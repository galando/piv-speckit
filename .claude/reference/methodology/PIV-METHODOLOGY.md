# PIV Methodology

**Prime - Implement - Validate**

A development methodology designed specifically for AI-assisted software development with Claude Code.

---

## Overview

PIV (Prime-Implement-Validate) is a methodology designed for AI-assisted software development with Claude Code. It ensures proper context, systematic implementation, and automatic validation. An optional Simplify phase helps maintain code quality over time.

The methodology is designed to minimize misunderstandings, reduce rework, and maintain code quality through systematic planning and automatic validation.

**🚨 MANDATORY: Test-Driven Development (TDD)**

PIV enforces **strict Test-Driven Development** throughout the Implement phase:
- **RED phase**: Write failing test first
- **GREEN phase**: Write minimal code to pass
- **REFACTOR phase**: Improve while tests stay green

**TDD is NON-NEGOTIABLE** - all code must follow the RED-GREEN-REFACTOR cycle with zero exceptions.

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
/piv_loop:prime
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
- **TDD patterns and compliance** - Identify if codebase follows RED-GREEN-REFACTOR cycle
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

#### Step 1: Plan (`/piv_loop:plan-feature`)
- Feature requirements are gathered and clarified
- Technical approach is designed
- Architecture decisions are documented
- Implementation steps are broken down
- Files to create/modify are listed
- Verification criteria are defined

#### Step 2: Execute (`/piv_loop:execute`)
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
/piv_loop:plan-feature "Feature description"
```

#### Execution
```
/piv_loop:execute [plan-name]
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
- [ ] **Code follows TDD (RED-GREEN-REFACTOR cycle)**
- [ ] **Tests written BEFORE implementation**
- [ ] Code follows all applicable rules
- [ ] Files created/modified as planned
- [ ] Execution report generated

---

## Pragmatic Programmer Integration

The PIV methodology integrates core principles from *The Pragmatic Programmer* into the planning phase to prevent technical debt and ensure long-term maintainability.

### When It Happens

During **Phase 2 (Implement)** → **Step 1: Plan**, after feature requirements are gathered and before codebase analysis begins.

### What It Covers

**Four Core Principles:**

#### 1. DRY (Don't Repeat Yourself)

Every piece of knowledge must have a single, unambiguous, authoritative representation.

**Applied in planning:**
- Check codebase for similar implementations before creating new code
- Reuse existing patterns, utilities, and services
- Extract common logic instead of duplicating
- Follow established conventions

**Example:**
```
Planning a new user profile feature:
❌ BAD: Create new user validation logic
✅ GOOD: Reuse existing ValidationService from auth feature
```

#### 2. Shrapnel (Fix Broken Windows)

Don't leave "broken windows" (bad designs, wrong decisions, or poor code) unrepaired.

**Applied in planning:**
- Note existing technical debt in affected areas
- Fix related issues while implementing (if appropriate)
- Avoid creating new broken windows
- Leave code better than you found it

**Example:**
```
Planning to add new endpoint:
❌ BAD: Add to messy controller that already needs refactoring
✅ GOOD: Note refactoring opportunity, include in plan if appropriate
```

#### 3. Automate, Automate, Automate

If it's not automated, it's part of the problem, not the solution.

**Applied in planning:**
- Plan tests for all new functionality
- Create scripts for repeatable processes
- Use CI/CD for automated validation
- Avoid manual processes

**Example:**
```
Planning database migration:
❌ BAD: Document manual SQL steps to run
✅ GOOD: Create Flyway migration script + verify with tests
```

#### 4. Design for Change

Design your code to be modular and flexible, making future changes easier.

**Applied in planning:**
- Consider likely future changes
- Design for flexibility (within reason)
- Avoid premature optimization (YAGNI)
- Balance flexibility with simplicity

**Example:**
```
Planning payment feature:
❌ BAD: Hardcode single payment provider
✅ GOOD: Design payment interface, implement one provider, easy to add more
```

### How It Works

**During Plan Creation:**

