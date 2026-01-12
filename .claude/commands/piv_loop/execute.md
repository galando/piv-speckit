---
description: Execute an implementation plan step-by-step with automatic validation
argument-hint: "<path-to-plan.md>"
---

# Command: /core_piv_loop:execute

**Phase: Implement**
**Purpose: Execute implementation plan step-by-step**

---

## Command Definition

This command executes an implementation plan created by `/core_piv_loop:plan-feature`, following the steps systematically and creating/modifying files as specified.

## Usage

```
/core_piv_loop:execute [plan-name]
```

If no plan name is specified, uses the most recent plan.

**Example:** `.claude/agents/plans/feature-implementation.md`

---

## Execution Instructions

### 1. Read and Understand the Plan

**CRITICAL: Read the ENTIRE plan carefully first!**

- Read the plan file from start to finish
- Understand all tasks and their dependencies
- Note the validation commands to run
- Review the testing strategy
- **Read all "MUST READ" files listed in the plan**

**DO NOT skip this step!** The success of one-pass implementation depends on thorough understanding.

### 2. Read Prime Context

Before starting implementation, read the prime context to understand the codebase:

```bash
Read .claude/agents/context/prime-context.md
```

This provides the overall codebase context that the plan builds upon.

### 3. Read All Mandatory Files

The plan lists files under "CONTEXT REFERENCES" or "Relevant Codebase Files (MUST READ!)"

**Read each file carefully:**
- Pay attention to patterns used
- Note naming conventions
- Understand error handling approaches
- Observe logging patterns

**Example:**
```bash
# Read relevant pattern files based on your technology
# Backend patterns (if applicable)
Read backend/src/main/java/com/example/controller/ExampleController.java
Read backend/src/main/java/com/example/service/ExampleService.java

# Frontend patterns (if applicable)
Read frontend/src/components/ExampleComponent.tsx
Read frontend/src/api/exampleApi.ts
```

### 4. Execute Tasks in Order

For EACH task in the implementation steps:

#### a. Navigate to the task

- Identify the file and action required
- Read existing related files if modifying
- Check if file exists (for UPDATE tasks)

#### b. Implement the task

- **Follow the detailed specifications exactly**
- Maintain consistency with existing code patterns
- Include proper type annotations
- Add structured logging where appropriate
- Follow naming conventions from the plan

#### c. Verify as you go

- After each file change, check syntax
- Ensure imports are correct
- Verify types are properly defined

#### d. Run validation command (if specified)

**CRITICAL:** Run the validation command specified in the task:

```bash
# Example validation commands (technology-specific)
# Backend (Java/Spring Boot):
cd backend && mvn clean compile

# Backend (Node.js):
npm run build

# Tests:
mvn test -Dtest=ExampleServiceTest  # Java
npm test -- ExampleService.test     # JavaScript
```

**If validation fails:**
- Fix the issue
- Re-run the validation command
- Continue only when it passes

**DO NOT skip validation!** Each task has a validation command for a reason.

### 5. Implement Testing Strategy

After completing implementation tasks:

- **Create all test files** specified in the plan
- **Implement all test cases** mentioned
- **Follow the testing approach** outlined in the plan
- **Ensure tests cover edge cases**

**Run tests after creating each test file:**

```bash
# Backend tests (technology-specific examples)
mvn test -Dtest=NewServiceTest          # Java
pytest tests/test_new_service.py       # Python
npm test -- NewService.test            # JavaScript

# Integration tests
mvn test -Dtest=NewControllerIT        # Java
pytest tests/integration/              # Python
npm test -- NewController.integration  # JavaScript
```

### 6. Run All Validation Commands

Execute **ALL validation commands** from the plan in order:

```bash
# Example validation flow (adapt to your technology stack)

# Level 1: Compilation
# Java: cd backend && mvn clean compile
# Node: npm run build
# Python: python -m py_compile src/**/*.py

# Level 2: Unit Tests
# Java: cd backend && mvn test
# Node: npm test
# Python: pytest

# Level 3: Integration Tests
# Java: cd backend && mvn verify -DskipUnitTests=true
# Node: npm run test:integration
# Python: pytest tests/integration/

# Level 4: Test Coverage
# Java: cd backend && mvn jacoco:report
# Node: npm test -- --coverage
# Python: pytest --cov=. --cov-report=html

# Level 5: Build
# Java: cd backend && mvn package
# Node: npm run build
# Python: python setup.py build

# Level 6: Manual Validation (feature-specific)
# (Run any manual testing steps from the plan)
```

**If any command fails:**

1. Identify the failure
2. Fix the issue
3. Re-run the failed command
4. Continue only when it passes

**DO NOT proceed to next validation level until current level passes!**

### 7. Final Verification

Before completing implementation, verify:

**Code Quality:**
- ✅ All tasks from plan completed
- ✅ Code follows project conventions
- ✅ Proper error handling implemented
- ✅ Structured logging added (if applicable)
- ✅ Proper data transfer objects used
- ✅ Framework patterns followed correctly

**Testing:**
- ✅ All tests created and passing
- ✅ Unit tests cover new functionality
- ✅ Integration tests verify workflows
- ✅ Edge cases tested
- ✅ Coverage meets project requirements (typically ≥80%)

**Validation:**
- ✅ All validation commands pass
- ✅ No compilation errors
- ✅ No test failures
- ✅ No linting errors
- ✅ Build completes successfully

**Acceptance Criteria:**
- ✅ All acceptance criteria met
- ✅ Feature works as specified
- ✅ No regressions in existing functionality
- ✅ Documentation updated (if required)

---

## Output Report

Provide completion summary:

### Completed Tasks

List all tasks completed:

