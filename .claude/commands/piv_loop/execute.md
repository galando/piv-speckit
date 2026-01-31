---
description: "Execute implementation from tasks.md or single plan file"
argument-hint: "<path-to-plan.md | path-to-tasks.md>"
---

# Execute: Implement from Plan

**Goal:** Implement feature from pre-generated plan.

## Usage

**For split artifacts (Spec-Kit style):**
```
/piv-speckit:execute .claude/specs/XXX-feature-name/tasks.md
```

**For single-file plans (legacy):**
```
/piv-speckit:execute .claude/agents/plans/feature-name.md
```

## Plan: $ARGUMENTS

## Execution

> **Full methodology:** `$CLAUDE_PLUGIN_ROOT/.claude-plugin/reference/execution/execute.md`

### Execution Steps

1. **Read plan/tasks** - Understand scope and requirements
2. **Read prime context** - `.claude/agents/context/prime-context.md`
3. **Verify feature branch** - Never commit to main
4. **Read mandatory files** - All "MUST READ" references from plan
5. **Execute tasks with TDD** - RED → GREEN → REFACTOR for each task

### TDD Compliance (Mandatory)

For EACH task:
1. **RED:** Write failing test FIRST
2. **GREEN:** Minimal code to pass test
3. **REFACTOR:** Improve while tests stay green
4. **VALIDATE:** Run task's validation command

### Task Execution Pattern

```
For each task in tasks.md:
  1. Read the task requirements
  2. Write test (RED)
  3. Run test → must FAIL
  4. Implement minimal code (GREEN)
  5. Run test → must PASS
  6. Refactor if needed
  7. Run VALIDATE command
  8. Mark task complete, move to next
```

## Spec-Kit Split Artifacts

When using split artifacts:
- `spec.md` - Read for context (WHAT)
- `plan.md` - Read for technical approach (HOW)
- **`tasks.md`** - Execute from this file (DO)
- `quickstart.md` - Quick reference

**Execute command reads tasks.md** for step-by-step implementation.
