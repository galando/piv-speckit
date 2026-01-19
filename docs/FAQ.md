# Frequently Asked Questions (FAQ)

**Common questions about PIV methodology and this skeleton**

---

## Getting Started

### What is PIV methodology?

PIV (Prime-Implement-Validate) is a development methodology designed specifically for AI-assisted software development with Claude Code. It ensures:

1. **Prime**: Load and understand codebase context before making changes
2. **Implement**: Plan features thoroughly, then execute systematically
3. **Validate**: Automatically test and verify implementations

This methodology prevents common AI-assisted development issues like lack of context, inconsistent implementations, and inadequate testing.

### Can I use PIV with an existing project?

**Yes!** The unified installer can add PIV to existing projects without disrupting your workflow:

```bash
cd your-project
curl -s https://raw.githubusercontent.com/galando/claude-dev-framework/main/scripts/piv.sh | bash
```

The installer will:
- Auto-detect if you need installation or update
- Detect your technology stack
- Install only the relevant PIV components
- Preserve your existing configuration
- Create an automatic backup

See [Installing to Existing Projects](getting-started/04-installing-to-existing-projects.md) for detailed guide.

### What technologies are supported?

PIV skeleton supports multiple technologies out of the box:

**Backend:**
- Spring Boot (Java/Kotlin)
- Node.js + Express
- Python + FastAPI

**Frontend:**
- React + TypeScript

**Database:**
- PostgreSQL

**DevOps:**
- Docker

The modular design makes it easy to add support for new technologies. See [Adding Technologies](../extending/01-adding-technologies.md) for guidance.

### Does PIV work with other AI coding tools?

PIV methodology is designed specifically for **Claude Code** and takes advantage of its unique features like:

- Slash commands (`/piv_loop:prime`, etc.)
- Context-aware agents
- Structured output parsing
- Multi-step reasoning

While the principles (context loading, planning, validation) could apply to other AI tools, the implementation is tightly coupled to Claude Code's capabilities.

### How much disk space does PIV require?

The skeleton is quite lightweight:

- **Core PIV files**: ~500 KB
- **Documentation**: ~2 MB
- **Technology templates**: Varies (typically 100-500 KB each)

You can also remove technologies you don't use to save space. For example, if you only use Spring Boot, you can delete the `technologies/frontend/` and `technologies/backend/node-express/` directories.

---

## Usage

### When should I run `/piv_loop:prime`?

**Always prime the workspace in a new session** or when:

- You haven't worked on the project in a while
- You've context-switched from another project
- Significant changes have been made by others
- You're starting work on a new feature area

For simple bug fixes in code you're actively working on, you can skip priming.

### Do I need to run `/piv_loop:plan-feature` for every change?

**No.** Use planning for:

- New features or endpoints
- Refactoring that affects multiple files
- Database migrations
- Complex authentication/authorization changes

**Skip planning for:**
- Simple bug fixes (use `/bug_fix:rca` instead)
- Typo fixes
- Minor improvements to existing code
- Adding a single field to an existing form

### What if the automatic validation fails?

The validation pipeline runs automatically after `/piv_loop:execute` completes. If it fails:

