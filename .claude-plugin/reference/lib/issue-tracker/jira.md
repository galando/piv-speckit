# Jira Issue Operations

Wrapper for Jira CLI and MCP server commands used in bug fix workflows.

## Prerequisites

### Option 1: Jira CLI (jira-cli)

- [jira-cli](https://github.com/ankitpokhrel/jira-cli) installed
- Configured with Jira instance and credentials
- `jira issue list` should return results

**Installation:**
```bash
# macOS
brew tap ankitpokhrel/jira-cli
brew install jira-cli

# Linux
curl -sL https://raw.githubusercontent.com/ankitpokhrel/jira-cli/main/scripts/install.sh | bash

# Configure
jira init
```

### Option 2: Jira MCP Server

- Atlassian Remote MCP Server configured
- OR community MCP server (e.g., mcp-jira)
- MCP tools available in Claude environment

## Fetch Issue Details

### Primary: MCP Server (if available)

If MCP Jira server is configured:

```bash
# Use MCP tool (via Claude)
# Tool: mcp__jira__get_issue or equivalent
# Parameters: { issueKey: "$ISSUE_KEY" }
```

**Note:** MCP tool names vary by server implementation. Common variants include:
- Atlassian Remote MCP Server: Check official documentation
- mcp-jira community server: `get_issue` or similar
- Custom servers: May have different naming conventions

Verify your MCP server's available tools before using.

### Fallback: jira-cli

```bash
jira issue view "$ISSUE_KEY" --plain
```

### Fallback: Curl (REST API)

If neither CLI nor MCP available, use Jira REST API:

```bash
# Validate token is set
if [[ -z "$JIRA_API_TOKEN" ]]; then
  echo "Error: JIRA_API_TOKEN environment variable not set"
  echo "Set it with: export JIRA_API_TOKEN='your-token'"
  exit 1
fi

# Requires JIRA_API_TOKEN environment variable
curl -s \
  -H "Authorization: Bearer $JIRA_API_TOKEN" \
  "$JIRA_INSTANCE/rest/api/3/issue/$ISSUE_KEY"
```

**Note:** This example requires the `jq` command for JSON parsing in most workflows.

### Graceful Degradation

If no Jira access method is available:
- Warn user about limited functionality
- Proceed with issue key only
- Require manual context gathering for RCA

```bash
echo "Warning: Jira CLI/MCP not available"
echo "Proceeding with issue key: $ISSUE_KEY"
echo "Please provide issue details manually"
```

## Issue Key Format

Jira issue keys follow the pattern: `{PROJECT}-{NUMBER}`

| Example | Valid? | Project | Number |
|---------|--------|---------|--------|
| `PROJ-123` | ✅ | PROJ | 123 |
| `ABC-1` | ✅ | ABC | 1 |
| `DEMO-999` | ✅ | DEMO | 999 |
| `proj-123` | ❌ | - | - (lowercase not valid) |
| `PROJ123` | ❌ | - | - (missing dash) |

## Branch Name Format

```
fix/{JIRA_KEY}-{description}
```

Examples:
- `fix/PROJ-123-login-fail`
- `fix/ABC-456-memory-leak`
- `fix/DEMO-789-api-timeout`

**Note:** Use the Jira key directly (not "issue-{number}" like GitHub)

## Commit Footer Format

```
Fixes {JIRA_KEY}
```

Examples:
- `Fixes PROJ-123`
- `Closes ABC-456`
- `Resolves DEMO-789`

## RCA Output Path Format

```
.claude/agents/reviews/rca-{JIRA_KEY}-{title}.md
```

Example: `.claude/agents/reviews/rca-PROJ-123-login-fails.md`

## Jira Instance Configuration

### Default Instance

Most Jira CLI setups use a default instance configured during `jira init`.

### Custom Instance (per-command)

For custom instances, use format: `PROJ-123@https://jira.example.com`

```bash
# Parse custom instance from input
# Note: BASH_REMATCH requires Bash 4.0+ (not default on macOS)
# For macOS compatibility, use sed/grep alternatives
if [[ "$ARGUMENTS" =~ ^([A-Z]+-[0-9]+)@(https?://.+) ]]; then
  ISSUE_KEY="${BASH_REMATCH[1]}"
  JIRA_INSTANCE="${BASH_REMATCH[2]}"
fi

# macOS-compatible alternative using sed:
ISSUE_KEY=$(echo "$ARGUMENTS" | cut -d@ -f1)
JIRA_INSTANCE=$(echo "$ARGUMENTS" | cut -d@ -f2)

# Use with jira-cli
jira issue view "$ISSUE_KEY" --server "$JIRA_INSTANCE"
```

### Environment Variable

Set default instance via environment:

```bash
export JIRA_INSTANCE="https://your-domain.atlassian.net"
export JIRA_API_TOKEN="your-api-token"
```

## Common Jira CLI Commands

### View Issue

```bash
jira issue view PROJ-123 --plain
```

### List Issues

```bash
# All open issues
jira issue list --plain

# By project
jira issue list --project PROJ --plain

# By assignee
jira issue list --assignee $(jira me) --plain

# By status
jira issue list --status "In Progress" --plain
```

### Add Comment

```bash
jira issue comment PROJ-123 "This issue is being investigated"
```

### Transition Issue

```bash
# Move to "In Progress"
jira issue transition PROJ-123 "In Progress"

# Move to "Done"
jira issue transition PROJ-123 "Done"
```

### Create Branch from Issue

```bash
# jira-cli has built-in branch creation
jira branch create PROJ-123 --template "fix/{key}-{summary}"
```

## Jira MCP Tool Mappings

| Operation | jira-cli | MCP Tool | REST API |
|-----------|----------|----------|----------|
| Get issue | `jira issue view` | `mcp__jira__get_issue` | `GET /rest/api/3/issue/{key}` |
| Search | `jira issue list` | `mcp__jira__search_issues` | `POST /rest/api/3/search` |
| Update | `jira issue update` | `mcp__jira__update_issue` | `PUT /rest/api/3/issue/{key}` |
| Comment | `jira issue comment` | `mcp__jira__add_comment` | `POST /rest/api/3/issue/{key}/comment` |
| Transition | `jira issue transition` | `mcp__jira__transition_issue` | `POST /rest/api/3/issue/{key}/transitions` |

## Integration with GitHub

When using Jira with GitHub repositories:

### Option 1: Jira's GitHub Integration

- Connect Jira to GitHub repository
- Jira automatically links commits and PRs
- Use Jira key in branch names
- Use Jira key in commit footers
- Jira displays development panel with PRs

### Option 2: Manual Linking

- Create PR as usual with GitHub
- Include Jira key in PR title/description
- Use smart commits: `PROJ-123#comment Fixed the bug`

## Common Workflows

### 1. Fetch Jira Issue for RCA

```bash
# Detect Jira instance (macOS-compatible - avoids BASH_REMATCH)
if [[ "$ARGUMENTS" == *@* ]]; then
  ISSUE_KEY=$(echo "$ARGUMENTS" | cut -d@ -f1)
  JIRA_INSTANCE=$(echo "$ARGUMENTS" | cut -d@ -f2)
else
  ISSUE_KEY="$ARGUMENTS"
  JIRA_INSTANCE="${JIRA_INSTANCE:-https://your-domain.atlassian.net}"
fi

# Try MCP first (if available)
# mcp__jira__get_issue --issueKey "$ISSUE_KEY"

# Fallback to jira-cli
if command -v jira >/dev/null 2>&1; then
  jira issue view "$ISSUE_KEY" --plain
else
  echo "Warning: Jira access not available"
  echo "Using issue key: $ISSUE_KEY"
fi
```

### 2. Create Branch from Jira Issue

```bash
# Sanitize issue key for branch name
BRANCH_NAME="fix/$ISSUE_KEY-$(echo "$ISSUE_SUMMARY" | tr '[:upper:]' '[:lower:]' | tr ' ' '-')"
git checkout -b "$BRANCH_NAME"
```

### 3. Commit with Jira Reference

```bash
git commit -m "fix: handle special characters in password

- Add proper escaping for special characters
- Update validation regex
- Add unit tests for edge cases

Fixes $ISSUE_KEY"
```

### 4. Push and Create PR (with Jira reference)

```bash
git push -u origin "$BRANCH_NAME"

# For GitHub repos, create PR with Jira key in title
gh pr create \
  --title "Fix: $ISSUE_KEY - Brief description" \
  --body "Fixes $ISSUE_KEY

## Summary
[Description]

## Changes
- [Change 1]
- [Change 2]"
```

## Error Handling

### Issue Not Found

```bash
if ! jira issue view "$ISSUE_KEY" >/dev/null 2>&1; then
  echo "Error: Jira issue $ISSUE_KEY not found"
  echo "Please verify the issue key and try again"
  exit 1
fi
```

### No Jira Access

```bash
if ! command -v jira >/dev/null 2>&1; then
  echo "Warning: jira-cli not found"
  echo "Install from: https://github.com/ankitpokhrel/jira-cli"
  echo ""
  echo "Proceeding with issue key: $ISSUE_KEY"
  echo "You'll need to provide issue details manually"
fi
```

## Smart Commits (Jira + GitHub)

Jira can process commit messages to update issues:

```
PROJ-123#comment Fixed the login bug
PROJ-123#time 2h
PROJ-123#resolve
```

## Jira Status Mappings

| Jira Status | Action | Git Commit |
|-------------|--------|------------|
| To Do | Start work | `PROJ-123#start` |
| In Progress | Working | - |
| In Review | PR created | Automatic via GitHub integration |
| Done | Fixed | `Fixes PROJ-123` in commit |

## Configuration Files

### jira-cli Config

Located at `~/.config/jira-cli/config.yml`:

```yaml
server: https://your-domain.atlassian.net
login: your-email@example.com
project: PROJ
editor: vim
```

### Environment Variables

```bash
# Jira instance
export JIRA_INSTANCE="https://your-domain.atlassian.net"

# API token (for REST API fallback)
export JIRA_API_TOKEN="your-api-token"

# Default project
export JIRA_PROJECT="PROJ"
```

## References

- [jira-cli Documentation](https://github.com/ankitpokhrel/jira-cli)
- [Atlassian API Documentation](https://developer.atlassian.com/cloud/jira/platform/rest/v3/)
- [Atlassian Remote MCP Server](https://www.atlassian.com/blog/announcements/remote-mcp-server)
