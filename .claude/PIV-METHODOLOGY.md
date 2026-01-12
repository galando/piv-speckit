# PIV Methodology

**Prime - Implement - Validate**

A development methodology designed specifically for AI-assisted software development with Claude Code.

---

## Overview

PIV (Prime-Implement-Validate) is a methodology designed for AI-assisted software development with Claude Code. It ensures proper context, systematic implementation, and automatic validation. An optional Simplify phase helps maintain code quality over time.

The methodology is designed to minimize misunderstandings, reduce rework, and maintain code quality through systematic planning and automatic validation.

### The PIV Phases

```
┌──────────────────────────────────────────────────────────────────┐
│                         PIV METHODOLOGY                          │
│                                                                  │
│  ┌──────────┐    ┌──────────────┐    ┌──────────┐            │
│  │  PRIME   │───▶│   IMPLEMENT  │───▶│ SIMPLIFY │ (Optional) │
│  │          │    │              │    │          │            │
│  │ Context  │    │  Plan        │    │  Clean   │            │
│  │ Loading  │    │  Execute     │    │  Refactor│            │
│  └──────────┘    └──────────────┘    └────┬─────┘            │
│                                              │                  │
│                                              ▼                  │
│                                       ┌──────────┐            │
│                                       │ VALIDATE │            │
│                                       │          │            │
│                                       │  Auto    │            │
│                                       │  Tests   │            │
│                                       └────┬─────┘            │
│                                            │                  │
│                                            ▼                  │
│                                      ┌──────────┐            │
│                                      │  Report  │            │
│                                      │ & Refine │            │
│                                      └──────────┘            │
└──────────────────────────────────────────────────────────────────┘
```

---

## Phase 1: Prime

**Goal: Load comprehensive codebase context**

### What Happens
- Claude Code analyzes the entire codebase structure
- Identifies key patterns, conventions, and architecture
- Loads project-specific rules and guidelines
- Creates context artifacts for reference

### When to Use
- **Start of session**: Run before any work
- **Context switch**: When switching between features
- **After major changes**: When significant changes have been made
- **New feature**: Before implementing new work

### Commands
```
/core_piv_loop:prime
```

### Artifacts Created
- `.claude/agents/context/prime-context.md` - Comprehensive context document

### What Gets Analyzed
- Project structure and organization
- Technology stack and frameworks
- Coding conventions and patterns
- Architecture and design patterns
- Dependencies and integrations
- Testing approach and coverage
- Documentation and guides

### Success Criteria
- [ ] Claude can answer questions about codebase structure
- [ ] Claude understands technology choices
- [ ] Claude knows coding conventions
- [ ] Claude identifies key files and their purposes
- [ ] Context artifact is created and saved

---

## Phase 2: Implement

**Goal: Plan and execute features systematically**

The Implement phase combines planning AND execution into a unified flow.

### What Happens

#### Step 1: Plan (`/core_piv_loop:plan-feature`)
- Feature requirements are gathered and clarified
- Technical approach is designed
- Architecture decisions are documented
- Implementation steps are broken down
- Files to create/modify are listed
- Verification criteria are defined

#### Step 2: Execute (`/core_piv_loop:execute`)
- Implementation follows the plan step-by-step
- Code is written following all applicable rules
- Changes are made incrementally
- Progress is tracked against the plan

### When to Use

#### Plan Feature
- **Complex features**: Multi-file or architectural changes
- **New functionality**: Features that require design decisions
- **Refactoring**: Changes that affect multiple components
- **Integration**: Adding new dependencies or services

#### Execute
- **After planning**: Always execute from a plan (for complex work)
- **Simple changes**: Can execute directly for minor tweaks
- **Bug fixes**: Execute based on RCA or issue description

### Commands

#### Planning
```
/core_piv_loop:plan-feature "Feature description"
```

#### Execution
```
/core_piv_loop:execute [plan-name]
```

### Artifacts Created

#### Plan Artifact
`.claude/agents/plans/{feature-name}.md`

