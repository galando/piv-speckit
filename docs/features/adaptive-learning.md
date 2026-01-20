# Adaptive Learning System

**The framework gets smarter with every feature you build!**

---

## Overview

The adaptive learning system transforms the universal-ai-dev-framework from a static rule enforcer into a self-improving quality system. After each code review, it automatically:

- **Analyzes reviews** to identify recurring patterns and issues
- **Extracts insights** about what works well and what doesn't
- **Generates improvement suggestions** for rules, validation checks, and skills
- **Tracks metrics** to show learning progress over time

---

## How It Works

**The Learning Loop:**

```
┌─────────────────────────────────────────────────────────────┐
│                    FEATURE IMPLEMENTATION                    │
└──────────────────────┬──────────────────────────────────────┘
                       │
                       ▼
┌─────────────────────────────────────────────────────────────┐
│                     CODE REVIEW                             │
│  ✓ Analyzes code quality, patterns, security, performance   │
└──────────────────────┬──────────────────────────────────────┘
                       │
                       ▼
┌─────────────────────────────────────────────────────────────┐
│              ADAPTIVE-LEARNING SKILL ACTIVATES              │
│  "Capture learnings? Run /validation:learn"                 │
└──────────────────────┬──────────────────────────────────────┘
                       │
                       ▼
┌─────────────────────────────────────────────────────────────┐
│                   LEARNING ANALYSIS                         │
│  • Parses review artifacts                                   │
│  • Identifies recurring issues                               │
│  • Extracts good patterns                                    │
│  • Generates insights artifact                                │
│  • Updates metrics dashboard                                 │
└──────────────────────┬──────────────────────────────────────┘
                       │
                       ▼
┌─────────────────────────────────────────────────────────────┐
│                 IMPROVEMENT SUGGESTIONS                      │
│  • Flag recurring issues                                     │
│  • Propose rule updates                                      │
│  • Suggest validation enhancements                           │
│  • Recommend skill improvements                              │
└──────────────────────┬──────────────────────────────────────┘
                       │
                       ▼
┌─────────────────────────────────────────────────────────────┐
│                 MANUAL REVIEW & APPROVAL                    │
│  • Review proposals                                          │
│  • Approve or reject                                        │
│  • Apply to codebase                                        │
│  • Track effectiveness                                      │
└──────────────────────┬──────────────────────────────────────┘
                       │
                       ▼
            ┌──────────────────────┐
            │ FRAMEWORK GETS       │
            │ SMARTER! 🧠          │
            └──────────────────────┘
```

---

## Commands

### `/validation:learn` - Extract Learnings from Code Reviews

**Purpose:** Analyze code review artifacts to identify patterns and generate insights

**Usage:**
```bash
# Analyze all code reviews
/validation:learn

# Analyze last 5 reviews only
/validation:learn --last=5

# Analyze specific review
/validation:learn --review=.claude/agents/reviews/code-review-feature-x.md
```

**What It Does:**
- ✅ Parses all code review artifacts
- ✅ Extracts issues by severity and category
- ✅ Identifies recurring patterns (appears in 2+ reviews)
- ✅ Extracts good patterns for reinforcement
- ✅ Generates learning insights artifact
- ✅ Updates metrics dashboard

**Output:**
- Creates: `.claude/agents/learning/insights/learning-insights-{timestamp}.md`
- Updates: `.claude/agents/learning/learning-metrics.md`

### `/validation:suggest-improvement` - Generate Improvement Suggestions

**Purpose:** Create structured improvement proposals for rules, validation, or skills

**Usage:**
```bash
# Suggest rule update
/validation:suggest-improvement rule "Add N+1 query anti-pattern"

# Suggest validation addition
/validation:suggest-improvement validation "Add environment URL check"

# Suggest skill enhancement
/validation:suggest-improvement skill "Enhance code-review with N+1 detection"
```

**What It Does:**
- ✅ Gathers context from learning insights
- ✅ Identifies target file (rule/validation/skill)
- ✅ Proposes specific change with rationale
- ✅ Includes evidence from code reviews
- ✅ Creates approval workflow

**Output:**
- Creates: `.claude/agents/learning/suggestions/{suggestion-id}.md`
- Updates: Metrics (increment suggestions generated)

### `/validation:learning-status` - View Learning Metrics Dashboard

**Purpose:** Display current learning status and metrics

**Usage:**
```bash
/validation:learning-status
```

**What It Shows:**
- 📊 Total reviews analyzed
- 📈 Issue trends by category and severity
- ⚠️ Recurring issues needing attention
- ✅ Improvements generated vs. applied
- 📉 Learning effectiveness metrics

---

## Auto-Activation

The **adaptive-learning skill** automatically suggests learning analysis after code reviews:

**When Issues Found:**
```
📊 Code review found 3 issues (1 high, 2 medium).

**Learning opportunity detected.**
Run /validation:learn to analyze if these issues are recurring
and generate improvement suggestions to prevent them in future.
```

**When Review Clean:**
```
✨ Clean code review! No issues found.

**Good patterns identified.**
Run /validation:learn to capture what went well
and reinforce good practices in the framework.
```

