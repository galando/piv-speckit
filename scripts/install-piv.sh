#!/bin/bash
# install-piv.sh - Interactive PIV installer for existing projects
# Main installer script that guides users through PIV installation

set -euo pipefail

# Save original directory
ORIGINAL_DIR="$(pwd)"

# Check if running from stdin (via curl | bash)
if [ -z "${BASH_SOURCE+x}" ] || [ "${BASH_SOURCE[0]}" = "bash" ] || [ "${BASH_SOURCE[0]}" = "/dev/stdin" ]; then
    # We're being piped in from curl - need to download the full skeleton
    echo "PIV Installer - Downloading..."

    # Create temp directory for skeleton
    TEMP_DIR=$(mktemp -d)

    # Check for git
    if ! command -v git &> /dev/null; then
        echo "Error: git is required for installation"
        echo ""
        echo "Please install git or use manual installation:"
        echo "  git clone https://github.com/galando/claude-piv-skeleton.git /tmp/piv"
        echo "  cd your-project"
        echo "  /tmp/piv/scripts/install-piv.sh"
        exit 1
    fi

    # Clone skeleton quietly
    echo "Downloading PIV skeleton..."
    if ! git clone --depth 1 -q https://github.com/galando/claude-piv-skeleton.git "$TEMP_DIR" 2>/dev/null; then
        echo "Error: Failed to download PIV skeleton"
        rm -rf "$TEMP_DIR"
        exit 1
    fi

    # Change back to original directory and run the real installer
    cd "$ORIGINAL_DIR" || cd /
    # Ensure stdin is connected to terminal for interactive prompts
    echo "Starting installer..."
    # Use bash explicitly with proper terminal handling
    bash "$TEMP_DIR/scripts/install-piv.sh" < /dev/tty
    EXIT_CODE=$?

    # Clean up temp directory
    rm -rf "$TEMP_DIR"

    exit $EXIT_CODE
fi

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Change to script directory to ensure relative paths work
cd "$SCRIPT_DIR"

# Source installation functions
source "install/core.sh"
source "install/detect-tech.sh"
source "install/backup.sh"
source "install/merge-mode.sh"
source "install/separate-mode.sh"
source "install/verify.sh"

# Global variables (exported for subprocess access)
export INSTALLATION_MODE=""
export PIV_SOURCE_DIR=""

# Print welcome banner
print_welcome() {
    cat << "EOF"

╔═══════════════════════════════════════════════════════════╗
║                                                           ║
║         PIV Methodology Installer for Existing Projects   ║
║                                                           ║
║    This will install the PIV (Prime-Implement-Validate)   ║
║    methodology into your existing project.                ║
║                                                           ║
╚═══════════════════════════════════════════════════════════╝

EOF

    print_info "PIV helps you build better software with Claude Code"
    echo ""
}

# Print introduction
print_introduction() {
    cat << "EOF"

The PIV methodology consists of three phases:

  1. PRIME   - Load and understand codebase context
  2. PLAN    - Create detailed implementation plans
  3. EXECUTE - Implement with automatic validation

This installer will:
  • Detect your technology stack
  • Install PIV commands and rules
  • Preserve your existing configuration
  • Create a backup before making changes

Installation takes 1-2 minutes.

EOF
}

# Check if already installed
check_existing_installation() {
    local existing_mode=$(get_installation_mode)

    if [ "$existing_mode" != "none" ]; then
        print_warning "PIV is already installed in $existing_mode mode"
        echo ""

        local choice=$(select_menu "What would you like to do?" \
            "Reinstall PIV (will backup current installation)" \
            "Uninstall PIV" \
            "Cancel")
        echo ""

        case $choice in
            1)
                print_info "Proceeding with reinstallation..."
                return 0
                ;;
            2)
                uninstall_piv
                exit 0
                ;;
            3)
                print_info "Installation cancelled"
                exit 0
                ;;
        esac
    fi
}

