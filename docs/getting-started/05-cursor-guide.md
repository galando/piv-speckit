# Using PIV Spec-Kit with Cursor

> No slash commands - use natural language. Cursor reads `AGENTS.md` automatically.

---

## Installation

```bash
curl -s https://raw.githubusercontent.com/galando/piv-speckit/main/scripts/piv.sh | bash
```

**What this creates:**

| File/Directory | Purpose |
|----------------|---------|
| `AGENTS.md` | Core PIV methodology (Cursor loads this automatically) |
| `.cursor/rules/` | Auto-attach rules that activate based on file patterns |
| `.specs/` | Directory for feature specifications |
| `.specs/.templates/` | Reusable templates |
| `constitution.md` | Project principles (you'll create this) |

---

## How Cursor Loads Context

Cursor automatically reads:
1. **`AGENTS.md`** from project root - always loaded (~2500 tokens)
2. **`.cursor/rules/*.mdc`** - auto-attach based on filename patterns

### Auto-Attach Rules

| Rule File | Activates When Editing |
|-----------|------------------------|
| `piv-general.mdc` | All files |
| `piv-tdd.mdc` | `*Test*`, `*.test.*`, `*_test.*`, `*.spec.*` |
| `piv-api.mdc` | `*Controller*`, `*Router*`, `routes/*` |
| `piv-security.mdc` | `*Auth*`, `*Security*`, `*Password*` |

---

## The PIV Workflow

| Phase | What to Say |
|-------|-------------|
| **Constitution** | "Create a project constitution" |
| **Prime** | "Analyze this codebase before we start" |
| **Plan** | "Plan a feature for X" |
| **Execute** | "Implement tasks from tasks.md using TDD" |
| **Validate** | "Run tests and check coverage" |

---

## Step-by-Step Guide

### 1. Constitution (One-Time)

Create project principles. Do this once when starting a project.

**In Cursor Chat (Cmd+L):**

```
Create a project constitution and save it to constitution.md

Include:
- Project name and purpose
- Tech stack (backend, frontend, database)
- Code style preferences
- Testing requirements (TDD mandatory, 80%+ coverage)
- Security constraints
- Git workflow (conventional commits)
```

---

### 2. Prime (Start of Each Session)

Load codebase context before making changes.

**In Cursor Chat:**

```
Analyze this codebase before we start. Read constitution.md and tell me:
- Project structure
- Tech stack and frameworks
- Existing patterns and conventions
- How tests are organized
```

---

### 3. Plan (For Complex Features)

Create specs before coding. Skip for trivial changes.

**In Cursor Chat or Composer (Cmd+I):**

```
Plan a feature for "password reset".

Create these files in .specs/password-reset/:
1. spec.md - User stories and requirements
2. plan.md - Technical architecture
3. tasks.md - Implementation checklist with checkboxes
4. quickstart.md - TL;DR summary

Use the templates in .specs/.templates/ as a guide.
```

---

### 4. Execute (TDD is Mandatory)

Implement following strict TDD: RED → GREEN → REFACTOR.

**In Cursor Composer (Cmd+I):**

```
Implement .specs/password-reset/tasks.md using strict TDD.

For each task:
1. Show me the failing test FIRST
2. Confirm it fails
3. Write minimal code to pass
4. Refactor if needed

Start with Task 1.1
```

**If Cursor skips the test:**

```
STOP. You wrote code before the test.
Delete that and write the failing test first.
```

---

### 5. Validate

Verify quality after implementation.

**In Cursor Chat:**

```
Validate the password-reset feature:
- Run all tests
- Check coverage (should be 80%+)
- Review for security issues
- Verify tests exist for all new code
```

---

### 6. Commit

```
Create a conventional commit for these changes.
Format: type(scope): description
```

---

## Cursor-Specific Tips

### Using Composer (Cmd+I) for Implementation

Composer is best for multi-file changes:

```
@codebase Implement the password reset feature.
Follow TDD - write tests first.
Check .specs/password-reset/tasks.md for the task list.
```

### Using Chat (Cmd+L) for Planning

Chat is best for discussions and planning:

```
Help me design the data model for user notifications.
Consider the patterns already used in this codebase.
```

### Customizing Rules

Edit `.cursor/rules/` to add project-specific rules:

```markdown
# .cursor/rules/my-project.mdc
---
globs: ["src/**/*.java"]
---

Use Spring Data JDBC (not JPA).
Use constructor injection with @RequiredArgsConstructor.
Return DTOs from controllers, never entities.
```

### Referencing Files

Use `@` to reference specific files:

```
@AGENTS.md @constitution.md
Implement authentication following these guidelines.
```

---

## Directory Structure

```
your-project/
├── AGENTS.md                    # ← Cursor reads automatically
├── constitution.md              # ← Project principles
├── .cursor/
│   └── rules/                   # ← Auto-attach rules
│       ├── piv-general.mdc
│       ├── piv-tdd.mdc
│       ├── piv-api.mdc
│       └── piv-security.mdc
└── .specs/
    ├── .templates/              # ← Reusable templates
    │   ├── spec-template.md
    │   ├── plan-template.md
    │   └── tasks-template.md
    └── password-reset/          # ← Feature specs
        ├── spec.md
        ├── plan.md
        ├── tasks.md
        └── quickstart.md
```

---

## Troubleshooting

### Cursor Ignores AGENTS.md

1. Verify `AGENTS.md` is in project root: `ls AGENTS.md`
2. Restart Cursor
3. Reference explicitly: "Follow the methodology in AGENTS.md"

### Cursor Skips TDD

Be firm:
```
STOP. TDD is mandatory.
1. Delete the implementation
2. Write a failing test
3. Show me the test failing
4. THEN write the code
```

### Rules Not Loading

1. Check `.cursor/rules/` exists
2. Verify glob patterns match your files
3. Restart Cursor

---

## Quick Reference

```
┌─────────────────────────────────────────────────────────┐
│  CURSOR + PIV QUICK REFERENCE                           │
├─────────────────────────────────────────────────────────┤
│                                                         │
│  CONSTITUTION (once)                                    │
│  "Create project constitution in constitution.md"       │
│                                                         │
│  PRIME (each session)                                   │
│  "Analyze codebase, read constitution.md"               │
│                                                         │
│  PLAN (complex features)                                │
│  "Plan feature X in .specs/X/ with spec, plan, tasks"   │
│                                                         │
│  EXECUTE (TDD!)                                         │
│  "Implement tasks.md - show FAILING TEST first"         │
│                                                         │
│  VALIDATE                                               │
│  "Run tests, check 80%+ coverage"                       │
│                                                         │
│  TDD CYCLE: 🔴 RED → 🟢 GREEN → 🔵 REFACTOR             │
│                                                         │
└─────────────────────────────────────────────────────────┘
```

---

*PIV Spec-Kit - [github.com/galando/piv-speckit](https://github.com/galando/piv-speckit)*
