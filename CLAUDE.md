# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

VibeGIS is a proof-of-concept application that implements a GIS (Geographic Information System) using a multi-agent architecture. The project defines different specialized agents that collaborate to build the application:

- Product Owner Agent: Defines requirements and prioritizes the backlog
- Architecture Agent: Designs the technical architecture and ensures its implementation
- Backend Development Agent: Implements server-side logic, APIs, and database operations
- Frontend Development Agent: Creates the user interface and client-side functionality
- DevOps Agent: Manages infrastructure and deployment pipelines
- QA Agent: Ensures quality through testing and validation

## Repository Structure

The repository currently contains markdown files defining the roles, responsibilities, and interaction patterns for each agent type. These files serve as the foundation for the collaborative development model used in this project.

## Agent Collaboration Framework

This project uses a collaborative agent approach where each agent has specialized responsibilities:

- Agents should operate within their defined roles
- Cross-agent communication should follow the patterns defined in the agent role descriptions
- Each agent should respect the work domains of other agents while collaborating effectively

## Development Guidelines

As the project evolves:

1. Follow the role definitions when implementing features
2. Maintain clear boundaries between agent responsibilities
3. Ensure communication between system components follows the defined patterns
4. Document new architectural decisions and patterns as they emerge