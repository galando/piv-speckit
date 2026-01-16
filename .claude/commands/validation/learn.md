---
description: Analyze code review outputs to extract learnings and identify improvement opportunities
argument-hint: "[--last=N] [--review=path]"
---

# Learning Analysis: Extract Insights from Code Reviews

## Purpose

Analyze code review artifacts to:
1. **Extract structured data** from review outputs (issues, patterns, recommendations)
2. **Identify recurring patterns** across multiple reviews
3. **Generate improvement suggestions** for rules, validation, and skills
4. **Update learning metrics** to track progress over time

## Prerequisites

- At least one code review artifact exists in `.claude/agents/reviews/`
- Code review artifacts follow standard format (from `/validation:code-review`)

## Arguments

| Argument | Description | Example |
|----------|-------------|---------|
| `--last=N` | Analyze last N reviews (default: all) | `--last=5` |
| `--review=path` | Analyze specific review | `--review=.claude/agents/reviews/code-review-feature-x.md` |

## Process

### Step 1: Discover Review Artifacts

```bash
# Find all review artifacts
ls -la .claude/agents/reviews/*.md
```

List all available reviews and their dates.

### Step 2: Read and Parse Each Review

For each review artifact, extract:

**From `## Issues Found` section:**
- Issue severity (Critical/High/Medium/Low)
- Issue title and description
- File and line number (if provided)
- Suggested fix (if provided)

**From `## Detailed Analysis` section:**
- Category (Logic Errors, Security, Performance, Code Quality)
- Pass/Fail status
- Specific findings

**From `## Positive Findings` section:**
- Good patterns that worked
- Practices to encourage

**From `## Recommendations` section:**
- Suggested improvements
- Future enhancements

**From `## Project Standards Compliance` section:**
- Which rules were followed
- Which rules were violated

**Metadata:**
- PIV Quality Score
- Date
- Feature name

### Step 3: Identify Patterns

**Recurring Issues:**
- Group issues by category and type
- Count occurrences across reviews
- Flag issues appearing in 2+ reviews as "recurring"

**Anti-Patterns:**
- Identify code patterns that repeatedly cause issues
- Document with examples from reviews

**Good Patterns:**
- Identify patterns that consistently pass review
- Document for encouragement in rules

### Step 4: Generate Learning Insights Artifact

Create artifact at: `.claude/agents/learning/insights/learning-insights-{timestamp}.md`

Structure:
```markdown
# Learning Insights: {Date Range}

**Date:** {ISO timestamp}
**Reviews Analyzed:** {count}
**Date Range:** {earliest} to {latest}

## Executive Summary

Analyzed {X} code reviews. Found {Y} total issues across {Z} categories.
{N} recurring issues identified as improvement candidates.

## Issues Summary

### By Severity
| Severity | Count | % of Total |
|----------|-------|------------|
| Critical | X | Y% |
| High | X | Y% |
| Medium | X | Y% |
| Low | X | Y% |

### By Category
| Category | Count | Recurring |
|----------|-------|-----------|
| Logic Errors | X | Y |
| Security | X | Y |
| Performance | X | Y |
| Code Quality | X | Y |

## Recurring Issues (Improvement Candidates)

### 1. {Issue Title}
- **Occurrences:** {N} times in {reviews}
- **Category:** {category}
- **Severity:** {severity}
- **Description:** {description}
- **Improvement Opportunity:** {what to add to rules/validation}

### 2. {Issue Title}
...

## Anti-Patterns Discovered

### 1. {Anti-Pattern Name}
- **Found in:** {reviews}
- **Description:** {what the bad pattern is}
- **Impact:** {why it's bad}
- **Prevention:** {how to prevent in rules/skills}

## Good Patterns Found

### 1. {Pattern Name}
- **Found in:** {reviews}
- **Description:** {what worked well}
- **Encourage:** {how to encourage in rules}

## Improvement Suggestions

Based on this analysis, consider:

1. **Rule Update:** Add {anti-pattern} to `.claude/rules/{file}.md`
   - Priority: {priority}
   - Rationale: {why}

2. **Validation Addition:** Add check for {issue} to validation pipeline
   - Priority: {priority}
   - Rationale: {why}

3. **Skill Enhancement:** Enhance {skill} to detect {pattern}
   - Priority: {priority}
   - Rationale: {why}

## Next Steps

- Run `/validation:suggest-improvement "{suggestion}"` to create improvement artifact
- Review and approve suggestions before applying
- Track effectiveness in learning metrics
```

### Step 5: Update Learning Metrics

Update `.claude/agents/learning/learning-metrics.md` with:
- Increment "Total Reviews Analyzed"
- Update "Last Updated" timestamp
- Add issues to category/severity counts
- Update recurring issues list
- Calculate trends (↑↓→) based on last 5 reviews

### Step 6: Report Summary

Output to user:
```
## Learning Analysis Complete

**Reviews Analyzed:** {N}
**Total Issues Found:** {X}
**Recurring Issues:** {Y} (improvement candidates)
**New Suggestions:** {Z}

**Learning Insights:** `.claude/agents/learning/insights/learning-insights-{timestamp}.md`
**Metrics Updated:** `.claude/agents/learning/learning-metrics.md`

**Next Steps:**
- Review learning insights for accuracy
- Run `/validation:suggest-improvement` for high-priority items
- Track learning effectiveness over time
```

## Output

**Artifacts Created:**
- `.claude/agents/learning/insights/learning-insights-{timestamp}.md` - Detailed learning insights

**Artifacts Updated:**
- `.claude/agents/learning/learning-metrics.md` - Aggregate metrics

## Example

```bash
# Analyze all reviews
/validation:learn

# Analyze last 5 reviews only
/validation:learn --last=5

# Analyze specific review
/validation:learn --review=.claude/agents/reviews/code-review-feature-x.md
```

## When to Run

- **After code review:** Run learning analysis to capture insights
- **Periodically:** Run with `--last=5` to analyze recent trends
- **Before planning:** Check learning metrics for known issue patterns

## Automatic Chaining

This command can be automatically suggested after `/validation:code-review` completes.
The adaptive-learning skill will prompt: "Run learning analysis to capture insights?"
