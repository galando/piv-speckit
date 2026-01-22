---
description: Run comprehensive validation of the Example project in LOCAL DEV MODE only
---

# Validate: Run Full Validation Suite (LOCAL DEV MODE)

**⚠️ CRITICAL SAFETY RULE:**
- **ALWAYS** validate in **LOCAL DEV MODE** (Docker PostgreSQL)
- **NEVER** validate against **PRODUCTION CLOUD** database
- Production mode is ONLY for deployed releases, NEVER for development/testing

## Test Passage Requirement

**🚨 CRITICAL: ALL TESTS MUST PASS - NO EXCEPTIONS**

**Validation Policy:**
- ✅ **ALL** unit tests MUST pass (zero failures allowed)
- ✅ **ALL** integration tests MUST pass (zero failures allowed)
- ✅ **NEW** tests for new code MUST pass
- ✅ **EXISTING** tests MUST NOT break (regressions not allowed)

**Hard Stops:**
- ❌ If ANY unit test fails → **VALIDATION FAILS** → Fix tests before proceeding
- ❌ If ANY integration test fails → **VALIDATION FAILS** → Fix tests before proceeding
- ❌ If test coverage < 80% → **VALIDATION FAILS** → Add tests before proceeding

**What This Means:**

**Level 2 (Unit Tests):**
```
cd backend && mvn test
```

**Expected Output:**
```
Tests run: XXX, Failures: 0, Errors: 0, Skipped: 0
```

**If Failures > 0:**
```
❌ VALIDATION FAILED

Unit tests are failing:
- Fix failing tests
- Ensure all tests pass
- Re-run: mvn test
- Do NOT proceed until all tests pass
```

**Level 3 (Integration Tests):**
```
cd backend && mvn verify -DskipUnitTests=true
```

**Expected Output:**
```
Tests run: XXX, Failures: 0, Errors: 0, Skipped: 0
```

**If Failures > 0:**
```
❌ VALIDATION FAILED

Integration tests are failing:
- Fix failing integration tests
- Ensure all tests pass
- Re-run: mvn verify -DskipUnitTests=true
- Do NOT proceed until all tests pass
```

**No Exceptions:**

There are NO valid exceptions to this rule:

❌ **NOT allowed:** "It's just a warning"
❌ **NOT allowed:** "That test is flaky"
❌ **NOT allowed:** "I'll fix it later"
❌ **NOT allowed:** "It's not related to my changes"

**If a test is wrong:**
1. Fix the test (if test is buggy)
2. Fix the code (if test reveals real bug)
3. Re-run validation
4. Only proceed when ALL tests pass

**Rationale:**

Tests are our safety net. Allowing test failures undermines:
- Code quality
- Confidence in changes
- Ability to detect regressions
- Team productivity (debugging failures later)

**This policy is non-negotiable.**

---

**Summary:** Test passage is a hard requirement. Validation does not proceed until ALL tests pass.

## Environment Modes

### Mode 1: Local Development (Docker) ✅ **USE THIS FOR VALIDATION**

**Configuration:** `backend/.env.local`
**Database:** Local Docker PostgreSQL
**Services:** PostgreSQL, Hasura, Adminer (all in Docker)

**Start:**
```bash
./start-local.sh
```

**Stop:**
```bash
./stop-local.sh
```

**When to use:**
- ✅ ALL validation and testing
- ✅ Feature development
- ✅ Bug fixing
- ✅ Experimentation

### Mode 2: Production (CloudProvider Cloud) ⚠️ **NEVER USE FOR VALIDATION**

**Configuration:** `backend/.env`
**Database:** CloudProvider cloud PostgreSQL
**Services:** CloudProvider cloud (authentication + database)

**Start:**
```bash
./start.sh
```

**Stop:**
```bash
./stop.sh
```

**When to use:**
- ✅ Production deployments ONLY
- ✅ Production release testing ONLY
- ❌ NEVER for feature development
- ❌ NEVER for validation/testing

## Validation Commands (LOCAL DEV MODE)

**Prerequisite: Ensure local dev environment is running:**

