# Installation Guide

**How to install and set up the PIV skeleton for your project**

---

## Overview

This guide will walk you through cloning and setting up the PIV skeleton for a new project.

---

## Prerequisites

Before you begin, ensure you have:

- **Git** - For version control
- **Claude Code** - The Claude CLI tool (installed and configured)
- **Your chosen technology stack** - Node.js, Python, Java, etc.

---

## Installation Steps

### 1. Clone the Repository

```bash
# Clone this repository
git clone https://github.com/galando/claude-piv-skeleton.git my-project
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

### 4. Select Your Technologies

The skeleton includes templates for multiple technologies. Choose what you need:

#### Backend Technologies

```bash
# Keep only what you need
technologies/backend/spring-boot/     # Java/Kotlin
technologies/backend/node-express/    # Node.js
technologies/backend/python-fastapi/  # Python
```

#### Frontend Technologies

```bash
technologies/frontend/react/          # React + TypeScript
```

#### Database Technologies

```bash
technologies/database/postgresql/     # PostgreSQL
```

#### DevOps Technologies

```bash
technologies/devops/docker/           # Docker
```

**Remove unused technology directories** to keep your project clean.

### 5. Install Your Technology Stack

Follow technology-specific guides in the `technologies/` directories:

- **Spring Boot**: See `technologies/backend/spring-boot/README.md`
- **Node.js/Express**: See `technologies/backend/node-express/README.md`
- **Python/FastAPI**: See `technologies/backend/python-fastapi/README.md`
- **React**: See `technologies/frontend/react/README.md`

### 6. Verify Setup

Test that Claude Code recognizes your PIV setup:

```bash
# In Claude Code, run:
/core_piv_loop:prime
```

You should see context loading from your project.

---

## What's Included

After installation, your project includes:

### Core PIV Infrastructure
- ✅ Universal rules (`.claude/rules/`)
- ✅ PIV commands (`.claude/commands/`)
- ✅ Agent artifact templates (`.claude/agents/`)
- ✅ Project instructions (`.claude/CLAUDE.md`)
- ✅ Methodology documentation (`.claude/PIV-METHODOLOGY.md`)

### Technology Templates
- ✅ Backend templates (Spring Boot, Node.js, Python)
- ✅ Frontend templates (React)
- ✅ Database templates (PostgreSQL)
- ✅ DevOps templates (Docker)

### Documentation
- ✅ This installation guide
- ✅ Quick start guide
- ✅ Your first feature walkthrough
- ✅ Extending guides

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
- Verify `.claude/commands/` directory exists
- Check command files have `.md` extension
- Restart Claude Code

### Rules Not Loading

**Problem**: Technology-specific rules not being applied

**Solution**:
- Verify technology directory structure
- Check rules have numeric prefix (NN-name.md)
- Ensure `.claude/rules/` exists in technology directory

### Context Not Loading

**Problem**: Prime command doesn't load context

**Solution**:
- Check `.claude/agents/context/` directory exists
- Verify `.claude/CLAUDE.md` is present
- Run prime command again with verbose output

---

## Getting Help

If you encounter issues:

1. Check the [troubleshooting section](#troubleshooting)
2. Review [PIV Methodology](../../.claude/PIV-METHODOLOGY.md)
3. Open an issue on [GitHub](https://github.com/galando/claude-piv-skeleton/issues)

---

**Ready to start?** Continue to [Quick Start](02-quick-start.md)
