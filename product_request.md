# VibeGIS Product Request

## AI Agent-Friendly Geospatial Platform POC

### Overall Architecture Strategy
Given AI agents will be building this, I'm designing for maximum modularity, clear interfaces, and well-established patterns that agents can implement reliably.

### POC Architecture
```
┌─────────────────────────────────────────────────────────────┐
│                    Frontend Tier                            │
├─────────────────────────────────────────────────────────────┤
│                    API Gateway Tier                         │
├─────────────────────────────────────────────────────────────┤
│                    Service Tier                             │
├─────────────────────────────────────────────────────────────┤
│                    Data Processing Tier                     │
├─────────────────────────────────────────────────────────────┤
│                    Storage Tier                             │
└─────────────────────────────────────────────────────────────┘
```

## Tier Specifications

### Frontend Tier
**Technology Stack:**
- Next.js 14 with TypeScript
- Mapbox GL JS for mapping
- Shadcn/ui for components
- TanStack Query for state management

**AI Agent Implementation:**
- Single-page application with clear component boundaries
- OpenAPI client generation for type safety
- Standardized folder structure (/pages, /components, /hooks, /utils)

### API Gateway Tier
**Technology Stack:**
- FastAPI with automatic OpenAPI generation
- Pydantic models for request/response validation
- JWT authentication middleware
- Rate limiting and CORS handling

**AI Agent Implementation:**
- REST endpoints following OpenAPI 3.0 specification
- Automatic documentation generation
- Clear error handling patterns
- Health check endpoints

### Service Tier
**Technology Stack:**
- FastAPI microservices architecture
- Async/await patterns throughout
- Dependency injection for database connections
- Background tasks with Celery

**Core Services:**
- Spatial Query Service - Handles geometric operations
- Data Ingestion Service - Processes incoming geospatial data
- LLM Interface Service - Natural language to spatial query translation
- User Management Service - Authentication and authorization

### Data Processing Tier
**Technology Stack:**
- Apache Airflow for orchestration
- Pandas + GeoPandas for data manipulation
- Apache Sedona for distributed processing
- Redis for caching and job queues

**AI Agent Implementation:**
- DAG-based workflows with clear task boundaries
- Containerized processing jobs
- Standardized data transformation patterns

### Storage Tier
**Technology Stack:**
- PostgreSQL with PostGIS extension
- MinIO (S3-compatible) for file storage
- Redis for session/cache storage
- GeoParquet files for analytical workloads