# Skills System

**Auto-activating behaviors that enforce best practices in real-time**

---

## Overview

The Skills System is a powerful feature of Claude Code that automatically enforces best practices while you work. Unlike commands (which you invoke manually), **skills auto-activate based on file patterns and commands**, providing real-time guidance and enforcement.

### What are Skills?

**Skills are auto-activating behaviors** that:
- Trigger automatically when you work on specific file types
- Enforce best practices in real-time
- Provide immediate feedback and guidance
- Complement manual commands (not replace them)

### Key Benefits

1. **Real-time Enforcement** - Catch issues during development, not after
2. **No Manual Invocation** - Skills activate automatically when needed
3. **Context-Aware** - Different skills activate for different file types
4. **Complementary to Commands** - Skills enhance manual commands, don't replace them
5. **Customizable** - Modify SKILL.md files to adjust behavior

---

## How Skills Work

### Activation Triggers

Skills activate based on two types of triggers:

#### 1. File Pattern Triggers

Skills activate when you open/edit files matching specific patterns:

```yaml
triggers:
  - file_pattern: "*.java"
    when: "writing implementation code", "adding new function/method"
```

**Example:**
- Opening `UserService.java` → Activates TDD skill, API design skill
- Opening `UserServiceTest.java` → Activates test-writing skill
- Opening `AuthController.java` → Activates security skill, API design skill

#### 2. Command Triggers

Skills activate when you run specific commands:

```yaml
triggers:
  - command: "/validation:code-review"
    when: "running code review", "reviewing pull request"
```

**Example:**
- Running `/validation:code-review` → Activates code-review skill
- Running `gh pr view` → Activates code-review skill

### Enforcement Behavior

When a skill activates, it:

1. **Analyzes the context** - What file are you working on? What are you doing?
2. **Checks compliance** - Does the code follow best practices?
3. **Provides guidance** - Real-time feedback on issues
4. **Enforces standards** - Blocks violations or suggests improvements

---

## Available Skills

### 1. Test-Driven Development Skill

**Location:** `.claude/skills/test-driven-development/SKILL.md`

**Activates when:**
- Writing implementation code (non-test files)
- File patterns: `*.java`, `*.ts`, `*.tsx`, `*.js`, `*.py`, `*.go`

**Enforces:**
- RED-GREEN-REFACTOR cycle
- Tests written BEFORE implementation
- Test exists for implementation
- Zero tolerance for code before tests

**Example:**
```javascript
// You start writing this in UserService.js
export function createUser(name, email) {
  // 🛑 SKILL ACTIVATES: "Write test FIRST!"
  // Skill checks: Does UserService.test.js exist?
  // If no: "STOP! Write test first (RED phase)"
}
```

---

### 2. Test Writing Skill

**Location:** `.claude/skills/test-writing/SKILL.md`

**Activates when:**
- Writing test code
- File patterns: `*.test.ts`, `*.test.js`, `*Test.java`, `*_test.go`, `test_*.py`

**Enforces:**
- Given-When-Then test structure
- Descriptive test names (`should...When...` pattern)
- Test independence (no shared state)
- Fast tests (< 100ms for unit tests)
- Edge case coverage

**Example:**
```javascript
// You write this test
test('user creation', () => {
  // 🧪 SKILL ACTIVATES: "Use better test name!"
  // Suggests: "shouldCreateUserWhenValidDataProvided"
  // Checks: Is there Given-When-Then structure?
});
```

---

### 3. API Design Skill

**Location:** `.claude/skills/api-design/SKILL.md`

**Activates when:**
- Creating API endpoints
- File patterns: `*Controller.java`, `*Router.ts`, `api/*.ts`, `routes/*.js`

**Enforces:**
- REST best practices (proper HTTP methods, status codes)
- DTO usage (NOT exposing entities)
- RESTful endpoint naming
- Proper error handling (400, 404, 500)
- Input validation on all endpoints
- Authentication/authorization on protected endpoints
- API documentation (OpenAPI/Swagger)

**Example:**
```java
// You write this in UserController.java
@PostMapping("/users")
public User createUser(@RequestBody User user) {
  // 🌐 SKILL ACTIVATES: "Entity exposed!"
  // Suggests: "Use CreateUserRequestDTO instead of User entity"
  // Checks: Is validation present? Are status codes correct?
}
```

---

### 4. Security Skill

**Location:** `.claude/skills/security/SKILL.md`

**Activates when:**
- Handling authentication, user data, sensitive information
- File patterns: `*Auth*.java`, `*User*.java`, `*Security*.java`

**Enforces:**
- Input validation on all user inputs
- SQL injection prevention (parameterized queries)
- XSS prevention (output encoding)
- CSRF protection on state-changing operations
- Secrets NOT committed (use environment variables)
- Proper password hashing (bcrypt, scrypt, Argon2)
- Authentication/authorization on protected resources
- No sensitive data logging (passwords, tokens, PII)

**Example:**
```java
// You write this in AuthService.java
public void saveUser(String username, String password) {
  user.setPassword(password); // Plain text!
  // 🔒 SKILL ACTIVATES: "Insecure password storage!"
  // Suggests: "Use BCrypt.hashpw(password, BCrypt.gensalt(12))"
}
```

