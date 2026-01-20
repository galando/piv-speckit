# Universal AI Dev Framework

[![Universal AI Dev Framework](https://img.shields.io/badge/Universal_AI_Dev-Framework-blue?style=for-the-badge)](https://github.com/galando/universal-ai-dev-framework)
[![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)](LICENSE)
[![Visual Guide](https://img.shields.io/badge/🌐_Visual_Guide-Interactive-467fd9?style=for-the-badge)](https://galando.github.io/universal-ai-dev-framework/)
[![Buy Me A Coffee](https://img.shields.io/badge/Buy_Me_A_Coffee-FFDD00?style=for-the-badge&logo=buy-me-a-coffee&logoColor=black)](https://buymeacoffee.com/galando)
[![Ask DeepWiki](https://deepwiki.com/badge.svg)](https://deepwiki.com/galando/universal-ai-dev-framework)

**Universal PIV (Prime-Implement-Validate) methodology for AI-assisted development.**

Works with **Claude Code**, **Cursor**, **GitHub Copilot**, **OpenAI Codex**, and 20+ AI coding tools.

---

## What is PIV?

**PIV = Prime → Implement → Validate**

A development methodology for AI-assisted software development:

- **Prime**: Load codebase context before making changes
- **Implement**: Write tests FIRST (strict TDD), then minimal code
- **Validate**: Automatic testing and verification

[→ Interactive Visual Guide](https://galando.github.io/universal-ai-dev-framework/) | [→ Full Methodology](.claude/reference/methodology/PIV-METHODOLOGY.md)

---

## Installation

### Claude Code (Full Experience) ⭐ Recommended

```bash
# Add marketplace
/plugin marketplace add galando/universal-ai-dev-framework/marketplace

# Install PIV
/plugin install piv@universal-ai-dev-framework
```

**Commands:** `/piv:prime`, `/piv:plan-feature`, `/piv:execute`, `/piv:validate`

**Features:** Auto-activating skills (TDD, code-review, security), full reference docs, agent context system.

### Cursor / GitHub Copilot / Other AI Tools

```bash
curl -s https://raw.githubusercontent.com/galando/universal-ai-dev-framework/main/scripts/piv.sh | bash
```

**Generates:** `AGENTS.md` - universal AI agent instructions that Cursor and other tools read automatically.

---

## Tool Comparison

| Feature | Claude Code (Plugin) | Cursor / Others (Script) |
|---------|---------------------|--------------------------|
| PIV Methodology | ✅ Full | ✅ Compact (AGENTS.md) |
| Slash Commands | ✅ `/piv:*` | ❌ |
| Auto-Skills | ✅ TDD, Review, Security | ❌ |
| Context Loading | Smart (on-demand) | Always (~2500 tokens) |
| Auto-Update | ✅ Plugin system | Manual |
| Installation | `/plugin install` | `curl \| bash` |

---

## Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                     SOURCE OF TRUTH                              │
│                     /.claude/ directory                         │
└───────────────────────────────┬─────────────────────────────────┘
                                │
        ┌───────────────────────┼───────────────────────────────┐
        ▼                       ▼                               ▼
┌───────────────┐      ┌───────────────┐              ┌───────────────┐
│  CLAUDE CODE  │      │    CURSOR     │              │ OTHER TOOLS   │
│   (Plugin)    │      │   (Script)    │              │   (Script)    │
│               │      │               │              │               │
│ /piv:prime    │      │  AGENTS.md    │              │  AGENTS.md    │
│ /piv:plan     │      │  (< 500 lines)│              │               │
│ /piv:execute  │      │               │              │               │
│ + Skills      │      │               │              │               │
└───────────────┘      └───────────────┘              └───────────────┘
```

---

## Key Features

| Feature | Description |
|---------|-------------|
| 🚨 **Strict TDD** | Mandatory RED-GREEN-REFACTOR cycle. Zero exceptions. |
| ⚡ **Skills System** | Auto-activating behaviors enforce best practices in real-time |
| 🧠 **Adaptive Learning** | Framework gets smarter with every feature you build |
| 🔧 **Technology Agnostic** | Works with Spring Boot, Node.js, Python, React, and more |
| ⚙️ **Commands** | `/piv:prime`, `/piv:plan-feature`, `/piv:execute`, `/piv:validate` |

[→ See all features](docs/features/) | [→ Full commands list](docs/getting-started/02-quick-start.md#piv-commands-reference)

---

## 🎬 See It In Action

**Watch PIV power a real feature from start to finish:**

```
┌─────────────────────────────────────────────────────────────────────────┐
│  USER: "/piv:prime"                                                     │
│                                                                          │
│  CLAUDE: [Loads project context]                                         │
│    → "Project: Spring Boot + React + PostgreSQL"                        │
│    → "Architecture: Controller → Service → Repository"                 │
│    → "15 Java classes, 8 React components identified"                  │
└─────────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────────┐
│  USER: "/piv:plan-feature Add password reset flow"                    │
│                                                                          │
│  CLAUDE: [Loads from .claude/reference/methodology/]                    │
│    → Reads PIV-METHODOLOGY.md for planning steps                        │
│    → [Loads from technologies/backend/spring-boot/]                      │
│    → Reads security patterns, email templates                           │
│    → Creates implementation plan...                                      │
│    → Plan saved to .claude/agents/plans/                               │
└─────────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────────┐
│  USER: "/piv:execute"                                                   │
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
| [Cursor Support](docs/getting-started/05-cursor-support.md) | Using PIV with Cursor |
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
universal-ai-dev-framework/
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
