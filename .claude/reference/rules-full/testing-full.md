# Testing Rules (Complete Guide)

**Universal testing guidelines applicable to all projects**

---

## Core Testing Philosophy

**Tests are MANDATORY, not optional**
- Write tests alongside implementation
- Run tests after each task
- Fix failing tests immediately
- Never leave tests for "later"

### Core Principles
1. **Test as You Code** - Write tests alongside implementation
2. **Test Behavior, Not Implementation** - Focus on what, not how
3. **Keep Tests Simple** - Tests should be easy to understand
4. **Make Tests Fast** - Slow tests don't get run
5. **Test Independently** - Tests shouldn't depend on each other

### The Testing Pyramid
```
         /\
        /  \     E2E Tests (few)
       /----\
      /      \   Integration Tests (some)
     /--------\
    /          \ Unit Tests (many)
   /____________\
```

---

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

### Code Example

```javascript
// GIVEN
const input = { name: "John", age: 30 };
const repository = { save: jest.fn() };

// WHEN
const result = createUser(input, repository);

// THEN
expect(result).toBeDefined();
expect(result.id).toBeDefined();
expect(repository.save).toHaveBeenCalledWith(expect.any(User));
```

### Test Name Pattern
**Format:** `should{ExpectedBehavior}When{StateUnderTest}`

**Good Names:**
- ✅ `shouldReturnUserWhenValidIdProvided`
- ✅ `shouldThrowErrorWhenInvalidInput`
- ✅ `shouldCalculateDiscountWhenCustomerIsPremium`
- ✅ `shouldValidateEmailWhenInvalidFormat`

**Bad Names:**
- ❌ `test1`
- ❌ `itWorks`
- ❌ `testUserCreation` (vague)

---

## Test Types

### 1. Unit Tests
**Scope:** Single function/method or class
**Speed:** Fast (< 100ms each)
**Isolation:** No external dependencies (mock databases, APIs)
**Focus:** Business logic, algorithms, validation

**Guidelines:**
- ✅ Test public API (private methods are implementation details)
- ✅ Use descriptive test names
- ✅ Follow AAA pattern (Arrange, Act, Assert)
- ✅ Mock external dependencies
- ✅ Test edge cases and error conditions
- ❌ Don't test implementation details
- ❌ Don't duplicate implementation logic in tests

### 2. Integration Tests
**Scope:** Multiple components working together
**Speed:** Slower (seconds to minutes)
**Dependencies:** Real database, test containers
**Focus:** Workflows, database operations, API endpoints

**Guidelines:**
- ✅ Test real interactions between components
- ✅ Use test database (not production)
- ✅ Test API endpoints
- ✅ Test database operations
- ❌ Don't use production data
- ❌ Don't depend on external services being up

**Example Scenarios:**
- API endpoint returns correct response
- Database transaction rolls back on error
- Service calls external API correctly
- Authentication flow works end-to-end

### 3. End-to-End Tests
**Scope:** Complete user flows
**Speed:** Slowest (minutes)
**Environment:** Production-like setup
**Focus:** Critical user journeys

---

## Test Coverage

### Coverage Goals

| Type | Target |
|------|--------|
| Critical paths | 90-100% |
| Business logic | 80-90% |
| Utility functions | 90-100% |
| Configuration | 50-70% |
| Overall | 80%+ |

### What NOT to Cover

- Auto-generated code
- Simple getters/setters
- Obvious one-liners
- Third-party libraries
- Framework code
- Configuration files

### Coverage Report

```bash
# JavaScript/TypeScript
npm test -- --coverage

# Python
pytest --cov=. --cov-report=html

# Java
mvn jacoco:report
```

---

## Test Organization

### Directory Structure

```
tests/
├── unit/
│   ├── services/
│   │   └── user.service.test.ts
│   └── utils/
│       └── date.utils.test.ts
├── integration/
│   ├── api/
│   │   └── users.api.test.ts
│   └── database/
│       └── user.repository.test.ts
└── e2e/
    └── flows/
        └── user-registration.flow.test.ts
```

### File Organization

- **Mirror source structure:** `src/utils/date.ts` → `tests/utils/date.test.ts`
- **Clear naming:** Add `.test.`, `.spec.`, or `__tests__` suffix
- **Keep close:** Place tests near code they test

---

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

---

## Mocking and Fakes

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
- Libraries with simple APIs

### Mocking Guidelines

- **Prefer** real implementations over mocks when possible
- **Use** fakes for simple dependencies
- **Keep** mocks simple
- **Avoid** over-mocking (tests become fragile)

---

## Test Data Management

### Test Data Fixtures

```javascript
// Good: Reusable test data
const testUsers = {
  valid: { name: "John", email: "john@example.com" },
  invalid: { name: "", email: "invalid" },
  duplicate: { name: "Jane", email: "john@example.com" }
};

test("should create user with valid data", () => {
  // Use testUsers.valid
});
```

### Test Database

- **Use** separate database for testing
- **Reset** database between tests
- **Seed** with consistent test data
- **Cleanup** after tests

---

## Running Tests

### Before Committing

```bash
# Run all tests
npm test

# Run specific test file
npm test user.service.test

# Run tests in watch mode
npm test -- --watch

# Run tests with coverage
npm test -- --coverage
```

### CI/CD Pipeline

Tests should run:
1. On every pull request
2. Before merging to main
3. On deployment to production

---

## Anti-Patterns

### ❌ Testing Implementation Details

**Bad:** Tests internal structure
```javascript
test("user array has 3 items", () => {
  expect(userService.users.length).toBe(3);
});
```

**Good:** Tests behavior
```javascript
test("returns all users", () => {
  const users = userService.getAll();
  expect(users).toHaveLength(3);
});
```

### ❌ Fragile Tests

**Bad:** Tests break when implementation changes
```javascript
test("service method called in specific order", () => {
  // Brittle - breaks on refactoring
});
```

**Good:** Tests outcome
```javascript
test("creates multiple users successfully", () => {
  // Resilient - focuses on result
});
```

### ❌ Testing Third-Party Code

**Bad:** Testing what libraries already test
```javascript
test("Array.map works", () => {
  expect([1, 2, 3].map(x => x * 2)).toEqual([2, 4, 6]);
});
```

**Good:** Test your usage of library
```javascript
test("doubles all values in array", () => {
  const result = doubleValues([1, 2, 3]);
  expect(result).toEqual([2, 4, 6]);
});
```

### ❌ Test Interdependence

**Bad:** Tests depend on execution order
```javascript
let sharedData = [];

test("creates user", () => {
  createUser("John");
  sharedData.push("user");
});

test("finds user", () => {
  const user = findUser("John"); // Relies on previous test
});
```

**Good:** Each test is independent
```javascript
test("creates and finds user", () => {
  createUser("John");
  const user = findUser("John");
  expect(user).toBeDefined();
});
```

### ❌ Slow Tests

**Bad:** Sleep in tests
```javascript
test("waits for async", async () => {
  await sleep(1000); // Don't do this
});
```

**Good:** Use fake timers
```javascript
test("waits for async", async () => {
  jest.useFakeTimers();
  // ...
});
```

---

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
- [ ] Mocks are appropriate
- [ ] Test has descriptive name
- [ ] Test follows AAA pattern

---

## Summary

**Good testing practices:**

1. **TEST** behavior, not implementation
2. **WRITE** tests alongside code
3. **MOCK** external dependencies
4. **KEEP** tests fast and independent
5. **AIM** for 80%+ coverage
6. **RUN** tests before committing
7. **AVOID** testing third-party code

**Remember: Tests are code too. Keep them clean, readable, and maintainable.**
