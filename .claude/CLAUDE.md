# PIV Spec-Kit

**PIV (Prime-Implement-Validate) methodology for AI-assisted development**

---

## 🚨 TDD MANDATORY

**RED → GREEN → REFACTOR** - No exceptions.

1. **RED**: Write failing test FIRST
2. **GREEN**: Minimal code to pass
3. **REFACTOR**: Improve while green

❌ Code before tests = DELETE IT

---

## Quick Commands

| Command | Purpose |
|---------|---------|
| `/piv-speckit:plan-feature "X"` | Plan feature X (auto-primes context) |
| `/piv-speckit:execute` | Implement plan |
| `/piv-speckit:prime` | Manually refresh context (optional) |
| `/piv-speckit:validate` | Run validation |
| `/piv-speckit:code-review` | Review code |
| `/piv-speckit:learn` | Capture learnings |
| `/commit` | Commit changes |

---

## Supported Stack

**Backend:** Spring Boot • Node/Express • FastAPI
**Frontend:** React/TS
**Database:** PostgreSQL

---

## Workflow

```
PLAN → Design approach (auto-loads context)
IMPLEMENT → Write tests first, then code
VALIDATE → Runs automatically
```

---

## For Full Details

> **Reference docs:** `$CLAUDE_PLUGIN_ROOT/.claude-plugin/reference/`

- **Rules:** Loaded from `.claude/rules/` (compressed versions)
- **Full docs:** Available at `$CLAUDE_PLUGIN_ROOT/.claude-plugin/reference/`

---

**PIV Version:** 4.2.0 | **Claude Code Plugin Available**
