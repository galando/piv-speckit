# Adding Technologies

**How to add new technology templates to the PIV skeleton**

---

## Overview

This guide explains how to extend the PIV skeleton with support for new technologies, frameworks, or tools.

---

## Understanding Technology Templates

Technology templates provide:
- **Rules** - Best practices and conventions
- **Reference** - Patterns and integration guides
- **Examples** - Working code examples
- **Documentation** - Setup and usage instructions

---

## Technology Template Structure

```
technologies/
├── [category]/
│   └── [technology-name]/
│       ├── README.md                    # Technology overview
│       ├── .claude/
│       │   └── rules/                   # Technology-specific rules
│       │   ├── 00-overview.md
│       │   ├── 10-setup.md
│       │   ├── 20-coding-standards.md
│       │   └── 30-testing.md
│       ├── reference/                   # Reference documentation
│       │   ├── patterns.md
│       │   └── integration.md
│       └── examples/                    # Code examples
│           ├── basic-example.md
│           └── advanced-example.md
```

### Directory Categories

- **backend/** - Server-side technologies
- **frontend/** - Client-side technologies
- **database/** - Databases and ORMs
- **devops/** - Infrastructure and deployment

---

## Step-by-Step Guide

### Step 1: Plan Your Technology Template

Before creating files, gather:

**Technology Information**:
- Official name and version
- Official documentation URL
- Common use cases
- Typical project structure

**PIV Integration Points**:
- What rules are needed?
- What patterns should be documented?
- What examples would be helpful?

**Related Technologies**:
- What does it integrate with?
- What are common companion tools?

### Step 2: Create Directory Structure

```bash
# Example: Adding Vue.js support
mkdir -p technologies/frontend/vue/.claude/rules
mkdir -p technologies/frontend/vue/reference
mkdir -p technologies/frontend/vue/examples
```

### Step 3: Create README.md

Create `technologies/[category]/[tech-name]/README.md`:

```markdown
# [Technology Name]

[Technology logo/badge]

## Overview
[Brief 2-3 sentence description of the technology]
[What it's used for]
[Why it's popular]

## Version Support
- **Minimum Version**: X.X.X
- **Tested With**: X.X.X
- **Status**: ✅ Stable | 🚧 Beta | ⚠️ Experimental

## Prerequisites
- [Requirement 1]
- [Requirement 2]

## Installation
\`\`\`bash
[Installation commands]
\`\`\`

## Project Structure
\`\`\`
[Typical project structure]
\`\`\`

## PIV Integration

### Rules Included
| Rule File | Purpose |
|-----------|---------|
| 00-overview.md | General guidelines |
| 10-setup.md | Setup and configuration |
| 20-coding-standards.md | Code style and conventions |
| 30-testing.md | Testing best practices |

### Auto-Loading Rules
Rules automatically load when:
- [File pattern that triggers loading]
- [File pattern that triggers loading]

## Examples
- [Example 1 description](examples/basic-example.md)
- [Example 2 description](examples/advanced-example.md)

## Reference Documentation
- [Design Patterns](reference/patterns.md)
- [PIV Integration](reference/integration.md)

## Common Patterns
### Pattern 1: [Pattern Name]
[Brief description]

### Pattern 2: [Pattern Name]
[Brief description]

## Troubleshooting
### Issue 1
[Solution]

### Issue 2
[Solution]

## Resources
- [Official Documentation](URL)
- [Community](URL)
- [Tutorials](URL)

## Contributing
How to contribute improvements to this technology template.

## License
[Technology license if applicable]
```

### Step 4: Create Rules

Create rule files in `.claude/rules/` with numeric prefix:

#### 00-overview.md
General overview and philosophy.

```markdown
# [Technology] Overview

## Core Principles
### Principle 1
[Description]

### Principle 2
[Description]

## Philosophy
[General philosophy and approach]

## When to Use [Technology]
✅ Good for:
- Use case 1
- Use case 2

❌ Avoid for:
- Use case 1
- Use case 2
```

#### 10-setup.md
Setup and configuration.

```markdown
# [Technology] Setup

## Initial Setup
\`\`\`bash
[Setup commands]
\`\`\`

## Configuration
\`\`\`[config format]
[Configuration example]
\`\`\`

## Environment Variables
| Variable | Purpose | Required |
|----------|---------|----------|
| VAR_NAME | Description | Yes/No |

## Dependencies
\`\`\`json
[package.json example]
\`\`\`

## Verification
\`\`\`bash
[Commands to verify setup]
\`\`\`
```

#### 20-coding-standards.md
Code style and conventions.

```markdown
# [Technology] Coding Standards

## Code Style
### Naming Conventions
- **Files**: [Convention]
- **Variables**: [Convention]
- **Classes/Components**: [Convention]
- **Constants**: [Convention]

### Formatting
- **Indentation**: [Tabs/Spaces and size]
- **Line Length**: [Maximum length]
- **Quotes**: [Single/Double]

### Code Organization
\`\`\`
[Example file structure]
\`\`\`

## Best Practices
### Practice 1
[Description with example]

### Practice 2
[Description with example]

## Anti-Patterns
### ❌ Anti-Pattern 1
[What to avoid]
✅ **Better**:
[Correct approach]

### ❌ Anti-Pattern 2
[What to avoid]
✅ **Better**:
[Correct approach]

## Common Patterns
### Pattern 1: [Name]
[Description and example]

### Pattern 2: [Name]
[Description and example]
```

#### 30-testing.md
Testing approach.

```markdown
# [Technology] Testing

## Testing Philosophy
[General testing approach]

## Test Structure
\`\`\`
[Directory structure]
\`\`\`

## Writing Tests
### Unit Tests
[Guidelines and examples]

### Integration Tests
[Guidelines and examples]

### E2E Tests
[Guidelines and examples]

## Test Coverage
- **Target**: [Percentage]%
- **Critical paths**: [Percentage]%

## Common Testing Patterns
### Pattern 1
[Example]

### Pattern 2
[Example]

## Tools
- [Testing tool 1]
- [Testing tool 2]

## Running Tests
\`\`\`bash
[Test commands]
\`\`\`
```

### Step 5: Create Reference Documentation

#### reference/patterns.md
```markdown
# [Technology] Design Patterns

## Pattern 1: [Pattern Name]
### Description
[What it is, when to use]

### Example
\`\`\`[language]
[Code example]
\`\`\`

### Pros & Cons
✅ **Pros**:
- Pro 1
- Pro 2

❌ **Cons**:
- Con 1
- Con 2

## Pattern 2: [Pattern Name]
[Same structure]
```

#### reference/integration.md
```markdown
# [Technology] PIV Integration

## How PIV Works with [Technology]

### Prime Phase
[What happens during prime]
- Context loaded from [locations]
- Rules activated for [file types]

### Implement Phase
[How implementation works]
- Plans generated based on [criteria]
- Code follows [patterns]

### Validate Phase
[How validation works]
- Tests run for [file types]
- Checks performed for [aspects]

## File Pattern Triggers
| Pattern | Rule Loaded | Purpose |
|---------|-------------|---------|
| `**/*.ext` | rule-file.md | [Purpose] |

## Example Workflow
\`\`\`bash
# Example PIV session
[Commands and outputs]
\`\`\`
```

