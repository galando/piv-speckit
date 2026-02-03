# Installing PIV to Existing Projects

**How to add the PIV methodology to your existing project**

---

## Overview

PIV Spec-Kit is installed as a **Claude Code plugin** from the marketplace. It integrates directly into your existing project without complex installation scripts.

**Installation time**: ~30 seconds

---

## Quick Install

### One-Line Install

```bash
# In Claude Code, from your project directory:
/plugin marketplace add galando/piv-speckit
/plugin install piv-speckit
```

That's it! The plugin is now installed and ready to use.

### Verify Installation

```bash
# In Claude Code, run:
/piv-speckit:prime
```

You should see context loading from your project.

---

## Prerequisites

Before installing, ensure you have:

- **Claude Code** - The Claude CLI tool (installed and configured)
- **Existing project** - Any software project with code
- **Git** repository (optional but recommended)

No other dependencies required.

---

## What Gets Installed

When you install the plugin, Claude Code automatically makes available:

### PIV Commands

| Command | Purpose |
|---------|---------|
| `/piv-speckit:plan-feature "desc"` | Create structured plans (auto-primes) |
| `/piv-speckit:execute` | Implement from plans |
| `/piv-speckit:prime` | Force context refresh |
| `/piv-speckit:validate` | Run validation checks |
| `/piv-speckit:code-review` | Technical code review |
| `/piv-speckit:learn` | Capture learnings |
| `/piv-speckit:learning-status` | View learning metrics |
| `/piv-speckit:rca` | Root cause analysis |
| `/piv-speckit:implement-fix` | Implement bug fixes |

### Auto-Activating Skills

Skills automatically activate to enforce best practices:

| Skill | Activates When |
|-------|----------------|
| `test-driven-development` | Writing or implementing code |
| `code-review` | Reviewing code changes |
| `security` | Handling sensitive data |
| `api-design` | Designing APIs |
| `test-writing` | Writing tests |
| `adaptive-learning` | After code reviews |

### Coding Rules

Rules are automatically loaded from the plugin:

- General development rules
- Git workflow rules
- Testing philosophy
- Strict TDD rules
- Documentation standards
- Security guidelines
- Backend-specific rules (API design, database)

---

## How It Works

### Plugin vs. Project Files

**Plugin Files (read-only, managed by plugin):**
- `.claude-plugin/` - Plugin manifest and reference docs
- Commands definitions
- Skill definitions
- Full methodology documentation

**Your Project (where you customize):**
- `.claude/CLAUDE.md` - Your project instructions
- `.claude/rules/` - Your custom rules (optional overrides)
- `.claude/agents/` - Generated artifacts (plans, reviews, learnings)

### Reference Paths

The plugin uses `${CLAUDE_PLUGIN_ROOT}` references to load documentation:

```
Read ${CLAUDE_PLUGIN_ROOT}/.claude-plugin/reference/rules-full/tdd-full.md
```

This means:
- Plugin docs are always available
- No local copies needed
- Updates are automatic

---

## After Installation

### Your First PIV Command

```bash
# In Claude Code:
/piv-speckit:prime
```

This loads your project's context:
- Project structure
- Technology stack
- Coding rules
- PIV methodology

### Plan Your First Feature

```bash
# In Claude Code:
/piv-speckit:plan-feature "add user authentication"
```

Claude will create structured artifacts in `.claude/specs/{feature}/`:
- `spec.md` - Requirements (WHAT)
- `plan.md` - Technical approach (HOW)
- `tasks.md` - Implementation steps (DO)
- `quickstart.md` - TL;DR reference

### Implement Your Feature

```bash
# In Claude Code:
/piv-speckit:execute
```

Claude will:
1. Follow RED-GREEN-REFACTOR TDD cycle
2. Execute tasks step by step
3. Auto-validate implementation
4. Generate execution report

---

## Customization

### Add Project-Specific Rules

Create `.claude/rules/` in your project:

```bash
# Create custom rules directory
mkdir -p .claude/rules

# Add your project-specific rules
echo "# My Project Rules

- Always use TypeScript strict mode
- Maximum function length: 50 lines
- All API responses must be typed
" > .claude/rules/99-project-specific.md
```

### Customize Project Instructions

Edit `.claude/CLAUDE.md`:

```markdown
# My Project

## Technology Stack
- Backend: Spring Boot 3.2
- Frontend: React 19 + TypeScript
- Database: PostgreSQL 15

## Project Structure
- src/main/java/ - Backend code
- src/frontend/ - React application
- src/db/migrations/ - Database migrations

## Coding Standards
- Follow existing patterns
- Write tests first (TDD)
- Keep PRs small and focused
```

---

## Updating the Plugin

```bash
# In Claude Code:
/plugin update piv-speckit
```

Or reinstall:

```bash
/plugin marketplace remove galando/piv-speckit
/plugin marketplace add galando/piv-speckit
/plugin install piv-speckit
```

---

## Uninstalling

```bash
# In Claude Code:
/plugin uninstall piv-speckit
```

This removes the plugin but keeps your:
- `.claude/` directory (your customizations)
- `.claude/agents/` (your artifacts)
- Generated specs and plans

To completely remove all PIV files:

```bash
# After uninstalling plugin:
rm -rf .claude/agents/
rm -rf .claude/specs/
```

---

## Troubleshooting

### Commands Not Found

**Problem:** PIV commands not recognized

**Solution:**
```bash
# Verify plugin is installed
/plugin list

# Reinstall if needed
/plugin install piv-speckit
```

### Rules Not Loading

**Problem:** Custom rules not being applied

**Solution:**
- Verify `.claude/rules/` exists
- Check rules have `.md` extension
- Restart Claude Code

### Context Not Loading

**Problem:** Prime command shows no output

**Solution:**
- Verify `.claude/CLAUDE.md` exists
- Check your project has code files
- Try running `/piv-speckit:plan-feature` directly (it auto-primes)

### Skills Not Activating

**Problem:** Skills don't auto-activate

**Solution:**
- Skills activate based on context (coding, reviewing, etc.)
- Trigger manually by asking for a code review or test
- Check skill definitions in `.claude/skills/`

---

## Verification Checklist

After installation, verify:

- [ ] `/plugin list` shows `piv-speckit`
- [ ] `/piv-speckit:prime` loads context
- [ ] `/piv-speckit:plan-feature "test"` creates a spec
- [ ] `.claude/agents/` directory exists
- [ ] `.claude/CLAUDE.md` exists (with your project info)

---

## Next Steps

1. **Customize CLAUDE.md** - Add your project specifics
2. **Add custom rules** - Create `.claude/rules/99-project-specific.md`
3. **Plan a feature** - Run `/piv-speckit:plan-feature` for real work
4. **Read the methodology** - Check out the [full PIV methodology](../../.claude/reference/methodology/PIV-METHODOLOGY.md)

---

## FAQ

**Q: Does this modify my existing `.claude/` setup?**
A: No, it adds PIV commands alongside your existing configuration.

**Q: Can I use my own rules?**
A: Yes, create `.claude/rules/` and the plugin will load them.

**Q: What if I don't want to use TDD?**
A: The TDD skill enforces strict TDD. You can disable it by removing or renaming `.claude/skills/test-driven-development/`.

**Q: Does this work with any technology?**
A: Yes, it's technology-agnostic. Backend-specific rules load automatically when Spring Boot files are detected.

---

**Questions?** Open an issue on [GitHub](https://github.com/galando/piv-speckit/issues)
