-- File: 02_infrastruct_views.sql

-- View to show all buildings with their facility types
CREATE OR REPLACE VIEW infrastruct.building_facilities AS
SELECT b.id AS building_id, b.name AS building_name, b.address, 
       f.id AS facility_id, f.facility_type
FROM infrastruct.building b
LEFT JOIN infrastruct.facility f ON b.id = f.building_id;

-- View to show faculties and their associated buildings
CREATE OR REPLACE VIEW infrastruct.faculty_buildings AS
SELECT f.id AS faculty_id, f.name AS faculty_name, 
       b.id AS building_id, b.name AS building_name, b.address
FROM infrastruct.faculty f
JOIN infrastruct.faculty_building fb ON f.id = fb.faculty_id
JOIN infrastruct.building b ON fb.building_id = b.id;

-- View to show room utilization by building
CREATE OR REPLACE VIEW infrastruct.room_utilization AS
SELECT b.id AS building_id, b.name AS building_name, 
       r.room_type, COUNT(*) AS room_count, SUM(r.capacity) AS total_capacity
FROM infrastruct.building b
JOIN infrastruct.room r ON b.id = r.building_id
GROUP BY b.id, b.name, r.room_type;

-- View to show faculties with libraries
CREATE OR REPLACE VIEW infrastruct.faculty_libraries AS
SELECT f.id AS faculty_id, f.name AS faculty_name, 
       b.id AS building_id, b.name AS building_name, 
       fac.id AS library_id
FROM infrastruct.faculty f
JOIN infrastruct.faculty_building fb ON f.id = fb.faculty_id
JOIN infrastruct.building b ON fb.building_id = b.id
JOIN infrastruct.facility fac ON b.id = fac.building_id
WHERE fac.facility_type = 'library';
