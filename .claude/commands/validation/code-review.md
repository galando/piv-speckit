---
description: Technical code review for quality and bugs that runs pre-commit
---

# Code Review: Technical Quality Analysis

## Core Principles

**Review Philosophy:**

- Simplicity is the ultimate sophistication - every line should justify its existence
- Code is read far more often than it's written - optimize for readability
- The best code is often the code you don't write
- Elegance emerges from clarity of intent and economy of expression

## Review Process

### Prerequisites (MANDATORY)

**⚠️ DO NOT RUN code review if:**

- ❌ Code does not compile
- ❌ Tests are failing
- ❌ Build is broken
- ❌ Runtime errors exist

**✅ RUN ONLY AFTER:**

- ✅ Build succeeds (compilation step passes)
- ✅ All tests pass (unit + integration)
- ✅ No runtime errors
- ✅ Validation pipeline passes

**Why This Matters:**

Code review is a **static analysis** tool. It checks code quality, patterns, and security issues, but it **cannot verify that code works**. Reviewing broken code is meaningless and wastes effort.

**Required Flow:**

```
Execute → Compile → Tests → Validation → Code Review ✅
                   ↓ FAIL
              Stop & Fix
```

If compilation or tests fail, fix those issues FIRST. Then run code review.

**How to Verify:**

Before running this command, ensure:

```bash
# 1. Compilation succeeded
<backend-compile-command>
# Expected: BUILD SUCCESS

# 2. Tests passed
<test-command>
# Expected: Tests run: X, Failures: 0, Errors: 0

# 3. If above pass, THEN run code review
/validation:code-review
```

**What This Command Does:**

- ✅ Static code analysis
- ✅ Pattern checking
- ✅ Security review
- ✅ Code quality assessment
- ❌ Does NOT compile code
- ❌ Does NOT run tests
- ❌ Does NOT verify code works

**Remember:** Code review assumes code is functional. It reviews quality, not correctness.

### 1. Gather Codebase Context

**Start by understanding the codebase standards:**

**NOTE:** As part of PIV adoption (Week 1), the following documentation files are being aligned with PIV methodology. Check if they've been updated yet.

Read these files FIRST (in order of priority):

```bash
# 1. Project overview and standards (PIV-aligned)
Read .claude/CLAUDE.md

# 2. PIV methodology workflow (current)
Read .claude/PIV-WORKFLOW.md

# 3. PIV adoption journey (historical)
Read .claude/archive/PIV-ADOPTION-JOURNEY.md

# 4. Architecture and patterns (to be PIV-aligned)
Read docs/ARCHITECTURE.md

# 5. Backend rules (to be PIV-aligned)
# These files will be enhanced with PIV-specific patterns during Week 1
Read .claude/rules/backend/api-design.md
Read .claude/rules/backend/database.md
Read .claude/rules/backend/fetching.md
Read .claude/rules/backend/email.md
Read .claude/rules/backend/security.md
Read .claude/rules/backend/data-quality.md
Read .claude/rules/backend/monitoring.md

# 6. General rules (to be PIV-aligned)
Read .claude/rules/testing.md
Read .claude/rules/anti-patterns.md
Read .claude/rules/code-review.md
Read .claude/rules/environment.md

# 7. PIV-specific rules (NEW - being created in Week 1)
Read .claude/rules/piv-workflow.md  # This file will be created
```

**Important:** Use the patterns documented in:
1. `.claude/PIV-WORKFLOW.md` - Current PIV methodology (primary reference)
2. `.claude/rules/` - Modular coding standards
3. Apply PIV methodology principles as the primary reference

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
public Entity fetchProperty(String url) {
    return jsoup.connect(url).get();
}

// ✅ GOOD: Proper error handling (Example pattern)
public Entity fetchProperty(String url) {
    try {
        Document doc = jsoup.connect(url).get();
        return parseEntity(doc);
    } catch (IOException e) {
        log.error("Failed to fetch property: {}", url, e);
        // Continue processing - Example graceful degradation pattern
        return null;
    }
}
```

**Race conditions:**
```java
// ❌ BAD: Potential race condition
if (property == null) {
    property = repository.save(new Entity());
}

// ✅ GOOD: Atomic operation
property = repository.findById(id)
    .orElseGet(() -> repository.save(new Entity()));
```

## 2. Security Issues

**SQL injection vulnerabilities:**
```java
// ❌ BAD: SQL injection risk
@Query("SELECT * FROM properties WHERE city = '" + city + "'")
List<Entity> findByCity(String city);

