---
description: Root Cause Analysis for GitHub issues or direct bug descriptions
argument-hint: "<github-issue-url-or-number | \"direct:<bug-description>\">"
---

# Root Cause Analysis (RCA)

## Bug Source

Determine the source and analyze accordingly:

**Option 1: GitHub Issue**
```
$ARGUMENTS
```
Example: `https://github.com/your-org/repo/issues/123` or just `123`

**Option 2: Direct Bug Description**
```
direct:Bug description here
```
Example: `direct:Properties with special characters in address cause geocoding to fail`

## Purpose

Create a comprehensive Root Cause Analysis document for a bug or issue.

**Goal:** Understand the problem deeply before implementing a fix.

## RCA Process

### 1. Understand the Issue

**If analyzing a GitHub Issue:**
- Issue title and number
- Issue description
- Steps to reproduce
- Expected behavior
- Actual behavior
- Screenshots/logs if provided
- Labels, milestones, assignee
- Use `gh issue view <number>` to get full issue details

**If analyzing a direct bug description:**
- Parse the bug description from user input
- Ask clarifying questions if needed:
  - What is the expected behavior?
  - What is the actual behavior?
  - How can this be reproduced?
  - What is the impact (critical/high/medium/low)?
  - Which users or use cases are affected?
- Gather additional context:
  - When did this start happening?
  - Was it working before?
  - Any recent changes that might have caused it?

**Clarify Ambiguities:**
- If description is unclear, ask questions
- Get reproduction steps if missing
- Understand the impact (critical/high/medium/low)
- Identify affected users or use cases

### 2. Reproduce the Issue

**Can you reproduce it?**
- [ ] Yes - Successfully reproduced
- [ ] No - Cannot reproduce
- [ ] Partially - Can reproduce some scenarios

**Reproduction Steps:**
1. Step 1: [Description]
2. Step 2: [Description]
3. Step 3: [Description]
4. Step 4: [Issue occurs]

**Environment:**
- Mode: LOCAL / PRODUCTION (as applicable)
- Browser (if applicable):
- Data: [Specific data that triggers issue]

### 3. Analyze the Code

**Find Related Code:**
```bash
# Search for relevant files
grep -r "keyword" backend/src/main/java/
grep -r "keyword" frontend/src/

# Find related controllers
find backend/src/main/java -name "*Controller.java"

# Find related services
find backend/src/main/java -name "*Service.java"
```

**Read Related Files:**
- Controller handling the feature
- Service with business logic
- Repository/Entity for data access
- Frontend components
- Configuration files

**Understand the Flow:**
- Trace the code path
- Identify where the bug occurs
- Understand the data flow
- Note any edge cases

### 4. Identify Root Cause

**What is the root cause?**
- [ ] Logic error - [Describe]
- [ ] Missing validation - [Describe]
- [ ] Incorrect data handling - [Describe]
- [ ] Race condition - [Describe]
- [ ] Configuration issue - [Describe]
- [ ] External dependency - [Describe]
- [ ] Other: [Describe]

**Root Cause Statement:**
[Clear, concise statement of the root cause]

**Why did this happen?**
- [ ] Code didn't handle edge case
- [ ] Missing test coverage
- [ ] Requirements misunderstanding
- [ ] Refactoring introduced bug
- [ ] External API change
- [ ] Other: [Explain]

### 5. Design Fix Strategy

**Fix Options:**

**Option 1: [Description]**
- **Approach:** [How to fix]
- **Pros:** [Advantages]
- **Cons:** [Disadvantages]
- **Risk:** [Low/Medium/High]

**Option 2: [Description]**
- **Approach:** [How to fix]
- **Pros:** [Advantages]
- **Cons:** [Disadvantages]
- **Risk:** [Low/Medium/High]

**Recommended Fix:**
[Choose option and explain why]

**Fix Strategy:**
1. **Step 1:** [Description]
2. **Step 2:** [Description]
3. **Step 3:** [Description]

**Files to Modify:**
- `path/to/file1.java` - [What to change]
- `path/to/file2.java` - [What to change]

**Testing Strategy:**
- Unit tests needed: [Which tests]
- Integration tests needed: [Which tests]
- Edge cases to test: [List]
- Regression tests: [Which existing tests]

**Validation:**
- How to verify fix works: [Method]
- How to verify no regressions: [Method]

### 6. Assess Impact

**Current Impact:**
- Affected users: [Who is affected]
- Affected features: [What features]
- Data impact: [Is data corrupted?]
- Severity: [Critical/High/Medium/Low]

**Potential Side Effects:**
- [What could break when we fix this]
- [What depends on this code]
- [What needs regression testing]

### 7. Prevention Measures

**How to prevent this in future:**
- [ ] Add test: [Which test]
- [ ] Update code review checklist: [What]
- [ ] Update documentation: [What]
- [ ] Add monitoring: [What]
- [ ] Improve patterns: [How]

### 8. RCA Report

**Save RCA to:** `.claude/agents/reviews/rca-{issue-number}-{title}.md`

**Report Structure:**

```markdown
# Root Cause Analysis: Issue #{number}

**Date:** [Timestamp]
**Issue:** {Title}
**Severity:** {Critical/High/Medium/Low}
**Status:** In Progress

## Issue Summary

**Description:**
[Issue description]

**Expected Behavior:**
[What should happen]

**Actual Behavior:**
[What actually happens]

**Impact:**
- Affected users: [Who]
- Affected features: [What]
- Severity: [Level]

## Reproduction

**Can Reproduce:** [Yes/No/Partially]

**Reproduction Steps:**
1. [Step 1]
2. [Step 2]
3. [Step 3]
4. [Issue occurs]

**Environment:**
- Mode: [LOCAL/PRODUCTION]
- Data: [Specific data]

## Analysis

**Related Files:**
- `path/to/file1.java` - [Role]
- `path/to/file2.java` - [Role]

**Code Flow:**
[Describe the code path and where the bug occurs]

## Root Cause

**Root Cause:**
[Clear statement of the root cause]

**Why it Happened:**
[Explanation of why this bug was introduced]

## Fix Strategy

**Recommended Fix:**
[Description of the fix approach]

**Implementation Steps:**
1. [Step 1]
2. [Step 2]
3. [Step 3]

**Files to Modify:**
- `path/to/file1.java` - [What to change]
- `path/to/file2.java` - [What to change]

**Testing Strategy:**
- Unit tests: [Which tests]
- Integration tests: [Which tests]
- Edge cases: [List]

**Validation:**
- How to verify: [Method]
- Regression testing: [What tests]

## Impact

**Current Impact:**
- Users affected: [Who]
- Features affected: [What]
- Data impact: [Is data corrupted?]

**Potential Side Effects:**
- [What could break]
- [What needs testing]

## Prevention

**How to Prevent:**
- [ ] Add test: [Which]
- [ ] Update checklist: [What]
- [ ] Update docs: [What]
- [ ] Add monitoring: [What]

## Next Steps

1. Implement fix using: `/bug_fix:implement-fix <this-rca>`
2. Validate fix
3. Update prevention measures
4. Close issue

---

**RCA Status:** [In Review/Approved/Implementation Ready]
```

## Quality Checklist

Before marking RCA as complete:

- [ ] Root cause identified (not just symptoms)
- [ ] Can reproduce the issue
- [ ] Fix strategy is clear
- [ ] Testing strategy defined
- [ ] Impact assessed
- [ ] Prevention measures identified
- [ ] No critical gaps in understanding

---

**Remember:** A good RCA identifies the ROOT CAUSE, not just the symptom. Take time to understand deeply before fixing.
