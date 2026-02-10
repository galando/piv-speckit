# Installation Guide

**How to install and set up PIV Spec-Kit for your project**

---

## Overview

PIV Spec-Kit is a **Claude Code plugin** installed directly from the marketplace.

---

## Prerequisites

Before you begin, ensure you have:

- **Claude Code** - The Claude CLI tool (installed and configured)
- **Git** - For version control

---

## Method 1: Install from Marketplace (Recommended)

**For any project** - Add PIV to your current project with a single command.

```bash
# In Claude Code, run:
/plugin marketplace add galando/piv-speckit
/plugin install piv-speckit
```

That's it! The plugin is now installed and ready to use.

### Verify Installation

```bash
# In Claude Code, run:
/piv-speckit:prime
```

You should see context loading from your project.

---

## Method 2: Clone and Customize

**For new projects or heavy customization** - Fork the framework and make it your own.

### 1. Clone the Repository

```bash
# Clone this repository
git clone https://github.com/galando/piv-speckit.git my-project
cd my-project
```

### 2. Initialize Fresh Git History

```bash
# Remove existing git history
rm -rf .git

# Initialize new git repository
git init

# Create initial commit
git add .
git commit -m "feat: initial commit from PIV skeleton"
```

### 3. Customize for Your Project

#### Update README.md

Edit `README.md` to describe your project:

```markdown
# My Project

> Brief description of your project

## Tech Stack
- Backend: [Your choice]
- Frontend: [Your choice]

## Installation
[Your installation instructions]

## Usage
[Your usage instructions]
```

#### Update .claude/CLAUDE.md

Add project-specific information at the top:

```markdown
# My Project

## Technology Stack
- Backend: [Your choice]
- Frontend: [Your choice]
- Database: [Your choice]

## Project Structure
[Brief description of your structure]
```

### 4. Customize Rules

Edit `.claude/rules/` to match your project's coding standards and preferences.

---

## What's Included

After installation, your project includes:

### Core PIV Infrastructure
- ✅ PIV commands (`.claude/commands/`)
- ✅ Skills for auto-activating behaviors (`.claude/skills/`)
- ✅ Coding rules (`.claude/rules/`)
- ✅ Issue tracker integration (`.claude/lib/issue-tracker/`)
- ✅ Project instructions (`.claude/CLAUDE.md`)
- ✅ Methodology documentation (`.claude/reference/methodology/`)
- ✅ Version tracking (`VERSION` in repo root)

### Plugin Configuration
- ✅ Plugin manifest (`.claude-plugin/plugin.json`)
- ✅ Marketplace listing (`.claude-plugin/marketplace.json`)
- ✅ Complete reference docs (`.claude-plugin/reference/`)

### Documentation
- ✅ This installation guide
- ✅ Quick start guide
- ✅ Your first feature walkthrough
- ✅ Feature documentation
- ✅ Troubleshooting guide

---

## Available Commands

| Command | Purpose |
|---------|---------|
| `/piv-speckit:plan-feature "desc"` | Create plan (auto-primes context) |
| `/piv-speckit:execute` | Implement from plan |
| `/piv-speckit:prime` | Force context refresh (optional) |
| `/piv-speckit:validate` | Run validation |
| `/piv-speckit:learn` | Extract learnings |
| `/piv-speckit:learning-status` | View metrics |
| `/piv-speckit:code-review` | Technical review |

---

## Auto-Activating Skills

PIV Spec-Kit includes skills that automatically activate to enforce best practices:

| Skill | Purpose |
|-------|---------|
| `test-driven-development` | Enforces RED-GREEN-REFACTOR cycle |
| `code-review` | Technical quality checks |
| `security` | Security best practices |
| `api-design` | REST API patterns |
| `test-writing` | Given-When-Then test structure |
| `adaptive-learning` | Captures learnings from your work |

---

## Next Steps

1. **Read the Quick Start** - [Quick Start Guide](02-quick-start.md)
2. **Build Your First Feature** - [Your First Feature](03-your-first-feature.md)
3. **Customize Rules** - Edit `.claude/rules/` to match your preferences
4. **Add Project Structure** - Set up your actual code structure

---

## Troubleshooting

### Claude Code Doesn't Recognize Commands

**Problem**: PIV commands not found

**Solution**:
- Verify `/plugin install piv-speckit` was run
- Check `.claude/commands/` directory exists
- Restart Claude Code

### Rules Not Loading

**Problem**: Rules not being applied

**Solution**:
- Verify `.claude/rules/` directory exists
- Check rules have numeric prefix (NN-name.md)
- Restart Claude Code

### Context Not Loading

**Problem**: Prime command doesn't load context

**Solution**:
- Verify `.claude/CLAUDE.md` is present
- Check `.claude/reference/` directory exists
- Run prime command again

---

## Getting Help

If you encounter issues:

1. Check the [troubleshooting section](#troubleshooting)
2. Review [PIV Methodology](../../.claude/reference/methodology/PIV-METHODOLOGY.md)
3. Open an issue on [GitHub](https://github.com/galando/piv-speckit/issues)

---

**Ready to start?** Continue to [Quick Start](02-quick-start.md)