// ✅ GOOD: Parameterized query (Spring Data JDBC pattern)
@Query("SELECT * FROM properties WHERE city = :city")
List<Entity> findByCity(String city);
```

**XSS vulnerabilities:**
```typescript
// ❌ BAD: XSS risk
<div dangerouslySetInnerHTML={{ __html: userInput }} />

// ✅ GOOD: Sanitized input (React pattern)
<div>{userInput}</div>
```

**Insecure data handling:**
```java
// ❌ BAD: Logging sensitive data
log.info("User password: {}", user.getPassword());

// ✅ GOOD: Don't log sensitive data (Example logging pattern)
log.info("User login attempt: {}", user.getEmail());
```

**Exposed secrets or API keys:**
```java
// ❌ BAD: Hardcoded API key
String API_KEY = "abc123xyz";

// ✅ GOOD: Configuration (Example configuration pattern)
@Value("${external-geo-service.api.key}")
private String apiKey;
```

## 3. Performance Problems

**N+1 queries:**
```java
// ❌ BAD: N+1 query problem
List<User> users = userRepository.findAll();
for (User user : users) {
    List<Entity> properties = dataRepository.findByUserId(user.getId());
    user.setProperties(properties);
}

// ✅ GOOD: Single query with JOIN (Spring Data JDBC pattern)
@Query("SELECT users.*, properties.* FROM users LEFT JOIN properties ON users.id = properties.user_id")
List<UserWithProperties> findAllWithProperties();
```

**Inefficient algorithms:**
```java
// ❌ BAD: O(n²) nested loop
for (Entity p1 : properties) {
    for (Entity p2 : properties) {
        if (p1.getId().equals(p2.getId())) { }
    }
}

// ✅ GOOD: O(n) with HashMap
Map<Long, Property> propertyMap = properties.stream()
    .collect(Collectors.toMap(Property::getId, Function.identity()));
```

**Memory leaks:**
```java
// ❌ BAD: Unbounded cache
private static List<Entity> cache = new ArrayList<>();

// ✅ GOOD: Bounded cache with eviction
private static Cache<Long, Property> cache = Caffeine.newBuilder()
    .maximumSize(1000)
    .expireAfterWrite(10, TimeUnit.MINUTES)
    .build();
```

**Unnecessary computations:**
```java
// ❌ BAD: Repeated expensive computation
for (Entity property : properties) {
    double distance = calculateDistance(property.getAddress(), userAddress);
    if (distance < 10) {
        notify(property);
    }
}

// ✅ GOOD: Filter first, compute only for matches
List<Entity> nearby = properties.stream()
    .filter(p -> isNearby(p, userAddress))
    .toList();
for (Entity property : nearby) {
    double distance = calculateDistance(property.getAddress(), userAddress);
    notify(property);
}
```

## 4. Code Quality

**Violations of DRY principle:**
```java
// ❌ BAD: Repeated code
public void processExternalServiceAProperty(Entity entity) {
    p.setUrl(p.getUrl().trim());
    p.setPrice(p.getPrice().trim());
    p.setAddress(p.getAddress().trim());
}

public void processExternalServiceBProperty(Entity entity) {
    p.setUrl(p.getUrl().trim());
    p.setPrice(p.getPrice().trim());
    p.setAddress(p.getAddress().trim());
}

