# Contributing to Claude PIV Skeleton

**Thank you for your interest in contributing!**

This project is a community-driven resource for AI-assisted software development using the PIV methodology with Claude Code. We welcome contributions of all kinds.

---

## Ways to Contribute

### 1. Add New Technologies
Add support for your favorite technology stack by creating templates, rules, and examples.

### 2. Improve Documentation
Fix typos, clarify explanations, add examples, improve getting started guides.

### 3. Share Examples
Add real-world implementation examples showing PIV methodology in action.

### 4. Report Issues
Found a bug or have a suggestion? [Open an issue](https://github.com/YOUR_USERNAME/claude-piv-skeleton/issues).

### 5. Submit PRs
Pull requests are welcome! See below for guidelines.

---

## Getting Started

### 1. Fork and Clone
```bash
# Fork the repository on GitHub
git clone https://github.com/YOUR_USERNAME/claude-piv-skeleton.git
cd claude-piv-skeleton
```

### 2. Set Up Your Environment
```bash
# Install dependencies (if any)
# No build process needed - this is a documentation/rules repository
```

### 3. Create a Branch
```bash
git checkout -b feature/your-feature-name
# or
git checkout -b docs/your-documentation-update
# or
git checkout -b fix/your-bug-fix
```

---

## Contribution Types

### Adding a New Technology

#### Directory Structure
Create a new technology directory:
```
technologies/
├── backend/
│   └── your-tech/          # Create this
│       ├── README.md
│       ├── .claude/
│       │   └── rules/
│       ├── reference/
│       └── examples/
```

#### Required Files

1. **README.md** - Technology overview
```markdown
# [Technology Name]

## Overview
[Brief description]

## Installation
[How to install and setup]

## PIV Integration
[How this integrates with PIV methodology]

## Rules Included
[List of rule files and their purposes]

## Examples
[Description of examples provided]

## Contributing
[How to contribute to this technology]
```

2. **Rules** (`technologies/your-tech/.claude/rules/`)
- Use numeric prefix: `NN-name.md` (NN = load order)
- Follow rule template structure
- Include patterns and anti-patterns

3. **Reference Documentation** (`technologies/your-tech/reference/`)
- `patterns.md` - Design patterns specific to technology
- `integration.md` - How to integrate with PIV

4. **Examples** (`technologies/your-tech/examples/`)
- Minimal working examples
- Demonstrates all rules in practice
- Well-commented

#### Technology Metadata
Create `tech.yaml`:
```yaml
name: "Technology Name"
version: "version+"
type: backend|frontend|database|devops
languages:
  - Language1
  - Language2
dependencies: []
related:
  - related-tech-1
  - related-tech-2
piv_support: full|partial
rules_count: N
examples_count: N
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
├── methodology/
├── extending/
└── examples/
```

Follow existing documentation structure and style.

#### Adding Examples
Add to `docs/examples/`:
```markdown
# Example: [Title]

## Overview
[Brief description]

## Tech Stack
[List technologies]

## Implementation
[Step-by-step guide]

## PIV Workflow
[How PIV methodology was used]

## Lessons Learned
[What you learned]
```

### Adding Universal Rules

Add to `.claude/rules/`:
- Use numeric prefix (00-99)
- Follow existing rule structure
- Test with multiple technologies
- Document rationale

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
- [ ] Technology addition
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

## Checklist
- [ ] Code follows project conventions
- [ ] Documentation updated
- [ ] Examples tested
- [ ] No breaking changes (or documented if intentional)
```

---

## Code Style

### Markdown
- Use proper markdown formatting
- Include tables for comparisons
- Use code blocks with language tags
- Add descriptive headers

### YAML
- Use 2-space indentation
- Quote strings when necessary
- Add comments for clarity

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

### Timeline
- Review typically within 1-3 days
- Complex changes may take longer
- Feel free to bump with a friendly reminder

---

## Questions?

### Where to Ask

1. **GitHub Discussions** - General questions, ideas
2. **GitHub Issues** - Bugs, feature requests
3. **Pull Request** - Questions about specific PR

### Getting Help

- Read existing documentation first
- Search for similar issues/PRs
- Be specific in your questions
- Provide context and examples

---

## Recognition

Contributors will be:
- Listed in CONTRIBUTORS.md
- Credited in release notes
- Thanked in relevant documentation

---

## License

By contributing, you agree that your contributions will be licensed under the MIT License.

---

## Code of Conduct

### Our Pledge

We pledge to make participation in our project a harassment-free experience.

### Our Standards

**Positive behavior**:
- Using welcoming and inclusive language
- Being respectful of differing viewpoints
- Gracefully accepting constructive criticism
- Focusing on what is best for the community

**Unacceptable behavior**:
- Use of sexualized language or imagery
- Personal attacks or insults
- Trolling or disrespectful comments
- Public or private harassment

### Responsibility

Project maintainers are responsible for clarifying standards and taking appropriate action.

---

## Summary

Thank you for contributing! Key points:

1. **Fork** the repository
2. **BRANCH** for your work
3. **FOLLOW** conventions
4. **TEST** your changes
5. **DOCUMENT** clearly
6. **SUBMIT** PR with clear description

We look forward to your contributions!

---

**Need help?** Open an issue or start a discussion. We're here to help!

**Want to learn more?** Check out the [documentation](docs/).
