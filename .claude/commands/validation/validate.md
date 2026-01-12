---
description: Run comprehensive validation pipeline (automatic after execute)
---

# Command: /validation:validate

**Phase: Validate**
**Purpose: Run comprehensive validation pipeline (automatic)**

---

## Command Definition

This command runs a comprehensive validation pipeline to ensure code quality. It is **automatically triggered** after `/core_piv_loop:execute` completes.

## Usage

```
/validation:validate
```

**Note**: This command runs automatically after `/core_piv_loop:execute`. Manual invocation is rarely needed.

---

## ⚠️ Environment Safety

### Critical Safety Rule

**ALWAYS** validate in **DEVELOPMENT/TEST environment**
**NEVER** validate against **PRODUCTION** data/services

### Environment Modes

#### Development Mode ✅ **USE THIS FOR VALIDATION**

**Characteristics:**
- Local database (Docker, SQLite, etc.)
- Local services and mocks
- Test data that can be discarded
- No connection to production systems

**When to use:**
- ✅ ALL validation and testing
- ✅ Feature development
- ✅ Bug fixing
- ✅ Experimentation

#### Production Mode ⚠️ **NEVER USE FOR VALIDATION**

**Characteristics:**
- Production database connection
- Production services
- Real user data

**When to use:**
- ✅ Production deployments ONLY
- ✅ Production release testing ONLY
- ❌ NEVER for feature development
- ❌ NEVER for validation/testing

### Safety Verification

Before running validation, ALWAYS confirm:

```bash
# Verify environment (examples - adapt to your project)
cat .env | grep DATABASE_URL
cat config/environment.yml | grep mode
```

**✅ SAFE:** Database URL contains `localhost`, `127.0.0.1`, `test`, or `dev`
**❌ UNSAFE:** Database URL contains production domains or IPs

---

## Validation Pipeline

### Level 0: Environment Safety
- Verifies environment (development vs production)
- Checks for safety guards
- Confirms destructive operations are disabled
- **Stops validation if environment is unsafe**

### Level 1: Compilation
- Compiles code without errors
- Checks for type errors
- Checks for syntax errors
- **Stops validation if compilation fails**

### Level 2: Unit Tests
- Runs all unit tests
- Ensures new tests pass
- Ensures existing tests still pass
- **Stops validation if tests fail**

### Level 3: Integration Tests (Optional)
- Runs integration tests (if applicable)
- Checks API contracts
- Verifies database operations
- **Warns if tests fail, doesn't stop**

### Level 4: Code Quality
- Runs linters
- Checks code formatting
- Scans for security vulnerabilities
- **Warns if issues found**

### Level 5: Coverage
- Measures test coverage
- Ensures coverage meets threshold (typically 80%+)
- Identifies untested code
- **Warns if below threshold**

### Level 6: Build
- Runs full build
- Generates assets
- Checks for build warnings
- **Stops validation if build fails**

---

## Validation Levels

```
┌─────────────────────────────────────────────────────┐
│              VALIDATION PIPELINE                     │
├─────────────────────────────────────────────────────┤
│ Level 0: Environment Safety          [Required]     │
│ Level 1: Compilation                 [Required]     │
│ Level 2: Unit Tests                  [Required]     │
│ Level 3: Integration Tests           [Optional]     │
│ Level 4: Code Quality                [Required]     │
│ Level 5: Coverage                    [Required]     │
│ Level 6: Build                       [Required]     │
└─────────────────────────────────────────────────────┘
```

---

## Technology-Specific Validation

### Java / Spring Boot
```bash
# Level 1: Compilation
cd backend && mvn clean compile

# Level 2: Unit Tests
cd backend && mvn test

# Level 3: Integration Tests
cd backend && mvn verify -DskipUnitTests=true

# Level 4: Code Quality
cd backend && mvn checkstyle:check
cd backend && mvn spotbugs:check

# Level 5: Coverage
cd backend && mvn jacoco:report

# Level 6: Build
cd backend && mvn package
```

### Node.js / JavaScript / TypeScript
```bash
# Level 1: Compilation (TypeScript)
npm run type-check
npm run build

# Level 2: Unit Tests
npm test

# Level 3: Integration Tests
npm run test:integration

# Level 4: Code Quality
npm run lint
npm audit

# Level 5: Coverage
npm test -- --coverage

# Level 6: Build
npm run build
```

