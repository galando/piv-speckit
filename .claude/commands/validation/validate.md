---
description: Run comprehensive validation in LOCAL DEV MODE only
---

# Validate: Run Full Validation Suite

**Goal:** Validate implementation in LOCAL DEV MODE.

> **Full methodology:** `$CLAUDE_PLUGIN_ROOT/.claude-plugin/reference/execution/validate.md`

**⚠️ CRITICAL:** Always validate in LOCAL DEV MODE, never production.

## Execution Steps

### Step 1: Environment Verification (Level 0)

**First, verify we're in LOCAL mode:**

```bash
# Verify LOCAL mode - MUST run first
cat backend/.env.local | grep DATABASE_URL | grep -v "production" && echo "✅ SAFE"
```

**Expected output:** `✅ SAFE`

**If this fails:**
- ❌ **STOP IMMEDIATELY**
- You may be pointing to production
- Fix `.env.local` before proceeding

### Step 2: Backend Compilation (Level 1)

```bash
cd backend && mvn clean compile
```

**Expected:** `BUILD SUCCESS`

**If this fails:**
- Fix compilation errors first
- Do not proceed to tests

**Report:**
```
Level 1 (Compilation): ✅ PASS / ❌ FAIL
Duration: X seconds
Output: [summary if failed]
```

### Step 3: Backend Unit Tests (Level 2)

```bash
cd backend && mvn test
```

**Expected:**
- Tests run: X
- Failures: 0
- Errors: 0
- Duration: <60s

**Report:**
```
Level 2 (Unit Tests): ✅ PASS / ❌ FAIL
Tests Run: X
Failures: 0
Errors: 0
Duration: X seconds
```

**If tests fail:**
- Fix failing tests before proceeding
- Do not skip to integration tests

### Step 4: Integration Tests (Level 3)

```bash
cd backend && mvn verify -DskipUnitTests=true
```

**Uses:** LOCAL Docker PostgreSQL

**Expected:**
- Tests run: X
- Failures: 0
- Errors: 0

**Report:**
```
Level 3 (Integration Tests): ✅ PASS / ❌ FAIL
Tests Run: X
Failures: 0
Errors: 0
Duration: X seconds
```

### Step 5: Test Coverage (Level 4)

```bash
cd backend && mvn jacoco:report
```

**Expected:** ≥80% coverage for new code

**Report:**
```
Level 4 (Coverage): ✅ PASS / ❌ FAIL
Coverage: XX%
Target: ≥80%
Status: Meets requirement / Below requirement
```

### Step 6: Frontend Build (Level 5)

```bash
cd frontend && npm run build
```

**Expected:** Build completes without errors

**Report:**
```
Level 5 (Frontend): ✅ PASS / ❌ FAIL
Duration: X seconds
Output: [summary if failed]
```

### Step 7: Generate Validation Report

After running all levels, generate a summary:

```markdown
# Validation Report

**Date:** {timestamp}
**Branch:** {branch}

## Results Summary

| Level | Status | Duration | Notes |
|-------|--------|----------|-------|
| 0: Environment | ✅/❌ | - | LOCAL mode verified |
| 1: Compilation | ✅/❌ | Xs | BUILD SUCCESS/FAILED |
| 2: Unit Tests | ✅/❌ | Xs | X tests passed |
| 3: Integration | ✅/❌ | Xs | X tests passed |
| 4: Coverage | ✅/❌ | - | XX% coverage |
| 5: Frontend | ✅/❌ | Xs | Build succeeded |

## Overall Status

**{ALL PASSED ✅ / SOME FAILED ❌}**

{If all passed}
✅ Ready for code review: `/piv-speckit:code-review`

{If any failed}
❌ Fix issues above before proceeding
```

## Validation Rules

- ❌ NEVER validate against production
- ✅ Always use `.env.local` configuration
- ✅ Run ALL levels in order
- ✅ Stop immediately if Level 0 (environment check) fails
- ✅ Fix compilation errors before running tests
- ✅ Fix test failures before proceeding

## Output

Provide a clear validation report showing:
- Pass/fail status for each level
- Test counts and duration
- Coverage percentage
- Overall status
- Next steps (either proceed to code review or fix failures)
