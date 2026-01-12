---
description: Technical code review for quality and bugs that runs pre-commit
---

# Code Review: Technical Quality Analysis

## ⚠️ CRITICAL PREREQUISITES

**DO NOT RUN this command if:**
- ❌ Code doesn't compile
- ❌ Tests are failing
- ❌ Build is broken
- ❌ Runtime errors occur

**RUN ONLY AFTER:**
- ✅ Compilation succeeds (`mvn clean compile`, `npm run build`, etc.)
- ✅ All tests pass (`mvn test`, `npm test`, etc.)
- ✅ No runtime errors
- ✅ Build completes successfully

**Why?** Code review performs **static analysis only**. It cannot verify that code actually compiles or runs correctly. Reviewing uncompiled code creates false confidence and wastes time.

**If build is broken:**
1. Fix compilation errors first
2. Fix test failures
3. Verify build succeeds
4. THEN run code review

**To verify build status, run:**
```
/validation:validate
```

This ensures compilation and tests pass before code review.

---

## Core Principles

**Review Philosophy:**

- Simplicity is the ultimate sophistication - every line should justify its existence
- Code is read far more often than it's written - optimize for readability
- The best code is often the code you don't write
- Elegance emerges from clarity of intent and economy of expression

## Review Process

### 1. Gather Codebase Context

**Start by understanding the codebase standards:**

Read these files FIRST:

```bash
# 1. Project overview and standards
Read .claude/CLAUDE.md

# 2. PIV methodology guide
Read .claude/PIV-METHODOLOGY.md

# 3. Architecture documentation (if exists)
Read docs/ARCHITECTURE.md

# 4. Technology-specific rules
# Backend rules (if using backend technologies)
Read .claude/rules/backend/*.md

# 5. General rules
Read .claude/rules/00-general.md
Read .claude/rules/10-git.md
Read .claude/rules/20-testing.md
Read .claude/rules/30-documentation.md
Read .claude/rules/40-security.md

# 6. Technology-specific reference documentation
# Check technologies/{backend|frontend|database}/*/reference/
```

### 2. Identify Changed Files

**Check what changed:**

```bash
# Show modified files
git status

# Show changes in detail
git diff HEAD

# Show statistics
git diff --stat HEAD

# List new files
git ls-files --others --exclude-standard
```

### 3. Read Each File Completely

**For each changed file or new file:**

- Read the ENTIRE file (not just the diff)
- Understand full context
- Note patterns used
- Identify potential issues

**Why entire file?** Diffs can be misleading. Full context ensures accurate review.

### 4. Analyze for Issues

For each changed file or new file, analyze for:

## 1. Logic Errors

**Off-by-one errors:**
```java
// ❌ BAD: Off-by-one error
for (int i = 0; i <= list.size(); i++) { }

// ✅ GOOD: Correct bounds
for (int i = 0; i < list.size(); i++) { }
```

**Incorrect conditionals:**
```java
// ❌ BAD: Wrong logic
if (price > 100 && price < 1000) { }

// ✅ GOOD: Correct logic
if (price >= 100 && price <= 1000) { }
```

**Missing error handling:**
```java
// ❌ BAD: No error handling
public Resource fetchResource(String url) {
    return httpClient.get(url);
}

// ✅ GOOD: Proper error handling
public Resource fetchResource(String url) {
    try {
        return httpClient.get(url);
    } catch (IOException e) {
        log.error("Failed to fetch resource: {}", url, e);
        return null; // Or throw appropriate exception
    }
}
```

**Race conditions:**
```java
// ❌ BAD: Potential race condition
if (resource == null) {
    resource = repository.save(new Resource());
}

// ✅ GOOD: Atomic operation
resource = repository.findById(id)
    .orElseGet(() -> repository.save(new Resource()));
```

## 2. Security Issues

**SQL injection vulnerabilities:**
```java
// ❌ BAD: SQL injection risk
@Query("SELECT * FROM resources WHERE name = '" + name + "'")
List<Resource> findByName(String name);

// ✅ GOOD: Parameterized query
@Query("SELECT * FROM resources WHERE name = :name")
List<Resource> findByName(String name);
```