# Uninstall PIV
uninstall_piv() {
    print_header "Uninstalling PIV"

    local mode=$(get_installation_mode)

    if [ "$mode" = "none" ]; then
        print_info "PIV is not installed"
        return 0
    fi

    print_warning "This will remove PIV from your project"
    if ! confirm "Continue?"; then
        print_info "Uninstall cancelled"
        return 0
    fi

    # Offer to restore backup first
    if has_backup; then
        if confirm "Restore backup before uninstalling?"; then
            restore_backup
            rm -f "$BACKUP_META_FILE"
            print_success "PIV uninstalled (backup restored)"
            return 0
        fi
    fi

    # Remove PIV files based on mode
    if [ "$mode" = "separate" ]; then
        uninstall_separate_mode
    else
        # Merge mode - just restore backup
        if has_backup; then
            restore_backup
        else
            print_warning "No backup found. Manual cleanup may be required"
            print_info "Remove these files/directories manually:"
            echo "  .claude/PIV-METHODOLOGY.md"
            echo "  .claude/commands/piv_loop/"
            echo "  .claude/commands/validation/"
            echo "  .claude/commands/bug_fix/"
        fi
    fi

    # Clean up backup metadata
    rm -f "$BACKUP_META_FILE"

    print_success "PIV uninstalled"
}

# Select installation mode
select_installation_mode() {
    print_header "Installation Mode"

    cat << "EOF"

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

EOF

    local choice=$(select_menu "Select installation mode:" \
        "Merge mode (integrate with existing .claude/)" \
        "Separate mode (keep .claude-piv/ separate)")
    echo ""

    # Debug: log what we received
    log "INFO" "User selected choice: '$choice' (length: ${#choice})"

    case $choice in
        1)
            INSTALLATION_MODE="merge"
            print_success "Selected: Merge mode"
            ;;
        2)
            INSTALLATION_MODE="separate"
            print_success "Selected: Separate mode"
            ;;
        *)
            INSTALLATION_MODE="merge"
            print_warning "Invalid choice '$choice', defaulting to Merge mode"
            ;;
    esac

    log "INFO" "Mode selected in select_installation_mode: '$INSTALLATION_MODE'"
    log "INFO" "INSTALLATION_MODE variable is set and exported"
}

# Install PIV
install_piv() {
    print_header "Installing PIV"

    # Set PIV source directory
    # Try to find it relative to script location
    if [ -f "$SCRIPT_DIR/../.claude/PIV-METHODOLOGY.md" ]; then
        PIV_SOURCE_DIR="$(dirname "$SCRIPT_DIR")"
    elif [ -f "$SCRIPT_DIR/.claude/PIV-METHODOLOGY.md" ]; then
        PIV_SOURCE_DIR="$SCRIPT_DIR"
    else
        # PIV methodology not found - need to download skeleton
        print_warning "PIV skeleton not found locally"
        print_info "Downloading PIV skeleton..."

        TEMP_DIR=$(mktemp -d)

        if command -v git &> /dev/null; then
            if ! git clone --depth 1 -q https://github.com/galando/claude-piv-skeleton.git "$TEMP_DIR" 2>/dev/null; then
                print_error "Failed to clone PIV skeleton"
                rm -rf "$TEMP_DIR"
                return 1
            fi
            PIV_SOURCE_DIR="$TEMP_DIR"
        else
            print_error "Git is required for installation"
            print_info "Please install git or use manual installation:"
            echo ""
            echo "  git clone https://github.com/galando/claude-piv-skeleton.git /tmp/piv"
            echo "  cd /tmp/piv/scripts"
            echo "  ./install-piv.sh"
            return 1
        fi
    fi

    print_info "PIV source: $PIV_SOURCE_DIR"

    # Validate PIV source directory
    if [ ! -d "$PIV_SOURCE_DIR/.claude" ]; then
        print_error "PIV source directory invalid: $PIV_SOURCE_DIR/.claude not found"
        log "ERROR" "PIV source validation failed: $PIV_SOURCE_DIR/.claude not found"
        return 1
    fi

    if [ ! -f "$PIV_SOURCE_DIR/.claude/PIV-METHODOLOGY.md" ]; then
        print_error "PIV-METHODOLOGY.md not found in: $PIV_SOURCE_DIR/.claude/"
        log "ERROR" "PIV-METHODOLOGY.md not found in: $PIV_SOURCE_DIR/.claude/"
        return 1
    fi

    log "INFO" "PIV source validated: $PIV_SOURCE_DIR"

    # Change back to original directory for installation
    cd "$ORIGINAL_DIR" || {
        print_error "Cannot access original directory: $ORIGINAL_DIR"
        return 1
    }

    # Install based on mode
    log "INFO" "Installing with mode: '$INSTALLATION_MODE'"
    print_info "Installing in: $INSTALLATION_MODE mode"
    if [ "$INSTALLATION_MODE" = "merge" ]; then
        set_piv_source "$PIV_SOURCE_DIR"
        install_merge_mode
    else
        set_piv_source "$PIV_SOURCE_DIR"
        install_separate_mode
    fi

    # Save backup metadata with mode and technologies
    if [ -f "$BACKUP_META_FILE" ]; then
        local tech_list=$(get_all_technologies)
        save_backup_metadata "$(get_backup_dir)" "$INSTALLATION_MODE" "$tech_list"
    fi
}

