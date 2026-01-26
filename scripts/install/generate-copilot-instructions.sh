#!/bin/bash
# generate-copilot-instructions.sh - Generate .github/copilot-instructions.md
# For GitHub Copilot auto-loading of PIV methodology

set -euo pipefail

generate_copilot_instructions() {
    local target_dir="${1:-.}"
    local github_dir="$target_dir/.github"

    # Create .github directory if it doesn't exist
    mkdir -p "$github_dir"

    cat > "$github_dir/copilot-instructions.md" << EOF
# PIV Spec-Kit - GitHub Copilot Instructions

> **PIV Methodology**: Prime → Implement → Validate for AI-assisted development

---

## 🚨 MANDATORY: TDD Workflow

**ALL code must follow RED → GREEN → REFACTOR.**

1. **RED**: Write failing test FIRST - show user it fails
2. **GREEN**: Write MINIMAL code to pass - no more
3. **REFACTOR**: Improve while tests stay green

**NEVER write implementation before test.** If asked to implement feature, start with test.

---

## 🛑 One Feature at a Time

- **ONE file** at a time → modify → ask user to test
- **ONE test** at a time → verify → then next
- **NEVER** create multiple files simultaneously
- **NEVER** batch similar changes

**After each change**: Ask "Shall I continue or commit this?"

---

## Core Principles

### Understand First
- Read existing code before modifying
- Match existing patterns and conventions
- Ask if unclear

### DRY & KISS
- Check for existing implementations before creating new
- Prefer simple over clever solutions
- Single source of truth

### Code Style
- Clear names over comments
- Self-documenting code
- Follow project conventions

---

## Testing (Given-When-Then)

\`\`\`
GIVEN: Setup test data and preconditions
WHEN:  Execute the code being tested
THEN:  Verify expected outcomes
\`\`\`

- Descriptive test names
- Independent tests
- Mock external dependencies
- 80%+ coverage goal

---

## Security Rules

**Golden Rule**: NEVER trust user input

- Validate: structure, type, format, length, range
- Use parameterized queries (SQL injection prevention)
- Use bcrypt/Argon2 for passwords (NOT MD5/SHA)
- Environment variables for secrets
- HTTPS in production

---

## Git Workflow

**Branch naming**: \`feature/\`, \`fix/\`, \`docs/\`

**Commits**: Conventional format
\`\`\`
type(scope): description

feat(auth): add JWT authentication
fix(api): resolve race condition
docs(readme): update installation
\`\`\`

---

## When User Asks to "Implement X"

**CORRECT approach:**
1. "What's the first test for this feature?"
2. Write ONE test
3. Show it fails, wait for confirmation
4. Write minimal code
5. Show it passes, wait for confirmation
6. "What's next?"

**WRONG approach:**
- Creating all files at once
- Writing implementation before tests
- "Here's the complete feature"

---

## For Complete Reference

See \`AGENTS.md\` in project root for full PIV methodology.

---

*PIV Spec-Kit - https://github.com/galando/piv-speckit*
EOF

    echo "Generated: $github_dir/copilot-instructions.md"
}

# Allow sourcing or direct execution
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    generate_copilot_instructions "$@"
fi
