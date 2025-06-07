# VibeGIS Implementation Plan

## Executive Summary

This document outlines the comprehensive implementation plan for VibeGIS, a proof-of-concept geospatial information system built using a multi-agent architecture. The plan integrates perspectives from Product Owner, Architecture, Backend Development, Frontend Development, DevOps, and QA agents to create a coordinated approach to building the system.

VibeGIS will be implemented using a tiered architecture consisting of:
- Frontend Tier (Next.js, TypeScript, Mapbox GL JS)
- API Gateway Tier (FastAPI)
- Service Tier (FastAPI microservices)
- Data Processing Tier (Apache Airflow, GeoPandas)
- Storage Tier (PostgreSQL/PostGIS, MinIO, Redis)

## Project Priorities

### Highest Priority Features (P0)
1. Interactive Map Visualization
2. Basic Spatial Queries
3. User Authentication

### High Priority Features (P1)
1. Data Ingestion
2. Natural Language Queries
3. Basic Analytics

## 1. Product Requirements & Roadmap

### Key User Stories

#### Interactive Map Visualization
- As a user, I want to view geospatial data on an interactive map so I can understand geographic patterns
- As a user, I want to zoom, pan, and toggle different map layers so I can focus on relevant information

#### Basic Spatial Queries
- As a user, I want to search for locations by name or coordinates so I can quickly navigate to areas of interest
- As a user, I want to select an area and see basic statistics about that region so I can gain insights

#### User Authentication
- As a user, I want to create an account and log in so I can access personalized features
- As an administrator, I want to manage user permissions so I can control access to sensitive data

### Acceptance Criteria

#### Interactive Map Visualization
- Map loads with default layers within 3 seconds
- Users can zoom in/out and pan the map
- Layer toggle controls function correctly
- Map maintains performance with up to 1000 features displayed

#### Basic Spatial Queries
- Location search returns results within 1 second
- Area selection tools work on desktop and mobile
- Statistical calculations are accurate and match expected results
- Query results are displayed in a clear, readable format

#### User Authentication
- Registration flow works with email verification
- Login/logout functions correctly
- Password reset process functions properly
- Role-based permissions restrict access appropriately

### Success Metrics

#### Technical Metrics
- API response times under 500ms for 95% of requests
- Frontend load time under 3 seconds
- Successful processing of datasets up to 10MB in size
- System uptime of 99%

#### User Experience Metrics
- Task completion rate for core user stories above 90%
- User satisfaction score of 4/5 or higher in usability testing
- Time to complete common tasks under 1 minute

## 2. System Architecture

### Overall System Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    Client Applications                       │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────────────┐  │
│  │  Web Client │  │Mobile Client│  │   Admin Console     │  │
│  │  (Next.js)  │  │   (Future)  │  │                     │  │
│  └─────────────┘  └─────────────┘  └─────────────────────┘  │
└───────────────────────────────┬─────────────────────────────┘
                                │
                                ▼
┌─────────────────────────────────────────────────────────────┐
│                     API Gateway Layer                        │
│  ┌─────────────────────────────────────────────────────┐    │
│  │                FastAPI Gateway Service              │    │
│  │ ┌─────────────┐ ┌─────────────┐ ┌─────────────────┐ │    │
│  │ │Authentication│ │Rate Limiting│ │  Request Routing│ │    │
│  │ └─────────────┘ └─────────────┘ └─────────────────┘ │    │
│  └─────────────────────────────────────────────────────┘    │
└───────────────────────────────┬─────────────────────────────┘
                                │
                                ▼
┌─────────────────────────────────────────────────────────────┐
│                      Service Layer                           │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐          │
│  │Spatial Query│  │Data Ingestion│  │LLM Interface│          │
│  │   Service   │  │   Service    │  │   Service   │          │
│  └─────────────┘  └─────────────┘  └─────────────┘          │
│                                                             │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐          │
│  │User Management│ │Visualization│  │ Analytics   │          │
│  │   Service    │  │   Service   │  │   Service   │          │
│  └─────────────┘  └─────────────┘  └─────────────┘          │
└───────────────────────────────┬─────────────────────────────┘
                                │
                                ▼
