# Feature: Installation System for Existing Projects

**Created**: 2025-01-09
**Status**: Planned

## Context

The current installation guide assumes users clone this repo to start a **new** project. However, users with **existing projects** (with business logic, backend, frontend, etc.) need a way to adopt the PIV methodology without starting from scratch.

**Current State:**
- Installation guide only covers cloning for new projects
- No automation for adding PIV to existing projects
- Manual process is error-prone and time-consuming

**Desired State:**
- Interactive installation script for existing projects
- Automatic technology detection (Spring Boot, React, Node.js, etc.)
- Intelligent merge handling for existing `.claude/` directories
- User choice between merge or separate installation modes
- Easy rollback if something goes wrong

## Requirements

### Functional Requirements
- [ ] FR-1: Interactive installation script that guides users through setup
- [ ] FR-2: Automatic detection of existing technologies (package.json, pom.xml, requirements.txt, etc.)
- [ ] FR-3: Backup of existing `.claude/` directory before installation
- [ ] FR-4: User choice between merge mode (add to existing) or separate mode (keep isolated)
- [ ] FR-5: Technology template installation based on detected stack
- [ ] FR-6: Rollback capability if installation fails or user is unsatisfied
- [ ] FR-7: Post-installation verification to ensure setup is correct

### Non-Functional Requirements
- [ ] NFR-1: Installation should complete in under 2 minutes
- [ ] NFR-2: Script must be cross-platform (macOS, Linux, Windows via WSL)
- [ ] NFR-3: Clear error messages and recovery options
- [ ] NFR-4: Idempotent - running multiple times should be safe
- [ ] NFR-5: No external dependencies beyond standard Unix tools (bash, curl, git)

## Technical Approach

### Architecture

**Installation Script Structure:**
```
scripts/
├── install-piv.sh              # Main interactive installer
├── install/
│   ├── core.sh                 # Core installation functions
│   ├── detect-tech.sh          # Technology detection
│   ├── backup.sh               # Backup/rollback functions
│   ├── merge-mode.sh           # Merge installation logic
│   ├── separate-mode.sh        # Separate installation logic
│   └── verify.sh               # Post-install verification
└── uninstall-piv.sh            # Rollback/uninstall script
```

### Installation Modes

#### Mode 1: Merge Installation
- Copies PIV files directly into existing `.claude/` directory
- Merges rules, commands, and templates
- Preserves user's existing CLAUDE.md if present
- Best for users who want PIV fully integrated

#### Mode 2: Separate Installation
- Creates `.claude-piv/` directory for PIV files
- Keeps existing `.claude/` untouched
- Adds symlink/reference in existing CLAUDE.md
- Best for users who want to try PIV without disruption

### Technology Detection Strategy

**Detection Logic:**
```bash
# Backend
detect_spring_boot() {
    if [[ -f "pom.xml" ]] && grep -q "spring-boot" pom.xml; then
        return 0
    fi
}

detect_nodejs() {
    if [[ -f "package.json" ]]; then
        return 0
    fi
}

detect_python() {
    if [[ -f "requirements.txt" || -f "pyproject.toml" ]]; then
        return 0
    fi
}

# Frontend
detect_react() {
    if [[ -f "package.json" ]] && grep -q "react" package.json; then
        return 0
    fi
}
```

**Confirmation Dialog:**
```
Detected Technologies:
✓ Spring Boot (backend)
✓ React (frontend)
✓ PostgreSQL (database)

Is this correct? [Y/n]:
Or select manually: [1] Spring Boot, [2] Node.js, [3] Python
```

### Backup Strategy

**Backup Process:**
```bash
# Create backup with timestamp
BACKUP_DIR=".claude-backup-$(date +%Y%m%d-%H%M%S)"

# Backup existing .claude if present
if [[ -d ".claude" ]]; then
    echo "Backing up existing .claude/ to $BACKUP_DIR"
    cp -r .claude $BACKUP_DIR
fi

# Store backup metadata
echo "$BACKUP_DIR" > .claude-install-backup
```