```bash
# Check if local mode is running
docker ps | grep postgres

# If not running, start local dev mode:
./start-local.sh
```

### 1. Verify Environment

**⚠️ CRITICAL: Confirm we're in LOCAL DEV MODE**

```bash
# Check which .env file is being used
cat backend/.env.local | grep DATABASE_URL

# Expected output: localhost or 127.0.0.1 (NOT production.example.com)
# Example: jdbc:postgresql://localhost:5432/example

# If you see production.example.com in DATABASE_URL, STOP! You're in PROD mode!
```

**✅ SAFE:** Database URL contains `localhost` or `127.0.0.1`
**❌ UNSAFE:** Database URL contains `production.example.com`

### 2. Backend Compilation

```bash
cd backend && mvn clean compile
```

**Expected:** BUILD SUCCESS

**Time:** ~30 seconds

**Why:** Ensures all Java code compiles without errors, including all dependencies.

### 3. TDD Compliance Check (MANDATORY)

**🚨 CRITICAL: HARD STOP if TDD violations detected**

```bash
# Check for implementation files without corresponding test files
# (This is a manual check - no automated command yet)

# Find all implementation files changed in this branch
git diff --name-only main | grep -E '\.(java|ts|tsx|js|py|go)$' | grep -v -E '\.(test|spec)\.'

# For each implementation file found:
# - Verify corresponding test file exists
# - Verify test was written BEFORE implementation (check git history)
# - Verify test follows Given-When-Then pattern
```

**Expected:** All implementation files have corresponding test files, tests written BEFORE implementation.

**Time:** ~30 seconds (manual review)

**Why:** Ensures strict TDD compliance - tests written FIRST, implementation SECOND.

**Checks:**
- [ ] Every implementation file (`.java`, `.ts`, `.tsx`, `.js`, `.py`, `.go`) has corresponding test file
  - Java: `UserService.java` → `UserServiceTest.java`
  - TypeScript: `user.service.ts` → `user.service.test.ts`
  - Python: `user_service.py` → `test_user_service.py`
- [ ] Test file was created BEFORE implementation file (check `git log --follow`)
- [ ] Test follows Given-When-Then pattern
- [ ] Test was run and FAILED (RED phase) before implementation
- [ ] Implementation was written AFTER test (GREEN phase)

**🚨 ON FAILURE (HARD STOP):**

If TDD violations detected, validation STOPS immediately:

```
❌ TDD COMPLIANCE CHECK FAILED

Implementation file: [filename]
Test file: [missing or created AFTER implementation]

REQUIRED ACTION:
1. DELETE implementation code (code written before tests violates TDD)
2. Write test FIRST (RED phase)
3. Run test to verify it FAILS
4. Implement code to make test PASS (GREEN phase)
5. Refactor while keeping tests green (REFACTOR phase)

Validation is BLOCKED until TDD compliance achieved.

TDD is NON-NEGOTIABLE:
- ❌ NO exceptions for "simple code"
- ❌ NO exceptions for "just this once"
- ❌ NO exceptions for "I'll add tests later"

Zero tolerance for TDD violations.
```

**No Exceptions:**
- Don't write implementation before tests
- Don't write tests after implementation
- Don't skip TDD for "simple" code
- Don't say "this doesn't need a test"

**Follow RED-GREEN-REFACTOR cycle:**
1. 🔴 RED: Write FAILING test first
2. 🟢 GREEN: Write MINIMAL code to pass
3. 🔵 REFACTOR: Improve while tests stay green

**Enforcement:**
- Skills system auto-activates to enforce TDD while you code
- Validation FAILS if TDD violations detected
- Code review rejects code written before tests
- Code written before tests WILL BE DELETED

### 4. Backend Unit Tests

```bash
cd backend && mvn test
```

**Expected:** All tests pass, zero failures

**Time:** ~60 seconds

**Why:** Verifies all unit tests pass, ensuring business logic is correct.

**Output to Check:**
```
Tests run: XXX, Failures: 0, Errors: 0, Skipped: 0
```

