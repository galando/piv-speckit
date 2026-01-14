# Strict TDD Enforcement

**Mandatory Test-Driven Development across all PIV projects**

---

## Overview

This skeleton enforces **strict Test-Driven Development (TDD)** as a non-negotiable practice. All code must follow the RED-GREEN-REFACTOR cycle with zero exceptions.

### What is TDD?

Test-Driven Development is a development practice where:

1. **RED** - Write a FAILING test first (before any implementation)
2. **GREEN** - Write MINIMAL code to make the test pass
3. **REFACTOR** - Improve code while keeping tests green

### Why Strict TDD?

**Benefits:**
- ✅ **Better Design** - Tests force you to think about API design first
- ✅ **Fewer Bugs** - Tests catch bugs before they reach production
- ✅ **Living Documentation** - Tests show how code is supposed to work
- ✅ **Refactor Confidence** - Tests ensure refactors don't break behavior
- ✅ **Faster Development** - Less time debugging, more time building
- ✅ **Code Quality** - Tests drive code toward better design

**Zero Tolerance:**
- ❌ No code before tests (ever)
- ❌ No "simple code" exceptions
- ❌ No "I'll add tests later"
- ❌ No "just this once"

---

## RED-GREEN-REFACTOR Cycle

### 1. RED Phase - Write Failing Test

**Write the test FIRST, before any implementation:**

```javascript
// Calculator.test.js
test('should add two numbers', () => {
  // GIVEN
  const calc = new Calculator();

  // WHEN
  const result = calc.add(2, 3);

  // THEN
  expect(result).toBe(5);
});
```

**Run the test → Verify it FAILS**

```
$ npm test

FAIL Calculator.test.js
  Calculator
    ✕ should add two numbers

  ReferenceError: Calculator is not defined

Tests:       1 failed, 1 total
```

**Why verify it fails?**
- Ensures test actually tests something
- Confirms test logic is correct
- Prevents false positives (test that always passes)

### 2. GREEN Phase - Make Test Pass

**Write MINIMAL code to make the test pass:**

```javascript
// Calculator.js
class Calculator {
  add(a, b) {
    return a + b; // Minimal implementation
  }
}
```

**Run the test → Verify it PASSES**

```
$ npm test

PASS Calculator.test.js
  Calculator
    ✓ should add two numbers

Tests:       1 passed, 1 total
```

**Why minimal code?**
- Don't worry about code quality yet
- Just make the test pass
- Keep it simple

### 3. REFACTOR Phase - Improve Code

**Improve code while keeping tests green:**

```javascript
// Calculator.js (after refactor)
class Calculator {
  // Extract validation as separate method
  add(a, b) {
    this.validateNumbers(a, b);
    return a + b;
  }

  validateNumbers(a, b) {
    if (typeof a !== 'number' || typeof b !== 'number') {
      throw new TypeError('Both arguments must be numbers');
    }
  }
}
```

**Run tests again → Verify STILL PASS**

```
$ npm test

PASS Calculator.test.js
  Calculator
    ✓ should add two numbers
    ✓ should throw error for non-numbers (new test!)

Tests:       2 passed, 2 total
```

**Why refactor?**
- Improve code quality
- Remove duplication
- Add missing validation
- Tests ensure nothing breaks

---

## Zero Tolerance Policy

### What is Prohibited

