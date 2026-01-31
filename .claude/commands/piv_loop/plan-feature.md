---
description: "Create comprehensive feature plan with split spec artifacts (spec, plan, tasks)"
argument-hint: "<feature-name>"
---

# Plan a New Feature

**Goal:** Transform feature request into implementation plan with **split spec artifacts**.

## Usage

```
/piv-speckit:plan-feature "feature description"
```

## Feature: $ARGUMENTS

## Execution

> **Full methodology:** `$CLAUDE_PLUGIN_ROOT/.claude-plugin/reference/execution/plan-feature.md`

### Planning Phases
- **Phase 0: Auto-Prime** (automatic — loads/refreshes codebase context silently)
- Phase 1: Feature Understanding
- Phase 1.5: Pragmatic Programmer Principles Review
- Phase 2: Codebase Intelligence Gathering
- Phase 3: External Research & Documentation
- Phase 4: Deep Strategic Thinking
- Phase 5: Plan Structure Generation
- Phase 6: Output Split Artifacts

### Compressed Methodology (Fallback)

**Phase 0:** Check `.claude/agents/context/prime-context.md`. If missing/stale (>20 files changed or >7 days), re-scan codebase silently.

**Phase 1:** Extract problem, identify type (New/Enhancement/Refactor/Fix), assess complexity (Low/Med/High), map affected systems. Create user story: `As a <user> I want <goal> So that <benefit>`.

**Phase 1.5:** Review DRY (reuse patterns?), Broken Windows (tech debt?), Automate (tests/CI?), Design for Change (flexible?).

**Phase 2:** Read prime context, analyze project structure, find similar implementations, check patterns in `.claude/rules/`, identify integration points.

**Phase 3:** Research latest library docs, find examples, identify gotchas.

**Phase 4:** Think about architecture fit, dependencies, edge cases, testing strategy, performance, security.

**Phase 5:** Generate plan with: context references, patterns to follow, implementation phases, step-by-step tasks with VALIDATE commands.

**Phase 6:** Create split artifacts in `.claude/specs/{XXX-feature}/` or single file in `.claude/agents/plans/`.

## Output Structure

**Split Artifacts** (Inspired by [GitHub's Spec-Kit](https://github.com/github/spec-kit))

Creates `.claude/specs/{XXX-feature-name}/` with:
- `spec.md` - WHAT: User stories, requirements, workflows
- `plan.md` - HOW: Technical approach, architecture, APIs
- `tasks.md` - DO: Step-by-step implementation tasks
- `quickstart.md` - TL;DR: Quick reference for humans

**Backward Compatible:**
- Old single-file plans still work
- Old plans can be migrated to split format
