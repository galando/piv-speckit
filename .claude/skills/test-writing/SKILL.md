---
description: Enforces Given-When-Then test structure and quality when writing test files
triggers:
  - file_pattern: "*.test.ts"
    when: "writing test code", "creating test file", "modifying test"
  - file_pattern: "*.test.js"
    when: "writing test code", "creating test file", "modifying test"
  - file_pattern: "*.spec.ts"
    when: "writing test code", "creating test file", "modifying test"
  - file_pattern: "*.spec.js"
    when: "writing test code", "creating test file", "modifying test"
  - file_pattern: "*Test.java"
    when: "writing test code", "creating test file", "modifying test"
  - file_pattern: "*IT.java"
    when: "writing test code", "creating test file", "modifying test"
  - file_pattern: "*_test.go"
    when: "writing test code", "creating test file", "modifying test"
  - file_pattern: "test_*.py"
    when: "writing test code", "creating test file", "modifying test"
---

# Test Writing Skill

## Activation

This skill activates when:
- Writing test code
- Creating test file
- Modifying existing test
- Adding new test case

**Activates ONLY for test files:**
- JavaScript/TypeScript: `*.test.ts`, `*.test.js`, `*.spec.ts`, `*.spec.js`
- Java: `*Test.java`, `*IT.java`
- Go: `*_test.go`
- Python: `test_*.py`, `*_test.py`

## Enforcement

**🧪 TEST QUALITY ENFORCEMENT:**

### 1. Test Naming Convention

**Follow the pattern:**
```
should{ExpectedBehavior}When{StateUnderTest}
```

**Examples:**
- ✅ `shouldReturnUserWhenValidIdProvided`
- ✅ `shouldThrowErrorWhenInvalidInput`
- ✅ `shouldCalculateDiscountWhenCustomerIsPremium`
- ❌ `test1` (not descriptive)
- ❌ `testUserCreation` (vague)
- ❌ `works` (no context)

### 2. Given-When-Then Structure (MANDATORY)

Every test MUST have clear sections:

```javascript
test('shouldCalculateTotalWhenDiscountApplied', () => {
  // GIVEN
  const price = 100;
  const discount = 0.1; // 10%
  const calculator = new Calculator();

  // WHEN
  const result = calculator.calculateTotal(price, discount);

  // THEN
  expect(result).toBe(90);
});
```

**Sections:**
- **GIVEN**: Test data and preconditions (setup)
- **WHEN**: Action being tested (execution)
- **THEN**: Expected outcomes (assertions)

### 3. Test Independence

**Each test must be independent:**
- No shared state between tests
- Tests can run in any order
- One test failure doesn't cascade
- Each test sets up its own data

**❌ BAD: Shared state**
```javascript
let sharedUser;

beforeEach(() => {
  sharedUser = new User();
});

test('test1', () => {
  sharedUser.setName('John'); // Affects test2
});

test('test2', () => {
  expect(sharedUser.name).toBeUndefined(); // FAILS if test1 runs first!
});
```

**✅ GOOD: Independent tests**
```javascript
test('shouldSetNameWhenValidNameProvided', () => {
  // GIVEN
  const user = new User(); // Each test creates its own data

  // WHEN
  user.setName('John');

  // THEN
  expect(user.name).toBe('John');
});

test('shouldHaveEmptyNameWhenNotSet', () => {
  // GIVEN
  const user = new User(); // Independent setup

  // THEN
  expect(user.name).toBeUndefined();
});
```

### 4. Test Speed

**Unit tests must be fast:**
- Target: < 100ms per test
- No slow I/O operations (use mocks)
- No network calls (use stubs)
- No database access (use fake repositories)

**❌ SLOW: Real database**
```javascript
test('shouldSaveUser', async () => {
  const user = new User();
  await realDatabase.save(user); // SLOW! Network + disk I/O
});
```

**✅ FAST: Mocked database**
```javascript
test('shouldSaveUser', async () => {
  const user = new User();
  const mockDb = { save: jest.fn().mockResolvedValue(user) };
  await userService.save(user, mockDb); // FAST! No I/O
});
```

### 5. Edge Case Coverage

**Tests must cover edge cases:**
- Empty inputs
- Null/undefined values
- Boundary conditions (min/max values)
- Error conditions
- Invalid inputs

**Example:**
```javascript
describe('Calculator.add', () => {
  // Happy path
  test('shouldReturnSumWhenValidNumbers', () => {
    expect(calc.add(2, 3)).toBe(5);
  });

  // Edge cases
  test('shouldReturnZeroWhenBothZeros', () => {
    expect(calc.add(0, 0)).toBe(0);
  });

  test('shouldHandleNegativeNumbers', () => {
    expect(calc.add(-5, 3)).toBe(-2);
  });

  test('shouldHandleLargeNumbers', () => {
    expect(calc.add(Number.MAX_SAFE_INTEGER, 0)).toBe(Number.MAX_SAFE_INTEGER);
  });

  // Error cases
  test('shouldThrowErrorWhenFirstInputIsNull', () => {
    expect(() => calc.add(null, 5)).toThrow('Invalid input');
  });

  test('shouldThrowErrorWhenSecondInputIsUndefined', () => {
    expect(() => calc.add(5, undefined)).toThrow('Invalid input');
  });
});
```

## Behavior

When this skill activates:

### 1. Review Test Name

Check test name follows pattern:
```
should{ExpectedBehavior}When{StateUnderTest}
```

If name doesn't follow pattern:
- Suggest better name
- Example: `testUserCreation` → `shouldCreateUserWhenValidDataProvided`

### 2. Review Test Structure

Verify Given-When-Then sections exist:

**If sections missing:**
```
⚠️ TEST STRUCTURE ISSUE

Test is missing clear Given-When-Then sections.

Add structure:
// GIVEN
[setup test data]

// WHEN
[execute action]

// THEN
[assert outcomes]

This improves test readability and maintainability.
```

### 3. Review Test Independence

Check for shared state:
- Global variables modified in tests
- Shared test data between tests
- Tests that depend on execution order

**If shared state detected:**
```
⚠️ TEST INDEPENDENCE ISSUE

Test shares state with other tests.

Problem: Tests cannot run independently
Solution: Each test creates its own data
Example:
  // BAD
  let sharedData;

  // GOOD
  test('...', () => {
    const testData = createTestData(); // Independent
  });
```

### 4. Review Test Speed

Check for slow operations:
- Real database calls
- Network requests
- File system operations
- Long timeouts

**If slow operations detected:**
```
⚠️ TEST SPEED ISSUE

Test performs slow I/O operations.

Problem: Test will be slow (> 100ms target)
Solution: Use mocks/stubs for external dependencies
Example:
  // BAD
  await realDatabase.save(user);

  // GOOD
  const mockDb = { save: jest.fn().mockResolvedValue(user) };
  await service.save(user, mockDb);
```

### 5. Review Edge Case Coverage

Analyze test for missing edge cases:
- What happens with empty input?
- What happens with null/undefined?
- What happens at boundaries?
- What happens on error?

**If edge cases missing:**
```
💡 EDGE CASE SUGGESTION

Consider testing edge cases:
- Empty input: ""
- Null input: null
- Boundary: MAX_SAFE_INTEGER
- Error: invalid type

Edge cases expose bugs that happy path tests miss.
```

## Examples

### ✅ GOOD: Well-Structured Test

```javascript
describe('UserService', () => {
  describe('createUser', () => {
    test('shouldReturnUserWhenValidDataProvided', () => {
      // GIVEN
      const userData = {
        name: 'John Doe',
        email: 'john@example.com'
      };
      const mockRepository = {
        save: jest.fn().mockResolvedValue({ id: '123', ...userData })
      };
      const service = new UserService(mockRepository);

      // WHEN
      const result = await service.createUser(userData);

      // THEN
      expect(result).toBeDefined();
      expect(result.id).toBe('123');
      expect(result.name).toBe('John Doe');
      expect(result.email).toBe('john@example.com');
      expect(mockRepository.save).toHaveBeenCalledTimes(1);
    });

    test('shouldThrowErrorWhenEmailAlreadyExists', () => {
      // GIVEN
      const userData = {
        name: 'John Doe',
        email: 'existing@example.com'
      };
      const mockRepository = {
        findByEmail: jest.fn().mockResolvedValue({ id: 'existing' })
      };
      const service = new UserService(mockRepository);

      // WHEN + THEN
      await expect(service.createUser(userData))
        .rejects
        .toThrow('Email already exists');
    });

    test('shouldThrowErrorWhenNameIsEmpty', async () => {
      // GIVEN
      const userData = {
        name: '',
        email: 'john@example.com'
      };
      const mockRepository = { findByEmail: jest.fn().mockResolvedValue(null) };
      const service = new UserService(mockRepository);

      // WHEN + THEN
      await expect(service.createUser(userData))
        .rejects
        .toThrow('Name is required');
    });
  });
});
```

**Why this is good:**
- ✅ Descriptive test names (should/when pattern)
- ✅ Clear Given-When-Then structure
- ✅ Independent tests (each creates its own data)
- ✅ Fast (mocked repository, no real DB)
- ✅ Edge cases covered (empty name, duplicate email)

### ❌ BAD: Poor Test Structure

```javascript
test('user creation', () => {
  const user = userService.create('John', 'john@example.com');

  expect(user).toBeDefined();
});
```

**Problems:**
- ❌ Name doesn't follow should/when pattern
- ❌ No Given-When-Then structure
- ❌ Not clear what's being tested
- ❌ No edge cases
- ❌ May be slow (real database?)

## Checklist

Before finishing a test:

- [ ] Test name follows `should...When...` pattern
- [ ] Test has clear GIVEN section (setup)
- [ ] Test has clear WHEN section (action)
- [ ] Test has clear THEN section (assertions)
- [ ] Test is independent (no shared state)
- [ ] Test is fast (< 100ms for unit tests)
- [ ] Test covers edge cases
- [ ] Test is self-documenting (clear what it tests)

**If any checklist item fails:**
- **IMPROVE** the test
- **THEN** consider it complete

## Test Organization

### File Structure

```
tests/
├── unit/              # Fast, isolated tests
│   ├── services/
│   │   └── user.service.test.ts
│   └── utils/
│       └── date.utils.test.ts
├── integration/       # Slower, component tests
│   └── api/
│       └── users.api.test.ts
└── e2e/              # Slowest, full workflow tests
    └── flows/
        └── user-registration.flow.test.ts
```

### Test Groups

Use `describe` to group related tests:

```javascript
describe('Calculator', () => {
  describe('add', () => {
    test('should...', () => {});
    test('should...', () => {});
  });

  describe('subtract', () => {
    test('should...', () => {});
    test('should...', () => {});
  });
});
```

## Resources

**See Also:**
- `.claude/rules/21-testing.md` - Given-When-Then testing guidelines
- `.claude/rules/22-tdd-strict.md` - Strict TDD rules
- `.claude/skills/test-driven-development/SKILL.md` - TDD enforcement

**Learn More:**
- [Given-When-Then Pattern](https://martinfowler.com/bliki/GivenWhenThen.html)
- [Test-Driven Development by Kent Beck](https://www.amazon.com/Test-Driven-Development-Kent-Beck/dp/0321146530)
