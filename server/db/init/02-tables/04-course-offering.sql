-- File: 04_course_offer_tables.sql
-- Creates tables for managing course offerings, schedules, and related operational aspects.

-- Enable psql command echoing and stop on error
\set ON_ERROR_STOP on
\set ECHO all

-- Create the course_offer schema
CREATE SCHEMA IF NOT EXISTS course_offer;

-- Academic Term: Defines academic terms (e.g., semesters, quarters)
CREATE TABLE course_offer.academic_term (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(50) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    is_current BOOLEAN DEFAULT false,
    CONSTRAINT valid_term_dates CHECK (start_date < end_date)
);

COMMENT ON COLUMN course_offer.academic_term.id IS 'Unique identifier for the academic term';
COMMENT ON COLUMN course_offer.academic_term.name IS 'Name of the academic term (e.g., Fall 2023)';
COMMENT ON COLUMN course_offer.academic_term.start_date IS 'Start date of the term';
COMMENT ON COLUMN course_offer.academic_term.end_date IS 'End date of the term';
COMMENT ON COLUMN course_offer.academic_term.is_current IS 'Indicates if this is the current academic term';

CREATE INDEX idx_academic_term_dates ON course_offer.academic_term(start_date, end_date);

-- Course Offering: Represents specific instances of courses offered in a given term
CREATE TABLE course_offer.course_offer (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    course_id UUID NOT NULL REFERENCES academic.course(id),
    term_id UUID NOT NULL REFERENCES course_offer.academic_term(id),
    section_number VARCHAR(10) NOT NULL,
    max_enrollment INT NOT NULL,
    current_enrollment INT DEFAULT 0,
    status VARCHAR(20) NOT NULL DEFAULT 'scheduled',
    CONSTRAINT unique_course_offer UNIQUE (course_id, term_id, section_number),
    CONSTRAINT valid_enrollment CHECK (current_enrollment <= max_enrollment)
);

COMMENT ON COLUMN course_offer.course_offer.id IS 'Unique identifier for the course offering';
COMMENT ON COLUMN course_offer.course_offer.course_id IS 'Reference to the course being offered';
COMMENT ON COLUMN course_offer.course_offer.term_id IS 'Academic term in which the course is offered';
COMMENT ON COLUMN course_offer.course_offer.section_number IS 'Section number for the course offering';
COMMENT ON COLUMN course_offer.course_offer.max_enrollment IS 'Maximum number of students that can enroll';
COMMENT ON COLUMN course_offer.course_offer.current_enrollment IS 'Current number of enrolled students';
COMMENT ON COLUMN course_offer.course_offer.status IS 'Current status of the course offering';

CREATE INDEX idx_course_offer_course ON course_offer.course_offer(course_id);
CREATE INDEX idx_course_offer_term ON course_offer.course_offer(term_id);

-- Course Schedule: Contains detailed scheduling information for course offerings
CREATE TABLE course_offer.course_schedule (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    course_offer_id UUID NOT NULL REFERENCES course_offer.course_offer(id),
    day_of_week INT NOT NULL CHECK (day_of_week BETWEEN 0 AND 6),
    start_time TIME NOT NULL,
    end_time TIME NOT NULL,
    location_id UUID REFERENCES infrastruct.room(id),
    CONSTRAINT valid_schedule_time CHECK (start_time < end_time)
);

COMMENT ON COLUMN course_offer.course_schedule.id IS 'Unique identifier for the schedule entry';
COMMENT ON COLUMN course_offer.course_schedule.course_offer_id IS 'Reference to the course offering';
COMMENT ON COLUMN course_offer.course_schedule.day_of_week IS 'Day of the week (0 = Sunday, 6 = Saturday)';
COMMENT ON COLUMN course_offer.course_schedule.start_time IS 'Start time of the class';
COMMENT ON COLUMN course_offer.course_schedule.end_time IS 'End time of the class';
COMMENT ON COLUMN course_offer.course_schedule.location_id IS 'Reference to the room where the class is held';

CREATE INDEX idx_course_schedule_offering ON course_offer.course_schedule(course_offer_id);
CREATE INDEX idx_course_schedule_day_time ON course_offer.course_schedule(day_of_week, start_time, end_time);

-- Instructor Assignment: Maps instructors to course offerings
CREATE TABLE course_offer.instructor_assignment (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    course_offer_id UUID NOT NULL REFERENCES course_offer.course_offer(id),
    instructor_id UUID NOT NULL REFERENCES hr.employee(id),
    is_primary BOOLEAN NOT NULL DEFAULT true,
    CONSTRAINT unique_instructor_assignment UNIQUE (course_offer_id, instructor_id)
);

COMMENT ON COLUMN course_offer.instructor_assignment.id IS 'Unique identifier for the instructor assignment';
COMMENT ON COLUMN course_offer.instructor_assignment.course_offer_id IS 'Reference to the course offering';
COMMENT ON COLUMN course_offer.instructor_assignment.instructor_id IS 'Reference to the assigned instructor';
COMMENT ON COLUMN course_offer.instructor_assignment.is_primary IS 'Indicates if this is the primary instructor for the course offering';

CREATE INDEX idx_instructor_assignment_offering ON course_offer.instructor_assignment(course_offer_id);
CREATE INDEX idx_instructor_assignment_instructor ON course_offer.instructor_assignment(instructor_id);
