#!/bin/bash
# generate-cursor-rules.sh - Generate Cursor auto-attach rules
# These are equivalent to Claude Code skills but for Cursor

set -euo pipefail

generate_cursor_rules() {
    local target_dir="${1:-.}"
    local rules_dir="$target_dir/.cursor/rules"
    local script_dir
    local version

    # Get script directory (works when sourced or run directly)
    script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

    # Read version from VERSION file
    version=$(cat "$script_dir/../../VERSION" 2>/dev/null || echo "dev")

    mkdir -p "$rules_dir"

    # General rules (always apply)
    cat > "$rules_dir/piv-general.mdc" << EOF
---
description: PIV Framework core development rules
globs: []
alwaysApply: true
---

# PIV Development Rules

Follow these rules for all code in this project.

## Core Principles
- **Understand first**: Read existing code before modifying
- **Match patterns**: Follow existing codebase conventions
- **Minimal changes**: Only change what's necessary
- **Self-documenting**: Clear names over comments

## DRY & KISS
- Check for existing implementations before creating new
- Prefer simple over clever solutions
- Single source of truth for each piece of knowledge

<!-- PIV v${version} -->
EOF

    # TDD rules (auto-attach on test files)
    cat > "$rules_dir/piv-tdd.mdc" << EOF
---
description: PIV TDD enforcement for test files
globs: ["*.test.*", "*.spec.*", "__tests__/*", "test/*", "tests/*"]
alwaysApply: false
---

# TDD Requirements (MANDATORY)

**RED → GREEN → REFACTOR** - No exceptions.

## The Cycle
1. 🔴 **RED**: Write failing test FIRST - test MUST fail before any implementation
2. 🟢 **GREEN**: Write MINIMAL code to make test pass - no more, no less
3. 🔵 **REFACTOR**: Improve code while keeping tests green

## Rules
- ❌ NEVER write implementation code before the test
- ❌ NEVER skip TDD for "simple" code
- ✅ Test must fail with clear assertion error
- ✅ One logical assertion per test

## Test Structure (Given-When-Then)
\`\`\`
GIVEN: Setup test data and preconditions
WHEN:  Execute the code being tested
THEN:  Verify expected outcomes
\`\`\`

<!-- PIV v${version} -->
EOF

    # API design rules (auto-attach on controllers/routes)
    cat > "$rules_dir/piv-api.mdc" << EOF
---
description: PIV API design rules for controllers and routes
globs: ["*Controller*", "*Router*", "*Route*", "routes/*", "controllers/*", "*Handler*"]
alwaysApply: false
---

# API Design Rules

## RESTful Principles
- **Nouns over verbs**: \`/users\` not \`/getUsers\`
- **Plural nouns**: \`/users\` not \`/user\`
- **HTTP verbs**: GET (read), POST (create), PUT (update), DELETE (remove)
- **Resource hierarchy**: \`/users/{id}/posts\`

## Response Format
\`\`\`json
// Success
{ "data": {...}, "meta": {...} }

// Error
{ "error": "ErrorCode", "message": "Human-readable description" }
\`\`\`

## Best Practices
- Use proper HTTP status codes (200, 201, 400, 404, 500)
- Validate all input
- Version your API (\`/v1/users\`)
- Return consistent response structures

<!-- PIV v${version} -->
EOF

    # Security rules (auto-attach on auth files)
    cat > "$rules_dir/piv-security.mdc" << EOF
---
description: PIV security rules for authentication and security code
globs: ["*Auth*", "*Security*", "*Password*", "*Token*", "*Credential*", "*Session*"]
alwaysApply: false
---

# Security Rules

## Golden Rule
**NEVER trust user input.**

## Input Validation
- Validate structure, type, format, length, range
- Sanitize data before use
- Use parameterized queries (prevent SQL injection)
- Escape output (prevent XSS)

## Authentication & Passwords
- Use bcrypt/Argon2 (NEVER MD5/SHA for passwords)
- Strong JWT secrets (256+ bits)
- Token expiration ≤1 hour
- Implement rate limiting

## Data Protection
- HTTPS in production
- Encrypt sensitive data at rest
- Environment variables for secrets
- NEVER commit secrets to git

<!-- PIV v${version} -->
EOF

    echo "Generated: $rules_dir/"
    ls -la "$rules_dir/"
}

# Allow sourcing or direct execution
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    generate_cursor_rules "$@"
fi
