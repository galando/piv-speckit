#!/bin/bash
# piv.sh - Unified PIV installer and updater
# Auto-detects whether to install fresh or update existing
#
# Usage:
#   curl -s .../piv.sh | bash
#   bash piv.sh --help
#   bash piv.sh --version 1.1.0 --pin

set -euo pipefail

################################################################################
# CONFIGURATION
################################################################################

readonly SCRIPT_NAME="piv.sh"
readonly SCRIPT_VERSION="1.1.0"

# User options
# PIV_VERSION is reserved for future use (will support installing specific versions from remote)
PIV_VERSION="${PIV_VERSION:-latest}"
PINNED_VERSION=""
DRY_RUN=false
FORCE=false
WANT_VERSION=false

# Working directory
ORIGINAL_DIR="$(pwd)"
SCRIPT_DIR=""

################################################################################
# CURL | BASH ENTRY POINT
################################################################################

# Check if running from stdin (via curl | bash)
if [ -z "${BASH_SOURCE+x}" ] || [ "${BASH_SOURCE[0]}" = "bash" ] || [ "${BASH_SOURCE[0]}" = "/dev/stdin" ]; then
    echo "PIV Installer - Downloading..."

    # Create temp directory
    TEMP_DIR=$(mktemp -d) || {
        echo "Error: Cannot create temp directory"
        exit 1
    }

    # Check for git
    if ! command -v git &> /dev/null; then
        echo "Error: git is required"
        rm -rf "$TEMP_DIR"
        exit 1
    fi

    # Clone repository
    echo "Downloading from GitHub..."
    if ! git clone --depth 1 -q https://github.com/galando/claude-dev-framework.git "$TEMP_DIR" 2>/dev/null; then
        echo "Error: Failed to download"
        rm -rf "$TEMP_DIR"
        exit 1
    fi

    # Change to original directory
    cd "$ORIGINAL_DIR" || cd /

    # Run the real script with all arguments
    bash "$TEMP_DIR/scripts/piv.sh" "$@" < /dev/tty
    EXIT_CODE=$?

    # Clean up
    rm -rf "$TEMP_DIR"

    exit $EXIT_CODE
fi

################################################################################
# SCRIPT INITIALIZATION
################################################################################

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Source all required modules
source "$SCRIPT_DIR/install/core.sh"
source "$SCRIPT_DIR/install/backup.sh"
source "$SCRIPT_DIR/install/detect-tech.sh"
source "$SCRIPT_DIR/install/verify.sh"
source "$SCRIPT_DIR/install/merge-mode.sh"
source "$SCRIPT_DIR/install/separate-mode.sh"
source "$SCRIPT_DIR/install/unified.sh"
source "$SCRIPT_DIR/install/update.sh"

# Set PIV source directory
if [ -f "$SCRIPT_DIR/../.claude/reference/methodology/PIV-METHODOLOGY.md" ]; then
    PIV_SOURCE_DIR="$(dirname "$SCRIPT_DIR")"
elif [ -f "$SCRIPT_DIR/../.claude/PIV-METHODOLOGY.md" ]; then
    PIV_SOURCE_DIR="$(dirname "$SCRIPT_DIR")"
else
    echo "Error: PIV source not found"
    exit 1
fi

export PIV_SOURCE_DIR SCRIPT_DIR

################################################################################
# ARGUMENT PARSING
################################################################################

print_usage() {
    cat << EOF
Usage: $SCRIPT_NAME [OPTIONS]

Unified PIV installer and updater. Auto-detects install vs update.

OPTIONS:
    --version X.Y.Z    Pin to specific version
    --pin              Remember version for future updates
    --dry-run          Show changes without applying
    --force            Skip confirmation prompts
    --help             Show this help message
    -v, --version      Show version information

EXAMPLES:
    # Fresh install or update (auto-detected)
    curl -s https://raw.githubusercontent.com/galando/claude-dev-framework/main/scripts/piv.sh | bash

    # Pin to version 1.1.0
    bash piv.sh --version 1.1.0 --pin

    # Preview changes without applying
    bash piv.sh --dry-run

    # Update without confirmation
    bash piv.sh --force

For more information: https://github.com/galando/claude-dev-framework
EOF
}

show_version() {
    cat << EOF
PIV Unified Script v$SCRIPT_VERSION
PIV Framework Version: $(get_version "$SCRIPT_DIR/..")
EOF
}

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --version=*)
            PIV_VERSION="${1#*=}"
            PINNED_VERSION="$PIV_VERSION"
            shift
            ;;
        --pin)
            PINNED_VERSION="$PIV_VERSION"
            shift
            ;;
        --dry-run)
            DRY_RUN=true
            shift
            ;;
        --force)
            FORCE=true
            shift
            ;;
        --help|-h)
            print_usage
            exit 0
            ;;
        -v|--version)
            WANT_VERSION=true
            shift
            ;;
        *)
            echo "Unknown option: $1"
            echo "Use --help for usage information"
            exit 1
            ;;
    esac
done

# Show version and exit if requested
if [ "$WANT_VERSION" = true ]; then
    show_version
    exit 0
fi

# Export options for subshells
export DRY_RUN FORCE PINNED_VERSION

################################################################################
# MAIN FLOW
################################################################################

print_welcome_unified() {
    cat << "EOF"

╔═══════════════════════════════════════════════════════════╗
║                                                           ║
║              PIV Framework Installer/Updater             ║
║                                                           ║
║     Prime → Implement → Validate methodology              ║
║                                                           ║
╚═══════════════════════════════════════════════════════════╝

EOF

    print_info "PIV: Universal methodology for AI-assisted development"
    echo ""
}

main() {
    # Set error trap
    set_error_trap

    # Print welcome
    print_welcome_unified

    # Ensure we're in the project directory
    cd "$ORIGINAL_DIR" || {
        print_error "Cannot access project directory"
        exit 1
    }

    # Route to install or update
    route_to_install_or_update

    # Print success
    echo ""
    print_success "Done!"
    echo ""

    # Show next steps
    print_info "Quick Start:"
    echo "  1. Load context: /piv_loop:prime"
    echo "  2. Plan feature: /piv_loop:plan-feature \"description\""
    echo "  3. Implement: /piv_loop:execute"
    echo ""
}

# Run main
main "$@"
