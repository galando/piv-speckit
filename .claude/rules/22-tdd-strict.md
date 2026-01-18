# Strict TDD Rules

## 🚨 MANDATORY: Test-Driven Development

**ALL code MUST follow RED-GREEN-REFACTOR cycle.**

## The Cycle

### 1. RED - Write Failing Test
- **Write** test FIRST, before implementation
- **Run** test to verify it FAILS
- **NO** implementation code until test passes

### 2. GREEN - Make Test Pass
- **Write** MINIMAL code to make test pass
- **Run** test to verify it PASSES
- **Don't** worry about code quality yet

### 3. REFACTOR - Improve Code
- **Improve** code while tests stay green
- **Run** tests again to ensure nothing broke
- **If** tests break → fix or revert

## Zero Tolerance

❌ **NEVER** write implementation code before tests
❌ **NEVER** write tests after code (that's NOT TDD)
❌ **NEVER** skip TDD for "simple" code
❌ **NEVER** say "I'll add tests later"

## Enforcement

- **test-driven-development skill** auto-activates
- **Validation FAILS** without TDD compliance
- **Code review rejects** violations
- **Code written before tests WILL BE DELETED**

**For complete guide with examples:** `Read .claude/reference/rules-full/tdd-full.md`
