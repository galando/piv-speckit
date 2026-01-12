# Git Workflow Rules

**Best practices for Git version control**

---

## Branching Strategy

### Feature Branch Workflow
```bash
main          ← Production-ready code
  ├── feature/← New features
  ├── fix/    ← Bug fixes
  └── docs/   ← Documentation changes
```

### Branch Naming
- `feature/feature-name` - New features
- `fix/bug-description` - Bug fixes
- `hotfix/critical-fix` - Urgent production fixes
- `docs/update-description` - Documentation changes
- `refactor/component-name` - Refactoring

### Branch Rules
- **NEVER** commit directly to main (except for updates that don't require a feature branch)
- **CREATE** a new branch for each feature/fix
- **KEEP** branches focused on single task
- **DELETE** branches after merging

---

## Commit Messages

### Conventional Commits Format
```
type(scope): description

[optional body]

[optional footer]
```

### Types
| Type | When to Use | Example |
|------|-------------|---------|
| `feat` | New feature | `feat(auth): add JWT authentication` |
| `fix` | Bug fix | `fix(api): resolve race condition in user creation` |
| `docs` | Documentation | `docs(readme): update installation instructions` |
| `style` | Code style (formatting, semicolons) | `style(frontend): format with Prettier` |
| `refactor` | Refactoring | `refactor(service): extract validation logic` |
| `test` | Adding or updating tests | `test(api): add integration tests for users` |
| `chore` | Maintenance tasks | `chore(deps): update dependencies` |
| `perf` | Performance improvements | `perf(query): optimize database query` |

### Good Commit Messages
✅ **Good**:
```
feat(auth): add JWT token refresh mechanism

- Implement refresh token endpoint
- Add token rotation for security
- Update authentication middleware
- Include unit tests

Closes #123
```

✅ **Good**:
```
fix(database): resolve connection pool exhaustion

- Increase max connections in pool
- Add connection timeout handling
- Implement connection retry logic

Fixes #456
```

❌ **Bad**:
```
update stuff
fix bug
changes
wip
```

### Commit Message Guidelines
- **USE** imperative mood ("add" not "added" or "adds")
- **LIMIT** subject line to 50 characters
- **SEPARATE** body from subject with blank line
- **WRAP** body at 72 characters
- **EXPLAIN** what and why, not how
- **REFERENCE** issues in footer (Closes #123, Fixes #456)

---

## Committing Practices

### Atomic Commits
**DO**:
- ✅ Make small, focused commits
- ✅ Each commit should be buildable
- ✅ Commit related changes together
- ✅ Write meaningful messages

**DON'T**:
- ❌ Make giant commits with unrelated changes
- ❌ Commit broken code
- ❌ Mix refactoring with feature changes
- ❌ Leave TODOs in committed code

### Commit Frequency
- **COMMIT** frequently (small chunks)
- **COMMIT** after completing logical unit of work
- **COMMIT** after tests pass
- **DON'T** commit unfinished work (use WIP commits if needed)

### Before Committing
1. **CHECK** what you're committing: `git status` / `git diff`
2. **ENSURE** tests pass: Run test suite
3. **VERIFY** build succeeds: Run build command
4. **REVIEW** your changes: Check for unintended modifications
5. **WRITE** clear message: Follow conventional commits

---

## Pull Requests

### PR Description Template
```markdown
## Summary
[Brief description of changes]

## Changes
- [ ] Change 1
- [ ] Change 2
- [ ] Change 3

## Testing
- [ ] Unit tests added/updated
- [ ] Integration tests added/updated
- [ ] Manual testing completed

## Checklist
- [ ] Tests pass
- [ ] Code follows style guidelines
- [ ] Documentation updated
- [ ] No merge conflicts
- [ ] Ready for review

## Related Issues
Closes #123
```

### PR Guidelines
- **KEEP** PRs focused and small
- **INCLUDE** tests for new functionality
- **UPDATE** documentation as needed
- **RESPOND** to review feedback
- **REBASE** rather than merge commits

### PR Review Process
1. **SELF-REVIEW** before requesting review
2. **ADD** descriptive PR title and description
3. **LINK** related issues
4. **REQUEST** review from relevant team members
5. **ADDRESS** all review feedback

---

## Git Workflow Best Practices

### Pull Before Push
```bash
# Always pull latest changes before pushing
git pull origin main --rebase
# or
git fetch origin
git rebase origin/main
```

### Resolve Conflicts
1. **IDENTIFY** conflicting files
2. **UNDERSTAND** both sides of conflict
3. **COMMUNICATE** with conflicting author if needed
4. **RESOLVE** conflicts carefully
5. **TEST** after resolution
6. **COMMIT** resolution

### Undo Changes
```bash
# Unstage file
git restore --staged <file>

# Discard changes to file
git restore <file>

# Undo last commit (keep changes)
git reset --soft HEAD~1

# Undo last commit (discard changes)
git reset --hard HEAD~1
```

### Clean History
```bash
# Interactive rebase to clean up commits
git rebase -i HEAD~n

# Squash commits
# Use "squash" or "fixup" in interactive rebase
```

---

## Git Safety

### Dangerous Commands - Use with Caution
⚠️ **NEVER** force push to shared branches:
```bash
# DANGEROUS
git push --force origin main

# SAFER alternative
git push --force-with-lease origin main
```

⚠️ **NEVER** hard reset without being sure:
```bash
# DANGEROUS - discards all uncommitted changes
git reset --hard HEAD

# First check what you'll lose
git status
git diff
```

⚠️ **ALWAYS** check before destructive operations:
```bash
# Check what will be deleted
git branch -d <branch>  # safe merge check
git branch -D <branch>  # force delete

# Check what will be changed
git diff
git status
```

### Protecting Important Branches
- **USE** branch protection rules on GitHub/GitLab
- **REQUIRE** PR reviews for main
- **REQUIRE** status checks to pass
- **RESTRICT** who can push to main

---

## Git Hygiene

### .gitignore Best Practices
```
# Dependencies
node_modules/
vendor/
__pycache__/

# Build artifacts
dist/
build/
target/
*.pyc

# Environment files
.env
.env.local

# IDE files
.idea/
.vscode/
*.swp

# OS files
.DS_Store
Thumbs.db

# Logs
*.log
npm-debug.log*

# Database
*.db
*.sqlite
```

### Sensitive Data
- **NEVER** commit:
  - API keys
  - Passwords
  - Certificates
  - Private keys
  - User data

- **USE** environment variables for sensitive config
- **COMMIT** example `.env.example` file instead

---

## Workflow Summary

### Standard Feature Workflow
```bash
# 1. Start from clean main
git checkout main
git pull origin main

# 2. Create feature branch
git checkout -b feature/my-feature

# 3. Make changes and commit
git add .
git commit -m "feat: add my feature"

# 4. Pull latest changes
git pull origin main --rebase

# 5. Push to remote
git push origin feature/my-feature

# 6. Create PR on GitHub
# 7. After review and merge, delete branch
git checkout main
git pull origin main
git branch -d feature/my-feature
```

### Hotfix Workflow
```bash
# 1. Create hotfix branch from main
git checkout main
git pull origin main
git checkout -b hotfix/critical-fix

# 2. Make fix and commit
git add .
git commit -m "fix: resolve critical production issue"

# 3. Push and create PR
git push origin hotfix/critical-fix

# 4. Merge with expedited review
# 5. Tag release if needed
git tag -a v1.0.1 -m "Hotfix: critical issue"
git push origin v1.0.1
```

---

## Summary

Good Git practices:

1. **BRANCH** for every feature/fix
2. **COMMIT** frequently with clear messages
3. **PULL** before pushing
4. **REVIEW** all PRs carefully
5. **PROTECT** main branch
6. **NEVER** commit sensitive data
7. **KEEP** history clean

**Follow these rules to maintain a clean, understandable Git history.**
