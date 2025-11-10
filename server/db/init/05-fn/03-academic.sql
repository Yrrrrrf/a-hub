-- File: 03_academic_functions.sql
-- Creates functions for the academic management module.

-- Function to get all courses in a program
CREATE OR REPLACE FUNCTION academic.get_program_courses(program_id UUID)
RETURNS TABLE (
    course_id UUID,
    course_code VARCHAR(20),
    course_title VARCHAR(255),
    credits NUMERIC(2,0),
    is_required BOOLEAN,
    recommended_semester INT
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        c.id, c.code, c.title, c.credits, pc.is_required, pc.recommended_semester
    FROM 
        academic.program_course pc
    JOIN academic.course c ON pc.course_id = c.id
    WHERE 
        pc.program_id = $1 AND c.is_active = true
    ORDER BY 
        pc.recommended_semester, c.code;
END;
$$ LANGUAGE plpgsql;

COMMENT ON FUNCTION academic.get_program_courses IS 'Returns all active courses for a given program';

-- Function to check if a course has prerequisites
CREATE OR REPLACE FUNCTION academic.has_prerequisites(course_id UUID)
RETURNS BOOLEAN AS $$
DECLARE
    prereq_count INT;
BEGIN
    SELECT COUNT(*) INTO prereq_count
    FROM academic.course_prerequisite
    WHERE course_id = $1;
    
    RETURN prereq_count > 0;
END;
$$ LANGUAGE plpgsql;

COMMENT ON FUNCTION academic.has_prerequisites IS 'Checks if a given course has any prerequisites';

-- Function to calculate total credits for a program
CREATE OR REPLACE FUNCTION academic.calculate_program_credits(program_id UUID)
RETURNS NUMERIC AS $$
DECLARE
    total_credits NUMERIC;
BEGIN
    SELECT COALESCE(SUM(c.credits), 0)
    INTO total_credits
    FROM academic.program_course pc
    JOIN academic.course c ON pc.course_id = c.id
    WHERE pc.program_id = $1 AND pc.is_required = true;
    
    RETURN total_credits;
END;
$$ LANGUAGE plpgsql;

COMMENT ON FUNCTION academic.calculate_program_credits IS 'Calculates the total credits for required courses in a program';
