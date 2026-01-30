# Issue Tracker Formatter

Standardized formatting for branch names, commit messages, and file paths across GitHub and Jira.

## Branch Naming

### GitHub Format

```
fix/issue-{number}-{description}
```

**Examples:**
- `fix/issue-123-login-fail`
- `fix/issue-456-memory-leak`
- `fix/issue-789-api-timeout`

**Rules:**
- Prefix: `fix/issue-`
- Issue number: numeric GitHub issue ID
- Description: kebab-case, brief (max 50 chars total recommended)

### Jira Format

```
fix/{JIRA_KEY}-{description}
```

**Examples:**
- `fix/PROJ-123-login-fail`
- `fix/ABC-456-memory-leak`
- `fix/DEMO-789-api-timeout`

**Rules:**
- Prefix: `fix/`
- Issue key: Full Jira key (PROJECT-NUMBER)
- Description: kebab-case, brief

### Description Formatting

Convert to kebab-case:
1. Lowercase all letters
2. Replace spaces with hyphens
3. Remove special characters
4. Truncate to ~30 chars

```bash
# Example conversion
echo "Login fails when password has special chars!" | \
  tr '[:upper:]' '[:lower:]' | \
  sed 's/[^a-z0-9]+/-/g' | \
  sed 's/-$//' | \
  cut -c1-30
# Output: login-fails-when-password-has
```

## Commit Messages

### GitHub Commit Footer

```
Fixes #{number}
```

**Variants:**
- `Fixes #123` - Standard
- `Closes #456` - Alternative
- `Resolves #789` - Alternative

**Full commit example:**
```
fix(auth): resolve token expiration issue

- Add refresh token rotation
- Update token validation logic
- Add unit tests for edge cases

Fixes #123
```

### Jira Commit Footer

```
Fixes {JIRA_KEY}
```

**Variants:**
- `Fixes PROJ-123` - Standard
- `Closes ABC-456` - Alternative
- `Resolves DEMO-789` - Alternative

**Full commit example:**
```
fix(auth): resolve token expiration issue

- Add refresh token rotation
- Update token validation logic
- Add unit tests for edge cases

Fixes PROJ-123
```

### Direct Bug Report (No Tracker)

For `direct:` inputs, no issue reference in footer:

```
fix: resolve token expiration issue

- Add refresh token rotation
- Update token validation logic
- Add unit tests for edge cases
```

## Pull Request Titles

### GitHub PR Format

```
Fix: Issue #{number} - {brief description}
```

**Examples:**
- `Fix: Issue #123 - Login fails for special characters`
- `Fix: Issue #456 - Memory leak in data processor`
- `Fix: Issue #789 - API timeout handling`

### Jira PR Format

When using Jira with GitHub:

```
Fix: {JIRA_KEY} - {brief description}
```

**Examples:**
- `Fix: PROJ-123 - Login fails for special characters`
- `Fix: ABC-456 - Memory leak in data processor`
- `Fix: DEMO-789 - API timeout handling`

## Pull Request Bodies

### Template (Universal)

```markdown
Fixes {ISSUE_REF}

## Summary
{Brief description of what was fixed and why}

## Root Cause
{From RCA - what caused the bug}

## Changes
- {Change 1}
- {Change 2}
- {Change 3}

## Testing
- {Test case 1}
- {Test case 2}

## Checklist
- [ ] Tests pass locally
- [ ] No regressions found
- [ ] Documentation updated (if needed)
```

**Where `{ISSUE_REF}` is:**
- GitHub: `#123`
- Jira: `PROJ-123`

## RCA Document Paths

### GitHub Format

```
.claude/agents/reviews/rca-{issue-number}-{title}.md
```

**Example:** `.claude/agents/reviews/rca-123-login-fails.md`

### Jira Format

```
.claude/agents/reviews/rca-{JIRA_KEY}-{title}.md
```

**Example:** `.claude/agents/reviews/rca-PROJ-123-login-fails.md`

### Direct Bug Report Format

```
.claude/agents/reviews/rca-{timestamp}-{title}.md
```

**Example:** `.claude/agents/reviews/rca-20250126-143052-login-fails.md`

