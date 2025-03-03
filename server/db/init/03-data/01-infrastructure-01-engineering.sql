DO $$
DECLARE
    v_faculty_id UUID := 'f0000000-0000-4000-a000-000000000001'; -- Engineering Faculty
BEGIN
    -- First ensure the faculty exists
    INSERT INTO infrastruct.faculty(id, name)
    VALUES (v_faculty_id, 'Engineering Faculty')
    ON CONFLICT (id) DO UPDATE SET name = 'Engineering Faculty';
    
    -- Building A - Main Engineering Building
    PERFORM infrastruct.add_building(
        v_faculty_id,
        'b0100000-0000-4000-a000-000000000001'::UUID,
        'Engineering Building A',
        '123 Engineering Blvd, Campus North',
        5,  -- 5 floors
        true, -- has accessibility features
        ARRAY[
            -- First floor classrooms
            ROW('a0101000-0000-4000-a000-000000000001'::UUID, 'classroom', 'A101', 60)::infrastruct.room_input,
            ROW('a0102000-0000-4000-a000-000000000002'::UUID, 'classroom', 'A102', 60)::infrastruct.room_input,
            ROW('a0103000-0000-4000-a000-000000000003'::UUID, 'classroom', 'A103', 40)::infrastruct.room_input,
            -- Second floor classrooms
            ROW('a0104000-0000-4000-a000-000000000004'::UUID, 'classroom', 'A201', 60)::infrastruct.room_input,
            ROW('a0105000-0000-4000-a000-000000000005'::UUID, 'classroom', 'A202', 40)::infrastruct.room_input,
            -- Third floor laboratories
            ROW('a0106000-0000-4000-a000-000000000006'::UUID, 'laboratory', 'A301', 30)::infrastruct.room_input,
            ROW('a0107000-0000-4000-a000-000000000007'::UUID, 'laboratory', 'A302', 30)::infrastruct.room_input,
            -- Fourth floor conference room
            ROW('a0108000-0000-4000-a000-000000000008'::UUID, 'conference_room', 'A401', 20)::infrastruct.room_input,
            -- Fifth floor offices
            ROW('a0109000-0000-4000-a000-000000000009'::UUID, 'office', 'A501', 4)::infrastruct.room_input,
            ROW('a0110000-0000-4000-a000-000000000010'::UUID, 'office', 'A502', 4)::infrastruct.room_input
        ]
    );
    
    -- Building B - Study Building (with 4 study rooms)
    PERFORM infrastruct.add_building(
        v_faculty_id,
        'b0200000-0000-4000-a000-000000000002'::UUID,
        'Engineering Building B',
        '125 Engineering Blvd, Campus North',
        3,  -- 3 floors (1, 3, 4 - avoiding floor 2 as requested)
        true,
        ARRAY[
            -- First floor study rooms
            ROW('b0101000-0000-4000-a000-000000000001'::UUID, 'study_room', 'B101', 10)::infrastruct.room_input,
            ROW('b0102000-0000-4000-a000-000000000002'::UUID, 'study_room', 'B102', 10)::infrastruct.room_input,
            -- Third floor study rooms (skipping 2nd floor as requested)
            ROW('b0301000-0000-4000-a000-000000000003'::UUID, 'study_room', 'B301', 10)::infrastruct.room_input,
            ROW('b0302000-0000-4000-a000-000000000004'::UUID, 'study_room', 'B302', 10)::infrastruct.room_input
        ]
    );
    
    -- Building C - Large Classroom Building (4 floors, 6 classrooms per floor)
    PERFORM infrastruct.add_building(
        v_faculty_id,
        'b0300000-0000-4000-a000-000000000003'::UUID,
        'Engineering Building C',
        '127 Engineering Blvd, Campus North',
        4,
        true,
        ARRAY[
            -- First floor classrooms (C101-C106)
            ROW('c0101000-0000-4000-a000-000000000001'::UUID, 'classroom', 'C101', 80)::infrastruct.room_input,
            ROW('c0102000-0000-4000-a000-000000000002'::UUID, 'classroom', 'C102', 70)::infrastruct.room_input,
            ROW('c0103000-0000-4000-a000-000000000003'::UUID, 'classroom', 'C103', 80)::infrastruct.room_input,
            ROW('c0104000-0000-4000-a000-000000000004'::UUID, 'classroom', 'C104', 60)::infrastruct.room_input,
            ROW('c0105000-0000-4000-a000-000000000005'::UUID, 'classroom', 'C105', 50)::infrastruct.room_input,
            ROW('c0106000-0000-4000-a000-000000000006'::UUID, 'classroom', 'C106', 40)::infrastruct.room_input,
            
            -- Third floor classrooms (C301-C306) - skipping floor 2 as requested
            ROW('c0301000-0000-4000-a000-000000000007'::UUID, 'classroom', 'C301', 80)::infrastruct.room_input,
            ROW('c0302000-0000-4000-a000-000000000008'::UUID, 'classroom', 'C302', 70)::infrastruct.room_input,
            ROW('c0303000-0000-4000-a000-000000000009'::UUID, 'classroom', 'C303', 80)::infrastruct.room_input,
            ROW('c0304000-0000-4000-a000-000000000010'::UUID, 'classroom', 'C304', 60)::infrastruct.room_input,
            ROW('c0305000-0000-4000-a000-000000000011'::UUID, 'classroom', 'C305', 50)::infrastruct.room_input,
            ROW('c0306000-0000-4000-a000-000000000012'::UUID, 'classroom', 'C306', 40)::infrastruct.room_input,
            
            -- Fourth floor classrooms (C401-C406)
            ROW('c0401000-0000-4000-a000-000000000013'::UUID, 'classroom', 'C401', 80)::infrastruct.room_input,
            ROW('c0402000-0000-4000-a000-000000000014'::UUID, 'classroom', 'C402', 70)::infrastruct.room_input,
            ROW('c0403000-0000-4000-a000-000000000015'::UUID, 'classroom', 'C403', 80)::infrastruct.room_input,
            ROW('c0404000-0000-4000-a000-000000000016'::UUID, 'classroom', 'C404', 60)::infrastruct.room_input,
            ROW('c0405000-0000-4000-a000-000000000017'::UUID, 'classroom', 'C405', 50)::infrastruct.room_input,
            ROW('c0406000-0000-4000-a000-000000000018'::UUID, 'classroom', 'C406', 40)::infrastruct.room_input,
            
            -- Fifth floor classrooms (C501-C506)
            ROW('c0501000-0000-4000-a000-000000000019'::UUID, 'classroom', 'C501', 80)::infrastruct.room_input,
            ROW('c0502000-0000-4000-a000-000000000020'::UUID, 'classroom', 'C502', 70)::infrastruct.room_input,
            ROW('c0503000-0000-4000-a000-000000000021'::UUID, 'classroom', 'C503', 80)::infrastruct.room_input,
            ROW('c0504000-0000-4000-a000-000000000022'::UUID, 'classroom', 'C504', 60)::infrastruct.room_input,
            ROW('c0505000-0000-4000-a000-000000000023'::UUID, 'classroom', 'C505', 50)::infrastruct.room_input,
            ROW('c0506000-0000-4000-a000-000000000024'::UUID, 'classroom', 'C506', 40)::infrastruct.room_input
        ]
    );
    
    -- Building D - Mixed-use building with various room types
    PERFORM infrastruct.add_building(
        v_faculty_id,
        'b0400000-0000-4000-a000-000000000004'::UUID,
        'Engineering Building D',
        '129 Engineering Blvd, Campus North',
        5,
        true,
        ARRAY[
            -- First floor laboratories
            ROW('d0101000-0000-4000-a000-000000000001'::UUID, 'laboratory', 'D101', 35)::infrastruct.room_input,
            ROW('d0102000-0000-4000-a000-000000000002'::UUID, 'laboratory', 'D102', 35)::infrastruct.room_input,
            -- First floor offices
            ROW('d0103000-0000-4000-a000-000000000003'::UUID, 'office', 'D103', 3)::infrastruct.room_input,
            ROW('d0104000-0000-4000-a000-000000000004'::UUID, 'office', 'D104', 3)::infrastruct.room_input,
            
            -- Third floor laboratories (skipping floor 2)
            ROW('d0301000-0000-4000-a000-000000000005'::UUID, 'laboratory', 'D301', 35)::infrastruct.room_input,
            ROW('d0302000-0000-4000-a000-000000000006'::UUID, 'laboratory', 'D302', 35)::infrastruct.room_input,
            -- Third floor offices
            ROW('d0303000-0000-4000-a000-000000000007'::UUID, 'office', 'D303', 3)::infrastruct.room_input,
            ROW('d0304000-0000-4000-a000-000000000008'::UUID, 'office', 'D304', 3)::infrastruct.room_input,
            
            -- Fourth floor conference rooms
            ROW('d0401000-0000-4000-a000-000000000009'::UUID, 'conference_room', 'D401', 25)::infrastruct.room_input,
            ROW('d0402000-0000-4000-a000-000000000010'::UUID, 'conference_room', 'D402', 15)::infrastruct.room_input,
            
            -- Fifth floor auditorium
            ROW('d0501000-0000-4000-a000-000000000011'::UUID, 'auditorium', 'D501', 200)::infrastruct.room_input
        ]
    );

    INSERT INTO infrastruct.facility(facility_type, building_id)
    VALUES (
        'library',
        'b0200000-0000-4000-a000-000000000002'::UUID  -- Located in Building A
    )
    ON CONFLICT (facility_type, building_id) DO NOTHING;

    RAISE NOTICE 'Engineering Faculty infrastructure has been successfully created';
END $$;
