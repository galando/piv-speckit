#!/bin/bash
# load-reference.sh - Loads reference documentation for PIV commands and skills
# This script is called by hooks before Skill tool execution
# Uses ${CLAUDE_PLUGIN_ROOT} which is set by Claude Code for plugins
#
# Configuration is in hooks/reference-mappings.json - edit that file to add mappings

set -e

# Read tool input from stdin (JSON)
TOOL_INPUT=$(cat)

# Extract skill name from the JSON input
# Expected format: {"skill": "piv_loop:plan-feature", "args": "..."}
SKILL_NAME=$(echo "$TOOL_INPUT" | grep -o '"skill"[[:space:]]*:[[:space:]]*"[^"]*"' | sed 's/.*"\([^"]*\)"$/\1/' || echo "")

# If no skill name found, exit silently
if [ -z "$SKILL_NAME" ]; then
    exit 0
fi

# Config and reference paths
CONFIG_FILE="${CLAUDE_PLUGIN_ROOT}/hooks/reference-mappings.json"
# Reference files are in .claude-plugin/reference/ for plugin distribution
REFERENCE_BASE="${CLAUDE_PLUGIN_ROOT}/.claude-plugin/reference"

# Check if config exists
if [ ! -f "$CONFIG_FILE" ]; then
    exit 0
fi

# Extract file paths for this skill from the JSON config
# Uses Python for reliable JSON parsing (available on macOS/Linux)
if command -v python3 &> /dev/null; then
    FILES=$(python3 -c "
import json
import sys

with open('$CONFIG_FILE', 'r') as f:
    config = json.load(f)

skill = '$SKILL_NAME'
mappings = config.get('mappings', {})

if skill in mappings:
    for path in mappings[skill]:
        print(path)
" 2>/dev/null || echo "")
else
    # Fallback: simple grep-based extraction (less reliable)
    FILES=$(grep -A 100 "\"$SKILL_NAME\"" "$CONFIG_FILE" | grep -o '"[^"]*\.md"' | head -20 | tr -d '"' || echo "")
fi

# If no files found for this skill, exit silently
if [ -z "$FILES" ]; then
    exit 0
fi

# Output header
echo ""
echo "--- PIV Reference Documentation (Auto-loaded) ---"

# Output each reference file
echo "$FILES" | while read -r REL_PATH; do
    if [ -n "$REL_PATH" ]; then
        FULL_PATH="${REFERENCE_BASE}/${REL_PATH}"
        if [ -f "$FULL_PATH" ]; then
            # Create readable header from filename
            HEADER=$(basename "$REL_PATH" .md | sed 's/-/ /g')
            echo ""
            echo "### ${HEADER} ###"
            echo ""
            cat "$FULL_PATH"
        fi
    fi
done

echo ""
echo "--- End of Reference Documentation ---"
echo ""
