---
description: Run comprehensive validation of the Example project in LOCAL DEV MODE only
---

# Validate: Run Full Validation Suite

**Goal:** Validate implementation in LOCAL DEV MODE.

## Execution

> **Full methodology:** `$CLAUDE_PLUGIN_ROOT/.claude-plugin/reference/execution/validate.md`

**⚠️ CRITICAL:** Always validate in LOCAL DEV MODE, never production.

### Validation Levels

**Level 0: Environment Verification**
```bash
# Verify LOCAL mode - MUST run first
cat backend/.env.local | grep DATABASE_URL | grep -v "production" && echo "✅ SAFE"
```

**Level 1: Backend Compilation**
```bash
cd backend && mvn clean compile
```

**Level 2: Backend Unit Tests**
```bash
cd backend && mvn test
# Expected: All pass, <60s
```

**Level 3: Integration Tests**
```bash
cd backend && mvn verify -DskipUnitTests=true
# Uses LOCAL Docker PostgreSQL
```

**Level 4: Test Coverage**
```bash
cd backend && mvn jacoco:report
# Expected: ≥80% for new code
```

**Level 5: Frontend Build**
```bash
cd frontend && npm run build
```

### Validation Rules

- ❌ NEVER validate against production
- ✅ Always use `.env.local` configuration
- ✅ Start with `./start-local.sh`
- ✅ Run ALL levels in order
