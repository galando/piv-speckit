# PIV Spec-Kit

[![PIV Spec-Kit](https://img.shields.io/badge/PIV_Spec--Kit-Framework-blue?style=for-the-badge)](https://github.com/galando/piv-speckit)
[![Version](https://img.shields.io/badge/Version-4.3.0-green?style=for-the-badge)](https://github.com/galando/piv-speckit/blob/main/CHANGELOG.md)
[![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)](LICENSE)
[![Visual Guide](https://img.shields.io/badge/🌐_Visual_Guide-Interactive-467fd9?style=for-the-badge)](https://galando.github.io/piv-speckit/)
[![Inspired by Spec-Kit](https://img.shields.io/badge/Inspired_By-Spec--Kit-blue?style=for-the-badge)](https://github.com/github/spec-kit)
[![Ask DeepWiki](https://deepwiki.com/badge.svg)](https://deepwiki.com/galando/piv-speckit)

**PIV (Prime-Implement-Validate) + Spec-Kit: Structured specs, strict TDD, for AI-assisted development.**

**Zero-setup workflow** - just run `/piv-speckit:plan-feature` and context loads automatically!

**A Claude Code plugin for structured AI-assisted development.**

---

## What is PIV?

**PIV = Prime → Implement → Validate**

A development methodology for AI-assisted software development:

- **Prime (Auto)**: Context loads automatically when planning
- **Implement**: Write tests FIRST (strict TDD), then minimal code
- **Validate**: Automatic testing and verification

[→ Interactive Visual Guide](https://galando.github.io/piv-speckit/) | [→ Full Methodology](.claude/reference/methodology/PIV-METHODOLOGY.md) | [→ Changelog](CHANGELOG.md)

---

## Enhanced with Spec-Kit

This framework integrates best practices from [GitHub's Spec-Kit](https://github.com/github/spec-kit), adding **structured specification artifacts** to the PIV methodology.

### What This Adds

| Artifact | Purpose | Created By |
|----------|---------|------------|
| `spec.md` | Functional requirements (WHAT) | `/piv-speckit:plan-feature` |
| `plan.md` | Technical approach (HOW) | `/piv-speckit:plan-feature` |
| `tasks.md` | Implementation steps (DO) | `/piv-speckit:plan-feature` |
| `quickstart.md` | TL;DR for humans | `/piv-speckit:plan-feature` |
| `prime-context.md` | Codebase context (auto-generated) | Auto-prime in plan-feature |

### Artifact Format

All artifacts are **structured Markdown** - human-readable and version-controlled.

---

## Installation

```bash
# Add marketplace
/plugin marketplace add galando/piv-speckit

# Install PIV + Spec-Kit
/plugin install piv-speckit
```

**Commands:** `/piv-speckit:plan-feature` (auto-primes), `/piv-speckit:execute`, `/piv-speckit:prime` (optional)

**Features:** Auto-activating skills (TDD, code-review, security), full reference docs, agent context system.

---

## Architecture & Workflow

### Complete Development Flow

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                      PIV SPEC-KIT WORKFLOW                                 │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  1. PLAN (Auto-Primes + Structured Specs)                                  │
│     ┌─────────────────────────────────────────────────────────────────┐    │
│     │ /piv-speckit:plan-feature "Add user authentication"              │    │
│     │                                                                  │    │
│     │ → Auto-prime: loads/refreshes context silently                  │    │
│     │ → Creates .claude/specs/{feature}/                              │    │
│     │   ├─ spec.md        (WHAT: requirements, user stories)          │    │
│     │   ├─ plan.md        (HOW: architecture, data model, APIs)       │    │
│     │   ├─ tasks.md       (DO: step-by-step implementation)          │    │
│     │   └─ quickstart.md  (TL;DR: quick reference)                   │    │
│     └─────────────────────────────────────────────────────────────────┘    │
│                                    ↓                                        │
│  2. IMPLEMENT (Strict TDD)                                               │
│     ┌─────────────────────────────────────────────────────────────────┐    │
│     │ /piv-speckit:execute .claude/specs/{feature}/tasks.md              │    │
│     │                                                                  │    │
│     │   For each task:                                                 │    │
│     │   ├─ RED:   Write failing test first                            │    │
│     │   ├─ GREEN: Write minimal code to pass                          │    │
│     │   └─ REFACTOR: Improve while tests stay green                   │    │
│     │                                                                  │    │
│     │   Skills auto-activate: TDD, code-review, security              │    │
│     └─────────────────────────────────────────────────────────────────┘    │
│                                    ↓                                        │
│  3. VALIDATE (Automatic)                                                 │
│     ┌─────────────────────────────────────────────────────────────────┐    │
│     │ Auto-runs after execute                                          │    │
│     │ → Tests: all passing?                                           │    │
│     │ → Coverage: ≥80%?                                               │    │
│     │ → Security: no vulnerabilities?                                  │    │
│     │ → TDD compliance: tests written first?                          │    │
│     └─────────────────────────────────────────────────────────────────┘    │
│                                    ↓                                        │
│  4. COMMIT                                                                  │
│     ┌─────────────────────────────────────────────────────────────────┐    │
│     │ /commit                                                          │    │
│     │ → Conventional commit message                                    │    │
│     │ → Atomic, focused changes                                       │    │
│     └─────────────────────────────────────────────────────────────────┘    │
│                                                                             │
│  Optional: /piv-speckit:prime — Force context refresh anytime             │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

### Component Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                     SOURCE OF TRUTH                              │
│                     /.claude/ directory                         │
│                                                                    │
│  .claude/                                                          │
│  ├── commands/           # Slash command definitions            │
│  │   ├── piv_loop/       # Prime, Plan, Execute, Constitution   │
│  │   ├── validation/     # Validate, code-review, learn         │
│  │   └── bug_fix/        # RCA, fix                               │
│  ├── skills/            # Auto-activating quality enforcers      │
│  │   ├── test-driven-development    # TDD enforcement            │
│  │   ├── code-review                # Quality checks              │
│  │   ├── api-design                 # REST API patterns           │
│  │   └── security                   # Security guidelines         │
│  ├── specs/.templates/  # Spec artifact templates               │
│  ├── memory/           # Stored context (constitution)          │
│  └── reference/         # Complete methodology docs           │
└───────────────────────────────┬─────────────────────────────────┘
                                │
                                ▼
┌───────────────────────────────────────────────────────────────────┐
│                        CLAUDE CODE PLUGIN                         │
│                                                                   │
│  • Full slash commands (/piv-speckit:*)                           │
│  • Auto-activating skills (TDD, security, code-review)            │
│  • Smart context loading (reference-based)                        │
│  • Embedded templates and methodology docs                        │
└───────────────────────────────────────────────────────────────────┘
```

### Key Principles

| Principle | Description |
|-----------|-------------|
| **Context Layering** | Load only relevant context (~15KB), not entire codebase |
| **Spec Artifacts** | Split WHAT (spec), HOW (plan), DO (tasks) for clarity |
| **Strict TDD** | RED → GREEN → REFACTOR - never write code before tests |
| **Auto-Validation** | Quality checks run automatically after implementation |
| **Artifact-Driven** | All work captured in structured Markdown files |

---

## Key Features

| Feature | Description |
|---------|-------------|
| 🚨 **Strict TDD** | Mandatory RED-GREEN-REFACTOR cycle. Zero exceptions. |
| ⚡ **Skills System** | Auto-activating behaviors enforce best practices in real-time |
| 🧠 **Adaptive Learning** | Framework gets smarter with every feature you build |
| 🔧 **Technology Agnostic** | Works with Spring Boot, Node.js, Python, React, and more |
| ⚙️ **Commands** | `/piv-speckit:prime`, `/piv-speckit:plan-feature`, `/piv-speckit:execute` |

[→ See all features](docs/features/) | [→ Full commands list](docs/getting-started/02-quick-start.md#piv-commands-reference)

---

## 🎬 See It In Action

**Watch PIV power a real feature from start to finish:**

```
┌─────────────────────────────────────────────────────────────────────────┐
│  USER: "/piv-speckit:plan-feature 'password reset feature'"              │
│                                                                          │
│  CLAUDE: [Auto-primes silently, then plans]                             │
│    → Auto-prime: Scanning codebase context...                           │
│    → "Project: Spring Boot + React + PostgreSQL"                        │
│    → "15 Java classes, 8 React components identified"                  │
│    → Creates spec.md, plan.md, tasks.md, quickstart.md                 │
│    → Plan saved to .claude/specs/password-reset/                        │
└─────────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────────┐
│  USER: "/piv-speckit:execute"                                              │
│                                                                          │
│  CLAUDE: [test-driven-development SKILL ACTIVATES 🔴]                    │
│    → "🔴 RED: Writing test FIRST..."                                     │
│    → Creates PasswordResetServiceTest.java                             │
│    → Test FAILS ✅                                                       │
│                                                                          │
│    → "🟢 GREEN: Writing minimal code..."                                │
│    → Creates PasswordResetService.java                                │
│    → Test PASSES ✅                                                       │
│                                                                          │
│    → "🔵 REFACTOR: Improving..."                                       │
│    → Extracts EmailService to separate class                             │
│    → Tests STILL PASS ✅                                                 │
└─────────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────────┐
│  [validation:code-review SKILL ACTIVATES]                              │
│                                                                          │
│  CLAUDE: [Reviews code, references .claude/rules/security.md]            │
│    → "✅ Uses bcrypt for password hashing"                              │
│    → "✅ Token expires in 1 hour"                                       │
│    → "⚠️  Suggestion: Add rate limiting"                                 │
│    → Report saved to .claude/agents/code-reviews/                       │
└─────────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────────┐
│  [validation:learn SKILL ACTIVATES]                                    │
│                                                                          │
│  CLAUDE: [Extracts learning from review]                                 │
│    → "Pattern captured: Always set token expiration to 1 hour"          │
│    → "Pattern captured: Use bcrypt for password hashing"                │
│    → Saves to .claude/agents/learnings/                                │
│                                                                          │
│  → Next security feature: "Based on past learnings, I'll use           │
│     bcrypt and 1-hour expiration..."                                   │
└─────────────────────────────────────────────────────────────────────────┘
```

**This is the PIV difference:**
- ✅ **Active enforcement** - Skills activate in real-time
- ✅ **Captures learning** - Framework gets smarter
- ✅ **Reference-based** - Loads patterns from `${CLAUDE_PLUGIN_ROOT}/.claude-plugin/reference/`
- ✅ **Full trace** - Every step recorded and reviewable

---

## Documentation

### Getting Started
| Guide | Description |
|-------|-------------|
| [Quick Start](docs/getting-started/02-quick-start.md) | Get started in 5 minutes |
| [PIV Methodology](.claude/reference/methodology/PIV-METHODOLOGY.md) | Complete methodology guide |

**[→ Documentation Hub](docs/README.md)** — Full index: Features, Commands, Support, Extending

---

## Supported Technologies

**Backend:** Spring Boot • Node.js/Express • Python/FastAPI
**Frontend:** React + TypeScript
**Database:** PostgreSQL

[→ Add new technologies](docs/extending/01-adding-technologies.md)

---

## Repository Structure

```
piv-speckit/
├── .claude/                     # Claude Code plugin configuration
│   ├── CLAUDE.md                # Project instructions
│   ├── agents/                  # Artifact directories (plans, reviews, learning)
│   ├── archive/                 # Archived configurations
│   ├── commands/                # PIV command definitions
│   │   ├── bug_fix/             # RCA, implement-fix
│   │   ├── piv_loop/            # prime, plan-feature, execute
│   │   ├── product/             # create-prd
│   │   └── validation/          # validate, code-review, learn, etc.
│   ├── lib/                     # Shared libraries (issue-tracker)
│   ├── reference/               # Complete methodology docs
│   ├── rules/                   # Coding rules
│   │   └── backend/             # Backend-specific rules
│   └── skills/                  # Auto-activating behaviors
│       ├── adaptive-learning/
│       ├── api-design/
│       ├── code-review/
│       ├── security/
│       ├── test-driven-development/
│       └── test-writing/
├── .claude-plugin/              # Claude Code plugin manifest
│   ├── plugin.json              # Plugin configuration
│   ├── marketplace.json         # Marketplace listing
│   └── reference/               # Full reference documentation
├── .github/                     # GitHub configuration
│   ├── workflows/               # CI/CD workflows
│   └── ISSUE_TEMPLATE/          # Issue templates
├── docs/                        # Comprehensive documentation
│   ├── assets/                  # Documentation assets
│   ├── examples/                # Code examples
│   ├── extending/               # Extension guides
│   ├── features/                # Feature documentation
│   ├── getting-started/         # Getting started guides
│   ├── images/                  # Documentation images
│   ├── methodology/             # Methodology deep dives
│   └── index.html               # Visual interactive guide
├── video/                       # Video content
├── CHANGELOG.md                 # Version history
├── CONTRIBUTING.md              # Contributing guidelines
├── LICENSE                      # MIT License
├── README.md                    # This file
└── VERSION                      # Single source of truth for versioning
```

---

## Contributing

We welcome contributions! See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

---

## Origins

**PIV Methodology created by [Cole Medin (coleam00)](https://github.com/coleam00)**

Based on [context-engineering-intro](https://github.com/coleam00/context-engineering-intro) and [habit-tracker](https://github.com/coleam00/habit-tracker).

---

## License

MIT License - see [LICENSE](LICENSE)

---

**Made with ❤️ for the AI-assisted development community**
