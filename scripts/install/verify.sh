#!/bin/bash
# verify.sh - Post-installation verification for PIV installer
# Verifies that installation completed successfully

# Verification checks
CHECKS_PASSED=0
CHECKS_FAILED=0

# Check if a file exists
# Usage: check_file "path" "description"
check_file() {
    local path="$1"
    local description="$2"

    if [ -f "$path" ]; then
        print_success "✓ $description"
        ((CHECKS_PASSED++))
        return 0
    else
        print_error "✗ $description"
        ((CHECKS_FAILED++))
        return 1
    fi
}

# Check if a directory exists
# Usage: check_directory "path" "description"
check_directory() {
    local path="$1"
    local description="$2"

    if [ -d "$path" ]; then
        print_success "✓ $description"
        ((CHECKS_PASSED++))
        return 0
    else
        print_error "✗ $description"
        ((CHECKS_FAILED++))
        return 1
    fi
}

# Check if a symlink exists
# Usage: check_symlink "path" "description"
check_symlink() {
    local path="$1"
    local description="$2"

    if [ -L "$path" ]; then
        print_success "✓ $description"
        ((CHECKS_PASSED++))
        return 0
    else
        print_error "✗ $description"
        ((CHECKS_FAILED++))
        return 1
    fi
}

# Check if file contains specific content
# Usage: check_content "path" "pattern" "description"
check_content() {
    local path="$1"
    local pattern="$2"
    local description="$3"

    if [ -f "$path" ] && grep -q "$pattern" "$path"; then
        print_success "✓ $description"
        ((CHECKS_PASSED++))
        return 0
    else
        print_error "✗ $description"
        ((CHECKS_FAILED++))
        return 1
    fi
}

# Main verification function
# Usage: verify_installation ["merge"|"separate"]
# If no mode specified, auto-detect based on installed files
verify_installation() {
    local mode="${1:-}"

    # Auto-detect mode if not specified
    if [ -z "$mode" ]; then
        if [ -d ".claude-piv" ]; then
            mode="separate"
        elif [ -f ".claude/reference/methodology/PIV-METHODOLOGY.md" ]; then
            mode="merge"
        else
            mode="merge"  # Default fallback
        fi
        log "INFO" "Auto-detected installation mode: '$mode'"
    else
        log "INFO" "Using specified installation mode: '$mode'"
    fi

    log "INFO" "Verifying with mode: '$mode'"
    print_header "Verifying PIV Installation"

    CHECKS_PASSED=0
    CHECKS_FAILED=0

    if [ "$mode" = "merge" ]; then
        verify_merge_installation
    else
        verify_separate_installation
    fi

    # Print summary
    echo ""
    echo "$(printf '─%.0s' $(seq 1 60))"
    print_info "Verification Summary"
    echo "$(printf '─%.0s' $(seq 1 60))"
    echo ""
    print_success "Passed: $CHECKS_PASSED"

    if [ $CHECKS_FAILED -gt 0 ]; then
        print_error "Failed: $CHECKS_FAILED"
        echo ""
        print_warning "Some verification checks failed. Please check the errors above."
        return 1
    else
        echo ""
        print_success "All verification checks passed!"
        echo ""
        return 0
    fi
}

# Verify merge mode installation
verify_merge_installation() {
    print_info "Checking merge mode installation..."
    echo ""

    # Core structure
    check_directory ".claude" "Claude configuration directory"
    check_file ".claude/reference/methodology/PIV-METHODOLOGY.md" "PIV methodology documentation"
    check_file ".claude/CLAUDE.md" "Project instructions"

    # Commands
    check_directory ".claude/commands" "Commands directory"
    check_directory ".claude/commands/piv_loop" "PIV loop commands"
    check_file ".claude/commands/piv_loop/prime.md" "Prime command"
    check_file ".claude/commands/piv_loop/plan-feature.md" "Plan command"
    check_file ".claude/commands/piv_loop/execute.md" "Execute command"

    check_directory ".claude/commands/validation" "Validation commands"
    check_file ".claude/commands/validation/validate.md" "Validate command"

    # Rules
    check_directory ".claude/rules" "Rules directory"
    check_file ".claude/rules/00-general.md" "General rules"
    check_file ".claude/rules/10-git.md" "Git rules"
    check_file ".claude/rules/20-testing.md" "Testing rules"
    check_file ".claude/rules/30-documentation.md" "Documentation rules"
    check_file ".claude/rules/40-security.md" "Security rules"

    # Check CLAUDE.md has PIV content
    check_content ".claude/CLAUDE.md" "PIV" "CLAUDE.md contains PIV reference"
}

