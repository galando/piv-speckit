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

## Execution

`Read {CLAUDE_PLUGIN_ROOT}/.claude/reference/execution/plan-feature.md`

Contains full planning methodology with phases:
- **Phase 0: Auto-Prime** (automatic — loads/refreshes codebase context silently)
- Phase 1: Feature Understanding
- Phase 1.5: Pragmatic Programmer Principles Review
- Phase 2: Codebase Intelligence Gathering
- Phase 3: External Research & Documentation
- Phase 4: Deep Strategic Thinking
- Phase 5: Plan Structure Generation
- Phase 6: Output Split Artifacts

## Output Structure

**NEW: Split Artifacts** (Inspired by [GitHub's Spec-Kit](https://github.com/github/spec-kit))

Creates `.claude/specs/{XXX-feature-name}/` with:
- `spec.md` - WHAT: User stories, requirements, workflows
- `plan.md` - HOW: Technical approach, architecture, APIs
- `tasks.md` - DO: Step-by-step implementation tasks
- `quickstart.md` - TL;DR: Quick reference for humans

**Backward Compatible:**
- Old single-file plans still work
- Old plans can be migrated to split format

## Multi-AI Compatibility

All artifacts are **structured Markdown** - works with ANY AI tool:
- **Claude Code** (plugin) - Full experience
- **Cursor** - Reads files directly
- **GitHub Copilot** - Reads files directly
- **ChatGPT/Claude Web** - Copy-paste content
