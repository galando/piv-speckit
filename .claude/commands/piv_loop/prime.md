---
description: Prime agent with codebase understanding and save context to file
---

# Prime: Load Project Context

## Objective

Build comprehensive understanding of the codebase by analyzing structure, documentation, and key files, then **save context to a reusable file** for planning phase.

## Process

### 1. Analyze Project Structure

List all tracked files:
```bash
git ls-files
```

Show directory structure:
```bash
find . -type f \( -name "*.java" -o -name "*.ts" -o -name "*.tsx" -o -name "*.py" -o -name "*.js" -o -name "*.go" \) | grep -v node_modules | grep -v target | grep -v __pycache__ | grep -v ".git" | head -100
```

### 2. Read Core Documentation

**Must Read:**
- `.claude/CLAUDE.md` - Project overview and tech stack
- `README.md` - Quick start guide
- `docs/ARCHITECTURE.md` - System architecture (if exists)
- `.claude/rules/` - Modular coding rules

### 3. Identify Key Files

Based on the structure, identify and read:

**Backend (Example: Java + Spring Boot):**
- `backend/pom.xml` or `build.gradle` - Dependencies and version
- `backend/src/main/java/com/example/Application.java` - Entry point
- `backend/src/main/resources/application.properties` - Configuration
- Key controllers: `backend/src/main/java/com/example/controller/`
- Key services: `backend/src/main/java/com/example/service/`
- Key entities: `backend/src/main/java/com/example/entity/`

**Backend (Example: Python + FastAPI):**
- `backend/pyproject.toml` or `requirements.txt` - Dependencies
- `backend/main.py` or `backend/app/main.py` - Entry point
- Key routers: `backend/app/api/`
- Key services: `backend/app/services/`
- Key models: `backend/app/models/`

**Backend (Example: Node.js + Express):**
- `backend/package.json` - Dependencies
- `backend/src/index.js` or `backend/server.js` - Entry point
- Key routes: `backend/src/routes/`
- Key controllers: `backend/src/controllers/`

**Frontend (Example: React):**
- `frontend/package.json` - Dependencies
- `frontend/src/main.tsx` or `frontend/src/index.tsx` - Entry point
- `frontend/src/App.tsx` - Main app component
- Key components: `frontend/src/components/`
- Key pages: `frontend/src/pages/` or `frontend/src/app/`

### 4. Understand Current State

Check recent activity:
```bash
git log -10 --oneline
```

Check current branch and status:
```bash
git status
git branch --show-current
```

### 5. Pattern Recognition

Identify key patterns based on your technology stack:

**Common Backend Patterns:**
- Repository/ORM pattern (e.g., Spring Data JDBC, SQLAlchemy, TypeORM)
- Service layer (business logic separation)
- DTOs/Response models (API layer separation)
- Logging strategy (structured logging, levels)
- Error handling approach (graceful degradation, exceptions)

**Common Frontend Patterns:**
- Component architecture (functional, hooks, class-based)
- State management (Context, Redux, Zustand, signals)
- HTTP client (fetch, Axios, etc.)
- Styling (CSS modules, Tailwind, styled-components)
- Routing approach

**Common Testing Patterns:**
- Test framework (JUnit, pytest, Jest, Vitest)
- Mocking approach (Mockito, unittest.mock, vi.mock)
- Test types (unit, integration, E2E)

### 6. External Dependencies

Identify external APIs and services:
- Authentication providers
- Database systems
- External APIs
- Cloud services
- Third-party integrations

## Output

### Save Context to File

**File:** `.claude/agents/context/prime-context.md`

**Structure:**

```markdown
# {Project Name} Prime Context

**Last Updated:** {timestamp}
**Branch:** {branch}
**Commit:** {commit-hash}

## Project Overview

- **Name:** {project name}
- **Purpose:** {brief description}
- **Tech Stack:** {backend} + {frontend}
- **Database:** {database}
- **Current Version:** {version}

## Architecture

### Backend
- Framework: {framework and version}
- Database: {database and ORM}
- Security: {authentication approach}
- Other: {key technologies}

### Frontend
- Framework: {framework and version}
- Build Tool: {build tool}
- Styling: {styling approach}
- State Management: {state management}
- HTTP Client: {HTTP client}

## Key Patterns

### Backend Patterns

**Repository/ORM Pattern:**
- {ORM or data access approach}
- {Key conventions}

**Service Layer:**
- {Business logic organization}
- {Dependency injection approach}

**DTOs/Response Models:**
- {API layer separation strategy}

**Logging:**
- {Logging framework and patterns}

**Error Handling:**
- {Error handling strategy}

### Frontend Patterns

**Components:**
- {Component architecture}

**State Management:**
- {State management approach}

**HTTP Client:**
- {HTTP client and patterns}

## Codebase Structure

### Backend Directory Layout
```
backend/src/main/java/com/example/
├── controller/      # REST API endpoints
├── service/         # Business logic
├── repository/      # Data access layer
├── entity/          # Database entities
├── dto/             # Data transfer objects
└── config/          # Configuration classes
```

### Frontend Directory Layout
```
frontend/src/
├── components/      # React components
├── context/         # State management
├── api/             # API clients
└── pages/           # Route pages
```

## Configuration Files

- {List key configuration files}

## External APIs

{List external APIs and services}

## Testing

**Backend:**
- {Test framework}
- {Mocking approach}
- {Integration test approach}

**Frontend:**
- {Test framework}
- {Component testing approach}

## Build & Run

**Backend:**
```bash
{Build and run commands}
```

**Frontend:**
```bash
{Build and run commands}
```

## Recent Activity

{git-log-output}

## Current State

- Branch: {branch}
- Status: {clean/dirty}
- Last commit: {commit-message}

## Important Notes

{List critical patterns and conventions}

## References

- CLAUDE.md: Project overview
- docs/ARCHITECTURE.md: Detailed architecture (if exists)
- .claude/rules/: Modular coding rules
```

## Next Steps

After creating the context file:

1. **Use this context** when creating feature plans with `/core_piv_loop:plan-feature`
2. **Update this context** weekly or when major changes occur
3. **Reference this file** from all implementation plans

**Example Plan Reference:**
```markdown
## CONTEXT REFERENCES

### Prime Context
- `.claude/agents/context/prime-context.md` - COMPLETE codebase overview
  - Read this FIRST to understand project structure
  - Contains all patterns, configurations, and external dependencies
```

## Quality Checklist

- [ ] All tracked files listed
- [ ] Core documentation read (CLAUDE.md, README.md, ARCHITECTURE.md)
- [ ] Key files identified (controllers, services, entities)
- [ ] Current state captured (git log, git status)
- [ ] Patterns documented (backend, frontend, testing)
- [ ] External APIs listed
- [ ] Context saved to `.claude/agents/context/prime-context.md`
- [ ] File is well-organized and easy to scan
