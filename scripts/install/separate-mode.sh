#!/bin/bash
# separate-mode.sh - Separate mode installation for PIV
# Installs PIV in separate .claude-piv directory, keeping existing .claude untouched

# Source core functions if not already loaded
#if [ -z "${print_info+x}" ]; then
#    source "$(dirname "${BASH_SOURCE[0]}")/core.sh"
#fi

# Note: PIV_SOURCE_DIR is declared as exported in install-piv.sh
# This script uses that exported variable

# Set PIV source directory
# Usage: set_piv_source "path"
set_piv_source() {
    PIV_SOURCE_DIR="$1"
}

# Install PIV in separate mode
# Usage: install_separate_mode
install_separate_mode() {
    print_header "Installing PIV (Separate Mode)"

    local piv_dir=".claude-piv"

    # Create .claude-piv directory
    if [ -d "$piv_dir" ]; then
        print_warning "$piv_dir already exists"
        if ! confirm "Remove existing $piv_dir and reinstall?"; then
            print_info "Installation cancelled"
            return 1
        fi
        rm -rf "$piv_dir"
    fi

    ensure_dir "$piv_dir"

    # Copy entire PIV structure
    print_info "Copying PIV files to $piv_dir..."

    # Copy PIV methodology
    if [ -f "$PIV_SOURCE_DIR/.claude/PIV-METHODOLOGY.md" ]; then
        copy_file "$PIV_SOURCE_DIR/.claude/PIV-METHODOLOGY.md" "$piv_dir/PIV-METHODOLOGY.md"
    fi

    # Copy rules
    if [ -d "$PIV_SOURCE_DIR/.claude/rules" ]; then
        print_info "Copying rules..."
        copy_file "$PIV_SOURCE_DIR/.claude/rules" "$piv_dir/rules"
    fi

    # Copy commands
    if [ -d "$PIV_SOURCE_DIR/.claude/commands" ]; then
        print_info "Copying commands..."
        copy_file "$PIV_SOURCE_DIR/.claude/commands" "$piv_dir/commands"
    fi

    # Copy technology templates (reference only)
    if [ -d "$PIV_SOURCE_DIR/technologies" ]; then
        print_info "Copying technology templates..."
        copy_file "$PIV_SOURCE_DIR/technologies" "$piv_dir/technologies"
    fi

    # Create symlink in existing .claude/commands to PIV commands
    if [ -d ".claude/commands" ]; then
        print_info "Creating links to PIV commands..."
        ensure_dir ".claude/commands/piv_loop"
        ensure_dir ".claude/commands/validation"
        ensure_dir ".claude/commands/bug_fix"

        # Link command files (symlinks from .claude/commands/ to .claude-piv/commands/)
        # From .claude/commands/piv_loop/ we need ../../../ to reach project root
        for cmd_file in "$piv_dir/commands/piv_loop"/*.md; do
            if [ -f "$cmd_file" ]; then
                local basename=$(basename "$cmd_file")
                ln -sf "../../../$piv_dir/commands/piv_loop/$basename" ".claude/commands/piv_loop/$basename"
            fi
        done

        for cmd_file in "$piv_dir/commands/validation"/*.md; do
            if [ -f "$cmd_file" ]; then
                local basename=$(basename "$cmd_file")
                ln -sf "../../../$piv_dir/commands/validation/$basename" ".claude/commands/validation/$basename"
            fi
        done

        for cmd_file in "$piv_dir/commands/bug_fix"/*.md; do
            if [ -f "$cmd_file" ]; then
                local basename=$(basename "$cmd_file")
                ln -sf "../../../$piv_dir/commands/bug_fix/$basename" ".claude/commands/bug_fix/$basename"
            fi
        done
    else
        # No existing .claude/commands, create the structure
        ensure_dir ".claude/commands"

        # Create individual command directories (not symlinks)
        ensure_dir ".claude/commands/piv_loop"
        ensure_dir ".claude/commands/validation"
        ensure_dir ".claude/commands/bug_fix"

        # Link command files from .claude-piv (same path: from .claude/commands/ go up 3 levels)
        for cmd_file in "$piv_dir/commands/piv_loop"/*.md; do
            if [ -f "$cmd_file" ]; then
                local basename=$(basename "$cmd_file")
                ln -sf "../../../$piv_dir/commands/piv_loop/$basename" ".claude/commands/piv_loop/$basename"
            fi
        done

        for cmd_file in "$piv_dir/commands/validation"/*.md; do
            if [ -f "$cmd_file" ]; then
                local basename=$(basename "$cmd_file")
                ln -sf "../../../$piv_dir/commands/validation/$basename" ".claude/commands/validation/$basename"
            fi
        done

        for cmd_file in "$piv_dir/commands/bug_fix"/*.md; do
            if [ -f "$cmd_file" ]; then
                local basename=$(basename "$cmd_file")
                ln -sf "../../../$piv_dir/commands/bug_fix/$basename" ".claude/commands/bug_fix/$basename"
            fi
        done
    fi

    # Add PIV reference to existing CLAUDE.md
    if [ -f ".claude/CLAUDE.md" ]; then
        print_info "Adding PIV reference to CLAUDE.md..."
        append_piv_reference ".claude-piv/PIV-METHODOLOGY.md"
    else
        # Create .claude directory if it doesn't exist
        ensure_dir ".claude"

        # Create CLAUDE.md with PIV reference
        cat > .claude/CLAUDE.md << 'EOF'
# PIV Methodology

This project uses the **PIV (Prime-Implement-Validate)** methodology for AI-assisted development.

## Quick Start

1. **Prime**: Load context with reference to `.claude-piv/`
2. **Plan**: Create plan using `/piv_loop:plan-feature "description"`
3. **Execute**: Implement with `/piv_loop:execute`

## Documentation

See `.claude-piv/PIV-METHODOLOGY.md` for complete methodology guide.

## Configuration

PIV commands are available in `.claude/commands/` and link to `.claude-piv/` for full methodology.

---

[Add your project-specific configuration below]
EOF
    fi

    # Create usage guide
    cat > "$piv_dir/HOW-TO-USE.md" << 'EOF'
# How to Use PIV (Separate Mode)

This directory contains the complete PIV methodology, kept separate from your existing `.claude/` configuration.

## Quick Reference

When working with Claude Code, reference the PIV methodology in this directory:

1. **Load Context**: Tell Claude to look at `.claude-piv/` for methodology
   ```
   "Load the PIV methodology from .claude-piv/PIV-METHODOLOGY.md"
   ```

2. **Use Commands**: PIV commands are linked in your `.claude/commands/` directory
   - `/piv_loop:prime` - Prime the workspace
   - `/piv_loop:plan-feature "description"` - Create plan
   - `/piv_loop:execute` - Execute plan

## Directory Structure

```
.claude-piv/
├── PIV-METHODOLOGY.md    # Complete methodology guide
├── commands/             # PIV command definitions
├── rules/                # Coding rules and best practices
└── technologies/         # Technology-specific templates
```

## Switching to Merge Mode

If you want to fully integrate PIV into your project, you can switch to merge mode:

1. Backup your current setup: `cp -r .claude .claude-backup`
2. Run installer again and choose "merge mode"
3. The installer will integrate `.claude-piv/` into `.claude/`

## Need Help?

See `PIV-METHODOLOGY.md` for detailed documentation.
EOF

    print_success "PIV installed successfully in separate mode"
    print_info "PIV files are in: $piv_dir"
    print_info "Your existing .claude/ directory was preserved"
}

# Verify separate installation
# Usage: verify_separate_installation
verify_separate_installation() {
    print_info "Verifying separate installation..."

    local errors=0
    local piv_dir=".claude-piv"

    # Check required files
    if [ ! -d "$piv_dir" ]; then
        print_error "$piv_dir not found"
        ((errors++))
    fi

    if [ ! -f "$piv_dir/PIV-METHODOLOGY.md" ]; then
        print_error "$piv_dir/PIV-METHODOLOGY.md not found"
        ((errors++))
    fi

    if [ ! -d "$piv_dir/commands" ]; then
        print_error "$piv_dir/commands not found"
        ((errors++))
    fi

    if [ ! -d "$piv_dir/rules" ]; then
        print_error "$piv_dir/rules not found"
        ((errors++))
    fi

    # Check links in .claude/commands
    if [ ! -L ".claude/commands/piv_loop" ] && [ ! -d ".claude/commands/piv_loop" ]; then
        print_warning ".claude/commands/piv_loop not found (commands may not work)"
    fi

    if [ $errors -eq 0 ]; then
        print_success "Separate installation verified"
        return 0
    else
        print_error "Verification failed with $errors errors"
        return 1
    fi
}

# Uninstall separate mode
# Usage: uninstall_separate_mode
uninstall_separate_mode() {
    print_header "Uninstalling PIV (Separate Mode)"

    local piv_dir=".claude-piv"

    if [ ! -d "$piv_dir" ]; then
        print_error "$piv_dir not found"
        return 1
    fi

    if ! confirm "Remove $piv_dir and all PIV files?"; then
        print_info "Uninstall cancelled"
        return 0
    fi

    # Remove the directory
    rm -rf "$piv_dir"
    print_success "$piv_dir removed"

    # Remove symlinks from .claude/commands
    if [ -d ".claude/commands" ]; then
        print_info "Removing PIV command links..."
        rm -rf ".claude/commands/piv_loop"
        rm -rf ".claude/commands/validation"
        rm -rf ".claude/commands/bug_fix"
        print_success "Command links removed"
    fi

    # Remove PIV reference from CLAUDE.md if we added it
    if [ -f ".claude/CLAUDE.md" ]; then
        print_info "Note: You may want to remove the PIV section from .claude/CLAUDE.md"
    fi

    print_success "PIV uninstalled successfully"
}

# Export functions
export -f set_piv_source install_separate_mode verify_separate_installation uninstall_separate_mode