- ✅ Task 1: CREATE ExampleController.java / ExampleService.ts
- ✅ Task 2: CREATE ExampleRepository.java / exampleRepository.ts
- ✅ Task 3: CREATE migration / database change
- ✅ Task 4: CREATE ExampleServiceTest.java / ExampleService.test.ts
- ✅ Task 5: CREATE ExampleComponent.tsx

### Files Created

List all new files with paths:

**Backend (if applicable):**
- `backend/src/main/java/com/example/controller/ExampleController.java`
- `backend/src/main/java/com/example/service/ExampleService.java`
- `backend/src/main/java/com/example/repository/ExampleRepository.java`
- `backend/src/main/resources/db/migration/V{next}__description.sql`
- `backend/src/test/java/com/example/service/ExampleServiceTest.java`

**Frontend (if applicable):**
- `frontend/src/components/ExampleComponent.tsx`
- `frontend/src/api/exampleApi.ts`

### Files Modified

List all modified files with paths:

- `backend/src/main/resources/application.properties` (added new config)
- `frontend/src/api/exampleApi.ts` (added new API endpoint)

### Tests Added

**Test Files Created:**
- `backend/src/test/java/com/example/service/ExampleServiceTest.java` - X test cases

**Test Cases Implemented:**
- Unit tests: X tests covering all service methods
- Integration tests: X tests verifying end-to-end workflows
- Edge cases: X tests covering error scenarios

**Test Results:**

```bash
# Paste test output here
[INFO] Tests run: X, Failures: 0, Errors: 0, Skipped: 0
```

### Validation Results

**Level 1: Compilation**
```bash
# Technology-specific command
# Output: BUILD SUCCESS
```

**Level 2: Unit Tests**
```bash
# Technology-specific command
# Output: Tests run: X, Failures: 0, Errors: 0
```

**Level 3: Integration Tests**
```bash
# Technology-specific command
# Output: Tests run: X, Failures: 0
```

**Level 4: Test Coverage**
```bash
# Technology-specific command
# Output: Coverage: XX% (meets XX% requirement)
```

**Level 5: Build**
```bash
# Technology-specific command
# Output: Build completed successfully
```

**Level 6: Manual Validation**
- ✅ Tested API endpoint
- ✅ Verified UI navigation
- ✅ Verified database changes

### Overall Status

**Status:** ✅ PASS

**Summary:**
- All X tasks completed successfully
- X tests added, all passing
- Test coverage: XX%
- All validation commands passing
- Manual testing confirms feature works
- Ready for automatic validation

### Ready for Automatic Validation

Confirm:
- ✅ All changes are complete
- ✅ All validations pass
- ✅ Proceeding to automatic validation flow

---

## Notes

**If you encounter issues not addressed in the plan:**

1. **Document them** in the execution report
2. **Explain why** you deviated from the plan
3. **Describe the solution** you implemented

**If tests fail:**

1. Fix implementation until tests pass
2. DO NOT modify tests to make them pass
3. Ensure tests are testing correct behavior

**If validation commands fail:**

1. Identify root cause
2. Fix the issue
3. Re-run the validation command
4. Continue until all validations pass

**Important:**
- Don't skip validation steps
- Don't skip reading "MUST READ" files
- Don't deviate from plan without documenting why
- Don't proceed until each validation passes

---

## Next Steps (AUTOMATIC)

**IMPORTANT:** The following steps now run AUTOMATICALLY to ensure code quality.

### Automatic Validation Flow

After implementation completes, the system will **automatically**:

1. **Run Code Review** - Technical quality analysis
   - Checks for bugs, security issues, performance problems
   - Verifies project standards compliance
   - If issues found → Auto-fix and re-review

2. **Run System Review** (Parallel) - Process improvement analysis
   - Analyzes PIV process quality
   - Documents lessons learned
   - Identifies future improvements (doesn't block)

3. **Run Final Validation** - Complete validation suite
   - Compilation verification
   - Unit tests
   - Integration tests
   - Coverage check (≥ project threshold)
   - Security scan
   - Performance check (if applicable)

4. **Ready State** - Stop when all pass
   - Report: "✅ FEATURE COMPLETE - ALL VALIDATIONS PASSED"
   - Summary: Files created, tests added, coverage achieved
   - Next step: **Ready to commit**

### What You Need To Do

**During automatic flow:**
- Watch progress (you'll see each step running)
- If manual fixes needed → System will ask you
- If automatic fixes possible → System will apply them
- Loop until all validations pass

**When feature is complete:**
- You'll see: "✅ READY TO COMMIT"
- Review the summary
- Create a commit with your changes

### Manual Override (Optional)

If you want to skip automatic validation and run manually:

```bash
# Skip automatic flow, run individual commands
/validation:code-review
/validation:code-review-fix <report-path>
/validation:validate
```

**But why?** Automatic flow ensures consistent quality and catches issues early.

---

## Artifacts Created

- **Code files**: As specified in plan
- **Test files**: For all new code
- `.claude/agents/reports/execution-report-{feature-name}.md` - Execution summary
- `.claude/agents/reports/validation-report-{timestamp}.md` - Validation results (automatic)

---

## Related Commands

- `/core_piv_loop:prime` - Load context before executing
- `/core_piv_loop:plan-feature` - Create plan (before execute)
- `/validation:validate` - Run validation (automatic after execute)
- `/validation:code-review` - Detailed code review (automatic)
- `/validation:execution-report` - View execution report

---

**Execution follows the plan systematically. Deviate only when necessary and document why.**

**Validation runs automatically to ensure quality.**

**Remember:** The goal is one-pass implementation with automatic quality gates. If you followed the plan and all validations pass, you succeeded! 🎉
