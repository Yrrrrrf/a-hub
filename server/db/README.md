# Academic Hub Database

This directory contains the PostgreSQL database implementation for Academic Hub, providing a structured and efficient data storage system for the entire application.

## Architecture Overview

The Academic Hub database is built on PostgreSQL, using a modular schema approach to organize data logically and maintain clear separation of concerns. The database includes:

- **Multiple specialized schemas** for different domain areas
- **Custom types and enums** for data validation and consistency
- **Helper functions** for data manipulation and cross-schema operations
- **Database views** for simplified data access patterns
- **Triggers and constraints** for data integrity

## Schema Structure

The database is organized into several specialized schemas:

| Schema | Purpose |
|--------|---------|
| `account` | User profiles, roles, and account management |
| `auth` | Authentication and authorization |
| `agnostic` | Shared concepts across modules (topics, tags) |
| `infrastruct` | Physical infrastructure (buildings, rooms, facilities) |
| `hr` | Human resources and personnel management |
| `academic` | Academic programs, courses, and curriculum |
| `course_offer` | Course scheduling and teaching assignments |
| `student` | Student records and academic progress |
| `library` | Library resources and management |

## Initialization Scripts

The `init/` directory contains scripts that run when the database container starts:

```
init/
├── 01-setup/       # Schema and role creation
├── 02-tables/      # Table definitions for each schema
├── 03-data/        # Sample data population scripts
├── 04-views/       # Database views
└── 05-functions/   # Helper functions and stored procedures
```

### Script Execution Order

Scripts execute in numerical order (01 → 05), with further ordering within each directory. This ensures dependencies are satisfied during initialization.

## Key Features

### Modular Schema Design
Each schema focuses on a specific domain, making the database more maintainable and allowing for independent development of different modules.

### UUID Primary Keys
All entities use UUID primary keys for better distribution, security, and flexibility in data management.

### Rich Data Types
Custom enum types ensure data consistency for fields like room types, job categories, and course categories.

## Database Management

### Access Information
- **Port:** 5432 (default PostgreSQL port)
- **Default Database:** `a_hub`
- **Default Admin User:** `a_hub_admin`

### Direct Connection

To connect directly to the database for development or troubleshooting:

```bash
# Using Docker
docker exec -it a-hub-db psql -U a_hub_admin -d a_hub

# From host with PostgreSQL client
psql -h localhost -U a_hub_admin -d a_hub
```

## Extending the Database

When adding new features to the database:

1. Place table definitions in the appropriate schema file in `02-tables/`
2. Add helper functions in `05-functions/` 
3. Add any initial data in `03-data/`
4. Follow the existing naming conventions and structure

<!--
## Backup and Restore

The database is configured to store data in a Docker volume for persistence.

```bash
# Backup the database
docker exec -t a-hub-db pg_dump -U a_hub_admin a_hub > backup.sql

# Restore from backup
cat backup.sql | docker exec -i a-hub-db psql -U a_hub_admin -d a_hub
```
-->
