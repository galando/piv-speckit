# Strict TDD Rules

**MANDATORY Test-Driven Development rules applicable to ALL projects**

---

## Core TDD Principles

### The RED-GREEN-REFACTOR Cycle (MANDATORY)

**ALL code MUST follow this cycle without exception:**

#### 1. RED Phase - Write a Failing Test
- **Write the test FIRST**, before any implementation code
- **Run the test** to verify it FAILS (RED)
- **If test passes**, you're missing test logic (fix the test first)
- **NO implementation code** until test is written and failing

#### 2. GREEN Phase - Make the Test Pass
- **Write MINIMAL code** to make the test pass
- **Run the test** to verify it PASSES (GREEN)
- **Don't worry about code quality** yet (that comes next)
- **ONLY implement** what the test requires

#### 3. REFACTOR Phase - Improve the Code
- **Improve code** while keeping tests green
- **Run tests again** to ensure nothing broke
- **If tests break**, fix refactor or revert
- **Repeat** until code is clean

### Core Principles

1. **Tests First, Always** - No code before tests, ever
2. **Minimal Implementation** - Just enough to make the test pass
3. **Continuous Refactoring** - Improve code while tests pass
4. **Baby Steps** - One test, one implementation, one refactor at a time
5. **Zero Exceptions** - No "simple code", no "just this once"

---

## Zero Tolerance Policy

### What is Prohibited

