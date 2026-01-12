# Installing PIV to Existing Projects

**How to add the PIV methodology to your existing project**

---

## Overview

This guide walks you through installing the PIV methodology into an existing project. The interactive installer will:

- ✅ **Detect your technology stack** automatically (Spring Boot, React, Node.js, etc.)
- ✅ **Preserve your existing configuration** (creates automatic backup)
- ✅ **Install PIV commands** for Prime-Implement-Validate workflow
- ✅ **Add coding rules** specific to your technology
- ✅ **Verify installation** to ensure everything works

**Installation time**: 1-2 minutes

---

## Prerequisites

Before installing, ensure you have:

- **Existing project** with business logic (backend, frontend, or both)
- **Git** repository (optional but recommended)
- **Bash** shell (macOS, Linux, or Windows with WSL)
- **Write permissions** in your project directory

**No other dependencies required** - the installer uses only standard Unix tools.

---

## Installation Methods

### Method 1: Clone and Run (Recommended)

```bash
# 1. Clone the PIV skeleton to a temporary location
git clone https://github.com/galando/claude-piv-skeleton.git /tmp/piv

# 2. Navigate to your existing project
cd /path/to/your-project

# 3. Run the installer
/tmp/piv/scripts/install-piv.sh
```

### Method 2: Direct Download

```bash
# From your project directory
cd /path/to/your-project

# Download and run installer
curl -sSL https://raw.githubusercontent.com/galando/claude-piv-skeleton/main/scripts/install-piv.sh | bash
```

### Method 3: Copy and Run

```bash
# 1. Copy the entire PIV skeleton to your project
cp -r /path/to/claude-piv-skeleton /tmp/

# 2. Navigate to your project
cd /path/to/your-project

# 3. Run the installer
/tmp/claude-piv-skeleton/scripts/install-piv.sh
```

---

## Installation Walkthrough

### Step 1: Welcome Screen

```
╔═══════════════════════════════════════════════════════════╗
║                                                           ║
║         PIV Methodology Installer for Existing Projects   ║
║                                                           ║
║    This will install the PIV (Prime-Implement-Validate)   ║
║    methodology into your existing project.                ║
║                                                           ║
╚═══════════════════════════════════════════════════════════╝
```

The installer will:
- Detect your technology stack
- Install PIV commands and rules
- Preserve your existing configuration
- Create a backup before making changes

### Step 2: Prerequisites Check

The installer automatically checks:
- ✅ Git repository (optional)
- ✅ Required commands (bash, cp, mkdir, rm)
- ✅ Write permissions

If any check fails, fix the issue and run the installer again.

### Step 3: Technology Detection

The installer scans your project for:

**Backend Technologies:**
- Spring Boot (pom.xml, build.gradle)
- Node.js/Express (package.json)
- Python/FastAPI (requirements.txt, pyproject.toml)
- Go (go.mod)
- Rust (Cargo.toml)
- Ruby (Gemfile)

**Frontend Technologies:**
- React (package.json)
- Vue.js (package.json)
- Angular (package.json)
- Svelte (package.json)
- Next.js (package.json)

**Databases:**
- PostgreSQL (dependencies, docker-compose)
- MySQL/MariaDB (dependencies, docker-compose)
- MongoDB (dependencies, docker-compose)
- Redis (dependencies, docker-compose)

**DevOps:**
- Docker (Dockerfile, docker-compose.yml)
- Kubernetes (k8s/ directory, YAML files)
- Terraform (*.tf files)

Example output:
```
Detected Technologies:
Backend:
  ✓ spring-boot

Frontend:
  ✓ react

Database:
  ✓ postgresql

DevOps:
  ✓ docker
```

### Step 4: Confirm Technologies

```
Is this correct? [Y/n]:
```

- Press **Enter** or **Y** to accept detected technologies
- Press **N** to select technologies manually

If you choose manual selection, you'll be prompted to pick your backend, frontend, database, and DevOps tools from a menu.

### Step 5: Choose Installation Mode

```
Choose how PIV should be installed:

  MERGE MODE (Recommended)
    • Integrates PIV into your existing .claude/ directory
    • Merges with your current configuration
    • Preserves your existing CLAUDE.md content
    • Best for: Full integration with PIV

  SEPARATE MODE
    • Creates a new .claude-piv/ directory
    • Keeps your .claude/ completely separate
    • Links PIV commands to your .claude/commands/
    • Best for: Trying PIV without changing existing setup

Select installation mode:
  [1] Merge mode (integrate with existing .claude/)
  [2] Separate mode (keep .claude-piv/ separate)
```

**Which mode should you choose?**

| Your Situation | Recommended Mode |
|----------------|------------------|
| New to PIV, want to try it | Separate mode |
| Want full integration | Merge mode |
| Have custom `.claude/` setup | Separate mode |
| Ready to commit to PIV | Merge mode |

