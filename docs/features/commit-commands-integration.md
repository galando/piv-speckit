# Commit Commands Integration

**How PIV methodology integrates with Anthropic's official commit-commands plugin**

---

## Overview

PIV methodology uses Anthropic's official **commit-commands plugin** for all Git commit operations. This provides:

- ✅ **Smart commit messages** - Auto-generates conventional commits from changes
- ✅ **Proper attribution** - Includes co-author tags for AI-assisted development
- ✅ **Safety checks** - Validates before committing (branch protection, empty commits)
- ✅ **Phase-based workflow** - Integrates with PIV's commit-after-phases approach
- ✅ **No custom implementation** - Delegates to official plugin (not custom code)

---

## Quick Start

### Basic Usage

```bash
# Auto-generated commit message
/commit

# Custom commit message
/commit "feat(auth): add JWT authentication"

# Multi-line commit message
/commit "fix(api): resolve race condition

- Add mutex lock to shared resource
- Update error handling
- Add unit tests

Fixes #123"
```

### After Implementation Complete

```bash
# 1. Run validation (automatic in PIV)
/piv-speckit:execute [plan-file]

# 2. Wait for validation to pass
# (Automatic validation runs: compilation, tests, coverage, etc.)

# 3. When validation passes, system asks:
✅ READY TO COMMIT

Ready to commit implementation? (yes/no)

# 4. Say "yes" and create commit
/commit
```

---

## PIV Integration: Phase-Based Commits

### Standard PIV Workflow

PIV methodology uses **phase-based commits** - one commit after each major phase:

```
┌─────────────────────────────────────────────────────────┐
│ 1. PRIME PHASE                                         │
│    ├─ Load context and understanding                   │
│    └─ No commit (context loading only)                 │
├─────────────────────────────────────────────────────────┤
│ 2. PLAN PHASE                                          │
│    ├─ Create implementation plan                       │
│    ├─ Ask: "Ready to commit plan?"                     │
│    └─ /commit "plan: [feature description]"            │
├─────────────────────────────────────────────────────────┤
│ 3. IMPLEMENT PHASE (TDD Enforced)                      │
│    ├─ Execute plan (RED → GREEN → REFACTOR)            │
│    ├─ Validation runs automatically                     │
│    ├─ Ask: "Ready to commit implementation?"           │
│    └─ /commit "feat: [feature description]"            │
├─────────────────────────────────────────────────────────┤
│ 4. VALIDATE PHASE                                      │
│    ├─ Validation already ran after implement           │
│    ├─ If fixes needed:                                 │
│    │  ├─ Fix issues                                    │
│    │  ├─ Ask: "Ready to commit validation fixes?"      │
│    │  └─ /commit "chore: fix validation issues"        │
│    └─ If no fixes: No commit                          │
├─────────────────────────────────────────────────────────┤
│ 5. SIMPLIFY PHASE (Optional)                           │
│    ├─ Refactor and clean up                            │
│    ├─ Validation runs again                            │
│    ├─ Ask: "Ready to commit refactoring?"             │
│    └─ /commit "refactor: [what was simplified]"        │
└─────────────────────────────────────────────────────────┘

Total: 2-4 commits (one per phase with changes)
```

### Why Phase-Based Commits?

**Benefits:**

1. **Right Granularity**
   - Each phase is a logical unit of work
   - Not too granular (not after each task)
   - Not too coarse (not after entire project)

2. **Easy to Revert**
   - Can revert entire phase if needed
   - Clean git history
   - Easy to understand what changed

3. **Clear History**
   - Git history shows PIV phases
   - Easy to track progress
   - Transparent workflow

4. **Tests + Code Together**
   - Implementation commit includes both tests and code
   - TDD verified (tests written FIRST, then implementation)
   - Validation ensures quality

### When to Commit vs. Continue

**Commit after phase:**
- ✅ Plan complete → `/commit "plan: ..."`
- ✅ Implementation complete + validation passing → `/commit "feat: ..."`
- ✅ Validation fixes applied → `/commit "chore: ..."`
- ✅ Refactoring complete + validation passing → `/commit "refactor: ..."`

