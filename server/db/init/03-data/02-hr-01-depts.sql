-- File: 02-hr-02-administrative.sql
-- Populates administrative departments and staff

DO $$
DECLARE
    -- Administrative Department IDs
    hr_dept_id UUID := 'd1000000-0000-4000-a000-000000000010';
    finance_dept_id UUID := 'd1100000-0000-4000-a000-000000000011';
    it_dept_id UUID := 'd1200000-0000-4000-a000-000000000012';
    student_affairs_dept_id UUID := 'd1300000-0000-4000-a000-000000000013';
    facilities_dept_id UUID := 'd1400000-0000-4000-a000-000000000014';

    -- Admin Position IDs
    director_position_id UUID := '71000000-0000-4000-a000-000000000010';
    manager_position_id UUID := '71100000-0000-4000-a000-000000000011';
    specialist_position_id UUID := '71200000-0000-4000-a000-000000000012';
    coordinator_position_id UUID := '71300000-0000-4000-a000-000000000013';
    technician_position_id UUID := '71400000-0000-4000-a000-000000000014';

    -- Department head IDs
    hr_director_id UUID := 'e1000000-0000-4000-a000-000000000010';
    finance_director_id UUID := 'e1100000-0000-4000-a000-000000000011';
    it_director_id UUID := 'e1200000-0000-4000-a000-000000000012';
    student_affairs_director_id UUID := 'e1300000-0000-4000-a000-000000000013';
    facilities_director_id UUID := 'e1400000-0000-4000-a000-000000000014';
