---
description: Enforces strict Test-Driven Development (RED-GREEN-REFACTOR cycle) when writing implementation code
triggers:
  - file_pattern: "*.java"
    when: "writing implementation code", "adding new function/method", "modifying business logic"
  - file_pattern: "*.ts"
    when: "writing implementation code", "adding new function/method", "modifying business logic"
  - file_pattern: "*.tsx"
    when: "writing implementation code", "adding new function/method", "modifying business logic"
  - file_pattern: "*.js"
    when: "writing implementation code", "adding new function/method", "modifying business logic"
  - file_pattern: "*.py"
    when: "writing implementation code", "adding new function/method", "modifying business logic"
  - file_pattern: "*.go"
    when: "writing implementation code", "adding new function/method", "modifying business logic"
---

# Test-Driven Development Skill

## Activation

This skill activates when:
- Writing implementation code (non-test files)
- Adding new function/method
- Modifying business logic
- Creating new classes/modules

**Does NOT activate for:**
- Test files (`*.test.ts`, `*.test.js`, `*Test.java`, `*_test.go`, etc.)
- Configuration files
- Documentation files

## Enforcement

**🚨 STRICT TDD ENFORCEMENT:**

### Before Writing ANY Implementation Code

**Step 1: CHECK Test Exists (RED Phase)**

Ask yourself:
- Does a test file exist for the code I'm about to write?
- Does the test specifically test the behavior I'm about to implement?

**If NO test exists:**
```
🛑 STOP! DO NOT WRITE IMPLEMENTATION CODE!

Write the test FIRST:
1. Create test file (if it doesn't exist)
2. Write test that FAILS (RED phase)
3. Run test to verify it FAILS
4. THEN write implementation code (GREEN phase)
```

**Step 2: VERIFY Test Fails (RED Phase)**

- Run the test to verify it FAILS
- If test passes → You're missing test logic, fix the test first
- If test fails → GOOD! Proceed to GREEN phase

**Step 3: Implement Code (GREEN Phase)**

- Write MINIMAL code to make the test pass
- Run test again to verify it PASSES
- If test fails → Fix implementation until test passes

**Step 4: Refactor (REFACTOR Phase)**

- Improve code while keeping tests green
- Run tests again to ensure nothing broke
- If tests break → Fix refactor or revert

## Behavior

When this skill activates:

### 1. Check for Test File Existence

```
For implementation file: src/service/UserService.java
Check for test file: test/service/UserServiceTest.java
```

If test file doesn't exist:
- **STOP immediately**
- Instruct: "Write test FIRST (RED phase)"
- Do not proceed until test file exists

### 2. Verify Test Written Before Implementation

Check git history or file modification times:
- If test file created AFTER implementation file → **TDD VIOLATION**
- Delete implementation code
- Instruct: "Start over with TDD cycle (test first, then implement)"

### 3. Verify Test Follows Given-When-Then Pattern

Check test structure:
- **GIVEN**: Test data and preconditions
- **WHEN**: Action being tested
- **THEN**: Expected outcomes

If test doesn't follow Given-When-Then:
- Remind about test-writing skill
- Suggest test structure improvement

### 4. Verify Test Fails First (RED Phase)

Ask: "Did you run the test before implementing to verify it FAILS?"

If test never ran in failing state:
- Remind: "RED phase requires test to FAIL first"
- "Run test, verify it FAILS, then implement"

### 5. Enforce Zero Tolerance

If code written before test:
```
🚨 TDD VIOLATION DETECTED

Implementation file: [filename]
Test file: [missing or created after implementation]

ACTION REQUIRED:
1. DELETE implementation code
2. Write test FIRST (RED phase)
3. Run test to verify it FAILS
4. Implement code to make test PASS (GREEN phase)
5. Refactor while keeping tests green (REFACTOR phase)

TDD is non-negotiable. No exceptions.
```

## Examples

### ✅ GOOD TDD Flow

```javascript
// Step 1: Write FAILING test (RED)
// test/service/calculator.test.js
test('should add two numbers', () => {
  // GIVEN
  const calc = new Calculator();

  // WHEN
  const result = calc.add(2, 3);

  // THEN
  expect(result).toBe(5);
});

// Run test → FAILS ✅ (Calculator.add doesn't exist yet)

// Step 2: Write MINIMAL implementation (GREEN)
// src/service/calculator.js
class Calculator {
  add(a, b) {
    return a + b;
  }
}

// Run test → PASSES ✅

// Step 3: Refactor if needed (REFACTOR)
// Keep tests green while improving code
```

