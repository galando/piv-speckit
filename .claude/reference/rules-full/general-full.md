# General Development Rules

**Universal rules applicable to all projects and technologies**

---

## Core Principles

### 1. Understand Before Changing
- **NEVER** make changes without understanding the existing code
- **ALWAYS** read relevant files before modifying
- **ASK** clarifying questions when uncertain
- **PRIME** the workspace before starting work

### 2. Follow Existing Patterns
- **MATCH** existing code style and conventions
- **REUSE** existing patterns and abstractions
- **CONSISTENCY** over personal preference
- **WHEN** adding new patterns, document the rationale

### 3. Minimal Changes
- **CHANGE** only what's necessary
- **AVOID** "while I'm here" changes
- **FOCUS** on the task at hand
- **REFATOR** only when explicitly requested

### 4. Test as You Code
- **WRITE** tests alongside implementation
- **RUN** tests frequently
- **NEVER** leave testing for the end
- **FIX** failures immediately

---

## Code Quality

### Readability
- **WRITE** self-documenting code
- **USE** clear, descriptive names
- **AVOID** cleverness that sacrifices clarity
- **COMMENT** only complex logic (not the obvious)

### Simplicity
- **PREFER** simple solutions over complex ones
- **AVOID** premature optimization
- **FOLLOW** YAGNI (You Aren't Gonna Need It)
- **DON'T** add abstractions for one-off use

### Maintainability
- **KEEP** functions small and focused
- **AVOID** deep nesting
- **PREFER** composition over inheritance
- **MINIMIZE** coupling between modules

---

## File Organization

### Structure
- **FOLLOW** standard project structure for your technology
- **GROUP** related files together
- **SEPARATE** concerns (logic, presentation, data)
- **USE** clear directory names

### Naming
- **USE** descriptive file names
- **FOLLOW** naming conventions of your technology
- **AVOID** generic names (utils.js, helpers.py)
- **BE** consistent with casing (camelCase, snake_case, etc.)

---

## Error Handling

### Principles
- **HANDLE** errors gracefully
- **PROVIDE** meaningful error messages
- **LOG** errors with context
- **FAIL** safely (secure by default)

### What to Avoid
- ❌ Silent failures (catching and ignoring errors)
- ❌ Generic error messages ("Error occurred")
- ❌ Exposing sensitive data in errors
- ❌ Crashing without recovery options

---

## Security

### Basic Principles
- **NEVER** trust user input
- **VALIDATE** at system boundaries
- **SANITIZE** data before use
- **USE** parameterized queries (SQL injection prevention)
- **ENCRYPT** sensitive data

### Common Vulnerabilities
- **SQL Injection**: Use parameterized queries
- **XSS**: Sanitize and escape user input
- **CSRF**: Use anti-CSRF tokens
- **Authentication**: Use strong, hashed passwords
- **Authorization**: Check permissions on every request

---

## Performance

### Guidelines
- **MEASURE** before optimizing
- **FOCUS** on hot paths
- **AVOID** premature optimization
- **CONSIDER** scalability implications

### What to Avoid
- ❌ Optimizing without profiling
- ❌ Micro-optimizations that hurt readability
- ❌ Caching without cache invalidation strategy
- ❌ Over-engineering for theoretical scale

---

## Documentation

### When to Document
- **COMPLEX** logic (explain why, not what)
- **ALGORITHMS** (explain approach)
- **WORKAROUNDS** (explain why needed)
- **PUBLIC APIs** (describe usage)

### When NOT to Document
- **OBVIOUS** code (comments like "increment i")
- **SELF-DOCUMENTING** code (good names are better than comments)
- **OUTDATED** information (worse than no documentation)

---

## Collaboration

### Git Workflow
- **PULL** before pushing
- **WRITE** meaningful commit messages
- **AVOID** breaking the build
- **RESPECT** code review feedback

### Communication
- **BE** clear and concise
- **PROVIDE** context when asking questions
- **ACKNOWLEDGE** limitations
- **ASK** rather than assume

---

## Anti-Patterns

### Code Organization
❌ **God Objects**: Classes/modules that do everything
✅ **Single Responsibility**: Each module has one clear purpose

❌ **Spaghetti Code**: Unstructured, hard to follow
✅ **Clear Flow**: Obvious execution path

❌ **Magic Numbers**: Unexplained numeric constants
✅ **Named Constants**: Descriptive constant names

### Error Handling
❌ **Silent Failures**: Catching and ignoring errors
✅ **Explicit Handling**: Deal with errors appropriately

❌ **Error Swallowing**: Generic catch blocks
✅ **Specific Handling**: Catch specific error types

### Testing
❌ **Untested Code**: No tests at all
✅ **Tested Code**: Comprehensive test coverage

❌ **Fragile Tests**: Tests that break easily
✅ **Robust Tests**: Tests that check behavior, not implementation

---

## Decision Framework

When making implementation decisions:

1. **Is it simple?** → Prefer simple solutions
2. **Is it tested?** → Write tests
3. **Is it documented?** → Document complex logic
4. **Is it secure?** → Validate and sanitize
5. **Is it maintainable?** → Future-you will thank you

---

## Summary

These rules provide a foundation for writing high-quality code:

1. **Understand** before changing
2. **Follow** existing patterns
3. **Keep** it simple
4. **Test** as you code
5. **Handle** errors gracefully
6. **Secure** by default
7. **Document** the complex

**Adapt these rules to your project's needs, but follow the spirit of quality and maintainability.**
