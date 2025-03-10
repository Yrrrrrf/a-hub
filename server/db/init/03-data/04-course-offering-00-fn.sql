-- Define the schedule entry type
CREATE TYPE course_offer.schedule_entry AS (
    day_of_week INT,
    start_time TIME,
    end_time TIME,
    location_id UUID
);

-- Course offering function with array parameter
CREATE OR REPLACE FUNCTION course_offer.add_course_offer(
    p_term_id UUID,
    p_course_id UUID,
    p_schedule_entries course_offer.schedule_entry[]
)
RETURNS UUID AS $$
DECLARE
    v_course_offer_id UUID;
    v_schedule_entry course_offer.schedule_entry;
    v_course_code VARCHAR(50);
    v_room_name VARCHAR(50);
BEGIN
    -- Get course code for better error messages
    SELECT code INTO v_course_code
    FROM academic.course
    WHERE id = p_course_id;

    -- Create the course offering
    INSERT INTO course_offer.course_offer (
        term_id,
        course_id
    ) VALUES (
        p_term_id,
        p_course_id
    ) RETURNING id INTO v_course_offer_id;

    -- Add each schedule entry
    FOREACH v_schedule_entry IN ARRAY p_schedule_entries
    LOOP
        -- Get room name for logging
        IF v_schedule_entry.location_id IS NOT NULL THEN
            SELECT name INTO v_room_name
            FROM infrastruct.room
            WHERE id = v_schedule_entry.location_id;
        ELSE
            v_room_name := 'No room assigned';
        END IF;

        -- Insert schedule entry
        BEGIN
            INSERT INTO course_offer.course_schedule (
                course_offer_id,
                day_of_week,
                start_time,
                end_time,
                location_id,
                current_enrollment
            ) VALUES (
                v_course_offer_id,
                v_schedule_entry.day_of_week,
                v_schedule_entry.start_time,
                v_schedule_entry.end_time,
                v_schedule_entry.location_id,
                0  -- Initialize current_enrollment to 0
            );

            RAISE NOTICE 'Added schedule for % on day % from % to % in %',
                v_course_code,
                v_schedule_entry.day_of_week,
                v_schedule_entry.start_time,
                v_schedule_entry.end_time,
                v_room_name;

        EXCEPTION WHEN OTHERS THEN
            -- Provide better error messages
            RAISE NOTICE 'Failed to add schedule for % (%) on day % from % to % in %: %',
                v_course_code,
                p_course_id,
                v_schedule_entry.day_of_week,
                v_schedule_entry.start_time,
                v_schedule_entry.end_time,
                v_room_name,
                SQLERRM;

            -- Rollback the course offering insert if any schedule fails
            DELETE FROM course_offer.course_offer WHERE id = v_course_offer_id;

            -- Re-raise the exception
            RAISE;
        END;
    END LOOP;

    RAISE NOTICE 'Successfully created course offering for % with % schedule entries',
        v_course_code, array_length(p_schedule_entries, 1);

    RETURN v_course_offer_id;
END;
$$ LANGUAGE plpgsql;

-- Function to add instructor assignment
CREATE OR REPLACE FUNCTION course_offer.assign_instructor(
    p_course_offer_id UUID,
    p_instructor_id UUID,
    p_is_primary BOOLEAN DEFAULT TRUE
)
RETURNS UUID AS $$
DECLARE
    v_assignment_id UUID;
    v_course_code VARCHAR(50);
    v_instructor_name VARCHAR(100);
BEGIN
    -- Get course code and instructor name for better logging
    SELECT c.code INTO v_course_code
    FROM course_offer.course_offer co
    JOIN academic.course c ON co.course_id = c.id
    WHERE co.id = p_course_offer_id;

    SELECT first_name || ' ' || last_name INTO v_instructor_name
    FROM hr.employee
    WHERE id = p_instructor_id;

    -- Create the assignment
    INSERT INTO course_offer.instructor_assignment (
        course_offer_id,
        instructor_id,
        is_primary
    ) VALUES (
        p_course_offer_id,
        p_instructor_id,
        p_is_primary
    ) RETURNING id INTO v_assignment_id;

    RAISE NOTICE 'Assigned instructor % to course %',
        v_instructor_name, v_course_code;

    RETURN v_assignment_id;
END;
$$ LANGUAGE plpgsql;

-- Function to update enrollment in a course schedule
CREATE OR REPLACE FUNCTION course_offer.update_enrollment(
    p_course_schedule_id UUID,
    p_new_enrollment INT
)
RETURNS VOID AS $$
DECLARE
    v_room_capacity INT;
    v_location_id UUID;
    v_room_name VARCHAR(50);
BEGIN
    -- Get location and capacity
    SELECT cs.location_id, r.capacity, r.name INTO v_location_id, v_room_capacity, v_room_name
    FROM course_offer.course_schedule cs
    LEFT JOIN infrastruct.room r ON cs.location_id = r.id
    WHERE cs.id = p_course_schedule_id;

    -- Check capacity if a room is assigned
    IF v_location_id IS NOT NULL AND p_new_enrollment > v_room_capacity THEN
        RAISE EXCEPTION 'New enrollment (%) exceeds room capacity (%) for room %',
            p_new_enrollment, v_room_capacity, v_room_name;
    END IF;

    -- Update enrollment
    UPDATE course_offer.course_schedule
    SET current_enrollment = p_new_enrollment
    WHERE id = p_course_schedule_id;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Course schedule with ID % not found', p_course_schedule_id;
    END IF;

    RAISE NOTICE 'Updated enrollment for schedule % to %', p_course_schedule_id, p_new_enrollment;
END;
$$ LANGUAGE plpgsql;

-- Function to find available rooms for a given time slot
CREATE OR REPLACE FUNCTION course_offer.find_available_rooms(
    p_term_id UUID,
    p_day_of_week INT,
    p_start_time TIME,
    p_end_time TIME,
    p_room_type infrastruct.room_type DEFAULT NULL
)
RETURNS TABLE (
    room_id UUID,
    room_name VARCHAR(32),
    building_name VARCHAR(255),
    capacity INT
) AS $$
BEGIN
    RETURN QUERY
    SELECT
        r.id AS room_id,
        r.name AS room_name,
        b.name AS building_name,
        r.capacity
    FROM
        infrastruct.room r
    JOIN
        infrastruct.building b ON r.building_id = b.id
    WHERE
        (p_room_type IS NULL OR r.room_type = p_room_type)
    AND NOT EXISTS (
        SELECT 1
        FROM course_offer.course_schedule cs
        JOIN course_offer.course_offer co ON cs.course_offer_id = co.id
        WHERE
            cs.location_id = r.id
            AND co.term_id = p_term_id
            AND cs.day_of_week = p_day_of_week
            AND (
                (cs.start_time < p_end_time AND cs.end_time > p_start_time)
            )
    )
    ORDER BY
        b.name, r.name;
END;
$$ LANGUAGE plpgsql;
