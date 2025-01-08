-- File: 06_student_functions.sql
-- Creates functions for the student management module.

-- Function to calculate GPA for a student
-- GPA: Grade Point Average (0.00 to 4.00 scale) - calculated based on final grades
-- todo: Add a new calculate_mean function to calculate the mean of the final grades
CREATE OR REPLACE FUNCTION student.calculate_gpa(student_id UUID)
RETURNS NUMERIC(3,2) AS $$
DECLARE
    total_grade_points NUMERIC(10,2) := 0;
    total_credits NUMERIC(5,2) := 0;
    gpa NUMERIC(3,2);
BEGIN
    SELECT
        SUM(g.grade * c.credits) / NULLIF(SUM(c.credits), 0),
        SUM(c.credits)
    INTO
        total_grade_points,
        total_credits
    FROM
        student.grade g
    JOIN student.enrollment e ON g.enrollment_id = e.id
    JOIN course_offer.course_offer co ON e.course_offer_id = co.id
    JOIN academic.course c ON co.course_id = c.id
    WHERE
        e.student_id = student_id
        AND g.exam_type = 'final';

    gpa := COALESCE(total_grade_points / NULLIF(total_credits, 0) / 25, 0);
    RETURN ROUND(gpa, 2);
END;
$$ LANGUAGE plpgsql;

COMMENT ON FUNCTION student.calculate_gpa IS 'Calculates the GPA for a given student based on final grades';

-- Function to enroll a student in a course
CREATE OR REPLACE FUNCTION student.enroll_student(
    p_student_id UUID,
    p_course_offer_id UUID
)
RETURNS UUID AS $$
DECLARE
    new_enrollment_id UUID;
BEGIN
    -- Check if the student is already enrolled
    IF EXISTS (
        SELECT 1 FROM student.enrollment
        WHERE student_id = p_student_id AND course_offer_id = p_course_offer_id
    ) THEN
        RAISE EXCEPTION 'Student is already enrolled in this course offering';
    END IF;

    -- Insert new enrollment
    INSERT INTO student.enrollment (student_id, course_offer_id)
    VALUES (p_student_id, p_course_offer_id)
    RETURNING id INTO new_enrollment_id;

    -- Update course offering enrollment count
    UPDATE course_offer.course_offer
    SET current_enrollment = current_enrollment + 1
    WHERE id = p_course_offer_id;

    RETURN new_enrollment_id;
END;
$$ LANGUAGE plpgsql;

COMMENT ON FUNCTION student.enroll_student IS 'Enrolls a student in a course offering and updates the enrollment count';

-- Function to get student's course history
CREATE OR REPLACE FUNCTION student.get_course_history(p_student_id UUID)
RETURNS TABLE (
    course_code VARCHAR(20),
    course_title VARCHAR(255),
    enrollment_status student.enrollment_status,
    final_grade NUMERIC(4,2),
    term_name VARCHAR(50)
) AS $$
BEGIN
    RETURN QUERY
    SELECT
        c.code,
        c.title,
        e.status,
        g.grade,
        at.name AS term_name
    FROM
        student.enrollment e
    JOIN course_offer.course_offer co ON e.course_offer_id = co.id
    JOIN academic.course c ON co.course_id = c.id
    JOIN course_offer.academic_term at ON co.term_id = at.id
    LEFT JOIN student.grade g ON e.id = g.enrollment_id AND g.exam_type = 'final'
    WHERE
        e.student_id = p_student_id
    ORDER BY
        at.start_date DESC, c.code;
END;
$$ LANGUAGE plpgsql;

COMMENT ON FUNCTION student.get_course_history IS 'Retrieves the course history for a given student';