❌ **NEVER** write implementation code before tests
❌ **NEVER** write tests after code (that's NOT TDD)
❌ **NEVER** skip TDD for "simple" code (no exceptions)
❌ **NEVER** say "I'll add tests later" (later never comes)
❌ **NEVER** write "TODO: add tests" (write them NOW)
❌ **NEVER** commit code without tests

### Consequences of Violation

**If you write code before tests:**

1. **Code WILL BE DELETED** - No exceptions
2. **Start over** - Write test first, then implement
3. **Repeat cycle** - Follow RED-GREEN-REFACTOR correctly
4. **Learn from mistake** - TDD saves time in the long run

**No negotiation, no "just this once", no "it's just a small change."**

---

## Enforcement Mechanisms

### 1. Skills System (Real-time)

**Auto-activating behaviors enforce TDD while you code:**

- **test-driven-development skill** - Activates when writing implementation code
  - Checks if test file exists
  - Verifies test was written BEFORE implementation
  - Enforces RED-GREEN-REFACTOR cycle
  - Deletes code written before tests

- **test-writing skill** - Activates when writing test files
  - Enforces Given-When-Then pattern
  - Verifies test structure and clarity
  - Checks test is independent and fast

### 2. Validation Pipeline (Hard Stop)

**TDD compliance validation FAILS immediately if violations detected:**

- Checks implementation files have corresponding test files
- Verifies tests were created BEFORE implementation (via git history)
- Fails validation if TDD violations found
- Blocks commit until TDD compliance achieved

### 3. Code Review (Quality Gate)

**Code review rejects code written before tests:**

- Reviews test implementation for quality
- Verifies RED-GREEN-REFACTOR cycle was followed
- Checks test coverage is ≥ 80%
- Rejects changes that don't follow TDD

### 4. Git Workflow (Commit Discipline)

**Commits happen after phases (with passing tests):**

- Plan phase → Commit plan
- Implement phase → Commit implementation + tests (TDD verified)
- Validate phase → Commit validation fixes (if needed)

**One commit per phase**, not per task, not at end.

---

## What to Do When You Violate TDD

### Scenario 1: You Wrote Code Before Test

**STOP immediately.**

1. **Delete** the implementation code
2. **Write** the test first (RED)
3. **Run** test to verify it fails
4. **Implement** minimal code to pass (GREEN)
5. **Refactor** while keeping tests green (REFACTOR)

### Scenario 2: Test Doesn't Fail (RED Phase Problem)

**Your test is broken.**

1. **Check** test logic - is it actually testing anything?
2. **Verify** test is calling the code under test
3. **Ensure** test assertions are correct
4. **Run** test again to verify it FAILS
5. **Then** proceed to GREEN phase

### Scenario 3: Can't Make Test Pass (GREEN Phase Problem)

**Step back and think.**

1. **Review** test - is it too complex?
2. **Simplify** - break into smaller tests
3. **Implement** one small piece at a time
4. **Run** frequently to see progress
5. **Don't** write entire feature at once

### Scenario 4: Refactor Breaks Tests (REFACTOR Phase Problem)

**Refactor is too aggressive.**

1. **Revert** refactor (git checkout or undo)
2. **Smaller steps** - refactor in smaller increments
3. **Run tests** after each small change
4. **Stop** when tests still pass
5. **Continue** with next small refactor

---

## Anti-Patterns

### ❌ Anti-Pattern 1: Writing Tests After Code

**Problem:**
```javascript
// Implementation written first
function calculateDiscount(price) {
  return price * 0.9;
}

// Test written AFTER implementation (NOT TDD)
test('discounts price', () => {
  expect(calculateDiscount(100)).toBe(90);
});
```

**Consequence:** This is NOT TDD. Tests become validation, not design.

**Solution:**
```javascript
// Test written FIRST (RED)
test('discounts price by 10%', () => {
  expect(calculateDiscount(100)).toBe(90);
});

// Run test → FAILS (RED) ✅

// Implementation written AFTER test (GREEN)
function calculateDiscount(price) {
  return price * 0.9;
}

// Run test → PASSES (GREEN) ✅

// Refactor if needed (REFACTOR)
```

### ❌ Anti-Pattern 2: Skipping TDD for "Simple" Code

**Problem:**
```javascript
// "This is just a getter, I don't need a test"
getName() {
  return this.name;
}
```

**Consequence:** Even simple code has edge cases. What if `name` is undefined?

**Solution:**
```javascript
// Test FIRST (RED)
test('should return name when set', () => {
  const user = new User();
  user.name = 'John';
  expect(user.getName()).toBe('John');
});

test('should return empty string when name not set', () => {
  const user = new User();
  expect(user.getName()).toBe('');
});

// Implementation AFTER test (GREEN)
getName() {
  return this.name || '';
}
```

### ❌ Anti-Pattern 3: "I'll Add Tests Later"

**Problem:** Writing code now, promising to add tests "later."

**Consequence:** Later never comes. Tests never get written. Technical debt accumulates.

**Solution:**
- **Write test NOW** - No excuses
- **Test FIRST** - Always
- **No code without tests** - Zero tolerance

### ❌ Anti-Pattern 4: Test Passes Immediately (Missing RED Phase)

**Problem:** Test passes on first run without any implementation.

**Consequence:** Test is broken or not actually testing anything.

**Solution:**
```javascript
// Bad: Test passes immediately (broken test)
test('creates user', () => {
  const user = new User(); // Test passes? Test is broken!
});

// Good: Test FAILS first (RED phase)
test('should create user with valid data', () => {
  const user = createUser({ name: 'John', email: 'john@example.com' });
  expect(user).toBeDefined();
  expect(user.id).toBeDefined(); // This fails! ✅ Good RED phase
});

// THEN implement to make it pass (GREEN)
```

---

## Good TDD Examples

### ✅ Example 1: Simple Function

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

**Run test → FAILS** ✅ (function doesn't exist yet)

**Step 2: GREEN - Write Minimal Implementation**
```javascript
function calculateTotal(price, taxRate) {
  return price + (price * taxRate);
}
```

**Run test → PASSES** ✅

**Step 3: REFACTOR - Improve Code (if needed)**
```javascript
// Maybe extract tax calculation as separate function?
function calculateTax(amount, rate) {
  return amount * rate;
}

function calculateTotal(price, taxRate) {
  return price + calculateTax(price, taxRate);
}
```

**Run tests → STILL PASS** ✅

### ✅ Example 2: Class Method

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

**Run test → FAILS** ✅ (method doesn't exist yet)

**Step 2: GREEN - Write Minimal Implementation**
```java
public User findById(String userId) {
    return repository.findById(userId)
        .orElseThrow(() -> new NotFoundException("User not found"));
}
```

**Run test → PASSES** ✅

**Step 3: REFACTOR - Improve Code (if needed)**
```java
// Maybe add caching?
public User findById(String userId) {
    return cache.get(userId, () -> repository.findById(userId)
        .orElseThrow(() -> new NotFoundException("User not found")));
}
```

**Run tests → STILL PASS** ✅

---

## TDD Workflow Summary

### The Never-Break Cycle

```
┌─────────────────────────────────────────────────────────┐
│                                                         │
│  1. WRITE TEST (RED)                                    │
│     ├─ Write test for ONE small piece of behavior      │
│     ├─ Run test → Verifies it FAILS                    │
│     └─ If test passes, fix test (it's broken)          │
│                                                         │
│  2. IMPLEMENT (GREEN)                                  │
│     ├─ Write MINIMAL code to make test pass            │
│     ├─ Run test → Verifies it PASSES                   │
│     └─ Don't worry about quality yet                   │
│                                                         │
│  3. REFACTOR                                            │
│     ├─ Improve code while tests stay green             │
│     ├─ Run tests → Verify STILL PASS                   │
│     └─ If tests break, fix or revert refactor          │
│                                                         │
│  REPEAT for next small piece of behavior               │
│                                                         │
└─────────────────────────────────────────────────────────┘
```

### Key Points

- **Baby steps** - One small test at a time
- **Minimal code** - Just enough to pass the test
- **Continuous refactoring** - Always improving while tests pass
- **Never skip phases** - RED → GREEN → REFACTOR, always in order
- **Zero exceptions** - No code before tests, ever

---

## Benefits of Strict TDD

### Why Enforce TDD?

1. **Better Design** - Tests force you to think about API design first
2. **Fewer Bugs** - Tests catch bugs before they reach production
3. **Living Documentation** - Tests show how code is supposed to work
4. **Refactor Confidence** - Tests ensure refactors don't break behavior
5. **Faster Development** - Less time debugging, more time building
6. **Code Quality** - Tests drive code toward better design

### Long-Term Impact

- **Reduced Technical Debt** - No "I'll add tests later" accumulation
- **Easier Maintenance** - Tests make code changes safer
- **Onboarding** - New developers understand code via tests
- **Consistency** - All developers follow same quality standard

---

## Summary

**Strict TDD is NOT optional:**

1. **TEST FIRST** - Always write failing test before implementation
2. **MINIMAL CODE** - Write just enough to make test pass
3. **REFACTOR** - Improve code while keeping tests green
4. **REPEAT** - One small piece at a time
5. **ZERO EXCEPTIONS** - No "simple code", no "just this once"

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

---

**See Also:**
- `.claude/rules/20-testing.md` - Testing guidelines and patterns
- `.claude/rules/21-testing.md` - Given-When-Then test structure
- `.claude/skills/test-driven-development/SKILL.md` - Auto-activating TDD enforcement
- `.claude/skills/test-writing/SKILL.md` - Auto-activating test quality checks