1. **Feature requirements gathered** (Phase 1 of planning)
2. **Pragmatic Programmer review** (Phase 1.5 of planning)
   - Answer checklist questions for each principle
   - Note action items (if any)
   - Adjust approach based on principles
3. **Codebase analysis** (Phase 2 of planning)
   - Apply principles while researching patterns
   - Identify reusable components (DRY)
   - Note broken windows to fix (Shrapnel)
4. **Plan finalized** with principles applied

### Why It Matters

**Prevents Technical Debt:**
- DRY → Less code duplication, easier maintenance
- Shrapnel → Better code quality over time
- Automation → Reliable, repeatable processes
- Design for Change → Adaptable to future needs

**Reduces Rework:**
- Catches issues early (during planning, not implementation)
- Ensures quality is built in, not bolted on
- Prevents "quick and dirty" solutions that become permanent

**Improves Long-term Success:**
- Code is easier to maintain
- Changes are less risky
- Team can move faster over time

### Success Criteria

- [ ] All four principles reviewed during planning
- [ ] Action items noted (if any)
- [ ] Plan adjusted based on principles
- [ ] Implementation follows principle-informed plan

### Anti-Patterns

### ❌ Skipping the Review

**Problem:** "I don't need to check principles, I know what to do"

**Consequence:** Technical debt accumulates, code quality degrades

**Correct Approach:** Always run the Pragmatic Programmer checklist during planning

### ❌ Treating as Optional

**Problem:** "I'll skip it this time, this feature is simple"

**Consequence:** Even simple features benefit from principle review

**Correct Approach:** The review is fast (5-10 minutes) and prevents expensive rework

### ❌ Ignoring Findings

**Problem:** Review identifies issues, but plan ignores them

**Consequence:** Principles become box-checking exercise with no value

**Correct Approach:** Adjust plan based on principle findings, or document why not

---

## Clarification During Planning

The planning process uses the **AskUserQuestion** tool strategically to prevent ambiguity and ensure requirements are clear before implementation begins.

### When Clarification Happens

**Three Integration Points:**

**1. During Phase 1: Feature Understanding**
   - After initial feature analysis
   - Before codebase research begins

**2. During Phase 4: Deep Strategic Thinking**
   - After architectural analysis
   - Before plan structure generation

**3. Before Finalizing Plan**
   - After plan structure is complete
   - Before presenting plan for approval

### What to Ask About

**At Phase 1 (Feature Understanding):**

✅ **Ask about:**
- Feature scope and boundaries
- User preferences (libraries, patterns, approaches)
- Business value and success criteria
- Priority of competing requirements

❌ **Don't ask about:**
- Technical decisions (answerable from codebase)
- Implementation details (figure out during planning)
- Obvious requirements (should be clear from request)

**Examples:**

```
✅ GOOD: "Should this feature use existing AuthenticationService or create a new one?"
✅ GOOD: "Is performance more important than code simplicity for this feature?"
✅ GOOD: "Should we support edge case X now or defer to future iteration?"

❌ BAD: "What programming language should I use?" (obvious from codebase)
❌ BAD: "How do I create a REST endpoint?" (figure out from codebase patterns)
```

**At Phase 4 (Strategic Thinking):**

✅ **Ask about:**
- Architectural decisions (multiple valid approaches)
- Trade-offs between quality attributes
- Implementation approach when alternatives exist
- Future extensibility vs. current simplicity

