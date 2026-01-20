# Using PIV with Cursor (and Other AI Tools)

## Overview

The Universal AI Dev Framework works with Cursor through `AGENTS.md` - a compact, self-contained file that Cursor loads automatically.

## Installation

```bash
curl -s https://raw.githubusercontent.com/galando/universal-ai-dev-framework/main/scripts/piv.sh | bash
```

This generates `AGENTS.md` in your project root.

## What You Get

AGENTS.md includes (~150 lines):
- PIV methodology overview
- TDD requirements (RED-GREEN-REFACTOR)
- Code style guidelines
- Testing patterns (Given-When-Then)
- Git workflow rules
- Security basics

## Context Efficiency

- **< 500 lines** - Minimal token overhead
- **Self-contained** - No external file references
- **Always loaded** - Cursor reads it automatically

Estimated overhead: ~2500 tokens per conversation.

## Cursor Auto-Attach Rules

The installer also creates `.cursor/rules/` with auto-attach rules that activate based on file type:

| Rule File | Triggers On |
|-----------|-------------|
| `piv-general.mdc` | Always applies |
| `piv-tdd.mdc` | `*Test*`, `*.test.*`, `*_test.*` |
| `piv-api.mdc` | `*Controller*`, `*Router*`, `routes/*` |
| `piv-security.mdc` | `*Auth*`, `*Security*`, `*Password*` |

### How Auto-Attach Works

When you edit a file matching a pattern, Cursor automatically loads the corresponding rule:

```bash
# Edit a test file → TDD rules activate
vim UserServiceTest.java

# Edit a controller → API rules activate
vim UserController.java
```

## Supported Tools

AGENTS.md works with:
- ✅ Cursor
- ✅ GitHub Copilot
- ✅ OpenAI Codex
- ✅ Google Jules
- ✅ 20+ other AI coding tools

See: [AGENTS.md specification](https://agents.md/)

## Tool Comparison

| Feature | Cursor (AGENTS.md) | Claude Code (Plugin) |
|---------|-------------------|---------------------|
| **Always loaded** | ~2500 tokens | ~200 tokens |
| **On skill trigger** | N/A | +800-1500 tokens |
| **On command invoke** | N/A | +1200-2000 tokens |
| **Max context** | ~2500 tokens | ~4000 tokens |
| **Strategy** | Static | Dynamic (smart) |

## For Full Experience

Use Claude Code with the plugin for full features:

```bash
/plugin marketplace add galando/universal-ai-dev-framework/marketplace
/plugin install piv@universal-ai-dev-framework
```

**Claude Code exclusive features:**
- Slash commands: `/piv:prime`, `/piv:plan-feature`, `/piv:execute`
- Auto-activating skills (TDD, code-review, security)
- Agent context system
- Adaptive learning

## Example Workflow in Cursor

### 1. Load AGENTS.md

Cursor automatically loads `AGENTS.md` when you start working.

### 2. Ask for Feature

```
You: "Add user authentication to my Spring Boot app"

Cursor: "I'll add user authentication following TDD requirements.
Let me start by writing a failing test first (RED phase)..."
```

### 3. File-Based Rules

```
You: "Create a UserController"

Cursor: "I'll create a RESTful controller following API design rules.
• Nouns over verbs: /users
• Proper HTTP verbs: GET, POST, PUT, DELETE
• Consistent response format..."
```

## Tips for Cursor Users

1. **Keep AGENTS.md in project root** - Cursor reads it automatically
2. **Edit .cursor/rules/ to customize** - Add project-specific rules
3. **Reference PIV explicitly** - "Follow PIV methodology for this feature"
4. **Use Given-When-Then** - Ask for tests in this structure

## Troubleshooting

### AGENTS.md Not Loading

1. Verify file exists: `ls AGENTS.md`
2. Check file location (must be in project root)
3. Restart Cursor

### Rules Not Auto-Attaching

1. Check `.cursor/rules/` directory exists
2. Verify globs match your file patterns
3. Check Cursor settings for rules enablement

## Next Steps

- [PIV Methodology](../../.claude/reference/methodology/PIV-METHODOLOGY.md) - Complete guide
- [Quick Start](02-quick-start.md) - Get started in 5 minutes
- [GitHub Repository](https://github.com/galando/universal-ai-dev-framework) - Source code
