---
description: Display learning metrics dashboard and progress
---

# Learning Status: View Learning Metrics Dashboard

## Purpose

Display the current state of the learning system:
- Total reviews analyzed
- Issue trends by category and severity
- Recurring issues that need attention
- Applied improvements and their effectiveness
- Learning effectiveness metrics

## Process

### Step 1: Read Metrics

Read `.claude/agents/learning/learning-metrics.md`

### Step 2: Display Dashboard

Format and display the metrics in a user-friendly format:

```
╔══════════════════════════════════════════════════════════════╗
║                   LEARNING METRICS DASHBOARD                  ║
╠══════════════════════════════════════════════════════════════╣
║ Last Updated: {timestamp}                                     ║
║ Reviews Analyzed: {N}                                         ║
╠══════════════════════════════════════════════════════════════╣
║ ISSUE TRENDS                                                  ║
╠─────────────┬───────┬────────────────┬───────────────────────╣
║ Category    │ Total │ Last 5 Reviews │ Trend                  ║
╠─────────────┼───────┼────────────────┼───────────────────────╣
║ Logic       │ {N}   │ {N}            │ {↑↓→}                  ║
║ Security    │ {N}   │ {N}            │ {↑↓→}                  ║
║ Performance │ {N}   │ {N}            │ {↑↓→}                  ║
║ Quality     │ {N}   │ {N}            │ {↑↓→}                  ║
╠══════════════════════════════════════════════════════════════╣
║ RECURRING ISSUES (Need Attention)                             ║
╠══════════════════════════════════════════════════════════════╣
║ 1. {Issue title} - {N} occurrences                           ║
║ 2. {Issue title} - {N} occurrences                           ║
╠══════════════════════════════════════════════════════════════╣
║ IMPROVEMENT SUGGESTIONS                                       ║
╠──────────────┬──────────┬─────────────────────────────────────╣
║ Generated    │ Applied  │ Pending                             ║
║ {N}          │ {N}      │ {N}                                 ║
╠══════════════════════════════════════════════════════════════╣
║ LEARNING EFFECTIVENESS                                        ║
╠══════════════════════════════════════════════════════════════╣
║ Issues Prevented (est.): {N}                                  ║
║ Rules Updated: {N}                                            ║
║ Skills Enhanced: {N}                                          ║
╚══════════════════════════════════════════════════════════════╝
```

### Step 3: Recommendations

Based on metrics, suggest actions:

```
## Recommendations

{If recurring issues exist}
- **Address recurring issues:** Run `/validation:suggest-improvement` for top recurring issues

{If no recent analysis}
- **Run learning analysis:** No reviews analyzed recently. Run `/validation:learn`

{If suggestions pending}
- **Review pending suggestions:** {N} suggestions awaiting approval in `.claude/agents/learning/suggestions/`
```

## Output

Formatted dashboard display with recommendations.

## Example

```bash
/validation:learning-status
```
