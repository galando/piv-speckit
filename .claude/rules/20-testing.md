# Testing Rules

## Core Philosophy

**Tests are MANDATORY, not optional.**

## The Given-When-Then Pattern

```
GIVEN: Set up test data and preconditions
WHEN: Execute the code being tested
THEN: Verify expected outcomes
```

## Test Types

| Type | Scope | Speed | Focus |
|------|-------|-------|-------|
| Unit | Single function | Fast | Business logic |
| Integration | Multiple components | Slower | Workflows |
| E2E | Complete flows | Slowest | User journeys |

## Coverage Goals

- Critical paths: 90-100%
- Business logic: 80-90%
- Overall: 80%+

## Quick Checklist

Before committing:
- [ ] Test has descriptive name
- [ ] Test follows Given-When-Then
- [ ] Test is independent
- [ ] Test is fast (< 100ms)
- [ ] Coverage meets requirements

## Anti-Patterns

❌ Testing implementation details
❌ Fragile tests
❌ Testing third-party code
❌ Shared state between tests

**For complete guide with examples:** `Read .claude/reference/rules-full/testing-full.md`
