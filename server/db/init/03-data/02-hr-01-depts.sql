-- File: 02-hr-01-academic.sql
-- Creates academic departments aligned with existing faculties

DO $$
DECLARE
    engineering_faculty_id UUID := 'f0000000-0000-4000-a000-000000000001';
    architecture_faculty_id UUID := 'f1000000-0000-4000-a000-000000000002';
    
    -- Department IDs (academic)
    engineering_dept_id UUID := 'd0100000-0000-4000-a000-000000000001';
    computer_science_dept_id UUID := 'd0200000-0000-4000-a000-000000000002';
    civil_engineering_dept_id UUID := 'd0300000-0000-4000-a000-000000000003';
    architecture_dept_id UUID := 'd0400000-0000-4000-a000-000000000004';
    design_dept_id UUID := 'd0500000-0000-4000-a000-000000000005';
    
    -- Position IDs (academic)
    dean_position_id UUID := '70100000-0000-4000-a000-000000000001';
    dept_head_position_id UUID := '70200000-0000-4000-a000-000000000002';
    professor_position_id UUID := '70300000-0000-4000-a000-000000000003';
    assoc_professor_position_id UUID := '70400000-0000-4000-a000-000000000004';
    assist_professor_position_id UUID := '70500000-0000-4000-a000-000000000005';
    instructor_position_id UUID := '70600000-0000-4000-a000-000000000006';
    researcher_position_id UUID := '70700000-0000-4000-a000-000000000007';
    
    -- Faculty member IDs
    dean_engineering_id UUID := 'e0100000-0000-4000-a000-000000000001';
    dean_architecture_id UUID := 'e0200000-0000-4000-a000-000000000002';
    comp_sci_head_id UUID := 'e0300000-0000-4000-a000-000000000003';
    civil_eng_head_id UUID := 'e0400000-0000-4000-a000-000000000004';
    arch_head_id UUID := 'e0500000-0000-4000-a000-000000000005';
    design_head_id UUID := 'e0600000-0000-4000-a000-000000000006';
BEGIN
    -- Create academic positions
    PERFORM hr.add_position(
        dean_position_id, 
        'Dean', 
        'Oversees an entire faculty, manages academic and administrative affairs'
    );
    
    PERFORM hr.add_position(
        dept_head_position_id, 
        'Department Head', 
        'Manages a specific academic department within a faculty'
    );
    
    PERFORM hr.add_position(
        professor_position_id, 
        'Professor', 
        'Senior academic with teaching and research responsibilities'
    );
    
    PERFORM hr.add_position(
        assoc_professor_position_id, 
        'Associate Professor', 
        'Mid-level faculty with teaching and research roles'
    );
    
    PERFORM hr.add_position(
        assist_professor_position_id, 
        'Assistant Professor', 
        'Early-career faculty member'
    );
    
    PERFORM hr.add_position(
        instructor_position_id, 
        'Instructor', 
        'Teaching-focused faculty member'
    );
    
    PERFORM hr.add_position(
        researcher_position_id, 
        'Researcher', 
        'Primarily conducts research with limited teaching duties'
    );
    
    -- Create Engineering Faculty departments
    PERFORM hr.create_faculty_department(
        engineering_faculty_id,
        engineering_dept_id,
        'Engineering Department',
        'Main administrative department for the Engineering Faculty'
    );
    
    PERFORM hr.create_faculty_department(
        engineering_faculty_id,
        computer_science_dept_id,
        'Computer Science Department',
        'Department focused on computer science and software engineering'
    );
    
    PERFORM hr.create_faculty_department(
        engineering_faculty_id,
        civil_engineering_dept_id,
        'Civil Engineering Department',
        'Department focused on civil engineering and infrastructure'
    );
    
    -- Create Architecture Faculty departments
    PERFORM hr.create_faculty_department(
        architecture_faculty_id,
        architecture_dept_id,
        'Architecture Department',
        'Main department for architectural studies'
    );
    
    PERFORM hr.create_faculty_department(
        architecture_faculty_id,
        design_dept_id,
        'Design Department',
        'Department focused on design principles and applications'
    );
    
    -- Create key academic leadership
    -- Deans
    PERFORM hr.add_employee_with_position(
        dean_engineering_id,
        'Roberto',
        'Martínez',
        'faculty',
        engineering_dept_id,
        dean_position_id,
        TRUE,
        '2020-08-01'
    );
    
    PERFORM hr.add_employee_with_position(
        dean_architecture_id,
        'Sofia',
        'Hernández',
        'faculty',
        architecture_dept_id,
        dean_position_id,
        TRUE,
        '2019-06-15'
    );
    
    -- Department Heads
    PERFORM hr.add_employee_with_position(
        comp_sci_head_id,
        'Carlos',
        'Vega',
        'faculty',
        computer_science_dept_id,
        dept_head_position_id,
        TRUE,
        '2021-01-10'
    );
    
    PERFORM hr.add_employee_with_position(
        civil_eng_head_id,
        'Mariana',
        'Rojas',
        'faculty',
        civil_engineering_dept_id,
        dept_head_position_id,
        TRUE,
        '2022-03-01'
    );
    
    PERFORM hr.add_employee_with_position(
        arch_head_id,
        'Daniel',
        'Luna',
        'faculty',
        architecture_dept_id,
        dept_head_position_id,
        TRUE,
        '2020-09-01'
    );
    
    PERFORM hr.add_employee_with_position(
        design_head_id,
        'Laura',
        'Mendoza',
        'faculty',
        design_dept_id,
        dept_head_position_id,
        TRUE,
        '2021-07-15'
    );
    
    -- Update departments with their heads
    UPDATE hr.department SET head_id = comp_sci_head_id WHERE id = computer_science_dept_id;
    UPDATE hr.department SET head_id = civil_eng_head_id WHERE id = civil_engineering_dept_id;
    UPDATE hr.department SET head_id = arch_head_id WHERE id = architecture_dept_id;
    UPDATE hr.department SET head_id = design_head_id WHERE id = design_dept_id;
    UPDATE hr.department SET head_id = dean_engineering_id WHERE id = engineering_dept_id;
    UPDATE hr.department SET head_id = dean_architecture_id WHERE id = architecture_dept_id;
    
    RAISE NOTICE 'Academic departments and leadership positions created successfully';
END $$;