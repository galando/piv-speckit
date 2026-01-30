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

## Execution

`Read {CLAUDE_PLUGIN_ROOT}/.claude/reference/execution/execute.md`

Contains full execution instructions:
1. Read and understand plan/tasks
2. Read prime context
3. Verify feature branch
4. Read mandatory files
5. Execute tasks with TDD compliance

## Spec-Kit Split Artifacts

When using split artifacts:
- `spec.md` - Read for context (WHAT)
- `plan.md` - Read for technical approach (HOW)
- **`tasks.md`** - Execute from this file (DO)
- `quickstart.md` - Quick reference

**Execute command reads tasks.md** for step-by-step implementation.
