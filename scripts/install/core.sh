#!/bin/bash
# core.sh - Core utility functions for PIV installer
# Provides common functions used across all installation scripts

# Color codes for output
readonly COLOR_RED='\033[0;31m'
readonly COLOR_GREEN='\033[0;32m'
readonly COLOR_YELLOW='\033[0;33m'
readonly COLOR_BLUE='\033[0;34m'
readonly COLOR_RESET='\033[0m'

# Logging
LOG_FILE=".piv-install.log"

# Initialize logging
init_logging() {
    echo "PIV Installation Log - $(date)" > "$LOG_FILE"
    echo "=================================" >> "$LOG_FILE"
}

log() {
    local level="$1"
    shift
    local message="$*"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [$level] $message" >> "$LOG_FILE"
}

# Print functions with colors
print_success() {
    echo -e "${COLOR_GREEN}✓ $*${COLOR_RESET}"
    log "INFO" "$*"
}

print_error() {
    echo -e "${COLOR_RED}✗ $*${COLOR_RESET}" >&2
    log "ERROR" "$*"
}

print_warning() {
    echo -e "${COLOR_YELLOW}⚠ $*${COLOR_RESET}"
    log "WARN" "$*"
}

print_info() {
    echo -e "${COLOR_BLUE}ℹ $*${COLOR_RESET}"
    log "INFO" "$*"
}

