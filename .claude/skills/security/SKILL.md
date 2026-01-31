---
description: Enforces security best practices
triggers:
  - file_pattern: "*Auth*.java;*User*.java;*Security*.java"
---

# Security Skill

**Critical:**
- ✅ Validate ALL input
- ✅ Parameterized queries only
- ✅ bcrypt passwords
- ✅ Env vars for secrets
- ❌ Never trust user input
- ❌ Never commit secrets

**For complete security guidelines:** Read `${CLAUDE_PLUGIN_ROOT}/.claude-plugin/reference/skills-full/security-full.md`
