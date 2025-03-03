-- File: 02-hr-00-fn.sql
-- Functions for populating the HR schema with department, position, and employee data

-- Function to add a department with optional head
CREATE OR REPLACE FUNCTION hr.add_department(
    p_id UUID,
    p_name VARCHAR(100),
    p_description TEXT,
    p_head_id UUID DEFAULT NULL
) RETURNS UUID AS $$
DECLARE
    v_department_id UUID;
BEGIN
    INSERT INTO hr.department (id, name, description, head_id)
    VALUES (p_id, p_name, p_description, p_head_id)
    ON CONFLICT (id) DO UPDATE
    SET name = EXCLUDED.name,
        description = EXCLUDED.description,
        head_id = EXCLUDED.head_id
    RETURNING id INTO v_department_id;
    
    RAISE NOTICE 'Department "%" added successfully', p_name;
    RETURN v_department_id;
END;
$$ LANGUAGE plpgsql;

-- Function to add a job position
CREATE OR REPLACE FUNCTION hr.add_position(
    p_id UUID,
    p_title VARCHAR(100),
    p_description TEXT
) RETURNS UUID AS $$
DECLARE
    v_position_id UUID;
BEGIN
    INSERT INTO hr.position (id, title, description)
    VALUES (p_id, p_title, p_description)
    ON CONFLICT (id) DO UPDATE
    SET title = EXCLUDED.title,
        description = EXCLUDED.description
    RETURNING id INTO v_position_id;
    
    RAISE NOTICE 'Position "%" added successfully', p_title;
    RETURN v_position_id;
END;
$$ LANGUAGE plpgsql;

-- Function to add an employee
CREATE OR REPLACE FUNCTION hr.add_employee(
    p_id UUID,
    p_first_name VARCHAR(50),
    p_last_name VARCHAR(50),
    p_job_category hr.job_category,
    p_department_id UUID,
    p_hire_date DATE DEFAULT CURRENT_DATE,
    p_is_active BOOLEAN DEFAULT TRUE
) RETURNS UUID AS $$
DECLARE
    v_employee_id UUID;
BEGIN
    INSERT INTO hr.employee (
        id, 
        first_name, 
        last_name, 
        hire_date, 
        job_category, 
        department_id, 
        is_active
    )
    VALUES (
        p_id, 
        p_first_name, 
        p_last_name, 
        p_hire_date, 
        p_job_category, 
        p_department_id, 
        p_is_active
    )
    ON CONFLICT (id) DO UPDATE
    SET first_name = EXCLUDED.first_name,
        last_name = EXCLUDED.last_name,
        hire_date = EXCLUDED.hire_date,
        job_category = EXCLUDED.job_category,
        department_id = EXCLUDED.department_id,
        is_active = EXCLUDED.is_active
    RETURNING id INTO v_employee_id;
    
    RAISE NOTICE 'Employee % % added successfully', p_first_name, p_last_name;
    RETURN v_employee_id;
END;
$$ LANGUAGE plpgsql;

-- Function to assign position to employee
CREATE OR REPLACE FUNCTION hr.assign_position(
    p_employee_id UUID,
    p_position_id UUID,
    p_start_date DATE DEFAULT CURRENT_DATE,
    p_end_date DATE DEFAULT NULL,
    p_is_primary BOOLEAN DEFAULT TRUE
) RETURNS UUID AS $$
DECLARE
    v_assignment_id UUID;
BEGIN
    -- Check if employee already has a primary position and we're setting another
    IF p_is_primary = TRUE THEN
        -- Update any existing primary positions to non-primary
        UPDATE hr.employee_position
        SET is_primary = FALSE
        WHERE employee_id = p_employee_id 
          AND is_primary = TRUE
          AND (end_date IS NULL OR end_date > CURRENT_DATE);
    END IF;

    INSERT INTO hr.employee_position (
        employee_id,
        position_id,
        start_date,
        end_date,
        is_primary
    )
    VALUES (
        p_employee_id,
        p_position_id,
        p_start_date,
        p_end_date,
        p_is_primary
    )
    RETURNING id INTO v_assignment_id;
    
    RAISE NOTICE 'Position assignment created successfully';
    RETURN v_assignment_id;
END;
$$ LANGUAGE plpgsql;

-- Function to add an employee with position in one operation
CREATE OR REPLACE FUNCTION hr.add_employee_with_position(
    p_employee_id UUID,
    p_first_name VARCHAR(50),
    p_last_name VARCHAR(50),
    p_job_category hr.job_category,
    p_department_id UUID,
    p_position_id UUID,
    p_is_primary BOOLEAN DEFAULT TRUE,
    p_hire_date DATE DEFAULT CURRENT_DATE,
    p_is_active BOOLEAN DEFAULT TRUE
) RETURNS UUID AS $$
DECLARE
    v_employee_id UUID;
BEGIN
    -- First add the employee
    v_employee_id := hr.add_employee(
        p_employee_id,
        p_first_name,
        p_last_name,
        p_job_category,
        p_department_id,
        p_hire_date,
        p_is_active
    );
    
    -- Then assign the position
    PERFORM hr.assign_position(
        v_employee_id,
        p_position_id,
        p_hire_date,
        NULL,
        p_is_primary
    );
    
    RETURN v_employee_id;
END;
$$ LANGUAGE plpgsql;

-- Function to create a faculty-aligned academic department
CREATE OR REPLACE FUNCTION hr.create_faculty_department(
    p_faculty_id UUID,
    p_department_id UUID,
    p_department_name VARCHAR(100),
    p_description TEXT DEFAULT NULL
) RETURNS UUID AS $$
DECLARE
    v_department_id UUID;
    v_faculty_name VARCHAR(255);
BEGIN
    -- Get faculty name for better description if not provided
    SELECT name INTO v_faculty_name FROM infrastruct.faculty WHERE id = p_faculty_id;
    
    IF p_description IS NULL THEN
        p_description := 'Academic department aligned with the ' || v_faculty_name || ' faculty';
    END IF;
    
    -- Create the department
    v_department_id := hr.add_department(
        p_department_id,
        p_department_name,
        p_description,
        NULL  -- Head will be set later
    );
    
    RAISE NOTICE 'Faculty-aligned department "%" created successfully', p_department_name;
    RETURN v_department_id;
END;
$$ LANGUAGE plpgsql;
