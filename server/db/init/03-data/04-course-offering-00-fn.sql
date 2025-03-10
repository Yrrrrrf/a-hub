-- File: 04-course-offering-00-fn.sql
-- Flexible functions for course offering management

-- Function to create a basic course offering (without schedules or instructors)
CREATE OR REPLACE FUNCTION course_offer.create_offering(
    p_course_id UUID,
    p_term_id UUID,
    p_section_number VARCHAR(10),
    p_max_enrollment INT DEFAULT 40
) RETURNS UUID AS $$
DECLARE
    v_offering_id UUID;
BEGIN
    INSERT INTO course_offer.course_offer (
        id,
        course_id,
        term_id,
        section_number,
        max_enrollment,
        current_enrollment,
        status
    ) VALUES (
        gen_random_uuid(),
        p_course_id,
        p_term_id,
        p_section_number,
        p_max_enrollment,
        0,
        'scheduled'
    ) RETURNING id INTO v_offering_id;

    RETURN v_offering_id;
END;
$$ LANGUAGE plpgsql;

-- Function to add a schedule to an existing course offering
CREATE OR REPLACE FUNCTION course_offer.add_schedule(
    p_course_offer_id UUID,
    p_day_of_week INT,
    p_start_time TIME,
    p_end_time TIME,
    p_room_id UUID DEFAULT NULL
) RETURNS UUID AS $$
DECLARE
    v_schedule_id UUID;
BEGIN
    INSERT INTO course_offer.course_schedule (
        course_offer_id,
        day_of_week,
        start_time,
        end_time,
        location_id
    ) VALUES (
        p_course_offer_id,
        p_day_of_week,
        p_start_time,
        p_end_time,
        p_room_id
    ) RETURNING id INTO v_schedule_id;

    RETURN v_schedule_id;
END;
$$ LANGUAGE plpgsql;

-- Fixed function to assign an instructor to a course offering
CREATE OR REPLACE FUNCTION course_offer.assign_instructor(
    p_course_offer_id UUID,
    p_instructor_id UUID,
    p_is_primary BOOLEAN DEFAULT TRUE
) RETURNS UUID AS $$
DECLARE
    v_assignment_id UUID;
BEGIN
    -- Check for NULL instructor ID
    IF p_instructor_id IS NULL THEN
        RAISE NOTICE 'Cannot assign NULL instructor to course offering';
        RETURN NULL;
    END IF;

    INSERT INTO course_offer.instructor_assignment (
        course_offer_id,
        instructor_id,
        is_primary
    ) VALUES (
        p_course_offer_id,
        p_instructor_id,
        p_is_primary
    ) RETURNING id INTO v_assignment_id;

    RETURN v_assignment_id;
END;
$$ LANGUAGE plpgsql;

-- Also fix the quick_offering function to handle NULL instructors
CREATE OR REPLACE FUNCTION course_offer.quick_offering(
    p_course_id UUID,
    p_term_id UUID,
    p_section_number VARCHAR(10),
    p_days INT[] DEFAULT ARRAY[1, 3],    -- Default: Monday, Wednesday
    p_start_time TIME DEFAULT '09:00:00',
    p_end_time TIME DEFAULT '11:00:00',
    p_room_id UUID DEFAULT NULL,
    p_instructor_id UUID DEFAULT NULL
) RETURNS UUID AS $$
DECLARE
    v_offering_id UUID;
    v_day INT;
BEGIN
    -- Create the basic offering
    v_offering_id := course_offer.create_offering(
        p_course_id,
        p_term_id,
        p_section_number
    );

    -- Add schedules for each day
    FOREACH v_day IN ARRAY p_days
    LOOP
        PERFORM course_offer.add_schedule(
            v_offering_id,
            v_day,
            p_start_time,
            p_end_time,
            p_room_id
        );
    END LOOP;

    -- Assign instructor if provided and not NULL
    IF p_instructor_id IS NOT NULL THEN
        PERFORM course_offer.assign_instructor(
            v_offering_id,
            p_instructor_id
        );
    END IF;

    RETURN v_offering_id;
END;
$$ LANGUAGE plpgsql;