**🚨 ON FAILURE (HARD STOP):**

If tests fail, validation STOPS immediately:

```
❌ UNIT TEST VALIDATION FAILED

Failure Details:
[Output from mvn test showing failures]

REQUIRED ACTION:
1. Analyze test failures
2. Fix the code or fix the test (whichever is wrong)
3. Re-run: cd backend && mvn test
4. Only proceed when ALL tests pass (Failures: 0, Errors: 0)

Validation is BLOCKED until unit tests pass.
Do NOT proceed to integration tests until unit tests pass.
```

**No Exceptions:**
- Don't skip failing tests
- Don't disable tests
- Don't proceed with failures
- Don't say "I'll fix it later"

**Fix the failure NOW.**

### 5. Backend Integration Tests (LOCAL DEV MODE)

```bash
cd backend && mvn verify -DskipUnitTests=true
```

**Expected:** All integration tests pass

**Time:** ~120 seconds

**Why:** Verifies integration with LOCAL database and external services works correctly.

**⚠️ SAFETY CHECK:**
- Uses `backend/.env.local` configuration
- Connects to LOCAL Docker PostgreSQL
- Does NOT touch CloudProvider production data

**Note:** Requires local Docker PostgreSQL to be running (`./start-local.sh`).

**🚨 ON FAILURE (HARD STOP):**

If tests fail, validation STOPS immediately:

```
❌ INTEGRATION TEST VALIDATION FAILED

Failure Details:
[Output from mvn verify showing failures]

REQUIRED ACTION:
1. Analyze integration test failures
2. Fix the code or fix the test (whichever is wrong)
3. Verify LOCAL database is running: ./start-local.sh
4. Re-run: cd backend && mvn verify -DskipUnitTests=true
5. Only proceed when ALL tests pass (Failures: 0, Errors: 0)

Validation is BLOCKED until integration tests pass.
Do NOT proceed to further validation until integration tests pass.
```

**⚠️ SAFETY CHECK:**
Before re-running, confirm:
- [ ] Using backend/.env.local (NOT backend/.env)
- [ ] Database URL points to localhost/127.0.0.1
- [ ] LOCAL Docker PostgreSQL is running

**No Exceptions:**
- Don't skip failing integration tests
- Don't disable integration tests
- Don't proceed with failures
- Don't say "I'll fix it later"

**Fix the failure NOW.**

### 6. Test Coverage

```bash
cd backend && mvn jacoco:report
```

**Expected:** Coverage >= 80%

**Time:** ~10 seconds

**Why:** Ensures new code has adequate test coverage.

**How to Check:**
- Report generated in `backend/target/site/jacoco/index.html`
- Check overall coverage percentage
- Ensure new files have >= 80% coverage

### 7. Frontend Type Check

```bash
cd frontend && npm run type-check
```

**Expected:** No TypeScript errors

**Time:** ~15 seconds

**Why:** Ensures all TypeScript code is properly typed.

### 8. Frontend Linting

```bash
cd frontend && npm run lint
```

**Expected:** No linting errors

**Time:** ~10 seconds

**Why:** Ensures code follows project style guidelines.

### 9. Frontend Unit Tests

```bash
cd frontend && npm test
```

**Expected:** All tests pass

**Time:** ~30 seconds

**Why:** Verifies frontend logic and components work correctly.

### 10. Frontend Build

```bash
cd frontend && npm run build
```

**Expected:** Build completes successfully, outputs to `dist/`

**Time:** ~45 seconds

**Why:** Ensures production build works without errors.

### 11. Database Migration Check (LOCAL DEV MODE)

```bash
cd backend && mvn flyway:info -Dflyway.configFiles=src/main/resources/application.properties
```

**Expected:** All migrations applied, no pending migrations

**Why:** Verifies LOCAL database schema is up to date.

**⚠️ SAFETY CHECK:**
- Only affects LOCAL Docker database
- Does NOT touch CloudProvider production database

### 12. Application Startup (LOCAL DEV MODE)

**⚠️ CRITICAL: Only run this in LOCAL DEV MODE!**

