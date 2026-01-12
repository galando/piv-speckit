# Your First Feature

**Walkthrough of implementing your first feature using PIV methodology**

---

## Overview

This guide walks you through building a complete feature using the PIV methodology. We'll implement a simple but realistic feature: **User Registration**.

---

## Prerequisites

- Completed [Installation Guide](01-installation.md)
- Read [Quick Start](02-quick-start.md)
- Project initialized from skeleton
- Basic understanding of your chosen technology stack

---

## Feature: User Registration

### What We'll Build

A user registration system with:
- Email validation
- Password hashing
- Database storage
- Error handling
- Tests

### Estimated Time
- **Planning**: 3-5 minutes
- **Implementation**: 10-15 minutes
- **Validation**: 2-3 minutes
- **Total**: ~20 minutes

---

## Step 1: Prime the Workspace

**Ask Claude Code**:
```
Run /core_piv_loop:prime to load the project context
```

**What to Expect**:
- Claude reads your project structure
- Identifies your technology stack
- Loads relevant rules
- Creates context artifact

**Verify**: Check `.claude/agents/context/prime-context.md` was created.

---

## Step 2: Plan the Feature

**Ask Claude Code**:
```
Use /core_piv_loop:plan-feature to create a plan for implementing user registration with email validation, password hashing, and database storage
```

**What to Expect**:

Claude will:
1. **Explore** your codebase structure
2. **Identify** existing patterns (entities, repositories, controllers)
3. **Design** the implementation approach
4. **Create** detailed step-by-step plan

**Example Plan Structure**:

```markdown
# Implementation Plan: User Registration

## Overview
[Brief description]

## Architecture
[Design decisions, trade-offs]

## Implementation Steps

### 1. Create User Entity
- Define entity fields
- Add validation annotations
- Configure database mapping

### 2. Create UserRepository
- Define repository interface
- Add methods for user operations

### 3. Create UserService
- Implement registration logic
- Add password hashing
- Add email validation

### 4. Create RegistrationController
- Define API endpoint
- Add request validation
- Handle errors

### 5. Add Tests
- Unit tests for service
- Integration tests for controller
- Test edge cases

## Files to Create
- List of files

## Files to Modify
- List of files
```

**Review the Plan**:
- Located in: `.claude/agents/plans/user-registration.md`
- Read through the plan
- **Edit if needed** to match your preferences
- Ask questions if anything is unclear

---

## Step 3: Execute the Plan

**Ask Claude Code**:
```
Use /core_piv_loop:execute to implement the user registration plan
```

**What to Expect**:

Claude will:
1. **Read** the plan
2. **Implement** each step systematically
3. **Create** new files
4. **Modify** existing files
5. **Follow** your project's patterns
6. **Write** tests alongside implementation

**During Execution**:
- Claude will report progress
- You'll see file creation/modification messages
- Tests will run automatically

**After Execution**:
- All files created/modified
- Tests passing
- Ready for validation

---

## Step 4: Automatic Validation

**What Happens**:
- Validation runs **automatically** after execute completes
- No manual command needed
- Comprehensive checks run

**Validation Includes**:
- ✅ Environment safety check
- ✅ Compilation/build verification
- ✅ Unit tests
- ✅ Integration tests
- ✅ Code quality checks
- ✅ Test coverage verification
- ✅ Final build verification

**Review Results**:
```bash
# View execution report
/validation:execution-report
```

**If Validation Fails**:
1. Check what failed
2. Ask Claude to fix issues
3. Validation re-runs automatically

---

## Step 5: Review and Test

### Manual Testing

```bash
# Start your application
npm run dev
# or
python main.py
# or
mvn spring-boot:run

# Test the endpoint
curl -X POST http://localhost:8080/api/users/register \
  -H "Content-Type: application/json" \
  -d '{
    "email": "user@example.com",
    "password": "SecurePassword123!"
  }'
```

### Code Review

Review what was created:

```bash
# See what changed
git status
git diff

# Review new files
git ls-files --others --exclude-standard
```

### Review the Plan Execution

Check `.claude/agents/reports/execution-report-user-registration.md` for:
- Files created
- Files modified
- Tests added
- Any issues encountered

---

## What You Should See

### Created Files

```
src/
├── entities/
│   └── User.ts                      (or User.java, user.py)
├── repositories/
│   └── UserRepository.ts
├── services/
│   └── UserService.ts
├── controllers/
│   └── RegistrationController.ts
└── types/
    └── RegistrationRequest.ts

tests/
├── unit/
│   └── UserService.test.ts
└── integration/
    └── RegistrationController.test.ts
```