❌ **Don't ask about:**
- Technical trivia (answerable from docs)
- How to implement (you're the planner)
- Questions with obvious best practice answers

**Examples:**

```
✅ GOOD: "Should we use Approach A (simpler, less flexible) or Approach B (more complex, more extensible)?"
✅ GOOD: "Is it acceptable to introduce dependency X for this feature, or should we find alternative?"
✅ GOOD: "Should we optimize for read performance or write performance?"

❌ BAD: "Should I follow SOLID principles?" (obviously yes)
❌ BAD: "What's the best way to structure Java code?" (check codebase conventions)
```

**Before Finalizing:**

✅ **Ask about:**
- Remaining ambiguities in plan
- Confirmation of approach
- Risks user is willing to accept
- Assumptions that need verification

❌ **Don't ask about:**
- Plan approval (use ExitPlanMode for this)
- "Is my plan ready?" (use ExitPlanMode)
- Questions you can answer yourself

**Examples:**

```
✅ GOOD: "I identified two potential issues: X and Y. How should we handle them?"
✅ GOOD: "The plan assumes Z is acceptable. Is this correct?"
✅ GOOD: "Should we defer edge case handling to future iteration?"

❌ BAD: "Is my plan ready to execute?" (use ExitPlanMode)
❌ BAD: "Should I proceed with implementation?" (use ExitPlanMode)
```

### How It Works

**Planning Flow with Clarification:**

```
1. Analyze feature requirements
   │
2. Ask: "Are requirements clear?"
   │
   ├─ NO → Use AskUserQuestion to clarify
   │       Get answers
   │       Update understanding
   │       Loop back to step 2
   │
   └─ YES → Proceed to codebase analysis
          │
3. Analyze codebase patterns
   │
4. Strategic thinking
   │
5. Ask: "Are architectural decisions clear?"
   │
   ├─ NO → Use AskUserQuestion to clarify
   │       Get answers
   │       Update approach
   │       Loop back to step 5
   │
   └─ YES → Generate plan structure
          │
6. Ask: "Is plan complete and clear?"
    │
    ├─ NO → Use AskUserQuestion to clarify
    │       Get answers
    │       Finalize plan
    │       Loop back to step 6
    │
    └─ YES → Use ExitPlanMode to present plan
```

### Why It Matters

**Prevents Rework:**
- Clarifying upfront prevents implementing wrong thing
- Reduces "I thought you meant X" situations
- Ensures alignment on approach

**Improves Plan Quality:**
- Uncovers assumptions that might be wrong
- Identifies risks user should know about
- Validates trade-offs against user priorities

**Speeds Up Implementation:**
- Clear requirements = faster implementation
- No mid-implementation clarifications needed
- Fewer "wait, I need to ask" moments

### AskUserQuestion vs. ExitPlanMode

**Important Distinction:**

| Tool | Purpose | When to Use | What It Does |
|------|---------|-------------|--------------|
| **AskUserQuestion** | Clarify requirements/approaches | When planning, ambiguities exist | Asks user questions, gets answers, continues planning |
| **ExitPlanMode** | Get plan approval | When plan is complete | Presents plan, asks for approval, stops planning |

**Workflow:**
```
Planning Phase
  │
  ├─ Use AskUserQuestion (as needed for clarification)
  │   → Get answers
  │   → Continue planning
  │
  └─ Plan complete
      │
      └─ Use ExitPlanMode
          → Present plan
          → Request approval
          → Stop planning
```

**Don't Mix Them Up:**

❌ **WRONG:** Use AskUserQuestion to ask "Is my plan ready?"
✅ **RIGHT:** Use ExitPlanMode to present completed plan

❌ **WRONG:** Use ExitPlanMode to clarify requirements
✅ **RIGHT:** Use AskUserQuestion to clarify during planning

### Success Criteria

- [ ] Requirements clear before codebase analysis
- [ ] Architectural decisions clear before plan generation
- [ ] Plan complete and clear before presenting for approval
- [ ] No ambiguities remain when plan is presented
- [ ] User has provided input on all key decisions

### Anti-Patterns

### ❌ Skipping Clarification

**Problem:** "I can figure this out myself"

**Consequence:** Implement wrong thing, waste time reworking

**Correct Approach:** When in doubt, ask. Better to ask now than implement wrong.

### ❌ Asking Too Many Questions

**Problem:** AskUserQuestion for everything

**Consequence:** User fatigue, planning takes too long

**Correct Approach:** Only ask when genuinely unclear. Research first, ask second.

### ❌ Using ExitPlanMode for Clarification

**Problem:** Use ExitPlanMode before plan is complete

**Consequence:** Plan not ready, user can't approve

**Correct Approach:** AskUserQuestion during planning, ExitPlanMode when complete

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

**Commit Timing: Commits happen AFTER each major phase (ASK before committing)**

**Standard PIV Workflow with Phase-Based Commits:**
```
1. Plan Phase
   ├─ Create plan artifact
   └─ Ask user: "Ready to commit plan?"

2. Implement Phase
   ├─ Execute plan (following TDD: RED-GREEN-REFACTOR)
   ├─ Validation runs automatically
   └─ Ask user: "Ready to commit implementation?"

3. Simplify Phase (Optional)
   ├─ Refactor and clean up
   ├─ Validation runs again
   └─ Ask user: "Ready to commit refactoring?"

4. Validate Phase (Already ran after implement)
   └─ Ask user: "Ready to commit validation fixes?" (if needed)

Total: 2-4 commits (one per phase)
```

**IMPORTANT:** Always ASK user before committing - never commit automatically!

**Why Phase-Based Commits?**
- ✅ Right granularity - Each phase is a logical unit
- ✅ Easy to revert - Can revert entire phase if needed
- ✅ Clear history - Git history shows PIV phases
- ✅ Tests + code together - Implementation phase includes both

**Option A: Simplify After Validation**
```
Plan → Commit Plan
Implement → Commit Implementation
Validate → Automatic
Simplify → Validate Again → Commit Simplification
```
Clean up code after everything works.

**Option B: Skip for Simple Features**
```
Plan → Commit Plan
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

#### Level 2.5: TDD Compliance Check (MANDATORY)
- **🚨 HARD STOP if TDD violations detected**
- Verify implementation files have corresponding test files
- Check tests were written BEFORE implementation (RED-GREEN-REFACTOR cycle)
- Validate test follows Given-When-Then pattern
- **FAILS validation if code was written before tests**
- Zero tolerance for TDD violations

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

This command is **automatically invoked** after `/piv_loop:execute` completes.

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

### Test Passage Policy

**🚨 MANDATORY: All tests MUST pass for validation to succeed**

Validation enforces a strict test passage policy. This is non-negotiable.

**🚨 MANDATORY: TDD Compliance**

Validation enforces strict Test-Driven Development compliance:
- ✅ Tests written BEFORE implementation (RED-GREEN-REFACTOR cycle)
- ❌ Code written before tests → Validation FAILS
- ❌ NO exceptions for "simple code" or "just this once"
- ✅ Every implementation file has corresponding test file

**Policy:**

**Unit Tests:**
- ✅ ALL unit tests MUST pass (Failures: 0, Errors: 0)
- ❌ ANY unit test failure → Validation FAILS
- ❌ NO exceptions for "just warnings" or "flaky tests"

**Integration Tests:**
- ✅ ALL integration tests MUST pass (Failures: 0, Errors: 0)
- ❌ ANY integration test failure → Validation FAILS
- ❌ NO exceptions for "unrelated failures" or "known issues"

**Test Coverage:**
- ✅ Coverage MUST be ≥ 80% for new code
- ❌ Coverage < 80% → Validation FAILS
- ❌ NO exceptions for "simple code" or "obvious logic"

**What This Means in Practice:**

**Scenario 1: New Feature with Tests**
```
Developer: "I added feature X and tests for it"
Validation: Runs tests
Result: Tests pass, coverage 85%
Status: ✅ VALIDATION PASSES
```

**Scenario 2: New Feature but Tests Fail**
```
Developer: "I added feature X and tests for it"
Validation: Runs tests
Result: 2 tests fail
Status: ❌ VALIDATION FAILS
Action: Fix failing tests, re-run validation
Do NOT proceed until tests pass
```

**Scenario 3: Existing Tests Break**
```
Developer: "I added feature X"
Validation: Runs tests
Result: 3 existing tests fail (regression)
Status: ❌ VALIDATION FAILS
Action: Fix regressions, re-run validation
Do NOT proceed until all tests pass
```

**Scenario 4: Low Coverage**
```
Developer: "I added feature X and a few tests"
Validation: Runs tests
Result: Tests pass, coverage 65%
Status: ❌ VALIDATION FAILS
Action: Add more tests to reach ≥80%, re-run validation
Do NOT proceed until coverage adequate
```

**No Valid Exceptions:**

There are NO acceptable reasons for test failures:

❌ **"That test is flaky"** → Fix the test (make it reliable)
❌ **"It's not related to my changes"** → Fix it anyway (you broke it)
❌ **"I'll fix it later"** → Fix it now (later never comes)
❌ **"It's just a warning"** → No such thing (failures are failures)
❌ **"The test is wrong"** → Fix the test or fix the code

**Rationale:**

Tests are our safety net. Allowing test failures undermines:
- **Code quality:** Broken tests mean broken code
- **Confidence:** Can't trust changes if tests fail
- **Regressions:** Broken tests miss real bugs
- **Team productivity:** Debugging accumulated failures is expensive

**This policy is non-negotiable.**

**Test Passage is a Gate:**

```
┌─────────────┐
│  Implement  │
│  feature    │
└──────┬──────┘
       │
       ▼
┌─────────────┐
│   Run       │
│   tests     │
└──────┬──────┘
       │
       ├─▶ Tests pass? ──NO──▶ ❌ VALIDATION FAILS
       │                           │
       │                           └─▶ Fix failures
       │                                   │
       └─▶ YES ────────────────────────────┘
               │
               ▼
       ┌─────────────┐
       │ Coverage    │
       │ ≥ 80%?      │
       └──────┬──────┘
              │
              ├─▶ NO ──▶ ❌ VALIDATION FAILS
              │             └─▶ Add more tests
              │
              └─▶ YES ──▶ ✅ VALIDATION PASSES
```

**Bottom Line:**

**If tests don't pass, validation doesn't pass. Period.**

**Fix the tests. Then re-run validation. Only proceed when all tests pass.**

### Automatic Flow

The validation is designed to run **automatically** as part of the execution flow:

```
/piv_loop:execute
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

## Phase 6: Learn (Optional - Continuous Improvement) 🆕

### What Happens

After code review completes, the **adaptive-learning skill** automatically suggests capturing learnings:

```
✅ Code review complete.

Capture learnings? Run /validation:learn
```

**The Learning System:**
- Analyzes code review artifacts to identify patterns
- Extracts insights about issues and good practices
- Generates improvement suggestions for rules, validation, and skills
- Tracks learning metrics over time
- Makes the framework smarter with every feature

### Commands

#### Learning Analysis

```bash
/validation:learn
```

Analyze code reviews to extract insights:
- Parse all code review artifacts
- Identify recurring issues (appears in 2+ reviews)
- Extract good patterns for reinforcement
- Generate learning insights artifact
- Update metrics dashboard

**Options:**
```bash
/validation:learn --last=5        # Analyze last 5 reviews only
/validation:learn --review=path   # Analyze specific review
```

#### Improvement Suggestions

```bash
/validation:suggest-improvement <type> "<title>"
```

Generate structured improvement proposals:
- Types: `rule`, `validation`, `skill`
- Creates suggestion artifact with:
  - Problem description
  - Evidence from code reviews
  - Proposed change
  - Approval workflow

**Example:**
```bash
/validation:suggest-improvement rule "Add N+1 query anti-pattern"
```

#### Learning Status

```bash
/validation:learning-status
```

Display learning metrics dashboard:
- Total reviews analyzed
- Issue trends by category and severity
- Recurring issues needing attention
- Improvements generated vs. applied
- Learning effectiveness metrics

### Artifacts Created

#### Learning Insights Artifact
`.claude/agents/learning/insights/learning-insights-{timestamp}.md`

Includes:
- Executive summary
- Issues by severity and category
- Recurring issues (improvement candidates)
- Anti-patterns discovered
- Good patterns found
- Improvement suggestions

#### Improvement Suggestion Artifact
`.claude/agents/learning/suggestions/{suggestion-id}.md`

Includes:
- Problem statement
- Evidence from code reviews
- Proposed change
- Rationale
- Approval checklist
- Application instructions

#### Learning Metrics Dashboard
`.claude/agents/learning/learning-metrics.md`

Tracks:
- Total reviews analyzed
- Issue trends (↑↓→)
- Recurring issues list
- Applied improvements
- Learning effectiveness

### When to Use Learning

| Scenario | Action |
|----------|--------|
| After code review | `/validation:learn` (auto-suggested) |
| Before new feature | `/validation:learning-status` (check known issues) |
| Recurring issue found | `/validation:suggest-improvement` (create fix) |
| Periodically | `/validation:learn --last=5` (analyze trends) |

### Learning vs. System Review

**Key Differentiation:**

| Aspect | System Review | Adaptive Learning |
|--------|---------------|-------------------|
| **Focus** | PIV process quality | Technical patterns |
| **Analyzes** | Plan vs. execution | Code review outputs |
| **Identifies** | Workflow inefficiencies | Recurring code issues |
| **Improves** | Planning process | Rules, skills, validation |
| **Output** | Process recommendations | Concrete improvements |

**Complementary:** Both improve quality, but in different dimensions!

### Success Criteria

- [ ] Code reviews analyzed for patterns
- [ ] Recurring issues identified
- [ ] Improvement suggestions generated
- [ ] Metrics dashboard updated
- [ ] Framework rules/skills enhanced over time

---

## Complete PIV Workflow

### Standard Feature Development

```
1. /piv_loop:prime
   │
   ├─▶ Load codebase context
   ├─▶ Create context artifact
   │
2. /piv_loop:plan-feature "Add user authentication"
   │
   ├─▶ Analyze requirements
   ├─▶ Design approach
   ├─▶ Create plan artifact
   │
3. /piv_loop:execute
   │
   ├─▶ Implement from plan (following RED-GREEN-REFACTOR cycle)
   │   ├─▶ RED: Write failing test first
   │   ├─▶ GREEN: Write minimal code to pass
   │   └─▶ REFACTOR: Improve while tests pass
   ├─▶ Follow all rules (especially TDD rule #22)
   ├─▶ Track progress
   │
   └─▶ AUTOMATIC: /validation:validate
       ├─▶ Run all validation levels (includes TDD compliance check)
       ├─▶ Generate validation report
       │
       └─▶ AUTOMATIC: /validation:execution-report
           └─▶ Generate execution report

4. (Optional) /validation:learn 🆕
   │
   ├─▶ Adaptive-learning skill suggests after code review
   ├─▶ Analyze code reviews for patterns
   ├─▶ Extract insights and identify recurring issues
   ├─▶ Generate improvement suggestions
   └─▶ Framework gets smarter! 🧠
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

After `/piv_loop:execute`:

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
   - **NEW:** Apply Pragmatic Programmer principles during planning
   - **NEW:** Clarify ambiguities using AskUserQuestion before implementing
3. **Simplify** - Optional cleanup to maintain code quality
4. **Validate** - Automatic verification of quality
   - **NEW:** All tests MUST pass (non-negotiable hard requirement)
   - **NEW:** Test coverage ≥ 80% enforced

The methodology is lightweight enough for quick fixes but structured enough for complex features. The Pragmatic Programmer principles prevent technical debt, strategic clarification prevents rework, and the strict test passage ensures quality.

**Key Differentiator**: Validation happens **automatically** as part of the execution flow, test passage is **mandatory**, and planning includes **quality principles** and **user clarification** to prevent issues before implementation begins.

**Remember**: The goal is not to follow the process rigidly, but to use it to produce better code more efficiently. Let the methodology serve you, not the other way around.

**When in doubt**: Prime → Plan (with PP review + clarification) → Execute → Validate (tests MUST pass). Simplification is optional and should be used based on code complexity and your judgment.