### Step 6: Create Examples

#### examples/basic-example.md
```markdown
# Basic [Technology] Example

## Overview
[What this example demonstrates]

## Prerequisites
- [Prerequisite 1]
- [Prerequisite 2]

## Files Structure
\`\`\`
[File tree]
\`\`\`

## Implementation

### File 1: [filename]
\`\`\`[language]
[Code with explanation]
\`\`\`

### File 2: [filename]
\`\`\`[language]
[Code with explanation]
\`\`\`

## Running the Example
\`\`\`bash
[Commands to run]
\`\`\`

## Expected Output
\`\`\`
[What you should see]
\`\`\`

## PIV Workflow Used
1. **Prime**: [What was primed]
2. **Plan**: [What was planned]
3. **Execute**: [What was executed]
4. **Validate**: [What was validated]
```

#### examples/advanced-example.md
More complex example showing real-world usage.

### Step 7: Test Your Template

Before submitting:

1. **Test Directory Structure**
   ```bash
   # Verify structure
   find technologies/[category]/[tech-name] -type f
   ```

2. **Test Rule Loading**
   - Create a test project using the template
   - Run `/core_piv_loop:prime`
   - Verify rules load correctly

3. **Test Examples**
   - Follow example instructions
   - Verify code works
   - Test PIV workflow

