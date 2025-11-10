# Academic Hub Server

This directory contains the server-side components of Academic Hub, consisting of a FastAPI backend and a PostgreSQL database.

## Overview

The server is split into two main components:

### 1. API ([FastAPI](https://fastapi.tiangolo.com/))

Located in [`/server/api`](./api/), this is our REST API built with FastAPI that handles all client requests. It provides:

- Automatic API documentation (available at `/docs` when running)
- Built-in request validation
- Easy-to-extend route structure
- Efficient data processing using async operations

### 2. Database ([PostgreSQL](https://www.postgresql.org/))

Located in [`/server/db`](./db/), this is our database system that stores and manages all application data. It features:

- Well-organized schema structure
- Automated initialization scripts
- Built-in data validation
- Efficient data relationships

## Project Structure

```sh
server/
├── api/                 # API implementation
│   ├── src/             # API source code (FastAPI + prism-py)
│   ├── requirements.txt # Python dependencies
│   └── api.Dockerfile   # API container configuration
│
└── db/                 # Database implementation
    ├── init/          # DB initialization scripts
    ├── scripts/       # DB management scripts
    └── db.Dockerfile  # DB container configuration
```

## Getting Started

1. **Environment Setup**
   Create a `.env` file in the project root with:
   ```sh
   DB_NAME=a_hub
   DB_OWNER_ADMIN=a_hub_admin
   DB_OWNER_PWORD=password
   DB_HOST=localhost
   ```

2. **Using Docker (Recommended)**

   Just run:
   ```sh
   docker-compose up --build
   ```

   This will start both the API and database services.

3. **Access Points**

   - API Documentation: http://localhost:8000/docs
   - API Base URL: http://localhost:8000
   - Database Port: 5432
