-- File: 04-course-offering-01-populate.sql
-- Course offering population script with multiple schedule patterns

-- First clean all data from the tables
DELETE FROM course_offer.instructor_assignment;
DELETE FROM course_offer.course_schedule;
DELETE FROM course_offer.course_offer;
DELETE FROM course_offer.academic_term;

-- Create academic terms
INSERT INTO course_offer.academic_term (id, name, start_date, end_date, is_current)
VALUES ('cdda4acf-e022-4479-b8a6-d0031d7f7c18', '2024A', '2024-01-15', '2024-05-15', FALSE);

INSERT INTO course_offer.academic_term (id, name, start_date, end_date, is_current)
VALUES ('68e7602d-ebf3-42e5-b9c5-bab2435284f9', '2024B', '2024-08-15', '2024-12-15', TRUE);

-- Create course offerings with various schedule patterns
DO $$
DECLARE
    course_offer_id UUID;
    academic_term_id UUID := '68e7602d-ebf3-42e5-b9c5-bab2435284f9';  -- 2024B
    count INT := 0;
BEGIN
    -- 1. Calculus I (MWF Morning Pattern)
    course_offer_id := course_offer.add_course_offer(
        academic_term_id,
        'c0101000-0000-4000-a000-000000000101', -- Cálculo I
        ARRAY[
            -- Monday, Wednesday, Friday 9:00-10:00 in room A201
            ROW(1, '09:00', '10:00', 'a0201000-0000-4000-a010-000000000005')::course_offer.schedule_entry,
            ROW(3, '09:00', '10:00', 'a0201000-0000-4000-a010-000000000005')::course_offer.schedule_entry,
            ROW(5, '09:00', '10:00', 'a0201000-0000-4000-a010-000000000005')::course_offer.schedule_entry
        ]::course_offer.schedule_entry[]
    );
    PERFORM course_offer.assign_instructor(course_offer_id, 'e1000000-0000-4000-a000-000000000010');
    count := count + 1;
    
    -- 2. Data Structures (Tuesday-Thursday Pattern)
    course_offer_id := course_offer.add_course_offer(
        academic_term_id,
        'c0404000-0000-4000-a000-000000000004', -- Estructuras de datos
        ARRAY[
            -- Tuesday and Thursday 10:30-12:00 in room A202
            ROW(2, '10:30', '12:00', 'a0202000-0000-4000-a010-000000000006')::course_offer.schedule_entry,
            ROW(4, '10:30', '12:00', 'a0202000-0000-4000-a010-000000000006')::course_offer.schedule_entry
        ]::course_offer.schedule_entry[]
    );
    PERFORM course_offer.assign_instructor(course_offer_id, 'e2201000-0000-4000-a000-000000000025');
    count := count + 1;
    
    -- 3. Programming with Lab Component
    course_offer_id := course_offer.add_course_offer(
        academic_term_id,
        'c0306000-0000-4000-a000-000000000606', -- Programación
        ARRAY[
            -- Tuesday 13:00-14:30 (Lecture in classroom)
            ROW(2, '13:00', '14:30', 'a0203000-0000-4000-a010-000000000007')::course_offer.schedule_entry,
            -- Thursday 13:00-15:00 (Lab in computer lab)
            ROW(4, '13:00', '15:00', 'a0301000-0000-4000-a010-000000000011')::course_offer.schedule_entry
        ]::course_offer.schedule_entry[]
    );
    -- Multiple instructors (primary and assistant)
    PERFORM course_offer.assign_instructor(course_offer_id, 'e2200000-0000-4000-a000-000000000024', TRUE);  -- Primary
    PERFORM course_offer.assign_instructor(course_offer_id, 'e2202000-0000-4000-a000-000000000026', FALSE); -- Assistant
    count := count + 1;
    
    -- 4. Electrical Circuits with Laboratory
    course_offer_id := course_offer.add_course_offer(
        academic_term_id,
        'c0501000-0000-4000-a000-000000000001', -- Circuitos eléctricos y electrónicos
        ARRAY[
            -- Monday 14:00-15:30 (Lecture)
            ROW(1, '14:00', '15:30', 'a0204000-0000-4000-a010-000000000008')::course_offer.schedule_entry,
            -- Wednesday 14:00-16:00 (Lab - Electronics Lab)
            ROW(3, '14:00', '16:00', '90101000-0000-4000-a000-000000000001')::course_offer.schedule_entry
        ]::course_offer.schedule_entry[]
    );
    PERFORM course_offer.assign_instructor(course_offer_id, 'e1200000-0000-4000-a000-000000000012');
    count := count + 1;
    
    -- 5. Evening Software Engineering Class
    course_offer_id := course_offer.add_course_offer(
        academic_term_id,
        'c0504000-0000-4000-a000-000000000004', -- Ingeniería de software I
        ARRAY[
            -- Monday and Wednesday Evening 18:00-20:00
            ROW(1, '18:00', '20:00', 'a0205000-0000-4000-a010-000000000009')::course_offer.schedule_entry,
            ROW(3, '18:00', '20:00', 'a0205000-0000-4000-a010-000000000009')::course_offer.schedule_entry
        ]::course_offer.schedule_entry[]
    );
    PERFORM course_offer.assign_instructor(course_offer_id, 'e2201000-0000-4000-a000-000000000025');
    count := count + 1;
    