### Features Implemented

✅ **Email Validation**
- Format validation
- Duplicate check
- Domain validation (optional)

✅ **Password Security**
- Password hashing (bcrypt/argon2)
- Password strength validation
- Secure storage

✅ **Database Storage**
- User entity persisted
- Unique email constraint
- Proper indexing

✅ **Error Handling**
- Validation errors
- Duplicate user errors
- Database errors
- User-friendly error messages

✅ **Testing**
- Unit tests for business logic
- Integration tests for API
- Edge cases covered
- High test coverage

---

## Common Issues and Solutions

### Issue: "Plan doesn't match my tech stack"

**Solution**:
- Be more specific in plan request
- Example: "Create a Spring Boot user registration with JPA entities"
- Or: "Create a FastAPI user registration with SQLAlchemy models"

### Issue: "Tests failing after execution"

**Solution**:
1. Check validation report for details
2. Ask Claude: "Fix the failing tests"
3. Re-run validation: `/validation:validate`

### Issue: "Code style doesn't match my project"

**Solution**:
1. Review your rules in `.claude/rules/`
2. Add technology-specific rules
3. Re-run execute with clearer style preferences

### Issue: "Missing dependencies"

**Solution**:
1. Check execution report
2. Install dependencies manually
3. Or ask Claude: "Install the required dependencies"

---

## Tips for Success

### 1. Be Specific in Planning

**Vague**:
```
Plan user registration
```

**Specific**:
```
Plan user registration with:
- Email validation using regex
- Password hashing with bcrypt (12 rounds)
- PostgreSQL database with JPA
- REST API endpoint at /api/users/register
- Input validation using @Valid
- Comprehensive unit and integration tests
```

### 2. Review the Plan Before Execution

- Read the generated plan
- Edit if needed
- Ask questions
- Ensure it matches your vision

### 3. Start Small

- First feature: Simple CRUD
- Second feature: Add validation
- Third feature: Add authentication
- Build complexity gradually

### 4. Use Git Stash

```bash
# Save work before execute
git stash

# Run execute
/core_piv_loop:execute

# Review changes
git diff

# Keep or discard
git stash pop  # or git checkout .
```

### 5. Read the Reports

- Execution report shows what changed
- Validation report shows quality
- Learn from each iteration

---

## Next Features to Try

After completing user registration:

1. **User Login** - Authentication endpoint
2. **Password Reset** - Forgot password flow
3. **Email Verification** - Verify email addresses
4. **User Profile** - View and edit profile
5. **User List** - Admin endpoint to list users

Each will follow the same PIV workflow!

---

## Beyond Your First Feature

### Building Complex Features

For multi-feature projects:

```bash
# 1. Prime once
/core_piv_loop:prime

# 2. Plan each feature
/core_piv_loop:plan-feature "User authentication"
/core_piv_loop:plan-feature "User profile"
/core_piv_loop:plan-feature "Password reset"

# 3. Execute each plan
/core_piv_loop:execute  # Runs with last plan
# Or execute specific plan
/core_piv_loop:execute user-authentication
```

### Iterative Development

```bash
# Plan basic version
/core_piv_loop:plan-feature "User registration (basic)"

# Execute basic version
/core_piv_loop:execute

# Plan enhancements
/core_piv_loop:plan-feature "Add email verification to registration"

# Execute enhancements
/core_piv_loop:execute
```

---

## Summary

**Your First Feature Checklist**:

- [ ] Prime workspace
- [ ] Create detailed plan
- [ ] Review and edit plan
- [ ] Execute implementation
- [ ] Automatic validation passes
- [ ] Manual testing successful
- [ ] Code review complete
- [ ] Commit changes

**Time Investment**:
- First time: ~20-30 minutes
- Future features: ~10-15 minutes
- With experience: ~5-10 minutes

---

## Next Steps

1. **Build More Features** - Practice makes perfect
2. **Customize Rules** - Tailor to your preferences
3. **Learn Advanced Topics** - See [Methodology](../../.claude/PIV-METHODOLOGY.md)
4. **Extend the Skeleton** - [Adding Technologies](../extending/01-adding-technologies.md)

---

**Congratulations!** 🎉 You've built your first feature with PIV methodology.

**What's Next?** Explore [extending the skeleton](../extending/01-adding-technologies.md) or dive into [advanced methodology](../../.claude/PIV-METHODOLOGY.md).
