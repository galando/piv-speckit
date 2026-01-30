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

> **Claude Code users:** Reference docs auto-load via hooks when commands are invoked.
> **Other AI tools:** See compressed methodology in each command file.

- **Rules:** Loaded from `.claude/rules/` (compressed versions)
- **Full docs:** Available in plugin source at `.claude/reference/`

---

**PIV Version:** 3.0.4 | **Claude Code Plugin Available**
