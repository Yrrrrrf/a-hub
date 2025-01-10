-- File: 00-setup-db.sql

-- Enable psql command echoing and stop on error
\set ON_ERROR_STOP on
\set ECHO all

-- Set variables for the db_owner and db_owner_password
DO $$
DECLARE
    db_owner TEXT := 'a_hub_admin';
    db_owner_password TEXT := 'password'; -- TODO: Use more secure method in production
BEGIN
    -- Create role if it doesn't exist, or update if it does
    IF EXISTS (SELECT FROM pg_roles WHERE rolname = db_owner) THEN
        EXECUTE format('ALTER ROLE %I WITH PASSWORD %L CREATEROLE', db_owner, db_owner_password);
        RAISE NOTICE 'Password updated and CREATEROLE granted for existing role %', db_owner;
    ELSE
        EXECUTE format('CREATE ROLE %I LOGIN PASSWORD %L CREATEROLE', db_owner, db_owner_password);
        RAISE NOTICE 'Role % created successfully with CREATEROLE permission', db_owner;
    END IF;

    -- Grant necessary permissions to the role
    EXECUTE format('ALTER ROLE %I WITH CREATEDB', db_owner);
    RAISE NOTICE 'CREATEDB permission granted to role %', db_owner;
END $$;

-- Terminate existing connections to the database if it exists
SELECT pg_terminate_backend(pid)
FROM pg_stat_activity
WHERE datname = 'a_hub';

-- Check if the database exists
SELECT EXISTS(SELECT 1 FROM pg_database WHERE datname = 'a_hub') AS db_exists \gset

-- Create the database if it doesn't exist
\if :db_exists
    \echo 'Database a_hub already exists'
\else
    CREATE DATABASE a_hub
    WITH
    OWNER = a_hub_admin
    ENCODING = 'UTF8'
    LC_COLLATE = 'en_US.UTF-8'
    LC_CTYPE = 'en_US.UTF-8'
    TEMPLATE = template0
    CONNECTION LIMIT = -1;

    \echo 'Database a_hub created successfully'
\endif

-- Connect to the new database
\c a_hub

-- Set database parameters and grant permissions
ALTER DATABASE a_hub SET search_path TO public;

-- Grant permissions to the owner role
DO $$
BEGIN
    EXECUTE format('GRANT ALL PRIVILEGES ON DATABASE a_hub TO a_hub_admin');
    EXECUTE format('GRANT ALL PRIVILEGES ON SCHEMA public TO a_hub_admin');
    EXECUTE format('ALTER DEFAULT PRIVILEGES FOR ROLE a_hub_admin IN SCHEMA public GRANT ALL PRIVILEGES ON TABLES TO a_hub_admin');
    EXECUTE format('ALTER DEFAULT PRIVILEGES FOR ROLE a_hub_admin IN SCHEMA public GRANT ALL PRIVILEGES ON SEQUENCES TO a_hub_admin');
    EXECUTE format('ALTER DEFAULT PRIVILEGES FOR ROLE a_hub_admin IN SCHEMA public GRANT ALL PRIVILEGES ON FUNCTIONS TO a_hub_admin');
    EXECUTE format('ALTER DEFAULT PRIVILEGES FOR ROLE a_hub_admin IN SCHEMA public GRANT ALL PRIVILEGES ON TYPES TO a_hub_admin');

    REVOKE ALL PRIVILEGES ON DATABASE a_hub FROM postgres;
    REVOKE ALL PRIVILEGES ON SCHEMA public FROM postgres;
    REVOKE ALL PRIVILEGES ON ALL TABLES IN SCHEMA public FROM postgres;
    REVOKE ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public FROM postgres;
    REVOKE ALL PRIVILEGES ON ALL FUNCTIONS IN SCHEMA public FROM postgres;
    ALTER USER a_hub_admin WITH SUPERUSER;
END $$;

-- Enable necessary extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";
CREATE EXTENSION IF NOT EXISTS "pg_trgm";

\echo 'A-HUB database setup completed successfully'
