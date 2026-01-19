#!/bin/bash
# unified.sh - Unified install/update logic for PIV
# Routes to fresh install or update based on detection

# =============================================================================
# STAGE TRACKING FOR UX
# =============================================================================

# Stage tracking globals
STAGE_NUM=0
TOTAL_STAGES=6

# Display next stage header
# Usage: next_stage "Stage Title"
next_stage() {
    STAGE_NUM=$((STAGE_NUM + 1))
    print_header "Stage $STAGE_NUM of $TOTAL_STAGES: $1"
}

# =============================================================================
# INSTALLATION STATE DETECTION
# =============================================================================

# Detect current installation state
# Usage: detect_installation_state
# Returns: "none" | "merge" | "separate"
detect_installation_state() {
    # Check for separate mode first
    if [ -d ".claude-piv" ] && [ -f ".claude-piv/reference/methodology/PIV-METHODOLOGY.md" ]; then
        echo "separate"
    # Check for merge mode with new structure
    elif [ -f ".claude/reference/methodology/PIV-METHODOLOGY.md" ]; then
        echo "merge"
    # Check for merge mode with old structure (needs migration)
    elif [ -f ".claude/PIV-METHODOLOGY.md" ]; then
        echo "merge-legacy"
    # Check for partial installation
    elif [ -d ".claude" ]; then
        echo "partial"
    # No installation
    else
        echo "none"
    fi
}

# Check if fresh install is needed
# Usage: is_fresh_install
# Returns: 0 (true) if install needed, 1 (false) otherwise
is_fresh_install() {
    local state=$(detect_installation_state)
    [[ "$state" == "none" ]]
}

# Check if update is possible
# Usage: is_update
# Returns: 0 (true) if update possible, 1 (false) otherwise
is_update() {
    local state=$(detect_installation_state)
    [[ "$state" == "merge" ]] || [[ "$state" == "separate" ]] || [[ "$state" == "merge-legacy" ]]
}

# =============================================================================
# ROUTING
# =============================================================================

# Route to appropriate flow (install or update)
# Usage: route_to_install_or_update
route_to_install_or_update() {
    local state=$(detect_installation_state)

    log "INFO" "Installation state: $state"

    case "$state" in
        none)
            print_info "No PIV installation found. Starting fresh install..."
            INSTALLATION_MODE=""
            install_fresh
            ;;
        partial)
            print_info "Partial .claude directory found. Starting fresh install..."
            INSTALLATION_MODE=""
            install_fresh
            ;;
        merge-legacy)
            print_info "Legacy installation found. Migrating and updating..."
            INSTALLATION_MODE="merge"
            migrate_and_update
            ;;
        merge)
            print_info "PIV installation found (merge mode). Checking for updates..."
            INSTALLATION_MODE="merge"
            update_existing
            ;;
        separate)
            print_info "PIV installation found (separate mode). Checking for updates..."
            INSTALLATION_MODE="separate"
            update_existing
            ;;
        *)
            print_error "Unknown installation state: $state"
            exit 1
            ;;
    esac
}

# =============================================================================
# FRESH INSTALL
# =============================================================================

# Perform fresh installation
# Usage: install_fresh
install_fresh() {
    # Reset stage counter
    STAGE_NUM=0

    print_header "Installing PIV Framework"

    # Change to original directory for project-specific operations
    cd "$ORIGINAL_DIR" || {
        print_error "Cannot access original directory: $ORIGINAL_DIR"
        exit 1
    }

    # Stage 1: Prerequisites
    next_stage "Environment Check"
    if ! check_prerequisites; then
        print_error "Prerequisites not met"
        exit 1
    fi
    print_success "Prerequisites met"

    # Stage 2: Technology Detection
    next_stage "Project Analysis"
    print_info "Analyzing project structure..."
    if ! detect_technologies; then
        print_warning "Could not auto-detect technologies"
    fi
    print_success "Detection complete"

    # Confirm technologies
    confirm_technologies

    # Stage 3: Installation Mode
    next_stage "Installation Mode"
    if [ -z "$INSTALLATION_MODE" ]; then
        unified_select_installation_mode
    else
        print_info "Using predefined mode: $INSTALLATION_MODE"
    fi

    # Stage 4: Backup
    if [ -d ".claude" ]; then
        print_header "Backup"
        if ! backup_existing_claude; then
            print_error "Backup failed"
            exit 1
        fi
        print_success "Backup created"
    fi

    # Stage 5: Installation
    next_stage "Installing Framework Files"
    unified_install_piv

    # Stage 6: Verification
    next_stage "Verification"
    write_version_file "$(get_version "$PIV_SOURCE_DIR")" ""
    verify_installation "$INSTALLATION_MODE"
    print_success "All checks passed"

    # Final summary
    print_header "Installation Complete"
    echo ""
    print_success "PIV framework installed successfully!"
    echo ""
    echo "Summary:"
    echo "  Commands:    .claude/commands/"
    echo "  Rules:       .claude/rules/"
    echo "  Reference:   .claude/reference/"
    echo "  Skills:      .claude/skills/"
    echo ""
    echo "Next steps:"
    echo "  1. Run '/piv_loop:prime' to load context"
    echo "  2. Run '/validation:validate' to verify setup"
    echo ""
}

