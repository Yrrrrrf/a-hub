-- File: 04_course_offer_functions.sql
-- Creates functions for the course offering management module.

-- Function to get available seats for a course offering
CREATE OR REPLACE FUNCTION course_offer.get_available_seats(course_offer_id UUID)
RETURNS INTEGER AS $$
DECLARE
    available_seats INTEGER;
BEGIN
    SELECT (max_enrollment - current_enrollment)
    INTO available_seats
    FROM course_offer.course_offer
    WHERE id = course_offer_id;

    RETURN COALESCE(available_seats, 0);
END;
$$ LANGUAGE plpgsql;

COMMENT ON FUNCTION course_offer.get_available_seats IS 'Calculates the number of available seats for a given course offering';

-- todo: Test this fn
-- -- Function to check for schedule conflicts
-- CREATE OR REPLACE FUNCTION course_offer.check_schedule_conflict(
--     p_instructor_id UUID,
--     p_day_of_week INT,
--     p_start_time TIME,
--     p_end_time TIME,
--     p_term_id UUID
-- )
-- RETURNS BOOLEAN AS $$
-- DECLARE
--     conflict_exists BOOLEAN;
-- BEGIN
--     SELECT EXISTS (
--         SELECT 1
--         FROM course_offer.instructor_assignment ia
--         JOIN course_offer.course_offer co ON ia.course_offer_id = co.id
--         JOIN course_offer.course_schedule cs ON co.id = cs.course_offer_id
--         WHERE
--             ia.instructor_id = p_instructor_id
--             AND co.term_id = p_term_id
--             AND cs.day_of_week = p_day_of_week
--             AND (
--                 (cs.start_time < p_end_time AND cs.end_time > p_start_time)
--                 OR (p_start_time < cs.end_time AND p_end_time > cs.start_time)
--             )
--     ) INTO conflict_exists;
--
--     RETURN conflict_exists;
-- END;
-- $$ LANGUAGE plpgsql;
--
-- COMMENT ON FUNCTION course_offer.check_schedule_conflict IS 'Checks if there is a scheduling conflict for an instructor in a given time slot';
--
-- -- Function to update course offering enrollment
-- CREATE OR REPLACE FUNCTION course_offer.update_enrollment(
--     p_course_offer_id UUID,
--     p_enrollment_change INT
-- )
-- RETURNS VOID AS $$
-- BEGIN
--     UPDATE course_offer.course_offer
--     SET current_enrollment = current_enrollment + p_enrollment_change
--     WHERE id = p_course_offer_id;
--
--     IF NOT FOUND THEN
--         RAISE EXCEPTION 'Course offering with ID % not found', p_course_offer_id;
--     END IF;
--
--     -- Check if the new enrollment is valid
--     IF (SELECT current_enrollment > max_enrollment FROM course_offer.course_offer WHERE id = p_course_offer_id) THEN
--         RAISE EXCEPTION 'Enrollment cannot exceed maximum capacity';
--     END IF;
-- END;
-- $$ LANGUAGE plpgsql;
--
-- COMMENT ON FUNCTION course_offer.update_enrollment IS 'Updates the enrollment count for a course offering, ensuring it doesn''t exceed capacity';
