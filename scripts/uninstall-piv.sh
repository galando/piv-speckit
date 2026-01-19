#!/bin/bash
# uninstall-piv.sh - Uninstall PIV from project
# Removes PIV files and optionally restores backup

set -euo pipefail

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Source installation functions
source "$SCRIPT_DIR/install/core.sh"
source "$SCRIPT_DIR/install/backup.sh"
source "$SCRIPT_DIR/install/verify.sh"
source "$SCRIPT_DIR/install/separate-mode.sh"

# Print welcome
print_welcome() {
    cat << "EOF"

╔═══════════════════════════════════════════════════════════╗
║                                                           ║
║              PIV Methodology Uninstaller                  ║
║                                                           ║
║         This will remove PIV from your project            ║
║                                                           ║
╚═══════════════════════════════════════════════════════════╝

EOF
}

# Check if PIV is installed
check_installation() {
    local mode=$(get_installation_mode)

    if [ "$mode" = "none" ]; then
        print_error "PIV is not installed in this project"
        echo ""
        print_info "Current directory: $(pwd)"
        return 1
    fi

    print_info "Detected PIV installation: $mode mode"
    echo ""
    return 0
}

# Show what will be removed
show_removal_plan() {
    local mode=$(get_installation_mode)

    print_header "Files to be Removed"

    if [ "$mode" = "separate" ]; then
        echo "  • .claude-piv/ (entire directory)"
        echo "  • .claude/commands/piv_loop (symlink)"
        echo "  • .claude/commands/validation (symlink)"
        echo "  • .claude/commands/bug_fix (symlink)"
    else
        echo "  • .claude/reference/methodology/PIV-METHODOLOGY.md"
        echo "  • .claude/.piv-version"
        echo "  • .claude/commands/piv_loop/"
        echo "  • .claude/commands/validation/"
        echo "  • .claude/commands/bug_fix/"
        echo "  • .claude/rules/backend/ (if exists)"
        echo "  • PIV section in .claude/CLAUDE.md"
    fi

    if has_backup; then
        echo ""
        print_info "Backup available: $(get_backup_dir)"
        echo "  You can choose to restore this backup"
    fi

    echo ""
}

# Remove merge mode installation
remove_merge_mode() {
    print_info "Removing merge mode installation..."

    # Remove PIV files
    [ -f ".claude/.piv-version" ] && rm -f ".claude/.piv-version"
    [ -d ".claude/reference" ] && rm -rf ".claude/reference"

    # Remove command directories
    [ -d ".claude/commands/piv_loop" ] && rm -rf ".claude/commands/piv_loop"
    [ -d ".claude/commands/validation" ] && rm -rf ".claude/commands/validation"
    [ -d ".claude/commands/bug_fix" ] && rm -rf ".claude/commands/bug_fix"

    # Remove backend rules
    [ -d ".claude/rules/backend" ] && rm -rf ".claude/rules/backend"

    # Remove frontend rules
    [ -d ".claude/rules/frontend" ] && rm -rf ".claude/rules/frontend"

    # Remove database rules
    [ -d ".claude/rules/database" ] && rm -rf ".claude/rules/database"

    # Note about CLAUDE.md
    if [ -f ".claude/CLAUDE.md" ]; then
        print_warning "Note: .claude/CLAUDE.md was not removed"
        print_info "You may want to manually edit it to remove PIV references"
    fi

    print_success "Merge mode files removed"
}

# Remove separate mode installation
remove_separate_mode() {
    print_info "Removing separate mode installation..."

    uninstall_separate_mode
}

# Main uninstall flow
main() {
    # Print welcome
    print_welcome

    # Check if PIV is installed
    if ! check_installation; then
        exit 1
    fi

    # Show what will be removed
    show_removal_plan

    # Ask for confirmation
    print_warning "This action cannot be undone"
    if ! confirm "Continue with uninstall?"; then
        print_info "Uninstall cancelled"
        exit 0
    fi

    # Get installation mode
    local mode=$(get_installation_mode)

    # Offer to restore backup first
    if has_backup; then
        echo ""
        local choice=$(select_menu "Backup found. What would you like to do?" \
            "Restore backup (recommended - reverts to pre-PIV state)" \
            "Remove PIV files only (keep backup for now)" \
            "Cancel")
        echo ""

        case $choice in
            1)
                # Restore backup
                print_header "Restoring Backup"
                if restore_backup; then
                    rm -f "$BACKUP_META_FILE"
                    print_success "PIV uninstalled (backup restored)"
                    echo ""
                    print_info "Your project is back to its pre-PIV state"
                else
                    print_error "Failed to restore backup"
                    exit 1
                fi
                exit 0
                ;;
            2)
                # Continue with removal
                print_info "Proceeding with file removal..."
                ;;
            3)
                print_info "Uninstall cancelled"
                exit 0
                ;;
        esac
    fi

    # Remove PIV files
    print_header "Removing PIV Files"

    if [ "$mode" = "separate" ]; then
        remove_separate_mode
    else
        remove_merge_mode
    fi

    # Clean up backup metadata
    rm -f "$BACKUP_META_FILE"

    # Success message
    echo ""
    print_success "PIV uninstalled successfully"
    echo ""
    print_info "If you have any issues, you can:"
    echo "  1. Check for leftover PIV references in .claude/CLAUDE.md"
    echo "  2. Manually remove .claude-piv/ if it still exists"
    echo "  3. Remove .claude-backup-* directories if no longer needed"
    echo ""
}

# Run main function
main "$@"
