---
description: Generate implementation report after executing a plan
argument-hint: "<path-to-plan.md>"
---

# Execution Report: Implementation Summary

> **Full methodology:** `$CLAUDE_PLUGIN_ROOT/.claude-plugin/reference/methodology/PIV-METHODOLOGY.md`

## Plan

Read the executed plan: `$ARGUMENTS`

**Example:** `.claude/agents/plans/example-feature-address-validation.md`

## Purpose

Generate a comprehensive report after implementing a feature using the PIV methodology.

This report:
- Documents what was implemented
- Records validation results
- Captures lessons learned
- Identifies areas for improvement
- Provides metrics for process improvement

## Execution Steps

### Step 1: Read the Plan

```bash
Read $ARGUMENTS
```

Extract from the plan:
- Feature name and description
- All tasks that were listed
- Expected outcomes
- Validation commands specified

### Step 2: Review Implementation

Check what was actually implemented:

```bash
# Get list of changed files
git status

# Get summary of changes
git diff --stat HEAD

# List new files
git ls-files --others --exclude-standard
```

Identify:
- Files created
- Files modified
- Tests added
- Any deviations from the plan

### Step 3: Review Validation Results

Check if validation commands were run and their results:
- Compilation: ✅/❌
- Unit tests: ✅/❌ with count
- Integration tests: ✅/❌ with count
- Coverage: percentage
- Frontend build: ✅/❌

### Step 4: Review Code Review Results

If code review was run, check:
- Issues found by severity
- Issues fixed
- Final assessment

### Step 5: Generate Report

Create report at: `.claude/agents/execution-reports/{feature-name}-report.md`

Use the structure below to document the implementation.

## Report Structure

### 1. Implementation Summary

**Feature:** [Feature name]
**Date:** [Timestamp]
**Branch:** [Branch name]
**Plan:** [Path to plan]
**Execution Time:** [Start to finish duration]

### 2. Completed Tasks

List all tasks from the plan that were completed:

**Foundation Tasks:**
- ✅ Task 1: [Description]
- ✅ Task 2: [Description]

**Core Implementation Tasks:**
- ✅ Task 3: [Description]
- ✅ Task 4: [Description]

**Integration Tasks:**
- ✅ Task 5: [Description]
- ✅ Task 6: [Description]

**Testing Tasks:**
- ✅ Task 7: [Description]
- ✅ Task 8: [Description]

**Total:** X tasks completed

### 3. Files Created

**Backend:**
- `backend/src/main/java/com/example/controller/NewController.java` - [Purpose]
- `backend/src/main/java/com/example/service/NewService.java` - [Purpose]
- `backend/src/main/java/com/example/repository/NewRepository.java` - [Purpose]
- `backend/src/main/java/com/example/dto/NewDTO.java` - [Purpose]
- `backend/src/main/resources/db/migration/V{next}__description.sql` - [Purpose]

**Frontend:**
- `frontend/src/components/NewComponent.tsx` - [Purpose]

**Tests:**
- `backend/src/test/java/com/example/service/NewServiceTest.java` - X test cases
- `backend/src/test/java/com/example/controller/NewControllerIT.java` - X integration tests

**Total:** X files created

### 4. Files Modified

**Backend:**
- `backend/src/main/resources/application.properties` - Added new configuration

**Frontend:**
- `frontend/src/api/exampleApi.ts` - Added new API endpoint

**Total:** X files modified

### 5. Tests Added

**Unit Tests:**
- `NewServiceTest.java` - X test cases
  - Test case 1: [Description]
  - Test case 2: [Description]
  - ...

**Integration Tests:**
- `NewControllerIT.java` - X integration tests
  - Test case 1: [Description]
  - Test case 2: [Description]
  - ...

**Total:** X test cases added

### 6. Validation Results

**Level 0: Environment Verification**
```bash
cat backend/.env.local | grep DATABASE_URL | grep -v "production.example.com"
```
**Result:** ✅ PASS - LOCAL mode confirmed

**Level 1: Backend Compilation**
```bash
cd backend && mvn clean compile
```
**Result:** ✅ PASS / ❌ FAIL
**Output:** [Build output or error messages]
**Duration:** X seconds

**Level 2: Backend Unit Tests**
```bash
cd backend && mvn test
```
**Result:** ✅ PASS / ❌ FAIL
**Tests Run:** X
**Failures:** 0
**Errors:** 0
**Skipped:** 0
**Duration:** X seconds

**Level 3: Integration Tests (LOCAL)**
```bash
cd backend && mvn verify -DskipUnitTests=true
```
**Result:** ✅ PASS / ❌ FAIL
**Tests Run:** X
**Failures:** 0
**Errors:** 0
**Duration:** X seconds

**Level 4: Test Coverage**
```bash
cd backend && mvn jacoco:report
```
**Result:** ✅ PASS / ❌ FAIL
**Coverage:** XX%
**Target:** >= 80%
**Status:** Meets requirement / Below requirement

**Level 5: Frontend Build**
```bash
cd frontend && npm run build
```
**Result:** ✅ PASS / ❌ FAIL
**Output:** Build output or error messages
**Duration:** X seconds

