# GitHub Issue Operations

Wrapper for GitHub CLI commands used in bug fix workflows.

## Prerequisites

- GitHub CLI (`gh`) installed and authenticated
- `gh auth status` should show valid authentication

## Fetch Issue Details

```bash
gh issue view $ISSUE_NUMBER --json title,body,state,labels,assignee,url,comments
```

### Output Fields

| Field | Description | Usage |
|-------|-------------|-------|
| `title` | Issue title | RCA document heading |
| `body` | Issue description | Context for bug analysis |
| `state` | Open/closed/draft | Determines if issue is active |
| `labels` | Issue labels | Priority/severity hints |
| `assignee` | Assigned user | Contact for context |
| `url` | Issue URL | Reference in RCA |
| `comments` | Discussion | Additional context |

### Example Output

```json
{
  "title": "Login fails when password contains special characters",
  "body": "## Steps to reproduce\r\n1. Go to login page\r\n2. Enter password with !@#$\r\n3. Click login",
  "state": "OPEN",
  "labels": [{"name": "bug"}, {"name": "high-priority"}],
  "assignee": {"login": "username"},
  "url": "https://github.com/owner/repo/issues/123",
  "comments": []
}
```

## Create Pull Request

```bash
gh pr create --title "$PR_TITLE" --body "$PR_BODY"
```

### PR Title Format

```
Fix: Issue #{number} - {brief description}
```

Example: `Fix: Issue #123 - Handle special characters in passwords`

### PR Body Format

```markdown
Fixes #{number}

## Summary
[Brief description of the fix]

## Changes
- [Change 1]
- [Change 2]

## Testing
- [Test 1]
- [Test 2]
```

## List Issues

```bash
gh issue list --state open --limit 20
```

### With Filters

```bash
# By label
gh issue list --label bug --state open

# By assignee
gh issue list --assignee @me

# By milestone
gh issue list --milestone "Sprint 1"
```

## Add Comment to Issue

```bash
gh issue comment $ISSUE_NUMBER --body "Comment text"
```

## Update Issue Status

```bash
# Close issue
gh issue close $ISSUE_NUMBER

# Reopen issue
gh issue reopen $ISSUE_NUMBER
```

## Branch Name Format

```
fix/issue-{number}-{description}
```

Examples:
- `fix/issue-123-login-fail`
- `fix/issue-456-memory-leak`
- `fix/issue-789-api-timeout`

## Commit Footer Format

```
Fixes #{number}
```

Examples:
- `Fixes #123`
- `Closes #456`
- `Resolves #789`

## Issue Reference Patterns

| Pattern | Usage | Example |
|---------|-------|---------|
| `#{number}` | Commit footer | `Fixes #123` |
| `https://github.com/.../issues/{number}` | Full reference | `See https://github.com/owner/repo/issues/123` |
| `owner/repo#{number}` | Cross-repo reference | `Fixes other/repo#456` |

## RCA Output Path Format

```
.claude/agents/reviews/rca-{issue-number}-{title}.md
```

Example: `.claude/agents/reviews/rca-123-login-fails.md`

## Common Workflows

### 1. Fetch Issue for RCA

```bash
# Get issue details
ISSUE_NUMBER=$(echo "$ARGUMENTS" | grep -oE '[0-9]+')
ISSUE_DETAILS=$(gh issue view $ISSUE_NUMBER --json title,body,state,labels,comments)

# Parse fields
ISSUE_TITLE=$(echo "$ISSUE_DETAILS" | jq -r '.title')
ISSUE_BODY=$(echo "$ISSUE_DETAILS" | jq -r '.body')
ISSUE_STATE=$(echo "$ISSUE_DETAILS" | jq -r '.state')
```

### 2. Create PR After Fix

```bash
# Extract issue number from branch name
ISSUE_NUMBER=$(git branch --show-current | grep -oE 'issue-([0-9]+)' | cut -d- -f2)

# Create PR
gh pr create \
  --title "Fix: Issue #$ISSUE_NUMBER - Brief description" \
  --body "Fixes #$ISSUE_NUMBER"
```

### 3. Reference Issue in Commit

```bash
git commit -m "fix: handle special characters in password

- Add proper escaping for special characters
- Update validation regex
- Add unit tests for edge cases

Fixes #123"
```

## Error Handling

### Issue Not Found

```bash
if ! gh issue view $ISSUE_NUMBER >/dev/null 2>&1; then
  echo "Error: Issue #$ISSUE_NUMBER not found"
  echo "Please verify the issue number and try again"
  exit 1
fi
```

### Not Authenticated

```bash
if ! gh auth status >/dev/null 2>&1; then
  echo "Error: GitHub CLI not authenticated"
  echo "Run: gh auth login"
  exit 1
fi
```

## Aliases and Shortcuts

```bash
# View issue (short)
gh i view 123

# List issues (short)
gh i list

# Create PR from current branch
gh pr create --fill
```

## Configuration

GitHub CLI can be configured with:

```bash
# Set default editor
gh config set editor vim

# Set default git protocol
gh config set git_protocol ssh

# Set prompt (skip confirmation prompts)
gh config set prompt disabled
```
