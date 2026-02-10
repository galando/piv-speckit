# Troubleshooting Guide

**Solutions to common issues with PIV Spec-Kit**

---

## Installation Issues

### Plugin Not Found

**Symptoms:**
```
Error: Plugin 'piv-speckit' not found
```

**Cause:** Plugin not added to marketplace or not installed

**Solutions:**

1. **Add marketplace first:**
```bash
/plugin marketplace add galando/piv-speckit
```

2. **Then install:**
```bash
/plugin install piv-speckit
```

3. **Verify installation:**
```bash
/plugin list
# Should show piv-speckit
```

---

### Commands Not Recognized

**Symptoms:**
```
User: /piv-speckit:prime
Claude: I don't recognize that command
```

**Cause:** Plugin not installed or not loaded

**Solutions:**

1. **Verify plugin is installed:**
```bash
/plugin list
# Should show piv-speckit
```

2. **Reinstall if needed:**
```bash
/plugin install piv-speckit
```

3. **Restart Claude Code** - Sometimes it needs to reload

---

## Claude Code Issues

### Context Loading Takes Too Long

**Symptoms:** `/piv-speckit:prime` takes more than 2 minutes

**Cause:** Scanning too many files (including `node_modules/`, `target/`, etc.)

**Solutions:**

1. **Ensure `.gitignore` is set up:**
```bash
# Check that these are ignored
cat .gitignore | grep -E "node_modules|target|build|dist|.next"
```

2. **Add large directories to `.gitignore`:**
```bash
echo "node_modules/" >> .gitignore
echo "target/" >> .gitignore
echo "build/" >> .gitignore
echo ".next/" >> .gitignore
```

---

### Rules Not Loading

**Symptoms:** Spring Boot rules don't apply when working on Java files

**Cause:** Rules not in correct location or plugin not loaded

**Solutions:**

1. **Verify plugin is installed:**
```bash
/plugin list
```

2. **Check for custom rules:**
```bash
ls .claude/rules/
# Your custom rules go here
```

3. **Plugin rules load from:**
```bash
# Plugin provides base rules via:
${CLAUDE_PLUGIN_ROOT}/.claude-plugin/reference/rules-full/
```

---

### Prime Context File Not Created

**Symptoms:** After running `/piv-speckit:prime`, no `.claude/agents/context/` file

**Cause:** Prime command failed or didn't complete

**Solutions:**

1. **Run prime again** - Sometimes it fails silently the first time
2. **Check for errors** - Look at Claude's output for error messages
3. **Verify prime command exists:**
```bash
cat .claude/commands/piv_loop/prime.md
# Should contain the prime command definition
```

---

## Validation Issues

### Validation Fails: "No Tests Found"

**Symptoms:**
```
[ERROR] Test coverage: 0%
[ERROR] No test files found
```

**Cause:** No test files or test framework not configured

**Solutions:**

1. **Create initial tests:**
```bash
# Spring Boot
mkdir -p src/test/java/com/example/
# Create test class

# Node.js
npm install --save-dev jest
# Create test file

# Python
pip install pytest
# Create test file
```

2. **Verify test framework is configured:**
```bash
# Check for test configuration
ls pom.xml              # Spring Boot
ls package.json         # Node.js
ls pytest.ini           # Python (or pyproject.toml)
```

3. **Run tests manually first:**
```bash
# Spring Boot
mvn test

# Node.js
npm test

# Python
pytest
```

---

### Validation Fails: Compilation Errors

**Symptoms:**
```
[ERROR] Compilation failed
```

**Cause:** Code has syntax errors or missing dependencies

**Solutions:**

1. **Check compilation manually:**
```bash
# Spring Boot
mvn clean compile

# Node.js
npm run build

# Python
python -m py_compile src/**/*.py
```

2. **Fix errors shown** - Address each compilation error
3. **Re-run validation:**
```bash
# Ask Claude to run validation again
Use /piv-speckit:validate
```

---

### Code Review Finds Issues

**Symptoms:** `/piv-speckit:code-review` reports bugs or security issues

**Cause:** Code has quality or security problems

**Solutions:**

1. **Read the code review report** - `.claude/agents/reviews/code-review-*.md`
2. **Use automatic fix:**
```bash
# Ask Claude to fix issues
Use /piv-speckit:code-review-fix
```

3. **Manual fixes** - Address issues that can't be auto-fixed
4. **Re-run code review** to verify fixes

---

### Coverage Requirements Not Met

**Symptoms:**
```
[ERROR] Coverage: 65% (required: 80%)
```

**Cause:** Insufficient test coverage

**Solutions:**

1. **Identify uncovered code:**
```bash
# Spring Boot
mvn jacoco:report
# View report: target/site/jacoco/index.html

# Node.js
npm test -- --coverage
# View coverage report

# Python
pytest --cov=. --cov-report=html
# View htmlcov/index.html
```

