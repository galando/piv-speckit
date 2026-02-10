# Frequently Asked Questions (FAQ)

**Common questions about PIV Spec-Kit**

---

## Getting Started

### What is PIV methodology?

PIV (Prime-Implement-Validate) is a development methodology designed specifically for AI-assisted software development with Claude Code. It ensures:

1. **Prime**: Load and understand codebase context before making changes
2. **Implement**: Plan features thoroughly, then execute systematically
3. **Validate**: Automatically test and verify implementations

This methodology prevents common AI-assisted development issues like lack of context, inconsistent implementations, and inadequate testing.

### Can I use PIV with an existing project?

**Yes!** Install the plugin to add PIV to any existing project:

```bash
# In Claude Code, from your project directory:
/plugin marketplace add galando/piv-speckit
/plugin install piv-speckit
```

The plugin installs without disrupting your existing workflow. See [Installing to Existing Projects](getting-started/04-installing-to-existing-projects.md) for a detailed guide.

### What technologies are supported?

PIV Spec-Kit is **technology-agnostic** and works with any stack:

**Backend:**
- Spring Boot (Java/Kotlin)
- Node.js + Express
- Python + FastAPI
- And more...

**Frontend:**
- React + TypeScript
- Vue.js
- Angular
- And more...

**Database:**
- PostgreSQL
- MySQL
- MongoDB
- And more...

The plugin provides base rules that apply universally, plus technology-specific rules that load automatically when relevant files are detected.

### Does PIV work with other AI coding tools?

PIV Spec-Kit is designed specifically for **Claude Code** and takes advantage of its unique features like:

- Slash commands (`/piv-speckit:prime`, etc.)
- Plugin system
- Context-aware agents
- Structured output parsing
- Multi-step reasoning

While the principles (context loading, planning, validation) could apply to other AI tools, the implementation is tightly coupled to Claude Code's capabilities.

### How much disk space does PIV require?

The plugin is quite lightweight:

- **Plugin files**: ~1 MB (installed via marketplace)
- **Generated artifacts**: Varies by usage (typically < 1 MB)

The plugin reference documentation is stored centrally and loaded on-demand, so you don't need local copies of technology templates.

---

## Usage

### When should I run `/piv-speckit:prime`?

**Prime is optional** - `/piv-speckit:plan-feature` auto-primes automatically.

Run `/piv-speckit:prime` manually when:
- You want to force a context refresh
- You've context-switched from another project
- Significant changes have been made by others
- You're starting work on a new feature area

### Do I need to run `/piv-speckit:plan-feature` for every change?

**No.** Use planning for:

- New features or endpoints
- Refactoring that affects multiple files
- Database migrations
- Complex authentication/authorization changes

**Skip planning for:**
- Simple bug fixes (use `/piv-speckit:rca` instead)
- Typo fixes
- Minor improvements to existing code
- Adding a single field to an existing form

### What if the automatic validation fails?

The validation pipeline runs automatically after `/piv-speckit:execute` completes. If it fails:

