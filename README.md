# PIV Spec-Kit

[![PIV Spec-Kit](https://img.shields.io/badge/PIV_Spec--Kit-Framework-blue?style=for-the-badge)](https://github.com/galando/piv-speckit)
[![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)](LICENSE)
[![Visual Guide](https://img.shields.io/badge/🌐_Visual_Guide-Interactive-467fd9?style=for-the-badge)](https://galando.github.io/piv-speckit/)
[![Inspired by Spec-Kit](https://img.shields.io/badge/Inspired_By-Spec--Kit-blue?style=for-the-badge)](https://github.com/github/spec-kit)
[![Ask DeepWiki](https://deepwiki.com/badge.svg)](https://deepwiki.com/galando/piv-speckit)

**PIV (Prime-Implement-Validate) + Spec-Kit: Structured specs, strict TDD, for AI-assisted development.**

Works with **Claude Code**, **Cursor**, **GitHub Copilot**, **OpenAI Codex**, and 20+ AI coding tools.

---

## What is PIV?

**PIV = Prime → Implement → Validate**

A development methodology for AI-assisted software development:

- **Prime**: Load codebase context before making changes
- **Implement**: Write tests FIRST (strict TDD), then minimal code
- **Validate**: Automatic testing and verification

[→ Interactive Visual Guide](https://galando.github.io/piv-speckit/) | [→ Full Methodology](.claude/reference/methodology/PIV-METHODOLOGY.md)

---

## Enhanced with Spec-Kit

This framework integrates best practices from [GitHub's Spec-Kit](https://github.com/github/spec-kit), adding **structured specification artifacts** to the PIV methodology.

### What This Adds

| Artifact | Purpose | Created By |
|----------|---------|------------|
| `constitution.md` | Project principles (one-time setup) | `/piv_loop:constitution` |
| `spec.md` | Functional requirements (WHAT) | `/piv_loop:plan-feature` |
| `plan.md` | Technical approach (HOW) | `/piv_loop:plan-feature` |
| `tasks.md` | Implementation steps (DO) | `/piv_loop:plan-feature` |
| `quickstart.md` | TL;DR for humans | `/piv_loop:plan-feature` |

### Multi-AI Compatibility

All artifacts are **structured Markdown** - works with ANY AI tool:
- **Claude Code** (plugin) - Full experience with commands
- **Cursor** - Reads files directly
- **GitHub Copilot** - Reads files directly

No Claude Code dependency for planning or implementation!

---

## Installation

### Claude Code (Full Experience) ⭐ Recommended

```bash
# Add marketplace
/plugin marketplace add galando/piv-speckit

# Install PIV + Spec-Kit
/plugin install piv-speckit
```

**Commands:** `/piv_loop:prime`, `/piv_loop:plan-feature`, `/piv_loop:execute`, `/piv_loop:constitution`

**Features:** Auto-activating skills (TDD, code-review, security), full reference docs, agent context system.

### Cursor / GitHub Copilot / Other AI Tools

```bash
curl -s https://raw.githubusercontent.com/galando/piv-speckit/main/scripts/piv.sh | bash
```

**How it works:**
- Generates `AGENTS.md` - a single file with PIV methodology instructions
- Cursor, Copilot, and other tools read `AGENTS.md` automatically via their project-aware features
- **No slash commands** - type your requests naturally, the AI follows PIV methodology

**Difference from Claude Code:**

| Feature | Claude Code | Cursor / Copilot |
|---------|-------------|-------------------|
| Slash commands | ✅ `/piv_loop:*` | ❌ (natural language) |
| Auto-skills | ✅ TDD, security | ❌ |
| Constitution template | ✅ Included | ✅ Included |
| Spec templates | ✅ Included | ✅ Included |
| PIV methodology | ✅ Full | ✅ Compact (AGENTS.md) |

---

## Tool Comparison

| Feature | Claude Code (Plugin) | Cursor / Copilot (Script) |
|---------|---------------------|----------------------------|
| Commands | `/piv_loop:prime`, `/piv_loop:plan-feature`, `/piv_loop:execute`, `/piv_loop:constitution` | Natural language (AI reads AGENTS.md) |
| Auto-Skills | ✅ TDD, code-review, security activate automatically | ❌ |
| Spec Templates | ✅ Included | ✅ Included |
| Constitution | ✅ Included | ✅ Included |
| Context Loading | Smart layering (~15KB on-demand) | AGENTS.md (~500 lines, always loaded) |
| Updates | `/plugin update` | Re-run script |

---

## Architecture & Workflow

### Complete Development Flow

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                           PIV SPEC-KIT WORKFLOW                             │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  1. CONSTITUTION (One-time)                                                 │
│     ┌─────────────────────────────────────────────────────────────────┐    │
│     │ /piv_loop:constitution                                          │    │
│     │ → Creates .claude/memory/constitution.md                        │    │
│     │ → Defines: purpose, principles, stack, constraints              │    │
│     └─────────────────────────────────────────────────────────────────┘    │
│                                    ↓                                        │
│  2. PRIME (Context Loading)                                               │
│     ┌─────────────────────────────────────────────────────────────────┐    │
│     │ /piv_loop:prime                                                  │    │
│     │ → Analyzes codebase structure                                   │    │
│     │ → Identifies patterns, conventions, tech stack                  │    │
│     │ → Loads only relevant context (smart layering)                 │    │
│     └─────────────────────────────────────────────────────────────────┘    │
│                                    ↓                                        │
│  3. PLAN (Structured Specs)                                               │
│     ┌─────────────────────────────────────────────────────────────────┐    │
│     │ /piv_loop:plan-feature "Add user authentication"              │    │
│     │ → Creates .claude/specs/{feature}/                              │    │
│     │   ├─ spec.md        (WHAT: requirements, user stories)          │    │
│     │   ├─ plan.md        (HOW: architecture, data model, APIs)       │    │
│     │   ├─ tasks.md       (DO: step-by-step implementation)          │    │
│     │   └─ quickstart.md  (TL;DR: quick reference)                   │    │
│     └─────────────────────────────────────────────────────────────────┘    │
│                                    ↓                                        │
│  4. IMPLEMENT (Strict TDD)                                               │
│     ┌─────────────────────────────────────────────────────────────────┐    │
│     │ /piv_loop:execute .claude/specs/{feature}/tasks.md              │    │
│     │                                                                  │    │
│     │   For each task:                                                 │    │
│     │   ├─ RED:   Write failing test first                            │    │
│     │   ├─ GREEN: Write minimal code to pass                          │    │
│     │   └─ REFACTOR: Improve while tests stay green                   │    │
│     │                                                                  │    │
│     │   Skills auto-activate: TDD, code-review, security              │    │
│     └─────────────────────────────────────────────────────────────────┘    │
│                                    ↓                                        │
│  5. VALIDATE (Automatic)                                                 │
│     ┌─────────────────────────────────────────────────────────────────┐    │
│     │ Auto-runs after execute                                          │    │
│     │ → Tests: all passing?                                           │    │
│     │ → Coverage: ≥80%?                                               │    │
│     │ → Security: no vulnerabilities?                                  │    │
│     │ → TDD compliance: tests written first?                          │    │
│     └─────────────────────────────────────────────────────────────────┘    │
│                                    ↓                                        │
│  6. COMMIT                                                                  │
│     ┌─────────────────────────────────────────────────────────────────┐    │
│     │ /commit                                                          │    │
│     │ → Conventional commit message                                    │    │
│     │ → Atomic, focused changes                                       │    │
│     └─────────────────────────────────────────────────────────────────┘    │
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
        ┌───────────────────────┼───────────────────────────────┐
        ▼                       ▼                               ▼
┌───────────────┐      ┌───────────────┐              ┌───────────────┐
│  CLAUDE CODE  │      │    CURSOR     │              │ OTHER TOOLS   │
│   (Plugin)    │      │   (Script)    │              │   (Script)    │
│               │      │               │              │               │
│ Full commands │      │  AGENTS.md    │              │  AGENTS.md    │
│ Auto-skills   │      │  (< 500 lines)│              │               │
│ Smart context │      │               │              │               │
└───────────────┘      └───────────────┘              └───────────────┘
```

### Key Principles

| Principle | Description |
|-----------|-------------|
| **Context Layering** | Load only relevant context (~15KB), not entire codebase |
| **Spec Artifacts** | Split WHAT (spec), HOW (plan), DO (tasks) for clarity |
| **Strict TDD** | RED → GREEN → REFACTOR - never write code before tests |
| **Auto-Validation** | Quality checks run automatically after implementation |
| **Multi-AI Compatible** | All artifacts are Markdown - works with any AI tool |

---

## Key Features

| Feature | Description |
|---------|-------------|
| 🚨 **Strict TDD** | Mandatory RED-GREEN-REFACTOR cycle. Zero exceptions. |
| ⚡ **Skills System** | Auto-activating behaviors enforce best practices in real-time |
| 🧠 **Adaptive Learning** | Framework gets smarter with every feature you build |
| 🔧 **Technology Agnostic** | Works with Spring Boot, Node.js, Python, React, and more |
| ⚙️ **Commands** | `/piv_loop:prime`, `/piv_loop:plan-feature`, `/piv_loop:execute` |

[→ See all features](docs/features/) | [→ Full commands list](docs/getting-started/02-quick-start.md#piv-commands-reference)

---

## 🎬 See It In Action

**Watch PIV power a real feature from start to finish:**

```
┌─────────────────────────────────────────────────────────────────────────┐
│  USER: "/piv_loop:prime"                                                │
│                                                                          │
│  CLAUDE: [Loads project context]                                         │
│    → "Project: Spring Boot + React + PostgreSQL"                        │
│    → "Architecture: Controller → Service → Repository"                 │
│    → "15 Java classes, 8 React components identified"                  │
└─────────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────────┐
│  USER: "Plan a password reset feature"                              │
│  AI: Creates spec.md, plan.md, tasks.md, quickstart.md              │
│                                                                          │
│  CLAUDE: [Loads from .claude/reference/methodology/]                    │
│    → Reads PIV-METHODOLOGY.md for planning steps                        │
│    → [Loads from technologies/backend/spring-boot/]                      │
│    → Reads security patterns, email templates                           │
│    → Creates implementation plan...                                      │
│    → Plan saved to .claude/agents/plans/                               │
└─────────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────────┐
│  USER: "/piv_loop:execute"                                              │
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
- ✅ **Technology-aware** - Loads patterns from `technologies/`
- ✅ **Full trace** - Every step recorded and reviewable

---

## Documentation

| Guide | Description |
|-------|-------------|
| [Quick Start](docs/getting-started/02-quick-start.md) | Get started in 5 minutes |
| [PIV Methodology](.claude/reference/methodology/PIV-METHODOLOGY.md) | Complete methodology guide |
| [Cursor Support](docs/getting-started/05-cursor-support.md) | Using PIV with Cursor, Copilot, and more |
| [All Documentation](docs/README.md) | Full documentation index |

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
├── .claude/                     # Claude Code configuration
│   ├── CLAUDE.md                # Project instructions
│   ├── agents/                  # Artifact directories
│   ├── commands/                # PIV command definitions
│   ├── reference/               # Complete guides
│   ├── rules/                   # Coding rules
│   └── skills/                  # Auto-activating behaviors
├── .claude-plugin/              # Claude Code plugin manifest
├── marketplace/                 # Plugin marketplace catalog
├── AGENTS.md                    # Universal AI agent instructions
├── .cursor/rules/               # Cursor auto-attach rules
├── .github/                     # GitHub configuration
├── docs/                        # Comprehensive documentation
├── scripts/                     # Utility scripts
├── technologies/                # Technology templates
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
