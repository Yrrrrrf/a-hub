-- File: 04_course_offer_views.sql
-- Creates views for the course offering management module.

-- Current term courses
CREATE OR REPLACE VIEW course_offer.current_term_courses AS
SELECT
    co.id AS course_offer_id,
    c.code AS course_code,
    c.title AS course_title,
    co.section_number,
    co.max_enrollment,
    co.current_enrollment,
    co.status,
    at.name AS term_name
FROM
    course_offer.course_offer co
JOIN academic.course c ON co.course_id = c.id
JOIN course_offer.academic_term at ON co.term_id = at.id
WHERE
    at.is_current = true;

COMMENT ON VIEW course_offer.current_term_courses IS 'Shows all course offerings for the current academic term';

-- Course schedule with location
CREATE OR REPLACE VIEW course_offer.course_schedule_with_location AS
SELECT
    cs.id AS schedule_id,
    co.id AS course_offer_id,
    c.code AS course_code,
    c.title AS course_title,
    co.section_number,
    cs.day_of_week,
    cs.start_time,
    cs.end_time,
    r.name AS room_name,
    b.name AS building_name
FROM
    course_offer.course_schedule cs
JOIN course_offer.course_offer co ON cs.course_offer_id = co.id
JOIN academic.course c ON co.course_id = c.id
LEFT JOIN infrastruct.room r ON cs.location_id = r.id
LEFT JOIN infrastruct.building b ON r.building_id = b.id;

COMMENT ON VIEW course_offer.course_schedule_with_location IS 'Displays course schedules with detailed location information';

-- Instructor course assignments
CREATE OR REPLACE VIEW course_offer.instructor_course_assignments AS
SELECT
    ia.id AS assignment_id,
    e.id AS instructor_id,
    e.first_name || ' ' || e.last_name AS instructor_name,
    c.code AS course_code,
    c.title AS course_title,
    co.section_number,
    at.name AS term_name,
    ia.is_primary
FROM
    course_offer.instructor_assignment ia
JOIN hr.employee e ON ia.instructor_id = e.id
JOIN course_offer.course_offer co ON ia.course_offer_id = co.id
JOIN academic.course c ON co.course_id = c.id
JOIN course_offer.academic_term at ON co.term_id = at.id;

COMMENT ON VIEW course_offer.instructor_course_assignments IS 'Shows all course assignments for instructors';