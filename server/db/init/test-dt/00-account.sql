DO $$
DECLARE
    admin_id UUID := 'a1111111-1111-4111-1111-111111111111';
    staff_id UUID := 'a2222222-2222-4222-2222-222222222222';
    teacher_id UUID := 'a3333333-3333-4333-3333-333333333333';
    student_id UUID := 'a4444444-4444-4444-4444-444444444444';
BEGIN
    -- Insert roles
    INSERT INTO account.roles (id, name, description, permissions) VALUES
    ('11111111-1111-4111-1111-111111111111', 'admin', 'System Administrator', '{"all": true}'::jsonb),
    ('22222222-2222-4222-2222-222222222222', 'staff', 'Staff Member', '{"users": {"read": true}, "content": {"write": true}}'::jsonb),
    ('33333333-3333-4333-3333-333333333333', 'teacher', 'Teacher/Professor', '{"courses": {"manage": true}, "grades": {"write": true}}'::jsonb),
    ('44444444-4444-4444-4444-444444444444', 'student', 'Student', '{"courses": {"read": true}, "assignments": {"submit": true}}'::jsonb)
    ON CONFLICT (id) DO NOTHING;

    -- Insert user profiles
    INSERT INTO account.profile (id, username, email, full_name, status) VALUES
    (admin_id, 'admin', 'admin@academichub.edu', 'System Administrator', 'active'),
    (staff_id, 'staff', 'staff@academichub.edu', 'Staff Member', 'active'),
    (teacher_id, 'teacher', 'teacher@academichub.edu', 'Professor Smith', 'active'),
    (student_id, 'student', 'student@academichub.edu', 'John Student', 'active')
    ON CONFLICT (id) DO NOTHING;

    -- Insert preferences
    INSERT INTO account.preferences (user_id, theme, language, notifications, settings) VALUES
    (admin_id, 'dark', 'en', '{"email": true, "push": true}'::jsonb, '{"dashboard": "admin"}'::jsonb),
    (staff_id, 'light', 'es', '{"email": true, "push": false}'::jsonb, '{"dashboard": "staff"}'::jsonb),
    (teacher_id, 'system', 'en', '{"email": true, "push": true}'::jsonb, '{"dashboard": "academic"}'::jsonb),
    (student_id, 'dark', 'en', '{"email": true, "push": true}'::jsonb, '{"dashboard": "student"}'::jsonb)
    ON CONFLICT (user_id) DO NOTHING;

    -- Associate users with roles
    INSERT INTO account.user_roles (user_id, role_id, assigned_by) VALUES
    (admin_id, '11111111-1111-4111-1111-111111111111', admin_id),
    (staff_id, '22222222-2222-4222-2222-222222222222', admin_id),
    (teacher_id, '33333333-3333-4333-3333-333333333333', admin_id),
    (student_id, '44444444-4444-4444-4444-444444444444', admin_id)
    ON CONFLICT (user_id, role_id) DO NOTHING;

END $$;