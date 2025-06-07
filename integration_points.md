# VibeGIS Agent Integration Points

## Product Owner ↔ Architecture
- Product Owner defines requirements and acceptance criteria
- Architecture Agent translates these into technical specifications
- Architecture Agent provides feasibility feedback on proposed features
- Product Owner prioritizes technical debt based on Architecture Agent recommendations

## Product Owner ↔ QA
- Product Owner defines acceptance criteria for features
- QA Agent creates test plans based on these acceptance criteria
- QA Agent validates completed features against acceptance criteria
- Product Owner adjusts requirements based on QA feedback during testing

## Architecture ↔ Backend Development
- Architecture Agent defines API contracts and database schemas
- Backend Development Agent implements these contracts and schemas
- Backend Development Agent requests design guidance for complex features
- Architecture Agent reviews backend implementation for compliance with design

## Architecture ↔ Frontend Development
- Architecture Agent defines component architecture and API interfaces
- Frontend Development Agent implements UI based on these specifications
- Frontend Development Agent requests design patterns for complex UI interactions
- Architecture Agent ensures consistent patterns across the application

## Architecture ↔ DevOps
- Architecture Agent defines performance and scaling requirements
- DevOps Agent configures infrastructure to meet these requirements
- DevOps Agent provides operational constraints that influence architecture
- Architecture Agent adjusts designs to work within operational constraints

## Backend Development ↔ Frontend Development
- Backend Development Agent implements APIs consumed by frontend
- Frontend Development Agent provides feedback on API usability
- Both agents collaborate on data transfer formats and optimization
- Frontend Development Agent adapts to changes in backend APIs

## Backend Development ↔ DevOps
- Backend Development Agent creates services to be deployed
- DevOps Agent configures environments and deployment pipelines
- DevOps Agent provides monitoring and performance data
- Backend Development Agent optimizes services based on operational metrics

## Frontend Development ↔ QA
- Frontend Development Agent creates UI components
- QA Agent tests these components for functionality and usability
- QA Agent provides feedback on UX issues
- Frontend Development Agent implements fixes for identified issues

## Backend Development ↔ QA
- Backend Development Agent implements service functionality
- QA Agent tests APIs and services for correctness
- QA Agent identifies edge cases and performance issues
- Backend Development Agent resolves issues found during testing

## DevOps ↔ QA
- DevOps Agent provides testing environments
- QA Agent ensures environments match production configuration
- QA Agent performs load and performance testing
- DevOps Agent tunes infrastructure based on testing results

## Cross-Cutting Concerns

### Security
- Architecture Agent defines security requirements
- Backend and Frontend Development Agents implement security controls
- DevOps Agent configures security infrastructure
- QA Agent validates security controls

### Performance
- Product Owner defines performance requirements
- Architecture Agent designs for performance
- Development Agents implement optimizations
- DevOps Agent monitors and tunes infrastructure
- QA Agent validates performance metrics

### Documentation
- Architecture Agent documents system design
- Development Agents document code and APIs
- DevOps Agent documents infrastructure
- QA Agent documents test cases and results
- Product Owner maintains user-facing documentation