# Verify separate mode installation
verify_separate_installation() {
    print_info "Checking separate mode installation..."
    echo ""

    local piv_dir=".claude-piv"

    # Core structure
    check_directory "$piv_dir" "PIV directory"
    check_file "$piv_dir/reference/methodology/PIV-METHODOLOGY.md" "PIV methodology documentation"
    check_file "$piv_dir/HOW-TO-USE.md" "Usage guide"

    # Commands
    check_directory "$piv_dir/commands" "Commands directory"
    check_directory "$piv_dir/commands/piv_loop" "PIV loop commands"

    # Rules
    check_directory "$piv_dir/rules" "Rules directory"

    # Check .claude exists
    check_directory ".claude" "Claude configuration directory"

    # Check command links (optional, may not exist if .claude was empty)
    if [ -d ".claude/commands/piv_loop" ]; then
        check_directory ".claude/commands/piv_loop" "PIV command links"
    fi

    # Check CLAUDE.md exists
    check_file ".claude/CLAUDE.md" "Project instructions"
}

# Quick check for installation presence
# Usage: is_piv_installed ["merge"|"separate"]
is_piv_installed() {
    local mode="${1:-merge}"

    if [ "$mode" = "merge" ]; then
        [ -d ".claude" ] && [ -f ".claude/reference/methodology/PIV-METHODOLOGY.md" ]
    else
        [ -d ".claude-piv" ] && [ -f ".claude-piv/reference/methodology/PIV-METHODOLOGY.md" ]
    fi
}

# Get installation mode if PIV is installed
# Usage: get_installation_mode
# Returns "merge", "separate", or "none"
get_installation_mode() {
    if is_piv_installed "merge"; then
        echo "merge"
    elif is_piv_installed "separate"; then
        echo "separate"
    else
        echo "none"
    fi
}

# Test PIV commands availability
# Usage: test_commands
test_commands() {
    print_info "Testing PIV commands availability..."
    echo ""

    local found=0

    if [ -d ".claude/commands/piv_loop" ]; then
        print_success "PIV Loop commands available"
        ((found++))
    fi

    if [ -d ".claude/commands/validation" ]; then
        print_success "Validation commands available"
        ((found++))
    fi

    if [ -d ".claude/commands/bug_fix" ]; then
        print_success "Bug fix commands available"
        ((found++))
    fi

    if [ $found -eq 3 ]; then
        print_success "All command sets available"
        return 0
    else
        print_warning "Some command sets missing ($found/3 found)"
        return 1
    fi
}

# Print installation info
# Usage: print_installation_info
print_installation_info() {
    local mode=$(get_installation_mode)

    print_header "PIV Installation Information"

    echo "Installation Mode: $mode"
    echo ""

    if [ "$mode" != "none" ]; then
        echo "Locations:"
        if [ "$mode" = "merge" ]; then
            echo "  .claude/ - Main configuration"
        else
            echo "  .claude-piv/ - PIV methodology"
            echo "  .claude/ - Your configuration"
        fi
        echo ""

        # Test commands
        test_commands
    else
        print_info "PIV is not installed in this project"
    fi
}

# Export functions
export -f check_file check_directory check_symlink check_content
export -f verify_installation verify_merge_installation verify_separate_installation
export -f is_piv_installed get_installation_mode test_commands print_installation_info