1. **Read the validation report** - It will explain what failed
2. **Fix the issues** - Address compilation errors, test failures, etc.
3. **Run manual validation** - Use `/piv-speckit:validate` to re-run
4. **Get help** - If stuck, open a [GitHub issue](https://github.com/galando/piv-speckit/issues)

You can also run individual validation steps:
- `/piv-speckit:code-review` - Technical code review
- `/piv-speckit:code-review-fix` - Auto-fix code review issues

### Can I customize PIV for my team's workflow?

**Absolutely!** PIV is designed to be customizable:

1. **Add team-specific rules** - Create new rule files in `.claude/rules/`
2. **Customize commands** - Modify command definitions in `.claude/commands/`
3. **Create custom skills** - Add auto-activating behaviors in `.claude/skills/`
4. **Validation thresholds** - Adjust coverage requirements, test frameworks, etc.

See [Extending PIV Spec-Kit](extending/01-adding-technologies.md) for details.

### How do I disable automatic validation?

We **strongly recommend keeping automatic validation enabled** - it's a core part of PIV methodology.

However, if you need to disable it temporarily, you can:
1. Not use `/piv-speckit:execute` - use `/piv-speckit:plan-feature` then implement manually
2. Or skip validation steps by editing the execute command

**Warning**: Disabling validation reduces the quality guarantees that PIV provides.

---

## Advanced

### How does PIV handle context loading?

The `/piv-speckit:prime` command uses Claude Code's context understanding to:

1. **Scan codebase structure** - Understand project layout
2. **Identify technologies** - Detect frameworks, libraries, tools
3. **Load relevant rules** - Only load rules applicable to your tech stack
4. **Create context artifact** - Save to `.claude/agents/context/`

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

### Can I contribute my own skills and rules?

**Yes, we welcome contributions!** To add new content:

1. Follow the [Extending guide](extending/01-adding-technologies.md)
2. Create the skill or rule files
3. Test them thoroughly
4. Submit a PR with your contribution

See [CONTRIBUTING.md](../CONTRIBUTING.md) for guidelines.

### What's the relationship between this framework and Cole Medin's work?

This framework is an **implementation** of the PIV methodology created by [Cole Medin (coleam00)](https://github.com/coleam00). Cole's original work includes:

- [context-engineering-intro](https://github.com/coleam00/context-engineering-intro) - PIV methodology introduction
- [habit-tracker](https://github.com/coleam00/habit-tracker) - PIV demonstration project

This framework extends Cole's work by providing:
- **Universal implementation** - Works with any technology stack
- **Plugin distribution** - Easy installation via Claude Code marketplace
- **Skills system** - Auto-activating behaviors for quality enforcement
- **Reference-based docs** - On-demand loading of full documentation

We give **full credit to Cole** for creating the PIV methodology. This is a community implementation to make PIV accessible to everyone.

---

## Troubleshooting

### Claude Code doesn't recognize PIV commands

**Symptoms**: Commands like `/piv-speckit:prime` aren't available

**Solutions**:
1. Verify plugin is installed: `/plugin list`
2. Reinstall if needed: `/plugin install piv-speckit`
3. Try restarting Claude Code
4. Check that you're in the correct project directory

### Plugin installation fails

**Symptoms**: Cannot install piv-speckit plugin

**Solutions**:
1. Add marketplace first: `/plugin marketplace add galando/piv-speckit`
2. Check your internet connection
3. Try: `/plugin marketplace remove galando/piv-speckit` then add again

### Validation fails with "No tests found"

**Symptoms**: Validation reports zero test coverage

**Solutions**:
1. Ensure you have test files in the correct locations
2. Verify test framework is configured (JUnit, pytest, Jest, etc.)
3. Check that test files match the naming patterns your framework expects
4. For new projects, create initial tests before running validation

### Context loading takes too long

**Symptoms**: `/piv-speckit:prime` takes several minutes

**Solutions**:
1. **Exclude unnecessary directories** - Add to `.gitignore`
2. **Reduce scan scope** - Edit prime command to focus on specific directories

Most projects should prime in under 30 seconds.

### Rules aren't loading for my technology

**Symptoms**: Technology-specific rules don't seem to apply

**Solutions**:
1. Check that plugin is installed: `/plugin list`
2. Verify rules are loading from: `${CLAUDE_PLUGIN_ROOT}/.claude-plugin/reference/rules-full/`
3. Add custom rules to `.claude/rules/` for project-specific patterns
4. Check the rule file syntax matches expected format

---

## Community

### Where can I ask questions?

- **GitHub Issues** - For bug reports and feature requests
- **GitHub Discussions** - For questions, ideas, and sharing experiences
- **Claude Code communities** - Check Claude's official channels

### How can I stay updated on PIV Spec-Kit development?

- ⭐ **Star the repo** - GitHub will notify you of new releases
- 👀 **Watch the repo** - See all issues and PRs
- Join [GitHub Discussions](https://github.com/galando/piv-speckit/discussions)
- Check the [CHANGELOG](../CHANGELOG.md) for version history

### Can I use PIV Spec-Kit for commercial projects?

**Yes!** PIV Spec-Kit is released under the [MIT License](../LICENSE), which permits:

- Commercial use
- Modification
- Distribution
- Private use

No attribution is required (though appreciated!).

---

## Still Have Questions?

- Check the [main documentation](README.md)
- Search [existing GitHub issues](https://github.com/galando/piv-speckit/issues)
- Start a [GitHub Discussion](https://github.com/galando/piv-speckit/discussions)
- Open a [new issue](https://github.com/galando/piv-speckit/issues/new)

---

**Last Updated**: 2026-02-03
