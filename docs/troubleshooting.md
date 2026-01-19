# Troubleshooting Guide

**Solutions to common issues with Claude Dev Framework**

---

## Installation Issues

### Permission Denied When Running Installer

**Symptoms:**
```bash
bash: /tmp/piv/scripts/piv.sh: Permission denied
```

**Cause:** Script doesn't have execute permissions

**Solutions:**
```bash
# Make script executable
chmod +x /tmp/piv/scripts/piv.sh

# Then run it
/tmp/piv/scripts/piv.sh
```

---

### Installer Fails: "Command Not Found: gh"

**Symptoms:**
```bash
Error: gh command not found
```

**Cause:** GitHub CLI (`gh`) is not installed

**Solutions:**

**macOS:**
```bash
brew install gh
```

**Linux:**
```bash
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
sudo apt update
sudo apt install gh
```

**Windows:**
Download from [GitHub CLI website](https://cli.github.com/)

---

### Installer Detected Wrong Technology

**Symptoms:**
Installer says "Detected: Spring Boot" but you're using React

**Cause:** Detection heuristics found files from both technologies

**Solutions:**

1. **Clean install** - Remove unwanted technology directories:
```bash
# After installer completes
rm -rf technologies/backend/spring-boot
rm -rf technologies/backend/node-express
# Keep only what you need
```

2. **Manual install** - Copy only the technology templates you need:
```bash
# Instead of running installer
cp -r /tmp/piv/.claude your-project/
cp -r /tmp/piv/technologies/frontend/react your-project/.claude/rules/
```

---

### Installer Creates Files in Wrong Location

**Symptoms:** `.claude` directory created in subdirectory instead of project root

**Cause:** Installer was run from wrong directory

**Solutions:**
```bash
# Navigate to your project root FIRST
cd your-project

# Verify you're in the right place (should see git repo, package.json, etc.)
ls

# Then run installer
/tmp/piv/scripts/piv.sh
```

---

## Claude Code Issues

### PIV Commands Not Recognized

**Symptoms:**
```
User: /piv_loop:prime
Claude: I don't recognize that command
```

**Cause:** Commands directory not found or not in project root

**Solutions:**

1. **Verify commands directory exists:**
```bash
ls .claude/commands/piv_loop/
# Should see: prime.md, plan-feature.md, execute.md
```

2. **Check project structure:**
```bash
# Commands must be in project root, not subdirectory
# Correct:
project-root/.claude/commands/

# Incorrect:
project-root/backend/.claude/commands/
```

3. **Restart Claude Code** - Sometimes it needs to reload the project

---

### Context Loading Takes Too Long

**Symptoms:** `/piv_loop:prime` takes more than 2 minutes

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

3. **Reduce scan scope** - Edit `.claude/commands/piv_loop/prime.md`:
```markdown
# Only scan specific directories
Focus scanning on:
- src/
- app/
- lib/
```

---

### Technology Rules Not Loading

**Symptoms:** Spring Boot rules don't apply when working on Java files

**Cause:** Rules not in correct location or wrong file format

**Solutions:**

1. **Verify rule file location:**
```bash
# Technology rules should be in:
ls .claude/rules/backend/spring-boot/
# Should see: 10-api-design.md, 20-database.md, etc.
```

2. **Check rule file format:**
```markdown
# First line must be:
## Rule: backend/**/*.java

# Not:
# Backend Rules for Spring Boot
```

3. **Copy rules if missing:**
```bash
# From skeleton to your project
cp -r technologies/backend/spring-boot/rules/* .claude/rules/backend/
```

---

### Prime Context File Not Created

**Symptoms:** After running `/piv_loop:prime`, no `.claude/agents/context/prime-context.md` file

**Cause:** Prime command failed or didn't complete

**Solutions:**

1. **Run prime again** - Sometimes it fails silently the first time
2. **Check for errors** - Look at Claude's output for error messages
3. **Create directory manually:**
```bash
mkdir -p .claude/agents/context
```

4. **Verify prime command exists:**
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
Use /validation:validate
```

---

### Code Review Finds Issues

**Symptoms:** `/validation:code-review` reports bugs or security issues

**Cause:** Code has quality or security problems

**Solutions:**

1. **Read the code review report** - `.claude/agents/reviews/code-review-*.md`
2. **Use automatic fix:**
```bash
# Ask Claude to fix issues
Use /validation:code-review-fix .claude/agents/reviews/code-report-123456.md
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

### Pre-commit Hooks Not Working

**Symptoms:** Commits accepted without running validation

**Cause:** Pre-commit hooks not installed or configured

**Solutions:**

1. **Install pre-commit hooks:**
```bash
# If using pre-commit framework
pip install pre-commit
pre-commit install
```

2. **Create git hook manually:**
```bash
# Create .git/hooks/pre-commit
cat > .git/hooks/pre-commit << 'EOF'
#!/bin/bash
# Run validation before commit
echo "Running PIV validation..."
# Add your validation commands here
EOF

chmod +x .git/hooks/pre-commit
```

3. **Bypass pre-commit if needed** (not recommended):
```bash
git commit --no-verify -m "message"
```

---

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

## Getting Help

### Still Having Issues?

1. **Check the [FAQ](FAQ.md)** - Common questions and answers
2. **Search [GitHub Issues](https://github.com/galando/claude-piv-skeleton/issues)** - Similar problems may already be solved
3. **Ask in [GitHub Discussions](https://github.com/galando/claude-piv-skeleton/discussions)** - Community help
4. **Open a [new issue](https://github.com/galando/claude-piv-skeleton/issues/new)** - Bug reports or feature requests

### When Opening an Issue

Include:
- **PIV Skeleton version** (e.g., v1.0.0)
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

1. **Always run prime** in new sessions
2. **Keep `.gitignore` updated** - Exclude generated files and dependencies
3. **Run validation** before committing
4. **Read error messages** - They usually contain solutions
5. **Check file locations** - Most issues are wrong file placement
6. **Use version control** - Commit in small increments
7. **Test in fresh environment** - Reproduce issues in clean directory

---

**Last Updated**: 2025-01-12

**Found this guide helpful?** ⭐ Consider [starring the repo](https://github.com/galando/claude-piv-skeleton)
