#!/bin/bash
# piv.sh - PIV Spec-Kit installer (AGENTS.md + templates)
# For Claude Code full experience, use: /plugin install piv@piv-speckit

set -euo pipefail

################################################################################
# CONFIGURATION
################################################################################

readonly REPO_URL="https://github.com/galando/piv-speckit"
readonly REPO_NAME="piv-speckit"

# SCRIPT_VERSION is read from VERSION file (single source of truth)
get_script_version() {
    local version_file="$SCRIPT_DIR/../VERSION"
    if [[ -f "$version_file" ]]; then
        cat "$version_file" | tr -d '[:space:]'
    else
        echo "unknown"
    fi
}

# User options
PIV_BRANCH=""
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
    echo "🌐 PIV Spec-Kit - Downloading..."

    # Early argument parsing for branch/tag (needed before clone)
    while [ $# -gt 0 ]; do
        case $1 in
            --branch)
                PIV_BRANCH="$2"
                shift 2
                ;;
            --tag)
                PIV_TAG="$2"
                shift 2
                ;;
            *)
                shift
                ;;
        esac
    done

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

    # Clone repository (from specific branch/tag if requested)
    echo "Downloading from GitHub..."

    # Determine what to clone
    PIV_CLONE_REF=""
    PIV_REF_TYPE="branch"

    if [ -n "$PIV_TAG" ]; then
        PIV_CLONE_REF="$PIV_TAG"
        PIV_REF_TYPE="tag"
    elif [ -n "$PIV_BRANCH" ]; then
        PIV_CLONE_REF="$PIV_BRANCH"
        PIV_REF_TYPE="branch"
    fi

    if [ -n "$PIV_CLONE_REF" ]; then
        echo "Fetching $PIV_REF_TYPE: $PIV_CLONE_REF"
        if ! git clone --depth 1 --branch "$PIV_CLONE_REF" -q "https://github.com/galando/$REPO_NAME.git" "$TEMP_DIR" 2>/dev/null; then
            echo "Error: Failed to download $PIV_REF_TYPE '$PIV_CLONE_REF'"
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
source "$SCRIPT_DIR/install/generate-specs-templates.sh"

################################################################################
# ARGUMENT PARSING
################################################################################

print_usage() {
    cat << EOF
Usage: piv.sh [OPTIONS]

PIV Spec-Kit installer - generates AGENTS.md and spec templates.

OPTIONS:
    --branch <name>    Install from specific branch (for testing)
    --tag vX.Y.Z       Install from specific release tag (e.g., v1.0.0)
    --dry-run          Show changes without applying
    --help             Show this help message
    -v, --version      Show version information

EXAMPLES:
    # Install from main branch
    curl -s $REPO_URL/raw/main/scripts/piv.sh | bash

    # Install from feature branch (for testing PRs)
    curl -s $REPO_URL/raw/fix/installer-branding-and-tool-prompt/scripts/piv.sh | bash -s -- --branch fix/installer-branding-and-tool-prompt

For Claude Code full experience:
    /plugin marketplace add galando/piv-speckit
    /plugin install piv@piv-speckit

For more information: $REPO_URL
EOF
}

show_version() {
    local version
    version=$(get_script_version)
    cat << EOF
PIV Spec-Kit Installer v$version
Repository: $REPO_URL
EOF
}

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --branch=*)
            PIV_BRANCH="${1#*=}"
            shift
            ;;
        --branch)
            PIV_BRANCH="$2"
            shift 2
            ;;
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
║                    PIV Spec-Kit Installer                              ║
║                                                                        ║
║      Generates AGENTS.md and spec templates                            ║
║                                                                        ║
║      For Claude Code full experience:                                  ║
║      /plugin marketplace add galando/piv-speckit                        ║
║      /plugin install piv@piv-speckit                                   ║
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
    if [ -f "$ORIGINAL_DIR/AGENTS.md" ]; then
        echo "⚠️  PIV already installed in this directory"
        echo ""
        read -p "Reinstall/update? [y/N]: " -n 1 -r < /dev/tty
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

    echo ""
    echo "📦 Installing PIV Spec-Kit..."
    echo ""

    # 1. Generate AGENTS.md
    echo "📄 Generating AGENTS.md..."
    generate_agents_md "$target_dir/AGENTS.md"

    # 2. Generate .specs/.templates/ and constitution template
    echo ""
    echo "📁 Generating .specs/.templates/..."
    generate_specs_templates "$target_dir"

    echo ""
    echo "════════════════════════════════════════════════════════════════════"
    echo "✅ PIV Spec-Kit installed successfully!"
    echo "════════════════════════════════════════════════════════════════════"
    echo ""
    echo "📄 AGENTS.md              - Core PIV methodology (auto-loaded)"
    echo "📁 .specs/.templates/     - Spec, plan, and task templates"
    echo "📄 constitution.template.md - Project constitution template"
    echo ""
    echo "🚀 NEXT STEPS:"
    echo ""
    echo "1. Create your constitution:"
    echo "   cp constitution.template.md constitution.md"
    echo "   # Then customize it for your project"
    echo ""
    echo "2. Start using PIV workflow:"
    echo "   • Prime: \"Analyze this codebase\""
    echo "   • Plan:  \"Plan feature X in .specs/X/\""
    echo "   • Execute: \"Implement tasks.md using TDD\""
    echo ""
    echo "📚 Documentation: $REPO_URL/blob/main/docs/"
    echo ""
}

# Run main
main "$@"