**Rollback Process:**
```bash
# Restore from backup if installation fails
restore_backup() {
    if [[ -f ".claude-install-backup" ]]; then
        BACKUP=$(cat .claude-install-backup)
        rm -rf .claude
        mv $BACKUP .claude
        echo "Restored from backup"
    fi
}
```

### Installation Flow

**Interactive Script Flow:**
```
1. Welcome screen
   ↓
2. Pre-flight checks (git repo, write permissions)
   ↓
3. Technology detection
   ↓
4. User confirmation
   ↓
5. Installation mode selection (merge/separate)
   ↓
6. Backup existing .claude (if present)
   ↓
7. Copy PIV files
   ↓
8. Install technology templates
   ↓
9. Update CLAUDE.md (merge or reference)
   ↓
10. Post-install verification
   ↓
11. Success message + next steps
```

### Patterns

**Shell Script Best Practices:**
- Use `set -euo pipefail` for error handling
- Modular functions in separate files (sourced by main script)
- Clear user prompts with color coding
- Logging to both terminal and log file
- Idempotent operations (check before create)

**User Interaction Patterns:**
```bash
# Colored output
print_success() { echo -e "\033[0;32m✓ $1\033[0m"; }
print_error() { echo -e "\033[0;31m✗ $1\033[0m"; }
print_info() { echo -e "\033[0;34mℹ $1\033[0m"; }

# Confirmation prompts
confirm() {
    read -p "$1 [Y/n]: " -n 1 -r
    echo
    [[ $REPLY =~ ^[Yy]$ ]] || [[ -z $REPLY ]]
}
```

### Trade-offs

**Decision: Shell script vs. Node.js/Python**
- ✅ **Chose Shell script**: No dependencies, universal availability
- ❌ **Rejected Node.js/Python**: Would require users to have runtime installed

**Decision: Merge vs. Separate modes**
- ✅ **Both options**: Users have different preferences and existing setups
- Trade-off: More complex script, but better user experience

**Decision: Auto-detect vs. Manual selection**
- ✅ **Both options**: Auto-detect with manual override
- Trade-off: More code, but reduces user friction

### Dependencies

**External Dependencies:**
- `git` - Version control (required)
- `curl` or `wget` - Downloading files (fallback to copy)
- `bash` - Shell version 4+ (macOS/Linux standard)

**Internal Dependencies:**
- `.claude/` directory structure
- Technology templates in `technologies/`
- PIV commands in `.claude/commands/`

## Implementation Steps

### Step 1: Create Installation Script Structure
**Files:**
- `scripts/install-piv.sh` - Main interactive installer
- `scripts/install/core.sh` - Core functions
- `scripts/install/detect-tech.sh` - Technology detection
- `scripts/install/backup.sh` - Backup/rollback
- `scripts/install/merge-mode.sh` - Merge installation
- `scripts/install/separate-mode.sh` - Separate installation
- `scripts/install/verify.sh` - Verification

**Notes:**
- Create modular structure for maintainability
- Source functions from core.sh in main script
- Use consistent naming conventions

### Step 2: Implement Core Functions
**Files:**
- `scripts/install/core.sh`

**Functions to implement:**
- `print_success()`, `print_error()`, `print_info()`, `print_warning()`
- `confirm()` - Prompt user for Y/n confirmation
- `check_prerequisites()` - Verify git, write permissions, etc.
- `create_directories()` - Create necessary directories
- `copy_files()` - Copy PIV files to target
- `update_claude_md()` - Update or create CLAUDE.md

### Step 3: Implement Technology Detection
**Files:**
- `scripts/install/detect-tech.sh`

