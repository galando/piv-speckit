---
description: Display learning metrics dashboard and progress
---

# Learning Status: View Learning Metrics Dashboard

> **Full methodology:** `$CLAUDE_PLUGIN_ROOT/.claude-plugin/reference/skills-full/adaptive-learning-full.md`

## Purpose

Display the current state of the learning system:
- Total reviews analyzed
- Issue trends by category and severity
- Recurring issues that need attention
- Applied improvements and their effectiveness
- Learning effectiveness metrics

## Execution Steps

### Step 1: Read Metrics File

```bash
Read .claude/agents/learning/learning-metrics.md
```

**If file doesn't exist:**
```
## Learning Metrics Dashboard

**Status:** No learning data yet

**First Steps:**
1. Run code reviews: `/piv-speckit:code-review`
2. Analyze reviews: `/piv-speckit:learn`
3. Check back here for metrics

---

**Why no data?** Learning metrics are populated after analyzing code review artifacts.
```

### Step 2: Parse and Display Metrics

Extract these values from the metrics file:
- Total Reviews Analyzed
- Last Updated timestamp
- Issue counts by category and severity
- Recurring issues list
- Improvement suggestions count
- Learning effectiveness indicators

### Step 3: Display Dashboard

Format as:

```markdown
## Learning Metrics Dashboard

**Last Updated:** {timestamp}
**Reviews Analyzed:** {N}

### Issue Trends

| Category | Total | Last 5 Reviews | Trend |
|----------|-------|----------------|-------|
| Logic | {N} | {N} | {↑↓→} |
| Security | {N} | {N} | {↑↓→} |
| Performance | {N} | {N} | {↑↓→} |
| Quality | {N} | {N} | {↑↓→} |

### Recurring Issues (Need Attention)

{If recurring issues exist}
1. **{Issue title}** - {N} occurrences
   - Category: {category}
   - Last seen: {date}

2. **{Issue title}** - {N} occurrences
   - Category: {category}
   - Last seen: {date}

{If no recurring issues}
✅ No recurring issues detected

### Improvement Suggestions

| Generated | Applied | Pending |
|-----------|---------|---------|
| {N} | {N} | {N} |

{If pending > 0}
**Pending suggestions:** {N} awaiting review in `.claude/agents/learning/suggestions/`
```

### Step 4: Provide Recommendations

Based on the metrics state:

```markdown
## Recommendations

{If recurring issues > 0}
- **Address recurring issues:** Run `/piv-speckit:suggest-improvement` for top recurring issues

{If last_analysis > 7 days ago}
- **Run learning analysis:** No recent analysis. Run `/piv-speckit:learn` to update metrics

{If pending_suggestions > 0}
- **Review pending suggestions:** {N} suggestions await approval

{If total_reviews < 5}
- **Build learning base:** More code reviews needed for meaningful insights
```

## Output

Provide the formatted dashboard followed by specific recommendations based on actual metrics state.

## Example

```bash
/piv-speckit:learning-status
```
