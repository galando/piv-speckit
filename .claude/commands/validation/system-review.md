---
description: Analyze implementation vs plan for process improvements
argument-hint: "<path-to-plan.md> <path-to-execution-report.md>"
---

# System Review: Process Improvement Analysis

## Inputs

**Plan:** `$ARGUMENTS_1` (path to plan)
**Execution Report:** `$ARGUMENTS_2` (path to execution report)

**Example:**
```bash
/validation:system-review .claude/agents/plans/feature-name.md .claude/agents/reports/execution-report-feature-name.md
```

## Purpose

Analyze the implementation process to identify:
- Plan quality and completeness
- Execution efficiency
- Validation effectiveness
- Process improvements needed
- Patterns to document

This is NOT about the code quality (that's code-review). This is about improving the PIV PROCESS.

## Analysis Process

### 1. Compare Plan vs Actual

**Read the plan:**
- What was planned?
- What patterns were documented?
- What validation commands were specified?

**Read the execution report:**
- What was actually implemented?
- What deviations occurred?
- What challenges were encountered?
- What was the plan quality score?

**Identify gaps:**
- What was missing from the plan?
- What was inaccurate in the plan?
- What caused rework or delays?

### 2. Analyze Plan Quality

**Completeness:**
- Were all necessary files listed?
- Were all patterns documented?
- Were all validation commands included?
- Was context sufficient?

**Accuracy:**
- Were code examples correct?
- Were pattern references accurate?
- Were file paths correct?
- Were dependencies documented?

**One-Pass Implementation:**
- Did the plan enable one-pass implementation?
- If not, why not?
- What was missing?

**Score Plan Quality:**
- Context completeness: X/10
- Accuracy: X/10
- Implementation readiness: X/10
- **Overall Plan Quality:** X/10

### 3. Analyze Execution Efficiency

**Time Tracking:**
- Planning time: X hours
- Implementation time: X hours
- Validation time: X hours
- **Total time:** X hours

**Estimated vs Actual:**
- Estimated: X hours
- Actual: X hours
- Variance: X%

**Rework Analysis:**
- How much rework was needed?
- What caused the rework?
- Could it have been prevented?

**Challenges:**
- What challenges occurred?
- How were they resolved?
- Could they have been anticipated?

### 4. Analyze Validation Effectiveness

**Validation Commands:**
- Did all validation commands pass?
- Were any validation commands missing?
- Were any validation commands incorrect?
- Did validation catch real issues?

**Code Review:**
- How many issues were found?
- What severity levels?
- Could these have been prevented?
- Were the issues due to plan gaps?

**Test Coverage:**
- Was coverage >= 80%?
- Were critical paths tested?
- Were edge cases tested?
- Were integration tests sufficient?

### 5. Identify Patterns to Document

**New Patterns Found:**
- What new patterns emerged during implementation?
- What existing patterns should be documented better?
- What anti-patterns were discovered?

**Code Examples:**
- What code examples should be added to reference docs?
- What patterns need better documentation?

**Best Practices:**
- What best practices should be added?
- What lessons should be shared?

### 6. Identify Process Improvements

**Planning Phase Improvements:**
- What should be added to the planning template?
- What research should be done during planning?
- What validation should be included?

**Execution Phase Improvements:**
- What should be clarified in plans?
- What validation commands should be added?
- What guidance should be improved?

**Validation Phase Improvements:**
- What validations should be added?
- What should be checked during code review?
- What metrics should be tracked?

## Output Report

### 1. Executive Summary

**Feature:** [Feature name]
**Date:** [Timestamp]
**Plan Quality Score:** X/10
**Implementation Success:** One-pass / Rework required
**Overall Assessment:** [Excellent/Good/Fair/Poor]

### 2. Plan Quality Analysis

**Strengths:**
- [What was good about the plan]
- [What enabled success]

**Weaknesses:**
- [What was missing]
- [What was inaccurate]
- [What caused confusion]

**Missing Information:**
- [List missing patterns, files, validation commands]

**Inaccurate Information:**
- [List incorrect information]

**Recommendations for Planning:**
- [How to improve future plans]
- [What to add to planning template]
- [What research to do during planning]

### 3. Execution Analysis

**Efficiency:**
- **Time Tracking:**
  - Planning: X hours (X% of total)
  - Implementation: X hours (X% of total)
  - Validation: X hours (X% of total)
  - **Total:** X hours

- **Estimated vs Actual:**
  - Estimated: X hours
  - Actual: X hours
  - Variance: X%

**Rework Required:**
- [Yes/No]
- If yes:
  - What caused rework?
  - How much time was lost?
  - Could it have been prevented?

**Challenges Faced:**
1. **Challenge:** [Description]
   - **Impact:** [Time/complexity]
   - **Resolution:** [How solved]
   - **Prevention:** [How to prevent in future]

2. **Challenge:** [Description]
   - **Impact:** [Time/complexity]
   - **Resolution:** [How solved]
   - **Prevention:** [How to prevent in future]

### 4. Validation Analysis

**Validation Results:**
- All validations passed: [Yes/No]
- If no, what failed and why?

**Code Review Results:**
- Issues found: X (X critical, X high, X medium, X low)
- Issues fixed: X/X
- Could these have been prevented during planning?

**Test Coverage:**
- Coverage achieved: XX%
- Sufficient: [Yes/No]
- What gaps exist?

### 5. Patterns to Document

**New Patterns:**
1. **Pattern Name:** [Description]
   - **File:** [Where it was found]
   - **Use Case:** [When to use it]
   - **Code Example:** [Include example]
   - **Should be added to:** [Which reference doc]

2. **Pattern Name:** [Description]
   - **File:** [Where it was found]
   - **Use Case:** [When to use it]
   - **Code Example:** [Include example]
   - **Should be added to:** [Which reference doc]

**Improved Documentation Needed:**
- [Which patterns need better docs]
- [What examples should be added]

**Anti-Patterns to Document:**
- [What to avoid]
- [Add to anti-patterns documentation]

### 6. Process Improvement Recommendations

**Planning Process:**

**Add to Plan Template:**
- [What sections to add]
- [What questions to ask]
- [What research to do]

**Improve Reference Docs:**
- [What patterns to document]
- [What examples to add]
- [What sections to improve]

**Improve Validation:**
- [What validation commands to add]
- [What checks to include]
- [What metrics to track]

**Improve Code Review:**
- [What checks to add]
- [What patterns to look for]

### 7. Action Items

**Immediate Actions:**
- [ ] Update reference doc: [Which one] with [what]
- [ ] Add pattern to: [Which doc]
- [ ] Update planning template with: [what]
- [ ] Add validation command: [what]

**Future Improvements:**
- [ ] Research: [topic] for future plans
- [ ] Document: [pattern] in reference docs
- [ ] Create: [new reference doc] for [topic]

### 8. Lessons Learned

**What Went Well:**
- [Positive aspects]
- [Should be repeated]

**What Didn't Go Well:**
- [Negative aspects]
- [Should be avoided]

**Key Takeaways:**
- [Main lessons]
- [Share with team]

### 9. Overall Assessment

**PIV Process Maturity:** [Emerging/Developing/Mature/Optimizing]

**Readiness for Next Feature:**
- [ ] Yes - Process is solid
- [ ] Mostly yes - Minor improvements needed
- [ ] Somewhat - Moderate improvements needed
- [ ] No - Significant improvements needed

**Confidence in One-Pass Implementation:**
- Current: X/10
- Target: 8/10
- Gap: What needs to improve to reach target?

## Save Report

**Location:** `.claude/agents/reviews/system-review-{feature-name}.md`

**Example:** `.claude/agents/reviews/system-review-user-authentication.md`

## Use Cases

1. **Process Improvement:** Identify what to improve in PIV workflow
2. **Knowledge Capture:** Document patterns and lessons learned
3. **Team Learning:** Share findings with team
4. **Template Refinement:** Improve planning and validation templates
5. **Metrics:** Track process maturity over time

---

**Remember:** The goal is continuous process improvement. Each implementation should make the next one better!
