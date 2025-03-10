-- 03-03-academic-ico-f19.sql
DO $$
DECLARE
    v_program_id UUID;
    course_type academic.course_category DEFAULT 'advanced';
BEGIN
    SELECT id INTO v_program_id FROM academic.program WHERE code = 'ICO';  -- retrieve the program ID
    IF v_program_id IS NULL THEN  -- ! If the program doesn't exist, create it
        INSERT INTO academic.program (id, code, name, description, degree_level) VALUES (
            'ce123456-7890-4321-abcd-ef1234567890'::UUID,
            'ICO',
            'Ingeniería en Computación',
            'Programa de ingeniería enfocado en el diseño y desarrollo de sistemas computacionales',
            'Licenciatura'
        )
        RETURNING id INTO v_program_id;
    END IF;

    -- * Semester 1
    PERFORM academic.associate_course_with_program(v_program_id, 'c0102000-0000-4000-a000-000000000002', TRUE, 1); -- Física
    PERFORM academic.associate_course_with_program(v_program_id, 'c0103000-0000-4000-a000-000000000003', TRUE, 1); -- Álgebra superior
    PERFORM academic.associate_course_with_program(v_program_id, 'c0306000-0000-4000-a000-000000000606', TRUE, 1); -- Programación
    PERFORM academic.associate_course_with_program(v_program_id, 'c0105000-0000-4000-a000-000000000005', TRUE, 1); -- Geometría analítica
    PERFORM academic.associate_course_with_program(v_program_id, 'c0101000-0000-4000-a000-000000000101', TRUE, 1); -- Cálculo I
    PERFORM academic.associate_course_with_program(v_program_id, 'c0106000-0000-4000-a000-000000000006', TRUE, 1); -- El ingeniero y su entorno socioeconómico
    -- * Semester 2
    PERFORM academic.associate_course_with_program(v_program_id, 'c0204000-0000-4000-a000-000000000014', TRUE, 2); -- Programación II
    PERFORM academic.associate_course_with_program(v_program_id, 'c0202000-0000-4000-a000-000000000002', TRUE, 2); -- Ecuaciones diferenciales
    PERFORM academic.associate_course_with_program(v_program_id, 'c0203000-0000-4000-a000-000000000003', TRUE, 2); -- Álgebra lineal
    PERFORM academic.associate_course_with_program(v_program_id, 'c0205000-0000-4000-a000-000000000005', TRUE, 2); -- Química
    PERFORM academic.associate_course_with_program(v_program_id, 'c0201000-0000-4000-a000-000000000001', TRUE, 2); -- Cálculo II
    PERFORM academic.associate_course_with_program(v_program_id, 'c0207000-0000-4000-a000-000000000007', TRUE, 2); -- Epistemología
    PERFORM academic.associate_course_with_program(v_program_id, 'c0206000-0000-4000-a000-000000000006', TRUE, 2); -- Inglés 5
    -- * Semester 3
    PERFORM academic.associate_course_with_program(v_program_id, 'c0305000-0000-4000-a000-000000000005', TRUE, 3); -- Bases de datos I
    PERFORM academic.associate_course_with_program(v_program_id, 'c0304000-0000-4000-a000-000000000004', TRUE, 3); -- Paradigmas de programación I
    PERFORM academic.associate_course_with_program(v_program_id, 'c0307000-0000-4000-a000-000000000007', TRUE, 3); -- Comunicación y relaciones humanas
    PERFORM academic.associate_course_with_program(v_program_id, 'c0302000-0000-4000-a000-000000000002', TRUE, 3); -- Probabilidad y estadística
    PERFORM academic.associate_course_with_program(v_program_id, 'c0304000-0000-4000-a000-000000000012', TRUE, 3); -- Matemáticas discretas
    PERFORM academic.associate_course_with_program(v_program_id, 'c0301000-0000-4000-a000-000000000001', TRUE, 3); -- Cálculo III
    PERFORM academic.associate_course_with_program(v_program_id, 'c0306000-0000-4000-a000-000000000306', TRUE, 3); -- Inglés 6
    -- * Semester 4
    PERFORM academic.associate_course_with_program(v_program_id, 'c0401000-0000-4000-a000-000000000001', TRUE, 4); -- Arquitectura de computadoras
    PERFORM academic.associate_course_with_program(v_program_id, 'c0405000-0000-4000-a000-000000000005', TRUE, 4); -- Bases de datos II
    PERFORM academic.associate_course_with_program(v_program_id, 'c0404000-0000-4000-a000-000000000004', TRUE, 4); -- Paradigmas de programación II
    PERFORM academic.associate_course_with_program(v_program_id, 'c0402000-0000-4000-a000-000000000002', TRUE, 4); -- Métodos estadísticos
    PERFORM academic.associate_course_with_program(v_program_id, 'c0403000-0000-4000-a000-000000000003', TRUE, 4); -- Métodos numéricos
    PERFORM academic.associate_course_with_program(v_program_id, 'c0204000-0000-4000-a000-000000000004', TRUE, 4); -- Electromagnetismo
    PERFORM academic.associate_course_with_program(v_program_id, 'c0407000-0000-4000-a000-000000000007', TRUE, 4); -- Inglés 7
   -- * Semester 5
    PERFORM academic.associate_course_with_program(v_program_id, 'c0501000-0000-4000-a000-000000000001', TRUE, 5); -- Circuitos eléctricos y electrónicos
    PERFORM academic.associate_course_with_program(v_program_id, 'c0502000-0000-4000-a000-000000000002', TRUE, 5); -- Transmisión de datos
    PERFORM academic.associate_course_with_program(v_program_id, 'c0503000-0000-4000-a000-000000000003', TRUE, 5); -- Investigación de operaciones
    PERFORM academic.associate_course_with_program(v_program_id, 'c0504000-0000-4000-a000-000000000004', TRUE, 5); -- Ingeniería de software I
    PERFORM academic.associate_course_with_program(v_program_id, 'c0505000-0000-4000-a000-000000000005', TRUE, 5); -- Ensambladores
    PERFORM academic.associate_course_with_program(v_program_id, 'c0506000-0000-4000-a000-000000000006', TRUE, 5); -- Inteligencia artificial
    PERFORM academic.associate_course_with_program(v_program_id, 'c0507000-0000-4000-a000-000000000007', TRUE, 5); -- Inglés 8
    -- * Semester 6
    PERFORM academic.associate_course_with_program(v_program_id, 'c0601000-0000-4000-a000-000000000001', TRUE, 6); -- Sistemas analógicos
    PERFORM academic.associate_course_with_program(v_program_id, 'c0602000-0000-4000-a000-000000000002', TRUE, 6); -- Protocolos de comunicación de datos
    PERFORM academic.associate_course_with_program(v_program_id, 'c0603000-0000-4000-a000-000000000003', TRUE, 6); -- Administración de recursos informáticos
    PERFORM academic.associate_course_with_program(v_program_id, 'c0604000-0000-4000-a000-000000000004', TRUE, 6); -- Ingeniería de software II
    PERFORM academic.associate_course_with_program(v_program_id, 'c0605000-0000-4000-a000-000000000005', TRUE, 6); -- Compiladores
    PERFORM academic.associate_course_with_program(v_program_id, 'c0606000-0000-4000-a000-000000000006', TRUE, 6); -- Procesamiento de imágenes digitales
    -- * Semester 7
    PERFORM academic.associate_course_with_program(v_program_id, 'c0701000-0000-4000-a000-000000000001', TRUE, 7); -- Sistemas digitales
    PERFORM academic.associate_course_with_program(v_program_id, 'c0702000-0000-4000-a000-000000000002', TRUE, 7); -- Arquitectura de redes
    PERFORM academic.associate_course_with_program(v_program_id, 'c0703000-0000-4000-a000-000000000003', TRUE, 7); -- Administración de proyectos informáticos
    PERFORM academic.associate_course_with_program(v_program_id, 'c0705000-0000-4000-a000-000000000005', TRUE, 7); -- Sistemas operativos
    PERFORM academic.associate_course_with_program(v_program_id, 'c0706000-0000-4000-a000-000000000006', TRUE, 7); -- Robótica
    PERFORM academic.associate_course_with_program(v_program_id, 'c0707000-0000-4000-a000-000000000007', TRUE, 7); -- Graficación computacional
    CALL add_course_to_program(v_program_id, 'c0704000-0000-4000-a000-000000000004'::UUID, 'ICO-07-04', 5, TRUE, 7, 'Ciencia de los datos', 'Análisis y procesamiento de grandes volúmenes de datos', TRUE, course_type);
    -- * Semester 8
    PERFORM academic.associate_course_with_program(v_program_id, 'c0802000-0000-4000-a000-000000000002', TRUE, 8); -- Seguridad de la información
    CALL add_course_to_program(v_program_id, 'c0801000-0000-4000-a000-000000000001'::UUID, 'ICO-08-01', 6, TRUE, 8, 'Sistemas embebidos', 'Diseño y programación de sistemas embebidos', TRUE, course_type);
    CALL add_course_to_program(v_program_id, 'c0803000-0000-4000-a000-000000000003'::UUID, 'ICO-08-03', 4, TRUE, 8, 'Gestión de proyectos de investigación', 'Metodología y gestión de proyectos de investigación', TRUE, course_type);
    CALL add_course_to_program(v_program_id, 'c0804000-0000-4000-a000-000000000004'::UUID, 'ICO-08-04', 5, TRUE, 8, 'Tecnologías computacionales I', 'Estudio de tecnologías computacionales avanzadas', TRUE, course_type);
    CALL add_course_to_program(v_program_id, 'c0805000-0000-4000-a000-000000000005'::UUID, 'ICO-08-05', 8, TRUE, 8, 'Integrativa profesional', 'Integración de conocimientos profesionales', TRUE, course_type);
    CALL add_course_to_program(v_program_id, 'c0806000-0000-4000-a000-000000000006'::UUID, 'ICO-08-06', 6, TRUE, 8, 'Ética profesional y sustentabilidad', 'Ética en la práctica profesional y desarrollo sustentable', TRUE, course_type);
    -- optional courses
    CALL add_course_to_program(v_program_id, 'c0807000-0000-4000-a000-000000000007'::UUID, 'ICO-08-07', 5, FALSE, 8, 'Análisis y diseño de redes', 'Diseño y análisis de redes de comunicación', TRUE, course_type);
    CALL add_course_to_program(v_program_id, 'c0808000-0000-4000-a000-000000000008'::UUID, 'ICO-08-08', 5, FALSE, 8, 'Visión artificial', 'Fundamentos y aplicaciones de visión artificial', TRUE, course_type);
    CALL add_course_to_program(v_program_id, 'c0809000-0000-4000-a000-000000000009'::UUID, 'ICO-08-09', 5, FALSE, 8, 'Reconocimiento de patrones', 'Técnicas de reconocimiento de patrones', TRUE, course_type);
    -- * Semester 9
    CALL add_course_to_program(v_program_id, 'c0901000-0000-4000-a000-000000000001'::UUID, 'ICO-09-01', 5, TRUE, 9, 'Proyecto integral de comunicación de datos', 'Desarrollo de proyectos de redes y comunicaciones', TRUE, course_type);
    CALL add_course_to_program(v_program_id, 'c0902000-0000-4000-a000-000000000002'::UUID, 'ICO-09-02', 5, TRUE, 9, 'Proyecto integral de ingeniería de software', 'Desarrollo de proyectos de ingeniería de software', TRUE, course_type);
    CALL add_course_to_program(v_program_id, 'c0903000-0000-4000-a000-000000000003'::UUID, 'ICO-09-03', 5, TRUE, 9, 'Tecnologías computacionales II', 'Aplicaciones avanzadas de tecnologías computacionales', TRUE, course_type);
    -- optional courses
    CALL add_course_to_program(v_program_id, 'c0904000-0000-4000-a000-000000000004'::UUID, 'ICO-09-04', 5, FALSE, 9, 'Gestión de redes', 'Diseño y gestión de redes de comunicación', TRUE, course_type);
    CALL add_course_to_program(v_program_id, 'c0905000-0000-4000-a000-000000000005'::UUID, 'ICO-09-05', 5, FALSE, 9, 'Computing in industry', 'Aplicaciones de la computación en la industria', TRUE, course_type);
    CALL add_course_to_program(v_program_id, 'c0906000-0000-4000-a000-000000000006'::UUID, 'ICO-09-06', 5, FALSE, 9, 'Interacción hombre-máquina', 'Diseño de interfaces de usuario', TRUE, course_type);
    CALL add_course_to_program(v_program_id, 'c0907000-0000-4000-a000-000000000007'::UUID, 'ICO-09-07', 5, FALSE, 9, 'Tecnologías emergentes', 'Estudio de tecnologías emergentes', TRUE, course_type);
    CALL add_course_to_program(v_program_id, 'c0908000-0000-4000-a000-000000000008'::UUID, 'ICO-09-08', 5, FALSE, 9, 'Tópicos de tecnologías de datos', 'Estudio de tópicos avanzados en tecnologías de datos', TRUE, course_type);
    CALL add_course_to_program(v_program_id, 'c0909000-0000-4000-a000-000000000009'::UUID, 'ICO-09-09', 5, FALSE, 9, 'Sistemas interactivos', 'Diseño de sistemas interactivos', TRUE, course_type);

    RAISE NOTICE 'All ICO program courses have been added successfully.';
EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION 'An error occurred while adding ICO program courses: %', SQLERRM;
END $$;


-- * Add the course prerequisites for the Computer Engineering program (Ingeniería en Computación - F19)
INSERT INTO academic.course_prerequisite (course_id, prerequisite_course_id)
VALUES
    ('c0204000-0000-4000-a000-000000000014', 'c0306000-0000-4000-a000-000000000606'),  -- Programación II requires Programación I

    ('c0404000-0000-4000-a000-000000000004', 'c0304000-0000-4000-a000-000000000004'),  -- Paradigmas de programación II requires Paradigmas de programación I
    ('c0405000-0000-4000-a000-000000000005', 'c0305000-0000-4000-a000-000000000005'),  -- Bases de datos II requires Bases de datos I
    ('c0704000-0000-4000-a000-000000000004', 'c0405000-0000-4000-a000-000000000005'),  -- Ciencia de los datos requires Bases de datos II
    ('c0604000-0000-4000-a000-000000000004', 'c0504000-0000-4000-a000-000000000004'),  -- Ingeniería de software II requires Ingeniería de software I
    ('c0601000-0000-4000-a000-000000000001', 'c0501000-0000-4000-a000-000000000001'),  -- Sistemas analógicos requires Circuitos eléctricos y electrónicos
    ('c0602000-0000-4000-a000-000000000002', 'c0502000-0000-4000-a000-000000000002'),  -- Protocolos de comunicación de datos requires Transmisión de datos
    ('c0702000-0000-4000-a000-000000000002', 'c0602000-0000-4000-a000-000000000002'),  -- Arquitectura de redes requires Protocolos de comunicación de datos
    ('c0801000-0000-4000-a000-000000000001', 'c0701000-0000-4000-a000-000000000001'),  -- Sistemas embebidos requires Sistemas digitales
    ('c0903000-0000-4000-a000-000000000003', 'c0804000-0000-4000-a000-000000000004')   -- TC-II requires TC-I
;