2. **Add tests for uncovered paths**
3. **Lower coverage threshold** (if appropriate):
   - Edit `.claude/commands/validation/validate.md`
   - Change coverage requirement
   - Use only if truly justified

---

## Git Issues

### Git Status Shows PIV Files as Untracked

**Symptoms:**
```
Untracked files:
.claude/agents/context/
.claude/agents/plans/
```

**Cause:** Agent-generated artifacts not in `.gitignore`

**Solutions:**

1. **Add to `.gitignore`:**
```bash
echo ".claude/agents/" >> .gitignore
```

2. **Or commit selectively:**
```bash
# Commit only certain files
git add .claude/rules/
git add .claude/commands/
git commit -m "Add PIV configuration"

# Ignore agent artifacts
echo ".claude/agents/" >> .gitignore
```

---

## Project-Specific Issues

### Spring Boot: Maven Fails to Find Dependencies

**Symptoms:**
```
[ERROR] Could not resolve dependencies
```

**Cause:** Missing or incorrect `pom.xml`

**Solutions:**

1. **Verify `pom.xml` exists:**
```bash
ls pom.xml
```

2. **Run Maven commands from correct directory:**
```bash
# Must be in directory with pom.xml
cd backend/  # or wherever pom.xml is
mvn clean compile
```

3. **Force dependency update:**
```bash
mvn clean install -U
```

---

### React: TypeScript Errors in Generated Code

**Symptoms:**
```
Error: Type 'string' is not assignable to type 'number'
```

**Cause:** TypeScript types not specified or incorrect

**Solutions:**

1. **Add type annotations:**
```typescript
// Specify types explicitly
const userId: string = user.id;
const age: number = user.age;
```

2. **Enable strict mode in `tsconfig.json`:**
```json
{
  "compilerOptions": {
    "strict": true
  }
}
```

3. **Use TypeScript's type checking:**
```bash
npx tsc --noEmit
```

---

### Python: Import Errors in Tests

**Symptoms:**
```
ModuleNotFoundError: No module named 'app'
```

**Cause:** Python path not configured correctly

**Solutions:**

1. **Create `__init__.py` files:**
```bash
touch app/__init__.py
touch app/services/__init__.py
```

2. **Set `PYTHONPATH`:**
```bash
export PYTHONPATH="${PYTHONPATH}:$(pwd)"
pytest
```

3. **Use pytest configuration:**
```ini
# pytest.ini or pyproject.toml
[tool.pytest.ini_options]
pythonpath = ["."]
```

---

### Node.js: ES Module Import Errors

**Symptoms:**
```
SyntaxError: Cannot use import statement outside a module
```

**Cause:** Package type not set to module

**Solutions:**

1. **Add `"type": "module"` to `package.json`:**
```json
{
  "type": "module"
}
```

2. **Or use `.mjs` extension:**
```bash
mv app.js app.mjs
```

3. **Or use CommonJS requires:**
```javascript
// Instead of: import { express } from 'express';
const express = require('express');
```

---

## Skills Not Activating

### TDD Skill Not Enforcing RED-GREEN-REFACTOR

**Symptoms:** Writing code before tests doesn't trigger warning

**Cause:** Skill may be disabled or not loading

**Solutions:**

1. **Verify skill exists:**
```bash
ls .claude/skills/test-driven-development/
```

2. **Check skill definition:**
```bash
cat .claude/skills/test-driven-development/SKILL.md
```

3. **Skills activate based on context** - They trigger when:
   - Writing implementation code
   - Creating or modifying tests
   - Reviewing code changes

---

## Getting Help

### Still Having Issues?

1. **Check the [FAQ](FAQ.md)** - Common questions and answers
2. **Search [GitHub Issues](https://github.com/galando/piv-speckit/issues)** - Similar problems may already be solved
3. **Ask in [GitHub Discussions](https://github.com/galando/piv-speckit/discussions)** - Community help
4. **Open a [new issue](https://github.com/galando/piv-speckit/issues/new)** - Bug reports or feature requests

### When Opening an Issue

Include:
- **PIV Spec-Kit version** (e.g., v4.3.0)
- **Claude Code version** (if known)
- **Operating system**
- **Technology stack**
- **Steps to reproduce**
- **Error messages or logs**
- **What you tried already**

This helps us help you faster! 🚀

---

## Prevention Tips

### Best Practices to Avoid Issues

1. **Keep plugin updated** - Run `/plugin update piv-speckit` regularly
2. **Keep `.gitignore` updated** - Exclude generated files and dependencies
3. **Run validation** before committing
4. **Read error messages** - They usually contain solutions
5. **Check file locations** - Most issues are wrong file placement
6. **Use version control** - Commit in small increments
7. **Test in fresh environment** - Reproduce issues in clean directory

---

**Last Updated**: 2026-02-03

**Found this guide helpful?** ⭐ Consider [starring the repo](https://github.com/galando/piv-speckit)
