-- File: 04-course-offering-01-populate.sql
-- Improved population script with NULL handling

-- First clean all data from the tables
DELETE FROM course_offer.instructor_assignment;
DELETE FROM course_offer.course_schedule;
DELETE FROM course_offer.course_offer;
DELETE FROM course_offer.academic_term;

-- Create the three terms individually
INSERT INTO course_offer.academic_term (id, name, start_date, end_date, is_current)
VALUES (gen_random_uuid(), 'Fall 2023', '2023-08-15', '2023-12-15', FALSE);

INSERT INTO course_offer.academic_term (id, name, start_date, end_date, is_current)
VALUES (gen_random_uuid(), 'Spring 2024', '2024-01-15', '2024-05-15', FALSE);

INSERT INTO course_offer.academic_term (id, name, start_date, end_date, is_current)
VALUES (gen_random_uuid(), 'Fall 2024', '2024-08-15', '2024-12-15', TRUE);

-- Create course offerings with better error handling
DO $$
DECLARE
    v_fall_2024_id UUID;
    v_course_id UUID;
    v_instructor_id UUID;
    v_room_id UUID;
    v_offering_id UUID;
    v_classroom_ids UUID[] := ARRAY[]::UUID[];
    v_total_courses INT := 0;
BEGIN
    -- Get the Fall 2024 term ID
    SELECT id INTO v_fall_2024_id
    FROM course_offer.academic_term
    WHERE name = 'Fall 2024'
    LIMIT 1;

    -- Get an instructor (with better error handling)
    BEGIN
        SELECT id INTO v_instructor_id
        FROM hr.employee
        WHERE job_category = 'faculty'
        LIMIT 1;
    EXCEPTION WHEN OTHERS THEN
        RAISE NOTICE 'Could not find a faculty instructor: %', SQLERRM;
        v_instructor_id := NULL;
    END;

    -- Find available classrooms (handle empty results)
    BEGIN
        SELECT ARRAY_AGG(id) INTO v_classroom_ids
        FROM infrastruct.room
        WHERE room_type = 'classroom'
        LIMIT 5;

        -- Handle NULL result
        IF v_classroom_ids IS NULL THEN
            v_classroom_ids := ARRAY[]::UUID[];
            RAISE NOTICE 'No classrooms found, using NULL for room IDs';
        END IF;
    EXCEPTION WHEN OTHERS THEN
        RAISE NOTICE 'Error finding classrooms: %', SQLERRM;
        v_classroom_ids := ARRAY[]::UUID[];
    END;

    -- Get a room ID safely
    IF array_length(v_classroom_ids, 1) > 0 THEN
        v_room_id := v_classroom_ids[1];
    ELSE
        v_room_id := NULL;
    END IF;

    -- METHOD 1: Quick offerings (for standard 2-day courses)
    FOR i IN 1..3 LOOP
        -- Get a course
        BEGIN
            SELECT id INTO v_course_id
            FROM academic.course
            LIMIT 1 OFFSET (i-1);
        EXCEPTION WHEN OTHERS THEN
            RAISE NOTICE 'Error getting course %: %', i, SQLERRM;
            CONTINUE;
        END;

        -- Skip if no course found
        CONTINUE WHEN v_course_id IS NULL;

        -- Create with the quick function (two sessions per week)
        PERFORM course_offer.quick_offering(
            v_course_id,
            v_fall_2024_id,
            'QK-' || i,
            ARRAY[1, 3],  -- Monday/Wednesday
            '09:00:00'::TIME,
            '11:00:00'::TIME,
            v_room_id,
            v_instructor_id
        );

        v_total_courses := v_total_courses + 1;
    END LOOP;

    -- METHOD 2: Custom course offerings (with variable schedules)
    FOR i IN 1..2 LOOP
        -- Get another course
        BEGIN
            SELECT id INTO v_course_id
            FROM academic.course
            LIMIT 1 OFFSET (i+3);
        EXCEPTION WHEN OTHERS THEN
            RAISE NOTICE 'Error getting course %: %', i+3, SQLERRM;
            CONTINUE;
        END;

        -- Skip if no course found
        CONTINUE WHEN v_course_id IS NULL;

        -- Step 1: Create the basic offering
        v_offering_id := course_offer.create_offering(
            v_course_id,
            v_fall_2024_id,
            'CM-' || i,
            30  -- Custom enrollment limit
        );

        -- Step 2: Add flexible schedule (can add any number of sessions)
        CASE i
            WHEN 1 THEN
                -- Course with 3 sessions per week (MWF)
                PERFORM course_offer.add_schedule(v_offering_id, 1, '14:00:00', '15:30:00', v_room_id);
                PERFORM course_offer.add_schedule(v_offering_id, 3, '14:00:00', '15:30:00', v_room_id);
                PERFORM course_offer.add_schedule(v_offering_id, 5, '14:00:00', '15:30:00', v_room_id);
            WHEN 2 THEN
                -- Course with 1 long session per week (F)
                PERFORM course_offer.add_schedule(v_offering_id, 5, '09:00:00', '13:00:00', v_room_id);
            ELSE
                -- Standard 2 sessions per week (Tu/Th)
                PERFORM course_offer.add_schedule(v_offering_id, 2, '11:00:00', '13:00:00', v_room_id);
                PERFORM course_offer.add_schedule(v_offering_id, 4, '11:00:00', '13:00:00', v_room_id);
        END CASE;

        -- Step 3: Assign instructor if we have one
        IF v_instructor_id IS NOT NULL THEN
            PERFORM course_offer.assign_instructor(v_offering_id, v_instructor_id);
        END IF;

        v_total_courses := v_total_courses + 1;
    END LOOP;

    RAISE NOTICE 'Successfully created % course offerings', v_total_courses;
END $$;