1. **Read the validation report** - It will explain what failed
2. **Fix the issues** - Address compilation errors, test failures, etc.
3. **Run manual validation** - Use `/validation:validate` to re-run
4. **Get help** - If stuck, open a [GitHub issue](https://github.com/galando/claude-piv-skeleton/issues)

You can also run individual validation steps:
- `/validation:code-review` - Technical code review
- `/validation:code-review-fix <report>` - Auto-fix code review issues

### Can I customize PIV for my team's workflow?

**Absolutely!** PIV is designed to be customizable:

1. **Add team-specific rules** - Create new rule files in `.claude/rules/`
2. **Customize commands** - Modify command definitions in `.claude/commands/`
3. **Technology-specific patterns** - Add templates for your stack
4. **Validation thresholds** - Adjust coverage requirements, test frameworks, etc.

See [Customizing PIV](../extending/02-customizing-piv.md) for details.

### How do I disable automatic validation?

We **strongly recommend keeping automatic validation enabled** - it's a core part of PIV methodology.

However, if you need to disable it temporarily, you can:
1. Not use `/piv_loop:execute` - use `/piv_loop:plan-feature` then implement manually
2. Or skip validation steps by editing the execute command

**Warning**: Disabling validation reduces the quality guarantees that PIV provides.

---

## Advanced

### How does PIV handle context loading?

The `/piv_loop:prime` command uses Claude Code's context understanding to:

1. **Scan codebase structure** - Understand project layout
2. **Identify technologies** - Detect frameworks, libraries, tools
3. **Load relevant rules** - Only load rules applicable to your tech stack
4. **Create context artifact** - Save to `.claude/agents/context/prime-context.md`

This context is then used by subsequent commands to make informed decisions.

### Can I use PIV with monorepos?

**Yes**, with some considerations:

1. **Prime each workspace** - Prime context for each subproject
2. **Shared rules** - Keep common PIV rules at monorepo root
3. **Technology-specific rules** - Place in subproject `.claude/` directories
4. **Adjust paths** - Ensure validation commands work across projects

Example monorepo structure:
```
monorepo/
├── .claude/                    # Shared PIV config
│   ├── rules/                  # Universal rules
│   └── commands/               # Shared commands
├── backend/                    # Spring Boot service
│   └── .claude/
│       └── rules/backend/      # Backend-specific rules
├── frontend/                   # React app
│   └── .claude/
│       └── rules/frontend/     # Frontend-specific rules
```

### How does PIV compare to traditional development workflows?

| Aspect | Traditional | PIV with Claude Code |
|--------|-------------|----------------------|
| Context understanding | Manual code review | Automated context loading |
| Planning | Ad-hoc or documents | Structured plans with artifacts |
| Implementation | Manual coding | AI-assisted with quality gates |
| Validation | Manual testing | Automated validation pipeline |
| Consistency | Varies by developer | Enforced through rules |
| Knowledge transfer | Documentation-heavy | Context-aware AI assistance |

PIV doesn't replace traditional practices - it **augments** them with AI assistance while maintaining quality standards.

### Can I contribute my own technology templates?

**Yes, we welcome contributions!** To add a new technology:

1. Follow the [Adding Technologies guide](../extending/01-adding-technologies.md)
2. Create the technology directory structure
3. Add rules, examples, and documentation
4. Submit a PR with your template

See [CONTRIBUTING.md](../../CONTRIBUTING.md) for guidelines.

### What's the relationship between this skeleton and Cole Medin's work?

This skeleton is an **implementation** of the PIV methodology created by [Cole Medin (coleam00)](https://github.com/coleam00). Cole's original work includes:

- [context-engineering-intro](https://github.com/coleam00/context-engineering-intro) - PIV methodology introduction
- [habit-tracker](https://github.com/coleam00/habit-tracker) - PIV demonstration project

This skeleton extends Cole's work by providing:
- **Universal implementation** - Works with any technology stack
- **Comprehensive templates** - Pre-built configurations for popular stacks
- **Installer for existing projects** - Easy adoption
- **Modular design** - Pick only what you need

We give **full credit to Cole** for creating the PIV methodology. This is a community implementation to make PIV accessible to everyone.

---

## Troubleshooting

### Claude Code doesn't recognize PIV commands

**Symptoms**: Commands like `/piv_loop:prime` aren't available

**Solutions**:
1. Ensure `.claude/commands/` directory exists in your project root
2. Check that command files (`.md`) are present and readable
3. Try restarting Claude Code
4. Verify the commands directory is at the correct level (project root, not subdirectory)

### Installer script fails with permission errors

**Symptoms**: `Permission denied` when running `piv.sh`

**Solution**:
```bash
chmod +x /tmp/piv/scripts/piv.sh
/tmp/piv/scripts/piv.sh
```

### Validation fails with "No tests found"

**Symptoms**: Validation reports zero test coverage

**Solutions**:
1. Ensure you have test files in the correct locations
2. Verify test framework is configured (JUnit, pytest, Jest, etc.)
3. Check that test files match the naming patterns your framework expects
4. For new projects, create initial tests before running validation

### Context loading takes too long

**Symptoms**: `/piv_loop:prime` takes several minutes

**Solutions**:
1. **Exclude unnecessary directories** - Add to `.gitignore`
2. **Reduce scan scope** - Edit prime command to focus on specific directories
3. **Remove unused technologies** - Delete technology templates you don't use

Most projects should prime in under 30 seconds.

### Rules aren't loading for my technology

**Symptoms**: Technology-specific rules don't seem to apply

**Solutions**:
1. Check that rule files are in the correct location (`technologies/*/rules/`)
2. Verify file naming follows the pattern (`## Rule: /path/pattern`)
3. Ensure rule files are in your project's `.claude/rules/` directory
4. Check the rule file syntax matches other rule files

---

## Community

### Where can I ask questions?

- **GitHub Issues** - For bug reports and feature requests
- **GitHub Discussions** - For questions, ideas, and sharing experiences
- **Claude Code communities** - Check Claude's official channels

### How can I stay updated on PIV skeleton development?

- ⭐ **Star the repo** - GitHub will notify you of new releases
- 👀 **Watch the repo** - See all issues and PRs
- Join [GitHub Discussions](https://github.com/galando/claude-piv-skeleton/discussions)
- Check the [ROADMAP](ROADMAP.md) for planned features

### Can I use PIV skeleton for commercial projects?

**Yes!** PIV skeleton is released under the [MIT License](../../LICENSE), which permits:

- Commercial use
- Modification
- Distribution
- Private use

No attribution is required (though appreciated!).

---

## Still Have Questions?

- Check the [main documentation](../README.md)
- Search [existing GitHub issues](https://github.com/galando/claude-piv-skeleton/issues)
- Start a [GitHub Discussion](https://github.com/galando/claude-piv-skeleton/discussions)
- Open a [new issue](https://github.com/galando/claude-piv-skeleton/issues/new)

---

**Last Updated**: 2025-01-12
