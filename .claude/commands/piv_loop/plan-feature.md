# Command: /core_piv_loop:plan-feature

**Phase: Implement**
**Purpose: Create comprehensive implementation plan**

---

## Command Definition

This command creates a detailed implementation plan for a feature, including requirements, technical approach, implementation steps, and verification criteria.

## Usage

```
/core_piv_loop:plan-feature "Feature description"
```

## What It Does

### 1. Requirements Analysis
- Gathers functional requirements
- Identifies non-functional requirements
- Clarifies edge cases
- Defines acceptance criteria

### 2. Context Analysis
- Reviews prime context
- Identifies relevant parts of codebase
- Finds similar existing implementations
- Maps dependencies

### 3. Technical Design
- Chooses technical approach
- Identifies patterns to follow
- Plans architecture changes
- Considers trade-offs

### 4. Implementation Planning
- Breaks down into steps
- Lists files to create
- Lists files to modify
- Identifies dependencies

### 5. Verification Planning
- Defines test strategy
- Lists verification criteria
- Plans manual testing
- Identifies success metrics

## When to Use

- **Complex features**: Multi-file or architectural changes
- **New functionality**: Features requiring design decisions
- **Refactoring**: Changes affecting multiple components
- **Integrations**: Adding new dependencies or services
- **API endpoints**: New or modified endpoints
- **Database changes**: Migrations or schema changes

## When NOT to Use

- Simple typo fixes
- Adding a single field
- Minor style fixes
- Documentation updates

## Expected Output

### Plan Artifact
File: `.claude/agents/plans/{feature-name}.md`

```markdown
# Feature: [Feature Name]

**Created**: [Timestamp]
**Status**: Planned

## Context
[Relevant context from prime phase]

## Requirements

### Functional Requirements
- [ ] FR-1: [Description]
- [ ] FR-2: [Description]

### Non-Functional Requirements
- [ ] NFR-1: [Performance requirement]
- [ ] NFR-2: [Security requirement]

## Technical Approach

### Architecture
[Describe the technical approach]

### Patterns
[List patterns to follow]

### Trade-offs
[Explain trade-off decisions]

### Dependencies
[List external dependencies or prerequisites]

## Implementation Steps

1. **Step 1**: [Description]
   - Files: [List files]
   - Notes: [Implementation notes]

2. **Step 2**: [Description]
   - Files: [List files]
   - Notes: [Implementation notes]

[Continue for all steps]

## Files to Create
| File | Purpose |
|------|---------|
| `path/to/file` | [Description] |

## Files to Modify
| File | Changes |
|------|---------|
| `path/to/file` | [Description of changes] |

## Testing Strategy

### Unit Tests
- [ ] [Test requirement 1]
- [ ] [Test requirement 2]

### Integration Tests
- [ ] [Test requirement 1]
- [ ] [Test requirement 2]

### Manual Testing
- [ ] [Manual test scenario 1]
- [ ] [Manual test scenario 2]

## Verification Criteria
- [ ] [Criterion 1]
- [ ] [Criterion 2]
- [ ] [Criterion 3]

## Notes
[Additional considerations, edge cases, risks, etc.]

## Related Issues
- [Issue #1](url)
- [Issue #2](url)
```

### Confirmation Message
```
✅ Plan created successfully

Plan: [Feature name]
Saved to: .claude/agents/plans/{feature-name}.md

Summary:
- [X] implementation steps
- [X] files to create
- [X] files to modify
- [X] verification criteria

Ready to execute. Use /core_piv_loop:execute to implement.
```

## Implementation Notes

For Claude Code Implementation:

1. **Parse** feature description from user input
2. **Ask clarifying questions** if requirements are unclear
3. **Review** prime context for relevant patterns
4. **Search** codebase for similar implementations
5. **Design** technical approach
6. **Break down** into actionable steps
7. **Generate** comprehensive plan artifact
8. **Present** plan summary to user

## Artifacts Created

- `.claude/agents/plans/{feature-name}.md` - Implementation plan

## User Interaction

During planning, Claude should:

1. **Ask questions** to clarify requirements
2. **Propose alternatives** for technical decisions
3. **Explain trade-offs** of different approaches
4. **Confirm** plan with user before saving

Example interaction:
```
User: /core_piv_loop:plan-feature "Add user authentication"

Claude: I'll create a plan for adding user authentication. A few questions:

1. Should authentication use JWT or session-based auth?
User: JWT

2. Do you need social login (Google, GitHub)?
User: Not yet, just email/password

3. What password requirements?
User: Min 8 chars, 1 uppercase, 1 number

[Creates plan with these requirements]
```

## Plan Quality Checklist

Before finalizing plan, ensure:

- [ ] Requirements are clear and complete
- [ ] Technical approach is justified
- [ ] Implementation steps are actionable
- [ ] Files are listed with purposes
- [ ] Testing strategy is comprehensive
- [ ] Verification criteria are measurable
- [ ] Dependencies are identified
- [ ] Edge cases are considered
- [ ] User has approved the plan

## Next Steps

After planning:

1. **Review** the plan with user
2. **Revise** if needed based on feedback
3. **Execute** using `/core_piv_loop:execute`
4. **Validate** runs automatically after execute

## Related Commands

- `/core_piv_loop:prime` - Load context (run before planning)
- `/core_piv_loop:execute` - Execute from plan
- `/validation:validate` - Run validation (automatic)

---

**A good plan is the foundation of successful implementation. Take time to plan thoroughly.**