---

### 5. Code Review Skill

**Location:** `.claude/skills/code-review/SKILL.md`

**Activates when:**
- Running code review commands
- Commands: `/validation:code-review`, `/code-review:code-review`, `gh pr view`

**Enforces:**
- TDD compliance (tests written before code)
- Test coverage ≥ 80%
- Security vulnerabilities (OWASP Top 10)
- Code follows project conventions
- Proper error handling
- Structured logging
- No code duplication (DRY principle)
- Appropriate abstraction level
- No technical debt (broken windows)
- Commit message follows conventional commits

**Example:**
```
You run: /validation:code-review

🔍 SKILL ACTIVATES: "Running systematic quality checks..."
- Checking TDD compliance...
- Checking test coverage...
- Checking security...
- Checking code conventions...
- [Generates comprehensive review report]
```

**Important:** This skill **complements** the `/validation:code-review` command:
- **Command**: Manual trigger for code review
- **Skill**: Auto-activates during review to enforce systematic checks
- **Result**: Best of both worlds (manual control + automatic enforcement)

---

## Skills vs Commands

### Key Differences

| Aspect | Skills | Commands |
|--------|--------|----------|
| **Invocation** | Automatic (file patterns, commands) | Manual (you invoke) |
| **Purpose** | Real-time enforcement | Execute workflows |
| **Triggers** | File types, commands | User request |
| **Example** | Opens `*.java` → TDD skill activates | `/piv_loop:execute` → Runs execution workflow |

### How They Work Together

**Example 1: Code Review Workflow**

```
1. You run: /validation:code-review
   ↓
2. Command triggers review workflow
   ↓
3. Code-review SKILL auto-activates
   ↓
4. Skill enforces systematic checks during review
   ↓
5. Result: Thorough review with automatic quality gates
```

**Example 2: Development Workflow**

```
1. You open: UserService.java
   ↓
2. TDD SKILL auto-activates
   ↓
3. Skill checks: Does test exist?
   ↓
4. If no: "Write test FIRST!"
   ↓
5. You write: UserServiceTest.java
   ↓
6. Test-writing SKILL auto-activates
   ↓
7. Skill checks: Is structure good?
   ↓
8. Result: High-quality test-driven code
```

### Code Review: BOTH Command AND Skill

**Command (`/validation:code-review`):**
- You manually invoke it
- Executes review workflow
- Generates review report

**Skill (auto-activates during review):**
- Auto-activates when command runs
- Enforces systematic quality checks
- Ensures nothing is missed

**Why both?**
- Command provides control and workflow
- Skill provides automatic enforcement
- Together: Comprehensive review with no manual effort

---

## Skill Activation Examples

### Example 1: Creating a New Endpoint

```java
// File: UserController.java (NEW FILE)

@RestController
@RequestMapping("/api/users")
public class UserController {

  @PostMapping
  public User create(@RequestBody User user) {
    // As soon as you type this...
  }
}
```

**Skills that activate:**
1. **TDD skill** → "Write test FIRST!"
2. **API design skill** → "Use DTO, not entity!"
3. **Security skill** → "Add validation!"

**Result:** You're guided to write correct code from the start.

---

### Example 2: Writing Tests

```javascript
// File: user.service.test.js

test('creates user', () => {
  // As soon as you type this...
});
```

**Skills that activate:**
1. **Test-writing skill** → "Use better name: shouldCreateUserWhenValidDataProvided"
2. **Test-writing skill** → "Add Given-When-Then structure"

**Result:** Better test quality.

---

### Example 3: Running Code Review

```bash
$ /validation:code-review
```

**Skills that activate:**
1. **Code-review skill** → Auto-activates to enforce systematic checks

**Result:**
- TDD compliance checked
- Test coverage verified
- Security issues identified
- Code conventions verified
- [Comprehensive report generated]

---

## Customizing Skills

### How to Modify Skills

Each skill is defined in a `SKILL.md` file:

```
.claude/skills/
├── test-driven-development/
│   └── SKILL.md
├── test-writing/
│   └── SKILL.md
├── api-design/
│   └── SKILL.md
├── security/
│   └── SKILL.md
└── code-review/
    └── SKILL.md
```

**To customize a skill:**

1. **Open the SKILL.md file**
2. **Modify triggers** (file patterns, commands, when conditions)
3. **Adjust enforcement behavior** (what checks to perform)
4. **Save** the file

**Example: Customize TDD skill to exclude DTOs**

```yaml
# .claude/skills/test-driven-development/SKILL.md

triggers:
  - file_pattern: "*.java"
    when: "writing implementation code"
    # ADD THIS EXCEPTION:
    exclude: "*DTO.java"  # Don't enforce TDD for pure DTOs
```

### How to Disable Skills

**Option 1: Disable specific skill temporarily**

Rename the SKILL.md file:
```bash
mv .claude/skills/test-driven-development/SKILL.md \
   .claude/skills/test-driven-development/SKILL.md.disabled
```

**Option 2: Disable all skills temporarily**

