-- Function to get all facilities of a specific type for a faculty
CREATE OR REPLACE FUNCTION infrastruct.get_faculty_facilities(
    p_faculty_id UUID,
    p_facility_type infrastruct.facility_type
)
RETURNS TABLE (
    facility_id UUID,
    building_name VARCHAR(255),
    building_address TEXT
)
AS $$
BEGIN
    RETURN QUERY
    SELECT f.id, b.name, b.address
    FROM infrastruct.facility f
    JOIN infrastruct.building b ON f.building_id = b.id
    JOIN infrastruct.faculty_building fb ON b.id = fb.building_id
    WHERE fb.faculty_id = p_faculty_id AND f.facility_type = p_facility_type;
END;
$$ LANGUAGE plpgsql;

-- Function to get room count by type for a building
CREATE OR REPLACE FUNCTION infrastruct.get_room_count_by_type(p_building_id UUID)
RETURNS TABLE (
    room_type infrastruct.room_type,
    room_count BIGINT
)
AS $$
BEGIN
    RETURN QUERY
    SELECT r.room_type, COUNT(*) as room_count
    FROM infrastruct.room r
    WHERE r.building_id = p_building_id
    GROUP BY r.room_type;
END;
$$ LANGUAGE plpgsql;

-- Function to check if a faculty has a library
CREATE OR REPLACE FUNCTION infrastruct.has_library(p_faculty_id UUID)
RETURNS BOOLEAN AS $$
DECLARE
    library_exists BOOLEAN;
BEGIN
    SELECT EXISTS (
        SELECT 1
        FROM infrastruct.facility f
        JOIN infrastruct.faculty_building fb ON f.building_id = fb.building_id
        WHERE fb.faculty_id = p_faculty_id AND f.facility_type = 'library'
    ) INTO library_exists;
    RETURN library_exists;
END;
$$ LANGUAGE plpgsql;