**Detection functions:**
- `detect_spring_boot()` - Check for pom.xml with spring-boot
- `detect_nodejs()` - Check for package.json
- `detect_python()` - Check for requirements.txt or pyproject.toml
- `detect_react()` - Check package.json for react dependency
- `detect_postgres()` - Check for postgres in dependencies or config
- `detect_docker()` - Check for Dockerfile or docker-compose.yml

**User interface:**
```bash
echo "Detected Technologies:"
echo "  ✓ Spring Boot (backend)"
echo "  ✓ React (frontend)"
echo ""
if confirm "Is this correct?"; then
    # Use detected technologies
else
    # Manual selection
fi
```

### Step 4: Implement Backup & Rollback
**Files:**
- `scripts/install/backup.sh`

**Functions:**
- `backup_existing_claude()` - Backup .claude with timestamp
- `save_backup_metadata()` - Store backup location
- `restore_backup()` - Restore from backup on failure
- `rollback_installation()` - Complete rollback

**Backup metadata format:**
```bash
# .claude-install-backup
BACKUP_DIR=".claude-backup-20250109-143022"
MODE="merge"
TECHNOLOGIES="spring-boot,react"
DATE="2025-01-09 14:30:22"
```

### Step 5: Implement Merge Mode
**Files:**
- `scripts/install/merge-mode.sh`

**Process:**
1. Ensure `.claude/` exists (create if not)
2. Copy universal rules (if not present)
3. Copy PIV commands (merge with existing)
4. Copy technology-specific rules based on detection
5. Merge CLAUDE.md:
   - Preserve existing content
   - Add PIV section at top
   - Add technology-specific sections

**CLAUDE.md merge strategy:**
```bash
# If CLAUDE.md exists, create backup and prepend PIV section
if [[ -f ".claude/CLAUDE.md" ]]; then
    mv .claude/CLAUDE.md .claude/CLAUDE.md.backup
    cat > .claude/CLAUDE.md << 'EOF'
# [Project Name] - PIV Configuration

[PIV-specific content]

---

## Existing Project Configuration

[Include existing CLAUDE.md content here]
EOF
else
    # Use template
    cp templates/CLAUDE.md .claude/CLAUDE.md
fi
```

### Step 6: Implement Separate Mode
**Files:**
- `scripts/install/separate-mode.sh`

**Process:**
1. Create `.claude-piv/` directory
2. Copy entire PIV structure to `.claude-piv/`
3. Add reference to `.claude/CLAUDE.md`:
   ```markdown
   # PIV Methodology

   This project uses the PIV methodology. See `.claude-piv/PIV-METHODOLOGY.md` for details.
   ```
4. Create symlinks or copy selected commands to `.claude/commands/`

**Note:** Separate mode requires users to reference `.claude-piv/` explicitly in prompts.

### Step 7: Implement Verification
**Files:**
- `scripts/install/verify.sh`

**Checks:**
- [ ] `.claude/` or `.claude-piv/` directory exists
- [ ] `CLAUDE.md` exists and has PIV section
- [ ] Commands are present (`.claude/commands/piv_loop/`)
- [ ] Rules are present (`.claude/rules/`)
- [ ] Technology templates are installed
- [ ] Git status shows no unintended changes (except new files)

**Verification output:**
```bash
echo "Verifying installation..."
check_directory ".claude" "Claude configuration directory"
check_file ".claude/CLAUDE.md" "Project instructions"
check_file ".claude/PIV-METHODOLOGY.md" "PIV methodology"
check_directory ".claude/commands/piv_loop" "PIV commands"
check_directory ".claude/rules" "Coding rules"
echo "✓ Installation verified"
```

### Step 8: Create Main Interactive Installer
**Files:**
- `scripts/install-piv.sh`

