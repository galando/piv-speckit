---
description: Fix issues found in code review
argument-hint: "<path-to-code-review-report>"
---

# Code Review Fix: Implement Review Recommendations

## Code Review Report

Read code review report: `$ARGUMENTS`

**Example:** `.claude/agents/reviews/code-review-{timestamp}.md`

## Process

### 1. Read and Understand Review

**Read the code review report completely:**

- Identify all issues found
- Understand severity levels (critical, high, medium, low)
- Review suggested fixes
- Note code examples provided

### 2. Prioritize Fixes

**Fix in this order:**

**Priority 1: Critical Issues**
- Security vulnerabilities (SQL injection, XSS, exposed secrets)
- Data loss risks
- Race conditions
- Must fix before commit

**Priority 2: High Priority Issues**
- Performance problems (N+1 queries, memory leaks)
- Logic errors
- Code quality issues that affect functionality
- Should fix before commit

**Priority 3: Medium Priority Issues**
- Code quality improvements
- Minor performance optimizations
- Can fix in follow-up if needed

**Priority 4: Low Priority Issues**
- Style issues (use linting tools)
- Nice-to-have improvements
- Can defer

### 3. Fix Each Issue

For each issue in the review report:

**Step 1: Locate the code**
- Find the file and line number
- Read surrounding context
- Understand the issue

**Step 2: Apply the fix**
- Follow the suggestion from the review
- Use the code example provided
- Follow project-specific patterns (see `.claude/rules/`)

**Step 3: Verify the fix**
- Run related tests
- Check for new issues introduced
- Ensure the fix doesn't break other functionality

**Step 4: Document the fix**
- Add comment if logic is complex
- Update related documentation if needed

### 4. Follow Project Standards

When fixing issues, ensure compliance with your project's technology patterns:

**For Spring Boot projects:**
- Use Spring Data JDBC (NOT JPA/Hibernate)
- Constructor injection with @RequiredArgsConstructor
- DTOs for API responses
- Structured logging
- Graceful error handling

**For React projects:**
- Functional components with hooks
- TypeScript strict mode
- Proper state management
- Performance optimizations

**For other technologies:**
- Check `technologies/*/reference/` for best practices
- Follow `.claude/rules/` guidelines
- Maintain consistency with existing code

### 5. Validate Fixes

After fixing all issues, run validation commands appropriate for your technology stack:

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

### 6. Re-Review (Optional)

If critical or many issues were fixed:

- Run code review again
- Verify all issues are resolved
- No new issues introduced

## Output Report

Provide summary of fixes applied:

### Issues Fixed

**Critical Issues:** X/X fixed
- ✅ Issue 1: [Title] - Fixed by [description]
- ✅ Issue 2: [Title] - Fixed by [description]

**High Priority Issues:** X/X fixed
- ✅ Issue 1: [Title] - Fixed by [description]
- ✅ Issue 2: [Title] - Fixed by [description]

**Medium Priority Issues:** X/X fixed (or deferred)
- ✅ Issue 1: [Title] - Fixed by [description]
- ⏸️ Issue 2: [Title] - Deferred to follow-up

**Low Priority Issues:** X/X deferred
- ⏸️ Issue 1: [Title] - Deferred (minor style issue)
- ⏸️ Issue 2: [Title] - Deferred (nice-to-have)

### Files Modified

- `path/to/file1.java` - Fixed security issue (SQL injection)
- `path/to/file2.tsx` - Fixed performance issue (unnecessary re-renders)
- `path/to/file3.java` - Fixed code quality issue

### Validation Results

```bash
# All validation commands pass
✅ Compilation: PASS
✅ Unit tests: PASS (42 tests)
✅ Integration tests: PASS (8 tests)
✅ Coverage: 85% (meets 80% requirement)
✅ Build: PASS
```

### Standards Compliance

- ✅ Follows technology patterns
- ✅ Proper error handling
- ✅ Appropriate logging
- ✅ Security best practices

### Ready for Commit

**Status:** ✅ READY

All critical and high priority issues fixed. Code ready to commit.

---

**Important:** If you cannot fix an issue, document why and create a follow-up task. Don't commit critical or high priority issues unfixed.

---

## Automatic Re-Review Loop

**After fixing issues:**

**IF critical or high priority issues were fixed:**
- Automatically re-run code review
- Verify all issues are resolved
- Check for new issues introduced
- **Loop until:** Code review passes with zero critical/high issues

**IF code review is now clean:**
- Automatically invoke: `/validation:validate`
- Continue to final validation

**Maximum iterations:** 3
- After 3 fix attempts, stop automatic loop
- Ask user: "Manual review required - automatic fix loop exhausted"
- User can manually fix and re-run code review

**If called manually (not from code review):**
- Ask user: "Run code review to verify fixes"
- Don't auto-chain (user is in control)

This automatic loop ensures code is clean before proceeding to final validation.
