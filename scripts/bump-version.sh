#!/bin/bash
# bump-version.sh - Update VERSION (single source of truth)
# All other files read VERSION dynamically - no hardcoded versions anywhere

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VERSION_FILE="$SCRIPT_DIR/../VERSION"

show_usage() {
    cat << EOF
Usage: bump-version.sh <major|minor|patch|VERSION>

Bump the PIV framework version.
VERSION is the single source of truth - all other files read from it.

Arguments:
  major    Bump major version (e.g., 1.0.0 → 2.0.0)
  minor    Bump minor version (e.g., 1.0.0 → 1.1.0)
  patch    Bump patch version (e.g., 1.0.0 → 1.0.1)
  VERSION  Set exact version (e.g., 2.3.4)

Example:
  bump-version.sh patch
  bump-version.sh 2.0.0

Files updated:
  - VERSION (single source of truth - ONLY place with version number)

Note: All other files (piv.sh, generators, etc.) read VERSION dynamically.
EOF
}

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
  - .github/copilot-instructions.md
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

    # Update VERSION file (ONLY place with version number)
    echo "$new_version" > "$VERSION_FILE"

    echo ""
    echo "════════════════════════════════════════════════════════════════════"
    echo "✅ Version bump complete!"
    echo "════════════════════════════════════════════════════════════════════"
    echo ""
    echo "Updated: VERSION = $new_version"
    echo ""
    echo "All other files read VERSION dynamically:"
    echo "  - scripts/piv.sh: reads VERSION at runtime"
    echo "  - .cursor/rules/*: read VERSION at generation time"
    echo "  - AGENTS.md: reads VERSION at generation time"
    echo ""
    echo "Next steps:"
    echo "  1. Commit: git add VERSION && git commit -m 'chore: bump version to $new_version'"
    echo "  2. Tag: git tag v$new_version"
    echo "  3. Push: git push --tags"
    echo ""
}

# Check arguments
if [ $# -eq 0 ]; then
    show_usage
    exit 1
fi

bump_version "$@"