### Python
```bash
# Level 1: Compilation
python -m py_compile src/**/*.py
mypy src/

# Level 2: Unit Tests
pytest

# Level 3: Integration Tests
pytest tests/integration/

# Level 4: Code Quality
flake8 src/
black --check src/
bandit -r src/

# Level 5: Coverage
pytest --cov=. --cov-report=html

# Level 6: Build
python setup.py build
pip install -e .
```

### React + TypeScript
```bash
# Level 1: Compilation
npm run type-check

# Level 2: Unit Tests
npm test

# Level 3: Integration Tests (if applicable)
npm run test:integration

# Level 4: Code Quality
npm run lint
npm audit

# Level 5: Coverage
npm test -- --coverage

# Level 6: Build
npm run build
```

---

## Expected Output

### Validation Report

File: `.claude/agents/reports/validation-report-{timestamp}.md`

```markdown
# Validation Report

**Run**: [Timestamp]
**Environment**: Development ✅
**Status**: ✅ PASS / ❌ FAIL

## Summary
| Level | Status | Details |
|-------|--------|---------|
| Environment | ✅ | Development mode confirmed |
| Compilation | ✅ | No errors, 3 warnings |
| Unit Tests | ✅ | 42/42 passed |
| Integration | ✅ | 15/15 passed |
| Code Quality | ✅ | No issues |
| Coverage | ✅ | 85% (threshold: 80%) |
| Build | ✅ | Success |

## Level 0: Environment Safety
✅ **Environment**: Development mode
✅ **Safety checks**: Enabled
✅ **Destructive ops**: Disabled

## Level 1: Compilation
✅ **Backend**: Compiled successfully
  - No compilation errors
  - 3 warnings (non-critical)

✅ **Frontend**: Compiled successfully
  - No type errors
  - No syntax errors

## Level 2: Unit Tests
✅ **Unit tests**: 42/42 passed
  - Backend: 28/28 passed
  - Frontend: 14/14 passed
  - Duration: 2.3s

## Level 3: Integration Tests
✅ **Integration tests**: 15/15 passed
  - API endpoints: 10/10 passed
  - Database: 5/5 passed
  - Duration: 5.1s

## Level 4: Code Quality
✅ **Linting**: No issues
  - ESLint: 0 errors, 0 warnings
  - Prettier: Formatted

✅ **Security**: No vulnerabilities
  - npm audit: 0 vulnerabilities
  - Dependency check: Passed

## Level 5: Coverage
✅ **Coverage**: 85%
  - Statements: 87%
  - Branches: 82%
  - Functions: 85%
  - Lines: 86%
  - Threshold: 80% ✅

## Level 6: Build
✅ **Build**: Success
  - Backend build: Success
  - Frontend build: Success
  - Assets generated: Yes

## Overall Result
✅ **VALIDATION PASSED**

All quality checks passed. Code is ready for commit.
```

### Console Output

```
🔄 Running validation pipeline...

Level 0: Environment Safety... ✅
Level 1: Compilation... ✅
Level 2: Unit Tests... ✅ (42/42 passed)
Level 3: Integration Tests... ✅ (15/15 passed)
Level 4: Code Quality... ✅
Level 5: Coverage... ✅ (85%)
Level 6: Build... ✅

✅ Validation complete
Status: PASSED
Report: .claude/agents/reports/validation-report-{timestamp}.md
```

---

## Stop on Failure Behavior

| Level | Stop on Failure? | Reason |
|-------|------------------|--------|
| 0 - Environment | ✅ Yes | Safety critical |
| 1 - Compilation | ✅ Yes | Can't proceed with errors |
| 2 - Unit Tests | ✅ Yes | Tests must pass |
| 3 - Integration | ⚠️ Warning | Optional, warn only |
| 4 - Code Quality | ⚠️ Warning | Warn, allow override |
| 5 - Coverage | ⚠️ Warning | Warn if below threshold |
| 6 - Build | ✅ Yes | Build must succeed |

---

## Failure Handling

### On Validation Failure

1. **STOP** validation pipeline
2. **REPORT** failure clearly
3. **IDENTIFY** root cause
4. **SUGGEST** fixes
5. **ALLOW** re-validation after fixes

Example failure output:
```
❌ Validation failed

Level 2: Unit Tests... ❌ FAILED

Failed tests:
  ❌ UserServiceTest.createDuplicateEmail
  ❌ AuthControllerTest.invalidToken

Fix issues and run /validation:validate again.
```