4. **Review Documentation**
   - Check all links work
   - Verify clarity
   - Test with fresh eyes

---

## Technology Metadata (Optional)

Create `tech.yaml` for tooling support:

```yaml
name: "Technology Name"
version: "1.0.0+"
type: backend|frontend|database|devops
languages:
  - Language1
  - Language2
dependencies:
  - name: dependency1
    version: "x.x.x"
  - name: dependency2
    version: "x.x.x"
related:
  - related-tech-1
  - related-tech-2
piv_support: full|partial
rules_count: 4
examples_count: 2
official_docs: https://example.com/docs
community: https://example.com/community
```

---

## Submission Checklist

Before submitting your technology template:

- [ ] All required files created
- [ ] README.md is comprehensive
- [ ] Rules follow naming convention (NN-name.md)
- [ ] At least 2 rules files included
- [ ] Reference documentation complete
- [ ] At least 1 working example
- [ ] Examples tested successfully
- [ ] All links verified
- [ ] Code follows formatting standards
- [ ] PIV workflow tested
- [ ] Documentation is clear
- [ ] No typos or errors

---

## Example: Adding a Simple Technology

Here's a minimal example for adding "Express.js" support:

### Directory Structure
```bash
technologies/backend/node-express/
├── README.md
├── .claude/
│   └── rules/
│       ├── 00-overview.md
│       ├── 10-setup.md
│       └── 20-coding-standards.md
└── examples/
    └── basic-api.md
```

### 00-overview.md
```markdown
# Express.js Overview

## Core Principles
- Minimalism: Simple, unopinionated
- Middleware: Everything is middleware
- Routing: Simple, powerful routing

## When to Use Express
✅ Great for:
- REST APIs
- Simple web applications
- Microservices

❌ Avoid for:
- Complex applications (consider frameworks)
- Real-time (use Socket.io)
- GraphQL (use Apollo/Express)
```

### README.md
```markdown
# Express.js

Fast, unopinionated, minimalist web framework for Node.js

## Overview
Express is a minimal and flexible Node.js web application framework...

## PIV Integration
Rules auto-load for files matching: `**/*.js`, `**/*.ts`

## Examples
- [Basic REST API](examples/basic-api.md)
```

---

## Best Practices for Technology Templates

### 1. Be Specific
- Use concrete examples
- Provide actual code
- Show real errors and fixes

### 2. Be Comprehensive
- Cover common use cases
- Document edge cases
- Include troubleshooting

### 3. Be Practical
- Focus on real-world usage
- Avoid theoretical examples
- Show production patterns

### 4. Be Consistent
- Follow existing template structure
- Use consistent formatting
- Maintain naming conventions

### 5. Be Tested
- Test all examples
- Verify rule loading
- Check documentation links

---

## Resources for Template Authors

### Existing Templates
Review existing technology templates for reference:
- `technologies/backend/spring-boot/`
- `technologies/frontend/react/`
- `technologies/database/postgresql/`

### Rule Writing Guide
See [PIV Methodology](../../.claude/PIV-METHODOLOGY.md) for rule writing guidelines.

### Documentation Standards
Follow documentation best practices from `.claude/rules/30-documentation.md`.

---

## Need Help?

### Questions?
- Open an issue on [GitHub](https://github.com/galando/claude-piv-skeleton/issues)
- Start a [discussion](https://github.com/galando/claude-piv-skeleton/discussions)

### Template Review
Submit PR with your technology template. We'll review for:
- Completeness
- Accuracy
- Clarity
- PIV integration

---

## Summary

**Adding a Technology Template**:

1. **Plan** - Gather information
2. **Create** - Directory structure
3. **Document** - README and rules
4. **Reference** - Patterns and integration
5. **Example** - Working code
6. **Test** - Verify everything works
7. **Submit** - PR with checklist complete

**Time Investment**: 2-4 hours for comprehensive template

---

**Ready to contribute?** Create your technology template and submit a PR!
