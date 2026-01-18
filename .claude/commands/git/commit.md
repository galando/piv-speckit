---
description: Create atomic commit with conventional commits (delegates to official commit-commands plugin)
argument-hint: "[commit message]"
---

# Commit: Create Git Commit

**This command delegates to the official Anthropic `commit-commands` plugin.**

## Usage

### Quick Commit (Auto-Generated Message)

```bash
/commit
```

The plugin will:
- Stage all changes (`git add .`)
- Generate conventional commit message from changes
- Create commit with proper attribution
- Include co-author tag for Claude Code

### Commit with Custom Message

```bash
/commit feat(auth): add JWT token refresh
```

Creates commit with your specified message.

### Commit with Body

```bash
/commit fix(api): resolve race condition

- Add mutex lock to shared resource
- Update error handling
- Add unit tests

Fixes #123
```

Creates commit with detailed body.

## Commit Message Format

The plugin enforces **Conventional Commits** format:

```
type(scope): description

[optional body]

[optional footer]
```

### Types

| Type | When to Use | Example |
|------|-------------|---------|
| `feat` | New feature | `feat(auth): add JWT authentication` |
| `fix` | Bug fix | `fix(api): resolve race condition` |
| `docs` | Documentation | `docs(readme): update installation` |
| `style` | Code style (formatting) | `style(frontend): format with Prettier` |
| `refactor` | Refactoring | `refactor(service): extract validation` |
| `test` | Adding/updating tests | `test(api): add integration tests` |
| `chore` | Maintenance | `chore(deps): update dependencies` |
| `perf` | Performance | `perf(query): optimize database query` |

### Good Examples

✅ **Simple:**
```
feat(user): add email validation
```

✅ **With scope and body:**
```
fix(auth): resolve token expiration issue

- Add refresh token rotation
- Update token validation logic
- Add unit tests for edge cases

Fixes #456
```

✅ **Multi-line:**
```
feat(api): implement user search endpoint

- Add GET /api/users?search=query endpoint
- Implement case-insensitive search
- Add pagination support
- Include integration tests

Closes #789
```

### Bad Examples

❌ **Too vague:**
```
update stuff
fix bug
changes
```

❌ **Wrong format:**
```
Updated user service
Fixed the bug with tokens
Added new features
```

## What the Plugin Does

The `commit-commands` plugin automatically:

1. **Stages Changes**
   - Runs `git add .` to stage all changes
   - Includes new, modified, and deleted files

2. **Generates Commit Message** (if not provided)
   - Analyzes changes with git diff
   - Determines commit type (feat/fix/docs/etc.)
   - Writes descriptive message
   - Follows conventional commits format

3. **Creates Commit**
   - Creates atomic commit with all staged changes
   - Includes co-author attribution for Claude Code
   - Follows git best practices

4. **Provides Feedback**
   - Shows commit message
   - Lists files committed
   - Shows commit hash

## Phase-Based Commits (PIV Methodology)

In PIV methodology, commits happen **after each major phase**:

```
1. Plan Phase → /commit "plan: [feature]"
2. Implement Phase → /commit "feat: [feature]"
3. Validate Phase → /commit "chore: validation fixes" (if needed)
```

**Key Points:**
- ✅ Commits include BOTH code and tests (TDD verified)
- ✅ Tests written FIRST, then implementation (RED-GREEN-REFACTOR)
- ✅ One commit per phase (not per task)
- ✅ Ask user before committing (never automatic)

## When to Use

### After Implementation Complete

**Prerequisites:**
- ✅ All code changes complete
- ✅ All tests passing
- ✅ Validation checks passing
- ✅ On feature branch (not main)

**Then:**
```bash
/commit
```

### After Validation Fixes

If validation found issues and you fixed them:

```bash
/commit chore: fix validation issues

- Fix TDD compliance violations
- Add missing tests
- Update code coverage

Fixes validation failures
```

## Git Workflow