BEGIN
    -- Create administrative positions
    INSERT INTO hr.position (id, title, description) VALUES
    (director_position_id, 'Director', 'Leads and manages an administrative department'),
    (manager_position_id, 'Manager', 'Oversees operations within a department area'),
    (specialist_position_id, 'Specialist', 'Subject matter expert in specific area'),
    (coordinator_position_id, 'Coordinator', 'Organizes and coordinates departmental activities'),
    (technician_position_id, 'Technician', 'Provides technical support and services')
    ON CONFLICT (id) DO UPDATE
    SET title = EXCLUDED.title,
        description = EXCLUDED.description;

    -- Create Administrative Departments

    -- 1. Human Resources Department
    INSERT INTO hr.department (id, name, description)
    VALUES (hr_dept_id, 'Human Resources', 'Manages recruitment, employee relations, and personnel matters');

    -- 2. Finance Department
    INSERT INTO hr.department (id, name, description)
    VALUES (finance_dept_id, 'Finance & Accounting', 'Handles financial operations, budgeting, and accounting');

    -- 3. IT Department
    INSERT INTO hr.department (id, name, description)
    VALUES (it_dept_id, 'Information Technology', 'Provides technology infrastructure and support services');

    -- 4. Student Affairs
    INSERT INTO hr.department (id, name, description)
    VALUES (student_affairs_dept_id, 'Student Affairs', 'Supports student life, activities, and well-being');

    -- 5. Facilities Management
    INSERT INTO hr.department (id, name, description)
    VALUES (facilities_dept_id, 'Facilities Management', 'Maintains campus buildings, grounds, and infrastructure');

    -- Add Department Directors

    -- HR Director
    PERFORM hr.add_employee_with_position(
        hr_director_id,
        'Carmen',
        'Jimenez',
        'administrative',
        hr_dept_id,
        director_position_id,
        TRUE,
        '2019-03-15'
    );

    -- Finance Director
    PERFORM hr.add_employee_with_position(
        finance_director_id,
        'Javier',
        'Morales',
        'administrative',
        finance_dept_id,
        director_position_id,
        TRUE,
        '2018-05-10'
    );

    -- IT Director
    PERFORM hr.add_employee_with_position(
        it_director_id,
        'Fernando',
        'Ramos',
        'administrative',
        it_dept_id,
        director_position_id,
        TRUE,
        '2020-01-20'
    );

    -- Student Affairs Director
    PERFORM hr.add_employee_with_position(
        student_affairs_director_id,
        'Ana',
        'Garcia',
        'administrative',
        student_affairs_dept_id,
        director_position_id,
        TRUE,
        '2019-08-05'
    );

    -- Facilities Director
    PERFORM hr.add_employee_with_position(
        facilities_director_id,
        'Ricardo',
        'Fuentes',
        'administrative',
        facilities_dept_id,
        director_position_id,
        TRUE,
        '2018-11-12'
    );

    -- Update departments with heads
    UPDATE hr.department SET head_id = hr_director_id WHERE id = hr_dept_id;
    UPDATE hr.department SET head_id = finance_director_id WHERE id = finance_dept_id;
    UPDATE hr.department SET head_id = it_director_id WHERE id = it_dept_id;
    UPDATE hr.department SET head_id = student_affairs_director_id WHERE id = student_affairs_dept_id;
    UPDATE hr.department SET head_id = facilities_director_id WHERE id = facilities_dept_id;

    -- Add Staff to HR Department
    PERFORM hr.add_employee_with_position(
        'e2000000-0000-4000-a000-000000000020',
        'Patricia',
        'Lopez',
        'administrative',
        hr_dept_id,
        manager_position_id,
        TRUE,
        '2020-03-10'
    );

    PERFORM hr.add_employee_with_position(
        'e2001000-0000-4000-a000-000000000021',
        'Manuel',
        'Rodriguez',
        'administrative',
        hr_dept_id,
        specialist_position_id,
        TRUE,
        '2021-06-15'
    );

    -- Add Staff to Finance Department
    PERFORM hr.add_employee_with_position(
        'e2100000-0000-4000-a000-000000000022',
        'Isabel',
        'Diaz',
        'administrative',
        finance_dept_id,
        manager_position_id,
        TRUE,
        '2019-11-05'
    );

    PERFORM hr.add_employee_with_position(
        'e2101000-0000-4000-a000-000000000023',
        'Victor',
        'Navarro',
        'administrative',
        finance_dept_id,
        specialist_position_id,
        TRUE,
        '2020-09-20'
    );

    -- Add Staff to IT Department
    PERFORM hr.add_employee_with_position(
        'e2200000-0000-4000-a000-000000000024',
        'Lucia',
        'Reyes',
        'technical_support',
        it_dept_id,
        manager_position_id,
        TRUE,
        '2020-02-15'
    );

    PERFORM hr.add_employee_with_position(
        'e2201000-0000-4000-a000-000000000025',
        'Andres',
        'Soto',
        'technical_support',
        it_dept_id,
        technician_position_id,
        TRUE,
        '2021-04-10'
    );

    PERFORM hr.add_employee_with_position(
        'e2202000-0000-4000-a000-000000000026',
        'Diana',
        'Medina',
        'technical_support',
        it_dept_id,
        technician_position_id,
        TRUE,
        '2022-01-15'
    );

    -- Add Staff to Student Affairs
    PERFORM hr.add_employee_with_position(
        'e2300000-0000-4000-a000-000000000027',
        'Gabriel',
        'Ortiz',
        'administrative',
        student_affairs_dept_id,
        coordinator_position_id,
        TRUE,
        '2020-08-10'
    );

    PERFORM hr.add_employee_with_position(
        'e2301000-0000-4000-a000-000000000028',
        'Margarita',
        'Vargas',
        'administrative',
        student_affairs_dept_id,
        coordinator_position_id,
        TRUE,
        '2021-09-05'
    );

    -- Add Staff to Facilities
    PERFORM hr.add_employee_with_position(
        'e2400000-0000-4000-a000-000000000029',
        'Oscar',
        'Mendez',
        'facilities',
        facilities_dept_id,
        manager_position_id,
        TRUE,
        '2019-10-15'
    );

    PERFORM hr.add_employee_with_position(
        'e2401000-0000-4000-a000-000000000030',
        'Teresa',
        'Castro',
        'facilities',
        facilities_dept_id,
        technician_position_id,
        TRUE,
        '2020-05-20'
    );

    PERFORM hr.add_employee_with_position(
        'e2402000-0000-4000-a000-000000000031',
        'Hector',
        'Rios',
        'facilities',
        facilities_dept_id,
        technician_position_id,
        TRUE,
        '2021-03-10'
    );

    RAISE NOTICE 'Administrative departments and staff successfully created';
END $$;