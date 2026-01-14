---
description: Auto-activates during code reviews to enforce systematic quality checks (COMPLEMENTS /validation:code-review command)
triggers:
  - command: "/validation:code-review"
    when: "running code review", "reviewing pull request"
  - command: "/code-review:code-review"
    when: "running code review", "reviewing pull request"
  - command: "gh pr view"
    when: "reviewing pull request"
---

# Code Review Skill

## Activation

This skill **auto-activates during manual code reviews**.

**Triggers:**
- `/validation:code-review` command executed
- `/code-review:code-review` command executed
- `gh pr view` or similar PR review commands

**IMPORTANT:** This is a **SKILL** that auto-activates DURING manual review, NOT a replacement for the `/validation:code-review` command.

**Relationship:**
- User triggers review via command
- This skill auto-activates to enforce systematic checks
- Best of both worlds: manual control + automatic enforcement

## Enforcement

**🔍 SYSTEMATIC CODE REVIEW CHECKLIST:**

### 1. TDD Compliance Check

**Verify tests written BEFORE code:**

**Questions to ask:**
- Does implementation have corresponding test file?
- Was test written BEFORE implementation (check git history)?
- Does test follow Given-When-Then pattern?
- Does test cover the behavior being implemented?

**If TDD violation detected:**
```
🚨 TDD VIOLATION

Implementation file: [filename]
Test file: [missing or created after implementation]

REQUIRED:
1. DELETE implementation code
2. Write test FIRST (RED phase)
3. Run test to verify it FAILS
4. Implement code to make test PASS (GREEN phase)

TDD is non-negotiable.
```

### 2. Test Coverage Check

**Verify test coverage ≥ 80%:**

**Questions to ask:**
- What is the test coverage for changed files?
- Are all critical paths covered?
- Are edge cases tested?
- Are error cases tested?

**If coverage < 80%:**
```
⚠️ LOW TEST COVERAGE

Coverage: [X]% (target: 80%+)

Add tests for:
- Uncovered methods/functions
- Edge cases
- Error conditions
- Boundary conditions

Run coverage report:
  mvn jacoco:report  # Java
  npm test -- --coverage  # JavaScript/TypeScript
```

### 3. Security Review

**Check for security vulnerabilities (OWASP Top 10):**

**Checklist:**
- [ ] Input validation on all user inputs
- [ ] SQL injection prevention (parameterized queries)
- [ ] XSS prevention (output encoding)
- [ ] CSRF protection on state-changing operations
- [ ] Secrets NOT committed (no API keys, passwords in code)
- [ ] Proper password hashing (bcrypt/scrypt/Argon2)
- [ ] Authentication/authorization on protected endpoints
- [ ] Sensitive data NOT logged (passwords, tokens, PII)

**If security issues found:**
```
🚨 SECURITY ISSUE

Issue: [description]
Severity: [High/Medium/Low]
OWASP Category: [e.g., A01:2021 – Broken Access Control]

Fix:
[Specific remediation steps]

Reference:
- [OWASP Top 10](https://owasp.org/www-project-top-ten/)
```

### 4. Code Conventions

**Verify code follows project conventions:**

**Checklist:**
- [ ] Naming conventions followed (camelCase, PascalCase, etc.)
- [ ] Code formatting matches project style
- [ ] Indentation consistent (tabs/spaces)
- [ ] Line length within limits (typically 120-140 chars)
- [ ] File organization follows project structure
- [ ] Import statements organized and clean

**If conventions violated:**
```
⚠️ CODE CONVENTION VIOLATION

Issue: [specific convention violated]
File: [filename]
Line: [line number]

Fix:
[Correct formatting]

Run formatter:
  mvn spotless:apply  # Java
  npm run format  # JavaScript/TypeScript
```

### 5. Error Handling

**Verify proper error handling:**

**Checklist:**
- [ ] Errors are logged with context
- [ ] Generic exceptions NOT caught (catch specific types)
- [ ] Error messages are meaningful (not "Error occurred")
- [ ] Errors are handled gracefully (no crashes)
- [ ] Sensitive information NOT exposed in errors
- [ ] Error recovery mechanisms in place

**If error handling issues:**
```
⚠️ ERROR HANDLING ISSUE

Problem: [specific error handling problem]
Location: [file:line]

Fix:
try {
  // code
} catch (SpecificException e) {
  log.error("Context message", e); // Log with context
  throw new MeaningfulException("Clear message", e);
}
```

