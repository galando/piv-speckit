#!/bin/bash
# update.sh - Update functions for unified PIV script
# Handles update logic with atomic operations and rollback

# =============================================================================
# VERSION TRACKING
# =============================================================================

# Get version from VERSION file
# Usage: get_version [path_to_repo]
get_version() {
    local repo_root="${1:-$PIV_SOURCE_DIR}"
    local version_file="$repo_root/VERSION"

    if [ -f "$version_file" ]; then
        cat "$version_file" | tr -d '[:space:]'
    else
        echo "unknown"
    fi
}

# Parse .piv-version file
# Usage: parse_piv_version
# Sets global variables: INSTALLED_VERSION, INSTALLED_COMMIT, INSTALLED_DATE, UPDATED_DATE, PINNED_VERSION
parse_piv_version() {
    local version_file=".claude/.piv-version"

    INSTALLED_VERSION="unknown"
    INSTALLED_COMMIT="unknown"
    INSTALLED_DATE=""
    UPDATED_DATE=""
    PINNED_VERSION=""

    if [ ! -f "$version_file" ]; then
        return 1
    fi

    # Parse securely with grep
    INSTALLED_VERSION=$(grep "^VERSION=" "$version_file" 2>/dev/null | cut -d'=' -f2 | tr -d '"' | tr -d '[:space:]')
    INSTALLED_COMMIT=$(grep "^COMMIT=" "$version_file" 2>/dev/null | cut -d'=' -f2 | tr -d '"' | tr -d '[:space:]')
    INSTALLED_DATE=$(grep "^INSTALLED=" "$version_file" 2>/dev/null | cut -d'=' -f2 | tr -d '"' | tr -d '[:space:]')
    UPDATED_DATE=$(grep "^UPDATED=" "$version_file" 2>/dev/null | cut -d'=' -f2 | tr -d '"' | tr -d '[:space:]')
    PINNED_VERSION=$(grep "^PINNED=" "$version_file" 2>/dev/null | cut -d'=' -f2 | tr -d '"' | tr -d '[:space:]')
}

# Write .piv-version file
# Usage: write_version_file [version] [commit] [pinned]
write_version_file() {
    local version="${1:-$(get_version)}"
    local commit="${2:-$(cd "$PIV_SOURCE_DIR" && git rev-parse --short HEAD 2>/dev/null || echo "unknown")}"
    local pinned="${3:-}"

    local version_file=".claude/.piv-version"
    local installed_date=""

    # Preserve INSTALLED date if exists
    if [ -f "$version_file" ]; then
        installed_date=$(grep "^INSTALLED=" "$version_file" 2>/dev/null | cut -d'=' -f2)
    fi

    if [ -z "$installed_date" ]; then
        installed_date=$(date -u +%Y-%m-%dT%H:%M:%SZ)
    fi

    cat > "$version_file" << EOF
VERSION=$version
COMMIT=$commit
INSTALLED=$installed_date
UPDATED=$(date -u +%Y-%m-%dT%H:%M:%SZ)
${pinned:+PINNED=$pinned}
EOF

    log "INFO" "Version file written: $version ($commit)"
}

# =============================================================================
# FILE CLASSIFICATION
# =============================================================================

# Classify a file path
# Usage: classify_file "path"
# Returns: "framework" | "user" | "additive" | "unknown"
classify_file() {
    local file_path="$1"

    # Remove leading .claude/ if present for pattern matching
    local clean_path="${file_path#.claude/}"

    case "$clean_path" in
        # Framework files - always update
        commands/*|skills/*|reference/*)
            echo "framework"
            ;;
        # User files - never touch
        CLAUDE.md|settings.local.json)
            echo "user"
            ;;
        agents/context/*|agents/learning/*|agents/plans/*|agents/reviews/*)
            echo "user"
            ;;
        # Additive files - add new only
        rules/*|rules/*/*)
            echo "additive"
            ;;
        *)
            echo "unknown"
            ;;
    esac
}

# =============================================================================
# CHECKSUM FUNCTIONS (Cross-platform)
# =============================================================================

# Compute file checksum
# Usage: compute_checksum "file_path"
# Returns: MD5 hash (32 hex characters)
compute_checksum() {
    local file_path="$1"

    if [ ! -f "$file_path" ]; then
        return 1
    fi

    # macOS uses md5 -q, Linux uses md5sum
    if command -v md5 &> /dev/null && [[ "$(uname)" == "Darwin" ]]; then
        md5 -q "$file_path" 2>/dev/null
    else
        md5sum "$file_path" 2>/dev/null | cut -d' ' -f1
    fi
}

