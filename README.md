# Claude Dev Framework

[![Claude Dev Framework](https://img.shields.io/badge/Claude_Dev_Framework-AI_Development-blue?style=for-the-badge&logo=anthropic)](https://github.com/galando/claude-dev-framework)
[![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)](LICENSE)
[![Visual Guide](https://img.shields.io/badge/🌐_Visual_Guide-Interactive_Methodology-467fd9?style=for-the-badge&logo=github)](https://galando.github.io/claude-dev-framework/)
[![Buy Me A Coffee](https://img.shields.io/badge/Buy_Me_A_Coffee-FFDD00?style=for-the-badge&logo=buy-me-a-coffee&logoColor=black)](https://buymeacoffee.com/galando)
[![Ask DeepWiki](https://deepwiki.com/badge.svg)](https://deepwiki.com/galando/claude-dev-framework)

**Universal PIV (Prime-Implement-Validate) methodology skeleton for Claude Code projects**

A technology-agnostic, extensible skeleton repository for implementing the PIV methodology with Claude Code. Provides comprehensive documentation, rules, and templates to accelerate development while maintaining code quality and consistency.

---

## What is PIV?

**PIV (Prime-Implement-Validate)** is a development methodology created by **Cole Medin** and designed specifically for AI-assisted software development with **strict Test-Driven Development (TDD)**:

- **Prime**: Load and understand codebase context before making changes
- **Implement**: Plan features and execute implementation (following RED-GREEN-REFACTOR TDD cycle)
- **Validate**: Automatically test, verify, and validate (including TDD compliance checks)

This methodology ensures Claude Code has proper context before making changes, creates detailed plans for complex features, follows mandatory TDD practices, and automatically validates implementations thoroughly.

![PIV Methodology Diagram](docs/images/PIVLoopDiagram.png)

---

## Quick Start

### 🌐 New to PIV?

**Start with the [interactive visual guide](https://galando.github.io/claude-dev-framework/) to understand the workflow in 5 minutes.**

### 🚀 One-Line Install (Existing Projects)

The fastest way to add PIV to your existing project:

```bash
curl -s https://raw.githubusercontent.com/galando/claude-dev-framework/main/scripts/install-piv.sh | bash
```

**Or download and run manually:**

```bash
git clone https://github.com/galando/claude-dev-framework.git /tmp/piv
cd your-project
/tmp/piv/scripts/install-piv.sh
```

The installer will:
- ✅ Detect your technology stack automatically
- ✅ Install PIV commands and rules
- ✅ Preserve your existing configuration
- ✅ Create automatic backup before making changes

**See [Installing to Existing Projects](docs/getting-started/04-installing-to-existing-projects.md) for detailed guide.**

### For New Projects

```bash
# Clone this repository
git clone https://github.com/galando/claude-dev-framework.git my-project
cd my-project

# Remove git history to start fresh
rm -rf .git
git init

# Install your technology stack
# (Follow technology-specific guides in technologies/ directory)
```

### Your First Feature

1. **Prime the workspace** - Load codebase context
   ```
   Ask Claude: "Run /piv_loop:prime to load the project context"
   ```

2. **Plan your feature** - Create detailed implementation plan
   ```
   Ask Claude: "Use /piv_loop:plan-feature to create a plan for adding user authentication"
   ```

3. **Execute** - Implement from plan (following TDD)
   ```
   Ask Claude: "Use /piv_loop:execute to implement the plan"
   ```

   **TDD is enforced during execution:**
   - 🔴 **RED**: Write failing test first
   - 🟢 **GREEN**: Write minimal code to pass
   - 🔵 **REFACTOR**: Improve while tests stay green

4. **Validate** - Automatic validation runs after execute
   ```
   No manual step - /validation:validate runs automatically!
   ```

   **Validation includes TDD compliance check** - fails if code written before tests!

5. **Bug Fixes** - When bugs occur
   ```
   Ask Claude: "Run /bug_fix:rca for issue #123"
   Ask Claude: "Use /bug_fix:implement-fix to fix the bug"
   ```

---

## Features

### 🚨 Strict Test-Driven Development (TDD)
- **MANDATORY TDD** - All code must follow RED-GREEN-REFACTOR cycle with zero exceptions
- **Zero Tolerance** - Code written before tests will be deleted
- **Skills Enforcement** - Auto-activating behaviors enforce TDD in real-time
- **Validation Fails** - Automatic validation fails if TDD violations detected
- **Test-First Culture** - Tests written FIRST (RED), then implementation (GREEN), then refactor (REFACTOR)

### Skills System: Auto-Activating Behaviors
- **Real-Time Enforcement** - Skills activate based on file patterns and commands
- **TDD Skill** - Enforces RED-GREEN-REFACTOR when writing implementation code
- **Test-Writing Skill** - Enforces Given-When-Then test structure
- **API Design Skill** - Enforces REST best practices for controllers
- **Security Skill** - Enforces OWASP Top 10 security checks
- **Code-Review Skill** - Systematic quality checks during reviews
- **Complements Commands** - Skills enhance manual commands, don't replace them

### Technology Agnostic Core
- Universal PIV methodology applicable to any technology stack
- Modular design allows picking only what you need
- Progressive enhancement - add technologies as needed

### Modular Rules System
- **Universal Rules**: Apply to all projects (git, testing, documentation, **strict TDD**)
- **Technology Rules**: Auto-loaded based on your stack
- **Path-based Loading**: Rules load automatically when working on specific file types

### Command Infrastructure
Standardized Claude Code commands for PIV workflow:
- `/piv_loop:prime` - Load context and prime workspace
- `/piv_loop:plan-feature "description"` - Create detailed feature plans
- `/piv_loop:execute [plan]` - Execute from plan (auto-validates)
- `/commit` - Create atomic commit with conventional commits (phase-based workflow)
- `/validation:validate` - Run validation pipeline (automatic)
- `/validation:code-review` - Optional detailed code review
- `/validation:code-review-fix` - Fix issues from code review
- `/validation:execution-report` - View execution report
- `/validation:system-review` - Analyze implementation vs plan
- `/validation:learn` - **Extract learnings from code reviews** 🆕
- `/validation:suggest-improvement` - **Generate improvement suggestions** 🆕
- `/validation:learning-status` - **View learning metrics dashboard** 🆕
- `/bug_fix:rca` - Root cause analysis for bugs
- `/bug_fix:implement-fix` - Implement bug fix from RCA
- `/product:create-prd [filename]` - Create Product Requirements Document

### 🧠 Adaptive Learning System 🆕

**The framework gets smarter with every feature you build!**

The adaptive learning system transforms the claude-dev-framework from a static rule enforcer into a self-improving quality system. After each code review, it automatically:

- **Analyzes reviews** to identify recurring patterns and issues
- **Extracts insights** about what works well and what doesn't
- **Generates improvement suggestions** for rules, validation checks, and skills
- **Tracks metrics** to show learning progress over time

**How It Works:**

```bash
# 1. Complete a feature (code review runs automatically)
/piv_loop:execute

# 2. Adaptive-learning skill suggests:
"✅ Code review complete. Capture learnings? Run /validation:learn"

# 3. Extract insights from all reviews
/validation:learn

# 4. Check learning status
/validation:learning-status

# 5. Generate improvement for recurring issue
/validation:suggest-improvement rule "Add N+1 query anti-pattern"
```

**What Makes It Different:**

- **System Review** = Analyzes PIV *process* quality (plan vs execution)
- **Adaptive Learning** = Analyzes *technical patterns* and improves rules/skills

**Key Benefits:**
- ✅ Framework learns from each code review
- ✅ Recurring issues automatically identified
- ✅ Rules and skills systematically improved
- ✅ Technical debt prevented before it accumulates
- ✅ Semi-automated (automatic extraction, manual approval)

**Learning Artifacts:**
- `insights/` - Learning extracted from code reviews
- `suggestions/` - Improvement proposals awaiting approval
- `applied/` - History of successfully applied improvements
- `learning-metrics.md` - Aggregate metrics dashboard

**See [Adaptive Learning Documentation](#adaptive-learning-system) below for details.**

### Technology Templates
Pre-built templates for popular technologies:
- **Backend**: Spring Boot, Node.js/Express, Python/FastAPI
- **Frontend**: React with TypeScript
- **Database**: PostgreSQL
- **DevOps**: Docker

Each template includes:
- Technology-specific rules
- Best practices reference
- Code examples
- Integration guides

### Comprehensive Documentation
- Methodology guides for each PIV phase
- Getting started tutorials
- Extending the skeleton
- Real-world examples

---

## Repository Structure

```
claude-dev-framework/
├── .claude/                     # Claude Code configuration
│   ├── CLAUDE.md                # Root project instructions (Tier 1: auto-loaded)
│   ├── reference/               # Tier 3: Complete guides (on-demand)
│   │   ├── methodology/         # Full PIV methodology
│   │   │   └── PIV-METHODOLOGY.md # Core methodology documentation
│   │   ├── rules-full/          # Complete rule sets (expanded)
│   │   └── skills-full/         # Complete skill definitions
│   ├── commands/                # PIV command definitions
│   │   ├── piv_loop/            # Core PIV workflow commands
│   │   │   ├── prime.md         # Prime phase command
│   │   │   ├── plan-feature.md  # Plan phase command
│   │   │   └── execute.md       # Execute phase command
│   │   ├── validation/          # Validation phase commands
│   │   │   ├── validate.md      # Full validation pipeline
│   │   │   ├── code-review.md   # Technical code review
│   │   │   ├── code-review-fix.md # Fix code review issues
│   │   │   ├── execution-report.md # Implementation report
│   │   │   └── system-review.md # Process improvement analysis
│   │   └── bug_fix/             # Bug fix workflow commands
│   │       ├── rca.md           # Root cause analysis
│   │       └── implement-fix.md # Implement bug fix
│   ├── rules/                   # Coding rules (Claude loads from here)
│   │   ├── backend/             # Technology-specific rules
│   │   │   ├── 10-api-design.md # Spring Boot API patterns
│   │   │   └── 20-database.md   # Spring Boot database patterns
│   │   ├── 00-general.md        # General development principles
│   │   ├── 05-pragmatic.md      # Pragmatic Programmer principles
│   │   ├── 10-git.md            # Git workflow rules
│   │   ├── 20-testing.md        # Testing philosophy (includes Given-When-Then)
│   │   ├── 22-tdd-strict.md     # Strict TDD enforcement
│   │   ├── 30-documentation.md  # Documentation standards
│   │   └── 40-security.md       # Security guidelines
│   ├── agents/                  # Agent artifact directories (auto-generated)
│   │   ├── context/             # Prime phase context artifacts
│   │   ├── plans/               # Plan phase artifacts
│   │   ├── reports/             # Execution and validation reports
│   │   ├── reviews/             # Code review and RCA artifacts
│   │   └── learning/            # 🆕 Adaptive learning artifacts
│   │       ├── insights/        # Learning insights from reviews
│   │       ├── suggestions/     # Improvement proposals
│   │       └── applied/         # Applied improvements history
│   ├── scripts/                 # Validation and maintenance scripts
│   ├── skills/                  # Auto-activating enforcement behaviors
│   │   ├── test-driven-development/
│   │   ├── test-writing/
│   │   ├── api-design/
│   │   ├── security/
│   │   ├── code-review/
│   │   └── adaptive-learning/
│   └── reference/               # Tier 3: Complete guides (on-demand)
│       ├── methodology/         # Full PIV methodology
│       ├── rules-full/          # Complete rule sets (expanded)
│       └── skills-full/         # Complete skill definitions
├── technologies/                # Technology-specific templates
│   ├── backend/                 # Backend frameworks
│   │   ├── spring-boot/         # Java/Kotlin + Spring Boot
│   │   │   ├── README.md        # Technology overview
│   │   │   ├── reference/       # Best practices reference
│   │   │   └── examples/        # Code examples
│   │   ├── node-express/        # Node.js + Express
│   │   └── python-fastapi/      # Python + FastAPI
│   ├── frontend/                # Frontend frameworks
│   │   └── react/               # React + TypeScript
│   ├── database/                # Databases
│   │   └── postgresql/          # PostgreSQL
│   └── devops/                  # DevOps tools
│       └── docker/              # Docker
├── docs/                        # Comprehensive documentation
│   ├── getting-started/         # Getting started guides
│   │   ├── 01-installation.md   # Installation guide
│   │   ├── 02-quick-start.md    # Quick start guide
│   │   └── 03-your-first-feature.md  # First feature walkthrough
│   ├── extending/               # Extension guides
│   │   └── 01-adding-technologies.md  # Adding new technologies
│   ├── methodology/             # Methodology deep dives
│   └── examples/                # Real-world examples
├── scripts/                     # Utility scripts
├── .github/                     # GitHub configuration
│   ├── workflows/               # CI/CD workflows
│   └── ISSUE_TEMPLATE/          # Issue templates
├── README.md                    # This file
├── CONTRIBUTING.md              # Contributing guidelines
└── LICENSE                      # MIT License
```

---

## Adaptive Learning System 🆕

### Overview

The adaptive learning system makes the claude-dev-framework **smarter with every feature you build**. It analyzes code review outputs to identify recurring patterns, generates improvement suggestions, and systematically enhances rules, validation checks, and skills over time.

### How It Works

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

### Commands

#### `/validation:learn` - Extract Learnings from Code Reviews

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

#### `/validation:suggest-improvement` - Generate Improvement Suggestions

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

#### `/validation:learning-status` - View Learning Metrics Dashboard

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

**Dashboard Display:**
```
╔══════════════════════════════════════════════════════════════╗
║                   LEARNING METRICS DASHBOARD                  ║
╠══════════════════════════════════════════════════════════════╣
║ Last Updated: 2025-01-16T23:16:52Z                            ║
║ Reviews Analyzed: 1                                            ║
╠══════════════════════════════════════════════════════════════╣
║ ISSUE TRENDS                                                  ║
║ Logic Errors: 0 | Security: 0 | Performance: 0 | Quality: 0    ║
╠══════════════════════════════════════════════════════════════╣
║ RECURRING ISSUES                                              ║
║ None identified yet                                          ║
╠══════════════════════════════════════════════════════════════╣
║ LEARNING EFFECTIVENESS                                        ║
║ Issues Prevented: 0 | Rules Updated: 0 | Skills Enhanced: 0   ║
╚══════════════════════════════════════════════════════════════╝
```

### Auto-Activation

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

### Learning Artifacts

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

**Learning Insights Artifact Structure:**
```markdown
# Learning Insights: {Date Range}

**Reviews Analyzed:** N
**Date Range:** {earliest} to {latest}

## Executive Summary
Analyzed N code reviews. Found X total issues. Y recurring issues.

## Issues Summary
### By Severity
| Severity | Count | % |
| Critical | X | Y% |
| High | X | Y% |

### By Category
| Category | Count | Recurring |
| Logic Errors | X | Y |
| Security | X | Y |

## Recurring Issues
### 1. {Issue Title}
- **Occurrences:** N times in {reviews}
- **Category:** {category}
- **Improvement Opportunity:** {suggestion}

## Good Patterns Found
### 1. {Pattern Name}
- **Found in:** {reviews}
- **Description:** {what worked well}
```

**Improvement Suggestion Artifact Structure:**
```markdown
# Improvement Suggestion: {Title}

**ID:** {suggestion-id}
**Type:** rule-update | validation-addition | skill-enhancement
**Priority:** critical | high | medium | low
**Status:** pending

## Problem
{Description of recurring issue}

## Evidence
- **Found in:** N code reviews
- **Source reviews:** {list}
- **Impact:** {description}

## Proposed Change
### Target File
`{path to file}`

### Proposed Content
{actual content to add}

### Rationale
{Why this prevents the issue}

## Approval
- [ ] Reviewed by human
- [ ] Approved for implementation
- [ ] Applied to codebase
```

### Key Differentiators

**Learning vs. System Review:**

| Aspect | System Review | Adaptive Learning |
|--------|---------------|------------------|
| **Focus** | PIV process quality | Technical patterns |
| **Analyzes** | Plan vs. execution | Code review outputs |
| **Identifies** | Workflow inefficiencies | Recurring code issues |
| **Improves** | Planning process | Rules/skills/validation |
| **Output** | Process recommendations | Rule/skill updates |

**Complementary:** Both improve quality, but in different dimensions. Use both together for comprehensive improvement!

### Benefits

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

### Best Practices

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

### Example Workflow

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

### Learning Effectiveness Metrics

The system tracks how well learning is working:

**Metrics Tracked:**
- **Issues Prevented** - Estimated count of issues prevented by improvements
- **Rules Updated** - Number of rules enhanced
- **Skills Enhanced** - Number of skills improved
- **Validation Checks Added** - New validation checks added

**Trend Analysis:**
- Issue trends (↑↓→) based on last 5 reviews
- Category breakdown (logic, security, performance, quality)
- Severity breakdown (critical, high, medium, low)

**Goal:** Continuously reduce recurring issues and improve code quality!

### FAQ

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

### Next Steps

**Ready to start learning?**

1. **Complete a feature** using PIV methodology
2. **Run learning analysis** after code review: `/validation:learn`
3. **Check your status** with `/validation:learning-status`
4. **Generate improvements** for recurring issues
5. **Watch the framework** get smarter! 🧠

**For more information, see:**
- [Adaptive Learning Command Reference](.claude/commands/validation/)
- [Learning Artifacts Directory](.claude/agents/learning/)
- [Adaptive-Learning Skill](.claude/skills/adaptive-learning/)

---

## Supported Technologies

### Backend
| Technology | Status | Description |
|------------|--------|-------------|
| Spring Boot | ✅ Stable | Java/Kotlin backend framework |
| Node.js + Express | ✅ Stable | JavaScript/TypeScript backend |
| Python + FastAPI | ✅ Stable | Modern Python async framework |

### Frontend
| Technology | Status | Description |
|------------|--------|-------------|
| React + TypeScript | ✅ Stable | React with strict TypeScript |

### Database
| Technology | Status | Description |
|------------|--------|-------------|
| PostgreSQL | ✅ Stable | Relational database |

### DevOps
| Technology | Status | Description |
|------------|--------|-------------|
| Docker | ✅ Stable | Containerization |

---

## Documentation

### 🌐 Interactive Methodology Guide

**New to PIV?** Start with the [interactive visual guide](https://galando.github.io/claude-dev-framework/) for a comprehensive walkthrough of the methodology.

The visual guide covers:
- **PIV Workflow** - How Prime, Implement, and Validate phases work together
- **Quick Start** - One-line installation and your first feature
- **Key Features** - Strict TDD, Skills System, Technology Templates
- **Code Examples** - Real-world PIV commands and workflows

Perfect for visual learners and anyone who wants to understand PIV in 5 minutes.

### Getting Started
- [Installation Guide](docs/getting-started/01-installation.md) - How to install and set up
- [Quick Start](docs/getting-started/02-quick-start.md) - Get started in 5 minutes
- [Your First Feature](docs/getting-started/03-your-first-feature.md) - Walkthrough of first feature
- [FAQ](docs/FAQ.md) - Frequently asked questions

### Methodology
- [PIV Methodology](.claude/reference/methodology/PIV-METHODOLOGY.md) - Complete methodology guide
- [Project Instructions](.claude/CLAUDE.md) - Quick reference for Claude Code

### Contributing
- [Contributing Guidelines](CONTRIBUTING.md) - How to contribute to the skeleton
- [Adding Technologies](docs/extending/01-adding-technologies.md) - Add new technology templates

### Resources
- [FAQ](docs/FAQ.md) - Frequently asked questions
- [Troubleshooting Guide](docs/troubleshooting.md) - Common issues and solutions

---

## Contributing

We welcome contributions! This skeleton is designed to be community-driven and extensible.

### Ways to Contribute
1. **Add new technologies** - Follow the [Adding Technologies guide](docs/extending/01-adding-technologies.md)
2. **Improve documentation** - Fix typos, clarify explanations, add examples
3. **Share examples** - Add real-world implementation examples
4. **Report issues** - Found a bug or have a suggestion? [Open an issue](https://github.com/galando/claude-dev-framework/issues)
5. **Submit PRs** - Pull requests are welcome!

See [CONTRIBUTING.md](CONTRIBUTING.md) for detailed guidelines.

---

## Origins & Attribution

**The PIV Methodology was created by [Cole Medin (coleam00)](https://github.com/coleam00)**

Cole Medin is a Generative AI specialist who developed the PIV (Prime-Implement-Validate) methodology as part of his work on [context engineering](https://github.com/coleam00/context-engineering-intro) and AI-assisted development workflows. The methodology is demonstrated in his [habit-tracker](https://github.com/coleam00/habit-tracker) project.

This skeleton is an implementation of Cole's PIV methodology, adapted from:
- [habit-tracker](https://github.com/coleam00/habit-tracker) - PIV loop demonstration project
- [context-engineering-intro](https://github.com/coleam00/context-engineering-intro) - Context engineering template
- [woningscoutje.nl](https://woningscoutje.nl) - Production-ready implementation using PIV

### Cole Medin's Other Work
- [Archon](https://github.com/coleam00/Archon) - Knowledge and task management backbone for AI assistants
- [ottomator-agents](https://github.com/coleam00/ottomator-agents) - Open source AI agents
- [ai-agents-masterclass](https://github.com/coleam00/ai-agents-masterclass) - AI agents educational content

**Thank you, Cole, for creating and sharing the PIV methodology with the community!** 🙌

---

## License

MIT License - see [LICENSE](LICENSE) for details.

---

**Made with ❤️ for the Claude Code community**
