#!/bin/bash
# load-reference.sh - Loads reference documentation for PIV commands
# This script is called by hooks before Skill tool execution
# Uses ${CLAUDE_PLUGIN_ROOT} which is set by Claude Code for plugins

set -e

# Read tool input from stdin (JSON)
TOOL_INPUT=$(cat)

# Extract skill name from the JSON input
# Expected format: {"skill": "piv_loop:plan-feature", "args": "..."}
SKILL_NAME=$(echo "$TOOL_INPUT" | grep -o '"skill"[[:space:]]*:[[:space:]]*"[^"]*"' | sed 's/.*"\([^"]*\)"$/\1/' || echo "")

# If no skill name found, exit silently (not our concern)
if [ -z "$SKILL_NAME" ]; then
    exit 0
fi

# Reference file mapping
# Only load references for commands that have execution methodology files
REFERENCE_DIR="${CLAUDE_PLUGIN_ROOT}/.claude/reference/execution"

case "$SKILL_NAME" in
    "piv_loop:plan-feature")
        REFERENCE_FILE="${REFERENCE_DIR}/plan-feature.md"
        ;;
    "piv_loop:execute")
        REFERENCE_FILE="${REFERENCE_DIR}/execute.md"
        ;;
    "validation:code-review")
        REFERENCE_FILE="${REFERENCE_DIR}/code-review.md"
        ;;
    "validation:validate")
        REFERENCE_FILE="${REFERENCE_DIR}/validate.md"
        ;;
    *)
        # Not a command that needs reference loading
        exit 0
        ;;
esac

# Output the reference file if it exists
if [ -f "$REFERENCE_FILE" ]; then
    echo ""
    echo "--- PIV Reference Documentation (Auto-loaded) ---"
    echo ""
    cat "$REFERENCE_FILE"
    echo ""
    echo "--- End of Reference Documentation ---"
    echo ""
fi
