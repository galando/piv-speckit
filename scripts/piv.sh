#!/bin/bash
# piv.sh - PIV Spec-Kit installer for Cursor and other AI tools
# For Claude Code, use: /plugin install piv@piv-speckit

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
TOOL=""  # cursor | copilot | (empty = all)

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
source "$SCRIPT_DIR/install/generate-cursor-rules.sh"
source "$SCRIPT_DIR/install/generate-copilot-instructions.sh"
source "$SCRIPT_DIR/install/generate-specs-templates.sh"

################################################################################
# ARGUMENT PARSING
################################################################################

print_usage() {
    cat << EOF
Usage: piv.sh [OPTIONS]

PIV Spec-Kit installer for Cursor and Copilot.

OPTIONS:
    --tool <name>      Install for specific tool: cursor | copilot
    --branch <name>    Install from specific branch (for testing)
    --tag vX.Y.Z       Install from specific release tag (e.g., v1.0.0)
    --dry-run          Show changes without applying
    --help             Show this help message
    -v, --version      Show version information

EXAMPLES:
    # Install for Cursor only
    curl -s $REPO_URL/raw/main/scripts/piv.sh | bash -s -- --tool cursor

    # Install from feature branch (for testing PRs)
    curl -s $REPO_URL/raw/fix/installer-branding-and-tool-prompt/scripts/piv.sh | bash -s -- --branch fix/installer-branding-and-tool-prompt

    # Install all tool configurations
    curl -s $REPO_URL/raw/main/scripts/piv.sh | bash

    # Install specific release for Cursor (example: vX.Y.Z)
    curl -s $REPO_URL/raw/main/scripts/piv.sh | bash -s -- --tool cursor --tag vX.Y.Z

For Claude Code full experience:
    /plugin marketplace add galando/piv-speckit/marketplace
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
        --tool=*)
            TOOL="$(echo "${1#*=}" | tr '[:upper:]' '[:lower:]')"
            shift
            ;;
        --tool)
            TOOL="$(echo "$2" | tr '[:upper:]' '[:lower:]')"
            shift 2
            ;;
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

# Validate tool option if provided
if [[ -n "$TOOL" && "$TOOL" != "cursor" && "$TOOL" != "copilot" ]]; then
    echo "Error: Invalid tool '$TOOL'"
    echo "Supported tools: cursor, copilot"
    echo ""
    print_usage
    exit 1
fi

################################################################################
# BANNER
################################################################################

print_banner() {
    cat << "EOF"

╔═══════════════════════════════════════════════════════════════════════╗
║                                                                        ║
║                    PIV Spec-Kit Installer                              ║
║                                                                        ║
║      Works with: Cursor • GitHub Copilot • Claude Code                ║
║                                                                        ║
║      For Claude Code full experience:                                  ║
║      /plugin marketplace add galando/piv-speckit/marketplace
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
    if [ -f "$ORIGINAL_DIR/AGENTS.md" ] && [ -d "$ORIGINAL_DIR/.cursor/rules" ]; then
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
# TOOL SELECTION
################################################################################

prompt_tool_selection() {
    # If tool already specified via flag, skip prompt
    if [[ -n "$TOOL" ]]; then
        return 0
    fi

    echo ""
    echo "🔧 Which AI tool(s) are you using?"
    echo ""
    echo "  [1] Cursor"
    echo "  [2] GitHub Copilot"
    echo "  [3] Both (default)"
    echo ""

    local selection
    local max_attempts=3
    local attempt=0

    while [ $attempt -lt $max_attempts ]; do
        read -p "Select option [1-3]: " -n 1 -r selection < /dev/tty 2>/dev/null || {
            # Non-interactive, default to both
            selection="3"
        }
        echo

        case "$selection" in
            1) TOOL="cursor"; break ;;
            2) TOOL="copilot"; break ;;
            3|"") TOOL=""; break ;;  # Empty = both
            *)
                if [ $attempt -lt $((max_attempts - 1)) ]; then
                    echo "⚠️  Invalid selection. Please enter 1, 2, or 3"
                fi
                ;;
        esac
        attempt=$((attempt + 1))
    done

    # Show what was selected
    if [[ -z "$TOOL" ]]; then
        echo "✓ Installing for: Cursor + Copilot"
    else
        echo "✓ Installing for: $TOOL"
    fi
}

################################################################################
# MAIN FLOW
################################################################################

main() {
    local target_dir="${1:-$ORIGINAL_DIR}"

    print_banner
    confirm_install
    prompt_tool_selection

    echo ""
    echo "📦 Installing PIV Spec-Kit..."
    echo ""

    # 1. Generate AGENTS.md (always - for all AI tools)
    echo "📄 Generating AGENTS.md..."
    generate_agents_md "$target_dir/AGENTS.md"

    # 2. Generate tool-specific rules
    if [[ -z "$TOOL" || "$TOOL" == "cursor" ]]; then
        echo ""
        echo "📁 Generating .cursor/rules/..."
        generate_cursor_rules "$target_dir"
    fi

    if [[ -z "$TOOL" || "$TOOL" == "copilot" ]]; then
        echo ""
        echo "📁 Generating .github/copilot-instructions.md..."
        generate_copilot_instructions "$target_dir"
    fi

    # 3. Generate .specs/.templates/ and constitution template
    echo ""
    echo "📁 Generating .specs/.templates/..."
    generate_specs_templates "$target_dir"

    echo ""
    echo "════════════════════════════════════════════════════════════════════"
    echo "✅ PIV Spec-Kit installed successfully!"
    echo "════════════════════════════════════════════════════════════════════"
    echo ""
    echo "📄 AGENTS.md              - Core PIV methodology (auto-loaded)"

    # Show installed tool files
    if [[ -z "$TOOL" || "$TOOL" == "cursor" ]]; then
        echo "📁 .cursor/rules/         - Auto-attach rules for Cursor"
    fi
    if [[ -z "$TOOL" || "$TOOL" == "copilot" ]]; then
        echo "📁 .github/copilot-instructions.md - Auto-load rules for Copilot"
    fi

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
    echo "📚 Guides:"
    if [[ -z "$TOOL" || "$TOOL" == "cursor" ]]; then
        echo "   • Cursor:  $REPO_URL/blob/main/docs/getting-started/06-cursor-guide.md"
    fi
    if [[ -z "$TOOL" || "$TOOL" == "copilot" ]]; then
        echo "   • Copilot: $REPO_URL/blob/main/docs/getting-started/07-copilot-guide.md"
    fi
    echo ""
}

# Run main
main "$@"