**Plan Structure:**
```markdown
# Feature: [Feature Name]

## Context
[Context from Prime phase about relevant parts of codebase]

## Requirements
[Detailed functional and non-functional requirements]

## Technical Approach
[Architecture decisions, design patterns, technology choices]

## Implementation Steps
1. [Step 1]
2. [Step 2]
3. [Step 3]
...

## Files to Create
- `path/to/file1.ext` - [Purpose]
- `path/to/file2.ext` - [Purpose]

## Files to Modify
- `path/to/existing.ext` - [Changes needed]

## Testing Strategy
- Unit tests needed: [List]
- Integration tests needed: [List]
- Manual verification steps: [List]

## Verification Criteria
- [ ] Criterion 1
- [ ] Criterion 2
- [ ] Criterion 3

## Dependencies
[What needs to be done first]

## Notes
[Additional considerations, edge cases, risks]
```

#### Execution Report
`.claude/agents/reports/execution-report-{feature-name}.md`

### Success Criteria

#### Planning
- [ ] All requirements are clearly defined
- [ ] Technical approach is justified
- [ ] Implementation steps are actionable
- [ ] Files are listed with purposes
- [ ] Testing strategy is comprehensive
- [ ] Verification criteria are measurable
- [ ] Dependencies are identified

#### Execution
- [ ] All implementation steps completed
- [ ] Code follows all applicable rules
- [ ] Files created/modified as planned
- [ ] Execution report generated

---

## Phase 4: Simplify (Optional)

**Goal: Improve code clarity and maintainability**

The Simplify phase is **optional** and should be used judiciously. It's not for every implementation.

### What Happens

After validation passes, you may choose to simplify the code:

- Remove redundant code
- Improve variable and method naming
- Simplify complex logic
- Consolidate duplicate code
- Improve code organization

### When to Use Simplify

**Use Simplify:**
- After completing a complex feature
- When code has become tangled during implementation
- Before major code reviews
- At the end of long coding sessions
- When code complexity is high

**Skip Simplify:**
- For simple one-off changes
- During rapid prototyping
- When actively changing the same code
- For trivial implementations
- When code is already clean

### How It Works

Simplification is a **behavior-preserving refactoring**:

**✅ What It Does:**
- Improves readability
- Enhances maintainability
- Removes dead code
- Consolidates duplicates
- Improves structure

