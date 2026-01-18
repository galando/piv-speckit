# Security Rules

## Core Principles

**CIA Triad:**
- **Confidentiality** - Protect sensitive data
- **Integrity** - Prevent unauthorized modification
- **Availability** - Ensure systems are available

## Golden Rule

**NEVER trust user input.**

Validate ALL input from untrusted sources:
- User input (forms, API requests)
- File uploads
- URL parameters
- External API responses

## Input Validation

- ✅ Validate structure, type, format, length, range
- ✅ Sanitize data before use
- ❌ Never concatenate user input into queries

## SQL Injection Prevention

```javascript
// ❌ VULNERABLE
const query = `SELECT * FROM users WHERE id = '${userId}'`;

// ✅ SECURE
const query = 'SELECT * FROM users WHERE id = $1';
await db.query(query, [userId]);
```

## XSS Prevention

- ✅ Escape user input before rendering
- ✅ Set Content-Security-Policy headers
- ✅ Use framework auto-escaping (React, Vue)

## Authentication & Security

- ✅ Use bcrypt/scrypt/Argon2 for passwords
- ✅ Strong JWT secrets (256+ bits)
- ✅ Short token expiration (1 hour)
- ❌ NEVER store plain text passwords
- ❌ NEVER use MD5/SHA1/SHA256 for passwords

## Data Protection

- ✅ Use HTTPS in production
- ✅ Encrypt sensitive data at rest
- ✅ Use environment variables for secrets
- ❌ NEVER commit secrets to git

**For complete OWASP coverage:** `Read .claude/reference/rules-full/security-full.md`