print_header() {
    local title="$1"
    local width=60
    local padding=$(( (width - ${#title} - 2) / 2 ))

    echo ""
    echo "$(printf '═%.0s' $(seq 1 $width))"
    echo "$(printf ' %.0s' $(seq 1 $padding))${title}$(printf ' %.0s' $(seq 1 $padding))"
    echo "$(printf '═%.0s' $(seq 1 $width))"
    echo ""
    log "INFO" "====== $title ======"
}

# Check if we need to read from terminal
if [ ! -t 0 ]; then
    # Stdin is not a terminal, use /dev/tty for interactive input
    USE_TTY=1
else
    USE_TTY=0
fi

# Confirmation prompt
# Returns 0 (success/yes) or 1 (no)
confirm() {
    local prompt="$1"
    local default="${2:-Y}"
    local response

    if [[ "$default" == "Y" ]]; then
        if [ "$USE_TTY" -eq 1 ]; then
            read -p "$prompt [Y/n]: " -n 1 -r response < /dev/tty
        else
            read -p "$prompt [Y/n]: " -n 1 -r response
        fi
        echo
        [[ -z "$response" ]] || [[ "$response" =~ ^[Yy]$ ]]
    else
        if [ "$USE_TTY" -eq 1 ]; then
            read -p "$prompt [y/N]: " -n 1 -r response < /dev/tty
        else
            read -p "$prompt [y/N]: " -n 1 -r response
        fi
        echo
        [[ "$response" =~ ^[Yy]$ ]]
    fi
}

# Select from menu
# Usage: select_menu "Choose option" "option1" "option2" "option3"
# Returns index (1-based) of selected option (via echo, not return code)
# Menu display goes to stderr to avoid interfering with command substitution
select_menu() {
    local title="$1"
    shift
    local options=("$@")
    local max_attempts=5
    local attempt=0

    # Print menu to stderr (not captured by command substitution)
    echo "" >&2
    print_info "$title" >&2
    local i=1
    for opt in "${options[@]}"; do
        echo "  [$i] $opt" >&2
        ((i++))
    done

    local selection
    while [ $attempt -lt $max_attempts ]; do
        if [ "$USE_TTY" -eq 1 ]; then
            if ! read -p "Select option [1-${#options[@]}]: " selection < /dev/tty; then
                log "ERROR" "read failed from /dev/tty (attempt $((attempt+1))/$max_attempts)"
                attempt=$((attempt + 1))
                [ $attempt -lt $max_attempts ] && continue
                # Fall through to default
                break
            fi
        else
            if ! read -p "Select option [1-${#options[@]}]: " selection; then
                log "ERROR" "read failed from stdin (attempt $((attempt+1))/$max_attempts)"
                attempt=$((attempt + 1))
                [ $attempt -lt $max_attempts ] && continue
                # Fall through to default
                break
            fi
        fi

        # Trim whitespace
        selection=$(echo "$selection" | xargs 2>/dev/null || echo "$selection")

        if [[ "$selection" =~ ^[0-9]+$ ]] && [ "$selection" -ge 1 ] && [ "$selection" -le "${#options[@]}" ]; then
            echo "" >&2
            echo "$selection"  # Only this goes to stdout (captured by caller)
            log "INFO" "User selected option $selection"
            return 0
        fi

        log "WARN" "Invalid selection: '$selection'"
        print_error "Invalid selection. Please enter a number between 1 and ${#options[@]}"
        # Safe increment: attempt is initialized and bounded by while loop condition
        attempt=$((attempt + 1))
    done

    # If we get here, read failed repeatedly - default to option 1
    log "ERROR" "Failed to get valid selection after $max_attempts attempts, defaulting to option 1"
    print_error "Unable to read input, defaulting to option 1" >&2
    echo "" >&2
    echo "1"
    return 1
}

# Check prerequisites
check_prerequisites() {
    print_header "Checking Prerequisites"

    local missing=0

    # Check if we're in a git repository
    if git rev-parse --git-dir > /dev/null 2>&1; then
        print_success "Git repository detected"
    else
        print_warning "Not a git repository (optional but recommended)"
    fi

    # Check for required commands
    local required_commands=("bash" "cp" "mkdir" "rm")
    for cmd in "${required_commands[@]}"; do
        if command -v "$cmd" &> /dev/null; then
            print_success "$cmd is available"
        else
            print_error "$cmd is not available"
            ((missing++))
        fi
    done

    # Check for optional commands
    local optional_commands=("git" "rsync")
    for cmd in "${optional_commands[@]}"; do
        if command -v "$cmd" &> /dev/null; then
            print_success "$cmd is available (optional)"
        else
            print_warning "$cmd is not available (optional)"
        fi
    done

    # Check write permissions
    if [ -w "." ]; then
        print_success "Write permissions OK"
    else
        print_error "No write permissions in current directory"
        ((missing++))
    fi

    if [ $missing -gt 0 ]; then
        print_error "Missing $missing required prerequisites"
        return 1
    fi

    print_success "All prerequisites met"
    return 0
}

# Create directory if it doesn't exist
# Usage: ensure_dir "path/to/directory"
ensure_dir() {
    local dir="$1"
    if [ ! -d "$dir" ]; then
        mkdir -p "$dir"
        log "INFO" "Created directory: $dir"
    fi
}

# Copy file or directory
# Usage: copy_file "source" "destination"
copy_file() {
    local src="$1"
    local dest="$2"

    if [ -e "$src" ]; then
        if [ -d "$src" ]; then
            if command -v rsync &> /dev/null; then
                rsync -av --delete "$src/" "$dest/"
            else
                mkdir -p "$dest"
                cp -r "$src"/* "$dest/"
            fi
        else
            cp "$src" "$dest"
        fi
        log "INFO" "Copied: $src -> $dest"
    else
        print_error "Source not found: $src"
        return 1
    fi
}

# Copy file only if destination doesn't exist
# Usage: copy_file_if_missing "source" "destination"
copy_file_if_missing() {
    local src="$1"
    local dest="$2"

    if [ ! -e "$dest" ]; then
        copy_file "$src" "$dest"
    else
        log "INFO" "Skipped (exists): $dest"
    fi
}

# Merge two directories, preserving existing files in destination
# Usage: merge_dirs "source" "destination"
merge_dirs() {
    local src="$1"
    local dest="$2"

    ensure_dir "$dest"

    if [ -d "$src" ]; then
        # Copy all files, skipping existing ones
        if command -v rsync &> /dev/null; then
            rsync -av --ignore-existing "$src/" "$dest/"
        else
            # Fallback to manual copy
            for item in "$src"/*; do
                local basename=$(basename "$item")
                if [ ! -e "$dest/$basename" ]; then
                    cp -r "$item" "$dest/"
                fi
            done
        fi
        log "INFO" "Merged: $src -> $dest"
    fi
}

# Get the directory where this script is located
get_script_dir() {
    local source="${BASH_SOURCE[0]}"
    while [ -h "$source" ]; do
        local dir="$(cd -P "$(dirname "$source")" && pwd)"
        source="$(readlink "$source")"
        [[ $source != /* ]] && source="$dir/$source"
    done
    cd -P "$(dirname "$source")" && pwd
}

# Create or update CLAUDE.md with PIV section
# Usage: create_claude_md "project_name" "technologies" [existing_content]
create_claude_md() {
    local project_name="$1"
    local technologies="$2"
    local existing_content="${3:-}"

    cat > .claude/CLAUDE.md << EOF
# $project_name - PIV Configuration

**PIV Methodology**: This project uses the Prime-Implement-Validate (PIV) methodology for AI-assisted development.

## Quick Reference

### Core PIV Commands
- \`/piv_loop:prime\` - Load project context
- \`/piv_loop:plan-feature "description"\` - Create implementation plan
- \`/piv_loop:execute\` - Execute plan (auto-validates)

### Validation Commands
- \`/validation:validate\` - Run validation pipeline (automatic)
- \`/validation:code-review\` - Technical code review

### Bug Fix Commands
- \`/bug_fix:rca\` - Root cause analysis
- \`/bug_fix:implement-fix\` - Implement bug fix

## Technology Stack
$technologies

## PIV Configuration

### Methodology Documentation
See \`PIV-METHODOLOGY.md\` for complete methodology guide.

### Rules
- Universal rules apply to all code (see \`rules/\`)
- Technology-specific rules load automatically based on file type

### Commands
All PIV commands are defined in \`commands/\` directory.

---

$(if [ -n "$existing_content" ]; then
    echo "## Existing Project Configuration"
    echo ""
    echo "$existing_content"
fi)
EOF

    log "INFO" "Created/updated .claude/CLAUDE.md"
}

# Append PIV reference to existing CLAUDE.md
# Usage: append_piv_reference [methodology_path]
#   methodology_path: Path to PIV-METHODOLOGY.md (default: .claude-piv/PIV-METHODOLOGY.md for separate mode)
append_piv_reference() {
    local methodology_path="${1:-.claude-piv/PIV-METHODOLOGY.md}"
    local claude_file=".claude/CLAUDE.md"

    if [ -f "$claude_file" ]; then
        # Check if PIV section already exists
        if grep -q "PIV Methodology" "$claude_file"; then
            log "INFO" "PIV reference already exists in CLAUDE.md"
            return 0
        fi

        # Create backup
        cp "$claude_file" "$claude_file.pre-piv"

        # Prepend PIV section with correct path
        # Note: EOF is unquoted to allow $methodology_path variable expansion (intentional)
        cat > "$claude_file.tmp" << EOF
# PIV Methodology

This project uses the **PIV (Prime-Implement-Validate)** methodology for AI-assisted development.

## Quick Start

1. **Prime**: Load context with \`/piv_loop:prime\`
2. **Plan**: Create plan with \`/piv_loop:plan-feature "description"\`
3. **Execute**: Implement with \`/piv_loop:execute\` (auto-validates)

## Documentation

See \`$methodology_path\` for complete methodology guide.

---

EOF

        cat "$claude_file" >> "$claude_file.tmp"
        mv "$claude_file.tmp" "$claude_file"

        log "INFO" "Appended PIV reference to CLAUDE.md"
    fi
}

# Append PIV reference for merge mode (uses .claude/ path)
# Usage: append_piv_reference_merge
append_piv_reference_merge() {
    append_piv_reference ".claude/PIV-METHODOLOGY.md"
}

# Check if running in supported shell
check_shell_version() {
    if [ -z "${BASH_VERSION+x}" ]; then
        print_error "This script must be run with bash"
        return 1
    fi

    # Bash 3.2+ for macOS compatibility, 4.0+ recommended
    local major_version="${BASH_VERSION%%.*}"
    if [ "$major_version" -lt 3 ]; then
        print_error "Bash version 3.2 or higher required (current: $BASH_VERSION)"
        return 1
    fi

    return 0
}

# Error handler
error_exit() {
    print_error "$1"
    log "ERROR" "$1"
    exit 1
}

# Trap errors
set_error_trap() {
    set -euo pipefail
    trap 'error_exit "Installation failed at line $LINENO"' ERR
}

# Initialize
init_logging
check_shell_version || exit 1

# Export functions for use in other scripts
export -f print_success print_error print_warning print_info
export -f print_header confirm select_menu
export -f check_prerequisites ensure_dir
export -f copy_file copy_file_if_missing merge_dirs
export -f get_script_dir create_claude_md append_piv_reference append_piv_reference_merge
export -f check_shell_version error_exit set_error_trap
