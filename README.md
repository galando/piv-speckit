# Claude Dev Framework

[![Claude Dev Framework](https://img.shields.io/badge/Claude_Dev_Framework-AI_Development-blue?style=for-the-badge&logo=anthropic)](https://github.com/galando/claude-dev-framework)
[![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)](LICENSE)
[![Visual Guide](https://img.shields.io/badge/🌐_Visual_Guide-Interactive_Methodology-467fd9?style=for-the-badge&logo=github)](https://galando.github.io/claude-dev-framework/)
[![Buy Me A Coffee](https://img.shields.io/badge/Buy_Me_A_Coffee-FFDD00?style=for-the-badge&logo=buy-me-a-coffee&logoColor=black)](https://buymeacoffee.com/galando)
[![Ask DeepWiki](https://deepwiki.com/badge.svg)](https://deepwiki.com/galando/claude-dev-framework)

**Universal PIV (Prime-Implement-Validate) methodology for AI-assisted development with Claude Code.**

A technology-agnostic, extensible framework with comprehensive documentation, rules, and templates to accelerate development while maintaining code quality.

---

## What is PIV?

**PIV = Prime → Implement → Validate**

A development methodology created by **Cole Medin** specifically for AI-assisted software development:

- **Prime**: Load codebase context before making changes
- **Implement**: Plan features, then execute (with strict TDD)
- **Validate**: Automatic testing and verification

[→ Interactive Visual Guide](https://galando.github.io/claude-dev-framework/) | [→ Full Methodology](.claude/reference/methodology/PIV-METHODOLOGY.md)

---

## Quick Start

### One-Line Install

```bash
curl -s https://raw.githubusercontent.com/galando/claude-dev-framework/main/scripts/piv.sh | bash
```

### Your First Feature (3 minutes)

```bash
# 1. Prime - Load context
/piv_loop:prime

# 2. Plan - Create implementation plan
/piv_loop:plan-feature "Add user authentication"

# 3. Execute - Implement with strict TDD
/piv_loop:execute

# 4. Validation runs automatically!
```

**TDD is enforced:** 🔴 RED (write failing test) → 🟢 GREEN (minimal code) → 🔵 REFACTOR (improve)

### Updating

Run the same command to update your installation:

```bash
curl -s https://raw.githubusercontent.com/galando/claude-dev-framework/main/scripts/piv.sh | bash
```

The script auto-detects if you need installation or update.

**Pin to a specific version:**
```bash
curl -s https://raw.githubusercontent.com/galando/claude-dev-framework/main/scripts/piv.sh | bash -s -- --version 1.1.0 --pin
```

**Preview changes without applying:**
```bash
curl -s https://raw.githubusercontent.com/galando/claude-dev-framework/main/scripts/piv.sh | bash -s -- --dry-run
```

---

## Key Features

| Feature | Description |
|---------|-------------|
| 🚨 **Strict TDD** | Mandatory RED-GREEN-REFACTOR cycle. Zero exceptions. |
| ⚡ **Skills System** | Auto-activating behaviors enforce best practices in real-time |
| 🧠 **Adaptive Learning** | Framework gets smarter with every feature you build |
| 🔧 **Technology Agnostic** | Works with Spring Boot, Node.js, Python, React, and more |
| ⚙️ **Commands** | `/piv_loop:prime`, `/piv_loop:plan-feature`, `/piv_loop:execute`, `/validation:validate` |

[→ See all features](docs/features/) | [→ Full commands list](docs/getting-started/02-quick-start.md#piv-commands-reference)

---

## Documentation

| Guide | Description |
|-------|-------------|
| [Quick Start](docs/getting-started/02-quick-start.md) | Get started in 5 minutes |
| [Installation](docs/getting-started/01-installation.md) | Detailed installation guide |
| [Your First Feature](docs/getting-started/03-your-first-feature.md) | Step-by-step walkthrough |
| [PIV Methodology](.claude/reference/methodology/PIV-METHODOLOGY.md) | Complete methodology guide |
| [All Documentation](docs/README.md) | Full documentation index |

---

## Supported Technologies

**Backend:** Spring Boot • Node.js/Express • Python/FastAPI
**Frontend:** React + TypeScript
**Database:** PostgreSQL
**DevOps:** Docker

[→ Add new technologies](docs/extending/01-adding-technologies.md)

---

## Contributing

We welcome contributions! See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

---

## Repository Structure

```
claude-dev-framework/
├── .claude/                     # Claude Code configuration
│   ├── CLAUDE.md                # Project instructions
│   ├── agents/                  # Artifact directories
│   ├── commands/                # PIV command definitions
│   ├── reference/               # Complete guides
│   ├── rules/                   # Coding rules
│   └── skills/                  # Auto-activating behaviors
├── .github/                     # GitHub configuration
│   ├── workflows/               # CI/CD workflows
│   └── ISSUE_TEMPLATE/          # Issue templates
├── docs/                        # Comprehensive documentation
│   ├── getting-started/         # Getting started guides
│   ├── features/                # Feature documentation
│   ├── extending/               # Extension guides
│   ├── methodology/             # Methodology deep dives
│   └── index.html               # GitHub Pages site
├── scripts/                     # Utility scripts
│   └── install/                 # Installer scripts
├── technologies/                # Technology templates
│   ├── backend/                 # Backend frameworks
│   ├── frontend/                # Frontend frameworks
│   ├── database/                # Databases
│   └── devops/                  # DevOps tools
├── CHANGELOG.md                 # Changelog
├── CONTRIBUTING.md              # Contributing guidelines
├── LICENSE                      # MIT License
└── README.md                    # This file
```

---

## Origins

**PIV Methodology created by [Cole Medin (coleam00)](https://github.com/coleam00)**

Based on [context-engineering-intro](https://github.com/coleam00/context-engineering-intro) and [habit-tracker](https://github.com/coleam00/habit-tracker).

---

## License

MIT License - see [LICENSE](LICENSE)

---

**Made with ❤️ for the Claude Code community**