**XSS vulnerabilities:**
```typescript
// ❌ BAD: XSS risk
<div dangerouslySetInnerHTML={{ __html: userInput }} />

// ✅ GOOD: Sanitized input (React auto-escapes)
<div>{userInput}</div>
```

**Insecure data handling:**
```java
// ❌ BAD: Logging sensitive data
log.info("User password: {}", user.getPassword());

// ✅ GOOD: Don't log sensitive data
log.info("User login attempt: {}", user.getEmail());
```

**Exposed secrets or API keys:**
```java
// ❌ BAD: Hardcoded API key
String API_KEY = "abc123xyz";

// ✅ GOOD: Configuration
@Value("${api.key}")
private String apiKey;
```

## 3. Performance Problems

**N+1 queries:**
```java
// ❌ BAD: N+1 query problem
List<User> users = userRepository.findAll();
for (User user : users) {
    List<Item> items = itemRepository.findByUserId(user.getId());
    user.setItems(items);
}

// ✅ GOOD: Single query with JOIN
@Query("SELECT users.*, items.* FROM users LEFT JOIN items ON users.id = items.user_id")
List<UserWithItems> findAllWithItems();
```

**Inefficient algorithms:**
```java
// ❌ BAD: O(n²) nested loop
for (Item i1 : items) {
    for (Item i2 : items) {
        if (i1.getId().equals(i2.getId())) { }
    }
}

// ✅ GOOD: O(n) with HashMap
Map<Long, Item> itemMap = items.stream()
    .collect(Collectors.toMap(Item::getId, Function.identity()));
```

**Memory leaks:**
```java
// ❌ BAD: Unbounded cache
private static List<Resource> cache = new ArrayList<>();

// ✅ GOOD: Bounded cache with eviction
private static Cache<Long, Resource> cache = Caffeine.newBuilder()
    .maximumSize(1000)
    .expireAfterWrite(10, TimeUnit.MINUTES)
    .build();
```

## 4. Code Quality

**Violations of DRY principle:**
```java
// ❌ BAD: Repeated code
public void processResourceA(Resource r) {
    r.setName(r.getName().trim());
    r.setValue(r.getValue().trim());
}

public void processResourceB(Resource r) {
    r.setName(r.getName().trim());
    r.setValue(r.getValue().trim());
}

// ✅ GOOD: Extract common method
public void trimResourceFields(Resource r) {
    r.setName(r.getName().trim());
    r.setValue(r.getValue().trim());
}
```

**Overly complex functions:**
```java
// ❌ BAD: Too complex, hard to understand
public void process() {
    // 200 lines of code with nested logic
}

// ✅ GOOD: Break into smaller functions
public void process() {
    validateInput();
    fetchData();
    processData();
    saveResults();
}
```

**Poor naming:**
```java
// ❌ BAD: Unclear naming
public String d(String p, String a) {
    return p + " " + a;
}

// ✅ GOOD: Clear naming
public String formatFullAddress(String postalCode, String city) {
    return String.format("%s %s", postalCode, city);
}
```

**Missing type annotations:**
```java
// ❌ BAD: Raw types
List list = new ArrayList();

// ✅ GOOD: Generic types
List<Resource> resources = new ArrayList<>();
```

## 5. Adherence to Project Standards

**Follow technology-specific patterns:**

Check if the code follows the patterns defined in:
- `.claude/rules/backend/` for backend code
- `technologies/backend/*/reference/` for best practices
- `.claude/rules/` for general patterns

**Common patterns to verify:**

- **Backend**: Dependency injection, DTOs, structured logging, error handling
- **Frontend**: Functional components, TypeScript, state management
- **Database**: Proper indexing, constraints, migrations

## Verify Issues Are Real

**Before flagging an issue:**

- Run specific tests for issues found
- Confirm type errors are legitimate
- Validate security concerns with context
- Check if pattern is intentional

**Example:**
```java
// Looks like N+1 query...
for (User user : users) {
    List<Item> items = itemRepository.findByUserId(user.getId());
}

// But maybe it's intentional for pagination?
// Check: Is there caching? Is the data size small?
// Verify before flagging as issue
```

## Output Format

**Save review report to:** `.claude/agents/reviews/code-review-{timestamp}.md`

