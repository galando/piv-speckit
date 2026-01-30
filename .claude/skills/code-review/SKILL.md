---
description: Auto-activates during code reviews
triggers:
  - command: "/piv-speckit:code-review"
  - command: "gh pr view"
  - command: "git diff"
---

# Code Review Skill

**Purpose:** Automated code review for quality, security, and best practices compliance.

**Activation Triggers:**
- `/piv-speckit:code-review` - Direct command invocation
- `gh pr view` - GitHub PR review workflow
- `git diff` - Jira/direct workflow (no PR)

**Checks:**
- TDD compliance (RED-GREEN-REFACTOR)
- Coverage ≥80%
- Security (OWASP Top 10)
- Project conventions
- Error handling
- DRY principle

*Full version: See `.claude/reference/skills-full/code-review-full.md` in plugin source.*