### 6. Structured Logging

**Verify appropriate logging:**

**Checklist:**
- [ ] Structured logging used (not string concatenation)
- [ ] Log levels appropriate (ERROR, WARN, INFO, DEBUG)
- [ ] Sensitive data NOT logged
- [ ] Context included in log messages
- [ ] Performance logging for critical paths

**If logging issues:**
```
⚠️ LOGGING ISSUE

Problem: [specific logging problem]
Location: [file:line]

Fix:
// BAD
logger.info("User " + user.getName() + " logged in");

// GOOD
logger.info("User logged in: userId={}", user.getId()); // Structured, no sensitive data
```

### 7. DRY Principle (Don't Repeat Yourself)

**Check for code duplication:**

**Questions to ask:**
- Is similar code repeated in multiple places?
- Can duplicated code be extracted to a function/method?
- Can loops/reduce be used instead of repetition?

**If code duplication found:**
```
⚠️ CODE DUPLICATION

Duplicated code found in:
- [file1:line]
- [file2:line]

Extract to shared function:
private Type sharedFunction(Params params) {
  // Common logic
}

Usage:
result1 = sharedFunction(params1);
result2 = sharedFunction(params2);
```

### 8. Abstraction Level

**Verify appropriate abstraction (not over-engineered):**

**Questions to ask:**
- Is the code unnecessarily complex?
- Are there too many layers of abstraction?
- Would simpler code be clearer?
- Is the abstraction solving a real problem?

**If over-engineered:**
```
⚠️ OVER-ENGINEERING

Code is more complex than necessary.

Consider simplifying:
- Remove unnecessary abstractions
- Use simpler data structures
- Reduce number of classes/interfaces
- Favor clarity over cleverness

Remember: YAGNI (You Aren't Gonna Need It)
```

### 9. "Broken Windows" (Technical Debt)

**Check for technical debt and code quality issues:**

**Checklist:**
- [ ] No commented-out code
- [ ] No TODO comments (or tracked in issues)
- [ ] No dead/unused code
- [ ] No obvious bugs
- [ ] No misleading comments
- [ ] No workarounds without documentation

**If technical debt found:**
```
⚠️ TECHNICAL DEBT

Issue: [specific debt]
Location: [file:line]

Options:
1. Fix now (if quick)
2. Create issue for later (if complex)
3. Document workaround (if necessary)

Don't let broken windows accumulate!
```

### 10. Commit Message

**Verify commit message follows conventional commits:**

**Format:**
```
type(scope): description

[optional body]

[optional footer]
```

**Types:** feat, fix, docs, style, refactor, test, chore, perf

**Examples:**
- ✅ `feat(auth): add JWT token refresh mechanism`
- ✅ `fix(api): resolve race condition in user creation`
- ✅ `docs(readme): update installation instructions`

**If commit message wrong:**
```
⚠️ COMMIT MESSAGE ISSUE

Current: [current message]

Should follow:
type(scope): description

Examples:
  feat(user): add email validation
  fix(auth): resolve token expiration bug
  docs(api): update endpoint documentation

To amend:
  git commit --amend -m "correct message"
```

## Behavior

When this skill activates (during code review):

### 1. Analyze Changed Files

Identify all files in the review:
- Implementation files
- Test files
- Configuration files
- Documentation files

### 2. Run Systematic Checks

For each changed file, run checks:
1. **TDD compliance** - Tests written first?
2. **Test coverage** - ≥80% coverage?
3. **Security** - OWASP Top 10?
4. **Conventions** - Project style?
5. **Error handling** - Graceful degradation?
6. **Logging** - Structured, no sensitive data?
7. **Duplication** - DRY principle?
8. **Abstraction** - Not over-engineered?
9. **Technical debt** - Broken windows?
10. **Commit message** - Conventional commits?

### 3. Generate Review Report

Report format:

