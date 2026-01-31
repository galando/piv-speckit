---
description: Technical code review for quality and bugs that runs pre-commit
---

# Code Review

**Goal:** Comprehensive code review for quality and bugs.

## Execution

> **Full methodology:** `$CLAUDE_PLUGIN_ROOT/.claude-plugin/reference/execution/code-review.md`

### Review Checklist

**1. TDD Compliance**
- [ ] Tests written BEFORE implementation
- [ ] RED → GREEN → REFACTOR cycle followed
- [ ] Each feature has corresponding tests

**2. Coverage (≥80%)**
- [ ] Critical paths: 90-100%
- [ ] Business logic: 80-90%
- [ ] Edge cases covered

**3. Security (OWASP)**
- [ ] No SQL injection (use parameterized queries)
- [ ] No XSS (escape user input)
- [ ] No hardcoded secrets
- [ ] Input validation on all user input

**4. Conventions**
- [ ] Follows project patterns in `.claude/rules/`
- [ ] Consistent naming conventions
- [ ] No unused imports/variables

**5. Error Handling**
- [ ] Graceful degradation
- [ ] Meaningful error messages
- [ ] Structured logging

**6. DRY Principle**
- [ ] No duplicated logic
- [ ] Reuses existing patterns/utilities

### Output Format

Use confidence-based filtering (HIGH/MEDIUM/LOW). Only report issues with HIGH confidence that truly matter.