**❌ What It Doesn't Do:**
- Change functionality
- Alter behavior
- Fix bugs (that's for the Implement phase)
- Add new features
- Change APIs

### Integration with PIV

**Option A: Simplify After Validation**
```
Implement → Validate → Simplify → Validate Again → Commit
```
Clean up code after everything works.

**Option B: Skip for Simple Features**
```
Implement → Validate → Commit
```
Simplification is optional.

**Important:** Always re-run validation after simplification to ensure nothing broke.

### Success Criteria
- [ ] Code is clearer and more readable
- [ ] No functionality has changed
- [ ] All tests still pass
- [ ] Validation still passes
- [ ] Code is easier to maintain

---

## Phase 5: Validate

Validation happens **automatically** after execution to ensure quality without manual intervention.

### What Happens Automatically

The `/validation:validate` command runs a comprehensive validation pipeline:

#### Level 0: Environment Safety
- Verify environment (local vs production)
- Check for safety guards
- Confirm destructive operations are disabled

#### Level 1: Compilation
- Code compiles without errors
- No type errors
- No syntax errors

#### Level 2: Unit Tests
- All new unit tests pass
- Existing tests still pass
- Test suite executes successfully

#### Level 3: Integration Tests
- Integration tests pass (if applicable)
- API contracts are maintained
- Database migrations work

#### Level 4: Code Quality
- Linting passes
- Code formatting checks
- No security vulnerabilities

#### Level 5: Coverage
- Test coverage meets threshold (typically 80%+)
- Critical paths are covered
- Edge cases are tested

#### Level 6: Build
- Full build succeeds
- Assets are generated correctly
- No build warnings

### Commands

#### Automatic Validation
```
/validation:validate
```

This command is **automatically invoked** after `/core_piv_loop:execute` completes.

#### Code Review (Optional)
```
/validation:code-review
```
Technical code review on changed files.

#### Fix Issues (Optional)
```
/validation:code-review-fix
```
Automatically fix issues found in code review.

#### Execution Report
```
/validation:execution-report
```
Generate comprehensive report after implementing a feature.

#### System Review (Optional)
```
/validation:system-review
```
Analyze implementation vs plan for process improvements.

### Artifacts Created

#### Validation Report
`.claude/agents/reports/validation-report-{timestamp}.md`

Includes:
- Environment verification status
- Compilation results
- Test results (unit + integration)
- Code quality metrics
- Coverage statistics
- Build status
- Overall validation result (PASS/FAIL)

#### Code Review Report
`.claude/agents/reviews/code-review-{timestamp}.md`

### Automatic Flow

The validation is designed to run **automatically** as part of the execution flow:

```
/core_piv_loop:execute
  │
  ├─▶ Implement feature
  │
  └─▶ /validation:validate (AUTOMATIC)
      │
      ├─▶ Run all validation levels
      │
      ├─▶ Generate validation report
      │
      └─▶ /validation:execution-report (AUTOMATIC)
          │
          └─▶ Generate execution report
```

### Success Criteria
- [ ] All validation levels pass
- [ ] Code follows all rules
- [ ] Tests are comprehensive
- [ ] No regressions introduced
- [ ] Validation report is generated
- [ ] Execution report is generated

---

## Complete PIV Workflow

### Standard Feature Development

```
1. /core_piv_loop:prime
   │
   ├─▶ Load codebase context
   ├─▶ Create context artifact
   │
2. /core_piv_loop:plan-feature "Add user authentication"
   │
   ├─▶ Analyze requirements
   ├─▶ Design approach
   ├─▶ Create plan artifact
   │
3. /core_piv_loop:execute
   │
   ├─▶ Implement from plan
   ├─▶ Follow all rules
   ├─▶ Track progress
   │
   └─▶ AUTOMATIC: /validation:validate
       ├─▶ Run all validation levels
       ├─▶ Generate validation report
       │
       └─▶ AUTOMATIC: /validation:execution-report
           └─▶ Generate execution report
```

### Quick Bug Fix

```
1. /github_bug_fix:rca
   │
   ├─▶ Create RCA document
   │
2. /github_bug_fix:implement-fix
   │
   ├─▶ Implement fix
   │
   └─▶ AUTOMATIC: /validation:validate
       └─▶ Validate fix works
```

---

## When to Use Each Phase

### Decision Tree

```
Start
  │
  ├─ New session or context switch?
  │   └─ YES → Run PRIME
  │
  ├─ Type of work?
  │   ├─ Simple bug fix or small tweak
  │   │   └─ Use RCA or implement directly
  │   │       └─ VALIDATE runs automatically
  │   │
  │   ├─ Complex feature or architectural change
  │   │   └─ PLAN → EXECUTE
  │   │       └─ VALIDATE runs automatically
  │   │
  │   └─ Uncertain about complexity?
  │       └─ When in doubt, PLAN it
  │
  └─ After implementation
      └─ VALIDATE runs automatically
          └─ Review reports
```

### Guidelines

| Scenario | Approach |
|----------|----------|
| New session | Always Prime |
| Context switch | Prime again |
| Simple typo fix | Implement directly → Auto validate |
| Add new field | Can skip planning → Implement → Auto validate |
| New feature endpoint | Plan → Execute → Auto validate |
| Refactor component | Plan → Execute → Auto validate |
| Add new dependency | Plan → Execute → Auto validate |
| Database migration | Always plan → Execute → Auto validate |
| Architecture change | Always plan → Execute → Auto validate |

---

## Best Practices

### Prime Phase
- **Be thorough**: Better to over-analyze than under-analyze
- **Save context**: Always save the context artifact
- **Update regularly**: Re-prime after major changes
- **Ask questions**: Clarify ambiguities during prime

### Implement Phase (Planning)
- **Think first**: Don't rush to implementation
- **Be specific**: Vague plans lead to vague implementations
- **Consider alternatives**: Document why you chose this approach
- **Identify risks**: Think about what could go wrong
- **List dependencies**: Know what needs to be done first

### Implement Phase (Execution)
- **Follow the plan**: Don't deviate without updating the plan
- **Code incrementally**: Make small, focused changes
- **Follow rules**: Respect all applicable rules
- **Track progress**: Mark steps as complete

### Validate Phase
- **Trust automation**: Let automatic validation do its job
- **Review reports**: Read validation and execution reports
- **Fix issues**: Address validation failures promptly
- **Don't skip**: Never skip automatic validation

---

## Anti-Patterns to Avoid

### ❌ Skipping Prime
**Problem**: Making changes without understanding context
**Consequence**: Breaking existing patterns, introducing inconsistencies
**Solution**: Always Prime at start of session

### ❌ Over-Planning
**Problem**: Spending too much time planning simple changes
**Consequence**: Diminishing returns, lost time
**Solution**: Use judgment - plan complex work, skip simple fixes

### ❌ Under-Planning
**Problem**: Not planning complex changes
**Consequence**: Rework, architectural issues, missed edge cases
**Solution**: When in doubt, plan it out

### ❌ Ignoring the Plan
**Problem**: Creating a plan then not following it
**Consequence**: Plan becomes useless, lessons lost
**Solution**: Update plan if needed, or don't create one

### ❌ Manual Validation
**Problem**: Running tests manually instead of using automatic validation
**Consequence**: Inconsistent validation, missed checks
**Solution**: Always use `/validation:validate` (runs automatically)

### ❌ Ignoring Reports
**Problem**: Not reading validation or execution reports
**Consequence**: Missed insights, repeated mistakes
**Solution**: Always review generated reports

---

## Automatic Validation Benefits

### Why Automatic?

1. **Consistency**: Every implementation gets the same thorough validation
2. **No Forgotten Steps**: All validation levels run every time
3. **Fast Feedback**: Issues caught immediately
4. **Quality Gates**: Can't proceed without passing validation
5. **Documentation**: Reports provide audit trail

### What Runs Automatically

After `/core_piv_loop:execute`:

```
1. /validation:validate (AUTOMATIC)
   ├─▶ Environment check
   ├─▶ Compilation
   ├─▶ Unit tests
   ├─▶ Integration tests
   ├─▶ Code quality
   ├─▶ Coverage check
   └─▶ Build verification

2. /validation:execution-report (AUTOMATIC)
   └─▶ Summary of what was done
```

### Manual vs Automatic

| Task | Manual | Automatic |
|------|--------|-----------|
| Prime | ✅ Required | - |
| Plan | ✅ Required (complex work) | - |
| Execute | ✅ Required | - |
| Validate | ❌ Don't run manually | ✅ Runs after execute |
| Code Review | ✅ Optional | - |
| Execution Report | ❌ Don't run manually | ✅ Runs after validate |

---

## Tips for Success

### For Effective Priming
- Start with broad questions: "How is this codebase organized?"
- Ask about patterns: "What are the key architectural patterns?"
- Understand conventions: "What coding style is used?"
- Identify rules: "What rules should I follow?"

### For Effective Planning
- State requirements clearly: "What exactly are we building?"
- Think about edge cases: "What could go wrong?"
- Consider performance: "Will this scale?"
- Plan testing: "How will we verify this works?"

### For Effective Execution
- Follow the plan step-by-step
- Respect all applicable rules
- Make incremental changes
- Test as you go (even though auto-validation will run)

### For Effective Validation
- **Don't disable auto-validation**: It's there for quality
- **Read the reports**: Understand what passed/failed
- **Fix failures promptly**: Don't accumulate technical debt
- **Track trends**: Watch for repeated validation issues

---

## PIV Anti-Patterns

### ❌ Anti-Pattern #1: Working Directly on Main Branch

**Problem**: Making commits directly to `main` branch

**Symptoms:**
- Large feature implementations on main
- No feature branch created
- Risk of breaking production code
- Cannot easily undo changes

**Consequences:**
- Cannot easily undo changes
- Blocks other development
- No code review gate
- Violates Git best practices
- **VIOLATES CORE PIV PRINCIPLE**

**Correct Approach:**
```bash
# ✅ ALWAYS start with:
git checkout -b feature/<descriptive-name>

# ✅ Verify you're on feature branch:
git branch
# Should show: * feature/<descriptive-name>

# ✅ Work on feature branch, then:
git commit -m "feat: ..."

# ✅ Create PR for review:
gh pr create

# ✅ Merge via PR (NOT direct commit to main)
```

**Prevention:**
- Create feature branch FIRST, before any code changes
- Always verify branch with `git branch` before committing
- Consider git hooks to warn against main commits

---

### ❌ Anti-Pattern #2: Executing Before Planning

**Problem**: Starting implementation immediately without a plan

**Symptoms:**
- No PIV plan created
- "I'll figure it out as I go"
- Missing context research
- Rework and backtracking

**Consequences:**
- Rework and backtracking
- Inconsistent patterns
- Missing edge cases
- Delayed discovery of issues

**Correct Approach:**
1. Create feature branch
2. Run `/piv:plan-feature <feature-name>`
3. Review and approve plan
4. ONLY THEN: `/piv:execute`

---

### ❌ Anti-Pattern #3: Skipping Validation

**Problem**: Not running validation or disabling auto-validation

**Symptoms:**
- "Tests will pass, don't need to run"
- Committing without validation
- Not checking compilation
- Skipping code review

**Consequences:**
- Broken code in repository
- Production bugs
- Embarrassing rollbacks
- Loss of trust in process

**Correct Approach:**
- **ALWAYS** run validation before committing
- **NEVER** disable automatic validation
- Check environment (when applicable)
- Review code before committing

---

### ❌ Anti-Pattern #4: Treating PIV as Optional

**Problem**: Inconsistent application of PIV methodology

**Symptoms:**
- "PIV is too much overhead for small changes"
- "I know what I'm doing, don't need a plan"
- Skipping PIV for "quick fixes"
- Inconsistent application

**Consequences:**
- Process breakdown
- Technical debt accumulation
- Knowledge silos
- Onboarding difficulties

**Correct Approach:**
- PIV is **mandatory for features** (medium+ complexity)
- PIV is **optional for trivial changes** (1-2 line fixes)
- When in doubt, use PIV
- Consistency over speed

**Decision Tree:**
```
Is this a feature/enhancement?
├─ Yes → Use PIV (Prime → Plan → Execute → Validate)
└─ No → Is it a trivial typo/fix?
    ├─ Yes → Can skip PIV, use judgment
    └─ No → Use PIV (bug fix workflow)
```

---

### ❌ Anti-Pattern #5: Over-Using Simplify

**Problem**: Running simplification on every change

**Symptoms:**
- Simplifying trivial changes
- Running simplify during active development
- Treating simplify as mandatory
- Slowing down development

**Consequences:**
- Wasted time on simple changes
- Unnecessary churn
- Development slowdown
- Loss of focus

**Correct Approach:**
- Simplify is **OPTIONAL**, not mandatory
- Use for complex features only
- Skip for simple changes
- Use judgment based on code complexity

---

## Summary

PIV is a comprehensive methodology for AI-assisted development:

1. **Prime** - Understand the codebase before making changes
2. **Implement** - Plan and execute features systematically
3. **Simplify** - Optional cleanup to maintain code quality
4. **Validate** - Automatic verification of quality

The methodology is lightweight enough for quick fixes but structured enough for complex features. The optional Simplify phase helps maintain code quality, while the automatic validation ensures quality without manual intervention.

**Key Differentiator**: Validation happens **automatically** as part of the execution flow, not as a separate manual step. This ensures every implementation gets thoroughly validated without requiring developer intervention.

**Remember**: The goal is not to follow the process rigidly, but to use it to produce better code more efficiently. Let the methodology serve you, not the other way around.

**When in doubt**: Prime → Plan → Execute → Validate. Simplification is optional and should be used based on code complexity and your judgment.
