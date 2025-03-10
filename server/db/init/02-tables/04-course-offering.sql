-- File: 04-course-offering-00-fn.sql
-- Creates utility functions for populating course offerings

-- Function to create a course offering and its schedule in one operation
CREATE OR REPLACE FUNCTION course_offer.add_course_offering(
    p_course_id UUID,                   -- Course to be offered
    p_term_id UUID,                     -- Academic term
    p_section_number VARCHAR(10),       -- Section identifier
    p_max_enrollment INT,               -- Maximum student capacity
    p_status VARCHAR(20) DEFAULT 'scheduled',  -- Course status
    p_instructor_id UUID DEFAULT NULL,  -- Primary instructor (optional)
    -- Schedule parameters (2 sessions per week)
    p_day_of_week_1 INT DEFAULT 1,      -- First session day (0=Sunday, 6=Saturday) - Monday default
    p_start_time_1 TIME DEFAULT '09:00:00',  -- First session start time - 9am default
    p_end_time_1 TIME DEFAULT '11:00:00',    -- First session end time - 11am default
    p_day_of_week_2 INT DEFAULT 3,      -- Second session day - Wednesday default
    p_start_time_2 TIME DEFAULT '09:00:00',  -- Second session start time - 9am default
    p_end_time_2 TIME DEFAULT '11:00:00',    -- Second session end time - 11am default
    p_location_id UUID DEFAULT NULL     -- Room for both sessions
) RETURNS UUID AS $$
DECLARE
    v_course_offering_id UUID;
BEGIN
    -- Insert the course offering
    INSERT INTO course_offer.course_offer(
        course_id,
        term_id,
        section_number,
        max_enrollment,
        current_enrollment,
        status
    )
    VALUES (
        p_course_id,
        p_term_id,
        p_section_number,
        p_max_enrollment,
        0,                               -- Start with 0 enrollment
        p_status
    )
    RETURNING id INTO v_course_offering_id;

    -- Schedule first session
    INSERT INTO course_offer.course_schedule(
        course_offer_id,
        day_of_week,
        start_time,
        end_time,
        location_id
    )
    VALUES (
        v_course_offering_id,
        p_day_of_week_1,
        p_start_time_1,
        p_end_time_1,
        p_location_id
    );

    -- Schedule second session
    INSERT INTO course_offer.course_schedule(
        course_offer_id,
        day_of_week,
        start_time,
        end_time,
        location_id
    )
    VALUES (
        v_course_offering_id,
        p_day_of_week_2,
        p_start_time_2,
        p_end_time_2,
        p_location_id
    );

    -- Assign instructor if provided
    IF p_instructor_id IS NOT NULL THEN
        INSERT INTO course_offer.instructor_assignment(
            course_offer_id,
            instructor_id,
            is_primary
        )
        VALUES (
            v_course_offering_id,
            p_instructor_id,
            TRUE
        );
    END IF;

    RETURN v_course_offering_id;
END;
$$ LANGUAGE plpgsql;

-- Function to add a set of course offerings for a given semester and program
CREATE OR REPLACE FUNCTION course_offer.add_program_semester_offerings(
    p_program_id UUID,              -- Academic program
    p_term_id UUID,                 -- Academic term
    p_semester INT,                 -- Semester number in the program
    p_default_max_enrollment INT DEFAULT 40,  -- Default class size
    p_faculty_id UUID DEFAULT NULL  -- Faculty for classroom allocation
) RETURNS INT AS $$
DECLARE
    course_rec RECORD;
    room_rec RECORD;
    instructor_rec RECORD;
    section_num VARCHAR(10);
    day_offset INT;
    hour_offset INT;
    counter INT := 0;
    rooms UUID[];
    current_room UUID;
    room_index INT := 1;

    -- Time slots (spread throughout the week)
    time_slots TIME[] := ARRAY['07:00:00'::TIME, '09:00:00'::TIME, '11:00:00'::TIME,
                               '13:00:00'::TIME, '15:00:00'::TIME, '17:00:00'::TIME];