### Re-validation

After fixing issues:
```
User: /validation:validate

Re-running validation...
Level 0: Environment Safety... ✅
Level 1: Compilation... ✅
Level 2: Unit Tests... ✅ (42/42 passed - retries passed)
...

✅ Validation passed
```

---

## Troubleshooting

### Common Issues

**Issue: Compilation fails**
- **Check**: Language version and dependencies
- **Fix**: Ensure correct versions are installed
- **Command**: Check technology-specific version commands

**Issue: Tests fail**
- **Check**: Test output for specific failure
- **Fix**: Debug failing test, fix implementation
- **Command**: Run specific test for debugging

**Issue: Integration tests fail**
- **Check**: Test database and services are running
- **Fix**: Start required services
- **Command**: Check docker/local services

**Issue: Wrong environment detected**
- **Symptoms**: Tests run against production data
- **Fix**: STOP immediately, check configuration
- **Verify**: Environment variables and config files

**Issue: Coverage below threshold**
- **Check**: Coverage report for uncovered lines
- **Fix**: Add tests for uncovered code
- **Command**: Open coverage report (HTML format typically)

**Issue: Build fails**
- **Check**: Build logs for errors
- **Fix**: Fix build configuration or dependencies
- **Command**: Clean build (`mvn clean`, `rm -rf node_modules`, etc.)

---

## Configuration

### Coverage Threshold
Set coverage threshold in project configuration:

**JavaScript/TypeScript (Jest):**
```javascript
// jest.config.js
module.exports = {
  coverageThreshold: {
    global: {
      statements: 80,
      branches: 80,
      functions: 80,
      lines: 80
    }
  }
};
```

**Python (pytest):**
```bash
# .coveragerc or pytest.ini
[coverage:report]
fail_under = 80
```

**Java (JaCoCo):**
```xml
<!-- pom.xml -->
<configuration>
    <rules>
        <rule>
            <element>BUNDLE</element>
            <limits>
                <limit>
                    <counter>LINE</counter>
                    <value>COVEREDRATIO</value>
                    <minimum>0.80</minimum>
                </limit>
            </limits>
        </rule>
    </rules>
</configuration>
```

### Linting Rules
Configure linting rules in technology-specific files:

**JavaScript/TypeScript:**
```javascript
// .eslintrc.js
module.exports = {
  rules: {
    // Your rules
  }
};
```

**Python:**
```ini
# setup.cfg or .flake8
[flake8]
max-line-length = 88
extend-ignore = E203, W503
```

---

## Automatic Execution

This command runs **automatically** as part of `/core_piv_loop:execute`:

```
/core_piv_loop:execute
  │
  ├─▶ Execute implementation steps
  │
  └─▶ AUTOMATIC: /validation:validate
      │
      └─▶ Generate reports
```

---

## Artifacts Created

- `.claude/agents/reports/validation-report-{timestamp}.md` - Validation results

---

## Related Commands

- `/core_piv_loop:execute` - Triggers validation automatically
- `/validation:code-review` - Detailed code review (runs in parallel)
- `/validation:execution-report` - View execution report

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
Environment: DEVELOPMENT ✅

SUMMARY:
- Files Created: X
- Files Modified: X
- Tests Added: X
- Test Coverage: XX%
- All Issues: RESOLVED

STATUS: ✅ READY TO COMMIT

The feature is complete and all quality gates have passed.
You can now commit this feature with confidence.

NEXT STEP: Create a commit with your changes
```

### What This Means

- Code compiles without errors
- All tests pass (unit + integration)
- Test coverage meets requirements (≥80% or project threshold)
- No critical or high priority issues
- Security scan passed
- Environment verified (development mode)

### User Action Required

**Do NOT auto-commit** (manual approval gate)

User should:
1. Review the summary above
2. Check file list is correct
3. Verify test coverage is adequate
4. Create a commit when ready

### If Any Validation Fails

Don't reach "Ready State" - Instead:
- Tell user which validation failed
- Explain what went wrong
- Suggest how to fix
- Ask user to fix and re-run `/validation:validate`

**Only reach "Ready State" when ALL validations pass.**

---

**Validation ensures quality automatically. Trust the process and fix any failures.**

**Safety First:** Always verify you're in development mode before running validation!