**Structure:**
```bash
#!/bin/bash
set -euo pipefail

# Source installation functions
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/install/core.sh"
source "$SCRIPT_DIR/install/detect-tech.sh"
source "$SCRIPT_DIR/install/backup.sh"
source "$SCRIPT_DIR/install/merge-mode.sh"
source "$SCRIPT_DIR/install/separate-mode.sh"
source "$SCRIPT_DIR/install/verify.sh"

# Main installation flow
main() {
    print_welcome
    check_prerequisites
    detect_technologies
    confirm_technologies
    select_installation_mode
    backup_existing
    install_piv
    verify_installation
    print_success_message
}

main "$@"
```

**Welcome screen:**
```bash
print_welcome() {
    cat << "EOF"

╔═══════════════════════════════════════════════════════════╗
║                                                           ║
║   PIV Methodology Installer for Existing Projects         ║
║                                                           ║
║   This will install the PIV (Prime-Implement-Validate)   ║
║   methodology into your existing project.                 ║
║                                                           ║
╚═══════════════════════════════════════════════════════════╝

EOF
}
```

### Step 9: Create Uninstall Script
**Files:**
- `scripts/uninstall-piv.sh`

**Process:**
1. Check for backup metadata
2. Ask for confirmation
3. Remove PIV files
4. Restore backup if requested
5. Clean up backup metadata

### Step 10: Update Documentation
**Files to update:**
- `docs/getting-started/01-installation.md` - Add "Installing to Existing Projects" section
- `docs/getting-started/02-quick-start.md` - Add quick install command
- `README.md` - Add "Add to Existing Project" section
- `docs/getting-started/04-installing-to-existing-projects.md` - New comprehensive guide

**New documentation content:**
- Prerequisites for existing projects
- Installation modes (merge vs. separate)
- Technology detection explanation
- Step-by-step installation walkthrough
- Troubleshooting for common issues
- Rollback instructions

### Step 11: Create Test Cases
**Files:**
- `scripts/install/test/test-install.sh` - Test installation script
- `scripts/install/test/fixtures/` - Test project fixtures

**Test scenarios:**
- Install to project without `.claude/`
- Install to project with existing `.claude/`
- Merge mode preserves existing CLAUDE.md
- Separate mode keeps `.claude/` untouched
- Technology detection accuracy
- Rollback restores correctly

## Files to Create

| File | Purpose |
|------|---------|
| `scripts/install-piv.sh` | Main interactive installer |
| `scripts/install/core.sh` | Core utility functions |
| `scripts/install/detect-tech.sh` | Technology detection logic |
| `scripts/install/backup.sh` | Backup and rollback functions |
| `scripts/install/merge-mode.sh` | Merge installation mode |
| `scripts/install/separate-mode.sh` | Separate installation mode |
| `scripts/install/verify.sh` | Post-install verification |
| `scripts/uninstall-piv.sh` | Uninstall/rollback script |
| `scripts/install/test/test-install.sh` | Installation tests |
| `docs/getting-started/04-installing-to-existing-projects.md` | Detailed guide |
| `scripts/install/test/fixtures/java-project/` | Spring Boot test fixture |
| `scripts/install/test/fixtures/node-project/` | Node.js test fixture |
| `scripts/install/test/fixtures/full-stack/` | Full-stack test fixture |

## Files to Modify

| File | Changes |
|------|---------|
| `README.md` | Add "Add to Existing Project" section with install command |
| `docs/getting-started/01-installation.md` | Add "Installing to Existing Projects" section after new project instructions |
| `docs/getting-started/02-quick-start.md` | Add quick install command for existing projects |
| `.gitignore` | Ignore backup directories (`.claude-backup-*`) |
| `CONTRIBUTING.md` | Add note about testing installation script |

## Testing Strategy

### Unit Tests
- [ ] Test technology detection functions with various project structures
- [ ] Test backup creation and restoration
- [ ] Test file copying functions
- [ ] Test CLAUDE.md merge logic

### Integration Tests
- [ ] Test full installation on Spring Boot project
- [ ] Test full installation on Node.js project
- [ ] Test full installation on React project
- [ ] Test merge mode with existing `.claude/`
- [ ] Test separate mode preservation
- [ ] Test rollback on failure
- [ ] Test uninstall script