```bash
# Start backend in LOCAL mode
cd backend && mvn spring-boot:run &
BACKEND_PID=$!
sleep 15  # Wait for startup

# Check we're connecting to LOCAL database
curl -s http://localhost:8080/actuator/health | jq .

# Expected output:
# {
#   "status": "UP"
# }

# Verify database connection (should be localhost)
curl -s http://localhost:8080/actuator/info | jq .

# Stop backend
kill $BACKEND_PID 2>/dev/null || true
```

**Expected:** Status UP, database is LOCAL (not production.example.com)

**Why:** Verifies application starts successfully with all changes in LOCAL mode.

**⚠️ SAFETY CHECKS:**
- Verify `application.properties` or `.env.local` is being used
- Verify database URL points to localhost
- Verify NO connection to production.example.com

## Summary Report

After all validations complete, provide a summary report with:

### Environment Confirmation

**✅ CONFIRMED:** Running in LOCAL DEV MODE
- Database: Local Docker PostgreSQL
- Configuration: `backend/.env.local`
- NO connection to CloudProvider production

### Validation Results

| Level | Command | Status | Time | Notes |
|-------|---------|--------|------|-------|
| 0 | Environment Check | ✅ PASS | 5s | LOCAL mode confirmed |
| 1 | Backend Compilation | ✅ PASS / ❌ FAIL | 30s | |
| 2 | Backend Unit Tests | ✅ PASS / ❌ FAIL | 60s | Tests run: X, Failures: 0 |
| 3 | Integration Tests (LOCAL) | ✅ PASS / ❌ FAIL | 120s | Tests run: X, Failures: 0 |
| 4 | Test Coverage | ✅ PASS / ❌ FAIL | 10s | Coverage: XX% |
| 5 | Frontend Type Check | ✅ PASS / ❌ FAIL | 15s | |
| 6 | Frontend Linting | ✅ PASS / ❌ FAIL | 10s | |
| 7 | Frontend Tests | ✅ PASS / ❌ FAIL | 30s | Tests pass: X |
| 8 | Frontend Build | ✅ PASS / ❌ FAIL | 45s | |
| 9 | DB Migration Check (LOCAL) | ✅ PASS / ❌ FAIL | 5s | |
| 10 | App Startup (LOCAL) | ✅ PASS / ❌ FAIL | 15s | Status: UP |

### Overall Health Assessment

**Status:** ✅ PASS / ❌ FAIL

**TEST PASSAGE REQUIREMENT:**
- ✅ Unit tests: ALL PASS (Failures: 0, Errors: 0)
- ✅ Integration tests: ALL PASS (Failures: 0, Errors: 0)
- ❌ If ANY test fails: VALIDATION FAILS (hard stop)

**Pass Rate:** X/11 validations passing

**Total Time:** X minutes

**Environment:** ✅ LOCAL DEV MODE (SAFE)

**NOTE:** Test passage is MANDATORY. Even if 10/11 validations pass, if tests fail, overall status is ❌ FAIL.

### Issues Found

**If any validations failed, document:**

1. **Level X - Validation Name**
   - **Error:** [Error message or output]
   - **Impact:** [What this means]
   - **Fix:** [How to fix it]

### Recommendations

**Based on validation results:**

- [ ] All validations passing - ready for code review
- [ ] Some validations failing - fix and re-run
- [ ] Coverage below 80% - add more tests
- [ ] Linting errors - fix style issues

## Safety Checklist

Before running validation, ALWAYS confirm:

- [ ] Using `backend/.env.local` (NOT `backend/.env`)
- [ ] Database URL points to localhost/127.0.0.1
- [ ] NO connection to production.example.com in configuration
- [ ] Started with `./start-local.sh` (NOT `./start.sh`)
- [ ] Testing data is disposable (NOT production data)

**If ANY of these checks fail:**
- ❌ STOP immediately
- ❌ DO NOT run validation
- ❌ Fix configuration first
- ❌ Re-check environment

## Troubleshooting

### Common Issues

