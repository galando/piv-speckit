<!-- PIV Spec-Kit - https://github.com/galando/piv-speckit -->
# PIV Spec-Kit - Agent Instructions

> PIV: Prime → Implement → Validate methodology for AI-assisted development

## Quick Start

1. **Prime**: Understand codebase before changes
2. **Implement**: Write tests FIRST (TDD mandatory)
3. **Validate**: Run tests, verify quality

---

## PIV Workflow

### 1. Constitution (One-Time)

Create project principles in `constitution.md`:

```
"Create a project constitution in constitution.md with:
- Project purpose
- Tech stack
- Code style preferences
- Testing requirements (TDD, 80%+ coverage)
- Security constraints"
```

### 2. Prime (Each Session)

Analyze codebase before making changes:

```
"Analyze this codebase. Read constitution.md.
Tell me the structure, patterns, and conventions."
```

### 3. Plan (Complex Features)

Create specs in `.specs/{feature-name}/`:

```
"Plan a feature for X. Create in .specs/X/:
- spec.md: Requirements and user stories
- plan.md: Technical architecture
- tasks.md: Implementation checklist
- quickstart.md: TL;DR"
```

### 4. Execute (TDD Mandatory)

Implement following strict TDD:

```
"Implement tasks from .specs/X/tasks.md using TDD.
Show me the FAILING TEST first, then implementation."
```

### 5. Validate

Verify quality:

```
"Validate: run tests, check 80%+ coverage, review for security issues."
```

### Artifacts Location

```
project/
├── constitution.md          # Project principles
└── .specs/
    ├── .templates/          # Reusable templates
    └── {feature}/
        ├── spec.md          # WHAT (requirements)
        ├── plan.md          # HOW (architecture)
        ├── tasks.md         # DO (implementation)
        └── quickstart.md    # TL;DR
```

---

## TDD Requirements (MANDATORY)

**RED → GREEN → REFACTOR** - No exceptions.

| Phase | Action | Validation |
|-------|--------|------------|
| 🔴 RED | Write failing test FIRST | Test fails |
| 🟢 GREEN | Minimal code to pass | Test passes |
| 🔵 REFACTOR | Improve while green | Tests still pass |

**Rules:**
- ❌ NEVER write code before test
- ❌ NEVER skip TDD for "simple" code
- ✅ Test must fail before implementation
- ✅ Minimal code only - no premature optimization

---

## Code Style

### General Principles
- **Understand first**: Read existing code before modifying
- **Match patterns**: Follow existing codebase conventions
- **Minimal changes**: Only change what's necessary
- **Self-documenting**: Clear names over comments

### DRY (Don't Repeat Yourself)
- Check for existing implementations before creating new
- Reuse patterns, don't duplicate logic
- Single source of truth for each piece of knowledge

### KISS (Keep It Simple)
- Prefer simple over clever solutions
- Don't over-engineer
- Avoid premature optimization

---

## Testing Patterns

### Given-When-Then Structure
```
GIVEN: Setup test data and preconditions
WHEN:  Execute the code being tested
THEN:  Verify expected outcomes
```

### Test Requirements
- Descriptive test names explaining behavior
- Independent tests (no shared state)
- Fast execution (< 100ms per unit test)
- Mock external dependencies

### Coverage Goals
- Critical paths: 90-100%
- Business logic: 80-90%
- Overall: 80%+

---

## Git Workflow

### Branch Naming
- `feature/feature-name` - New features
- `fix/bug-description` - Bug fixes
- `docs/update-description` - Documentation

### Commit Messages (Conventional Commits)
```
type(scope): description

Types: feat, fix, docs, refactor, test, chore
```

### Rules
- ✅ Small, focused commits
- ✅ Meaningful messages
- ❌ No broken code
- ❌ No WIP commits

---

## Security

### Golden Rule
**NEVER trust user input.**

### Input Validation
- Validate structure, type, format, length
- Sanitize before use
- Use parameterized queries (prevent SQL injection)

### Authentication & Passwords
- Use bcrypt/Argon2 (NEVER MD5/SHA for passwords)
- Strong JWT secrets (256+ bits)
- Short token expiration (1 hour)
- Implement rate limiting

### Data Protection
- HTTPS in production
- Encrypt sensitive data at rest
- Environment variables for secrets
- NEVER commit secrets to git

---

## API Design (if applicable)

### RESTful Principles
- Nouns over verbs: `/users` not `/getUsers`
- Plural nouns: `/users` not `/user`
- Proper HTTP verbs: GET, POST, PUT, DELETE

### Response Format
```json
// Success
{ "data": {...}, "meta": {...} }

// Error
{ "error": "ErrorCode", "message": "Description" }
```

---

## Quick Reference

| Principle | Rule |
|-----------|------|
| TDD | RED → GREEN → REFACTOR always |
| DRY | No duplicate logic |
| KISS | Simple over clever |
| Security | Never trust input |
| Git | Conventional commits |
| Tests | Given-When-Then |

---

*PIV Spec-Kit - https://github.com/galando/piv-speckit*
*Works with: Claude Code, Cursor, GitHub Copilot, OpenAI Codex, and 20+ AI tools*
