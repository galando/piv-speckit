# Documentation Rules

**Guidelines for writing and maintaining documentation**

---

## Documentation Philosophy

### Core Principles
1. **Document as You Code** - Update docs when code changes
2. **Document the Why, Not the What** - Code shows what, docs explain why
3. **Keep Docs Current** - Outdated docs are worse than no docs
4. **Write for Future You** - You'll forget context in 6 months
5. **Be Concise** - Respect the reader's time

### What to Document
✅ **Document**:
- Complex algorithms (why this approach)
- Non-obvious decisions (trade-offs considered)
- API contracts (inputs, outputs, side effects)
- Configuration (options, environment variables)
- Setup instructions (how to run the project)
- Architecture (system design, data flow)

❌ **Don't Document**:
- Obvious code (what the code does is clear)
- Implementation details that change frequently
- Outdated information
- Information that's already in code (types, names)

---

## Code Comments

### When to Use Comments

#### ✅ Good Use Cases
```javascript
// GOOD: Explains why, not what
// Using exponential backoff to avoid overwhelming the API
// during rate limit errors (max 5 retries)
await retryWithBackoff(apiCall, { maxRetries: 5 });

// GOOD: Documents non-obvious behavior
// This function mutates the input array (by design)
// Use copyArray() if you need immutability
function sortInPlace(arr) { ... }

// GOOD: Explains workaround
// TODO: Remove this workaround when upgrading to v2.0
// See: https://github.com/lib/lib/issues/123
```

#### ❌ Bad Use Cases
```javascript
// BAD: Obvious
// Increment the counter
i++;  // Don't do this

// BAD: Restates the code
// Check if user is logged in
if (user.isLoggedIn) { ... }  // Don't do this

// BAD: Outdated
// This function returns a string (actually returns Object now)
function getData() { ... }  // Don't do this
```

### Comment Style Guidelines
- **WRITE** complete sentences
- **USE** proper capitalization and punctuation
- **KEEP** comments brief and to the point
- **UPDATE** comments when code changes
- **AVOID** commented-out code (delete it instead)

---

## README Files

### Project README Structure
```markdown
# Project Name

> Brief description of what the project does

## Overview
[2-3 sentences explaining the project's purpose]

## Features
- Feature 1
- Feature 2
- Feature 3

## Tech Stack
- Language/Framework
- Database
- Other key technologies

## Prerequisites
- Requirement 1
- Requirement 2

## Installation
```bash
# Step-by-step installation instructions
```

## Usage
[Basic usage examples]

## Project Structure
[Brief directory structure explanation]

## Development
```bash
# How to run in development
npm run dev
```

## Testing
```bash
# How to run tests
npm test
```

## Contributing
[Link to CONTRIBUTING.md or brief guidelines]

## License
[License name and link]
```

### README Checklist
- [ ] Clear project name and description
- [ ] What the project does
- [ ] Why the project exists
- [ ] Installation instructions
- [ ] Usage examples
- [ ] Tech stack listed
- [ ] How to run tests
- [ ] How to contribute

---

## API Documentation

### Endpoint Documentation Template
```markdown
## GET /api/users

Retrieves a list of users with pagination support.

### Query Parameters

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| page | integer | No | Page number (default: 1) |
| limit | integer | No | Items per page (default: 20) |
| search | string | No | Search filter by name |

### Response

**Success (200 OK)**
```json
{
  "data": [
    {
      "id": "uuid",
      "name": "John Doe",
      "email": "john@example.com"
    }
  ],
  "pagination": {
    "page": 1,
    "limit": 20,
    "total": 100
  }
}
```

**Error (401 Unauthorized)**
```json
{
  "error": "Unauthorized",
  "message": "Invalid authentication token"
}
```

### Examples
```bash
curl -X GET "http://api.example.com/users?page=1&limit=10" \
  -H "Authorization: Bearer TOKEN"
```
```

### API Documentation Guidelines
- **INCLUDE** request/response examples
- **DOCUMENT** all parameters (required/optional)
- **LIST** possible error responses
- **PROVIDE** usage examples (curl, code)
- **KEEP** documentation up-to-date with API changes
- **USE** OpenAPI/Swagger for automated docs

---

## Inline Documentation

### Function Documentation
```javascript
/**
 * Calculates the total price with tax and discounts applied.
 *
 * @param {number} basePrice - The base price before adjustments
 * @param {number} taxRate - Tax rate as decimal (0.1 = 10%)
 * @param {number[]} discounts - Array of discount amounts to apply
 * @returns {number} Final price after all adjustments
 * @throws {Error} If basePrice or taxRate is negative
 *
 * @example
 * calculatePrice(100, 0.1, [10, 5]) // Returns 94.5
 */
function calculatePrice(basePrice, taxRate, discounts = []) {
  // Implementation...
}
```