// ✅ GOOD: Extract common method
public void trimPropertyFields(Entity entity) {
    p.setUrl(p.getUrl().trim());
    p.setPrice(p.getPrice().trim());
    p.setAddress(p.getAddress().trim());
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
List<Entity> properties = new ArrayList<>();
```

## 5. Adherence to Example Standards

**Spring Data JDBC (NOT JPA/Hibernate):**
```java
// ❌ BAD: JPA annotations (FORBIDDEN in Example)
@Entity
@Table(name = "properties")
public class Entity {
    @ManyToOne
    private User user;
}

// ✅ GOOD: Simple entity for JDBC (Example pattern)
public class Entity {
    private Long id;
    private Long userId;
    // No @ManyToOne, use repository for queries
}
```

**Constructor injection with @RequiredArgsConstructor:**
```java
// ❌ BAD: Field injection (FORBIDDEN in Example)
@Autowired
private DataService propertyService;

// ✅ GOOD: Constructor injection (Example pattern)
@RequiredArgsConstructor
public class EntityController {
    private final DataService propertyService;
}
```

**DTOs for API responses:**
```java
// ❌ BAD: Returning entities from controller (FORBIDDEN in Example)
@GetMapping
public List<Entity> getProperties() {
    return propertyService.getAll();
}

// ✅ GOOD: Returning DTOs (Example pattern)
@GetMapping
public List<EntityDTO> getProperties() {
    return propertyService.getAll()
        .stream()
        .map(EntityDTO::from)
        .collect(Collectors.toList());
}
```

**Structured logging:**
```java
// ❌ BAD: Unstructured logging
log.info("Fetching completed for " + sourceName);

// ✅ GOOD: Structured logging (Example pattern)
log.info("Fetching completed: source={}, found={}, new={}, duration={}ms",
         sourceName, propertiesFound, newProperties, duration);
```

**Graceful error handling:**
```java
// ❌ BAD: Fails fast on error
for (Entity property : properties) {
    enrichEntity(property); // Throws exception, stops processing
}

// ✅ GOOD: Continues on error (Example pattern)
for (Entity property : properties) {
    try {
        enrichEntity(property);
    } catch (Exception e) {
        log.error("Failed to enrich property: {}", entity.getId(), e);
        // Continue with next property - Example graceful degradation
    }
}
```

**Environment Safety (LOCAL vs PROD):**
```java
// ❌ BAD: Hardcoded production URL (CRITICAL SECURITY ISSUE)
String dbUrl = "jdbc:postgresql://production.example.com/database";

// ❌ BAD: Hardcoded local URL (won't work in production)
String dbUrl = "jdbc:postgresql://localhost:5432/example";

// ✅ GOOD: Configuration with environment-specific values (Example pattern)
@Value("${spring.datasource.url}")
private String dbUrl;

// Uses backend/.env.local for LOCAL mode
// Uses backend/.env for PRODUCTION mode
```

**PIV Methodology Adherence (if applicable):**

If the implementation was done using PIV methodology:

```java
// ✅ GOOD: Follows PIV plan
// - Patterns match those documented in plan
// - Validation commands were run
// - Tests were implemented per plan

// Check if:
// [ ] Plan was read before implementation
// [ ] Patterns from plan were followed
// [ ] All validation commands pass
// [ ] Tests cover acceptance criteria
```

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
    List<Entity> props = dataRepository.findByUserId(user.getId());
}

// But maybe it's intentional for pagination?
// Check: Is there a @Async? Is the result cached?
// Verify before flagging as issue
```

## Output Format

**Save review report to:** `.claude/agents/code-reviews/{feature-name}-review.md`

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

## Environment Safety Check

- [ ] No hardcoded production URLs (production.example.com)
- [ ] No hardcoded local URLs (localhost)
- [ ] No hardcoded API keys or secrets
- [ ] All configuration via @Value or properties files
- [ ] Safe for both LOCAL and PROD environments
- [ ] Follows Example environment patterns

## Example Standards Compliance

- [ ] Spring Data JDBC used (NOT JPA/Hibernate)
- [ ] Constructor injection with @RequiredArgsConstructor
- [ ] DTOs used for API responses (NOT entities)
- [ ] Structured logging with SLF4J
- [ ] Graceful error handling (continue processing)
- [ ] Proper use of @Transactional where needed

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
- ✅ Follows Example standards
- ✅ Proper error handling
- ✅ Good use of patterns
- ✅ Environment-safe configuration

**Example Standards:**
- ✅ Spring Data JDBC (not JPA)
- ✅ Constructor injection
- ✅ DTOs for API
- ✅ Structured logging
- ✅ Graceful degradation
- ✅ Environment-safe

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

**Check Environment Safety:**
- No hardcoded production URLs (CRITICAL)
- No hardcoded local URLs
- No hardcoded secrets
- Configuration via properties
- Safe for both LOCAL and PROD modes

**Check Example Standards:**
- Spring Data JDBC (NOT JPA)
- Constructor injection (NOT field injection)
- DTOs for API (NOT entities)
- Structured logging
- Graceful error handling

**Check PIV Compliance (if applicable):**
- Was a plan created?
- Was the plan followed?
- Were all validations run?
- Do tests meet coverage requirements?

---

**Remember:** The goal is to improve code quality, not to criticize. Be helpful, not harsh.

**Note:** During PIV adoption, some documentation may not be fully aligned with PIV yet. In that case, prioritize PIV-WORKFLOW.md and the emerging PIV patterns over older documentation that hasn't been updated yet.

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