# Print success message
print_success_message() {
    cat << "EOF"

╔═══════════════════════════════════════════════════════════╗
║                                                           ║
║                    Installation Complete!                 ║
║                                                           ║
╚═══════════════════════════════════════════════════════════╝

EOF

    print_success "PIV has been installed successfully!"
    echo ""

    # Show installation info
    print_installation_info
    echo ""

    # Show next steps
    print_header "Next Steps"

    cat << 'EOF'

1. Start using PIV with Claude Code:

   ask: "Run /piv_loop:prime to load project context"

2. Plan your first feature:

   ask: "Use /piv_loop:plan-feature to plan adding user authentication"

3. Implement your feature:

   ask: "Use /piv_loop:execute to implement the plan"

4. Learn more:

   Read .claude/PIV-METHODOLOGY.md for complete documentation

EOF

    # Show backup info
    if has_backup; then
        print_info "A backup of your previous configuration was created:"
        echo "  $(get_backup_dir)"
        echo ""
        print_info "You can restore it anytime by running:"
        echo "  ./scripts/uninstall-piv.sh"
        echo ""
    fi

    # Show log file
    if [ -f "$LOG_FILE" ]; then
        print_info "Installation log saved to: $LOG_FILE"
    fi
}

# Handle interruption
handle_interrupt() {
    echo ""
    print_warning "Installation interrupted"
    echo ""
    print_info "Cleaning up..."

    # If backup exists, offer to restore
    if has_backup; then
        print_info "Backup found: $(get_backup_dir)"
        if confirm "Restore backup?"; then
            restore_backup
            print_success "Backup restored"
        fi
    fi

    exit 1
}

# Main installation flow
main() {
    # Set error trap for interruption
    trap handle_interrupt INT

    # Set error trap for errors
    set_error_trap

    # Print welcome
    print_welcome
    print_introduction

    # CRITICAL: Change to original directory for project-specific operations
    # We need to be in the user's project directory, not the skeleton directory
    cd "$ORIGINAL_DIR" || {
        print_error "Cannot access original directory: $ORIGINAL_DIR"
        exit 1
    }
    log "INFO" "Working directory: $(pwd)"

    # Check prerequisites
    if ! check_prerequisites; then
        print_error "Prerequisites not met. Please fix the errors above and try again."
        exit 1
    fi

    # Check for existing installation
    check_existing_installation

    # Detect technologies (runs in user's project directory)
    print_header "Analyzing Project"
    log "INFO" "Starting technology detection in directory: $(pwd)"
    if ! detect_technologies; then
        print_warning "Could not auto-detect technologies"
        log "INFO" "Technology detection completed with no results"
    else
        log "INFO" "Technology detection completed successfully"
    fi

    # Confirm technologies
    confirm_technologies

    # Select installation mode
    select_installation_mode

    # Backup existing .claude directory (runs in user's project directory)
    print_header "Backup"
    if [ -d ".claude" ]; then
        if ! backup_existing_claude; then
            print_error "Backup failed. Cannot proceed."
            exit 1
        fi
    else
        print_info "No existing .claude directory to backup"
    fi

    # Install PIV (install_piv will handle directory changes internally)
    install_piv

    # Verify installation
    echo ""
    log "INFO" "About to verify with mode: '$INSTALLATION_MODE'"
    verify_installation "$INSTALLATION_MODE"

    # Print success message
    echo ""
    print_success_message

    # Offer to delete backup
    echo ""
    if has_backup; then
        delete_backup
    fi

    print_success "Done! You're ready to use PIV."
    echo ""
}

# Run main function
main "$@"