❌ **NEVER** write implementation code before tests
❌ **NEVER** write tests after code (that's NOT TDD)
❌ **NEVER** skip TDD for "simple" code
❌ **NEVER** say "I'll add tests later"
❌ **NEVER** commit code without tests

### Consequences

**If you write code before tests:**

1. **Code WILL BE DELETED** - No exceptions
2. **Start over** - Write test first (RED)
3. **Implement** - Make test pass (GREEN)
4. **Refactor** - Improve while tests pass (REFACTOR)

### Examples

#### ❌ ANTI-PATTERN: Code Before Test

```javascript
// Implementation written first
function calculateDiscount(price) {
  return price * 0.9;
}

// Test written AFTER (NOT TDD!)
test('discounts price', () => {
  expect(calculateDiscount(100)).toBe(90);
});
```

**Problem:** This is NOT TDD. Tests become validation, not design.

#### ✅ GOOD PATTERN: Test Before Code

```javascript
// Test written FIRST (RED)
test('should calculate 10% discount', () => {
  expect(calculateDiscount(100)).toBe(90);
});

// Run test → FAILS ✅ (function doesn't exist)

// Implementation written AFTER test (GREEN)
function calculateDiscount(price) {
  return price * 0.9;
}

// Run test → PASSES ✅

// Refactor if needed (REFACTOR)
```

---

## Enforcement Mechanisms

### 1. Skills System

**Auto-activating behaviors enforce TDD while you code:**

#### TDD Skill
- **Activates when:** Writing implementation code (non-test files)
- **Enforcement:**
  - Checks if test file exists
  - Verifies test written BEFORE implementation
  - Blocks code written before tests
  - Enforces RED-GREEN-REFACTOR cycle

#### Test-Writing Skill
- **Activates when:** Writing test files
- **Enforcement:**
  - Enforces Given-When-Then structure
  - Verifies test is descriptive
  - Checks test is independent and fast

### 2. Validation Pipeline

**Automatic validation FAILS if TDD violations detected:**

```bash
$ /validation:validate

Level 2.5: TDD Compliance Check

❌ TDD VIOLATION DETECTED

Implementation file: src/service/UserService.java
Test file: DOES NOT EXIST or was created AFTER implementation

REQUIRED ACTION:
1. DELETE implementation code
2. Write test FIRST (RED phase)
3. Run test to verify it FAILS
4. Implement code to make test PASS (GREEN phase)
5. Refactor while keeping tests green (REFACTOR phase)

Validation BLOCKED until TDD compliance achieved.
```

### 3. Code Review

**Code review rejects code written before tests:**

- Reviews test implementation for quality
- Verifies RED-GREEN-REFACTOR cycle was followed
- Checks test coverage ≥ 80%
- Rejects changes that don't follow TDD

### 4. Git Workflow

**Commits happen AFTER phases (with passing tests):**

```
1. Plan Phase → /commit "plan: [feature]"
2. Implement Phase (TDD verified) → /commit "feat: [feature]"
3. Validate Phase → /commit "chore: fixes" (if needed)
```

---

## Examples

### Example 1: Simple Function

**Step 1: RED - Write Failing Test**

```javascript
test('should calculate total with tax', () => {
  // GIVEN
  const price = 100;
  const taxRate = 0.1;

  // WHEN
  const total = calculateTotal(price, taxRate);

  // THEN
  expect(total).toBe(110);
});
```

**Run test → FAILS** ✅

**Step 2: GREEN - Write Minimal Implementation**

```javascript
function calculateTotal(price, taxRate) {
  return price + (price * taxRate);
}
```

**Run test → PASSES** ✅

**Step 3: REFACTOR - Improve Code**

```javascript
function calculateTax(amount, rate) {
  return amount * rate;
}

function calculateTotal(price, taxRate) {
  return price + calculateTax(price, taxRate);
}
```

**Run tests → STILL PASS** ✅

---

### Example 2: Class Method

**Step 1: RED - Write Failing Test**

```java
@Test
public void shouldReturnUserWhenIdIsValid() {
    // GIVEN
    String userId = "user-123";
    UserRepository repository = mock(UserRepository.class);
    UserService service = new UserService(repository);

    // WHEN
    User result = service.findById(userId);

    // THEN
    assertNotNull(result);
    assertEquals(userId, result.getId());
}
```

**Run test → FAILS** ✅

**Step 2: GREEN - Write Minimal Implementation**

```java
public User findById(String userId) {
    return repository.findById(userId)
        .orElseThrow(() -> new NotFoundException("User not found"));
}
```

**Run test → PASSES** ✅

**Step 3: REFACTOR - Improve Code**

```java
public User findById(String userId) {
    return cache.get(userId, () -> repository.findById(userId)
        .orElseThrow(() -> new NotFoundException("User not found")));
}
```

**Run tests → STILL PASS** ✅

---

## Common TDD Mistakes

### ❌ Mistake 1: "It's Just a Simple Function"

**Problem:** Skipping TDD for "simple" code

```javascript
// "This is just a getter, I don't need a test"
getName() {
  return this.name;
}
```

**Consequence:** Even simple code has edge cases

**Solution:** Write test first

```javascript
test('should return name when set', () => {
  const user = new User();
  user.name = 'John';
  expect(user.getName()).toBe('John');
});

test('should return empty string when name not set', () => {
  const user = new User();
  expect(user.getName()).toBe('');
});
```

### ❌ Mistake 2: "I'll Add Tests Later"

**Problem:** Writing code now, promising to add tests "later"

**Consequence:** Later never comes. Technical debt accumulates.

**Solution:** Write test NOW

```javascript
// Write test NOW, not later
test('should validate email format', () => {
  expect(validateEmail('test@example.com')).toBe(true);
  expect(validateEmail('invalid')).toBe(false);
});
```

### ❌ Mistake 3: Test Passes Immediately

**Problem:** Test passes on first run without any implementation

```javascript
// Bad: Test passes immediately (broken test)
test('creates user', () => {
  const user = new User(); // Test passes? Test is broken!
});
```

**Consequence:** Test is broken or not testing anything

**Solution:** Verify test FAILS first

```javascript
// Good: Test FAILS first (RED phase)
test('should create user with valid data', () => {
  const user = createUser({ name: 'John', email: 'john@example.com' });
  expect(user).toBeDefined();
  expect(user.id).toBeDefined(); // This fails! ✅ Good RED phase
});

// THEN implement to make it pass (GREEN)
```

---

## Migration Guide

### Adopting TDD in Existing Projects

**Challenge:** Legacy code has no tests

**Strategy:**

1. **Start New Features with TDD**
   - All NEW code must follow TDD
   - Don't retrofit old code immediately

2. **Add Tests When Modifying**
   - Before fixing bug: Write test that reproduces bug
   - Before adding feature: Write test for new behavior
   - Follow TDD for the change

3. **Gradual Legacy Coverage**
   - Add tests for critical paths first
   - Focus on high-risk areas
   - Don't aim for 100% coverage immediately

**Example: Adding Feature to Legacy Code**

```javascript
// Legacy code (no tests)
function processOrder(order) {
  // Old code, no tests
}

// NEW: Add discount feature (WITH TDD)

// Step 1: Write test FIRST (RED)
test('should apply discount when order total exceeds threshold', () => {
  const order = { total: 150, discount: 0 };
  processOrder(order);
  expect(order.discount).toBe(0.1); // 10% discount
});

// Step 2: Implement feature (GREEN)
function processOrder(order) {
  // ... existing code ...
  if (order.total > 100) {
    order.discount = 0.1;
  }
}

// Step 3: Refactor if needed (REFACTOR)
// ...
```

---

## Checklist

### Before Writing Implementation Code

- [ ] Test file exists for implementation I'm about to write
- [ ] Test was written BEFORE implementation code
- [ ] Test follows Given-When-Then pattern
- [ ] Test was run and FAILED (RED phase) ✅
- [ ] Only THEN write implementation (GREEN phase)
- [ ] Tests still pass after refactoring (REFACTOR phase)

**If any checklist item fails:**
- **STOP** writing implementation
- **FIX** TDD violation
- **THEN** proceed

---

## Resources

### Internal Documentation

- `.claude/rules/22-tdd-strict.md` - Strict TDD rules
- `.claude/PIV-METHODOLOGY.md` - TDD in PIV methodology
- `.claude/skills/test-driven-development/SKILL.md` - TDD enforcement skill
- `.claude/skills/test-writing/SKILL.md` - Test quality enforcement

### External Resources

- [Test-Driven Development by Kent Beck](https://www.amazon.com/Test-Driven-Development-Kent-Beck/dp/0321146530)
- [The Pragmatic Programmer](https://www.amazon.com/Pragmatic-Programmer-journey-mastery/dp/020161622X)
- [Given-When-Then Pattern](https://martinfowler.com/bliki/GivenWhenThen.html)

### Training

- Practice TDD on small features first
- Start with simple functions
- Gradually tackle more complex features
- Review test coverage regularly

---

## Summary

**Strict TDD is NON-NEGOTIABLE:**

1. **TEST FIRST** - Always write failing test before implementation
2. **MINIMAL CODE** - Write just enough to make test pass
3. **REFACTOR** - Improve code while keeping tests green
4. **ZERO EXCEPTIONS** - No "simple code", no "just this once"

**Enforcement:**
- Skills auto-activate while you code
- Validation FAILS without TDD compliance
- Code review rejects violations
- Git workflow commits after phases

**If you violate TDD:**
- Code WILL BE DELETED
- Start over with test first
- Follow RED-GREEN-REFACTOR cycle

**Remember: Tests first, implementation second, refactor third. Always.**
