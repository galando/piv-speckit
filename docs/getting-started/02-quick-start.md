# Quick Start

**Get started with PIV methodology in 5 minutes**

---

## Overview

This guide will get you up and running with the PIV methodology quickly.

---

## Prerequisites

- Completed [Installation Guide](01-installation.md)
- Claude Code installed and working
- A project initialized from the skeleton

---

## The PIV Loop in 5 Minutes

### Phase 1: Prime (Load Context)

**Ask Claude Code**:
```
Run /piv_loop:prime to load the project context
```

**What happens**:
- Claude reads your project structure
- Loads relevant rules based on your tech stack
- Creates context artifact for future reference
- Understands your codebase architecture

**Time**: ~30 seconds

---

### Phase 2: Implement (Build Features)

#### Option A: Plan First (Recommended for Complex Features)

**1. Create a Plan**

**Ask Claude Code**:
```
Use /piv_loop:plan-feature to create a plan for adding [your feature]
```

**Example**:
```
Use /piv_loop:plan-feature to create a plan for adding user authentication
```

**What happens**:
- Claude explores your codebase
- Designs implementation approach
- Creates detailed step-by-step plan
- Considers architectural trade-offs
- Saves plan to `.claude/agents/plans/`

**Time**: ~1-2 minutes

**2. Execute the Plan**

**Ask Claude Code**:
```
Use /piv_loop:execute to implement the plan
```

**What happens**:
- Claude reads the plan
- Implements each step systematically
- Creates/modifies files as needed
- Follows your project's patterns

**Time**: Depends on feature complexity

#### Option B: Direct Implementation (Simple Changes)

For simple fixes or small features:

**Ask Claude Code**:
```
Implement this change: [describe what you need]
```

**Example**:
```
Implement this change: Add a timestamp field to the User entity
```

**Time**: ~30 seconds to a few minutes

---

### Phase 3: Validate (Automatic Verification)

**What happens**:
- Validation runs **automatically** after execute
- No manual command needed
- Runs comprehensive checks:
  - Environment safety
  - Compilation/build
  - Unit tests
  - Integration tests
  - Code quality checks
  - Coverage verification
  - Build verification

**Time**: ~1-2 minutes

---

### Phase 4: Learn (Optional - Continuous Improvement) 🆕

**What happens**:
- After code review, **adaptive-learning skill** suggests capturing learnings
- Run learning analysis to extract insights from code reviews
- Identify recurring patterns and improvement opportunities
- Generate suggestions to enhance rules, validation, and skills
- Track learning effectiveness over time

**Ask Claude Code**:
```
Run /validation:learn to analyze code reviews and extract insights
```

**What it does**:
- Parses all code review artifacts
- Identifies recurring issues across multiple reviews
- Extracts good patterns for reinforcement
- Generates improvement suggestions
- Updates learning metrics dashboard

**Time**: ~30 seconds

**Why it matters**:
- ✅ Framework gets smarter with every feature
- ✅ Recurring issues are systematically prevented
- ✅ Rules and skills continuously improve
- ✅ Technical debt prevented before it accumulates