# =============================================================================
# HELPER FUNCTIONS (from original install-piv.sh)
# =============================================================================

# Select installation mode
# Usage: unified_select_installation_mode
unified_select_installation_mode() {
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

    log "INFO" "Mode selected: '$INSTALLATION_MODE'"
}

# Install PIV (route to correct mode)
# Usage: unified_install_piv
unified_install_piv() {
    # Set PIV source directory
    # Try to find it relative to script location
    if [ -f "$SCRIPT_DIR/../.claude/reference/methodology/PIV-METHODOLOGY.md" ]; then
        PIV_SOURCE_DIR="$(dirname "$SCRIPT_DIR")"
    elif [ -f "$SCRIPT_DIR/../.claude/PIV-METHODOLOGY.md" ]; then
        PIV_SOURCE_DIR="$(dirname "$SCRIPT_DIR")"
    else
        print_error "PIV source not found"
        return 1
    fi

    print_info "PIV source: $PIV_SOURCE_DIR"

    # Validate PIV source directory
    if [ ! -d "$PIV_SOURCE_DIR/.claude" ]; then
        print_error "PIV source directory invalid"
        return 1
    fi

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
}

# =============================================================================
# UPDATE EXISTING
# =============================================================================

# Perform update of existing installation
# Usage: update_existing
update_existing() {
    # Reset stage counter
    STAGE_NUM=0

    print_header "Updating PIV Framework"

    # Parse current version
    parse_piv_version

    local current_version="$INSTALLED_VERSION"
    local latest_version=$(get_version)

    print_info "Current version: $current_version"
    print_info "Latest version: $latest_version"

    # Check for pinned version
    if [ -n "$PINNED_VERSION" ] && [ "$FORCE" != true ]; then
        print_info "Pinned to version: $PINNED_VERSION"
        # Would check if pinned version has updates
        # For now, skip if pinned
        if [ "$PINNED_VERSION" = "$current_version" ]; then
            print_info "Already on pinned version"
            return 0
        fi
    fi

    # Detect changes
    print_info "Scanning for updates..."
    local changes=$(detect_changes)

    if [ -z "$changes" ]; then
        print_success "Already up to date!"
        return 0
    fi

    # Show what's new
    show_whats_new "$changes"

    # Confirm update (unless --force)
    if [ "$FORCE" != true ]; then
        if ! confirm "Apply these updates?"; then
            print_info "Update cancelled"
            return 0
        fi
    fi

    # Backup before update
    print_header "Creating Backup"
    if [ -d ".claude" ]; then
        if ! backup_existing_claude; then
            print_error "Backup failed - cannot proceed"
            exit 1
        fi
        print_success "Backup created"
    fi

    # Migration for old installations
    print_info "Checking for migration needs..."
    migrate_old_installation

    # Apply updates
    if [ "$DRY_RUN" = true ]; then
        print_info "Dry run complete. No changes made."
        return 0
    fi

    print_info "Applying updates..."
    # Set error trap for rollback
    trap rollback_on_failure ERR INT

    # Stage, verify, apply
    stage_changes "$changes"
    verify_staged_changes
    apply_staged_changes

    # Update version file
    write_version_file "$latest_version" "" "$PINNED_VERSION"

    # Verify after update
    print_info "Verifying update..."
    verify_installation "$INSTALLATION_MODE"

    # Clear trap
    trap - ERR INT

    # Final summary
    print_header "Update Complete"
    echo ""
    print_success "PIV framework updated successfully!"
    echo ""
    echo "Updated from: $current_version"
    echo "Updated to:   $latest_version"
    echo ""
    echo "Next steps:"
    echo "  1. Run '/validation:validate' to verify setup"
    echo ""
}

# =============================================================================
# MIGRATE AND UPDATE
# =============================================================================

# Migrate legacy installation and update
# Usage: migrate_and_update
migrate_and_update() {
    print_header "Migrating Legacy Installation"

    # Backup first
    if [ -d ".claude" ]; then
        backup_existing_claude
    fi

    # Migrate to new structure
    migrate_old_installation

    # Continue with update
    update_existing
}

# =============================================================================
# EXPORT FUNCTIONS
# =============================================================================

export -f next_stage
export -f detect_installation_state is_fresh_install is_update
export -f route_to_install_or_update
export -f install_fresh update_existing migrate_and_update
export -f unified_select_installation_mode unified_install_piv
