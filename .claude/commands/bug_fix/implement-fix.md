---
description: Implement fix from Root Cause Analysis
argument-hint: "<path-to-rca-document>"
---

# Implement Fix: Execute RCA Solution

## RCA Document

Read RCA document: `$ARGUMENTS`

**Example:** `.claude/agents/reviews/rca-123-bug-title.md`

## Purpose

Implement a bug fix based on a comprehensive Root Cause Analysis.

**Process:** Use systematic approach for bug fixing

## Implementation Process

### 1. Read and Understand RCA

**Read the entire RCA document:**
- Understand the issue
- Understand the root cause
- Review the fix strategy
- Note the testing strategy
- Note the acceptance criteria

**Clarify Ambiguities:**
- If RCA is unclear, ask questions
- Get specific implementation details
- Resolve approach decisions

### 2. Verify Feature Branch

**CRITICAL: You MUST be on a feature branch for bug fixes!**

Check current branch:
```bash
git branch --show-current
```

**If on `main` branch:**
1. **STOP** - Do not implement fixes on main!
2. Ask user: "Should I create a feature branch for this bug fix?"
3. If approved, create branch:
   ```bash
   git checkout -b fix/issue-{number}-{brief-description}
   ```
4. Then proceed with implementation

**If on feature branch:**
- ✅ Continue with implementation
- Verify branch name follows convention: `fix/issue-{number}-{description}`

**Rationale:**
- Protects main branch from untested fixes
- Allows for review before merging
- Facilitates rollback if fix introduces issues
- Enables testing in isolation

### 3. Create Mini-Plan

**Unlike feature development, bug fixes are simpler. Create a mini-plan:**

```markdown
# Fix Plan: Issue #{number}

## Root Cause
[From RCA]

## Fix Strategy
[From RCA]

## Files to Modify
- `path/to/file1.java` - [What to change]
- `path/to/file2.java` - [What to change]

## Implementation Steps
1. Step 1: [Description]
2. Step 2: [Description]
3. Step 3: [Description]

## Testing Strategy
[From RCA]

## Validation
[From RCA]
```

**Save to:** `.claude/agents/plans/fix-issue-{number}.md`

### 4. Read Context

**Read necessary context:**
- Read files to be modified
- Understand current implementation
- Identify patterns to follow
- Note related code that might be affected

**Check project standards:**
- Read `.claude/rules/backend/` (if backend fix)
- Read `.claude/rules/20-testing.md` (for tests)
- Read relevant reference docs from `technologies/*/reference/`

### 5. Implement the Fix

**Follow the mini-plan:**

**Step 1: Fix the root cause**
- Locate the buggy code
- Apply the fix
- Follow project patterns
- Add comments if logic is complex

**Step 2: Add tests**
- Create unit tests for the fix
- Create integration tests if needed
- Test edge cases
- Test regression scenarios

**Step 3: Verify**
- Run tests
- Check for side effects
- Ensure no regressions

**Step 4: Update documentation** (if needed)
- Update code comments
- Update README/docs if behavior changed
- Add pattern to reference docs (if new pattern)

### 6. Validate

**Run appropriate validation commands for your technology stack:**

**For Spring Boot backend:**
```bash
# Compilation
mvn clean compile

# Unit tests
mvn test

# Integration tests
mvn verify -DskipUnitTests=true

# Coverage
mvn jacoco:report
```

**For React frontend:**
```bash
# Build
npm run build

# Tests
npm test
```

**All validations must pass!**

### 7. Manual Testing

**Test the fix:**
1. Start development environment
2. Reproduce the original issue (should still be broken before fix)
3. Apply the fix
4. Reproduce the issue again (should be fixed now)
5. Test edge cases
6. Test related functionality (no regressions)

**Document testing results:**
- [ ] Original issue fixed
- [ ] Edge cases tested
- [ ] No regressions
- [ ] Ready for commit

### 8. Code Review

**Run code review:**
```
/piv-speckit:code-review
```

**Fix any issues found:**
```
/piv-speckit:code-review-fix <review-report>
```

### 9. Create Execution Report

**Generate report:**
```
/piv-speckit:execution-report <plan-path>
```

**Include in report:**
- What was fixed
- Files modified
- Tests added
- Validation results
- Time tracking

## Output Report

Provide summary:

### Issue Fixed

**Issue:** #{number} - [Title]
**Root Cause:** [From RCA]
**Fix Applied:** [Description]

### Files Modified

- `path/to/file1.java` - [What changed]
- `path/to/file2.java` - [What changed]

### Tests Added

- `TestFile1.java` - X test cases
- `TestFile2.java` - X test cases

**Total:** X test cases added

### Validation Results

- ✅ Compilation: PASS
- ✅ Unit tests: PASS (X tests)
- ✅ Integration tests: PASS (X tests)
- ✅ Coverage: XX% (>= 80%)
- ✅ Frontend: PASS (if applicable)

**Overall:** ✅ ALL PASS

### Manual Testing

**Reproduction:** [Yes/No]
- Original issue reproduced: [Yes/No]
- Issue fixed after changes: [Yes/No]
- Edge cases tested: [List]
- Related functionality tested: [List]
- Regressions found: [None/List]

### Standards Compliance

- ✅ Follows technology patterns
- ✅ Proper error handling
- ✅ Appropriate testing
- ✅ Code quality standards

### Ready for Commit

**Status:** ✅ READY

**IMPORTANT: Commit Workflow for Bug Fixes**

You are currently on a **feature branch** for this bug fix. Follow this workflow:

**Step 1: Commit your changes**
```bash
/commit
```
This will create a commit with all your changes on the feature branch.

**Step 2: Push to remote**
```bash
git push -u origin fix/issue-{number}-{description}
```

**Step 3: Create Pull Request**
```bash
gh pr create --title "Fix: Issue #{number} - {brief description}" --body "Fixes #{number}"
```

**Step 4: Merge to main (ONLY after review and approval)**
- ✅ Pull request must be reviewed
- ✅ All tests must pass
- ✅ Get explicit approval from maintainer
- Then merge to main

**CRITICAL REMINDERS:**
- ❌ **NEVER** commit directly to main without approval
- ❌ **NEVER** push bug fixes directly to main
- ✅ **ALWAYS** use feature branches for bug fixes
- ✅ **ALWAYS** create PR for review before merging

**Commit Message Template (for /commit command):**
```bash
fix: [Short description of fix]

Fixes #{number}

[Detailed description of the fix]

Root cause:
[From RCA]

Changes:
- [Change 1]
- [Change 2]

Tests:
- [Test 1]
- [Test 2]

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude Sonnet 4.5 <noreply@anthropic.com>
```

## Prevention Measures

**Implement prevention from RCA:**
- [ ] Add test: [Which test]
- [ ] Update docs: [What]
- [ ] Add to code review checklist: [What]
- [ ] Share with team: [How]

## Update RCA

**Mark RCA as complete:**
- Status: Fixed
- PR: [Link to PR]
- Commit: [Commit hash]
- Deployment Date: [When deployed]

---

**Remember:** Bug fixes should follow the same quality standards as new features. Test thoroughly, validate completely, and document well.