### Step 6: Backup

If you have an existing `.claude/` directory, the installer automatically creates a backup:

```
Backing up existing .claude/ to .claude-backup-20250109-143022
✓ Backup created: .claude-backup-20250109-143022
```

The backup includes:
- All files in `.claude/`
- Metadata about the installation (mode, technologies, date)

You can restore this backup anytime if needed.

### Step 7: Installation

The installer now copies PIV files to your project:

**Merge Mode:**
```
Installing universal rules...
Installing PIV commands...
Installing PIV methodology documentation...
Installing technology-specific rules...
Updating CLAUDE.md...
✓ PIV installed successfully in merge mode
```

**Separate Mode:**
```
Copying PIV files to .claude-piv/...
Creating links to PIV commands...
Adding PIV reference to CLAUDE.md...
✓ PIV installed successfully in separate mode
```

### Step 8: Verification

The installer automatically verifies the installation:

```
Verifying PIV Installation
────────────────────────────────────────────────────────────

✓ Claude configuration directory
✓ PIV methodology documentation
✓ Project instructions
✓ Commands directory
✓ PIV loop commands
✓ Prime command
✓ Plan command
✓ Execute command
✓ Validation commands
✓ Validate command
✓ Rules directory
✓ General rules
✓ Git rules
✓ Testing rules
✓ Documentation rules
✓ Security rules
✓ CLAUDE.md contains PIV reference

────────────────────────────────────────────────────────────
Verification Summary

✓ Passed: 16
✓ All verification checks passed!
```

### Step 9: Success!

```
╔═══════════════════════════════════════════════════════════╗
║                                                           ║
║                    Installation Complete!                 ║
║                                                           ║
╚═══════════════════════════════════════════════════════════╝

✓ PIV has been installed successfully!
```

The installer shows:
- Installation summary
- Next steps
- Backup location (if created)

---

## After Installation

### Your First PIV Command

Start using PIV with Claude Code:

```
Ask Claude: "Run /piv_loop:prime to load project context"
```

This will load your project's context into Claude's working memory, including:
- Project structure
- Technology stack
- Coding rules
- PIV methodology

### Plan Your First Feature

```
Ask Claude: "Use /piv_loop:plan-feature to plan adding user authentication"
```

Claude will create a detailed implementation plan saved to `.claude/agents/plans/`.

### Implement Your Feature

```
Ask Claude: "Use /piv_loop:execute to implement the plan"
```

Claude will:
1. Execute the plan step by step
2. Write tests alongside code
3. Automatically validate the implementation
4. Generate execution and validation reports

---

## Installation Modes Explained

### Merge Mode

**What happens:**
- PIV files are copied into your existing `.claude/` directory
- Universal rules are added (if not present)
- Technology-specific rules are installed
- Your existing `CLAUDE.md` is preserved and merged with PIV content
- PIV commands are added to `.claude/commands/`

**Directory structure after install:**
```
your-project/
├── .claude/
│   ├── CLAUDE.md              # Your config + PIV section
│   ├── PIV-METHODOLOGY.md     # PIV methodology
│   ├── commands/
│   │   ├── piv_loop/          # PIV commands
│   │   ├── validation/        # Validation commands
│   │   ├── bug_fix/           # Bug fix commands
│   │   └── [your existing commands]
│   └── rules/
│       ├── 00-general.md      # Universal rules
│       ├── 10-git.md
│       ├── 20-testing.md
│       ├── 30-documentation.md
│       ├── 40-security.md
│       ├── backend/           # Backend rules (if detected)
│       └── [your existing rules]
```

**Best for:**
- Projects ready to fully adopt PIV
- Teams comfortable integrating new methodology
- Projects without extensive existing `.claude/` configuration

### Separate Mode

**What happens:**
- PIV files are copied to `.claude-piv/` directory (separate)
- Your existing `.claude/` is untouched
- Symlinks are created from `.claude/commands/` to `.claude-piv/commands/`
- A reference to `.claude-piv/` is added to your `CLAUDE.md`

**Directory structure after install:**
```
your-project/
├── .claude/                    # Your existing config (unchanged)
│   ├── CLAUDE.md              # Your config + PIV reference
│   └── commands/
│       ├── piv_loop -> ../.claude-piv/commands/piv_loop
│       ├── validation -> ../.claude-piv/commands/validation
│       └── bug_fix -> ../.claude-piv/commands/bug_fix
│
└── .claude-piv/                # Complete PIV installation
    ├── PIV-METHODOLOGY.md
    ├── HOW-TO-USE.md
    ├── commands/
    ├── rules/
    └── technologies/
```

