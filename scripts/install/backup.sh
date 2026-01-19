#!/bin/bash
# backup.sh - Backup and rollback functions for PIV installer
# Manages backup of existing .claude directories

# Backup metadata file
BACKUP_META_FILE=".claude-install-backup"
CURRENT_BACKUP_DIR=""

# Create backup of existing .claude directory
# Usage: backup_existing_claude
backup_existing_claude() {
    if [ ! -d ".claude" ]; then
        print_info "No existing .claude directory to backup"
        return 0
    fi

    local timestamp=$(date +%Y%m%d-%H%M%S)
    CURRENT_BACKUP_DIR=".claude-backup-$timestamp"

    # Ensure unique backup directory (prevent collision if multiple installs run simultaneously)
    while [ -d "$CURRENT_BACKUP_DIR" ]; do
        timestamp=$(date +%Y%m%d-%H%M%S)
        CURRENT_BACKUP_DIR=".claude-backup-$timestamp"
    done

    print_info "Creating backup of .claude/ directory..."

    if cp -r ".claude" "$CURRENT_BACKUP_DIR"; then
        print_success "Backup created: $CURRENT_BACKUP_DIR"

        # Save backup metadata
        save_backup_metadata "$CURRENT_BACKUP_DIR"

        # Make backup read-only for safety
        chmod -R a-w "$CURRENT_BACKUP_DIR"

        return 0
    else
        print_error "Failed to create backup"
        return 1
    fi
}

# Save backup metadata
# Usage: save_backup_metadata "backup_dir" ["mode"] ["technologies"]
save_backup_metadata() {
    local backup_dir="$1"
    local mode="${2:-merge}"
    local technologies="${3:-unknown}"

    cat > "$BACKUP_META_FILE" << EOF
BACKUP_DIR="$backup_dir"
MODE="$mode"
TECHNOLOGIES="$technologies"
DATE="$(date -R)"
EOF

    log "INFO" "Backup metadata saved to $BACKUP_META_FILE"
}

# Load backup metadata
# Usage: load_backup_metadata
# Returns metadata in global variables
load_backup_metadata() {
    if [ ! -f "$BACKUP_META_FILE" ]; then
        return 1
    fi

    # Parse metadata file securely (don't use 'source' to avoid code injection)
    BACKUP_DIR=$(grep "^BACKUP_DIR=" "$BACKUP_META_FILE" 2>/dev/null | cut -d'"' -f2)
    MODE=$(grep "^MODE=" "$BACKUP_META_FILE" 2>/dev/null | cut -d'"' -f2)
    TECHNOLOGIES=$(grep "^TECHNOLOGIES=" "$BACKUP_META_FILE" 2>/dev/null | cut -d'"' -f2)
    DATE=$(grep "^DATE=" "$BACKUP_META_FILE" 2>/dev/null | cut -d'"' -f2)

    # Validate required fields
    if [ -z "$BACKUP_DIR" ]; then
        log "ERROR" "Invalid backup metadata: missing BACKUP_DIR"
        return 1
    fi

    log "INFO" "Backup metadata loaded from $BACKUP_META_FILE"
    return 0
}

# Restore from backup
# Usage: restore_backup
restore_backup() {
    if ! load_backup_metadata; then
        print_error "No backup metadata found"
        return 1
    fi

    if [ ! -d "$BACKUP_DIR" ]; then
        print_error "Backup directory not found: $BACKUP_DIR"
        return 1
    fi

    print_warning "Restoring from backup: $BACKUP_DIR"

    # Remove current .claude if it exists
    if [ -d ".claude" ]; then
        rm -rf ".claude"
    fi

    # Restore from backup
    if cp -r "$BACKUP_DIR" ".claude"; then
        print_success "Backup restored successfully"

        # Make writeable again
        chmod -R u+w ".claude"

        return 0
    else
        print_error "Failed to restore backup"
        return 1
    fi
}

