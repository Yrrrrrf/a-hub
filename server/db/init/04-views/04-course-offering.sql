-- File: 04_course_offer_views.sql
-- Creates views for the course offering management module.

-- Current term courses
CREATE OR REPLACE VIEW course_offer.current_term_courses AS
SELECT
    co.id AS course_offer_id,
    c.code AS course_code,
    c.title AS course_title,
    -- co.section_number, -- Removed: Column does not exist in course_offer.course_offer
    -- co.max_enrollment, -- Removed: Column does not exist in course_offer.course_offer
    -- co.current_enrollment, -- Removed: This column is in course_schedule, not course_offer. Aggregating it here would change the view's grain.
    -- co.status, -- Removed: Column does not exist in course_offer.course_offer
    at.name AS term_name
FROM
    course_offer.course_offer co
JOIN academic.course c ON co.course_id = c.id
JOIN course_offer.academic_term at ON co.term_id = at.id
WHERE
    at.is_current = true;

COMMENT ON VIEW course_offer.current_term_courses IS 'Shows all course offerings for the current academic term. Note: section_number, max_enrollment, status, and current_enrollment were removed as they are not in the base course_offer.course_offer table.';

-- Course schedule with location
CREATE OR REPLACE VIEW course_offer.course_schedule_with_location AS
SELECT
    cs.id AS schedule_id,
    co.id AS course_offer_id,
    c.code AS course_code,
    c.title AS course_title,
    cs.day_of_week,
    cs.start_time,
    cs.end_time,
    r.name AS room_name,
    b.name AS building_name,
    cs.current_enrollment -- This column IS in course_schedule
FROM
    course_offer.course_schedule cs
JOIN course_offer.course_offer co ON cs.course_offer_id = co.id
JOIN academic.course c ON co.course_id = c.id
LEFT JOIN infrastruct.room r ON cs.location_id = r.id
LEFT JOIN infrastruct.building b ON r.building_id = b.id;

COMMENT ON VIEW course_offer.course_schedule_with_location IS 'Displays course schedules with detailed location information. Note: section_number was removed as it is not in the base course_offer.course_offer table.';

-- Instructor course assignments
CREATE OR REPLACE VIEW course_offer.instructor_course_assignments AS
SELECT
    ia.id AS assignment_id,
    e.id AS instructor_id,
    e.first_name || ' ' || e.last_name AS instructor_name,
    c.code AS course_code,
    c.title AS course_title,
    at.name AS term_name,
    ia.is_primary
FROM
    course_offer.instructor_assignment ia
JOIN hr.employee e ON ia.instructor_id = e.id
JOIN course_offer.course_offer co ON ia.course_offer_id = co.id
JOIN academic.course c ON co.course_id = c.id
JOIN course_offer.academic_term at ON co.term_id = at.id;

COMMENT ON VIEW course_offer.instructor_course_assignments IS 'Shows all course assignments for instructors. Note: section_number was removed as it is not in the base course_offer.course_offer table.';
