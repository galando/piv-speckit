#!/bin/bash
# bump-version.sh - Update VERSION (single source of truth) and propagate to all files
# Updates: VERSION, .claude-plugin/plugin.json, scripts/piv.sh, AGENTS.md, .cursor/rules/

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VERSION_FILE="$SCRIPT_DIR/../VERSION"
PLUGIN_FILE="$SCRIPT_DIR/../.claude-plugin/plugin.json"
INSTALLER_SCRIPT="$SCRIPT_DIR/piv.sh"

show_usage() {
    cat << EOF
Usage: bump-version.sh <major|minor|patch|VERSION>

Bump the PIV framework version and regenerate all files.

Arguments:
  major    Bump major version (e.g., 1.0.0 → 2.0.0)
  minor    Bump minor version (e.g., 1.0.0 → 1.1.0)
  patch    Bump patch version (e.g., 1.0.0 → 1.0.1)
  VERSION  Set exact version (e.g., 2.3.4)

Example:
  bump-version.sh patch
  bump-version.sh 2.0.0

Files updated:
  - VERSION (single source of truth)
  - .claude-plugin/plugin.json
  - scripts/piv.sh
  - AGENTS.md
  - .cursor/rules/*
EOF
}

bump_version() {
    local bump_type="$1"
    local current_version
    local new_version

    # Read current version
    current_version=$(cat "$VERSION_FILE" 2>/dev/null || echo "0.0.0")

    # Calculate new version
    if [[ "$bump_type" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
        # Exact version provided
        new_version="$bump_type"
    else
        # Semantic version bump
        IFS='.' read -r major minor patch <<< "$current_version"

        case "$bump_type" in
            major)
                major=$((major + 1))
                minor=0
                patch=0
                ;;
            minor)
                minor=$((minor + 1))
                patch=0
                ;;
            patch)
                patch=$((patch + 1))
                ;;
            *)
                echo "Error: Invalid bump type '$bump_type'"
                show_usage
                exit 1
                ;;
        esac

        new_version="$major.$minor.$patch"
    fi

    echo "Bumping version: $current_version → $new_version"

    # Update VERSION file
    echo "$new_version" > "$VERSION_FILE"
    echo "✅ Updated: VERSION"

    # Update plugin.json
    if [[ "$OSTYPE" == "darwin"* ]]; then
        sed -i '' "s/\"version\": \".*\"/\"version\": \"$new_version\"/" "$PLUGIN_FILE"
    else
        sed -i "s/\"version\": \".*\"/\"version\": \"$new_version\"/" "$PLUGIN_FILE"
    fi
    echo "✅ Updated: .claude-plugin/plugin.json"

    # Update piv.sh SCRIPT_VERSION
    if [[ "$OSTYPE" == "darwin"* ]]; then
        sed -i '' "s/readonly SCRIPT_VERSION=\".*\"/readonly SCRIPT_VERSION=\"$new_version\"/" "$INSTALLER_SCRIPT"
    else
        sed -i "s/readonly SCRIPT_VERSION=\".*\"/readonly SCRIPT_VERSION=\"$new_version\"/" "$INSTALLER_SCRIPT"
    fi
    echo "✅ Updated: scripts/piv.sh"

    # Regenerate AGENTS.md and .cursor/rules/
    echo ""
    echo "Regenerating files with new version..."

    # Source generators
    source "$SCRIPT_DIR/install/generate-agents-md.sh"
    source "$SCRIPT_DIR/install/generate-cursor-rules.sh"

    # Generate in project root
    generate_agents_md "$SCRIPT_DIR/../AGENTS.md"
    generate_cursor_rules "$SCRIPT_DIR/.."

    echo ""
    echo "════════════════════════════════════════════════════════════════════"
    echo "✅ Version bump complete!"
    echo "════════════════════════════════════════════════════════════════════"
    echo ""
    echo "Updated files:"
    echo "  - VERSION: $new_version"
    echo "  - .claude-plugin/plugin.json"
    echo "  - scripts/piv.sh"
    echo "  - AGENTS.md"
    echo "  - .cursor/rules/*"
    echo ""
    echo "Next steps:"
    echo "  1. Review changes: git diff"
    echo "  2. Commit: git add -A && git commit -m 'chore: bump version to $new_version'"
    echo "  3. Tag: git tag v$new_version"
    echo "  4. Push: git push --tags"
    echo ""
}

# Check arguments
if [ $# -eq 0 ]; then
    show_usage
    exit 1
fi

bump_version "$@"