```markdown
# Code Review Report

## Summary
- Files changed: [N]
- Lines added: [N]
- Lines removed: [N]
- Test coverage: [X]%
- Issues found: [N]

## TDD Compliance
- ✅ PASS / ❌ FAIL
- Details: [...]

## Test Coverage
- ✅ PASS / ❌ FAIL
- Coverage: [X]%
- Missing tests: [...]

## Security
- ✅ PASS / ❌ FAIL
- Issues: [...]

## Code Quality
- ✅ PASS / ❌ FAIL
- Issues: [...]

## Recommendations
1. [High priority]
2. [Medium priority]
3. [Low priority]

## Overall Assessment
- ✅ APPROVE / ❌ REQUEST CHANGES / ⚠️ APPROVE WITH SUGGESTIONS
```

## Examples

### ✅ GOOD: Clean Code Review

```java
// UserService.java
@Service
@RequiredArgsConstructor
public class UserService {

  private final UserRepository userRepository;
  private final PasswordEncoder passwordEncoder;
  private final Logger logger = LoggerFactory.getLogger(UserService.class);

  @Transactional
  public User create(CreateUserDTO dto) {
    logger.info("Creating user: email={}", dto.getEmail());

    User user = new User();
    user.setEmail(dto.getEmail());
    user.setPassword(passwordEncoder.encode(dto.getPassword()));
    user.setName(dto.getName());

    User created = userRepository.save(user);
    logger.info("User created: userId={}", created.getId());

    return created;
  }
}

// UserServiceTest.java
class UserServiceTest {

  @Test
  void shouldCreateUserWhenValidDataProvided() {
    // GIVEN
    CreateUserDTO dto = CreateUserDTO.builder()
      .email("john@example.com")
      .password("SecurePass123")
      .name("John Doe")
      .build();

    // WHEN
    User user = userService.create(dto);

    // THEN
    assertThat(user).isNotNull();
    assertThat(user.getEmail()).isEqualTo("john@example.com");
    assertThat(user.getName()).isEqualTo("John Doe");
    assertThat(user.getPassword()).isNotNull(); // Hashed
  }
}
```

**Review:**
- ✅ TDD compliance: Test exists, covers implementation
- ✅ Security: Password hashed, no sensitive data logged
- ✅ Error handling: Transactional, structured logging
- ✅ Code quality: Clean code, follows conventions
- ✅ Test coverage: Covers happy path

### ❌ BAD: Code Quality Issues

```java
// BAD: Multiple issues
public class UserService {

  public void create(String email, String pass, String name) {
    Logger.log("Creating user: " + email + ", " + name); // Sensitive data logged
    User u = new User(); // Unclear naming
    u.email = email; // Direct field access
    u.pass = pass; // PLAIN TEXT PASSWORD!
    u.name = name;
    repo.save(u); // No error handling

    // TODO: Add validation later // Technical debt
    // Unused code below (dead code)
    // String debug = "Debug: " + u.toString();
  }

  public List<User> getAllUsers() {
    return repo.findAll(); // No pagination
  }

  public List<User> getAllUsers2() { // DUPLICATE!
    return repo.findAll();
  }
}
```

**Review:**
- ❌ TDD compliance: No tests
- ❌ Security: Plain text password, sensitive data logged
- ❌ Error handling: No error handling
- ❌ Code quality: Direct field access, unclear names
- ❌ Technical debt: TODO comments, dead code, duplication
- ❌ Test coverage: 0%

**Action:** ❌ REQUEST CHANGES

## Checklist

Before approving code review:

- [ ] TDD compliance verified (tests written first)
- [ ] Test coverage ≥ 80%
- [ ] Security vulnerabilities checked (OWASP Top 10)
- [ ] Code follows project conventions
- [ ] Error handling implemented
- [ ] Structured logging used
- [ ] No code duplication (DRY principle)
- [ ] Appropriate abstraction level
- [ ] No technical debt (broken windows)
- [ ] Commit message follows conventional commits

**If any checklist item fails:**
- **REQUEST CHANGES** if critical issues (TDD, security, coverage)
- **APPROVE WITH SUGGESTIONS** if minor issues (style, optimization)
- **APPROVE** if all checks pass

## Resources

**See Also:**
- `.claude/commands/validation/code-review.md` - Code review command
- `.claude/rules/22-tdd-strict.md` - TDD rules
- `.claude/rules/40-security.md` - Security rules
- `.claude/skills/test-driven-development/SKILL.md` - TDD enforcement

**Learn More:**
- [Effective Code Review](https://google.github.io/eng-practices/review/)
- [OWASP Code Review Guide](https://owasp.org/www-project-code-review-guide/)
