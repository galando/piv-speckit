#!/bin/bash
# generate-cursor-rules.sh - Generate Cursor auto-attach rules
# These are equivalent to Claude Code skills but for Cursor
# Uses Cursor-specific tool names for better AI compliance

set -euo pipefail

generate_cursor_rules() {
    local target_dir="${1:-.}"
    local rules_dir="$target_dir/.cursor/rules"

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
describe('UserService', () => {
  it('should create user with valid input', async () => {
    // GIVEN: Setup test data
    const input = { name: 'Test User', email: 'test@example.com' };

    // WHEN: Execute the code
    const result = await userService.create(input);

    // THEN: Verify outcomes
    expect(result.id).toBeDefined();
    expect(result.name).toBe('Test User');
  });
});
\`\`\`
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
{ "data": {...}, "meta": { "page": 1, "total": 100 } }

// Error
{ "error": "ValidationError", "message": "Email is required" }
\`\`\`

## HTTP Methods & Status Codes

| Method | Purpose | Success Code |
|--------|---------|--------------|
| GET | Read resource | 200 |
| POST | Create resource | 201 |
| PUT | Update entire resource | 200 |
| PATCH | Partial update | 200 |
| DELETE | Remove resource | 204 |

| Error Code | Use Case |
|------------|----------|
| 400 | Bad Request (validation failed) |
| 401 | Unauthorized (not logged in) |
| 403 | Forbidden (no permission) |
| 404 | Not Found |
| 409 | Conflict (duplicate) |
| 500 | Server Error |

## Best Practices

- Validate all input (body, params, query)
- Version your API (\`/v1/users\`)
- Implement rate limiting on public endpoints
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

## SQL Injection Prevention

\`\`\`javascript
// ❌ VULNERABLE - Never concatenate user input
const query = \`SELECT * FROM users WHERE id = '\${userId}'\`;

// ✅ SECURE - Use parameterized queries
const query = 'SELECT * FROM users WHERE id = \$1';
await db.query(query, [userId]);
\`\`\`

## XSS Prevention

\`\`\`javascript
// ❌ VULNERABLE - Never insert raw user input
div.innerHTML = userInput;

// ✅ SECURE - Use textContent or framework escaping
div.textContent = userInput;
\`\`\`

## Authentication & Passwords

\`\`\`javascript
// ❌ FORBIDDEN - Never use for passwords
MD5, SHA1, SHA256, SHA512

// ✅ REQUIRED - Use password hashing (bcrypt example)
import bcrypt from 'bcrypt';
const hash = await bcrypt.hash(password, 10);
const match = await bcrypt.compare(password, hash);
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
EOF

    echo "Generated: $rules_dir/"
    ls -la "$rules_dir/"
}

# Allow sourcing or direct execution
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    generate_cursor_rules "$@"
fi
