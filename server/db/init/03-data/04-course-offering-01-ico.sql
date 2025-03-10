-- File: 04-course-offering-01-populate.sql
-- Improved population script with NULL handling

-- First clean all data from the tables
DELETE FROM course_offer.instructor_assignment;
DELETE FROM course_offer.course_schedule;
DELETE FROM course_offer.course_offer;
DELETE FROM course_offer.academic_term;


INSERT INTO course_offer.academic_term (id, name, start_date, end_date, is_current)
VALUES ('cdda4acf-e022-4479-b8a6-d0031d7f7c18', '2024A', '2024-01-15', '2024-05-15', FALSE);

INSERT INTO course_offer.academic_term (id, name, start_date, end_date, is_current)
VALUES ('68e7602d-ebf3-42e5-b9c5-bab2435284f9', '2024B', '2024-08-15', '2024-12-15', TRUE);

-- Create course offerings with better error handling
DO $$
DECLARE
    count INT := 0;
    academic_term_id UUID := '68e7602d-ebf3-42e5-b9c5-bab2435284f9';  -- 2024B
    -- academic_term_id UUID := 'cdda4acf-e022-4479-b8a6-d0031d7f7c18';  -- 2024A

BEGIN
    PERFORM course_offer.offer(
        -- *reg some data for the course offering table
        academic_term_id, -- term_id  --* ref some academic_term
        'c0404000-0000-4000-a000-000000000004', -- course_id (estructuras de datos)
        -- * then receive an array! to fill the course_schedule table!
        

        );

    RAISE NOTICE 'Successfully created {count} course offerings', count;
END $$;
