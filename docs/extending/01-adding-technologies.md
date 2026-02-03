# Extending PIV Spec-Kit

**How to customize and extend PIV for your project**

---

## Overview

PIV Spec-Kit is designed to be extensible. You can add custom skills, rules, and commands to fit your project's specific needs.

---

## Adding Custom Skills

Skills are auto-activating behaviors that enforce best practices in real-time.

### Create a New Skill

```bash
mkdir -p .claude/skills/my-skill
```

### Skill Template

Create `.claude/skills/my-skill/SKILL.md`:

```markdown
# My Custom Skill

**Auto-activates when:** [describe trigger condition]

## Purpose
[Brief description of what this skill enforces]

## Activation
This skill activates when:
- [Condition 1]
- [Condition 2]

## Rules
1. **Rule 1**: [Description]
2. **Rule 2**: [Description]

## Reference Documentation
For full details, see:
\${CLAUDE_PLUGIN_ROOT}/.claude-plugin/reference/skills-full/my-skill-full.md
```

### Example: Logging Skill

```markdown
# Logging

**Auto-activates when:** Writing code that produces output or errors

## Purpose
Ensures consistent, structured logging throughout the application.

## Activation
This skill activates when:
- Adding console.log, print, or similar output statements
- Implementing error handling
- Creating API endpoints

## Rules
1. Use structured logging with consistent fields
2. Log at appropriate levels (debug, info, warn, error)
3. Avoid logging sensitive data
4. Include correlation IDs for request tracing

## Reference Documentation
For full details, see:
\${CLAUDE_PLUGIN_ROOT}/.claude-plugin/reference/skills-full/logging-full.md
```

---

## Adding Custom Rules

Rules are coding guidelines that Claude follows when working on your project.

### Universal Rules

Create `.claude/rules/NN-name.md` (NN = load order):

```markdown
# My Custom Rules

## Principle Name
- **Rule**: What to do
- **Rationale**: Why it matters

## Examples

**Good:**
```typescript
// Correct approach
```

**Bad:**
```typescript
// Wrong approach
```

## Full Reference
See: \${CLAUDE_PLUGIN_ROOT}/.claude-plugin/reference/rules-full/my-category-full.md
```

### Technology-Specific Rules

Create `.claude/rules/backend/NN-name.md`:

```markdown
# Backend API Rules

## Response Format
- **Rule**: Always return consistent response structure
- **Rationale**: Client code depends on predictable structure

**Good:**
```json
{
  "data": { ... },
  "meta": { "timestamp": "..." }
}
```

**Bad:**
```json
{
  "result": { ... },
  "time": "..."
}
```
```

---

## Adding Custom Commands

Create custom slash commands for your project workflow.

### Command Structure

```bash
mkdir -p .claude/commands/mycategory
```

Create `.claude/commands/mycategory/my-command.md`:

```markdown
# My Command

**Usage:** `/mycategory:my-command [args]`

## Description
[Brief description of what this command does]

## Parameters
- `arg1` - Description
- `arg2` - Description

## Steps
1. Step one
2. Step two
3. Step three

## Notes
- Any important notes
- Prerequisites
- Related commands
```

---

## Customizing Project Instructions

Edit `.claude/CLAUDE.md` to add project-specific context:

```markdown
# My Project

## Technology Stack
- Backend: Spring Boot 3.2
- Frontend: React 19 + TypeScript
- Database: PostgreSQL 15

## Project Structure
- src/main/java/ - Backend code
- src/frontend/ - React application
- src/db/migrations/ - Database migrations

## Coding Standards
- All APIs must return consistent response structure
- Use TypeScript strict mode
- Write tests first (TDD)
- Keep PRs small and focused

## Architecture Patterns
- Repository pattern for data access
- DTOs for API responses (never expose entities)
- Service layer for business logic
```

---

## Reference Paths

Use `${CLAUDE_PLUGIN_ROOT}` to reference plugin documentation:

```
Read ${CLAUDE_PLUGIN_ROOT}/.claude-plugin/reference/rules-full/security-full.md
```

Available reference paths:
- `${CLAUDE_PLUGIN_ROOT}/.claude-plugin/reference/rules-full/` - Complete rule documentation
- `${CLAUDE_PLUGIN_ROOT}/.claude-plugin/reference/skills-full/` - Complete skill documentation
- `${CLAUDE_PLUGIN_ROOT}/.claude-plugin/reference/execution/` - Command implementation docs
- `${CLAUDE_PLUGIN_ROOT}/.claude-plugin/reference/methodology/` - Methodology docs

---

## Examples

### Adding a Frontend Framework Rule

Create `.claude/rules/frontend/01-react.md`:

```markdown
# React Best Practices

## Component Structure
- Use functional components with hooks
- Props must have TypeScript interfaces
- Keep components under 200 lines

## State Management
- Use Context API for global state
- Use local state for component-specific state
- Avoid prop drilling beyond 2 levels

## Full Reference
See: \${CLAUDE_PLUGIN_ROOT}/.claude-plugin/reference/rules-full/react-full.md
```

### Adding a Database Rule

Create `.claude/rules/database/01-postgresql.md`:

```markdown
# PostgreSQL Best Practices

## Query Design
- Use parameterized queries (SQL injection prevention)
- Create indexes for foreign keys
- Use EXPLAIN ANALYZE for slow queries

## Migration Rules
- All schema changes via migrations
- Migrations must be reversible
- Test migrations on copy of production data

## Full Reference
See: \${CLAUDE_PLUGIN_ROOT}/.claude-plugin/reference/rules-full/postgresql-full.md
```

---

## Testing Your Extensions

### Verify Skills Load

```bash
# In Claude Code:
# Trigger your skill by doing the action it watches for
```

### Verify Rules Apply

```bash
# In Claude Code:
"Follow the rules in .claude/rules/ for all changes"
```

### Verify Commands Work

```bash
# In Claude Code:
/mycategory:my-command
```

---

## Sharing Your Extensions

If you create useful extensions, consider contributing them back:

1. Fork the repository
2. Add your skill/rule/command
3. Update documentation
4. Submit a pull request

See [CONTRIBUTING.md](../../CONTRIBUTING.md) for guidelines.

---

## Next Steps

- [Adding Skills](#adding-custom-skills)
- [Adding Rules](#adding-custom-rules)
- [Adding Commands](#adding-custom-commands)
- [Contributing](../../CONTRIBUTING.md)

---

**Questions?** Open an issue on [GitHub](https://github.com/galando/piv-speckit/issues)
