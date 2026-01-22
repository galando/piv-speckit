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
find . -type f -name "*.java" -o -name "*.ts" -o -name "*.tsx" -o -name "*.md" | grep -v node_modules | grep -v target | head -100
```

### 2. Read Core Documentation

**Must Read:**
- `.claude/CLAUDE.md` - Project overview and tech stack
- `README.md` - Quick start guide
- `docs/ARCHITECTURE.md` - System architecture
- `.claude/rules/` - Modular coding rules

### 3. Identify Key Files

Based on the structure, identify and read:

**Backend (Java 24 + Spring Boot):**
- `backend/pom.xml` - Maven dependencies and Java version
- `backend/src/main/java/com/example/Application.java` - Entry point
- `backend/src/main/resources/application.properties` - Configuration
- Key controllers: `backend/src/main/java/com/example/controller/`
- Key services: `backend/src/main/java/com/example/service/`
- Key entities: `backend/src/main/java/com/example/entity/`

**Frontend (React 19 + Vite):**
- `frontend/package.json` - Dependencies
- `frontend/src/main.tsx` - Entry point
- `frontend/src/App.tsx` - Main app component
- Key components: `frontend/src/components/`
- Key pages: `frontend/src/pages/`

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

Identify key patterns:

**Backend Patterns:**
- Repository pattern: Spring Data JDBC (NOT JPA)
- Service layer: @Service with @RequiredArgsConstructor
- DTOs: Separate DTO classes for API responses
- Logging: SLF4J structured logging
- Error handling: Graceful degradation, continue processing

**Frontend Patterns:**
- Functional components with hooks
- Context API for global state
- Axios for HTTP client
- TailwindCSS utility classes
- TypeScript interfaces

**Testing Patterns:**
- JUnit 5 for unit tests
- Mockito for mocking
- @SpringBootTest for integration tests
- Testcontainers for PostgreSQL

### 6. External Dependencies

**Identify external APIs and services:**
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

**Repository Pattern:**
- Spring Data JDBC (NOT JPA/Hibernate)
- @Repository interfaces extending CrudRepository
- Custom @Query annotations for complex queries

**Service Layer:**
- @Service annotation
- @RequiredArgsConstructor for constructor injection
- Business logic in services, not controllers
- @Transactional for database operations

**DTOs:**
- Separate DTO classes for API responses
- Never return entities from controllers
- Map entities to DTOs in service layer

**Logging:**
- SLF4J + Logback
- Structured logging with key-value pairs
- log.info(), log.error(), log.warn()

**Error Handling:**
- Graceful degradation on non-critical errors
- Continue processing even if individual items fail
- Try-catch around external API calls

### Frontend Patterns

**Components:**
- Functional components with hooks (no class components)
- TypeScript interfaces for props
- TailwindCSS utility classes (no inline styles)

**State Management:**
- React Context API for global state
- useState for local state
- useEffect for side effects

**HTTP Client:**
- Axios for API calls
- Async/await for promises
- Error handling with try-catch

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
├── pages/           # Route pages
└── locales/         # i18next translations
```

## Configuration Files

- `backend/pom.xml` - Maven dependencies
- `backend/src/main/resources/application.properties` - Spring config
- `frontend/package.json` - NPM dependencies
- `frontend/vite.config.ts` - Vite config

## External APIs

{List external APIs and services}

## Testing

**Backend:**
- JUnit 5 for unit tests
- Mockito for mocking
- @SpringBootTest for integration tests
- Testcontainers for PostgreSQL

**Frontend:**
- Vitest for unit tests
- React Testing Library for component tests

## Build & Run

**Backend:**
```bash
cd backend
mvn clean install
mvn spring-boot:run
```

**Frontend:**
```bash
cd frontend
npm install
npm run dev
```

## Recent Activity

{git-log-output}

## Current State

- Branch: {branch}
- Status: {clean/dirty}
- Last commit: {commit-message}

## Important Notes

- Use Spring Data JDBC, NOT JPA/Hibernate
- Always use DTOs in API responses
- Constructor injection with @RequiredArgsConstructor
- Structured logging with SLF4J
- Graceful error handling
- Test-first approach for new features
- Never modify existing Flyway migrations

## References

- CLAUDE.md: Project overview
- docs/ARCHITECTURE.md: Detailed architecture
- .claude/rules/: Modular coding rules
- docs/API.md: API reference
- docs/SETUP.md: Setup guide
```

## Next Steps

After creating the context file:

1. **Use this context** when creating feature plans with `/piv-speckit:plan-feature`
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