**See [Adaptive Learning System](#adaptive-learning-system) below for details.**

---

## Typical Workflow

### New Feature (Complex)

```bash
# 1. Prime context
/piv_loop:prime

# 2. Plan feature
/piv_loop:plan-feature "Add user authentication"

# 3. Review plan (in .claude/agents/plans/)
# Edit if needed

# 4. Execute plan
/piv_loop:execute

# 5. Validation runs automatically
# ✨ No manual step needed!

# 6. Review results
/validation:execution-report
```

**Total Time**: 5-15 minutes (depending on complexity)

### Bug Fix (Simple)

```bash
# 1. Prime context (if not already done)
/piv_loop:prime

# 2. Implement fix directly
Fix the bug in UserService where null pointer occurs

# 3. Validation runs automatically
```

**Total Time**: 2-5 minutes

### Context Switch

```bash
# When switching to a new session or project
/piv_loop:prime
```

**Total Time**: 30 seconds

---

## PIV Commands Reference

### Core Commands

| Command | Purpose | When to Use |
|---------|---------|-------------|
| `/piv_loop:prime` | Load context | New session, context switch |
| `/piv_loop:plan-feature "desc"` | Create plan | Complex features, refactoring |
| `/piv_loop:execute` | Implement | Execute from plan |
| `/validation:validate` | Run validation | Manual validation (optional) |
| `/validation:code-review` | Code review | Detailed technical review |
| `/validation:execution-report` | View report | See what was executed |
| `/validation:learn` | **Extract learnings** | **After code reviews 🆕** |
| `/validation:learning-status` | **View learning metrics** | **Check progress 🆕** |

### Utility Commands

| Command | Purpose |
|---------|---------|
| `/commit` | Create atomic commit |
| `/github_bug_fix:rca` | Root cause analysis |
| `/github_bug_fix:implement-fix` | Implement bug fix from RCA |

---

## Best Practices

### ✅ DO

- **Always Prime** - Run prime at the start of each session
- **Plan Complex Work** - Use plan-feature for multi-step work
- **Review Plans** - Check generated plans before execution
- **Let Validation Run** - Don't skip automatic validation
- **Read Reports** - Review execution reports to understand changes

### ❌ DON'T

- **Don't Skip Prime** - Working without context leads to mistakes
- **Don't Over-Plan** - Simple changes don't need planning
- **Don't Ignore Validation** - Automatic validation catches issues early
- **Don't Deviate from Plans** - If you need changes, update the plan first

---

## Quick Examples

### Example 1: Add New API Endpoint

```bash
# 1. Prime
/piv_loop:prime

# 2. Plan
/piv_loop:plan-feature "Add REST API endpoint for creating users"

# 3. Execute
/piv_loop:execute

# 4. Review
/validation:execution-report
```

### Example 2: Fix Bug

```bash
# 1. Prime (if needed)
/piv_loop:prime

# 2. Implement directly
Fix the bug where user email validation doesn't reject invalid domains

# 3. Validation runs automatically
```

### Example 3: Refactor

```bash
# 1. Prime
/piv_loop:prime

# 2. Plan
/piv_loop:plan-feature "Refactor UserService to use repository pattern"

# 3. Execute
/piv_loop:execute
```

---

## Common Patterns

### When to Plan vs. Implement Directly

| Scenario | Approach |
|----------|----------|
| New API endpoint | Plan → Execute |
| Database migration | Plan → Execute |
| Bug fix | Implement directly |
| Add validation | Implement directly |
| Refactoring | Plan → Execute |
| New feature (complex) | Plan → Execute |
| New feature (simple) | Implement directly |
| Configuration change | Implement directly |

### When to Re-Prime

- **New session** - Always prime first
- **Context switch** - Switching projects or major features
- **After major changes** - If codebase changed significantly
- **Claude seems lost** - If Claude struggles with context

---

## Troubleshooting

### "Claude doesn't understand my codebase"

**Solution**: Run `/piv_loop:prime` to reload context

### "Plan doesn't match what I want"

**Solution**: Edit the plan in `.claude/agents/plans/` before executing

### "Validation fails"

**Solution**:
1. Check validation report: `/validation:execution-report`
2. Fix issues manually or ask Claude to fix
3. Re-run: `/validation:validate`

### "Execute makes unexpected changes"

**Solution**:
1. Review plan before execution
2. Start with git stash, review diff after execute
3. Revert if needed: `git checkout .`

---

## Adaptive Learning System 🆕

### Overview

**The framework gets smarter with every feature you build!**

The adaptive learning system is an **optional but recommended** feature that analyzes your code reviews to identify recurring patterns, extract best practices, and systematically improve the framework over time.

### How It Works

**The Learning Loop:**

```
Feature Implementation
        ↓
Code Review (automatic)
        ↓
Adaptive-Learning Suggests:
"Run /validation:learn?"
        ↓
Learning Analysis:
- Parse reviews
- Identify patterns
- Extract insights
        ↓
Improvement Suggestions:
- Flag recurring issues
- Propose rule updates
- Track metrics
        ↓
Framework Gets Smarter! 🧠
```

### Quick Start with Learning

**1. After your first code review, you'll see:**
```
✅ Code review complete.

Capture learnings? Run /validation:learn
```

**2. Extract insights:**
```bash
/validation:learn
```

**3. Check your learning status:**
```bash
/validation:learning-status
```

**4. If recurring issues found, generate improvements:**
```bash
/validation:suggest-improvement rule "Add input validation pattern"
```

### When to Use Learning

| Scenario | Action |
|----------|--------|
| After code review | `/validation:learn` (suggested automatically) |
| Before new feature | `/validation:learning-status` (check known issues) |
| Recurring issue found | `/validation:suggest-improvement` (create fix) |
| Periodically | `/validation:learn --last=5` (analyze trends) |

### Benefits

**For Your Project:**
- ✅ **Prevents Recurring Issues** - Learn from mistakes
- ✅ **Continuous Improvement** - Framework evolves with your codebase
- ✅ **Best Practices Capture** - Good patterns are reinforced automatically
- ✅ **Technical Debt Prevention** - Address issues systematically

**Example: Preventing N+1 Query Problem**

```bash
# Feature 1: Code review finds N+1 query issue
/validation:code-review

# Learning captures it
/validation:learn
# Output: "N+1 query found in UserService"

# Feature 2: Same issue found again
# Learning flags as recurring

# Feature 3: Generate improvement
/validation:suggest-improvement rule "Add N+1 query detection"

# Apply improvement to rules
# Now all future features are protected! ✅
```

### Key Concepts

**Learning vs. System Review:**

| Aspect | System Review | Adaptive Learning |
|--------|---------------|-------------------|
| **Analyzes** | PIV process (plan vs. execution) | Technical patterns (code issues) |
| **Improves** | Workflow efficiency | Rules, skills, validation |
| **Output** | Process recommendations | Concrete improvements |

**Semi-Automated Approach:**
- ✅ **Automatic:** Pattern extraction, trend analysis, suggestion generation
- ✅ **Manual:** Review and approval before applying changes
- ✅ **Safe:** No automatic rule modifications without human oversight

### Learning Artifacts

```
.claude/agents/learning/
├── insights/           # What we learned from reviews
├── suggestions/        # Proposed improvements (pending approval)
├── applied/            # Successfully applied improvements
└── learning-metrics.md # Dashboard showing progress
```

**What's Tracked:**
- Total reviews analyzed
- Issue trends (by category and severity)
- Recurring issues (need attention)
- Improvements generated vs. applied
- Learning effectiveness metrics

### FAQ

**Q: Is learning mandatory?**
A: **No, it's optional.** The adaptive-learning skill will suggest it, but you can skip. However, using it helps prevent recurring issues.

**Q: How often should I run learning?**
A: **After each code review** is ideal, but periodically (every 5-10 features) also works.

**Q: Can I customize what gets tracked?**
A: **Yes!** The learning system is modular and can be extended for project-specific needs.

**Q: Do I have to apply every suggestion?**
A: **No.** Suggestions are proposals. Review and approve only what makes sense for your project.

---

## Next Steps

1. **Build Your First Feature** - [Your First Feature](03-your-first-feature.md)
2. **Learn Methodology** - [PIV Methodology](../../.claude/reference/methodology/PIV-METHODOLOGY.md)
3. **Customize Rules** - Edit `.claude/rules/` to match your preferences

---

## Summary

**The PIV Loop in 3 Steps**:

1. **Prime** - Load context (30 seconds)
2. **Implement** - Plan + Execute (varies)
3. **Validate** - Automatic (1-2 minutes)

**Total**: As little as 2 minutes for simple changes

---

**Ready to build?** Continue to [Your First Feature](03-your-first-feature.md)