**Continue without committing:**
- ✅ During implementation (multiple tasks in one phase)
- ✅ During refactoring (multiple cleanups in one phase)
- ✅ While validation is running (wait for results)

---

## TDD and Commits

### Implementation Phase Includes Tests

**Critical:** Implementation phase commits include BOTH tests AND code, written in TDD order:

**Correct TDD Order:**
```
For EACH piece of functionality:

1. 🔴 RED: Write FAILING test
   └─ Run test → Verifies it FAILS

2. 🟢 GREEN: Write MINIMAL code to pass
   └─ Run test → Verifies it PASSES

3. 🔵 REFACTOR: Improve while tests pass
   └─ Run tests → Verify STILL PASS

[Repeat for all functionality in implementation phase]

[After ALL implementation complete + validation passing]
→ /commit "feat: [feature]"
   (includes ALL tests + ALL code + ALL refactoring)
```

**One commit for entire implementation phase** includes:
- All tests written (RED phase)
- All implementation code (GREEN phase)
- All refactoring (REFACTOR phase)
- Validation passing (quality gate)

**Do NOT:**
- ❌ Commit after each test/implementation cycle (too granular)
- ❌ Commit code without tests (violates TDD)
- ❌ Commit tests without code (incomplete)

**DO:**
- ✅ Commit after entire implementation phase complete
- ✅ Include both tests and code in one commit
- ✅ Ensure validation passing before commit
- ✅ Follow RED-GREEN-REFACTOR order within phase

### Commit Messages for TDD

**Good TDD commit message:**
```
feat(user): add user registration endpoint

Tests written first (RED):
- Validate email format
- Check password strength
- Verify user not already registered
- Test successful registration

Implementation (GREEN):
- POST /api/users/register endpoint
- Email validation service
- Password hashing (bcrypt)
- User creation service

Refactoring (REFACTOR):
- Extract validation to separate service
- Add reusable validation components

All tests passing, validation green.

Closes #123
```

This shows:
- Tests were written FIRST
- Implementation came SECOND
- Refactoring came THIRD
- All included in ONE commit (right granularity)

---

## /commit Command Features

### Auto-Generated Messages

The commit-commands plugin analyzes your changes and generates appropriate commit messages:

**Example 1: Feature Addition**
```bash
# Changes: Added new API endpoint
/commit

# Plugin generates:
"feat(api): add user search endpoint

- Add GET /api/users?search=query endpoint
- Implement case-insensitive search
- Add pagination support
- Include integration tests"
```

**Example 2: Bug Fix**
```bash
# Changes: Fixed database connection issue
/commit

# Plugin generates:
"fix(database): resolve connection pool exhaustion

- Increase max connections in pool
- Add connection timeout handling
- Implement connection retry logic"
```

### Custom Messages

**Provide your own message:**

```bash
/commit "feat(auth): add JWT token refresh mechanism"
```

**Multi-line message:**
```bash
/commit "fix(api): resolve race condition

- Add mutex lock to shared resource
- Update error handling
- Add unit tests for edge cases

Fixes #456"
```

### Conventional Commits Format

The plugin enforces **Conventional Commits**:

```
type(scope): description

[optional body]

[optional footer]
```

**Types:**
- `feat` - New feature
- `fix` - Bug fix
- `docs` - Documentation
- `style` - Code style (formatting)
- `refactor` - Refactoring
- `test` - Adding/updating tests
- `chore` - Maintenance
- `perf` - Performance

**Examples:**
```
feat(auth): add JWT token refresh
fix(api): resolve race condition
docs(readme): update installation
refactor(service): extract validation
chore(deps): update dependencies
```

### Safety Features

The plugin includes safety checks:

**Branch Protection:**
```
⚠️ WARNING: You're on main branch

Recommendation: Create feature branch first
  git checkout -b feature/my-feature

Continue anyway? (yes/no)
```

**Empty Commit:**
```
⚠️ WARNING: No changes to commit

Changes staged: 0 files
```

**Merge Conflicts:**
```
❌ ERROR: Merge conflicts detected

Resolve conflicts first:
  git status
  # Fix conflicts...
  git add .

Then try again.
```

