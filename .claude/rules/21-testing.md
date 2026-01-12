# Testing Guidelines

## Core Testing Philosophy

**Tests are MANDATORY, not optional**
- Write tests alongside implementation
- Run tests after each task
- Fix failing tests immediately
- Never leave tests for "later"

## The Given-When-Then Pattern

**Universal test structure (language-agnostic):**

```
GIVEN: Set up test data and preconditions
WHEN: Execute the code being tested
THEN: Verify expected outcomes
```

### Pattern Template

```
1. GIVEN (Arrange)
   - Create test data
   - Set up preconditions
   - Configure mocks/stubs

2. WHEN (Act)
   - Call the method/function being tested
   - Execute single action

3. THEN (Assert)
   - Verify expected outcome
   - Check side effects
   - Validate state changes
```

### Examples (Conceptual)

**Test Name Pattern:**
`should{ExpectedBehavior}When{StateUnderTest}`

Examples:
- ✅ `shouldReturnUserWhenValidIdProvided`
- ✅ `shouldThrowErrorWhenInvalidInput`
- ❌ `test1` (not descriptive)
- ❌ `testUserCreation` (vague)

## Test Types

### 1. Unit Tests
**Scope:** Single function/method or class
**Speed:** Fast (< 100ms each)
**Isolation:** No external dependencies (mock databases, APIs)
**Focus:** Business logic, algorithms, validation

### 2. Integration Tests
**Scope:** Multiple components working together
**Speed:** Slower (seconds to minutes)
**Dependencies:** Real database, test containers
**Focus:** Workflows, database operations, API endpoints

### 3. End-to-End Tests
**Scope:** Complete user flows
**Speed:** Slowest (minutes)
**Environment:** Production-like setup
**Focus:** Critical user journeys

## Best Practices

### Test Independence
- Each test must run independently
- No shared state between tests
- Tests can run in any order
- One test failure shouldn't cascade

### Test Naming
Use descriptive names that document behavior:
- Format: `should{ExpectedBehavior}When{StateUnderTest}`
- Examples:
  - `shouldReturnNotFoundWhenNonExistentId`
  - `shouldCalculateDiscountWhenCustomerIsPremium`
  - `shouldValidateEmailWhenInvalidFormat`

### Test Coverage Goals

| Type | Target |
|------|--------|
| Critical paths | 90-100% |
| Business logic | 80-90% |
| Utilities/helpers | 90-100% |
| Configuration | 50-70% |
| Overall | 80%+ |

### What NOT to Test

- Auto-generated code
- Simple getters/setters
- Third-party libraries
- Framework code
- Obvious one-liners

## Testing Patterns

### Pattern 1: Testing Happy Path

```javascript
// Test that normal operation works
GIVEN valid input
WHEN operation is performed
THEN expected result is returned
```

### Pattern 2: Testing Error Cases

```javascript
// Test that errors are handled correctly
GIVEN invalid input
WHEN operation is performed
THEN appropriate error is thrown
```

### Pattern 3: Testing Edge Cases

```javascript
// Test boundary conditions
GIVEN boundary value input (empty, null, max, min)
WHEN operation is performed
THEN handles gracefully
```

### Pattern 4: Testing External Dependencies

```javascript
// Test with mocked/stubbed dependencies
GIVEN service with mocked dependency
WHEN operation is called
THEN dependency is called correctly
AND result is as expected
```

## Anti-Patterns to Avoid

### ❌ Testing Implementation Details

**Bad:** Tests internal structure
```javascript
test("user array has 3 items")
```

**Good:** Tests behavior
```javascript
test("returns all users")
```

### ❌ Fragile Tests

**Bad:** Tests break when implementation changes
```javascript
test("service method called in specific order")
```

**Good:** Tests outcome
```javascript
test("creates multiple users successfully")
```

### ❌ Testing Third-Party Code

**Bad:** Tests what libraries already test
```javascript
test("Array.map works correctly")
```

**Good:** Tests YOUR usage of library
```javascript
test("doubles all values in input array")
```

### ❌ Shared State Between Tests

**Bad:** Tests depend on execution order
```javascript
let sharedData = [];

test("creates user", () => {
    sharedData.push("user");
});

test("finds user", () => {
    // Depends on previous test
});
```

**Good:** Each test is independent
```javascript
test("creates and finds user", () => {
    const user = createUser("test");
    const found = findUser("test");
    expect(found).toBeDefined();
});
```

## Mocking and Stubbing

### When to Mock

✅ **Mock:**
- External APIs
- Databases (in unit tests)
- File system operations
- Time/date functions
- Random number generators

❌ **Don't Mock:**
- The code you're testing
- Simple utilities
- Value objects

### Mocking Guidelines

- **Prefer** real implementations over mocks when possible
- **Use** fakes for simple dependencies
- **Keep** mocks simple
- **Avoid** over-mocking (tests become fragile)

## Test Organization

### Directory Structure

```
tests/
├── unit/           # Fast, isolated tests
├── integration/    # Slower, component tests
└── e2e/           # Slow, full workflow tests
```

### File Organization

- **Mirror source structure**: `src/service/user.ts` → `tests/service/user.test.ts`
- **Clear naming**: Add `.test.`, `.spec.`, or `__tests__` suffix
- **Keep close**: Place tests near code they test

## Running Tests

### Before Committing

1. **Run full test suite**
2. **Verify** all tests pass
3. **Check** coverage meets requirements
4. **Fix** any failures immediately

### CI/CD Pipeline

Tests should run:
- On every pull request
- Before merging to main branch
- On deployment to production

## Testing Checklist

Before considering tests complete:

- [ ] Test has descriptive name
- [ ] Test follows Given-When-Then structure
- [ ] Test is independent (no shared state)
- [ ] Test is fast (< 100ms for unit tests)
- [ ] Test covers edge cases
- [ ] External dependencies are mocked (unit tests)
- [ ] Tests are easy to understand
- [ ] Tests run in any order
- [ ] Coverage meets requirements (80%+)
- [ ] No testing of third-party code
- [ ] No testing of implementation details

## Summary

**Good testing practices:**

1. **TEST** behavior, not implementation
2. **WRITE** tests alongside code
3. **MOCK** external dependencies (in unit tests)
4. **KEEP** tests fast and independent
5. **AIM** for 80%+ coverage
6. **RUN** tests before committing
7. **AVOID** testing third-party code

**Remember:** Tests are code too. Keep them clean, readable, and maintainable.