**Report Structure:**

```markdown
# Code Review: {Feature Name}

**Date:** {timestamp}
**Branch:** {branch}
**Commit:** {commit-hash}
**PIV Status:** [PIV-based / Non-PIV / Mixed]

## Stats

- Files Modified: X
- Files Added: X
- Files Deleted: X
- New Lines: +XXX
- Deleted Lines: -XXX
- Total Changes: XXX lines

## Summary

{Overall assessment of changes}

## PIV Compliance (if applicable)

**If feature was implemented using PIV methodology:**

- [ ] Plan was created and followed
- [ ] All mandatory files were read
- [ ] Patterns from plan were used
- [ ] All validation commands pass
- [ ] Tests meet coverage requirements (>= 80%)

**PIV Quality Score:** X/10

## Issues Found

### Critical Issues

{severity: critical}

#### Issue 1: {Title}

**severity:** critical
**file:** `path/to/file.java`
**line:** 42
**issue:** {One-line description}
**detail:** {Explanation of why this is a problem}
**suggestion:** {How to fix it}
**code example:** {Show fix if applicable}

### High Priority Issues

{severity: high}

{List high priority issues}

### Medium Priority Issues

{severity: medium}

{List medium priority issues}

### Low Priority Issues

{severity: low}

{List low priority issues}

## Positive Findings

{What was done well}

## Recommendations

{Overall recommendations for improvement}

## Standards Compliance

{Check against project-specific standards}
- [ ] Follows technology patterns
- [ ] Proper error handling
- [ ] Appropriate logging
- [ ] Security best practices
- [ ] Performance considerations

## Conclusion

**Overall Assessment:** PASS / NEEDS FIXES

**PIV Assessment:** [If applicable] EXCELLENT / GOOD / NEEDS IMPROVEMENT

**Summary:** {Brief summary}

**Next Steps:**
- [ ] Fix critical issues
- [ ] Fix high priority issues
- [ ] Consider medium priority improvements
- [ ] Ready for commit once critical/high issues fixed
```

## If No Issues Found

**Report:**

```markdown
# Code Review: {Feature Name}

**Status:** ✅ PASSED

**PIV Status:** [PIV-based / Non-PIV]

**Summary:** Code review passed. No technical issues detected.

**Changes Reviewed:**
- Files Modified: X
- Files Added: X
- Lines Changed: XXX

**PIV Compliance:** [If applicable]
- [ ] Plan followed correctly
- [ ] All validations pass
- [ ] Tests comprehensive

**Quality Assessment:**
- ✅ No logic errors
- ✅ No security issues
- ✅ No performance problems
- ✅ Code quality is good
- ✅ Follows project standards
- ✅ Proper error handling
- ✅ Good use of patterns

**Ready for commit.**
```

## Important Guidelines

**Be Specific:**
- Include line numbers (not vague complaints)
- Show code examples (before/after)
- Explain WHY it's a problem (not just WHAT)

**Focus on Real Issues:**
- Don't complain about style (use linting tools for that)
- Focus on bugs, security, performance, maintainability
- Flag security issues as CRITICAL

**Suggest Fixes:**
- Don't just complain
- Show how to fix it
- Provide code examples

**Be Constructive:**
- Explain reasoning clearly
- Provide actionable feedback
- Help improve code quality

**Check PIV Compliance (if applicable):**
- Was a plan created?
- Was the plan followed?
- Were all validations run?
- Do tests meet coverage requirements?

---

**Remember:** The goal is to improve code quality, not to criticize. Be helpful, not harsh.

---

## Automatic Next Step

**After generating the review report:**

**If CRITICAL or HIGH priority issues found:**
- Automatically invoke: `/validation:code-review-fix <report-path>`
- This will fix issues and loop back to code review
- Don't wait for user - automated quality gate

**If NO critical/high issues (clean review):**
- Automatically invoke: `/validation:validate`
- This runs final validation suite
- Continue the automatic flow

**If called manually (not from execute):**
- Show report summary
- Ask user: "Run `/validation:code-review-fix <report-path>` to fix issues"
- Or "Run `/validation:validate` if code is clean"

This automatic chaining ensures quality gates are never skipped.
