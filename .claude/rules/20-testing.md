# Testing Rules

**Universal testing guidelines applicable to all projects**

---

## Testing Philosophy

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

## Unit Tests

### Purpose
Test individual functions/classes in isolation.

### Guidelines
✅ **DO**:
- Test public API (private methods are implementation details)
- Use descriptive test names
- Follow AAA pattern (Arrange, Act, Assert)
- Mock external dependencies
- Test edge cases and error conditions
- Keep tests fast (< 100ms each)

❌ **DON'T**:
- Don't test implementation details
- Don't write tests that are hard to understand
- Don't duplicate implementation logic in tests
- Don't make tests dependent on each other
- Don't test third-party libraries

### Test Structure (Given-When-Then)
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

### Test Naming
**Good Names**:
- ✅ `should_return_user_when_valid_input`
- ✅ `should_throw_error_when_email_exists`
- ✅ `should_calculate_total_with_discount`

**Bad Names**:
- ❌ `test1`
- ❌ `itWorks`
- ❌ `testUser`

---

## Integration Tests

### Purpose
Test how components work together.

### Guidelines
✅ **DO**:
- Test real interactions between components
- Use test database (not production)
- Test API endpoints
- Test database operations
- Test external service integrations (with mocks)

❌ **DON'T**:
- Don't use production data
- Don't depend on external services being up
- Don't make tests slow
- Don't test what unit tests already cover

### Example Test Scenarios
- API endpoint returns correct response
- Database transaction rolls back on error
- Service calls external API correctly
- Authentication flow works end-to-end

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
- Configuration files

### Coverage Report
Run coverage reports:
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

### Test Files
- **Mirror source structure**: `src/utils/date.ts` → `tests/utils/date.test.ts`
- **Clear naming**: Add `.test.`, `.spec.`, or `__tests__` suffix
- **Keep close**: Place tests near code they test

---

## Mocking and Fakes

### When to Mock
✅ **Mock**:
- External APIs
- Database connections
- File system operations
- Time/date functions
- Random number generators

❌ **Don't Mock**:
- Simple utilities
- The code you're testing
- Libraries with simple APIs

### Mocking Guidelines
- **PREFER** real implementations over mocks when possible
- **USE** fakes for simple dependencies
- **KEEP** mocks simple
- **AVOID** over-mocking (tests become fragile)

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
- **USE** separate database for testing
- **RESET** database between tests
- **SEED** with consistent test data
- **CLEANUP** after tests

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

### ❌ Fragile Tests
**Problem**: Tests break when implementation changes
```javascript
// Bad: Tests implementation details
test("user array has 3 items", () => {
  expect(userService.users.length).toBe(3);
});

// Good: Tests behavior
test("returns all users", () => {
  const users = userService.getAll();
  expect(users).toHaveLength(3);
});
```

### ❌ Slow Tests
**Problem**: Tests take too long to run
```javascript
// Bad: Sleep in tests
test("waits for async", async () => {
  await sleep(1000); // Don't do this
});

// Good: Use fake timers
test("waits for async", async () => {
  jest.useFakeTimers();
  // ...
});
```

### ❌ Testing Third-Party Code
**Problem**: Testing what libraries already test
```javascript
// Bad: Testing the library
test("Array.map works", () => {
  expect([1, 2, 3].map(x => x * 2)).toEqual([2, 4, 6]);
});

// Good: Test your usage of the library
test("doubles all values in array", () => {
  const result = doubleValues([1, 2, 3]);
  expect(result).toEqual([2, 4, 6]);
});
```

### ❌ Test Interdependence
**Problem**: Tests depend on each other
```javascript
// Bad: Tests depend on order
test("creates user", () => {
  createUser("John");
});

test("finds user", () => {
  const user = findUser("John"); // Relies on previous test
});

// Good: Each test is independent
test("creates and finds user", () => {
  createUser("John");
  const user = findUser("John");
  expect(user).toBeDefined();
});
```

---

## Best Practices Summary

### Writing Tests
1. **ARRANGE** test data and context
2. **ACT** on the code being tested
3. **ASSERT** expected outcomes
4. **CLEANUP** resources (in afterEach/afterAll)

### Test Quality Checklist
- [ ] Test has descriptive name
- [ ] Test follows AAA pattern
- [ ] Test is independent
- [ ] Test is fast
- [ ] Test covers edge cases
- [ ] Test is easy to understand
- [ ] Mocks are appropriate

---

## Summary

Good testing practices:

1. **TEST** behavior, not implementation
2. **WRITE** tests alongside code
3. **MOCK** external dependencies
4. **KEEP** tests fast and independent
5. **AIM** for 80%+ coverage
6. **RUN** tests before committing
7. **AVOID** testing third-party code

**Remember: Tests are code too. Keep them clean, readable, and maintainable.**