### Standard Feature Workflow

```bash
# 1. Create feature branch
git checkout -b feature/my-feature

# 2. Make changes and test
# ... write code (following TDD) ...
# ... run tests ...

# 3. Commit changes
/commit

# 4. Push to remote
git push -u origin feature/my-feature

# 5. Create pull request
gh pr create --title "Feature: my feature" --body "Summary"
```

### After Pull Request Review

If review requires changes:

```bash
# 1. Make requested changes
# ... update code ...

# 2. Commit amendments
/commit fix: address PR feedback

- Update API endpoint per review
- Add missing error handling
- Improve test coverage

Addresses comments in PR #123

# 3. Push to feature branch
git push

# 4. PR updates automatically
```

## Attribution

All commits include co-authorship:

```
Co-Authored-By: Claude Sonnet 4.5 <noreply@anthropic.com>
```

This gives proper credit to AI-assisted development.

## Safety Features

The plugin includes safety checks:

- **Branch Protection**: Warns if committing to main (should use feature branches)
- **Empty Commit**: Warns if no changes to commit
- **Merge Conflicts**: Detects and reports merge conflicts
- **Large Commits**: Warns if commit is too large (>100 files)

## Troubleshooting

### "Nothing to commit"

**Problem:** No changes staged or all changes committed.

**Solution:**
```bash
# Check status
git status

# If there are uncommitted changes, stage them
git add .

# Try again
/commit
```

### "Failed to create commit"

**Problem:** Git hook failed or merge conflict.

**Solution:**
```bash
# Check for merge conflicts
git status

# Resolve conflicts if any
# ...

# Try again
/commit
```

### Commit Message Wrong

**Problem:** Auto-generated message doesn't match changes.

**Solution:**
```bash
# Amend with correct message
git commit --amend -m "correct(message): better description"

# Or use custom message next time
/commit "correct(message): better description"
```

## Best Practices

### DO ✅

- ✅ Commit frequently (small, focused commits)
- ✅ Commit after tests pass
- ✅ Follow conventional commits format
- ✅ Write clear, descriptive messages
- ✅ Include issue references in footer
- ✅ Use feature branches (not main)

### DON'T ❌

- ❌ Commit broken code
- ❌ Commit failing tests
- ❌ Commit directly to main
- ❌ Write vague commit messages
- ❌ Commit huge changes all at once
- ❌ Skip tests before committing

## Examples

### Feature Commit

```bash
/commit feat(auth): add JWT token refresh mechanism

- Implement refresh token endpoint
- Add token rotation for security
- Update authentication middleware
- Include unit tests for all scenarios

Closes #123
```

### Bug Fix Commit

```bash
/commit fix(database): resolve connection pool exhaustion

- Increase max connections in pool
- Add connection timeout handling
- Implement connection retry logic
- Add integration test for concurrent connections

Fixes #456
```

### Documentation Commit

```bash
/commit docs(readme): update installation instructions

- Add prerequisites section
- Update setup steps for macOS
- Fix broken links
- Add troubleshooting section
```

### Refactoring Commit

```bash
/commit refactor(service): extract validation logic

- Extract validation to separate service
- Add reusable validation components
- Update all callers to use new service
- Include unit tests for validation service
```

## See Also

- [Conventional Commits Specification](https://www.conventionalcommits.org/)
- `.claude/rules/10-git.md` - Git workflow rules
- `.claude/reference/methodology/PIV-METHODOLOGY.md` - Phase-based commit workflow
- `docs/features/commit-commands-integration.md` - Integration guide

## Summary

**The `/commit` command provides:**

1. **Easy commits** - Single command to stage and commit
2. **Smart messages** - Auto-generates conventional commits
3. **Proper attribution** - Includes co-author tags
4. **Safety checks** - Validates before committing
5. **PIV integration** - Supports phase-based workflow

**Remember:** Commit frequently, write clear messages, and always commit on feature branches.
