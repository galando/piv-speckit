# Git Workflow Rules

## Branching

- **NEVER** commit directly to main
- **CREATE** feature branch for each change
- **DELETE** branch after merging
- **ALL** merges to main require approval

## Branch Naming

- `feature/feature-name` - New features
- `fix/bug-description` - Bug fixes
- `hotfix/critical-fix` - Urgent production fixes
- `docs/update-description` - Documentation changes

## Commit Messages (Conventional Commits)

```
type(scope): description

[optional body]

[optional footer]
```

**Types:** feat, fix, docs, style, refactor, test, chore, perf

**Examples:**
- `feat(auth): add JWT authentication`
- `fix(api): resolve race condition in user creation`
- `docs(readme): update installation instructions`

## Committing Practices

- ✅ Small, focused commits
- ✅ Conventional commit format
- ✅ Write meaningful messages
- ❌ No giant commits
- ❌ No broken code
- ❌ No "wip" commits

**For full guide with examples:** `Read .claude/reference/rules-full/git-full.md`
