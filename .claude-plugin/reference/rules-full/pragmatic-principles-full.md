# Pragmatic Programmer Principles (Full Guide)

**From:** *The Pragmatic Programmer* by Andrew Hunt and David Thomas

---

## Overview

These principles should be applied to EVERY feature and code change in this codebase. They represent decades of collective wisdom about what makes software development effective and maintainable.

---

## ✅ DRY (Don't Repeat Yourself)

### The Principle

**Every piece of knowledge must have a single, unambiguous, authoritative representation within a system.**

### In Practice

**What to Look For:**
- Duplicate code blocks that do the same thing
- Similar logic spread across multiple files
- Repeated configuration values
- Copy-pasted implementations

**How to Apply:**
1. **Before writing code:** Search the codebase for existing implementations
2. **When you find duplication:** Extract to shared function/module
3. **For configuration:** Use constants or config files
4. **For patterns:** Create reusable abstractions

**Examples:**

❌ **Don't:**
```javascript
// In three different files
function validateEmail(email) {
  return /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email);
}
```

✅ **Do:**
```javascript
// In one shared utility file
export function validateEmail(email) {
  return /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email);
}

// In other files
import { validateEmail } from './utils/validation';
```

### Related Anti-Patterns

- **Cargo Culting:** Copying code without understanding
- **Clone and Modify:** Duplicating files instead of parameterizing
- **Golden Hammer:** Using same solution for every problem

---

## ✅ Broken Windows

### The Principle

**Don't leave "broken windows" (bad designs, wrong decisions, or poor code) unrepaired. Fix them immediately.**

### In Practice

**What Counts as a Broken Window:**
- TODO comments that are never addressed
- Inconsistent code style in a file
- Dead/commented-out code
- Missing error handling
- Outdated dependencies
- Failing tests that are skipped

**How to Apply:**
1. **See it, fix it:** If you spot a problem, fix it immediately
2. **No "quick hacks":** Do it right the first time
3. **Clean as you go:** Leave code better than you found it
4. **Set standards:** Agree on what "clean" means for the team

**Examples:**

❌ **Don't:**
```javascript
// TODO: Fix this later
function processData(data) {
  // Quick hack for now
  return data.map(x => x ? x : null);
}
```

✅ **Do:**
```javascript
// Fixed properly
function processData(data) {
  return data.filter(Boolean);
}
```

### The Slippery Slope

- One broken window → tolerance for more
- Many broken windows → software rot
- Software rot → impossible to maintain
- **Fix early, fix often**

---

## ✅ Automate

### The Principle

**If it's not automated, it's a problem. Anything done more than once should be automated.**

### In Practice

**What to Automate:**
- **Tests:** Full test suite, run on every commit
- **Builds:** One command to build everything
- **Deployments:** One command to deploy to any environment
- **Documentation:** Auto-generate from code where possible
- **Code Quality:** Linting, formatting, static analysis
- **Repetitive tasks:** Scripts for common operations

**How to Apply:**
1. **Identify repetition:** What do you do manually more than once?
2. **Script it:** Write automation (even if simple)
3. **Integrate:** Hook into CI/CD or development workflow
4. **Maintain:** Keep automation updated with code changes

**Examples:**

❌ **Don't:**
```bash
# Manual deployment steps (run manually each time)
ssh server
cd /var/www/app
git pull
npm install
npm run build
pm2 restart app
exit
```

✅ **Do:**
```bash
# deploy.sh - one command
#!/bin/bash
set -e
SERVER="user@production"
ssh $SERVER "cd /var/www/app && git pull && npm install && npm run build && pm2 restart app"
```

### Automation Checklist

- [ ] All tests run automatically on commits
- [ ] Linting/formatting enforced in pre-commit hooks
- [ ] Build is reproducible (one command)
- [ ] Deployment is scripted (one command)
- [ ] Environment setup is automated

---

## ✅ Design for Change

### The Principle

**Code will change. Design for it. The only constant in software development is change.**

### In Practice

