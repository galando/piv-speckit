---
description: Auto-activates during code reviews
triggers:
  - command: "/validation:code-review;/code-review:code-review;gh pr view"
---

# Code Review Skill

**Checks:**
- TDD compliance
- Coverage ≥80%
- Security (OWASP)
- Conventions
- Error handling
- DRY principle

`Read .claude/reference/skills-full/code-review-full.md`