## Plan Document Paths

### GitHub-Linked Plan

```
.claude/specs/gh-{issue-number}-{feature-name}/
```

### Jira-Linked Plan

```
.claude/specs/{JIRA_KEY}-{feature-name}/
```

### Standalone Plan

```
.claude/specs/{xxx-feature-name}/
```

## Format Detection Quick Reference

| Input Pattern | Tracker | Branch Format | Commit Footer |
|---------------|---------|---------------|---------------|
| `123` | GitHub | `fix/issue-123-desc` | `Fixes #123` |
| `#456` | GitHub | `fix/issue-456-desc` | `Fixes #456` |
| `PROJ-123` | Jira | `fix/PROJ-123-desc` | `Fixes PROJ-123` |
| `direct:...` | Direct | `fix/desc` | (none) |

## Unified Formatter Function

When implementing in commands, use this logic:

```bash
# Input: $TRACKER_TYPE, $ISSUE_KEY, $DESCRIPTION

# Format branch name
if [ "$TRACKER_TYPE" = "github" ]; then
  BRANCH_NAME="fix/issue-$ISSUE_KEY-$DESCRIPTION"
elif [ "$TRACKER_TYPE" = "jira" ]; then
  BRANCH_NAME="fix/$ISSUE_KEY-$DESCRIPTION"
else
  BRANCH_NAME="fix/$DESCRIPTION"
fi

# Format commit footer
if [ "$TRACKER_TYPE" = "github" ]; then
  COMMIT_FOOTER="Fixes #$ISSUE_KEY"
elif [ "$TRACKER_TYPE" = "jira" ]; then
  COMMIT_FOOTER="Fixes $ISSUE_KEY"
else
  COMMIT_FOOTER=""
fi

# Format PR title
if [ "$TRACKER_TYPE" = "github" ]; then
  PR_TITLE="Fix: Issue #$ISSUE_KEY - $DESCRIPTION"
elif [ "$TRACKER_TYPE" = "jira" ]; then
  PR_TITLE="Fix: $ISSUE_KEY - $DESCRIPTION"
else
  PR_TITLE="Fix: $DESCRIPTION"
fi
```

## Description Sanitization

Always sanitize descriptions for file/branch names:

```bash
# Convert to safe filename/branch name
sanitize_description() {
  echo "$1" | \
    tr '[:upper:]' '[:lower:]' | \
    tr ' ' '-' | \
    sed 's/[^a-z0-9-]//g' | \
    sed 's/-\{2,\}/-/g' | \
    sed 's/^-\|-$//g' | \
    cut -c1-50
}

# Usage
DESCRIPTION=$(sanitize_description "Login fails!!!")
# Output: login-fails
```

## Cross-Tracker Compatibility

When using both GitHub and Jira (e.g., Jira for GitHub):

1. **Use Jira key format** in branch names
2. **Use Jira key** in commit footers
3. **Let Jira's GitHub integration** handle linking
4. **PR title includes both** if needed:
   ```
   Fix: PROJ-123 (gh#456) - Login fails
   ```

## Validation

Validate formatted names before use:

```bash
# Branch name validation
validate_branch_name() {
  local branch="$1"
  if [ -z "$branch" ]; then
    echo "Error: Branch name is empty"
    return 1
  fi
  if [ ${#branch} -gt 100 ]; then
    echo "Warning: Branch name exceeds 100 characters"
  fi
  # Check for valid characters
  if ! echo "$branch" | grep -qE '^[a-z0-9-]+$'; then
    echo "Error: Branch name contains invalid characters"
    return 1
  fi
}
```

## Quick Reference Card

| Context | GitHub | Jira | Direct |
|---------|--------|------|--------|
| **Branch** | `fix/issue-123-desc` | `fix/PROJ-123-desc` | `fix/desc` |
| **Commit** | `Fixes #123` | `Fixes PROJ-123` | (none) |
| **PR Title** | `Fix: Issue #123 - desc` | `Fix: PROJ-123 - desc` | `Fix: desc` |
| **RCA Path** | `rca-123-title.md` | `rca-PROJ-123-title.md` | `rca-TS-title.md` |