BEGIN
    -- Get available classrooms if faculty provided
    IF p_faculty_id IS NOT NULL THEN
        SELECT ARRAY_AGG(r.id) INTO rooms
        FROM infrastruct.room r
        JOIN infrastruct.building b ON r.building_id = b.id
        JOIN infrastruct.faculty_building fb ON b.id = fb.building_id
        WHERE fb.faculty_id = p_faculty_id
        AND r.room_type IN ('classroom', 'computer_lab');
    END IF;

    -- Iterate through required courses for the program and semester
    FOR course_rec IN (
        SELECT c.id AS course_id, c.code AS course_code
        FROM academic.program_course pc
        JOIN academic.course c ON pc.course_id = c.id
        WHERE pc.program_id = p_program_id
          AND pc.recommended_semester = p_semester
          AND pc.is_required = TRUE
          AND c.is_active = TRUE
        ORDER BY c.code
    )
    LOOP
        -- Select a room (rotating through available rooms)
        IF rooms IS NOT NULL AND array_length(rooms, 1) > 0 THEN
            current_room := rooms[room_index];
            room_index := room_index + 1;
            IF room_index > array_length(rooms, 1) THEN
                room_index := 1;
            END IF;
        ELSE
            current_room := NULL;
        END IF;

        -- Create a section number based on course code
        section_num := SUBSTRING(course_rec.course_code FROM '[^-]+$') || '01';

        -- Calculate day offset for variety (Mon-Wed, Tue-Thu patterns)
        day_offset := (counter % 3) * 2; -- 0, 2, 4 (Mon, Wed, Fri)

        -- Calculate hour offset (different times during the day)
        hour_offset := counter % array_length(time_slots, 1);

        -- Find an appropriate instructor (someone from the related department)
        SELECT e.id INTO instructor_rec
        FROM hr.employee e
        WHERE e.job_category = 'faculty'
        AND e.is_active = TRUE
        LIMIT 1;

        -- Create the course offering with its schedule
        PERFORM course_offer.add_course_offering(
            course_rec.course_id,
            p_term_id,
            section_num,
            p_default_max_enrollment,
            'scheduled',
            instructor_rec.id,
            1 + day_offset,  -- Monday (1) + offset
            time_slots[hour_offset+1],
            time_slots[hour_offset+1] + INTERVAL '2 hours',
            3 + day_offset,  -- Wednesday (3) + offset
            time_slots[hour_offset+1],
            time_slots[hour_offset+1] + INTERVAL '2 hours',
            current_room
        );

        counter := counter + 1;
    END LOOP;

    RETURN counter;
END;
$$ LANGUAGE plpgsql;

-- Function to find an available classroom at a specific time
CREATE OR REPLACE FUNCTION course_offer.find_available_room(
    p_faculty_id UUID,
    p_day_of_week INT,
    p_start_time TIME,
    p_end_time TIME,
    p_term_id UUID,
    p_min_capacity INT DEFAULT 30,
    p_room_type infrastruct.room_type DEFAULT 'classroom'
) RETURNS UUID AS $$
DECLARE
    v_room_id UUID;
BEGIN
    -- Find a room that isn't scheduled during the requested time
    SELECT r.id INTO v_room_id
    FROM infrastruct.room r
    JOIN infrastruct.building b ON r.building_id = b.id
    JOIN infrastruct.faculty_building fb ON b.id = fb.building_id
    WHERE fb.faculty_id = p_faculty_id
      AND r.room_type = p_room_type
      AND r.capacity >= p_min_capacity
      AND NOT EXISTS (
          SELECT 1
          FROM course_offer.course_schedule cs
          JOIN course_offer.course_offer co ON cs.course_offer_id = co.id
          WHERE cs.location_id = r.id
            AND co.term_id = p_term_id
            AND cs.day_of_week = p_day_of_week
            AND (
                (cs.start_time <= p_start_time AND cs.end_time > p_start_time) OR
                (cs.start_time < p_end_time AND cs.end_time >= p_end_time) OR
                (cs.start_time >= p_start_time AND cs.end_time <= p_end_time)
            )
      )
    LIMIT 1;

    RETURN v_room_id;
END;
$$ LANGUAGE plpgsql;

-- Function to create a new academic term
CREATE OR REPLACE FUNCTION course_offer.create_academic_term(
    p_name VARCHAR(50),
    p_start_date DATE,
    p_end_date DATE,
    p_is_current BOOLEAN DEFAULT FALSE
) RETURNS UUID AS $$
DECLARE
    v_term_id UUID;
BEGIN
    -- If making this term current, first reset all others
    IF p_is_current THEN
        UPDATE course_offer.academic_term
        SET is_current = FALSE;
    END IF;

    -- Create the academic term
    INSERT INTO course_offer.academic_term(
        name,
        start_date,
        end_date,
        is_current
    )
    VALUES (
        p_name,
        p_start_date,
        p_end_date,
        p_is_current
    )
    RETURNING id INTO v_term_id;

    RETURN v_term_id;
END;
$$ LANGUAGE plpgsql;