**Level 6: Manual Validation (LOCAL)**
- ✅ Tested API endpoint: `/api/new`
- ✅ Verified UI: `/new-page` works correctly
- ✅ Verified database: Tables created in LOCAL PostgreSQL

**Overall Validation Status:** ✅ ALL PASS / ❌ SOME FAILURES

### 7. Code Review Results

**Review Date:** [Timestamp]
**Review Report:** [Path to code review report if generated]

**Issues Found:**
- Critical: X
- High: X
- Medium: X
- Low: X

**Issues Fixed:**
- Critical: X/X fixed
- High: X/X fixed
- Medium: X/X fixed (or X deferred)
- Low: X/X deferred

**Final Assessment:** ✅ PASS / NEEDS FIXES

### 8. Plan Quality Assessment

**Was the plan comprehensive?**
- [ ] Yes - All information needed was present
- [ ] Mostly yes - Minor gaps, had to research a few things
- [ ] No - Significant gaps, had to research extensively

**Was the plan accurate?**
- [ ] Yes - All patterns and examples were correct
- [ ] Mostly yes - Minor corrections needed
- [ ] No - Significant corrections needed

**Did the plan enable one-pass implementation?**
- [ ] Yes - Implemented in one pass with no rework
- [ ] Mostly yes - Minor rework needed
- [ ] No - Significant rework required

**Plan Completeness Score:** X/10

**What was missing from the plan?**
- [List missing information, patterns, or validation commands]

**What was inaccurate in the plan?**
- [List inaccurate information or examples]

### 9. Example Standards Compliance

**Spring Data JDBC:**
- ✅ Used Spring Data JDBC (not JPA)
- ✅ Simple entities, no JPA annotations
- ✅ Repository pattern correct

**Constructor Injection:**
- ✅ Used @RequiredArgsConstructor
- ✅ No field injection

**DTOs:**
- ✅ Used DTOs in API responses
- ✅ Did not return entities from controllers

**Logging:**
- ✅ Structured logging with SLF4J
- ✅ Proper log levels used
- ✅ No sensitive data logged

**Error Handling:**
- ✅ Graceful degradation
- ✅ Continue processing on non-critical errors
- ✅ Proper exception handling

**Environment Safety:**
- ✅ All configuration via properties
- ✅ No hardcoded URLs
- ✅ Safe for LOCAL and PROD modes

**Overall Compliance:** ✅ COMPLIANT / ❌ VIOLATIONS

### 10. Deviations from Plan

**Did you deviate from the plan?**
- [ ] No - Followed plan exactly
- [ ] Minor deviations - [Explain]
- [ ] Major deviations - [Explain why]

**If deviations occurred, document:**

**Deviation 1:**
- **Planned:** [What was planned]
- **Actual:** [What was done]
- **Reason:** [Why deviation was necessary]
- **Impact:** [Impact on implementation]

### 11. Challenges and Solutions

**Challenge 1:**
- **Issue:** [Description of challenge]
- **Solution:** [How it was resolved]
- **Time Impact:** [How much time it added]

**Challenge 2:**
- **Issue:** [Description of challenge]
- **Solution:** [How it was resolved]
- **Time Impact:** [How much time it added]

### 12. Lessons Learned

**What went well:**
- [Positive aspects of the implementation]
- [What made this implementation successful]

**What could be improved:**
- [Aspects that could be better]
- [What to do differently next time]

**Process Improvements:**
- [Suggestions for improving PIV workflow]
- [Patterns that should be documented]
- [Validation commands that should be added]

### 13. Time Tracking

**Planning Phase:**
- Plan creation: X hours
- Plan review: X hours
- **Total Planning:** X hours

**Implementation Phase:**
- Implementation: X hours
- Testing: X hours
- Validation: X hours
- **Total Implementation:** X hours

**Total Time:** X hours

**Estimated vs Actual:**
- **Estimated:** X hours
- **Actual:** X hours
- **Variance:** X hours (X%)

### 14. Next Steps

**Immediate:**
- [ ] Fix any remaining issues (if applicable)
- [ ] Complete code review fixes (if applicable)
- [ ] Commit changes

**Follow-up:**
- [ ] Monitor in production (if applicable)
- [ ] Gather user feedback
- [ ] Address deferred medium/low priority issues

**Process Improvements:**
- [ ] Update PIV templates based on lessons learned
- [ ] Add missing patterns to reference docs
- [ ] Improve validation commands
- [ ] Share findings with team

### 15. Recommendations

**For Future Implementations:**
- [Advice for similar features]
- [Patterns to follow]
- [Pitfalls to avoid]

**For PIV Process:**
- [Suggestions to improve planning phase]
- [Suggestions to improve execution phase]
- [Suggestions to improve validation phase]

## Save Report

**Location:** `.claude/agents/execution-reports/{feature-name}-report.md`

**Example:** `.claude/agents/execution-reports/example-feature-validation-report.md`

## Use Cases for Reports

1. **Documentation:** Keep record of what was implemented
2. **Process Improvement:** Identify patterns to document
3. **Team Learning:** Share lessons learned
4. **Metrics:** Track implementation time and quality
5. **Post-Mortem:** Reference if issues arise in production

---

**Remember:** The goal is continuous improvement. Each implementation makes the next one better!