---

## Attribution

### Co-Author Tags

All commits include co-authorship for AI-assisted development:

```
feat(auth): add JWT authentication

- Implement JWT token generation
- Add refresh token rotation
- Include authentication middleware

Co-Authored-By: Claude Sonnet 4.5 <noreply@anthropic.com>
```

This:
- Gives proper credit to AI-assisted development
- Follows open source best practices
- Transparent about development process

---

## Examples

### Example 1: New Feature (Complete Workflow)

```bash
# 1. Plan Phase
/piv-speckit:plan-feature "add user authentication"

# Output: Plan created at .claude/agents/plans/user-authentication.md

# Ask: Ready to commit plan?
# Response: yes
/commit "plan: add user authentication feature"

# 2. Implement Phase
/piv-speckit:execute .claude/agents/plans/user-authentication.md

# Implementation follows TDD:
# - Write test (RED)
# - Implement code (GREEN)
# - Refactor (REFACTOR)
# [Repeat for all functionality]

# Validation runs automatically:
# ✅ Compilation: PASS
# ✅ TDD Compliance: PASS
# ✅ Unit Tests: PASS
# ✅ Integration Tests: PASS
# ✅ Coverage: 85% (≥80% required)

# Ask: Ready to commit implementation?
# Response: yes
/commit

# Plugin generates:
"feat(auth): add user authentication

Tests (written first):
- Validate email format
- Check password strength
- Verify user login
- Test JWT token generation

Implementation:
- POST /api/users/register endpoint
- POST /api/auth/login endpoint
- JWT token service
- Password hashing (bcrypt)

Refactoring:
- Extract validation to separate service
- Add reusable auth components

Co-Authored-By: Claude Sonnet 4.5 <noreply@anthropic.com>"
```

### Example 2: Bug Fix

```bash
# 1. Report Bug
User: "Login fails when email has uppercase letters"

# 2. Root Cause Analysis
/piv-speckit:rca

# Output: RCA report at .claude/agents/reviews/rca-login-bug.md

# 3. Implement Fix
/piv-speckit:execute .claude/agents/plans/fix-login-email-case.md

# Implementation follows TDD:
# - Write test for uppercase email (RED)
# - Implement email normalization (GREEN)
# - Refactor (REFACTOR)

# Validation runs automatically:
# ✅ All tests passing
# ✅ Bug fixed

# Ask: Ready to commit implementation?
# Response: yes
/commit

# Plugin generates:
"fix(auth): normalize email to lowercase during login

Tests:
- Verify uppercase email login works
- Test mixed case email handling
- Verify email uniqueness check case-insensitive

Implementation:
- Normalize email to lowercase on login
- Update email validation to be case-insensitive
- Add integration tests

Fixes login issue with uppercase emails.

Fixes #789"
```

### Example 3: Refactoring

```bash
# 1. Plan Refactoring
/piv-speckit:plan-feature "extract validation logic to separate service"

# 2. Implement Refactoring
/piv-speckit:execute [plan-file]

# Refactoring follows TDD:
# - Write tests for new validation service (RED)
# - Extract validation logic (GREEN)
# - Refactor callers to use new service (REFACTOR)

# Validation runs automatically:
# ✅ All tests still passing (no behavior change)
# ✅ Code simplified

# Ask: Ready to commit refactoring?
# Response: yes
/commit

# Plugin generates:
"refactor(api): extract validation logic to separate service

Tests:
- Add tests for ValidationService
- Verify validation rules work correctly
- Test all callers use new service

Refactoring:
- Extract validation to ValidationService
- Update all controllers to use ValidationService
- Remove duplicate validation code

No behavior changes, all tests passing.

Co-Authored-By: Claude Sonnet 4.5 <noreply@anthropic.com>"
```

### Example 4: Documentation

```bash
# 1. Update Documentation
# Edit README.md, CONTRIBUTING.md, etc.

# 2. Commit Documentation
/commit "docs(readme): update installation instructions

- Add prerequisites section
- Update setup steps for macOS
- Fix broken links
- Add troubleshooting section"
```

---

