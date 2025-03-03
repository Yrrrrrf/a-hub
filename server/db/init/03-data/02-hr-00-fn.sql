-- File: 02-hr-00-fn.sql
-- Only the high-value compound functions that perform multiple operations

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
    -- Directly insert the employee
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
        p_employee_id, 
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
    
    -- Handle the position assignment
    IF p_is_primary = TRUE THEN
        -- Update any existing primary positions to non-primary
        UPDATE hr.employee_position
        SET is_primary = FALSE
        WHERE employee_id = v_employee_id 
          AND is_primary = TRUE
          AND (end_date IS NULL OR end_date > CURRENT_DATE);
    END IF;

    -- Directly assign position
    INSERT INTO hr.employee_position (
        employee_id,
        position_id,
        start_date,
        is_primary
    )
    VALUES (
        v_employee_id,
        p_position_id,
        p_hire_date,
        p_is_primary
    );
    
    RAISE NOTICE 'Employee % % added with position successfully', p_first_name, p_last_name;
    RETURN v_employee_id;
END;
$$ LANGUAGE plpgsql;

-- Function to create a faculty-aligned department 
CREATE OR REPLACE FUNCTION hr.create_faculty_department(
    p_faculty_id UUID,
    p_department_id UUID,
    p_department_name VARCHAR(100),
    p_description TEXT DEFAULT NULL
) RETURNS UUID AS $$
DECLARE
    v_faculty_name VARCHAR(255);
BEGIN
    -- Get faculty name for better description if not provided
    SELECT name INTO v_faculty_name FROM infrastruct.faculty WHERE id = p_faculty_id;
    
    IF p_description IS NULL THEN
        p_description := 'Academic department aligned with the ' || v_faculty_name || ' faculty';
    END IF;
    
    -- Directly create the department
    INSERT INTO hr.department (id, name, description, head_id)
    VALUES (p_department_id, p_department_name, p_description, NULL)
    ON CONFLICT (id) DO UPDATE
    SET name = EXCLUDED.name,
        description = EXCLUDED.description;
    
    RAISE NOTICE 'Faculty-aligned department "%" created successfully', p_department_name;
    RETURN p_department_id;
END;
$$ LANGUAGE plpgsql;
