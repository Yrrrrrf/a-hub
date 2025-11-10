-- 01-infrastructure-02-architecture.sql
DO $$
DECLARE
    v_faculty_id UUID := 'f1000000-0000-4000-a000-000000000002'; -- Architecture Faculty
BEGIN
    -- First ensure the faculty exists
    INSERT INTO infrastruct.faculty(id, name)
    VALUES (v_faculty_id, 'Architecture Faculty')
    ON CONFLICT (id) DO UPDATE SET name = 'Architecture Faculty';
    
    -- Building A - Main Architecture Building (primarily studios and classrooms)
    PERFORM infrastruct.add_building(
        v_faculty_id,
        'a0100000-0000-4000-a000-000000000001'::UUID,
        'Architecture Building A',
        '200 Design Avenue, Campus East',
        4,  -- 4 floors
        true, -- has accessibility features
        ARRAY[
            -- First floor - Design studios
            ROW('a1101000-0000-4000-a000-000000000001'::UUID, 'classroom', 'A101', 40)::infrastruct.room_input,
            ROW('a1102000-0000-4000-a000-000000000002'::UUID, 'classroom', 'A102', 40)::infrastruct.room_input,
            ROW('a1103000-0000-4000-a000-000000000003'::UUID, 'classroom', 'A103', 35)::infrastruct.room_input,
            ROW('a1104000-0000-4000-a000-000000000004'::UUID, 'classroom', 'A104', 35)::infrastruct.room_input,
            
            -- Second floor - Computer labs and lecture rooms
            ROW('a1201000-0000-4000-a000-000000000005'::UUID, 'computer_lab', 'A201', 30)::infrastruct.room_input,
            ROW('a1202000-0000-4000-a000-000000000006'::UUID, 'computer_lab', 'A202', 30)::infrastruct.room_input,
            ROW('a1203000-0000-4000-a000-000000000007'::UUID, 'classroom', 'A203', 60)::infrastruct.room_input,
            ROW('a1204000-0000-4000-a000-000000000008'::UUID, 'classroom', 'A204', 60)::infrastruct.room_input,
            
            -- Third floor - Advanced design studios
            ROW('a1301000-0000-4000-a000-000000000009'::UUID, 'classroom', 'A301', 25)::infrastruct.room_input,
            ROW('a1302000-0000-4000-a000-000000000010'::UUID, 'classroom', 'A302', 25)::infrastruct.room_input,
            ROW('a1303000-0000-4000-a000-000000000011'::UUID, 'classroom', 'A303', 25)::infrastruct.room_input,
            ROW('a1304000-0000-4000-a000-000000000012'::UUID, 'classroom', 'A304', 25)::infrastruct.room_input,
            
            -- Fourth floor - Faculty offices and meeting rooms
            ROW('a1401000-0000-4000-a000-000000000013'::UUID, 'office', 'A401', 3)::infrastruct.room_input,
            ROW('a1402000-0000-4000-a000-000000000014'::UUID, 'office', 'A402', 3)::infrastruct.room_input,
            ROW('a1403000-0000-4000-a000-000000000015'::UUID, 'office', 'A403', 3)::infrastruct.room_input,
            ROW('a1404000-0000-4000-a000-000000000016'::UUID, 'office', 'A404', 3)::infrastruct.room_input,
            ROW('a1405000-0000-4000-a000-000000000017'::UUID, 'conference_room', 'A405', 15)::infrastruct.room_input
        ]
    );
    
    -- Building B - Workshop Building
    PERFORM infrastruct.add_building(
        v_faculty_id,
        'a0200000-0000-4000-a000-000000000002'::UUID,
        'Architecture Building B',
        '202 Design Avenue, Campus East',
        2,  -- 2 floors
        true,
        ARRAY[
            -- First floor - Workshops
            ROW('a2101000-0000-4000-a000-000000000018'::UUID, 'workshop', 'B101', 25)::infrastruct.room_input, -- Wood workshop
            ROW('a2102000-0000-4000-a000-000000000019'::UUID, 'workshop', 'B102', 25)::infrastruct.room_input, -- Metal workshop
            ROW('a2103000-0000-4000-a000-000000000020'::UUID, 'workshop', 'B103', 25)::infrastruct.room_input, -- Digital fabrication
            ROW('a2104000-0000-4000-a000-000000000021'::UUID, 'storage', 'B104', 0)::infrastruct.room_input,   -- Materials storage
            
            -- Second floor - More specialized workshops
            ROW('a2201000-0000-4000-a000-000000000022'::UUID, 'workshop', 'B201', 20)::infrastruct.room_input, -- 3D printing lab
            ROW('a2202000-0000-4000-a000-000000000023'::UUID, 'workshop', 'B202', 20)::infrastruct.room_input, -- Model making
            ROW('a2203000-0000-4000-a000-000000000024'::UUID, 'workshop', 'B203', 15)::infrastruct.room_input, -- Photography studio
            ROW('a2204000-0000-4000-a000-000000000025'::UUID, 'office', 'B204', 2)::infrastruct.room_input     -- Workshop supervisor office
        ]
    );
    
    -- Building C - Exhibition & Review Building
    PERFORM infrastruct.add_building(
        v_faculty_id,
        'a0300000-0000-4000-a000-000000000003'::UUID,
        'Architecture Building C',
        '204 Design Avenue, Campus East',
        3,
        true,
        ARRAY[
            -- First floor - Main exhibition hall and gallery spaces
            ROW('a3101000-0000-4000-a000-000000000026'::UUID, 'auditorium', 'C101', 150)::infrastruct.room_input, -- Main exhibition hall
            ROW('a3102000-0000-4000-a000-000000000027'::UUID, 'conference_room', 'C102', 30)::infrastruct.room_input, -- Gallery space
            ROW('a3103000-0000-4000-a000-000000000028'::UUID, 'conference_room', 'C103', 30)::infrastruct.room_input, -- Gallery space
            
            -- Second floor - Review spaces and critique rooms
            ROW('a3201000-0000-4000-a000-000000000029'::UUID, 'conference_room', 'C201', 20)::infrastruct.room_input, -- Review room
            ROW('a3202000-0000-4000-a000-000000000030'::UUID, 'conference_room', 'C202', 20)::infrastruct.room_input, -- Review room
            ROW('a3203000-0000-4000-a000-000000000031'::UUID, 'conference_room', 'C203', 20)::infrastruct.room_input, -- Review room
            ROW('a3204000-0000-4000-a000-000000000032'::UUID, 'conference_room', 'C204', 20)::infrastruct.room_input, -- Review room
            
            -- Third floor - Student lounge and study spaces
            ROW('a3301000-0000-4000-a000-000000000033'::UUID, 'study_room', 'C301', 40)::infrastruct.room_input, -- Student lounge
            ROW('a3302000-0000-4000-a000-000000000034'::UUID, 'study_room', 'C302', 15)::infrastruct.room_input, -- Study space
            ROW('a3303000-0000-4000-a000-000000000035'::UUID, 'study_room', 'C303', 15)::infrastruct.room_input  -- Study space
        ]
    );
    
    -- Building D - Administrative Building
    PERFORM infrastruct.add_building(
        v_faculty_id,
        'a0400000-0000-4000-a000-000000000004'::UUID,
        'Architecture Building D',
        '206 Design Avenue, Campus East',
        2,
        true,
        ARRAY[
            -- First floor - Admin offices and reception
            ROW('a4101000-0000-4000-a000-000000000036'::UUID, 'office', 'D101', 5)::infrastruct.room_input,   -- Dean's office
            ROW('a4102000-0000-4000-a000-000000000037'::UUID, 'office', 'D102', 10)::infrastruct.room_input,  -- Administrative staff
            ROW('a4103000-0000-4000-a000-000000000038'::UUID, 'conference_room', 'D103', 20)::infrastruct.room_input, -- Main meeting room
            
            -- Second floor - Faculty and research offices
            ROW('a4201000-0000-4000-a000-000000000039'::UUID, 'office', 'D201', 2)::infrastruct.room_input,
            ROW('a4202000-0000-4000-a000-000000000040'::UUID, 'office', 'D202', 2)::infrastruct.room_input,
            ROW('a4203000-0000-4000-a000-000000000041'::UUID, 'office', 'D203', 2)::infrastruct.room_input,
            ROW('a4204000-0000-4000-a000-000000000042'::UUID, 'office', 'D204', 2)::infrastruct.room_input,
            ROW('a4205000-0000-4000-a000-000000000043'::UUID, 'office', 'D205', 6)::infrastruct.room_input,   -- Research assistants
            ROW('a4206000-0000-4000-a000-000000000044'::UUID, 'conference_room', 'D206', 10)::infrastruct.room_input  -- Small meeting room
        ]
    );
    
    -- Create architecture library facility
    INSERT INTO infrastruct.facility(facility_type, building_id)
    VALUES (
        'library',
        'a0100000-0000-4000-a000-000000000001'::UUID  -- Located in Building A
    )
    ON CONFLICT (facility_type, building_id) DO NOTHING;
    
    RAISE NOTICE 'Architecture Faculty infrastructure has been successfully created';
END $$;