# Rollback installation completely
# Usage: rollback_installation
rollback_installation() {
    print_header "Rolling Back Installation"

    if ! load_backup_metadata; then
        print_error "No backup found. Cannot rollback."
        return 1
    fi

    print_warning "This will restore your .claude directory from the backup."
    if ! confirm "Continue with rollback?"; then
        print_info "Rollback cancelled"
        return 1
    fi

    # Restore backup
    if restore_backup; then
        # Clean up backup metadata
        rm -f "$BACKUP_META_FILE"

        print_success "Installation rolled back successfully"
        print_info "Your previous configuration has been restored"
        return 0
    else
        print_error "Rollback failed"
        return 1
    fi
}

# Delete backup after successful installation
# Usage: delete_backup
delete_backup() {
    if ! load_backup_metadata; then
        print_info "No backup to delete"
        return 0
    fi

    if confirm "Delete backup directory ($BACKUP_DIR)?"; then
        if [ -d "$BACKUP_DIR" ]; then
            chmod -R u+w "$BACKUP_DIR" 2>/dev/null
            rm -rf "$BACKUP_DIR"
            print_success "Backup deleted"
        fi

        rm -f "$BACKUP_META_FILE"
        log "INFO" "Backup deleted"
    else
        print_info "Backup kept. You can delete it later:"
        print_info "  rm -rf $BACKUP_DIR"
        print_info "  rm -f $BACKUP_META_FILE"
    fi
}

# List all backups
# Usage: list_backups
list_backups() {
    print_header "Available Backups"

    local found=0

    for backup_dir in .claude-backup-*; do
        if [ -d "$backup_dir" ]; then
            ((found++))
            local timestamp=$(stat -c %y "$backup_dir" 2>/dev/null || stat -f "%Sm" "$backup_dir" 2>/dev/null)
            echo "  📁 $backup_dir"
            echo "     Created: $timestamp"
            echo ""
        fi
    done

    if [ $found -eq 0 ]; then
        print_info "No backups found"
        return 1
    fi

    return 0
}

# Interactive backup management
# Usage: manage_backups
manage_backups() {
    list_backups || return 0

    if [ -f "$BACKUP_META_FILE" ]; then
        print_info "Current installation backup: $(grep BACKUP_DIR $BACKUP_META_FILE | cut -d'"' -f2)"
    fi

    echo ""
    local choice=$(select_menu "What would you like to do?" \
        "Restore a backup" \
        "Delete a backup" \
        "Delete all backups" \
        "Cancel")

    case $choice in
        1)
            if [ -f "$BACKUP_META_FILE" ]; then
                restore_backup
            else
                print_error "No recent installation backup found"
            fi
            ;;
        2)
            list_backups || return 0
            read -p "Enter backup directory name to delete: " backup_name
            if [ -d "$backup_name" ]; then
                chmod -R u+w "$backup_name" 2>/dev/null
                rm -rf "$backup_name"
                print_success "Backup deleted: $backup_name"
            else
                print_error "Directory not found: $backup_name"
            fi
            ;;
        3)
            if confirm "Delete ALL backups? This cannot be undone"; then
                rm -rf .claude-backup-*
                print_success "All backups deleted"
            fi
            ;;
        4)
            print_info "Cancelled"
            ;;
    esac
}

# Check if backup exists
# Usage: has_backup
# Returns 0 if backup exists, 1 otherwise
has_backup() {
    [ -f "$BACKUP_META_FILE" ] && [ -d "$BACKUP_DIR" ]
}

# Get current backup directory
# Usage: get_backup_dir
get_backup_dir() {
    if load_backup_metadata 2>/dev/null; then
        echo "$BACKUP_DIR"
    fi
}

# Export functions
export -f backup_existing_claude save_backup_metadata load_backup_metadata
export -f restore_backup rollback_installation delete_backup
export -f list_backups manage_backups has_backup get_backup_dir
