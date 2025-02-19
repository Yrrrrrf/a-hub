-- File: 03_academic_tables.sql
-- Creates tables for the academic management module, including programs, courses, and syllabi.

-- Enable psql command echoing and stop on error
\set ON_ERROR_STOP on
\set ECHO all

-- Create the academic schema
CREATE SCHEMA IF NOT EXISTS academic;

-- Program: Defines academic programs offered by the institution
CREATE TABLE academic.program (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    code VARCHAR(20) NOT NULL UNIQUE,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    degree_level VARCHAR(50) NOT NULL,
    is_active BOOLEAN DEFAULT true
);

COMMENT ON COLUMN academic.program.id IS 'Unique identifier for the program';
COMMENT ON COLUMN academic.program.code IS 'Program code (e.g., ME, CS)';
COMMENT ON COLUMN academic.program.name IS 'Full name of the program';
COMMENT ON COLUMN academic.program.description IS 'Detailed description of the program';
COMMENT ON COLUMN academic.program.degree_level IS 'Level of the degree or type of program';
COMMENT ON COLUMN academic.program.is_active IS 'Indicates if the program is currently active';

CREATE INDEX idx_program_code ON academic.program(code);
CREATE INDEX idx_program_degree_level ON academic.program(degree_level);

-- Program Category: Defines the main categories of programs
CREATE TYPE academic.course_category AS ENUM (
    'basic',  -- any general education courses
    'core',  -- some specific courses required for the program
    'advanced'  -- specialized courses for the program
);

CREATE TABLE academic.course (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    code VARCHAR(20) NOT NULL UNIQUE,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    credits NUMERIC(2,0) NOT NULL,
    category academic.course_category,
    is_active BOOLEAN DEFAULT true
);

COMMENT ON COLUMN academic.course.id IS 'Unique identifier for the course';
COMMENT ON COLUMN academic.course.code IS 'Course code (e.g., CS101)';
COMMENT ON COLUMN academic.course.title IS 'Title of the course';
COMMENT ON COLUMN academic.course.description IS 'Detailed description of the course';
COMMENT ON COLUMN academic.course.credits IS 'Number of credits for the course';
COMMENT ON COLUMN academic.course.category IS 'Category of the course within the curriculum structure';
COMMENT ON COLUMN academic.course.is_active IS 'Indicates if the course is currently active';

CREATE INDEX idx_course_code ON academic.course(code);
CREATE INDEX idx_course_credits ON academic.course(credits);
CREATE INDEX idx_course_category ON academic.course(category);

-- Course Prerequisite: Defines prerequisites for courses
CREATE TABLE academic.course_prerequisite (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    course_id UUID NOT NULL REFERENCES academic.course(id),
    prerequisite_course_id UUID NOT NULL REFERENCES academic.course(id),
    CONSTRAINT unique_prerequisite UNIQUE (course_id, prerequisite_course_id)
);

COMMENT ON COLUMN academic.course_prerequisite.id IS 'Unique identifier for the prerequisite relationship';
COMMENT ON COLUMN academic.course_prerequisite.course_id IS 'Reference to the course that has the prerequisite';
COMMENT ON COLUMN academic.course_prerequisite.prerequisite_course_id IS 'Reference to the course that is a prerequisite';

CREATE INDEX idx_course_prerequisite_course ON academic.course_prerequisite(course_id);
CREATE INDEX idx_course_prerequisite_prereq ON academic.course_prerequisite(prerequisite_course_id);

-- Syllabus: Contains syllabus information for courses
CREATE TABLE academic.syllabus (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    course_id UUID NOT NULL REFERENCES academic.course(id),
    version VARCHAR(20) NOT NULL,
    content TEXT NOT NULL,
    approved_date DATE DEFAULT CURRENT_DATE,
    CONSTRAINT unique_syllabus_version UNIQUE (course_id, version)
);

COMMENT ON COLUMN academic.syllabus.id IS 'Unique identifier for the syllabus';
COMMENT ON COLUMN academic.syllabus.course_id IS 'Reference to the course this syllabus is for';
COMMENT ON COLUMN academic.syllabus.version IS 'Version of the syllabus';
COMMENT ON COLUMN academic.syllabus.content IS 'Full content of the syllabus';
COMMENT ON COLUMN academic.syllabus.approved_date IS 'Date when the syllabus was approved';

CREATE INDEX idx_syllabus_course ON academic.syllabus(course_id);
CREATE INDEX idx_syllabus_approved_date ON academic.syllabus(approved_date);

-- Program Course: Maps courses to programs
CREATE TABLE academic.program_course (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    program_id UUID NOT NULL REFERENCES academic.program(id),
    course_id UUID NOT NULL REFERENCES academic.course(id),
    is_required BOOLEAN NOT NULL DEFAULT true,
    recommended_semester INT,
    CONSTRAINT unique_program_course UNIQUE (program_id, course_id)
);

COMMENT ON COLUMN academic.program_course.id IS 'Unique identifier for the program-course relationship';
COMMENT ON COLUMN academic.program_course.program_id IS 'Reference to the academic program';
COMMENT ON COLUMN academic.program_course.course_id IS 'Reference to the course';
COMMENT ON COLUMN academic.program_course.is_required IS 'Indicates if the course is required for the program';
COMMENT ON COLUMN academic.program_course.recommended_semester IS 'Recommended semester to take the course in the program';

CREATE INDEX idx_program_course_program ON academic.program_course(program_id);
CREATE INDEX idx_program_course_course ON academic.program_course(course_id);

-- Course Topic: Maps courses to topics from the agnostic schema
CREATE TABLE academic.course_topic (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    course_id UUID NOT NULL REFERENCES academic.course(id),
    topic_id UUID NOT NULL REFERENCES agnostic.topic(id),
    relevance_level INT CHECK (relevance_level BETWEEN 1 AND 5),
    CONSTRAINT unique_course_topic UNIQUE (course_id, topic_id)
);

COMMENT ON COLUMN academic.course_topic.id IS 'Unique identifier for the course-topic relationship';
COMMENT ON COLUMN academic.course_topic.course_id IS 'Reference to the course';
COMMENT ON COLUMN academic.course_topic.topic_id IS 'Reference to the topic from the agnostic schema';
COMMENT ON COLUMN academic.course_topic.relevance_level IS 'Indicates the relevance of the topic to the course (1-5)';

CREATE INDEX idx_course_topic_course ON academic.course_topic(course_id);
CREATE INDEX idx_course_topic_topic ON academic.course_topic(topic_id);
