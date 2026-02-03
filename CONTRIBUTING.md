# Contributing to PIV Spec-Kit

**Thank you for your interest in contributing!**

PIV Spec-Kit is a community-driven framework for AI-assisted software development using the PIV (Prime-Implement-Validate) methodology with Claude Code. We welcome contributions of all kinds.

---

## Ways to Contribute

### 1. Improve Documentation
Fix typos, clarify explanations, add examples, improve getting started guides.

### 2. Add New Skills
Create auto-activating behaviors that enforce best practices.

### 3. Add New Rules
Contribute coding rules for specific technologies or practices.

### 4. Share Examples
Add real-world implementation examples showing PIV methodology in action.

### 5. Report Issues
Found a bug or have a suggestion? [Open an issue](https://github.com/galando/piv-speckit/issues).

### 6. Submit PRs
Pull requests are welcome! See below for guidelines.

---

## Getting Started

### 1. Fork and Clone
```bash
# Fork the repository on GitHub
git clone https://github.com/YOUR_USERNAME/piv-speckit.git
cd piv-speckit
```

### 2. Create a Branch
```bash
git checkout -b feature/your-feature-name
# or
git checkout -b docs/your-documentation-update
# or
git checkout -b fix/your-bug-fix
```

---

## Contribution Types

### Adding a New Skill

Skills are auto-activating behaviors that enforce best practices.

#### Directory Structure
Create a new skill directory:
```
.claude/skills/
└── your-skill/
    └── SKILL.md
```

#### Skill Template
```markdown
# Your Skill Name

**Trigger**: When does this skill activate?

## Purpose
[Brief description of what this skill enforces]

## Activation Conditions
- Condition 1
- Condition 2

## Rules
1. **Rule 1**: Description
2. **Rule 2**: Description

## Reference
${CLAUDE_PLUGIN_ROOT}/.claude-plugin/reference/skills-full/your-skill-full.md
```

### Adding New Rules

Rules are coding guidelines that Claude follows.

#### Directory Structure
```
.claude/rules/
├── 00-general.md
├── 10-git.md
├── 20-testing.md
└── backend/
    └── your-rules.md
```

#### Rule Template
```markdown
# Rule Category

## Core Principles

### Principle Name
- **Rule**: What to do
- **Rationale**: Why

## Examples

**Good:**
```example
// Correct approach
```

**Bad:**
```example
// Wrong approach
```

**For complete rules:** Read `${CLAUDE_PLUGIN_ROOT}/.claude-plugin/reference/rules-full/category-full.md`
```

### Improving Documentation

#### Fixing Typos/Errors
- Simple fixes: Just submit the PR
- Include "Documentation" in commit message

#### Adding Guides
Create in `docs/` directory:
```
docs/
├── getting-started/
├── features/
├── extending/
└── examples/
```

Follow existing documentation structure and style.

---

## Pull Request Guidelines

### Before Submitting

1. **Update Documentation**
   - Update relevant docs
   - Add comments to complex code
   - Update README if needed

2. **Follow Conventions**
   - Match existing code style
   - Use consistent formatting
   - Follow naming conventions

3. **Test Your Changes**
   - Verify rules are clear
   - Check examples work
   - Test documentation links

4. **Write Good Commit Messages**
   ```
   type(scope): description

   - Change 1
   - Change 2

   Closes #123
   ```

### PR Description Template

```markdown
## Summary
[Brief description of changes]

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Documentation update
- [ ] Skill addition
- [ ] Rule addition/modification

## What Changed
- [ ] Change 1
- [ ] Change 2
- [ ] Change 3

## Testing
- [ ] Verified rules are clear
- [ ] Checked examples work
- [ ] Tested documentation links
- [ ] Reviewed for consistency

## Related Issues
Closes #123
Related to #456
```

---

## Code Style

### Markdown
- Use proper markdown formatting
- Include tables for comparisons
- Use code blocks with language tags
- Add descriptive headers

### File Naming
- Use kebab-case for files: `my-file.md`
- Use descriptive names
- Follow existing conventions

---

## Review Process

### What Gets Reviewed

1. **Quality**
   - Is the content clear and accurate?
   - Are examples correct?
   - Is documentation comprehensive?

2. **Consistency**
   - Does it match existing style?
   - Is it consistent with PIV methodology?
   - Does it follow conventions?

3. **Completeness**
   - Are all required files included?
   - Is documentation complete?
   - Are examples functional?

---

## Questions?

### Where to Ask

1. **GitHub Discussions** - General questions, ideas
2. **GitHub Issues** - Bugs, feature requests
3. **Pull Request** - Questions about specific PR

---

## Recognition

Contributors will be:
- Credited in release notes
- Thanked in relevant documentation

---

## License

By contributing, you agree that your contributions will be licensed under the MIT License.

---

## Summary

Thank you for contributing! Key points:

1. **FORK** the repository
2. **BRANCH** for your work
3. **FOLLOW** conventions
4. **TEST** your changes
5. **DOCUMENT** clearly
6. **SUBMIT** PR with clear description

We look forward to your contributions!

---

**Need help?** Open an issue or start a discussion. We're here to help!

**Want to learn more?** Check out the [documentation](docs/).