### Manual Testing
- [ ] Run installer on real existing project (e.g., woningscout)
- [ ] Test with interactive prompts (both Y and n responses)
- [ ] Test technology detection override
- [ ] Test verification catches incomplete installations
- [ ] Test rollback restores correctly
- [ ] Test on macOS, Linux, Windows (WSL)

### Test Fixtures
Create minimal project fixtures for testing:
- **Spring Boot fixture**: `pom.xml` with spring-boot dependency
- **Node.js fixture**: `package.json` with express
- **React fixture**: `package.json` with react
- **Full-stack fixture**: Both backend and frontend

## Verification Criteria

### Installation Success
- [ ] Installer completes without errors
- [ ] `.claude/` or `.claude-piv/` directory exists with all PIV files
- [ ] CLAUDE.md contains PIV configuration
- [ ] Technology-specific rules are installed
- [ ] Verification script passes all checks
- [ ] User can run `/piv_loop:prime` successfully

### Technology Detection
- [ ] Detects Spring Boot from `pom.xml`
- [ ] Detects Node.js from `package.json`
- [ ] Detects Python from `requirements.txt` or `pyproject.toml`
- [ ] Detects React from `package.json` dependencies
- [ ] Allows manual override when detection is wrong
- [ ] Handles unknown technologies gracefully

### Backup & Rollback
- [ ] Backup created before installation
- [ ] Backup metadata saved correctly
- [ ] Rollback restores pre-installation state
- [ ] Uninstall removes PIV files cleanly
- [ ] User can restore backup after uninstall

### User Experience
- [ ] Welcome screen is clear and welcoming
- [ ] Prompts are easy to understand
- [ ] Colored output enhances readability
- [ ] Error messages are helpful and actionable
- [ ] Installation completes in under 2 minutes
- [ ] Success message includes next steps

### Cross-Platform
- [ ] Works on macOS (bash 3.2+)
- [ ] Works on Linux (bash 4+)
- [ ] Works on Windows via WSL
- [ ] Handles path differences (Unix vs. Windows)

## Notes

### Edge Cases to Handle
- **Existing `.claude/commands/` directory**: Merge without overwriting custom commands
- **Read-only filesystem**: Detect and error gracefully
- **Insufficient permissions**: Check and warn user
- **Network unavailable**: Use local file copies (no git clone needed)
- **Interrupted installation**: Handle Ctrl+C gracefully, clean up partial installation
- **Multiple installation attempts**: Idempotent, safe to run again

### Future Enhancements
- **CI/CD Integration**: Automated installation for GitHub Actions, GitLab CI
- **Updates**: `update-piv.sh` script to update PIV to latest version
- **Configuration**: `.pivrc` file for user preferences
- **Plugin System**: Allow users to add custom technology templates
- **Version Management**: Support multiple PIV versions in same project

### Security Considerations
- Script should not execute arbitrary code from network
- Validate user inputs to prevent injection
- Check file permissions before writing
- Warn before overwriting existing files
- Backup should be read-only after creation

### Performance Considerations
- Technology detection should complete in < 5 seconds
- File copying should use efficient methods (rsync if available)
- Minimize filesystem operations
- Cache detection results for confirmation step

### Dependencies
- **No external dependencies**: Use only standard Unix tools
- **Optional dependencies**: Use `rsync` if available for faster copying
- **Fallback methods**: Use `cp` if `rsync` not available

## Related Issues
- GitHub Issue: (to be created)

## Next Steps

1. **Review this plan** with stakeholders
2. **Create installation script structure**
3. **Implement core functions**
4. **Test on sample projects**
5. **Refine based on feedback**
6. **Update documentation**
7. **Release with announcement**

---

**Ready to execute. Use `/core_piv_loop:execute` to implement this plan.**
