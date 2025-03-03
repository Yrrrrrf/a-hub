-- First, create a type for room data
CREATE TYPE infrastruct.room_input AS (
    id UUID,
    room_type TEXT,
    name VARCHAR(32),
    capacity INT
);

-- Function to add building with rooms using the custom type
CREATE OR REPLACE FUNCTION infrastruct.add_building(
    p_faculty_id UUID,
    p_building_id UUID,
    p_building_name VARCHAR(255),
    p_address TEXT,
    p_total_floors INT,
    p_accessibility_features BOOLEAN,
    p_rooms infrastruct.room_input[]
) RETURNS VOID AS $$
DECLARE
    v_building_id UUID;
    v_room infrastruct.room_input;
    v_room_count INT := 0;
BEGIN
    -- Create or update the building
    INSERT INTO infrastruct.building(id, name, address, total_floors, accessibility_features)
    VALUES (p_building_id, p_building_name, p_address, p_total_floors, p_accessibility_features)
    ON CONFLICT (id) DO UPDATE 
    SET name = EXCLUDED.name,
        address = EXCLUDED.address,
        total_floors = EXCLUDED.total_floors,
        accessibility_features = EXCLUDED.accessibility_features
    RETURNING id INTO v_building_id;
    
    -- Associate building with faculty
    INSERT INTO infrastruct.faculty_building(faculty_id, building_id)
    VALUES (p_faculty_id, v_building_id)
    ON CONFLICT (faculty_id, building_id) DO NOTHING;
    
    RAISE NOTICE 'Added building "%" to faculty %', p_building_name, p_faculty_id;
    
    -- Process rooms if provided
    IF p_rooms IS NOT NULL THEN
        FOREACH v_room IN ARRAY p_rooms
        LOOP
            -- Insert room
            INSERT INTO infrastruct.room(
                id, building_id, room_type, name, capacity
            ) VALUES (
                v_room.id, 
                v_building_id, 
                v_room.room_type::infrastruct.room_type, 
                v_room.name, 
                v_room.capacity
            )
            ON CONFLICT (id) DO UPDATE 
            SET room_type = EXCLUDED.room_type,
                name = EXCLUDED.name,
                capacity = EXCLUDED.capacity;
                
            v_room_count := v_room_count + 1;
        END LOOP;
        
        RAISE NOTICE 'Added % rooms to building "%"', v_room_count, p_building_name;
    END IF;
END;
$$ LANGUAGE plpgsql;
