#!/bin/bash
# merge-mode.sh - Merge mode installation for PIV
# Installs PIV into existing .claude directory, merging with existing configuration

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

# Install PIV in merge mode
# Usage: install_merge_mode
install_merge_mode() {
    print_header "Installing PIV (Merge Mode)"

    # Ensure .claude directory exists
    ensure_dir ".claude"

    # Preserve existing CLAUDE.md if it exists
    local existing_claude_md=""
    if [ -f ".claude/CLAUDE.md" ]; then
        print_info "Backing up existing CLAUDE.md"
        cp ".claude/CLAUDE.md" ".claude/CLAUDE.md.pre-piv"
        existing_claude_md=$(cat ".claude/CLAUDE.md")
    fi

    # Copy universal rules (don't overwrite existing)
    print_info "Installing universal rules..."
    if [ -d "$PIV_SOURCE_DIR/.claude/rules" ]; then
        ensure_dir ".claude/rules"
        local rule_count=0
        for rule_file in "$PIV_SOURCE_DIR/.claude/rules"/*.md; do
            if [ -f "$rule_file" ]; then
                local basename=$(basename "$rule_file")
                log "INFO" "Copying rule: $rule_file -> .claude/rules/$basename"
                if copy_file_if_missing "$rule_file" ".claude/rules/$basename"; then
                    rule_count=$((rule_count + 1))
                fi
            fi
        done
        log "INFO" "Copied $rule_count rule files"
        if [ $rule_count -eq 0 ]; then
            print_warning "No rule files were copied. Source may be empty."
        fi
    else
        print_error "Rules directory not found in PIV source: $PIV_SOURCE_DIR/.claude/rules"
        log "ERROR" "Rules directory not found: $PIV_SOURCE_DIR/.claude/rules"
    fi

    # Copy PIV commands
    print_info "Installing PIV commands..."
    ensure_dir ".claude/commands"
    if [ -d "$PIV_SOURCE_DIR/.claude/commands" ]; then
        merge_dirs "$PIV_SOURCE_DIR/.claude/commands" ".claude/commands"
    fi

    # Copy PIV methodology
    print_info "Installing PIV methodology documentation..."
    copy_file_if_missing "$PIV_SOURCE_DIR/.claude/PIV-METHODOLOGY.md" ".claude/PIV-METHODOLOGY.md"

    # Install technology-specific rules based on detection
    print_info "Installing technology-specific rules..."
    install_technology_rules

    # Create or update CLAUDE.md
    print_info "Updating CLAUDE.md..."
    local project_name=$(basename "$(pwd)")
    local tech_list=$(get_all_technologies)

    if [ -z "$existing_claude_md" ]; then
        # No existing CLAUDE.md, create new one
        create_claude_md "$project_name" "$tech_list"
    else
        # Merge with existing CLAUDE.md
        create_claude_md "$project_name" "$tech_list" "$existing_claude_md"
    fi

    print_success "PIV installed successfully in merge mode"
    print_info "Your existing configuration has been preserved"
}

# Install technology-specific rules
# Usage: install_technology_rules
install_technology_rules() {
    # Check if detection arrays exist and are populated
    # Use ${var+x} to check if variable is set (works with arrays too)
    local backends_set="${DETECTED_BACKENDS+x}"
    local frontends_set="${DETECTED_FRONTENDS+x}"
    local databases_set="${DETECTED_DATABASES+x}"

    # If no arrays are defined at all, skip technology-specific rules
    if [ -z "$backends_set" ] && [ -z "$frontends_set" ] && [ -z "$databases_set" ]; then
        log "INFO" "No technology detection arrays available, skipping technology-specific rules"
        return 0
    fi

    # Count total detected technologies
    local total_count=0
    [ -n "$backends_set" ] && total_count=$((total_count + ${#DETECTED_BACKENDS[@]}))
    [ -n "$frontends_set" ] && total_count=$((total_count + ${#DETECTED_FRONTENDS[@]}))
    [ -n "$databases_set" ] && total_count=$((total_count + ${#DETECTED_DATABASES[@]}))

    if [ $total_count -eq 0 ]; then
        log "INFO" "No technologies detected, skipping technology-specific rules"
        return 0
    fi

    # Backend rules
    if [ -n "$backends_set" ] && [[ " ${DETECTED_BACKENDS[*]} " =~ " spring-boot " ]]; then
        if [ -d "$PIV_SOURCE_DIR/.claude/rules/backend" ]; then
            ensure_dir ".claude/rules/backend"
            merge_dirs "$PIV_SOURCE_DIR/.claude/rules/backend" ".claude/rules/backend"
            print_success "Spring Boot rules installed"
        fi
    fi

    if [ -n "$backends_set" ] && [[ " ${DETECTED_BACKENDS[*]} " =~ " nodejs " ]]; then
        # Node.js rules would go here
        print_info "Node.js backend detected (universal rules applied)"
    fi

    if [ -n "$backends_set" ] && [[ " ${DETECTED_BACKENDS[*]} " =~ " python " ]]; then
        # Python rules would go here
        print_info "Python backend detected (universal rules applied)"
    fi

    # Frontend rules
    if [ -n "$frontends_set" ] && [[ " ${DETECTED_FRONTENDS[*]} " =~ " react " ]]; then
        if [ -d "$PIV_SOURCE_DIR/technologies/frontend/react" ]; then
            # Copy React best practices and rules
            ensure_dir ".claude/rules/frontend"
            if [ -f "$PIV_SOURCE_DIR/technologies/frontend/react/reference/react-best-practices.md" ]; then
                copy_file_if_missing "$PIV_SOURCE_DIR/technologies/frontend/react/reference/react-best-practices.md" \
                    ".claude/rules/frontend/react-best-practices.md"
            fi
            print_success "React rules installed"
        fi
    fi

    # Database rules
    if [ -n "$databases_set" ] && [[ " ${DETECTED_DATABASES[*]} " =~ " postgresql " ]]; then
        if [ -f "$PIV_SOURCE_DIR/technologies/database/postgresql/reference/postgresql-best-practices.md" ]; then
            ensure_dir ".claude/rules/database"
            copy_file_if_missing "$PIV_SOURCE_DIR/technologies/database/postgresql/reference/postgresql-best-practices.md" \
                ".claude/rules/database/postgresql-best-practices.md"
            print_success "PostgreSQL rules installed"
        fi
    fi
}

# Verify merge installation
# Usage: verify_merge_installation
verify_merge_installation() {
    print_info "Verifying merge installation..."

    local errors=0

    # Check required files
    if [ ! -f ".claude/PIV-METHODOLOGY.md" ]; then
        print_error "PIV-METHODOLOGY.md not found"
        ((errors++))
    fi

    if [ ! -f ".claude/CLAUDE.md" ]; then
        print_error "CLAUDE.md not found"
        ((errors++))
    fi

    if [ ! -d ".claude/commands/piv_loop" ]; then
        print_error "PIV commands not found"
        ((errors++))
    fi

    if [ ! -d ".claude/rules" ]; then
        print_error "Rules directory not found"
        ((errors++))
    fi

    if [ $errors -eq 0 ]; then
        print_success "Merge installation verified"
        return 0
    else
        print_error "Verification failed with $errors errors"
        return 1
    fi
}

# Export functions
export -f set_piv_source install_merge_mode install_technology_rules verify_merge_installation
