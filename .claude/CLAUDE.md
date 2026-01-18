# Claude PIV Skeleton

**Universal PIV (Prime-Implement-Validate) methodology for Claude Code projects**

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
| `/piv_loop:prime` | Load context |
| `/piv_loop:plan-feature "X"` | Plan feature X |
| `/piv_loop:execute` | Implement plan |
| `/validation:validate` | Run validation |
| `/validation:code-review` | Review code |
| `/validation:learn` | Capture learnings |
| `/commit` | Commit changes |

---

## Supported Stack

**Backend:** Spring Boot • Node/Express • FastAPI
**Frontend:** React/TS
**Database:** PostgreSQL

---

## Workflow

```
PRIME → Load context
PLAN → Design approach (complex features only)
IMPLEMENT → Write tests first, then code
VALIDATE → Runs automatically
```

---

## For Full Details

- **Methodology:** `Read .claude/reference/methodology/PIV-METHODOLOGY.md`
- **Rules:** `Read .claude/rules/` (compressed) or `.claude/reference/rules-full/` (complete)
- **Skills:** `Read .claude/reference/skills-full/`

---

**PIV Version:** 1.0 | **Claude Code Compatible**
