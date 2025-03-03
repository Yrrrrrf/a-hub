# Academic Hub API

This directory contains the FastAPI implementation that powers the Academic Hub's backend services, providing RESTful endpoints for the frontend application.

## Architecture Overview

The Academic Hub API is built with FastAPI and utilizes DBForge for easier database interaction. The API follows modern backend development practices:

- **REST-based API design** for intuitive resource management
- **Automatic API documentation** with OpenAPI and Swagger UI
- **Type safety** through Pydantic models and Python type hints
- **Modular architecture** for maintainability and scalability
- **Containerized deployment** for consistent environments
- **Asynchronous request handling** for better performance

## Key Components

### prism-py

The API uses [`prism-py`](https://github.com/Yrrrrrf/prism-py) automatically generates API routes based on database models.

```python
# From main.py
# Initialize API generator
api_prism = ApiPrism(
    config=PrismConfig(
        project_name=f"{db_client.config.database}Hub",
        version="0.1.0",
    ),
    app=app,
)

# Generate metadata routes
api_prism.gen_metadata_routes(model_manager)
api_prism.gen_health_routes(model_manager)
api_prism.gen_table_routes(model_manager)
api_prism.gen_view_routes(model_manager)
api_prism.gen_fn_routes(model_manager)
```

### Metadata Router

The metadata router (`get_metadata_router`) exposes database schema information, providing details about:
- Available tables and their structures
- Available database views
- Table relationships
- API endpoints

## API Documentation

When the API is running, interactive documentation is available at:

- **Swagger UI:** http://localhost:8000/docs
- **ReDoc:** http://localhost:8000/redoc

## Environment Configuration

The API can be configured through environment variables:

| Variable | Description | Default |
|----------|-------------|---------|
| `DB_NAME` | Database name | `a_hub` |
| `DB_HOST` | Database hostname | `localhost` |
| `DB_OWNER_ADMIN` | Database user | `a_hub_admin` |
| `DB_OWNER_PWORD` | Database password | `password` |
| `DB_PORT` | Database port | `5432` |

## Development

### Running Locally

To run the API locally during development:

```bash
# Install dependencies
pip install -r requirements.txt

# Run with hot reload
uvicorn src.main:app --reload
```

### Using Docker (recommended)

The API is containerized for easy deployment:

```bash
# Build and start with Docker Compose
docker-compose up --build

# Or build just the API
docker build -f api.Dockerfile -t academic-hub-api .
```

## Testing

The test directory contains test suites for API functionality:

```bash
# Run all tests
pytest test/

# Run specific test
python test/00-app.py
```