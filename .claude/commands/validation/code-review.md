---
description: Technical code review for quality and bugs that runs pre-commit
---

# Code Review

**Goal:** Comprehensive code review for quality and bugs.

> **Full methodology:** `$CLAUDE_PLUGIN_ROOT/.claude-plugin/reference/execution/code-review.md`

## Prerequisites (MANDATORY)

**⚠️ DO NOT RUN if:**
- ❌ Code does not compile
- ❌ Tests are failing
- ❌ Build is broken

**✅ RUN ONLY AFTER:**
- ✅ Build succeeds
- ✅ All tests pass
- ✅ Validation pipeline passes

## Execution Steps

### Step 1: Gather Context

Read project standards:
```bash
Read .claude/CLAUDE.md
Read .claude/rules/
```

### Step 2: Identify Changed Files

```bash
# Show modified files
git status

# Show changes in detail
git diff HEAD

# Show statistics
git diff --stat HEAD
```

### Step 3: Read Each Changed File Completely

For each changed/new file:
- Read the ENTIRE file (not just diff)
- Understand full context
- Note patterns used
- Identify potential issues

### Step 4: Analyze for Issues

Check for:

**1. Logic Errors**
- Off-by-one errors
- Incorrect conditionals
- Missing error handling
- Race conditions

**2. Security Issues**
- SQL injection vulnerabilities
- XSS vulnerabilities
- Insecure data handling
- Exposed secrets or API keys

**3. Performance Problems**
- N+1 queries
- Inefficient algorithms
- Memory leaks
- Unnecessary computations

**4. Code Quality**
- DRY violations
- Overly complex functions
- Poor naming
- Missing type annotations

**5. Project Standards Compliance**
- Spring Data JDBC (NOT JPA/Hibernate)
- Constructor injection with @RequiredArgsConstructor
- DTOs for API responses
- Structured logging
- Graceful error handling
- Environment-safe configuration

### Step 5: Verify Issues Are Real

Before flagging an issue:
- Run specific tests
- Confirm type errors are legitimate
- Validate security concerns with context
- Check if pattern is intentional

### Step 6: Generate Report

Save review report to: `.claude/agents/code-reviews/{feature-name}-review.md`

**Report Structure:**

```markdown
# Code Review: {Feature Name}

**Date:** {timestamp}
**Branch:** {branch}
**Commit:** {commit-hash}

## Summary

{Overall assessment}

## Issues Found

### Critical Issues

{List critical issues with file, line, description, suggestion}

### High Priority Issues

{List high priority issues}

### Medium/Low Priority Issues

{List medium/low priority issues}

## Positive Findings

{What was done well}

## Standards Compliance

- [ ] Spring Data JDBC used (NOT JPA/Hibernate)
- [ ] Constructor injection with @RequiredArgsConstructor
- [ ] DTOs used for API responses
- [ ] Structured logging with SLF4J
- [ ] Graceful error handling
- [ ] Environment-safe configuration

## Conclusion

**Overall Assessment:** PASS / NEEDS FIXES

**Summary:** {Brief summary}

**Next Steps:**
- If issues found: Run `/piv-speckit:code-review-fix <this-report>`
- If clean: Run `/piv-speckit:validate`
```

## Automatic Next Step

**After generating the review report:**

**If CRITICAL or HIGH priority issues found:**
- Automatically invoke: `/piv-speckit:code-review-fix <report-path>`

**If NO critical/high issues (clean review):**
- Automatically invoke: `/piv-speckit:validate`

**If called manually (not from execute):**
- Show report summary
- Ask user for next action
