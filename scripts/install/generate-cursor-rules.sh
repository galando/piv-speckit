#!/bin/bash
# generate-cursor-rules.sh - Generate Cursor auto-attach rules
# These are equivalent to Claude Code skills but for Cursor
# Uses Cursor-specific tool names for better AI compliance

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

## Workflow Rules

- **ONE file** at a time → modify → test → commit → then next
- **ONE task** at a time → complete → verify → then next
- **NEVER** batch multiple files or changes together
- **ASK** before starting: "Should I break this into smaller tasks?"

## Core Principles

- **Understand first**: Use \`Read\` tool on existing code before modifying
- **Match patterns**: Follow existing codebase conventions
- **Minimal changes**: Only change what's necessary
- **Self-documenting**: Clear names over comments

## DRY & KISS

- Check for existing implementations before creating new
- Prefer simple over clever solutions
- Single source of truth for each piece of knowledge

## When Completing Work

**ASK**: "Shall I commit this change?"

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

## The Cycle (SEQUENTIAL - NO EXCEPTIONS)

| Phase | Action | Tool | Verify |
|-------|--------|------|--------|
| 🔴 RED | Write failing test | \`Write\` / \`StrReplace\` | Run \`Shell\` → see failure |
| 🟢 GREEN | Write minimal implementation | \`Write\` / \`StrReplace\` | Run \`Shell\` → see pass |
| 🔵 REFACTOR | Improve code | \`Write\` / \`StrReplace\` | Run \`Shell\` → still passes |

## Critical Rules

- ❌ **NEVER** write test and implementation in the same tool call
- ❌ **NEVER** skip running tests between phases
- ❌ **NEVER** create multiple files at once
- ✅ **ALWAYS** use \`Shell\` tool to run tests (e.g., \`npm test\`)
- ✅ **ALWAYS** use \`Read\` tool to check \`package.json\` for test command first
- ✅ **ALWAYS** verify test output before proceeding to next phase

## Checkpoints (ASK user before proceeding)

- After RED: "Test fails as expected. Proceed to GREEN phase?"
- After GREEN: "Test passes. Refactor or move to next test?"

## Test Structure (Given-When-Then)

\`\`\`javascript
// GIVEN: Setup test data and preconditions
const input = { name: "Test", email: "test@example.com" };

// WHEN: Execute the code being tested
const result = await service.create(input);

// THEN: Verify expected outcomes
expect(result.id).toBeDefined();
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

## Workflow

1. **Write API test FIRST** (TDD applies to APIs too)
2. **Define request/response contract** before implementing
3. **Implement ONE endpoint** → test → confirm → then next

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

## HTTP Status Codes

| Code | Use Case |
|------|----------|
| 200 | Success (GET, PUT, PATCH) |
| 201 | Created (POST) |
| 400 | Bad Request (validation) |
| 401 | Unauthorized |
| 404 | Not Found |
| 500 | Server Error |

## Best Practices

- Validate all input (body, params, query)
- Version your API (\`/v1/users\`)
- Implement rate limiting on public endpoints

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

Validate EVERYTHING: form submissions, API requests, file uploads, URL params, webhooks.

## Input Validation

- ✅ Validate structure, type, format, length, range
- ✅ Sanitize data before use
- ✅ Use parameterized queries (prevent SQL injection)
- ✅ Escape output (prevent XSS)

## Authentication & Passwords

\`\`\`javascript
// ❌ FORBIDDEN - Never use for passwords
MD5, SHA1, SHA256, SHA512

// ✅ REQUIRED - Use password hashing
bcrypt, argon2, scrypt
\`\`\`

- Strong JWT secrets (256+ bits)
- Token expiration ≤1 hour
- Implement rate limiting on auth endpoints

## Data Protection

- ✅ HTTPS in production
- ✅ Encrypt sensitive data at rest
- ✅ Environment variables for secrets
- ❌ NEVER commit secrets to git
- ❌ NEVER log sensitive data

<!-- PIV v${version} -->
EOF

    echo "Generated: $rules_dir/"
    ls -la "$rules_dir/"
}

# Allow sourcing or direct execution
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    generate_cursor_rules "$@"
fi