┌─────────────────────────────────────────────────────────────┐
│                   Data Processing Layer                      │
│  ┌─────────────────────────────────────────────────────┐    │
│  │              Apache Airflow Orchestration           │    │
│  │ ┌─────────────┐ ┌─────────────┐ ┌─────────────────┐ │    │
│  │ │ETL Pipelines│ │Geospatial   │ │Data Aggregation │ │    │
│  │ │             │ │Processing   │ │and Analytics    │ │    │
│  │ └─────────────┘ └─────────────┘ └─────────────────┘ │    │
│  └─────────────────────────────────────────────────────┘    │
└───────────────────────────────┬─────────────────────────────┘
                                │
                                ▼
┌─────────────────────────────────────────────────────────────┐
│                     Storage Layer                            │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐          │
│  │ PostgreSQL/ │  │   MinIO     │  │   Redis     │          │
│  │   PostGIS   │  │ Object Store│  │             │          │
│  └─────────────┘  └─────────────┘  └─────────────┘          │
└─────────────────────────────────────────────────────────────┘
```

### API Design Principles

1. **RESTful Design**
   - Resource-oriented endpoints
   - Proper use of HTTP verbs (GET, POST, PUT, DELETE)
   - Consistent URL structure: `/api/v1/{resource}/{id}`
   - Appropriate status codes for responses

2. **API Versioning**
   - Version in URL path (e.g., `/api/v1/`)
   - Semantic versioning for breaking changes
   - Maintain backward compatibility when possible

3. **Documentation**
   - OpenAPI 3.0 specification
   - Auto-generated documentation with FastAPI
   - Examples for each endpoint
   - Authentication requirements clearly documented

4. **Request/Response Format**
   - JSON as primary data format
   - GeoJSON for geospatial data
   - Consistent response structure
   - Pagination for collection responses

### Data Models

#### Core Database Schema

```sql
-- Users and Authentication
CREATE TABLE users (
    id UUID PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    hashed_password VARCHAR(100) NOT NULL,
    full_name VARCHAR(100),
    is_active BOOLEAN DEFAULT TRUE,
    is_admin BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Data sources configuration
CREATE TABLE data_sources (
    id UUID PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    source_type VARCHAR(50) NOT NULL, -- 'file', 'api', 'database'
    connection_params JSONB,
    created_by UUID REFERENCES users(id),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Layer metadata
CREATE TABLE layers (
    id UUID PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    table_name VARCHAR(100) NOT NULL,
    geometry_column VARCHAR(50) DEFAULT 'geometry',
    geometry_type VARCHAR(50) NOT NULL, -- 'POINT', 'LINESTRING', 'POLYGON', etc.
    srid INTEGER NOT NULL,
    attributes JSONB, -- schema of non-geometry columns
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Example spatial data table
CREATE TABLE example_points (
    id UUID PRIMARY KEY,
    name VARCHAR(100),
    description TEXT,
    properties JSONB,
    geometry GEOMETRY(POINT, 4326) NOT NULL,
    created_by UUID REFERENCES users(id),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create spatial indexes
CREATE INDEX example_points_geometry_idx ON example_points USING GIST(geometry);
```

### Security Architecture

#### Authentication Framework
- JWT-based token authentication
- Token-based sessions with Redis backing
- Secure password hashing with bcrypt
- Multi-factor authentication support (future enhancement)

#### Authorization Model
- Role-Based Access Control (RBAC)
- Resource-level permissions for geospatial data
- Predefined roles: Admin, Editor, Viewer, Analyst

## 3. Backend Implementation

### Service Tier Implementation

#### Spatial Query Service

```python
# app/spatial_query/main.py
from fastapi import FastAPI, Depends, HTTPException
from pydantic import BaseModel
from typing import List, Dict, Any, Optional
from app.core.db import get_db_connection
from sqlalchemy.ext.asyncio import AsyncSession
from shapely.geometry import shape
import geopandas as gpd

app = FastAPI(title="Spatial Query Service")

class GeometryInput(BaseModel):
    geometry: Dict[str, Any]  # GeoJSON geometry
    srid: int = 4326

class SpatialQueryRequest(BaseModel):
    input_geometry: GeometryInput
    query_type: str  # "intersects", "contains", "within", etc.
    target_layer: str
    properties: Optional[List[str]] = None
    
@app.post("/query", response_model=Dict[str, Any])
async def spatial_query(
    request: SpatialQueryRequest,
    db: AsyncSession = Depends(get_db_connection)
):
    """Execute a spatial query against the specified layer"""
    try:
        # Convert GeoJSON to WKT for PostGIS
        geom = shape(request.input_geometry.geometry)
        wkt = geom.wkt
        
        # Build dynamic SQL based on query type
        query_op = request.query_type.lower()
        property_selection = "*" if not request.properties else ", ".join(request.properties)
        
        # Parameterized query for security
        sql = f"""
            SELECT {property_selection} 
            FROM {request.target_layer} 
            WHERE ST_{query_op.capitalize()}(
                geometry, 
                ST_SetSRID(ST_GeomFromText(:wkt), :srid)
            )
        """
        
        # Execute query
        result = await db.execute(
            sql, 
            {"wkt": wkt, "srid": request.input_geometry.srid}
        )
        features = result.fetchall()
        
        # Convert to GeoJSON
        return {
            "type": "FeatureCollection",
            "features": [feature.to_geojson() for feature in features]
        }
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Query error: {str(e)}")
```

#### LLM Interface Service

```python
# app/llm_interface/main.py
from fastapi import FastAPI, HTTPException, Depends
from pydantic import BaseModel
from typing import Dict, Any, List, Optional
from sqlalchemy.ext.asyncio import AsyncSession
from app.core.db import get_db_connection
import httpx

app = FastAPI(title="LLM Interface Service")

class NaturalLanguageQuery(BaseModel):
    query: str
    context: Optional[Dict[str, Any]] = None

class SpatialQueryTranslation(BaseModel):
    original_query: str
    translated_query: Dict[str, Any]  # Structured query for Spatial Query Service
    confidence_score: float
    
@app.post("/translate", response_model=SpatialQueryTranslation)
async def translate_nl_to_spatial_query(
    nl_query: NaturalLanguageQuery,
    db: AsyncSession = Depends(get_db_connection)
):
    """Translate natural language query to structured spatial query"""
    try:
        # Get available layers from database for context
        result = await db.execute("SELECT table_name FROM information_schema.tables WHERE table_schema = 'public'")
        available_layers = [row[0] for row in result.fetchall()]
        
        # Call LLM API (placeholder - implement with actual LLM API)
        async with httpx.AsyncClient() as client:
            response = await client.post(
                "https://api.openai.com/v1/completions",
                headers={"Authorization": "Bearer YOUR_API_KEY"},
                json={
                    "model": "text-davinci-003",
                    "prompt": f"""
                    Translate this natural language query into a structured spatial query.
                    Available layers: {', '.join(available_layers)}
                    
                    Natural language query: "{nl_query.query}"
                    
                    Return a JSON object with:
                    1. input_geometry (GeoJSON)
                    2. query_type (e.g., intersects, contains)
                    3. target_layer
                    4. properties (fields to return)
                    """,
                    "max_tokens": 500
                }
            )
            
            llm_response = response.json()
            structured_query = parse_llm_response(llm_response["choices"][0]["text"])
            
            return {
                "original_query": nl_query.query,
                "translated_query": structured_query,
                "confidence_score": 0.85  # Placeholder - implement actual confidence scoring
            }
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Translation error: {str(e)}")
```

### Performance Optimization Techniques

#### Spatial Indexing Strategy

```python
# app/core/spatial_indexing.py
from sqlalchemy import text
from app.core.db import get_transaction

async def ensure_spatial_index(table_name: str, geometry_column: str = "geometry"):
    """Create spatial index if it doesn't exist"""
    async with get_transaction() as session:
        # Check if index exists
        result = await session.execute(
            text("""
            SELECT indexname FROM pg_indexes
            WHERE tablename = :table_name
            AND indexname = :index_name
            """),
            {"table_name": table_name, "index_name": f"{table_name}_{geometry_column}_idx"}
        )
        
        if not result.fetchone():
            # Create index
            await session.execute(
                text(f"CREATE INDEX {table_name}_{geometry_column}_idx ON {table_name} USING GIST({geometry_column})")
            )
            await session.commit()
```

#### Caching Strategy

```python
# app/core/cache.py
from redis import asyncio as aioredis
import json
import hashlib
import os

# Redis connection
redis = aioredis.from_url(os.getenv("REDIS_URL", "redis://localhost:6379/0"))

async def cache_query_result(query_hash: str, result: dict, expire_seconds: int = 3600):
    """Cache query result in Redis"""
    await redis.set(f"query:{query_hash}", json.dumps(result), ex=expire_seconds)

async def get_cached_query_result(query_hash: str):
    """Get cached query result from Redis"""
    cached = await redis.get(f"query:{query_hash}")
    if cached:
        return json.loads(cached)
    return None

def generate_query_hash(query_params: dict):
    """Generate a hash for query parameters to use as cache key"""
    # Sort the dict to ensure consistent hashing
    serialized = json.dumps(query_params, sort_keys=True)
    return hashlib.md5(serialized.encode()).hexdigest()
```

## 4. Frontend Implementation

### Component Architecture

```
/src
  /components
    /layout          # Layout components like Header, Footer, Sidebar
    /map             # Map-related components
      MapContainer.tsx
      MapControls.tsx
      LayerToggle.tsx
      LegendPanel.tsx
    /data-viz        # Data visualization components
      Chart.tsx
      DataTable.tsx
      InfoPanel.tsx
    /ui              # Shadcn/ui component customizations
    /forms           # Form components
  /hooks             # Custom hooks for map, data fetching, etc.
    useMapbox.ts
    useGeodata.ts
    useViewport.ts
  /lib               # Utility functions and constants
    /api             # API client
  /pages             # Next.js pages
  /styles            # Global styles
  /types             # TypeScript type definitions
```

### Key Component Implementations

#### MapContainer Component

```typescript
// /components/map/MapContainer.tsx
import { useRef, useEffect, useState } from 'react';
import mapboxgl from 'mapbox-gl';
import 'mapbox-gl/dist/mapbox-gl.css';
import { useMapbox } from '@/hooks/useMapbox';

interface MapContainerProps {
  initialViewState?: {
    longitude: number;
    latitude: number;
    zoom: number;
  };
  layers?: Layer[];
}

export function MapContainer({ 
  initialViewState = { longitude: -100, latitude: 40, zoom: 3.5 },
  layers = []
}: MapContainerProps) {
  const mapContainer = useRef<HTMLDivElement>(null);
  const { map, isLoaded } = useMapbox(mapContainer, initialViewState);
  
  useEffect(() => {
    if (!map || !isLoaded) return;
    
    // Add layers when map is loaded and layers change
    layers.forEach(layer => {
      // Add layer implementation
    });
    
    return () => {
      // Clean up layers when component unmounts or layers change
    };
  }, [map, isLoaded, layers]);

  return (
    <div className="w-full h-[calc(100vh-64px)]">
      <div ref={mapContainer} className="w-full h-full" />
    </div>
  );
}
```

#### Map Hook

```typescript
// /hooks/useMapbox.ts
import { useState, useEffect, useRef, MutableRefObject } from 'react';
import mapboxgl from 'mapbox-gl';

mapboxgl.accessToken = process.env.NEXT_PUBLIC_MAPBOX_TOKEN || '';

interface UseMapboxProps {
  initialViewState?: {
    longitude: number;
    latitude: number;
    zoom: number;
  };
}

export function useMapbox(
  container: MutableRefObject<HTMLDivElement | null>,
  initialViewState = { longitude: -100, latitude: 40, zoom: 3.5 }
) {
  const [map, setMap] = useState<mapboxgl.Map | null>(null);
  const [isLoaded, setIsLoaded] = useState(false);
  
  useEffect(() => {
    if (!container.current) return;
    
    const mapInstance = new mapboxgl.Map({
      container: container.current,
      style: 'mapbox://styles/mapbox/light-v11',
      ...initialViewState,
    });
    
    mapInstance.on('load', () => {
      setIsLoaded(true);
    });
    
    setMap(mapInstance);
    
    return () => {
      mapInstance.remove();
    };
  }, [container]);
  
  return { map, isLoaded };
}
```

### State Management with TanStack Query

```typescript
// /hooks/useGeodata.ts
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import { fetchGeoJSON, updateFeature } from '@/lib/api/geo-service';

export function useGeoJSONQuery(layerId: string) {
  return useQuery({
    queryKey: ['geoJSON', layerId],
    queryFn: () => fetchGeoJSON(layerId),
    staleTime: 5 * 60 * 1000, // 5 minutes
    refetchOnWindowFocus: false,
  });
}

export function useFeatureUpdate() {
  const queryClient = useQueryClient();
  
  return useMutation({
    mutationFn: updateFeature,
    onSuccess: (data, variables) => {
      // Invalidate the specific layer query
      queryClient.invalidateQueries({ 
        queryKey: ['geoJSON', variables.layerId] 
      });
    },
  });
}
```

### Accessibility Considerations

```typescript
// /components/map/MapKeyboardControls.tsx
import { useEffect } from 'react';
import mapboxgl from 'mapbox-gl';

interface MapKeyboardControlsProps {
  map: mapboxgl.Map | null;
  enabled?: boolean;
  panDistance?: number;
  zoomDistance?: number;
}

export function MapKeyboardControls({
  map,
  enabled = true,
  panDistance = 100,
  zoomDistance = 1,
}: MapKeyboardControlsProps) {
  useEffect(() => {
    if (!map || !enabled) return;
    
    const handleKeyDown = (e: KeyboardEvent) => {
      if (!map) return;
      
      // Ensure we're not inside an input, textarea, etc.
      if (
        document.activeElement instanceof HTMLInputElement ||
        document.activeElement instanceof HTMLTextAreaElement ||
        document.activeElement instanceof HTMLSelectElement
      ) {
        return;
      }
      
      switch (e.key) {
        case 'ArrowUp':
          map.panBy([0, -panDistance]);
          break;
        case 'ArrowDown':
          map.panBy([0, panDistance]);
          break;
        case 'ArrowLeft':
          map.panBy([-panDistance, 0]);
          break;
        case 'ArrowRight':
          map.panBy([panDistance, 0]);
          break;
        case '+':
          map.zoomIn(zoomDistance);
          break;
        case '-':
          map.zoomOut(zoomDistance);
          break;
        default:
          return;
      }
      
      e.preventDefault();
    };
    
    document.addEventListener('keydown', handleKeyDown);
    
    return () => {
      document.removeEventListener('keydown', handleKeyDown);
    };
  }, [map, enabled, panDistance, zoomDistance]);
  
  return null;
}
```

## 5. DevOps Implementation

### Infrastructure as Code

```terraform
# main.tf
provider "aws" {
  region = "us-west-2"
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  version = "~> 3.0"
  
  name = "vibegis-vpc"
  cidr = "10.0.0.0/16"
  
  azs             = ["us-west-2a", "us-west-2b"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]
  
  enable_nat_gateway = true
  single_nat_gateway = true
  
  tags = {
    Environment = var.environment
    Project     = "vibegis"
  }
}

module "eks" {
  source = "terraform-aws-modules/eks/aws"
  version = "~> 18.0"
  
  cluster_name    = "vibegis-${var.environment}"
  cluster_version = "1.27"
  
  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets
  
  eks_managed_node_groups = {
    general = {
      desired_size = 2
      min_size     = 2
      max_size     = 5
      
      instance_types = ["t3.medium"]
      capacity_type  = "ON_DEMAND"
    }
    
    geospatial = {
      desired_size = 2
      min_size     = 1
      max_size     = 5
      
      instance_types = ["m5.large"]
      capacity_type  = "ON_DEMAND"
    }
  }
}

# RDS PostgreSQL with PostGIS
module "db" {
  source  = "terraform-aws-modules/rds/aws"
  version = "~> 3.0"
  
  identifier = "vibegis-${var.environment}"
  
  engine            = "postgres"
  engine_version    = "14.7"
  instance_class    = "db.t3.medium"
  allocated_storage = 20
  
  db_name  = "vibegis"
  username = var.db_username
  password = var.db_password
  port     = "5432"
  
  vpc_security_group_ids = [aws_security_group.rds.id]
  subnet_ids             = module.vpc.private_subnets
}
```

### CI/CD Pipeline

```yaml
# .github/workflows/ci-cd.yaml
name: VibeGIS CI/CD

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main, develop ]

jobs:
  test:
    runs-on: ubuntu-latest
    
    services:
      postgres:
        image: postgis/postgis:14-3.3
        env:
          POSTGRES_USER: postgres
          POSTGRES_PASSWORD: postgres
          POSTGRES_DB: vibegis_test
        ports:
          - 5432:5432
        options: >-
          --health-cmd pg_isready
          --health-interval 10s
          --health-timeout 5s
          --health-retries 5
      
      redis:
        image: redis:6
        ports:
          - 6379:6379
    
    steps:
      - uses: actions/checkout@v3
      
      - name: Set up Python
        uses: actions/setup-python@v4
        with:
          python-version: '3.10'
          
      - name: Install Python dependencies
        run: |
          python -m pip install --upgrade pip
          pip install -r backend/requirements.txt
          pip install -r backend/requirements-dev.txt
      
      - name: Lint with flake8
        run: flake8 backend
      
      - name: Run Python tests
        run: pytest backend/tests
      
      - name: Set up Node.js
        uses: actions/setup-node@v3
        with:
          node-version: '18'
          
      - name: Install frontend dependencies
        run: cd frontend && npm ci
      
      - name: Lint frontend
        run: cd frontend && npm run lint
      
      - name: Test frontend
        run: cd frontend && npm test
```

### Kubernetes Deployment

```yaml
# k8s/deployments/api-gateway.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: api-gateway
  namespace: vibegis-${ENVIRONMENT}
spec:
  replicas: 2
  selector:
    matchLabels:
      app: api-gateway
  template:
    metadata:
      labels:
        app: api-gateway
    spec:
      containers:
      - name: api-gateway
        image: ${ECR_REGISTRY}/vibegis-api-gateway:${IMAGE_TAG}
        ports:
        - containerPort: 8000
        resources:
          requests:
            memory: "256Mi"
            cpu: "100m"
          limits:
            memory: "512Mi"
            cpu: "300m"
        env:
        - name: DATABASE_URL
          valueFrom:
            secretKeyRef:
              name: db-credentials
              key: url
        - name: REDIS_URL
          valueFrom:
            secretKeyRef:
              name: redis-credentials
              key: url
        readinessProbe:
          httpGet:
            path: /health
            port: 8000
          initialDelaySeconds: 5
          periodSeconds: 10
        livenessProbe:
          httpGet:
            path: /health
            port: 8000
          initialDelaySeconds: 15
          periodSeconds: 20
```

### Monitoring and Observability

```python
# backend/common/telemetry.py
from opentelemetry import trace
from opentelemetry.exporter.otlp.proto.grpc.trace_exporter import OTLPSpanExporter
from opentelemetry.sdk.resources import SERVICE_NAME, Resource
from opentelemetry.sdk.trace import TracerProvider
from opentelemetry.sdk.trace.export import BatchSpanProcessor
from opentelemetry.instrumentation.fastapi import FastAPIInstrumentor
from opentelemetry.instrumentation.sqlalchemy import SQLAlchemyInstrumentor
from opentelemetry.instrumentation.redis import RedisInstrumentor
import os

def setup_telemetry(app, service_name):
    """Configure OpenTelemetry for a FastAPI service"""
    # Create resource with service name
    resource = Resource(attributes={
        SERVICE_NAME: service_name
    })
    
    # Create tracer provider
    tracer_provider = TracerProvider(resource=resource)
    
    # Set up export pipeline
    otlp_exporter = OTLPSpanExporter(
        endpoint=os.getenv("OTEL_EXPORTER_OTLP_ENDPOINT", "tempo:4317"),
        insecure=True
    )
    
    span_processor = BatchSpanProcessor(otlp_exporter)
    tracer_provider.add_span_processor(span_processor)
    
    # Set the tracer provider
    trace.set_tracer_provider(tracer_provider)
    
    # Instrument FastAPI
    FastAPIInstrumentor.instrument_app(app)
    
    # Return the tracer for manual instrumentation if needed
    return trace.get_tracer(service_name)
```

## 6. QA Implementation

### Testing Strategy by Application Tier

#### Frontend Tier
- Unit tests for React components with React Testing Library/Jest
- Integration tests for component compositions and data fetching
- E2E tests with Cypress for critical user journeys
- Accessibility testing with axe-core

#### API Gateway Tier
- OpenAPI specification compliance testing
- JWT authentication flow validation
- Rate limiting and CORS configuration testing

#### Service Tier
- Unit tests for isolated business logic
- Integration tests for inter-service communication
- Service-specific tests for spatial operations

#### Data Processing Tier
- Airflow DAG structure validation
- Data transformation correctness testing
- Processing pipeline benchmarking

#### Storage Tier
- PostGIS spatial query testing
- MinIO file operations validation
- Redis caching performance testing

### Test Implementation Examples

#### Unit Tests for Spatial Queries

```python
# tests/unit/test_spatial_queries.py
import pytest
from shapely.geometry import Point, Polygon
from app.spatial_query.utils import shape_to_wkt, validate_geometry
from app.core.query_optimization import optimize_query

def test_shape_to_wkt_conversion():
    """Test conversion of GeoJSON to WKT"""
    point = Point(0, 0)
    point_wkt = shape_to_wkt(point.__geo_interface__)
    assert point_wkt == "POINT (0 0)"
    
    polygon = Polygon([(0, 0), (1, 0), (1, 1), (0, 1), (0, 0)])
    polygon_wkt = shape_to_wkt(polygon.__geo_interface__)
    assert polygon_wkt == "POLYGON ((0 0, 1 0, 1 1, 0 1, 0 0))"

def test_geometry_validation():
    """Test geometry validation function"""
    # Valid geometry
    valid_geom = {
        "type": "Polygon", 
        "coordinates": [[[0, 0], [1, 0], [1, 1], [0, 1], [0, 0]]]
    }
    assert validate_geometry(valid_geom) is True
    
    # Invalid geometry (self-intersecting)
    invalid_geom = {
        "type": "Polygon",
        "coordinates": [[[0, 0], [1, 1], [0, 1], [1, 0], [0, 0]]]
    }
    assert validate_geometry(invalid_geom) is False
```

#### Integration Tests for API Endpoints

```python
# tests/integration/test_spatial_query_service.py
import pytest
from httpx import AsyncClient
from app.spatial_query.main import app
import json

@pytest.mark.asyncio
async def test_spatial_query_endpoint():
    """Test the spatial query endpoint with a real geometry"""
    test_query = {
        "input_geometry": {
            "geometry": {
                "type": "Polygon",
                "coordinates": [[[0, 0], [1, 0], [1, 1], [0, 1], [0, 0]]]
            },
            "srid": 4326
        },
        "query_type": "intersects",
        "target_layer": "test_points",
        "properties": ["name", "id"]
    }
    
    async with AsyncClient(app=app, base_url="http://test") as client:
        response = await client.post("/query", json=test_query)
        assert response.status_code == 200
        
        result = response.json()
        assert "type" in result
        assert result["type"] == "FeatureCollection"
        assert "features" in result
```

### Performance Testing

```python
# tests/performance/test_query_performance.py
import pytest
import time
import json
import asyncio
from httpx import AsyncClient
from app.spatial_query.main import app

@pytest.mark.asyncio
async def test_query_response_time():
    """Test response time for different query complexities"""
    # Simple point query
    simple_query = {
        "input_geometry": {
            "geometry": {"type": "Point", "coordinates": [0, 0]},
            "srid": 4326
        },
        "query_type": "intersects",
        "target_layer": "test_layer"
    }
    
    # Complex polygon query
    complex_coords = [[[i*0.01, i*0.01] for i in range(100)]]
    complex_coords[0].append(complex_coords[0][0])  # Close the ring
    
    complex_query = {
        "input_geometry": {
            "geometry": {"type": "Polygon", "coordinates": complex_coords},
            "srid": 4326
        },
        "query_type": "intersects",
        "target_layer": "test_layer"
    }
    
    async with AsyncClient(app=app, base_url="http://test") as client:
        # Test simple query
        start_time = time.time()
        simple_response = await client.post("/query", json=simple_query)
        simple_duration = time.time() - start_time
        
        # Test complex query
        start_time = time.time()
        complex_response = await client.post("/query", json=complex_query)
        complex_duration = time.time() - start_time
        
        # Assert both succeeded
        assert simple_response.status_code == 200
        assert complex_response.status_code == 200
        
        # Complex query should use optimization
        complex_result = complex_response.json()
        assert "geometry_simplified" in complex_result or "bbox_filter_applied" in complex_result
        
        # Log performance metrics
        print(f"Simple query duration: {simple_duration:.4f}s")
        print(f"Complex query duration: {complex_duration:.4f}s")
        
        # Complex query should be reasonably fast despite complexity
        assert complex_duration < 2.0  # Maximum 2 seconds for complex query
```

## 7. Integration Between Agent Responsibilities

See [integration_points.md](/home/craigdev/vibegis-poc/integration_points.md) for detailed information on how agents will collaborate on the project.

## 8. Implementation Timeline

### Phase 1: Foundation (Weeks 1-2)
- Set up development environment and CI/CD pipeline
- Implement core infrastructure with Terraform
- Create database schema and initial migrations
- Develop authentication and user management service

### Phase 2: Core Features (Weeks 3-4)
- Implement map visualization components
- Develop spatial query service
- Create API gateway with routing and security
- Set up basic data ingestion workflows

### Phase 3: Advanced Features (Weeks 5-6)
- Implement natural language interface with LLM integration
- Develop analytics and visualization components
- Create data processing pipelines with Airflow
- Set up monitoring and observability

### Phase 4: Testing and Refinement (Weeks 7-8)
- Comprehensive testing across all tiers
- Performance optimization for geospatial operations
- UI/UX refinements based on user feedback
- Documentation and final deployment