**How to Design for Change:**
- **Modularity:** Small, focused components
- **Loose coupling:** Components depend on abstractions, not concretions
- **Interfaces:** Define contracts between components
- **Configuration:** Externalize what changes
- **Extensibility:** Allow behavior extension without modification

**Examples:**

❌ **Don't:**
```javascript
// Hard to change - tight coupling
class UserService {
  constructor() {
    this.database = new PostgreSQLDatabase(); // Hard dependency
  }
}
```

✅ **Do:**
```javascript
// Easy to change - loose coupling
class UserService {
  constructor(database) {
    this.database = database; // Injected dependency
  }
}

// Can swap implementations easily
const pgService = new UserService(new PostgreSQLDatabase());
const mongoService = new UserService(new MongoDBDatabase());
```

### YAGNI (You Aren't Gonna Need It)

**Balance flexibility with simplicity:**
- Don't over-engineer for hypothetical future needs
- Design for *likely* changes, not *possible* changes
- Refactor when change actually happens

---

## ✅ Stone Soup

### The Principle

**Show incremental value. Let requirements evolve. Start small, grow.**

### In Practice

**How to Apply:**
1. **Start with a core:** Build the smallest useful thing
2. **Demonstrate value:** Show working software early
3. **Gather feedback:** Let users guide the direction
4. **Iterate:** Add features based on real needs, not guesses

**Examples:**

❌ **Don't:**
```
Phase 1: Design entire system
Phase 2: Build everything (6 months)
Phase 3: Deploy and hope users like it
```

✅ **Do:**
```
Iteration 1: Core feature (1 week) → Deploy → Get feedback
Iteration 2: Add top requested feature → Deploy → Get feedback
Iteration 3: Improve based on usage data → Continue...
```

---

## ✅ Good-Enough Software

### The Principle

**Perfect is the enemy of good. Ship working software. Iterate based on feedback.**

### In Practice

**What "Good Enough" Means:**
- **Works:** Solves the problem adequately
- **Tested:** Has tests for critical paths
- **Maintainable:** Others can understand and modify
- **User-valued:** Users find it useful

**What It Doesn't Mean:**
- Sloppy or buggy code
- Missing essential features
- No documentation
- Technical debt ignored

**Examples:**

❌ **Don't:**
```
"We need to architect the perfect system before coding"
```

✅ **Do:**
```
"Let's build a working solution, learn from it, and improve iteratively"
```

---

## Applying These Principles

### Before Writing Code

1. **Search existing codebase** - Is there already an implementation?
2. **Identify what might change** - Design for flexibility
3. **Plan for automation** - Tests, scripts, CI/CD
4. **Spot broken windows** - Fix them as you go

### While Writing Code

1. **Follow DRY** - Extract duplication immediately
2. **Keep it clean** - Leave code better than you found it
3. **Design for change** - Use interfaces, dependency injection
4. **Automate as you go** - Add tests, scripts

### After Writing Code

1. **Review for duplication** - Did you repeat patterns?
2. **Check for broken windows** - Did you create technical debt?
3. **Verify automation** - Do tests pass? Is deployment scripted?
4. **Document decisions** - Why this design? What might change?

---

## Principle Checklist

When reviewing code or features, verify:

- [ ] **DRY:** No duplicate logic or knowledge
- [ ] **Broken Windows:** Code is cleaner than when found
- [ ] **Automate:** Tests and deployment are scripted
- [ ] **Design for Change:** Code can adapt to likely changes
- [ ] **Stone Soup:** Incremental value demonstrated
- [ ] **Good Enough:** Software works and is ready for feedback

---

## Summary

**These principles are interconnected:**
- **DRY** + **Design for Change** = Maintainable code
- **Broken Windows** + **Automate** = High-quality codebase
- **Stone Soup** + **Good Enough** = Continuous delivery

**Apply them together for best results.**

---

**Remember:** These principles are guidelines, not rigid rules. Use judgment. The goal is working, maintainable software that delivers value.

**For condensed version:** `Read .claude/rules/05-pragmatic.md`
