---
description: Fix issues found in code review
argument-hint: "<path-to-code-review-report>"
---

# Code Review Fix: Implement Review Recommendations

> **Code review methodology:** `$CLAUDE_PLUGIN_ROOT/.claude-plugin/reference/execution/code-review.md`
> **Rules reference:** `$CLAUDE_PLUGIN_ROOT/.claude-plugin/reference/rules-full/`

## Code Review Report

Read code review report: `$ARGUMENTS`

**Example:** `.claude/agents/code-reviews/example-feature-validation-review.md`

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
- Follow Example patterns (see reference docs)

**Step 3: Verify the fix**
- Run related tests
- Check for new issues introduced
- Ensure the fix doesn't break other functionality

**Step 4: Document the fix**
- Add comment if logic is complex
- Update related documentation if needed

### 4. Example Standards Compliance

When fixing issues, ensure compliance with:

**Spring Data JDBC (NOT JPA/Hibernate):**
```java
// ✅ GOOD: Simple entity for JDBC
public class Entity {
    private Long id;
    private Long userId;
}

// ❌ BAD: JPA annotations
@Entity
public class Entity {
    @ManyToOne
    private User user;
}
```

**Constructor Injection:**
```java
// ✅ GOOD: Constructor injection
@RequiredArgsConstructor
public class Service {
    private final Repository repository;
}

// ❌ BAD: Field injection
@Autowired
private Repository repository;
```

**DTOs for API:**
```java
// ✅ GOOD: Return DTOs
@GetMapping
public List<EntityDTO> getAll() {
    return service.getAll()
        .stream()
        .map(EntityDTO::from)
        .collect(Collectors.toList());
}

// ❌ BAD: Return entities
@GetMapping
public List<Entity> getAll() {
    return service.getAll();
}
```

**Structured Logging:**
```java
// ✅ GOOD: Structured logging
log.info("Fetching completed: source={}, found={}", source, count);

// ❌ BAD: String concatenation
log.info("Fetching completed for " + source);
```

**Graceful Error Handling:**
```java
// ✅ GOOD: Continue processing
for (Entity p : properties) {
    try {
        process(p);
    } catch (Exception e) {
        log.error("Failed to process: {}", p.getId(), e);
        // Continue with next
    }
}

// ❌ BAD: Fail fast
for (Entity p : properties) {
    process(p); // Throws exception, stops all processing
}
```

### 5. Validate Fixes

After fixing all issues:

**Run all validations:**
```bash
# Level 0: Environment check (LOCAL mode!)
cat backend/.env.local | grep DATABASE_URL | grep -v "production.example.com"

# Level 1: Backend compilation
cd backend && mvn clean compile

# Level 2: Unit tests
cd backend && mvn test

# Level 3: Integration tests (LOCAL)
cd backend && mvn verify -DskipUnitTests=true

# Level 4: Coverage
cd backend && mvn jacoco:report

# Level 5: Frontend build
cd frontend && npm run build
```

**All validations must pass!**

### 6. Re-Review (Optional)

If critical or many issues were fixed:

- Run `/piv:code-review` again
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
- `path/to/file2.java` - Fixed performance issue (N+1 query)
- `path/to/file3.java` - Fixed code quality issue

### Validation Results

```bash
# All validation commands pass
✅ Backend compilation: PASS
✅ Unit tests: PASS (42 tests)
✅ Integration tests: PASS (8 tests)
✅ Coverage: 85% (meets 80% requirement)
✅ Frontend build: PASS
```

### Example Standards Compliance

- ✅ Spring Data JDBC used (not JPA)
- ✅ Constructor injection
- ✅ DTOs for API responses
- ✅ Structured logging
- ✅ Graceful error handling
- ✅ Environment-safe configuration

### Ready for Commit

**Status:** ✅ READY

All critical and high priority issues fixed. Code ready to commit.

---

**Important:** If you cannot fix an issue, document why and create a follow-up task. Don't commit critical or high priority issues unfixed.

---

## Automatic Re-Review Loop

**After fixing issues:**

**IF critical or high priority issues were fixed:**
- Automatically re-run: `/piv-speckit:code-review`
- Verify all issues are resolved
- Check for new issues introduced
- **Loop until:** Code review passes with zero critical/high issues

**IF code review is now clean:**
- Automatically invoke: `/piv-speckit:validate`
- Continue to final validation

**Maximum iterations:** 3
- After 3 fix attempts, stop automatic loop
- Ask user: "Manual review required - automatic fix loop exhausted"
- User can manually fix and re-run code review

**If called manually (not from code review):**
- Ask user: "Run `/piv-speckit:code-review` to verify fixes"
- Don't auto-chain (user is in control)

This automatic loop ensures code is clean before proceeding to final validation.
