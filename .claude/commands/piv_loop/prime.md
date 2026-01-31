---
description: "Manually refresh codebase context (optional — plan-feature auto-primes)"
---

# Prime: Refresh Project Context (Optional)

> **Full methodology:** `$CLAUDE_PLUGIN_ROOT/.claude-plugin/reference/methodology/PIV-METHODOLOGY.md`

## When to Use

**This command is optional.** `/piv-speckit:plan-feature` now auto-primes silently before planning.

Use `/piv-speckit:prime` explicitly when you want to:
- **Force a full context refresh** (e.g., after major refactoring)
- **Inspect what Claude "sees"** about your codebase
- **Switch between projects** in the same session
- **Debug context issues** (stale patterns, missing files)

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

**Format:** Reference-based (~50-80 lines) — points to files instead of dumping code.

```markdown
# Prime Context

**Project:** {name from CLAUDE.md or package.json}
**Last Updated:** {YYYY-MM-DD HH:MM}
**Branch:** {current branch}
**Commit:** {short hash}
**Tech Stack:** {backend} + {frontend} + {database}

## Where to Find Patterns

### Backend (if detected)

#### REST Controllers
**Example:** `{path/to/ExampleController.java}:1-50`
**Find all:** `grep -r "@RestController" {backend-path}/`

#### Services
**Example:** `{path/to/ExampleService.java}:1-60`
**Find all:** `grep -r "@Service" {backend-path}/`

#### Repositories
**Example:** `{path/to/ExampleRepository.java}:1-30`
**Find all:** `grep -r "@Repository" {backend-path}/`

### Frontend (if detected)

#### React Components
**Example:** `{path/to/ExampleComponent.tsx}:1-80`
**Find all:** `grep -r "export function\|export const" {frontend-path}/components/`

#### Pages/Routes
**Example:** `{path/to/App.tsx}:1-100`
**Find all:** `ls {frontend-path}/pages/`

### Tests

#### Backend Tests
**Example:** `{path/to/ExampleTest.java}:1-40`
**Find all:** `find {backend-path} -name "*Test.java"`

#### Frontend Tests
**Example:** `{path/to/Example.test.tsx}:1-30`
**Find all:** `find {frontend-path} -name "*.test.tsx" -o -name "*.spec.tsx"`

## Key Files

| Purpose | File |
|---------|------|
| Project Config | `{pom.xml or package.json}` |
| App Config | `{application.properties or .env}` |
| Entry Point | `{main application file}` |
| Routes | `{router/routes file}` |
| Database | `{schema or migrations path}` |

## Project Principles

**Source:** `.claude/CLAUDE.md` + `.claude/rules/` (loaded automatically by Claude Code)

**Key Constraints:**
- {List 3-5 key constraints from CLAUDE.md}

## External Dependencies

| Service | Purpose | Config Location |
|---------|---------|-----------------|
| {Database} | Data storage | `{config file}` |
| {External API} | {purpose} | `{config file}` |

## Build & Test Commands

| Action | Command |
|--------|---------|
| Build | `{build command}` |
| Test | `{test command}` |
| Run | `{run command}` |
```

**Why reference-based?** Full code dumps waste ~2000 tokens. References let Claude read files on-demand during planning, saving context for actual work.

## Quality Checklist

- [ ] Tech stack detected correctly
- [ ] Key patterns identified with examples
- [ ] File references are valid paths
- [ ] Grep/find commands work
- [ ] Build/test commands accurate
- [ ] Context saved to `.claude/agents/context/prime-context.md`
