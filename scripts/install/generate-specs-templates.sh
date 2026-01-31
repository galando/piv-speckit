#!/bin/bash
# generate-specs-templates.sh - Generate .specs/ directory with templates
# Generates spec, plan, and task templates

set -euo pipefail

generate_specs_templates() {
    local target_dir="${1:-.}"
    local specs_dir="$target_dir/.specs"
    local templates_dir="$specs_dir/.templates"
    local script_dir
    local version

    # Get script directory (works when sourced or run directly)
    script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

    # Read version from VERSION file
    version=$(cat "$script_dir/../../VERSION" 2>/dev/null || echo "dev")

    mkdir -p "$templates_dir"

    # Spec template
    cat > "$templates_dir/spec-template.md" << 'EOF'
# Spec: {Feature Name}

**ID:** {XXX-feature-name}
**Status:** DRAFT
**Created:** {DATE}

## Overview

{Brief description of what this feature delivers}

## User Stories

### Story 1: {Story Title}
**As a** {type of user}
**I want** {action}
**So that** {benefit}

**Acceptance Criteria:**
- [ ] {Criteria 1}
- [ ] {Criteria 2}
- [ ] {Criteria 3}

### Story 2: {Story Title}
**As a** {type of user}
**I want** {action}
**So that** {benefit}

**Acceptance Criteria:**
- [ ] {Criteria 1}
- [ ] {Criteria 2}

## Functional Requirements

| ID | Requirement | Priority |
|----|-------------|----------|
| FR1 | {Requirement 1} | HIGH |
| FR2 | {Requirement 2} | MEDIUM |
| FR3 | {Requirement 3} | LOW |

## User Workflows

### Workflow 1: {Workflow Name}

1. User {action 1}
2. User {action 2}
3. System {response}
4. User {confirmation}

## Edge Cases

- {Edge case 1}
- {Edge case 2}

## Non-Functional Requirements

- Performance: {Requirements}
- Security: {Requirements}
- Accessibility: {Requirements}

## Out of Scope

{What is explicitly NOT included}
EOF

    # Plan template
    cat > "$templates_dir/plan-template.md" << 'EOF'
# Plan: {Feature Name}

**Feature ID:** {XXX-feature-name}
**Status:** DRAFT
**Created:** {DATE}

## Technical Approach

{High-level technical solution}

## Architecture

### Component Diagram

```
┌─────────────┐    ┌─────────────┐    ┌─────────────┐
│   Frontend  │───▶│    API      │───▶│  Database   │
│             │    │   Gateway   │    │             │
└─────────────┘    └─────────────┘    └─────────────┘
```

### Technology Choices

| Component | Technology | Rationale |
|-----------|------------|-----------|
| API | {Choice} | {Why} |
| Database | {Choice} | {Why} |
| Caching | {Choice} | {Why} |

## Data Model

### Entity: {Entity Name}

```sql
CREATE TABLE {table_name} (
    id BIGSERIAL PRIMARY KEY,
    {field1} {type} NOT NULL,
    {field2} {type},
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);
```

### Relationships

{Describe relationships between entities}

## API Design

### Endpoints

| Method | Path | Description |
|--------|------|-------------|
| POST | /api/resource | Create resource |
| GET | /api/resource/:id | Get resource |
| PUT | /api/resource/:id | Update resource |
| DELETE | /api/resource/:id | Delete resource |

## External Dependencies

| Dependency | Version | Purpose |
|------------|---------|---------|
| {Library} | {Version} | {Why needed} |

## Security Considerations

- {Security item 1}
- {Security item 2}

## Performance Considerations

- {Performance item 1}
- {Performance item 2}
EOF

    # Tasks template
    cat > "$templates_dir/tasks-template.md" << 'EOF'
# Tasks: {Feature Name}

**Feature ID:** {XXX-feature-name}
**Status:** DRAFT
**Created:** {DATE}

## Task Breakdown

**Legend:**
- `[P]` = Can run in parallel
- `(file: path)` = Target file for implementation

---

## User Story 1: {Story Name}

### Setup Tasks
- [ ] Task 1.1 [P] {Task description} (file: `path/to/file.ext`)
- [ ] Task 1.2 [P] {Task description} (file: `path/to/file.ext`)

### Core Implementation
- [ ] Task 1.3 {Task description} (file: `path/to/file.ext`)
  - Test: `path/to/test.ext`
- [ ] Task 1.4 {Task description} (depends on Task 1.3)
  - Test: `path/to/test.ext`

### Validation
- [ ] Task 1.5 {Validation task}
- [ ] Task 1.6 {Integration test}

---

## User Story 2: {Story Name}

### Setup Tasks
- [ ] Task 2.1 {Task description} (file: `path/to/file.ext`)

### Core Implementation
- [ ] Task 2.2 [P] {Task description} (file: `path/to/file.ext`)
  - Test: `path/to/test.ext`

---

## Cross-Cutting Concerns

### Documentation
- [ ] Task D.1 Update README.md
- [ ] Task D.2 Update API documentation

### Testing
- [ ] Task T.1 Add integration tests
- [ ] Task T.2 Add E2E tests

### Deployment
- [ ] Task O.1 Create database migration
- [ ] Task O.2 Update deployment config
EOF

    # Quickstart template
    cat > "$templates_dir/quickstart-template.md" << 'EOF'
# Quickstart: {Feature Name}

> TL;DR for {feature name}

## What We're Building

{One sentence description}

## Key Files

| File | Purpose |
|------|---------|
| `path/to/file1` | {Purpose} |
| `path/to/file2` | {Purpose} |

## Implementation Order

1. {First thing to implement}
2. {Second thing}
3. {Third thing}

## Test Commands

```bash
# Run specific tests
{test command}

# Check coverage
{coverage command}
```

## Done When

- [ ] All tests pass
- [ ] Coverage ≥ 80%
- [ ] Code reviewed
- [ ] Documentation updated
EOF

    # Constitution template (at root level)
    cat > "$target_dir/constitution.template.md" << 'EOF'
# Project Constitution

**Last Updated:** {DATE}
**Project:** {PROJECT_NAME}

## Purpose

{What this project is and why it exists}

## Core Principles

1. **Quality First**
   - {Your quality standards}

2. **Testing**
   - TDD is mandatory (RED → GREEN → REFACTOR)
   - 80%+ test coverage
   - Integration tests for critical paths

3. **Code Style**
   - {Your style preferences}

## Technology Stack

**Backend:**
- Framework: {e.g., Spring Boot 3.2}
- Language: {e.g., Java 21}
- Database: {e.g., PostgreSQL 16}

**Frontend:**
- Framework: {e.g., React 19}
- Language: {e.g., TypeScript}
- Styling: {e.g., TailwindCSS}

## Technical Constraints

**Use:**
- {Technology choices to use}

**Avoid:**
- {Anti-patterns to avoid}

## Development Guidelines

**Git Workflow:**
- Branch from: `main`
- Commit style: Conventional Commits
- PR required: Yes

**Code Review:**
- Required for: All changes
- Reviewers: {Who reviews}

**Testing:**
- Required before: All commits
- Test command: {e.g., `mvn test`}

## Security Requirements

- {Security requirements}

## Performance Requirements

- {Performance targets}
EOF

    echo "Generated: $templates_dir/"
    ls -la "$templates_dir/"
    echo ""
    echo "Generated: $target_dir/constitution.template.md"
}

# Allow sourcing or direct execution
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    generate_specs_templates "$@"
fi