Rename the skills directory:
```bash
mv .claude/skills .claude/skills.disabled
```

**Option 3: Remove specific triggers**

Edit the SKILL.md file and remove unwanted triggers:
```yaml
# Remove this trigger if you don't want skill for Python files
# - file_pattern: "*.py"
#   when: "writing implementation code"
```

---

## Creating New Skills

### Skill Template

To create a new skill:

1. **Create directory:**
   ```bash
   mkdir -p .claude/skills/your-skill-name
   ```

2. **Create SKILL.md:**
   ```bash
   touch .claude/skills/your-skill-name/SKILL.md
   ```

3. **Use this template:**

   ```yaml
   ---
   description: Brief description of what this skill enforces
   triggers:
     - file_pattern: "*.file-extension"
       when: "what you're doing"
     - command: "/some-command"
       when: "when command runs"
   ---

   # Skill Name

   ## Activation

   This skill activates when:
   - [List activation conditions]

   ## Enforcement

   **What this skill enforces:**

   ### 1. Check Name
   Description of check

   **If violation:**
   ```
   Error message and remediation steps
   ```

   ## Behavior

   When this skill activates:
   1. First check
   2. Second check
   3. Third check

   ## Checklist

   - [ ] Check 1
   - [ ] Check 2
   - [ ] Check 3

   ## Resources

   **See Also:**
   - [Related documentation]

   **Learn More:**
   - [External resources]
   ```

4. **Save and test** - Skill will auto-activate based on triggers

---

## Troubleshooting

### Skills Not Activating

**Problem:** Skill isn't activating when it should.

**Solutions:**

1. **Check file pattern** - Is the file pattern correct?
   ```bash
   # Does the pattern match your file?
   ls -la *.java  # Check if pattern works
   ```

2. **Check skill exists** - Is SKILL.md in the right location?
   ```bash
   ls -la .claude/skills/your-skill/SKILL.md
   ```

3. **Check skill not disabled** - Is file named `SKILL.md.disabled`?
   ```bash
   # Rename back to enable
   mv .claude/skills/your-skill/SKILL.md.disabled \
      .claude/skills/your-skill/SKILL.md
   ```

4. **Check YAML syntax** - Is the YAML front matter valid?
   ```bash
   # Validate YAML
   cat .claude/skills/your-skill/SKILL.md
   ```

### False Positives

**Problem:** Skill activates when it shouldn't.

**Solutions:**

1. **Adjust triggers** - Make file patterns more specific
   ```yaml
   # Too broad
   file_pattern: "*.java"

   # More specific
   file_pattern: "*Controller.java"
   ```

2. **Add exclusions** - Exclude specific patterns
   ```yaml
   triggers:
     - file_pattern: "*.java"
       when: "writing implementation code"
       exclude:
         - "*DTO.java"
         - "*Config.java"
   ```

### Skill Too Aggressive

**Problem:** Skill blocks legitimate work.

**Solutions:**

1. **Tune enforcement** - Make skill more lenient
   - Change hard blocks to warnings
   - Add exceptions for valid use cases

2. **Provide overrides** - Allow explicit override
   ```yaml
   # In SKILL.md
   **Exception:**
   If you have a valid reason to skip TDD (e.g., interface definition),
   explicitly document it in code:
   // TDD-EXEMPT: Interface definition (no implementation)
   ```

---

## Best Practices

### 1. Skill Triggers

**Do:**
- ✅ Use specific file patterns (`*Controller.java`, not `*.java`)
- ✅ Combine file patterns with `when` conditions
- ✅ Test triggers work as expected

**Don't:**
- ❌ Use overly broad patterns (too many activations)
- ❌ Duplicate triggers across skills

### 2. Enforcement Behavior

**Do:**
- ✅ Provide clear feedback (what's wrong, how to fix)
- ✅ Be specific (file:line, exact issue)
- ✅ Suggest concrete improvements

**Don't:**
- ❌ Be vague ("fix this code")
- ❌ Over-enforce (block legitimate work)
- ❌ Overwhelm (too many checks at once)

### 3. Skill Design

**Do:**
- ✅ Focus on one domain per skill
- ✅ Keep skills focused and maintainable
- ✅ Document clearly what skill does

**Don't:**
- ❌ Create god skill (does everything)
- ❌ Mix unrelated checks in one skill

---

## Summary

The Skills System provides:

1. **Real-time Enforcement** - Catch issues during development
2. **Automatic Activation** - No manual invocation needed
3. **Context-Aware** - Right skill for right file type
4. **Complementary to Commands** - Skills enhance, don't replace
5. **Customizable** - Modify SKILL.md files as needed

**Available Skills:**
- 🧪 Test-Driven Development - Enforces RED-GREEN-REFACTOR
- 📝 Test Writing - Enforces Given-When-Then structure
- 🌐 API Design - Enforces REST best practices
- 🔒 Security - Enforces security checks
- 🔍 Code Review - Systematic quality checks

**See Also:**
- [Strict TDD Documentation](strict-tdd.md)
- [Commit Commands Integration](commit-commands-integration.md)
- [PIV Methodology](../.claude/PIV-METHODOLOGY.md)
