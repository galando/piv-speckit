#!/bin/bash
# piv.sh - Universal AI Dev Framework installer for Cursor and other AI tools
# For Claude Code, use: /plugin install piv@universal-ai-dev-framework

set -euo pipefail

################################################################################
# CONFIGURATION
################################################################################

readonly SCRIPT_VERSION="2.0.0"
readonly REPO_URL="https://github.com/galando/universal-ai-dev-framework"
readonly REPO_NAME="universal-ai-dev-framework"

# User options
PIV_TAG=""
DRY_RUN=false
AUTO_CONFIRM=false

# Working directory
ORIGINAL_DIR="$(pwd)"
SCRIPT_DIR=""

################################################################################
# CURL | BASH ENTRY POINT
################################################################################

# Check if running from stdin (via curl | bash)
if [ -z "${BASH_SOURCE+x}" ] || [ "${BASH_SOURCE[0]}" = "bash" ] || [ "${BASH_SOURCE[0]}" = "/dev/stdin" ]; then
    echo "🌐 Universal AI Dev Framework - Downloading..."

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

    # Clone repository (from specific tag if requested)
    echo "Downloading from GitHub..."
    if [ -n "$PIV_TAG" ]; then
        echo "Fetching tag: $PIV_TAG"
        if ! git clone --depth 1 --branch "$PIV_TAG" -q "https://github.com/galando/$REPO_NAME.git" "$TEMP_DIR" 2>/dev/null; then
            echo "Error: Failed to download tag '$PIV_TAG'"
            rm -rf "$TEMP_DIR"
            exit 1
        fi
    else
        if ! git clone --depth 1 -q "https://github.com/galando/$REPO_NAME.git" "$TEMP_DIR" 2>/dev/null; then
            echo "Error: Failed to download"
            rm -rf "$TEMP_DIR"
            exit 1
        fi
    fi

    # Change to original directory (with fallback)
    cd "$ORIGINAL_DIR" 2>/dev/null || cd /

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

# Source generators
source "$SCRIPT_DIR/install/generate-agents-md.sh"
source "$SCRIPT_DIR/install/generate-cursor-rules.sh"

################################################################################
# ARGUMENT PARSING
################################################################################

print_usage() {
    cat << EOF
Usage: piv.sh [OPTIONS]

Universal AI Dev Framework installer for Cursor and other AI tools.

OPTIONS:
    --tag vX.Y.Z       Install from specific release tag (e.g., v1.0.0)
    --dry-run          Show changes without applying
    --help             Show this help message
    -v, --version      Show version information

EXAMPLES:
    # Fresh install
    curl -s $REPO_URL/raw/main/scripts/piv.sh | bash

    # Install specific release
    curl -s $REPO_URL/raw/main/scripts/piv.sh | bash -s -- --tag v1.0.0

    # Preview changes without applying
    bash piv.sh --dry-run

For Claude Code full experience:
    /plugin marketplace add galando/universal-ai-dev-framework/marketplace
    /plugin install piv@universal-ai-dev-framework

For more information: $REPO_URL
EOF
}

show_version() {
    local version
    version=$(cat "$SCRIPT_DIR/../VERSION" 2>/dev/null || echo "unknown")
    cat << EOF
Universal AI Dev Framework Installer v$SCRIPT_VERSION
PIV Framework Version: $version
Repository: $REPO_URL
EOF
}

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --tag=*)
            PIV_TAG="${1#*=}"
            shift
            ;;
        --tag)
            PIV_TAG="$2"
            shift 2
            ;;
        --dry-run)
            DRY_RUN=true
            shift
            ;;
        --help|-h)
            print_usage
            exit 0
            ;;
        -v|--version)
            show_version
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            echo "Use --help for usage information"
            exit 1
            ;;
    esac
done

################################################################################
# BANNER
################################################################################

print_banner() {
    cat << "EOF"

╔═══════════════════════════════════════════════════════════════════════╗
║                                                                        ║
║            Universal AI Dev Framework - PIV Methodology                ║
║                                                                        ║
║      Works with: Cursor • GitHub Copilot • OpenAI Codex • More        ║
║                                                                        ║
║      For Claude Code full experience:                                  ║
║      /plugin marketplace add galando/universal-ai-dev-framework/marketplace
║      /plugin install piv@universal-ai-dev-framework                    ║
║                                                                        ║
╚═══════════════════════════════════════════════════════════════════════╝

EOF
}

################################################################################
# CONFIRMATION
################################################################################

confirm_install() {
    if [ "$AUTO_CONFIRM" = true ]; then
        return 0
    fi

    # Check if already installed
    if [ -f "$ORIGINAL_DIR/AGENTS.md" ] && [ -d "$ORIGINAL_DIR/.cursor/rules" ]; then
        echo "⚠️  PIV already installed in this directory"
        echo ""
        read -p "Reinstall/update? [y/N]: " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            echo "Aborted."
            exit 0
        fi
    fi

    return 0
}

################################################################################
# MAIN FLOW
################################################################################

main() {
    local target_dir="${1:-$ORIGINAL_DIR}"

    print_banner
    confirm_install

    echo "📦 Installing Universal AI Dev Framework..."
    echo ""

    # 1. Generate AGENTS.md (for all AI tools)
    echo "📄 Generating AGENTS.md..."
    generate_agents_md "$target_dir/AGENTS.md"

    # 2. Generate .cursor/rules/ (for Cursor users)
    echo ""
    echo "📁 Generating .cursor/rules/..."
    generate_cursor_rules "$target_dir"

    echo ""
    echo "════════════════════════════════════════════════════════════════════"
    echo "✅ Universal AI Dev Framework installed successfully!"
    echo "════════════════════════════════════════════════════════════════════"
    echo ""
    echo "📄 AGENTS.md - Core PIV methodology (works with ALL AI tools)"
    echo "📁 .cursor/rules/ - Auto-attach rules for Cursor"
    echo ""
    echo "For Cursor users:"
    echo "  • AGENTS.md is loaded automatically"
    echo "  • .cursor/rules/ auto-attach based on file type"
    echo "  • Edit a *Test.java file → TDD rules activate"
    echo "  • Edit a *Controller.java → API rules activate"
    echo ""
    echo "For other AI tools (Copilot, Codex, etc.):"
    echo "  • AGENTS.md provides PIV methodology guidance"
    echo ""
    echo "📚 Learn more: $REPO_URL"
    echo ""
}

# Run main
main "$@"