### ❌ BAD: Code Before Test

```javascript
// BAD: Implementation written first
// src/service/calculator.js
class Calculator {
  add(a, b) {
    return a + b;
  }
}

// THEN test written AFTER (NOT TDD!)
// test/service/calculator.test.js
test('should add two numbers', () => {
  expect(new Calculator().add(2, 3)).toBe(5);
});

// 🚨 TDD VIOLATION! Code written before test.
// SOLUTION: Delete code, start over with test first.
```

## Triggers by File Type

| File Pattern | Test File Pattern | Example |
|--------------|-------------------|---------|
| `*.java` | `*Test.java`, `*IT.java` | `UserService.java` → `UserServiceTest.java` |
| `*.ts` | `*.test.ts` | `calculator.ts` → `calculator.test.ts` |
| `*.tsx` | `*.test.tsx` | `Button.tsx` → `Button.test.tsx` |
| `*.js` | `*.test.js` | `utils.js` → `utils.test.js` |
| `*.py` | `test_*.py`, `*_test.py` | `calculator.py` → `test_calculator.py` |
| `*.go` | `*_test.go` | `calculator.go` → `calculator_test.go` |

## Special Cases

### Interface/Abstract Class Definitions

For interfaces or abstract classes (no implementation):
- **TDD not required** for interface definition itself
- **TDD REQUIRED** for first implementing class

Example:
```java
// Interface definition (OK without test)
public interface Calculator {
  int add(int a, int b);
}

// Implementation REQUIRES test first
public class BasicCalculator implements Calculator {
  // TDD violation if written before test!
}
```

### Data Transfer Objects (DTOs)

For simple DTOs (getters/setters, no logic):
- **TDD not required** for pure data holders
- **TDD REQUIRED** if DTO has validation logic

Example:
```java
// Pure DTO (OK without test)
public class UserDTO {
  private String name;
  // getters/setters
}

// DTO with validation (REQUIRES test)
public class UserDTO {
  public void setName(String name) {
    if (name == null || name.isEmpty()) {
      throw new IllegalArgumentException(); // Logic requires test!
    }
  }
}
```

### Configuration Files

Configuration files (application.properties, .env, etc.):
- **TDD not required**
- Not implementation code

## Anti-Patterns to Watch For

### ❌ "I'll add tests later"

**Problem:** Writing code now, promising to add tests "later"

**Consequence:** Later never comes. Technical debt accumulates.

**Enforcement:**
- Stop immediately
- "Write test NOW, not later"
- "TDD means test FIRST, not after"

### ❌ "It's just a simple function"

**Problem:** Skipping TDD for "simple" code

**Consequence:** Even simple code has edge cases

**Enforcement:**
- "No exceptions for 'simple' code"
- "If it's worth writing, it's worth testing first"
- "Simple code = Simple test, still write it"

### ❌ "I know it works, don't need to test"

**Problem:** Overconfidence, skipping RED phase

**Consequence:** Missed edge cases, brittle code

**Enforcement:**
- "RED phase requires test to FAIL first"
- "Run test before implementing to verify it fails"
- "Tests document behavior, not just verify correctness"

## Checklist

Before writing implementation code:

- [ ] Test file exists for this implementation
- [ ] Test was written BEFORE implementation code
- [ ] Test follows Given-When-Then pattern
- [ ] Test was run and FAILED (RED phase) ✅
- [ ] Implementation written AFTER failing test (GREEN phase)
- [ ] Tests still pass after refactoring (REFACTOR phase)

**If any checklist item fails:**
- **STOP** writing implementation
- **FIX** TDD violation
- **THEN** proceed with implementation

## Resources

**See Also:**
- `.claude/rules/22-tdd-strict.md` - Strict TDD rules
- `.claude/skills/test-writing/SKILL.md` - Test writing enforcement
- `.claude/commands/piv_loop/execute.md` - TDD in execution workflow

**Learn More:**
- [Test-Driven Development by Kent Beck](https://www.amazon.com/Test-Driven-Development-Kent-Beck/dp/0321146530)
- [PIV Methodology - TDD Section](.claude/PIV-METHODOLOGY.md)
