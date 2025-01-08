-- File: 01_infrastruct_tables.sql

-- Enable psql command echoing and stop on error
\set ON_ERROR_STOP on
\set ECHO all

-- Create ENUM types for room and facility types
CREATE TYPE infrastruct.room_type AS ENUM (
    'classroom',
    'laboratory',
    'office',
    'conference_room',
    'auditorium',
    'study_room',
    'computer_lab',
    'workshop',
    'storage',
    'cafeteria',
    'infirmary'
);

CREATE TYPE infrastruct.facility_type AS ENUM (
    'library',
    'research_center',
    'administrative_office',
    'sports_facility',
    'dining_hall',
    'health_center',
    'gymnasium',
    'auditorium'
);

-- Building table
DROP TABLE IF EXISTS infrastruct.building CASCADE;
CREATE TABLE infrastruct.building (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(255) NOT NULL,
    address TEXT,
    total_floors INT,
    accessibility_features BOOLEAN DEFAULT false
);

COMMENT ON COLUMN infrastruct.building.id IS 'Unique identifier for the building';
COMMENT ON COLUMN infrastruct.building.name IS 'Official name of the building';
COMMENT ON COLUMN infrastruct.building.address IS 'Full postal address of the building';
COMMENT ON COLUMN infrastruct.building.total_floors IS 'Total number of floors in the building, including any basement levels';
COMMENT ON COLUMN infrastruct.building.accessibility_features IS 'Indicates if the building is equipped with accessibility features';

ALTER TABLE infrastruct.building
ADD CONSTRAINT check_positive_floors CHECK (total_floors > 0);

CREATE INDEX idx_building_name ON infrastruct.building(name);

-- Room table
DROP TABLE IF EXISTS infrastruct.room CASCADE;
CREATE TABLE infrastruct.room (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    room_type infrastruct.room_type NOT NULL,
    name VARCHAR(32),
    building_id UUID NOT NULL REFERENCES infrastruct.building(id),
    capacity INT
);

COMMENT ON COLUMN infrastruct.room.id IS 'Unique identifier for the room';
COMMENT ON COLUMN infrastruct.room.room_type IS 'Type of room (e.g., classroom, laboratory)';
COMMENT ON COLUMN infrastruct.room.name IS 'Room number or name';
COMMENT ON COLUMN infrastruct.room.building_id IS 'Reference to the building containing this room';
COMMENT ON COLUMN infrastruct.room.capacity IS 'Maximum occupancy of the room';

ALTER TABLE infrastruct.room
ADD CONSTRAINT check_positive_capacity CHECK (capacity > 0);

CREATE INDEX idx_room_building ON infrastruct.room(building_id);
CREATE INDEX idx_room_type ON infrastruct.room(room_type);

-- Faculty table
DROP TABLE IF EXISTS infrastruct.faculty CASCADE;
CREATE TABLE infrastruct.faculty (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(255) NOT NULL UNIQUE
);

COMMENT ON COLUMN infrastruct.faculty.id IS 'Unique identifier for the faculty';
COMMENT ON COLUMN infrastruct.faculty.name IS 'Official name of the faculty or department';

-- Faculty Building table
DROP TABLE IF EXISTS infrastruct.faculty_building CASCADE;
CREATE TABLE infrastruct.faculty_building (
    faculty_id UUID NOT NULL REFERENCES infrastruct.faculty(id),
    building_id UUID NOT NULL REFERENCES infrastruct.building(id),
    PRIMARY KEY (faculty_id, building_id)
);

COMMENT ON COLUMN infrastruct.faculty_building.faculty_id IS 'Reference to the faculty';
COMMENT ON COLUMN infrastruct.faculty_building.building_id IS 'Reference to the building';

CREATE INDEX idx_faculty_building_faculty ON infrastruct.faculty_building(faculty_id);
CREATE INDEX idx_faculty_building_building ON infrastruct.faculty_building(building_id);

-- Facility table
DROP TABLE IF EXISTS infrastruct.facility CASCADE;
CREATE TABLE infrastruct.facility (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    facility_type infrastruct.facility_type NOT NULL,
    building_id UUID NOT NULL REFERENCES infrastruct.building(id),
    CONSTRAINT unique_facility_per_building UNIQUE (facility_type, building_id)
);

COMMENT ON COLUMN infrastruct.facility.id IS 'Unique identifier for the facility';
COMMENT ON COLUMN infrastruct.facility.facility_type IS 'Type of facility';
COMMENT ON COLUMN infrastruct.facility.building_id IS 'Reference to the building containing this facility';


-- * CONSTRAINS...

-- Create a function to be used by the trigger
CREATE OR REPLACE FUNCTION infrastruct.check_one_library_per_faculty()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.facility_type = 'library' THEN
        IF EXISTS (
            SELECT 1
            FROM infrastruct.facility f
            JOIN infrastruct.faculty_building fb ON f.building_id = fb.building_id
            WHERE f.facility_type = 'library'
              AND fb.faculty_id = (
                  SELECT faculty_id
                  FROM infrastruct.faculty_building
                  WHERE building_id = NEW.building_id
              )
              AND f.id != NEW.id
        ) THEN
            RAISE EXCEPTION 'Only one library is allowed per faculty';
        END IF;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create the trigger
CREATE TRIGGER enforce_one_library_per_faculty
BEFORE INSERT OR UPDATE ON infrastruct.facility
FOR EACH ROW EXECUTE FUNCTION infrastruct.check_one_library_per_faculty();