--     -- 6. Weekend Executive Engineering Economics
--     course_offer_id := course_offer.add_course_offer(
--         academic_term_id,
--         'c0612000-0000-4000-a000-000000000012', -- Ingeniería económica
--         ARRAY[
--             -- Friday evening
--             ROW(5, '17:00', '20:00', 'c0102000-0000-4000-a000-000000000001')::course_offer.schedule_entry,
--             -- Saturday morning
--             ROW(6, '09:00', '12:00', 'c0102000-0000-4000-a000-000000000001')::course_offer.schedule_entry
--         ]::course_offer.schedule_entry[]
--     );
--     PERFORM course_offer.assign_instructor(course_offer_id, 'e1100000-0000-4000-a000-000000000011');
--     count := count + 1;
    
    -- 7. Large Auditorium Philosophy Course
    course_offer_id := course_offer.add_course_offer(
        academic_term_id,
        'c0207000-0000-4000-a000-000000000007', -- Epistemología
        ARRAY[
            -- Single weekly session in large auditorium
            ROW(2, '11:00', '13:00', 'a0103000-0000-4000-a010-000000000004')::course_offer.schedule_entry
        ]::course_offer.schedule_entry[]
    );
    PERFORM course_offer.assign_instructor(course_offer_id, 'e2301000-0000-4000-a000-000000000028');
    count := count + 1;
    
    -- 8. Materials Mechanics with Theory, Problems and Lab
    course_offer_id := course_offer.add_course_offer(
        academic_term_id, 
        'c0308000-0000-4000-a000-000000000019', -- Mecánica de materiales
        ARRAY[
            -- Monday 08:00-10:00 (Theory lecture)
            ROW(1, '08:00', '10:00', 'c0301000-0000-4000-a000-000000000004')::course_offer.schedule_entry,
            -- Tuesday 10:00-12:00 (Problem session)
            ROW(2, '10:00', '12:00', 'c0302000-0000-4000-a000-000000000004')::course_offer.schedule_entry,
            -- Thursday 14:00-17:00 (Laboratory)
            ROW(4, '14:00', '17:00', 'd0301000-0000-4000-a000-000000000005')::course_offer.schedule_entry
        ]::course_offer.schedule_entry[]
    );
    PERFORM course_offer.assign_instructor(course_offer_id, 'e1400000-0000-4000-a000-000000000014');
    count := count + 1;
    
    -- 9. Back-to-back classes (no break between)
    course_offer_id := course_offer.add_course_offer(
        academic_term_id,
        'c0103000-0000-4000-a000-000000000003', -- Álgebra superior
        ARRAY[
            -- Monday 10:00-11:30
            ROW(1, '10:00', '11:30', 'a0206000-0000-4000-a010-000000000010')::course_offer.schedule_entry,
            -- Wednesday 10:00-11:30
            ROW(3, '10:00', '11:30', 'a0206000-0000-4000-a010-000000000010')::course_offer.schedule_entry
        ]::course_offer.schedule_entry[]
    );
    PERFORM course_offer.assign_instructor(course_offer_id, 'e1000000-0000-4000-a000-000000000010');
    count := count + 1;
    
    -- 10. Computer networks course with multiple labs
    course_offer_id := course_offer.add_course_offer(
        academic_term_id,
        'c0702000-0000-4000-a000-000000000002', -- Arquitectura de redes
        ARRAY[
            -- Monday lecture
            ROW(1, '15:30', '17:00', 'a0205000-0000-4000-a010-000000000009')::course_offer.schedule_entry,
            -- Wednesday lab for group A
            ROW(3, '15:30', '17:30', '70212000-0000-4000-a000-000000000012')::course_offer.schedule_entry,
            -- Friday lab for group B
            ROW(5, '15:30', '17:30', '70212000-0000-4000-a000-000000000012')::course_offer.schedule_entry
        ]::course_offer.schedule_entry[]
    );
    PERFORM course_offer.assign_instructor(course_offer_id, 'e2201000-0000-4000-a000-000000000025');
    count := count + 1;

    -- Also populate some courses for 2024A (past term)
    academic_term_id := 'cdda4acf-e022-4479-b8a6-d0031d7f7c18';  -- 2024A
    
    -- 11. Previous term calculus
    course_offer_id := course_offer.add_course_offer(
        academic_term_id,
        'c0101000-0000-4000-a000-000000000101', -- Cálculo I
        ARRAY[
            -- MWF pattern, different room
            ROW(1, '08:00', '09:30', 'c0401000-0000-4000-a000-000000000013')::course_offer.schedule_entry,
            ROW(3, '08:00', '09:30', 'c0401000-0000-4000-a000-000000000013')::course_offer.schedule_entry,
            ROW(5, '08:00', '09:30', 'c0401000-0000-4000-a000-000000000013')::course_offer.schedule_entry
        ]::course_offer.schedule_entry[]
    );
    PERFORM course_offer.assign_instructor(course_offer_id, 'e1000000-0000-4000-a000-000000000010');
    count := count + 1;
    
    -- 12. Previous term programming
    course_offer_id := course_offer.add_course_offer(
        academic_term_id,
        'c0306000-0000-4000-a000-000000000606', -- Programación
        ARRAY[
            -- TR pattern with lab
            ROW(2, '14:00', '15:30', 'c0402000-0000-4000-a000-000000000014')::course_offer.schedule_entry,
            ROW(4, '14:00', '16:00', 'a0304000-0000-4000-a010-000000000014')::course_offer.schedule_entry
        ]::course_offer.schedule_entry[]
    );
    PERFORM course_offer.assign_instructor(course_offer_id, 'e2202000-0000-4000-a000-000000000026');
    count := count + 1;

    RAISE NOTICE 'Successfully created % course offerings', count;
END $$;