# Claude PIV Skeleton - Project Instructions

**Universal PIV (Prime-Implement-Validate) methodology for Claude Code projects**

---

## Project Overview

This is a **skeleton/template repository** for starting new projects with the PIV methodology. It contains:

- Universal PIV methodology documentation
- Modular rules system (technology-agnostic)
- Technology-specific templates (Spring Boot, React, Node.js, FastAPI)
- Command infrastructure for Claude Code
- Agent artifact templates

**Purpose**: Clone this repo to start new projects with PIV already configured.

---

## Quick Reference - PIV Commands

### Core PIV Loop

| Command | Purpose |
|---------|---------|
| `/core_piv_loop:prime` | Load codebase context and understanding |
| `/core_piv_loop:plan-feature "description"` | Create implementation plan |
| `/core_piv_loop:execute` | Execute implementation plan |

### Validation (Automatic)

| Command | Purpose |
|---------|---------|
| `/validation:validate` | Run full validation pipeline ✨ *Runs automatically after execute* |
| `/validation:code-review` | Technical code review on changed files |
| `/validation:execution-report` | Generate execution report |
| `/validation:system-review` | Analyze implementation vs plan |

### Other Commands

| Command | Purpose |
|---------|---------|
| `/commit` | Create atomic commit with conventional commits |
| `/github_bug_fix:rca` | Root cause analysis for bugs |
| `/github_bug_fix:implement-fix` | Implement bug fix from RCA |

---

## PIV Methodology - Quick Start

### Phase 1: Prime
**Load context before making changes**

```
Ask: "Run /core_piv_loop:prime to load project context"
```

### Phase 2: Implement
**Plan and execute features**

For complex work:
```
Ask: "Use /core_piv_loop:plan-feature to plan adding [feature]"
Ask: "Use /core_piv_loop:execute to implement the plan"
```

For simple changes:
```
Ask: "Implement this fix directly"
```

### Phase 3: Validate
**Automatic verification**

```
✨ Runs automatically after /core_piv_loop:execute
```

No manual intervention needed - validation includes:
- Environment safety check
- Compilation
- Unit tests
- Integration tests
- Code quality
- Coverage check
- Build verification

---

## Technology Stack

This skeleton supports multiple technologies. When starting a new project:

1. **Choose your stack** from `technologies/` directory
2. **Copy relevant templates** to your project
3. **Customize** for your needs

### Supported Technologies

#### Backend
- `technologies/backend/spring-boot/` - Java/Kotlin with Spring Boot
- `technologies/backend/node-express/` - Node.js with Express
- `technologies/backend/python-fastapi/` - Python with FastAPI

#### Frontend
- `technologies/frontend/react/` - React with TypeScript

#### Database
- `technologies/database/postgresql/` - PostgreSQL

#### DevOps
- `technologies/devops/docker/` - Docker containerization

---

## Rules System

### Universal Rules (`.claude/rules/`)

Apply to **all projects** regardless of technology:

- `00-general.md` - General development principles
- `10-git.md` - Git workflow and commits
- `20-testing.md` - Testing philosophy
- `30-documentation.md` - Documentation standards
- `40-security.md` - Security guidelines

### Technology Rules (`technologies/*/rules/`)

Auto-loaded based on file patterns:

```
backend/**/*.java     → Load Spring Boot rules
frontend/**/*.tsx     → Load React rules
**/*.test.ts          → Load testing rules
```

**Key**: Rules are numbered to control load order (00-99).

---

## Agent Artifacts

Artifacts created during PIV workflow:

### Context Artifacts
- `.claude/agents/context/prime-context.md` - Codebase context from Prime phase

### Plan Artifacts
- `.claude/agents/plans/{feature-name}.md` - Implementation plans from Plan phase

### Report Artifacts
- `.claude/agents/reports/execution-report-{feature-name}.md` - Execution summaries
- `.claude/agents/reports/validation-report-{timestamp}.md` - Validation results

### Review Artifacts
- `.claude/agents/reviews/code-review-{timestamp}.md` - Code review summaries

---

## Documentation Structure

### For This Skeleton
- `README.md` - Overview and quick start
- `CONTRIBUTING.md` - How to contribute
- `docs/getting-started/` - Detailed guides
- `docs/methodology/` - PIV methodology deep dives
- `docs/extending/` - How to extend and customize

### For New Projects
When cloning this skeleton, update:
1. `README.md` - Your project's overview
2. `.claude/CLAUDE.md` - This file, add your project specifics
3. Keep `PIV-METHODOLOGY.md` - Universal methodology
4. Customize rules in `.claude/rules/` and `technologies/*/rules/`

---

## Workflow Preferences

### When to Use PIV

| Scenario | Approach |
|----------|----------|
| New session | Always `/core_piv_loop:prime` |
| Context switch | Prime again |
| Simple bug fix | Implement directly |
| New endpoint | Plan → Execute |
| Refactoring | Plan → Execute |
| Database change | Always plan first |

### What NOT to Do

- ❌ Don't skip Prime for new sessions
- ❌ Don't over-plan simple changes
- ❌ Don't ignore validation reports
- ❌ Don't disable auto-validation
- ❌ Don't deviate from plan without updating it

---

## Customizing for Your Project

### Step 1: Choose Technologies
Copy relevant technology templates from `technologies/` directory.

### Step 2: Update CLAUDE.md
Add this section at the top:

```markdown
# [Your Project Name]

## Technology Stack
- Backend: [Your choice]
- Frontend: [Your choice]
- Database: [Your choice]

## Project Structure
[Brief description of your structure]

## Active Rules
- Universal rules: ✅
- Backend rules: [List active backend rule sets]
- Frontend rules: [List active frontend rule sets]
```

### Step 3: Remove Unused Technologies
Delete technology directories you're not using from `technologies/`.

### Step 4: Customize Rules
Edit `.claude/rules/` and technology-specific rules to match your preferences.

---

## Getting Help

### Methodology Questions
- See: `.claude/PIV-METHODOLOGY.md` - Complete methodology guide
- See: `docs/methodology/` - Detailed methodology docs

### How to Use Questions
- See: `docs/getting-started/` - Getting started guides
- See: `docs/extending/` - Extending and customizing

### Contributing
- See: `CONTRIBUTING.md` - Contribution guidelines

---

## Summary

This skeleton provides:

1. **PIV Methodology** - Proven workflow for AI-assisted development
2. **Universal Rules** - Best practices applicable to any technology
3. **Technology Templates** - Pre-built configurations for popular stacks
4. **Command Infrastructure** - Standardized Claude Code commands
5. **Automatic Validation** - Quality gates that run without intervention

**Clone it, customize it, start building with quality from day one.**

---

**Last Updated**: 2025-01-08
**PIV Version**: 1.0
**Compatible**: Claude Code (all versions)
