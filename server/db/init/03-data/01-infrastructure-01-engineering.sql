DO $$
DECLARE
    v_faculty_id UUID := 'f0000000-0000-4000-a000-000000000001'; -- Engineering Faculty
BEGIN
    -- First ensure the faculty exists
    INSERT INTO infrastruct.faculty(id, name)
    VALUES (v_faculty_id, 'Engineering Faculty')
    ON CONFLICT (id) DO UPDATE SET name = 'Engineering Faculty';

    -- * Building A
    PERFORM infrastruct.add_building(
        v_faculty_id,
        'b0100000-0000-4000-a000-000000000001'::UUID,
        'Engineering Building A',
        'Por ahí we...',
        3,
        true, -- has accessibility features
        ARRAY[
            -- First floor
            ROW('a0101000-0000-4000-a010-000000000001'::UUID, 'auditorium', 'A117', 60)::infrastruct.room_input,
            ROW('a0102000-0000-4000-a010-000000000002'::UUID, 'auditorium', 'A118', 60)::infrastruct.room_input,
            ROW('a0103000-0000-4000-a010-000000000003'::UUID, 'auditorium', 'A119', 60)::infrastruct.room_input,
            ROW('a0103000-0000-4000-a010-000000000004'::UUID, 'auditorium', 'José Verreta Valdés', 180)::infrastruct.room_input,
            -- Second floor
            ROW('a0201000-0000-4000-a010-000000000005'::UUID, 'classroom', 'A201', 60)::infrastruct.room_input,
            ROW('a0202000-0000-4000-a010-000000000006'::UUID, 'classroom', 'A202', 40)::infrastruct.room_input,
            ROW('a0203000-0000-4000-a010-000000000007'::UUID, 'classroom', 'A203', 40)::infrastruct.room_input,
            ROW('a0204000-0000-4000-a010-000000000008'::UUID, 'classroom', 'A204', 40)::infrastruct.room_input,
            ROW('a0205000-0000-4000-a010-000000000009'::UUID, 'classroom', 'A205', 40)::infrastruct.room_input,
            ROW('a0206000-0000-4000-a010-000000000010'::UUID, 'classroom', 'A206', 40)::infrastruct.room_input,
            -- Third floor
            ROW('a0301000-0000-4000-a010-000000000011'::UUID, 'computer_lab', 'Sala 1', 30)::infrastruct.room_input,
            ROW('a0302000-0000-4000-a010-000000000012'::UUID, 'computer_lab', 'Sala 2', 30)::infrastruct.room_input,
            ROW('a0303000-0000-4000-a010-000000000013'::UUID, 'computer_lab', 'Sala 3', 30)::infrastruct.room_input,
            ROW('a0304000-0000-4000-a010-000000000014'::UUID, 'computer_lab', 'Sala 4', 30)::infrastruct.room_input,
            ROW('a0305000-0000-4000-a010-000000000015'::UUID, 'computer_lab', 'Sala 5', 30)::infrastruct.room_input,
            ROW('a0306000-0000-4000-a010-000000000016'::UUID, 'computer_lab', 'Sala 6', 30)::infrastruct.room_input,
            ROW('a0307000-0000-4000-a010-000000000017'::UUID, 'computer_lab', 'Sala 7', 30)::infrastruct.room_input,
            ROW('a0308000-0000-4000-a010-000000000018'::UUID, 'computer_lab', 'Sala 8', 30)::infrastruct.room_input,
            ROW('a0309000-0000-4000-a010-000000000019'::UUID, 'computer_lab', 'Sala 9', 30)::infrastruct.room_input,
            ROW('a0310000-0000-4000-a010-000000000020'::UUID, 'computer_lab', 'Sala 10', 30)::infrastruct.room_input,

            ROW('a0310000-0000-4000-a010-000000000021'::UUID, 'storage', 'Almacén', 2)::infrastruct.room_input,
            ROW('a0310000-0000-4000-a010-000000000022'::UUID, 'office', 'Oficina 1', 8)::infrastruct.room_input
        ]
    );

    -- * Building B
    PERFORM infrastruct.add_building(
        v_faculty_id,
        'b0200000-0000-4000-a000-000000000002'::UUID,
        'Engineering Building B',
        '125 Engineering Blvd, Campus North',
        2,
        true,
        ARRAY[
            ROW('b0101000-0000-4000-a000-000000000001'::UUID, 'study_room', 'Sala de estudio 1', 10)::infrastruct.room_input,
            ROW('b0102000-0000-4000-a000-000000000002'::UUID, 'study_room', 'Sala de estudio 2', 10)::infrastruct.room_input,
            ROW('b0301000-0000-4000-a000-000000000003'::UUID, 'study_room', 'Sala de estudio 3', 10)::infrastruct.room_input
        ]
    );

    -- * Building C
    PERFORM infrastruct.add_building(
        v_faculty_id,
        'b0300000-0000-4000-a000-000000000003'::UUID,
        'Engineering Building C',
        '127 Engineering Blvd, Campus North',
        4,
        true,
        ARRAY[
            -- First floor
            ROW('c0102000-0000-4000-a000-000000000001'::UUID, 'classroom', 'C101', 40)::infrastruct.room_input,
            ROW('c0103000-0000-4000-a000-000000000002'::UUID, 'classroom', 'C102', 40)::infrastruct.room_input,
            ROW('c0104000-0000-4000-a000-000000000003'::UUID, 'classroom', 'C103', 40)::infrastruct.room_input,

            -- Third floor
            ROW('c0301000-0000-4000-a000-000000000004'::UUID, 'classroom', 'C301', 36)::infrastruct.room_input,
            ROW('c0302000-0000-4000-a000-000000000004'::UUID, 'classroom', 'C302', 36)::infrastruct.room_input,
            ROW('c0303000-0000-4000-a000-000000000005'::UUID, 'classroom', 'C303', 36)::infrastruct.room_input,
            ROW('c0304000-0000-4000-a000-000000000006'::UUID, 'classroom', 'C304', 36)::infrastruct.room_input,
            ROW('c0305000-0000-4000-a000-000000000007'::UUID, 'classroom', 'C305', 36)::infrastruct.room_input,
            ROW('c0306000-0000-4000-a000-000000000008'::UUID, 'classroom', 'C306', 36)::infrastruct.room_input,
            ROW('c0307000-0000-4000-a000-000000000009'::UUID, 'classroom', 'C307', 36)::infrastruct.room_input,

            ROW('c0308000-0000-4000-a000-000000000014'::UUID, 'study_room', 'Sala de estudio 1', 10)::infrastruct.room_input,
            ROW('c0309000-0000-4000-a000-000000000015'::UUID, 'study_room', 'Sala de estudio 2', 10)::infrastruct.room_input,
            ROW('c0310000-0000-4000-a000-000000000016'::UUID, 'study_room', 'Sala de estudio 3', 10)::infrastruct.room_input,
            ROW('c0311000-0000-4000-a000-000000000017'::UUID, 'study_room', 'Sala de estudio 4', 10)::infrastruct.room_input,
            ROW('c0312000-0000-4000-a000-000000000018'::UUID, 'study_room', 'Sala de estudio 5', 10)::infrastruct.room_input,
            ROW('c0313000-0000-4000-a000-000000000019'::UUID, 'study_room', 'Sala de estudio 6', 10)::infrastruct.room_input,

            -- Fourth floor
            ROW('c0401000-0000-4000-a000-000000000013'::UUID, 'classroom', 'C401', 40)::infrastruct.room_input,
            ROW('c0402000-0000-4000-a000-000000000014'::UUID, 'classroom', 'C402', 40)::infrastruct.room_input,
            ROW('c0403000-0000-4000-a000-000000000015'::UUID, 'classroom', 'C403', 40)::infrastruct.room_input,
            ROW('c0404000-0000-4000-a000-000000000016'::UUID, 'classroom', 'C404', 40)::infrastruct.room_input,
            ROW('c0405000-0000-4000-a000-000000000017'::UUID, 'classroom', 'C405', 40)::infrastruct.room_input,
            ROW('c0406000-0000-4000-a000-000000000018'::UUID, 'classroom', 'C406', 40)::infrastruct.room_input,
            ROW('c0407000-0000-4000-a000-000000000019'::UUID, 'classroom', 'C407', 40)::infrastruct.room_input,
            ROW('c0408000-0000-4000-a000-000000000020'::UUID, 'classroom', 'C408', 40)::infrastruct.room_input,
            ROW('c0409000-0000-4000-a000-000000000021'::UUID, 'classroom', 'C409', 40)::infrastruct.room_input,
            ROW('c0410000-0000-4000-a000-000000000022'::UUID, 'classroom', 'C410', 40)::infrastruct.room_input,
            ROW('c0411000-0000-4000-a000-000000000023'::UUID, 'storage', 'Almacén', 2)::infrastruct.room_input
        ]
    );

    -- * Building D
    PERFORM infrastruct.add_building(
        v_faculty_id,
        'b0400000-0000-4000-a000-000000000004'::UUID,
        'Engineering Building D',
        '129 Engineering Blvd, Campus North',
        5,
        true,
        ARRAY[
            -- First floor laboratories
            ROW('d0101000-0000-4000-a000-000000000001'::UUID, 'classroom', 'D101', 35)::infrastruct.room_input,

            -- Third floor laboratories (skipping floor 2)
            ROW('d0301000-0000-4000-a000-000000000005'::UUID, 'laboratory', 'D301', 35)::infrastruct.room_input,
            ROW('d0302000-0000-4000-a000-000000000006'::UUID, 'laboratory', 'D302', 35)::infrastruct.room_input,
            ROW('d0303000-0000-4000-a000-000000000007'::UUID, 'laboratory', 'D303', 35)::infrastruct.room_input,
            ROW('d0304000-0000-4000-a000-000000000008'::UUID, 'laboratory', 'D304', 35)::infrastruct.room_input,
            ROW('d0305000-0000-4000-a000-000000000009'::UUID, 'laboratory', 'D305', 35)::infrastruct.room_input,
            ROW('d0306000-0000-4000-a000-000000000010'::UUID, 'laboratory', 'D306', 35)::infrastruct.room_input
        ]
    );


    -- * Building E
    PERFORM infrastruct.add_building(
        v_faculty_id,
        'b0500000-0000-4000-a000-000000000005'::UUID,
        'Engineering Building E',
        '131 Engineering Blvd, Campus North',
        3,
        true,
        ARRAY[
            -- First floor
            ROW('e0101000-0000-4000-a000-000000000001'::UUID, 'classroom', 'E101', 40)::infrastruct.room_input,
            ROW('e0102000-0000-4000-a000-000000000002'::UUID, 'classroom', 'E102', 40)::infrastruct.room_input,
            ROW('e0103000-0000-4000-a000-000000000003'::UUID, 'classroom', 'E103', 40)::infrastruct.room_input,

            -- Second floor
            ROW('e0201000-0000-4000-a000-000000000004'::UUID, 'classroom', 'E201', 40)::infrastruct.room_input,
            ROW('e0202000-0000-4000-a000-000000000005'::UUID, 'classroom', 'E202', 40)::infrastruct.room_input,
            ROW('e0203000-0000-4000-a000-000000000006'::UUID, 'classroom', 'E203', 40)::infrastruct.room_input,

            -- Third floor
            ROW('e0301000-0000-4000-a000-000000000007'::UUID, 'classroom', 'E301', 40)::infrastruct.room_input,
            ROW('e0302000-0000-4000-a000-000000000008'::UUID, 'classroom', 'E302', 40)::infrastruct.room_input,
            ROW('e0303000-0000-4000-a000-000000000009'::UUID, 'classroom', 'E303', 40)::infrastruct.room_input,
            ROW('e0304000-0000-4000-a000-000000000010'::UUID, 'classroom', 'E304', 40)::infrastruct.room_input
        ]
    );


    -- * Building F (does not exist yet...)
    -- * Building G
    PERFORM infrastruct.add_building(
        v_faculty_id,
        'b0700000-0000-4000-a000-000000000007'::UUID,
        'Engineering Building G',
        '135 Engineering Blvd, Campus North',
        2,
        true,
        ARRAY[
            -- Second floor (fixing the UUIDs by replacing 'g' with valid hex)
            ROW('70101000-0000-4000-a000-000000000001'::UUID, 'classroom', 'G201', 40)::infrastruct.room_input,
            ROW('70202000-0000-4000-a000-000000000002'::UUID, 'classroom', 'G202', 40)::infrastruct.room_input,
            ROW('70203000-0000-4000-a000-000000000003'::UUID, 'classroom', 'G203', 40)::infrastruct.room_input,
            ROW('70204000-0000-4000-a000-000000000004'::UUID, 'classroom', 'G204', 40)::infrastruct.room_input,
            ROW('70205000-0000-4000-a000-000000000005'::UUID, 'classroom', 'G205', 40)::infrastruct.room_input,
            ROW('70206000-0000-4000-a000-000000000006'::UUID, 'classroom', 'G206', 40)::infrastruct.room_input,

            ROW('70207000-0000-4000-a000-000000000007'::UUID, 'study_room', 'Educación Continua 1', 10)::infrastruct.room_input,
            ROW('70208000-0000-4000-a000-000000000008'::UUID, 'study_room', 'Educación Continua 2', 10)::infrastruct.room_input,

            ROW('70209000-0000-4000-a000-000000000009'::UUID, 'laboratory', 'Laboratorio de Interacción Hombre-Maquina', 30)::infrastruct.room_input,
            ROW('70210000-0000-4000-a000-000000000010'::UUID, 'laboratory', 'Laboratorio de Robótica', 30)::infrastruct.room_input,
            ROW('70211000-0000-4000-a000-000000000011'::UUID, 'laboratory', 'Laboratorio de VIANCO', 30)::infrastruct.room_input,
            ROW('70212000-0000-4000-a000-000000000012'::UUID, 'laboratory', 'Laboratorio de Redes', 30)::infrastruct.room_input,
            ROW('70213000-0000-4000-a000-000000000013'::UUID, 'laboratory', 'Laboratorio de Cloud Computing', 30)::infrastruct.room_input,

            -- Third floor (4 classrooms)
            ROW('70301000-0000-4000-a000-000000000014'::UUID, 'classroom', 'Postgrado G1', 40)::infrastruct.room_input,
            ROW('70302000-0000-4000-a000-000000000015'::UUID, 'classroom', 'Postgrado G2', 40)::infrastruct.room_input,
            ROW('70303000-0000-4000-a000-000000000016'::UUID, 'classroom', 'Postgrado G3', 40)::infrastruct.room_input,
            ROW('70304000-0000-4000-a000-000000000017'::UUID, 'classroom', 'Postgrado G4', 40)::infrastruct.room_input
        ]
    );

    -- * Building H

    -- * Building I
    PERFORM infrastruct.add_building(
        v_faculty_id,
        'b0900000-0000-4000-a000-000000000009'::UUID,
        'Engineering Building I',
        '139 Engineering Blvd, Campus North',
        3,
        true,
        ARRAY[
            -- First floor (fixing the UUIDs by replacing 'i' with valid hex)
            ROW('90101000-0000-4000-a000-000000000001'::UUID, 'laboratory', 'Laboratorio de Electrónica Digital', 30)::infrastruct.room_input,
            ROW('90102000-0000-4000-a000-000000000002'::UUID, 'laboratory', 'Laboratorio de Electrónica de Potencia', 30)::infrastruct.room_input,
            ROW('90103000-0000-4000-a000-000000000003'::UUID, 'laboratory', 'Laboratorio de Electrónica Analógica', 30)::infrastruct.room_input,
            ROW('90104000-0000-4000-a000-000000000004'::UUID, 'storage', 'Almacén', 2)::infrastruct.room_input,

            -- Second floor
            ROW('90201000-0000-4000-a000-000000000005'::UUID, 'classroom', 'I201', 40)::infrastruct.room_input,
            ROW('90202000-0000-4000-a000-000000000006'::UUID, 'classroom', 'I202', 40)::infrastruct.room_input,
            ROW('90203000-0000-4000-a000-000000000007'::UUID, 'classroom', 'I203', 40)::infrastruct.room_input,
            ROW('90204000-0000-4000-a000-000000000008'::UUID, 'classroom', 'I204', 40)::infrastruct.room_input,
            ROW('90205000-0000-4000-a000-000000000009'::UUID, 'classroom', 'I205', 40)::infrastruct.room_input,

            -- Third floor
            ROW('90301000-0000-4000-a000-000000000010'::UUID, 'classroom', 'I301', 40)::infrastruct.room_input,
            ROW('90302000-0000-4000-a000-000000000011'::UUID, 'classroom', 'I302', 40)::infrastruct.room_input,
            ROW('90303000-0000-4000-a000-000000000012'::UUID, 'classroom', 'I303', 40)::infrastruct.room_input,
            ROW('90304000-0000-4000-a000-000000000013'::UUID, 'classroom', 'I304', 40)::infrastruct.room_input,
            ROW('90305000-0000-4000-a000-000000000014'::UUID, 'classroom', 'I305', 40)::infrastruct.room_input
        ]
    );

    INSERT INTO infrastruct.facility(facility_type, building_id)
    VALUES (
        'library',
        'b0200000-0000-4000-a000-000000000002'::UUID  -- Located in Building B
    )
    ON CONFLICT (facility_type, building_id) DO NOTHING;

    RAISE NOTICE 'Engineering Faculty infrastructure has been successfully created';
END $$;