# =============================================================================
# CHANGE DETECTION
# =============================================================================

# Detect changes between upstream and local
# Usage: detect_changes
# Output: Lines with "ACTION filepath" format
detect_changes() {
    local changes=""
    local upstream="$PIV_SOURCE_DIR/.claude"

    # Check framework files
    for dir in commands skills reference; do
        if [ -d "$upstream/$dir" ]; then
            find "$upstream/$dir" -type f -name "*.md" 2>/dev/null | while read -r upstream_file; do
                local rel_path="${upstream_file#$upstream/}"
                local local_file=".claude/$rel_path"

                if [ -f "$local_file" ]; then
                    # Compare checksums
                    local upstream_hash=$(compute_checksum "$upstream_file")
                    local local_hash=$(compute_checksum "$local_file")

                    if [ "$upstream_hash" != "$local_hash" ]; then
                        echo "UPDATE .claude/$rel_path"
                    fi
                else
                    echo "ADD .claude/$rel_path"
                fi
            done
        fi
    done

    # Check additive files (rules)
    # Use find to handle non-matching globs safely
    find "$upstream/rules" -type f -name "*.md" 2>/dev/null | while read -r rule_file; do
        local rel_path="${rule_file#$upstream/}"
        local local_file=".claude/$rel_path"

        if [ ! -f "$local_file" ]; then
            echo "ADD .claude/$rel_path"
        fi
    done
}

# =============================================================================
# ATOMIC UPDATE OPERATIONS
# =============================================================================

# Staging directory for atomic updates
STAGING_DIR=""

# Stage updates to temporary location
# Usage: stage_changes "change_list"
stage_changes() {
    local change_list="$1"
    STAGING_DIR=$(mktemp -d)

    log "INFO" "Staging updates to: $STAGING_DIR"

    local staged_count=0
    local failed_count=0

    while read -r action file_path; do
        [ -z "$action" ] && continue

        local classification=$(classify_file "$file_path")

        if [ "$classification" = "user" ]; then
            log "INFO" "Skipping user file: $file_path"
            continue
        fi

        if [ "$classification" = "additive" ] && [ "$action" = "UPDATE" ]; then
            log "INFO" "Skipping existing additive file: $file_path"
            continue
        fi

        local upstream_file="$PIV_SOURCE_DIR/$file_path"
        local staging_file="$STAGING_DIR/$file_path"

        if [ "$action" = "ADD" ] || [ "$action" = "UPDATE" ]; then
            if [ -f "$upstream_file" ]; then
                local staging_dirname=$(dirname "$staging_file")
                mkdir -p "$staging_dirname"
                if cp "$upstream_file" "$staging_file" 2>/dev/null; then
                    ((staged_count++))
                    log "INFO" "Staged: $file_path"
                else
                    ((failed_count++))
                    log "ERROR" "Failed to stage: $file_path"
                fi
            fi
        fi
    done <<< "$change_list"

    log "INFO" "Staging complete: $staged_count succeeded, $failed_count failed"

    # Return failure if any files failed to stage
    [ "$failed_count" -eq 0 ]
}

# Verify staged files
# Usage: verify_staged_changes
verify_staged_changes() {
    print_info "Verifying staged files..."

    local errors=0

    while read -r staged_file; do
        [ -z "$staged_file" ] && continue
        [ ! -f "$staged_file" ] && continue

        local rel_path="${staged_file#$STAGING_DIR/}"
        local upstream_file="$PIV_SOURCE_DIR/$rel_path"

        if [ ! -f "$upstream_file" ]; then
            log "ERROR" "Missing upstream file: $rel_path"
            ((errors++))
            continue
        fi

        local staged_hash=$(compute_checksum "$staged_file")
        local upstream_hash=$(compute_checksum "$upstream_file")

        if [ "$staged_hash" != "$upstream_hash" ]; then
            log "ERROR" "Checksum mismatch: $rel_path"
            ((errors++))
        fi
    done < <(find "$STAGING_DIR" -type f -name "*.md" 2>/dev/null)

    if [ $errors -gt 0 ]; then
        print_error "Verification failed with $errors errors"
        return 1
    fi

    print_success "All staged files verified"
    return 0
}