**Best for:**
- Trying out PIV without commitment
- Projects with extensive existing `.claude/` configuration
- Teams who want to evaluate PIV before full adoption

**Switching modes:**
You can easily switch from separate to merge mode:
1. Uninstall PIV: `./scripts/uninstall-piv.sh`
2. Reinstall: `./scripts/install-piv.sh`
3. Choose merge mode

---

## What Gets Installed

### Core Files (Both Modes)

| File | Purpose |
|------|---------|
| `.claude/PIV-METHODOLOGY.md` | Complete PIV methodology guide |
| `.claude/commands/piv_loop/prime.md` | Prime phase command |
| `.claude/commands/piv_loop/plan-feature.md` | Plan phase command |
| `.claude/commands/piv_loop/execute.md` | Execute phase command |
| `.claude/commands/validation/validate.md` | Validation command |
| `.claude/rules/00-general.md` | General development rules |
| `.claude/rules/10-git.md` | Git workflow rules |
| `.claude/rules/20-testing.md` | Testing philosophy |
| `.claude/rules/21-testing.md` | Testing guidelines (Given-When-Then) |
| `.claude/rules/30-documentation.md` | Documentation standards |
| `.claude/rules/40-security.md` | Security guidelines |

### Technology-Specific Files (Based on Detection)

| Technology | Files Installed |
|------------|-----------------|
| Spring Boot | `.claude/rules/backend/10-api-design.md`, `.claude/rules/backend/20-database.md` |
| React | `.claude/rules/frontend/react-best-practices.md` |
| PostgreSQL | `.claude/rules/database/postgresql-best-practices.md` |
| Docker | Technology templates in `.claude-piv/technologies/devops/docker/` (separate mode) |

---

## Verification

After installation, verify PIV is working:

```bash
# Check that commands are available
ls -la .claude/commands/piv_loop/
ls -la .claude/commands/validation/

# Read the methodology
cat .claude/PIV-METHODOLOGY.md

# Or for separate mode:
cat .claude-piv/PIV-METHODOLOGY.md
```

**With Claude Code:**
```
Ask: "List available PIV commands"
```

Claude should show:
- `/piv_loop:prime`
- `/piv_loop:plan-feature "description"`
- `/piv_loop:execute`
- `/validation:validate`
- `/bug_fix:rca`
- `/bug_fix:implement-fix`

---

## Troubleshooting

### Installer Fails: "Permission Denied"

**Problem:** Script doesn't have execute permission

**Solution:**
```bash
chmod +x /tmp/piv/scripts/install-piv.sh
/tmp/piv/scripts/install-piv.sh
```

### Technology Detection is Wrong

**Problem:** Installer detects incorrect technologies

**Solution:** When prompted "Is this correct?", press **N** and select technologies manually from the menu.

### Backup Creation Fails

**Problem:** Can't create backup of existing `.claude/`

**Solution:**
1. Check available disk space: `df -h`
2. Ensure write permissions: `ls -la .claude/`
3. Manually backup: `cp -r .claude .claude-manual-backup`

### Installation Completes But Commands Don't Work

**Problem:** Claude Code doesn't recognize PIV commands

**Solution:**
1. Restart Claude Code
2. Check `.claude/commands/` directory exists
3. Verify command files have `.md` extension
4. Check `.claude/CLAUDE.md` references PIV

### Verification Fails

**Problem:** Installation verification shows errors

**Solution:**
1. Check the log: `cat .piv-install.log`
2. Restore backup: `./scripts/uninstall-piv.sh`
3. Run installer again

---

## Uninstalling PIV

If you want to remove PIV from your project:

```bash
# If you still have the PIV skeleton
/tmp/piv/scripts/uninstall-piv.sh

# Or download uninstall script
curl -sSL https://raw.githubusercontent.com/galando/claude-piv-skeleton/main/scripts/uninstall-piv.sh | bash
```

The uninstaller will:
1. Check for backup and offer to restore it
2. Remove PIV files (`.claude-piv/`, PIV commands, rules)
3. Clean up backup metadata
4. Show you any manual cleanup needed (like editing `CLAUDE.md`)

**Note:** Backup directories (`.claude-backup-*`) are not automatically deleted. You can remove them manually if satisfied with uninstall.

---

## Next Steps

1. **Read the methodology**: `.claude/PIV-METHODOLOGY.md` (or `.claude-piv/PIV-METHODOLOGY.md`)
2. **Prime your workspace**: Ask Claude to "Run `/piv_loop:prime`"
3. **Plan your first feature**: Use `/piv_loop:plan-feature` to create a plan
4. **Implement**: Use `/piv_loop:execute` to build your feature
5. **Learn more**: Check out [other guides](../)

---

**Questions?** Open an issue on [GitHub](https://github.com/galando/claude-piv-skeleton/issues)
