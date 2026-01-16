---
description: Generate an improvement suggestion for rules, validation, or skills
argument-hint: "<type> <title>"
---

# Suggest Improvement: Generate Rule/Validation/Skill Enhancement

## Purpose

Create a structured improvement suggestion artifact that proposes changes to:
- **Rules** (`.claude/rules/*.md`) - Add patterns, anti-patterns, examples
- **Validation** (`.claude/commands/validation/*.md`) - Add checks
- **Skills** (`.claude/skills/*.md`) - Add enforcement behaviors

## Prerequisites

- Learning insights exist (run `/validation:learn` first)
- Improvement is based on real data from code reviews

## Arguments

| Argument | Description | Example |
|----------|-------------|---------|
| `type` | Type of improvement (rule, validation, skill) | `rule` |
| `title` | Brief title of the improvement | `"Add N+1 query detection"` |

## Process

### Step 1: Gather Context

Read learning insights from `.claude/agents/learning/insights/` to understand:
- What issue/pattern prompted this suggestion
- How many times it occurred
- What the impact was

### Step 2: Identify Target File

Based on type:
- **rule**: Determine which rule file (security, testing, general, etc.)
- **validation**: Determine which validation command to enhance
- **skill**: Determine which skill to enhance or create

### Step 3: Propose Change

Determine:
- What content to add
- Where to add it (section, line)
- How it will prevent the issue

### Step 4: Create Improvement Artifact

Create at: `.claude/agents/learning/suggestions/{suggestion-id}.md`

Generate unique suggestion-id: `{type}-{short-title}-{timestamp}`

Example: `rule-n1-query-detection-20250115`

Structure:
```markdown
# Improvement Suggestion: {Title}

**ID:** {suggestion-id}
**Date:** {timestamp}
**Type:** {rule-update | validation-addition | skill-enhancement}
**Priority:** {critical | high | medium | low}
**Status:** pending

## Problem

{Description of the recurring issue or gap}

## Evidence

Based on learning analysis:
- **Found in:** {N} code reviews
- **Last occurrence:** {date}
- **Source reviews:**
  - `.claude/agents/reviews/{review1}.md`
  - `.claude/agents/reviews/{review2}.md`
- **Impact:** {description of impact}

## Proposed Change

### Target File
`{path to file to update}`

### Section
{Which section to add to}

### Proposed Content

```{language}
{The actual content to add}
```

### Rationale
{Why this change will prevent the issue}

## Validation

After applying this change:
1. {How to verify it works}
2. {Expected behavior}

## Risks

- {Potential downside 1}
- {Potential downside 2}

## Approval

- [ ] Reviewed by human
- [ ] Approved for implementation
- [ ] Applied to codebase

## Application Instructions

To apply this improvement:
1. Review the proposed change above
2. If approved, update `{target file}` with the proposed content
3. Run validation to ensure no regressions
4. Mark as applied and move to `.claude/agents/learning/applied/`
```

### Step 5: Update Metrics

Update `.claude/agents/learning/learning-metrics.md`:
- Increment "Total Suggestions Generated"

### Step 6: Report

Output to user:
```
## Improvement Suggestion Created

**ID:** {suggestion-id}
**Type:** {type}
**Title:** {title}
**Priority:** {priority}

**Artifact:** `.claude/agents/learning/suggestions/{suggestion-id}.md`

**Next Steps:**
1. Review the suggestion artifact
2. Approve or reject the proposed change
3. If approved, apply changes to target file
4. Mark as applied in the artifact
```

## Output

**Artifact Created:**
- `.claude/agents/learning/suggestions/{suggestion-id}.md`

## Example

```bash
# Suggest rule update
/validation:suggest-improvement rule "Add N+1 query anti-pattern"

# Suggest validation addition
/validation:suggest-improvement validation "Add environment URL check"

# Suggest skill enhancement
/validation:suggest-improvement skill "Enhance code-review with N+1 detection"
```