### Class Documentation
```javascript
/**
 * Manages user authentication and session handling.
 *
 * Provides methods for user login, logout, token refresh,
 * and session validation.
 *
 * @example
 * const auth = new AuthService(apiClient);
 * await auth.login('user@example.com', 'password');
 */
class AuthService {
  // Implementation...
}
```

---

## Architecture Documentation

### System Architecture Diagram
```markdown
## Architecture Overview

```
┌─────────────┐      ┌─────────────┐      ┌─────────────┐
│   Client    │─────▶│   API       │─────▶│  Database   │
│  (React)    │      │  (Express)  │      │ (PostgreSQL)│
└─────────────┘      └─────────────┘      └─────────────┘
                           │
                           ├─────────────▶ ┌─────────────┐
                           │               │  External   │
                           └─────────────▶ │     API     │
                                          └─────────────┘
```

## Component Responsibilities

### Client (React)
- UI rendering
- User interaction
- State management
- API communication

### API (Express)
- Request validation
- Business logic
- Data transformation
- External API calls

### Database (PostgreSQL)
- Data persistence
- Transaction management
- Data integrity
```

### Data Flow Documentation
```markdown
## User Registration Flow

1. Client submits registration form
   ↓
2. API validates input (email format, password strength)
   ↓
3. API checks if user already exists
   ↓
4. API hashes password (bcrypt)
   ↓
5. API creates user record in database
   ↓
6. API generates JWT token
   ↓
7. API returns token to client
   ↓
8. Client stores token for future requests
```

---

## Contributing Guidelines

### CONTRIBUTING.md Structure
```markdown
# Contributing to [Project]

## How to Contribute
1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Write/update tests
5. Submit a pull request

## Development Setup
[Step-by-step setup guide]

## Code Style
[Link to style guide or key conventions]

## Commit Message Format
[Explain commit message conventions]

## Pull Request Process
[PR review process, requirements, etc.]

## Questions?
[Where to ask for help]
```

---

## Changelog

### CHANGELOG.md Format
```markdown
# Changelog

## [1.2.0] - 2025-01-08
### Added
- User authentication feature
- Password reset functionality
- Email notifications

### Changed
- Upgraded to Express v5
- Improved error handling

### Fixed
- Fixed memory leak in user service
- Resolved race condition in API

### Removed
- Deprecated old authentication method
```

---

## Documentation Anti-Patterns

### ❌ Outdated Documentation
```markdown
<!-- BAD: Outdated info -->
This project uses Python 2.7 (actually using 3.11)
```
**Fix**: Update docs when code changes

### ❌ Vague Instructions
```markdown
<!-- BAD: Not actionable -->
Install the dependencies and run the server
```
**Fix**:
```markdown
<!-- GOOD: Specific and actionable -->
npm install
npm run dev
```

### ❌ Over-Documenting
```javascript
// BAD: Commenting obvious code
// Set the user's name
user.name = "John";

// Add 1 to the counter
counter++;
```
**Fix**: Remove obvious comments

### ❌ Scattered Documentation
**Problem**: Docs in multiple places, hard to find
**Fix**: Centralize documentation, link from README

---

## Documentation Tools

### Recommended Tools
| Purpose | Tools |
|---------|-------|
| API Documentation | OpenAPI/Swagger, Postman |
| Code Documentation | JSDoc, Javadoc, Docstrings |
| Architecture Diagrams | Mermaid, Draw.io |
| Wiki/Docs Site | Docusaurus, GitBook, MkDocs |
| Changelog | Conventional Changelog |

---

## Best Practices Summary

1. **UPDATE** docs when code changes
2. **DOCUMENT** the why, not the what
3. **KEEP** docs concise and clear
4 **USE** examples and diagrams
5. **MAINTAIN** a consistent structure
6. **REMOVE** outdated information
7. **WRITE** for your future self

**Remember: Good documentation reduces confusion and speeds up onboarding.**

---

## Documentation Checklist

### Before Considering Documentation Complete
- [ ] README is clear and comprehensive
- [ ] Installation instructions work
- [ ] API documentation is current
- [ ] Architecture is documented
- [ ] Complex code has comments
- [ ] Contributing guidelines exist
- [ ] Changelog is maintained
- [ ] Examples are provided