**Issue: Backend compilation fails**
- **Check:** Java version (should be 24)
- **Fix:** Ensure JAVA_HOME points to Java 24
- **Command:** `java -version` should show 24

**Issue: Tests fail**
- **Check:** Test output for specific failure
- **Fix:** Debug failing test, fix implementation
- **Command:** `mvn test -Dtest=FailingTest` for single test

**Issue: Integration tests fail**
- **Check:** LOCAL Docker PostgreSQL is running
- **Fix:** Start local database with `./start-local.sh`
- **Command:** `docker ps | grep postgres`

**Issue: Accidentally connected to CloudProvider**
- **Symptoms:** Tests run against production data
- **Fix:** STOP immediately, check configuration
- **Verify:** `cat backend/.env.local | grep DATABASE_URL`
- **Safe:** URL should contain `localhost` or `127.0.0.1`
- **Unsafe:** URL contains `production.example.com`

**Issue: Coverage below 80%**
- **Check:** JaCoCo report for uncovered lines
- **Fix:** Add tests for uncovered code
- **Command:** Open `backend/target/site/jacoco/index.html`

**Issue: Frontend build fails**
- **Check:** TypeScript errors
- **Fix:** Fix type errors or add // @ts-ignore if necessary
- **Command:** `npm run type-check` for details

**Issue: Application won't start**
- **Check:** Application logs for errors
- **Fix:** Fix configuration issues
- **Command:** Check `backend/src/main/resources/application.properties`
- **Verify:** Using LOCAL database configuration

## Success Criteria

**Validation is considered PASSING when:**

- ✅ Running in LOCAL DEV mode (confirmed)
- ✅ All 11 validation levels pass
- ✅ Zero test failures
- ✅ Coverage >= 80%
- ✅ No compilation errors
- ✅ No linting errors
- ✅ Application starts successfully
- ✅ NO connection to CloudProvider production

**If any validation fails:**

- ❌ Fix the issue
- ❌ Re-run the failed validation
- ❌ Continue until all validations pass

---

**⚠️ CRITICAL REMINDERS:**

1. **ALWAYS** validate in LOCAL DEV MODE (`./start-local.sh`)
2. **NEVER** validate in PRODUCTION MODE (`./start.sh`)
3. **VERIFY** database URL points to localhost before running
4. **CHECK** configuration is using `.env.local` not `.env`
5. **STOP** if you see production.example.com in any connection string

**Remember:** Run validations in order. Don't skip levels. Fix failures before proceeding.

**Safety First:** Better to stop and check than to accidentally touch production data!

---

## Final State: Ready to Commit

**When ALL validations pass:**

### Report Success

```markdown
✅ ✅ ✅ ALL VALIDATIONS PASSED ✅ ✅ ✅

Feature Implementation: COMPLETE
Code Quality: VERIFIED
Test Coverage: ACHIEVED
Security: CHECKED
Performance: VALIDATED

SUMMARY:
- Files Created: X
- Files Modified: X
- Tests Added: X
- Test Coverage: XX%
- All Issues: RESOLVED

STATUS: ✅ READY TO COMMIT

The feature is complete and all quality gates have passed.
You can now commit this feature with confidence.

NEXT STEP: Run `/commit` to finish
```

### What This Means

- Code compiles without errors
- All tests pass (unit + integration)
- Test coverage meets requirements (≥80%)
- No critical or high priority issues
- Security scan passed
- Performance validated
- Environment verified (LOCAL mode)

### User Action Required

**Do NOT auto-commit** (manual approval gate)

User should:
1. Review the summary above
2. Check file list is correct
3. Verify test coverage is adequate
4. Run `/commit` when ready

### If Called Manually (Not From Execute)

Show:
- Validation results summary
- Pass/fail status for each check
- "Run `/commit` to finish if all validations passed"

Don't auto-chain (user is in control of manual flow).

### If Any Validation Fails

Don't reach "Ready State" - Instead:
- Tell user which validation failed
- Explain what went wrong
- Suggest how to fix
- Ask user to fix and re-run `/piv-speckit:validate`

**Only reach "Ready State" when ALL validations pass.**
