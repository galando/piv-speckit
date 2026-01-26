#!/bin/bash
# generate-agents-md.sh - Generate compact AGENTS.md for Cursor/other AI tools
# Target: < 500 lines for minimal context overhead

set -euo pipefail

generate_agents_md() {
    local output="${1:-AGENTS.md}"

    cat > "$output" << HEADER
<!-- PIV Spec-Kit - https://github.com/galando/piv-speckit -->
# PIV Spec-Kit - Agent Instructions

> PIV: Prime → Implement → Validate methodology for AI-assisted development

## Quick Start

1. **Prime**: Understand codebase before changes
2. **Implement**: Write tests FIRST (TDD mandatory)
3. **Validate**: Run tests, verify quality

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
\`\`\`
GIVEN: Setup test data and preconditions
WHEN:  Execute the code being tested
THEN:  Verify expected outcomes
\`\`\`

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
- \`feature/feature-name\` - New features
- \`fix/bug-description\` - Bug fixes
- \`docs/update-description\` - Documentation

### Commit Messages (Conventional Commits)
\`\`\`
type(scope): description

Types: feat, fix, docs, refactor, test, chore
\`\`\`

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
- Token expiration ≤1 hour
- Implement rate limiting

### Data Protection
- HTTPS in production
- Encrypt sensitive data at rest
- Environment variables for secrets
- NEVER commit secrets to git

---

## API Design (if applicable)

### RESTful Principles
- Nouns over verbs: \`/users\` not \`/getUsers\`
- Plural nouns: \`/users\` not \`/user\`
- Proper HTTP verbs: GET, POST, PUT, DELETE

### Response Format
\`\`\`json
// Success
{ "data": {...}, "meta": {...} }

// Error
{ "error": "ErrorCode", "message": "Description" }
\`\`\`

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
HEADER

    local lines=$(wc -l < "$output")
    echo "Generated: $output ($lines lines)"

    if [ "$lines" -gt 500 ]; then
        echo "⚠️  Warning: AGENTS.md exceeds 500 lines ($lines)"
    else
        echo "✅ AGENTS.md is under 500 lines"
    fi
}

# Allow sourcing or direct execution
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    generate_agents_md "$@"
fi
