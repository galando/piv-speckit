---
description: Auto-suggests learning analysis after code reviews to capture insights and improve rules
triggers:
  - command: "/validation:code-review"
    when: "code review completed successfully"
  - command: "/validation:code-review-fix"
    when: "code review fix completed"
---

# Adaptive Learning Skill

## Activation

This skill **auto-activates after code reviews** to suggest capturing learnings.

**Triggers:**
- `/validation:code-review` completes (pass or fail)
- `/validation:code-review-fix` completes
- Manual invocation via `/validation:learn`

**IMPORTANT:** This is a **SKILL** that suggests learning, not enforces it.
Learning analysis is optional but recommended.

## Enforcement

**🧠 ADAPTIVE LEARNING PROMPTS:**

### After Code Review Completes

When code review completes:

```
✅ Code review complete.

**Capture learnings?**
Run `/validation:learn` to:
- Extract insights from this review
- Identify recurring patterns
- Update learning metrics
- Generate improvement suggestions

This helps the framework get smarter over time.
```

### When Issues Were Found

If code review found issues:

```
📊 Code review found {N} issues ({critical}, {high}, {medium}, {low}).

**Learning opportunity detected.**
Run `/validation:learn` to analyze if these issues are recurring
and generate improvement suggestions to prevent them in future.
```

### When Review Was Clean

If code review found no issues:

```
✨ Clean code review! No issues found.

**Good patterns identified.**
Run `/validation:learn` to capture what went well
and reinforce good practices in the framework.
```

## Behavior

When this skill activates:

### 1. Check Learning Metrics Status

Read `.claude/agents/learning/learning-metrics.md` to check:
- When was last analysis run?
- How many reviews since last analysis?
- Are there pending suggestions?

### 2. Generate Appropriate Prompt

Based on review outcome and metrics status:

**If issues found + no recent learning:**
- Strong suggestion to run learning analysis

**If clean review + no recent learning:**
- Gentle suggestion to capture good patterns

**If analysis run recently:**
- Light reminder that learning is available

### 3. Provide Learning Summary (if metrics exist)

Show brief learning status:
```
**Current Learning Status:**
- Reviews analyzed: {N}
- Recurring issues: {N} pending attention
- Suggestions: {N} pending approval

Run `/validation:learning-status` for full dashboard.
```

## Examples

### ✅ GOOD: Capturing Learnings

```
User: /validation:code-review

[Code review runs and completes]

Skill prompts:
"✅ Code review complete. Found 2 medium issues.

 Capture learnings? Run `/validation:learn` to analyze
 if these issues are recurring and suggest improvements."

User: /validation:learn

[Learning analysis runs, creates insights artifact]

"Learning analysis complete. 1 recurring issue identified:
 'Missing input validation on API endpoints (3 occurrences)'

 Run `/validation:suggest-improvement rule "Add API input validation pattern"`
 to create improvement suggestion."
```

### ✅ GOOD: Building Learning Over Time

```
Review 1: Found security issue → Learning captures it
Review 2: Same security issue → Learning flags as recurring
Review 3: Suggestion created → Rule updated with security pattern
Review 4: No security issues → Learning notes improvement!
```

## Integration Points

### With Code Review

After `/validation:code-review` completes:
- Skill activates
- Suggests learning analysis
- User can accept or skip

### With Code Review Fix

After `/validation:code-review-fix` completes:
- Skill activates
- Suggests learning analysis (what issues were fixed?)

### With System Review

**Complementary, not overlapping:**
- System Review = PIV process quality
- Learning = Technical patterns and rules

## Checklist

Before skipping learning analysis, consider:

- [ ] Are there issues that might be recurring?
- [ ] Would capturing this pattern help future features?
- [ ] Has it been a while since last learning analysis?
- [ ] Are there pending suggestions to review?

## Resources

**See Also:**
- `.claude/commands/validation/learn.md` - Learning analysis command
- `.claude/commands/validation/suggest-improvement.md` - Generate improvements
- `.claude/commands/validation/learning-status.md` - View metrics dashboard
- `.claude/agents/learning/` - Learning artifacts directory