---

## Learning Artifacts

**Directory Structure:**
```
.claude/agents/learning/
├── insights/                    # Learning extracted from reviews
│   └── learning-insights-{timestamp}.md
├── suggestions/                 # Improvement proposals (pending)
│   └── {suggestion-id}.md
├── applied/                     # Successfully applied improvements
│   └── {suggestion-id}-applied.md
└── learning-metrics.md          # Aggregate metrics dashboard
```

---

## Key Differentiators

**Learning vs. System Review:**

| Aspect | System Review | Adaptive Learning |
|--------|---------------|------------------|
| **Focus** | PIV process quality | Technical patterns |
| **Analyzes** | Plan vs. execution | Code review outputs |
| **Identifies** | Workflow inefficiencies | Recurring code issues |
| **Improves** | Planning process | Rules/skills/validation |
| **Output** | Process recommendations | Rule/skill updates |

**Complementary:** Both improve quality, but in different dimensions. Use both together for comprehensive improvement!

---

## Benefits

**For Your Project:**
- ✅ **Prevents Recurring Issues** - Learn from mistakes and prevent them
- ✅ **Continuous Improvement** - Framework gets smarter over time
- ✅ **Best Practices Capture** - Good patterns are reinforced
- ✅ **Technical Debt Prevention** - Address issues before they accumulate

**For Your Team:**
- ✅ **Knowledge Sharing** - Learnings captured across all features
- ✅ **Quality Trends** - See issue patterns over time
- ✅ **Data-Driven Improvements** - Evidence-based rule updates
- ✅ **Consistent Standards** - Automatically reinforce good patterns

---

## Best Practices

**When to Run Learning Analysis:**
- ✅ After each code review (automatic suggestion)
- ✅ Before starting new features (check known issues)
- ✅ Periodically (analyze last 5 reviews for trends)
- ✅ After fixing bugs (was the issue recurring?)

**When to Generate Improvements:**
- ✅ When same issue appears in 2+ reviews
- ✅ When you identify a gap in rules/validation
- ✅ When you find a pattern that should be enforced
- ✅ When you want to add a new best practice

**Review Process:**
1. **Review insights** - Are patterns accurately identified?
2. **Evaluate suggestions** - Is the proposed change appropriate?
3. **Consider impact** - Will this improve quality?
4. **Approve or reject** - You have final say
5. **Track effectiveness** - Did the improvement work?

---

## Example Workflow

**Complete Learning Flow:**

```bash
# 1. Implement feature with PIV
/piv_loop:execute

# 2. Code review runs automatically
# (finds 2 medium issues)

# 3. Adaptive-learning skill suggests:
"📊 Code review found 2 issues.
 Capture learnings? Run /validation:learn"

# 4. Extract learnings
/validation:learn
# Output: "1 recurring issue: Missing input validation"

# 5. Generate improvement
/validation:suggest-improvement rule "Add API input validation pattern"
# Creates: suggestions/rule-api-validation-20250116.md

# 6. Review suggestion
cat .claude/agents/learning/suggestions/rule-api-validation-20250116.md
# Review: Looks good, evidence from 3 code reviews

# 7. Apply improvement
# Update .claude/rules/40-security.md with validation pattern

# 8. Mark as applied
mv suggestions/rule-api-validation-20250116.md \
    applied/rule-api-validation-20250116-applied.md

# 9. Next feature
# ✅ New code automatically follows new validation pattern!
```

**Result:** The framework now enforces API input validation, preventing that issue from occurring again!

---

## FAQ

**Q: Is learning automatic or manual?**
A: **Semi-automatic.** Extraction and suggestion are automatic, but applying improvements requires manual approval. This ensures quality and safety.

**Q: Do I have to use learning?**
A: **It's optional but recommended.** The adaptive-learning skill will suggest it, but you can skip. However, using it helps the framework (and your team!) get smarter over time.

**Q: How is this different from system review?**
A: **System review** analyzes your PIV process (did you follow the plan? was the plan good?). **Learning** analyzes technical patterns (what issues keep occurring? what patterns work well?). They complement each other.

**Q: Can I customize what gets tracked?**
A: **Yes!** The learning system is modular. You can extend it to track additional metrics, patterns, or improvements specific to your project.

**Q: What if I disagree with a suggestion?**
A: **That's fine!** Suggestions are proposals, not commands. Review them, reject if inappropriate, or modify before applying. You have final say.

**Q: How do I know if improvements are working?**
A: **Check the metrics!** Run `/validation:learning-status` to see issue trends over time. If improvements are working, you'll see recurring issues decrease.

---

## Next Steps

**Ready to start learning?**

1. **Complete a feature** using PIV methodology
2. **Run learning analysis** after code review: `/validation:learn`
3. **Check your status** with `/validation:learning-status`
4. **Generate improvements** for recurring issues
5. **Watch the framework** get smarter! 🧠

**For more information, see:**
- [Adaptive Learning Command Reference](../../.claude/commands/validation/)
- [Learning Artifacts Directory](../../.claude/agents/learning/)
- [Adaptive-Learning Skill](../../.claude/skills/adaptive-learning/)