## Best Practices

### DO ✅

1. **Commit After Each PIV Phase**
   - Plan → `/commit "plan: ..."`
   - Implement → `/commit "feat: ..."`
   - Validate fixes → `/commit "chore: ..."`
   - Refactor → `/commit "refactor: ..."`

2. **Follow TDD Within Implementation Phase**
   - Tests written FIRST (RED)
   - Implementation SECOND (GREEN)
   - Refactoring THIRD (REFACTOR)
   - One commit includes ALL of it

3. **Write Clear Commit Messages**
   - Follow conventional commits format
   - Include what changed and why
   - Reference issues in footer

4. **Let Plugin Generate Messages**
   - Plugin analyzes changes intelligently
   - Override only when plugin message unclear
   - Provide specific message when needed

5. **Review Before Committing**
   - Check what's being committed: `git status`
   - Ensure tests passing
   - Ensure validation passing

### DON'T ❌

1. **Don't Commit Directly to Main**
   - Always use feature branches
   - Create pull requests for review
   - Get approval before merging

2. **Don't Commit Broken Code**
   - Ensure all tests passing
   - Ensure validation passing
   - Fix issues before committing

3. **Don't Commit Too Frequently**
   - Not after each task (too granular)
   - Not after each test/implementation cycle
   - Commit after PHASE (right granularity)

4. **Don't Commit Too Infrequently**
   - Not after entire project (too coarse)
   - Not after multiple features
   - Commit after each PHASE

5. **Don't Skip TDD**
   - Never commit code without tests
   - Never commit tests written after code
   - Always follow RED-GREEN-REFACTOR

---

## Troubleshooting

### Problem: Plugin Generates Wrong Message

**Issue:** Auto-generated message doesn't match changes.

**Solution:**
```bash
# Provide custom message
/commit "correct(message): better description"
```

### Problem: Commit Hook Failed

**Issue:** Pre-commit hook failed (linting, formatting, etc.).

**Solution:**
```bash
# Check hook output
git status

# Fix issues (e.g., run formatter)
npm run format

# Try again
/commit
```

### Problem: Wrong Branch

**Issue:** Accidentally committing to main instead of feature branch.

**Solution:**
```bash
# 1. Reset commit (keep changes)
git reset --soft HEAD~1

# 2. Create feature branch
git checkout -b feature/my-feature

# 3. Commit on feature branch
/commit
```

### Problem: Need to Amend Commit

**Issue:** Forgot to include file in commit.

**Solution:**
```bash
# 1. Add missing file
git add forgotten-file.txt

# 2. Amend commit
git commit --amend --no-edit

# 3. Force push (if already pushed)
git push --force-with-lease
```

---

## See Also

### Internal Documentation
- `.claude/commands/git/commit.md` - Commit command usage
- `.claude/PIV-METHODOLOGY.md` - PIV methodology workflow
- `.claude/rules/10-git.md` - Git workflow rules
- `docs/features/skills-system.md` - Skills system documentation
- `docs/features/strict-tdd.md` - Strict TDD enforcement

### External Resources
- [Conventional Commits Specification](https://www.conventionalcommits.org/)
- [Commit Commands Plugin](https://github.com/anthropics/commit-commands)

---

## Summary

**Commit commands integration provides:**

1. **Official Plugin** - Uses Anthropic's commit-commands plugin (not custom code)
2. **Smart Messages** - Auto-generates conventional commits from changes
3. **Phase-Based Workflow** - Integrates with PIV's commit-after-phases approach
4. **TDD Integration** - Implementation commits include tests + code (TDD verified)
5. **Safety Checks** - Validates before committing (branch protection, etc.)
6. **Proper Attribution** - Includes co-author tags for AI-assisted development

**Key Points:**
- ✅ Commit AFTER each PIV phase (not after each task)
- ✅ Implementation commit includes BOTH tests AND code
- ✅ Follow RED-GREEN-REFACTOR within implementation phase
- ✅ Always ask user before committing (never automatic)
- ✅ Use feature branches (never commit to main directly)

**Remember:** Right granularity = one commit per phase, with tests and code together, TDD verified.