# Apply staged updates
# Usage: apply_staged_changes
apply_staged_changes() {
    print_info "Applying updates..."

    find "$STAGING_DIR" -type f -name "*.md" 2>/dev/null | while read -r staged_file; do
        local rel_path="${staged_file#$STAGING_DIR/}"
        local target_file=".claude/${rel_path#.claude/}"
        local target_dir=$(dirname "$target_file")

        mkdir -p "$target_dir"
        mv "$staged_file" "$target_file"
        log "INFO" "Applied: $rel_path"
    done

    # Clean up staging
    rm -rf "$STAGING_DIR"
    STAGING_DIR=""

    print_success "Updates applied"
}

# Rollback on failure
# Usage: rollback_on_failure
rollback_on_failure() {
    print_error "Update failed! Rolling back..."

    # Clean up staging
    [ -n "$STAGING_DIR" ] && rm -rf "$STAGING_DIR"

    # Restore from backup if exists
    if has_backup; then
        restore_backup
        print_success "Rolled back to previous state"
    else
        print_error "No backup available for rollback"
    fi
}

# =============================================================================
# MIGRATION
# =============================================================================

# Ensure .claude/reference/ directory structure exists
# Usage: ensure_reference_structure
ensure_reference_structure() {
    print_info "Ensuring reference directory structure..."

    local dirs=(
        ".claude/reference/methodology"
        ".claude/reference/rules-full"
        ".claude/reference/skills-full"
        ".claude/reference/patterns"
    )

    for dir in "${dirs[@]}"; do
        ensure_dir "$dir"
    done

    log "INFO" "Reference structure ensured"
}

# Migrate old .claude/PIV-METHODOLOGY.md to new location
# Usage: migrate_to_reference_structure
migrate_to_reference_structure() {
    local old_file=".claude/PIV-METHODOLOGY.md"
    local new_dir=".claude/reference/methodology"
    local new_file="$new_dir/PIV-METHODOLOGY.md"

    if [ -f "$old_file" ]; then
        print_info "Migrating PIV-METHODOLOGY.md to new location..."

        ensure_dir "$new_dir"

        # Check if new location already has the file
        if [ -f "$new_file" ]; then
            # Compare - keep newer one
            local old_mtime=$(stat -c %Y "$old_file" 2>/dev/null || stat -f %m "$old_file")
            local new_mtime=$(stat -c %Y "$new_file" 2>/dev/null || stat -f %m "$new_file")

            if [ "$old_mtime" -gt "$new_mtime" ]; then
                cp "$old_file" "$new_file"
                log "INFO" "Migrated newer file to reference/methodology/"
            fi

            # Remove old file after successful migration
            rm -f "$old_file"
            log "INFO" "Removed old PIV-METHODOLOGY.md"
        else
            # New location doesn't have file - move it
            mv "$old_file" "$new_file"
            log "INFO" "Moved PIV-METHODOLOGY.md to reference/methodology/"
        fi

        print_success "Migration complete"
    fi
}

# Migrate old installation to new structure
# Usage: migrate_old_installation
migrate_old_installation() {
    print_info "Checking for migration needs..."

    local needs_migration=false

    # Check for old structure indicators
    if [ -f ".claude/PIV-METHODOLOGY.md" ]; then
        needs_migration=true
    fi

    if [ ! -d ".claude/reference" ]; then
        needs_migration=true
    fi

    if [ "$needs_migration" = true ]; then
        ensure_reference_structure
        migrate_to_reference_structure
        print_success "Old installation migrated"
    else
        log "INFO" "No migration needed"
    fi
}

# =============================================================================
# USER FEEDBACK
# =============================================================================

# Show what's new in the update
# Usage: show_whats_new "change_list"
show_whats_new() {
    local change_list="$1"

    print_header "What's New"

    # Count using grep (works in parent shell)
    local add_count=$(echo "$change_list" | grep -c "^ADD" || echo "0")
    local update_count=$(echo "$change_list" | grep -c "^UPDATE" || echo "0")

    # Display individual changes
    while read -r action file_path; do
        [ -z "$action" ] && continue

        case "$action" in
            ADD)
                print_success "  + $file_path (new)"
                ;;
            UPDATE)
                print_warning "  ~ $file_path (updated)"
                ;;
            SKIP)
                ;;
        esac
    done <<< "$change_list"

    echo ""
    print_info "Summary:"
    echo "  New files: $add_count"
    echo "  Updated files: $update_count"
    echo ""
}

# =============================================================================
# EXPORT FUNCTIONS
# =============================================================================

export -f get_version parse_piv_version write_version_file
export -f classify_file compute_checksum detect_changes
export -f stage_changes verify_staged_changes apply_staged_changes rollback_on_failure
export -f ensure_reference_structure migrate_to_reference_structure migrate_old_installation
export -f show_whats_new
