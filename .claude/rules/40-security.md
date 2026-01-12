# Security Rules

**Security best practices applicable to all projects**

---

## Core Security Principles

### The CIA Triad
1. **Confidentiality** - Protect sensitive data from unauthorized access
2. **Integrity** - Prevent unauthorized modification of data
3. **Availability** - Ensure systems are available when needed

### Security First Mindset
- **NEVER** trust user input
- **ALWAYS** validate at system boundaries
- **ASSUME** code will be attacked
- **PREPARE** for security incidents
- **LEAST** privilege principle (minimum required access)

---

## Input Validation

### Golden Rule
**Validate ALL input from untrusted sources:**
- User input (forms, API requests)
- File uploads
- URL parameters
- External API responses
- Database query results

### Validation Strategy
```javascript
// BAD: No validation
app.post('/users', (req, res) => {
  const user = req.body;
  db.save(user);  // Vulnerable!
});

// GOOD: Validate and sanitize
app.post('/users', (req, res) => {
  // Validate structure
  if (!req.body.name || !req.body.email) {
    return res.status(400).json({ error: 'Missing required fields' });
  }

  // Validate format
  if (!isValidEmail(req.body.email)) {
    return res.status(400).json({ error: 'Invalid email' });
  }

  // Sanitize input
  const user = {
    name: sanitize(req.body.name),
    email: req.body.email.toLowerCase()
  };

  db.save(user);
});
```

### Validation Checklist
- [ ] Required fields present
- [ ] Data type is correct
- [ ] Data format is valid (email, URL, etc.)
- [ ] Length constraints (min/max)
- [ ] Value range constraints
- [ ] Sanitized (remove dangerous content)

---

## SQL Injection Prevention

### The Problem
```javascript
// VULNERABLE: SQL Injection
const query = `SELECT * FROM users WHERE id = '${userId}'`;
// If userId = "1' OR '1'='1", returns all users!
```

### The Solution: Parameterized Queries
```javascript
// SECURE: Parameterized query
const query = 'SELECT * FROM users WHERE id = $1';
await db.query(query, [userId]);
```

### Rules
- ✅ **ALWAYS** use parameterized queries or prepared statements
- ✅ **USE** ORM/Query builder when possible
- ❌ **NEVER** concatenate user input into SQL queries
- ❌ **NEVER** use string formatting for queries

### Examples by Technology
```javascript
// Node.js (pg)
db.query('SELECT * FROM users WHERE id = $1', [userId]);

// Python (psycopg2)
cursor.execute('SELECT * FROM users WHERE id = %s', [userId]);

// Java (JDBC)
PreparedStatement stmt = conn.prepareStatement(
  'SELECT * FROM users WHERE id = ?'
);
stmt.setInt(1, userId);

// PHP (PDO)
$stmt = $pdo->prepare('SELECT * FROM users WHERE id = :id');
$stmt->execute(['id' => $userId]);
```

---

## Cross-Site Scripting (XSS) Prevention

### The Problem
```javascript
// VULNERABLE: XSS
app.get('/search', (req, res) => {
  const query = req.query.q;
  res.send(`Results for: ${query}`);  // Renders HTML!
});
```

### Solutions

#### 1. Output Encoding
```javascript
// SECURE: Encode output
const encoded = escapeHtml(query);
res.send(`Results for: ${encoded}`);
```

#### 2. Content Security Policy (CSP)
```javascript
// Set CSP header
res.setHeader('Content-Security-Policy',
  "default-src 'self'; " +
  "script-src 'self' 'unsafe-inline'; " +
  "style-src 'self' 'unsafe-inline'"
);
```

#### 3. Framework Protections
```javascript
// React auto-escapes
<div>{userInput}</div>  // Safe!

// Dangerous (only when absolutely necessary)
<div dangerouslySetInnerHTML={{__html: userInput}} />  // Unsafe!
```

### XSS Prevention Checklist
- [ ] Escape user input before rendering
- [ ] Set Content-Security-Policy headers
- [ ] Use framework auto-escaping (React, Vue, etc.)
- [ ] Sanitize HTML (if allowing rich text)
- [ ] Validate input on server side
- [ ] HTTPOnly flags on cookies (prevent JS access)

---

## Authentication & Authorization

### Password Storage
```javascript
// BAD: Plain text or weak hashing
db.save({ password: 'secret123' });  // Terrible!
db.save({ password: md5('secret123') });  // Weak!

// GOOD: Strong hashing with salt
const hash = await bcrypt.hash(password, 12);
db.save({ password: hash });
```

### Password Guidelines
- ✅ **USE** bcrypt, scrypt, or Argon2 (minimum 12 rounds)
- ✅ **USE** unique salt per password (built into bcrypt)
- ✅ **ENFORCE** strong password policies
- ❌ **NEVER** store plain text passwords
- ❌ **NEVER** use MD5, SHA1, or SHA256 for passwords
- ❌ **NEVER** roll your own crypto

### JWT Best Practices
```javascript
// GOOD: Secure JWT configuration
const token = jwt.sign(
  { userId: user.id, role: user.role },
  process.env.JWT_SECRET,  // Strong secret (256+ bits)
  {
    expiresIn: '1h',        // Short expiration
    issuer: 'myapp',
    audience: 'myapp-users'
  }
);
```

### JWT Security Checklist
- [ ] Use strong secret key (256+ bits)
- [ ] Set short expiration (1 hour or less)
- [ ] Implement refresh token rotation
- [ ] Validate all claims (exp, iss, aud)
- [ ] Use HTTPS only
- [ ] Store securely (HttpOnly cookies or secure storage)

### Authorization
```javascript
// GOOD: Role-based access control
function requireRole(role) {
  return (req, res, next) => {
    if (req.user.role !== role) {
      return res.status(403).json({ error: 'Forbidden' });
    }
    next();
  };
}

app.delete('/users/:id',
  authenticate,
  requireRole('admin'),  // Only admins can delete
  deleteUser
);
```

---

## API Security

### Rate Limiting
```javascript
// GOOD: Rate limit by user
import rateLimit from 'express-rate-limit';

const limiter = rateLimit({
  windowMs: 15 * 60 * 1000,  // 15 minutes
  max: 100,  // 100 requests per window
  keyGenerator: (req) => req.user.id  // Per user
});

app.use('/api/', limiter);
```

### API Security Checklist
- [ ] Rate limiting implemented
- [ ] Input validation on all endpoints
- [ ] Authentication required (except public endpoints)
- [ ] Authorization checks (user can only access their data)
- [ ] HTTPS only in production
- [ ] API keys/rotation for service-to-service
- [ ] Request ID tracing for audits
- [ ] Don't leak sensitive info in error messages

---

## Data Protection

### Sensitive Data Handling
```javascript
// BAD: Logging sensitive data
console.log('User login:', { email, password });

// GOOD: Don't log sensitive data
console.log('User login:', { email });

// BAD: Returning sensitive data in API
res.json({ user: { id, email, passwordHash } });

// GOOD: Exclude sensitive fields
const { passwordHash, ...safeUser } = user;
res.json({ user: safeUser });
```

### Encryption at Rest
- **Database**: Enable encryption (PostgreSQL, AWS RDS, etc.)
- **File Storage**: Encrypt sensitive files
- **Backups**: Encrypt backup files
- **Environment**: Use encrypted secrets (AWS KMS, etc.)

### Encryption in Transit
- ✅ **ALWAYS** use HTTPS in production
- ✅ **USE** TLS 1.2 or higher
- ✅ **ENABLE** HSTS (HTTP Strict Transport Security)
- ❌ **NEVER** use HTTP for sensitive data

### Environment Variables
```javascript
// .env (NEVER commit this!)
DATABASE_URL=postgresql://...
JWT_SECRET=your-secret-key
API_KEY=secret-api-key

// .env.example (Commit this!)
DATABASE_URL=postgresql://...
JWT_SECRET=your-secret-key-here
API_KEY=your-api-key-here
```

### Secrets Management
- ✅ **USE** environment variables for secrets
- ✅ **NEVER** commit secrets to git
- ✅ **USE** secret management (AWS Secrets Manager, HashiCorp Vault)
- ✅ **ROTATE** secrets regularly
- ✅ **DIFFERENT** secrets for dev/staging/prod

---

## Cross-Site Request Forgery (CSRF)

### The Problem
User's browser makes authenticated requests to malicious site.

### Solutions

#### 1. CSRF Tokens
```javascript
// GOOD: CSRF tokens
const csrf = require('csurf');
const csrfProtection = csrf({ cookie: true });

app.get('/form', csrfProtection, (req, res) => {
  res.render('form', { csrfToken: req.csrfToken() });
});

app.post('/form', csrfProtection, (req, res) => {
  // Token validated automatically
});
```

#### 2. SameSite Cookies
```javascript
// GOOD: SameSite cookie attribute
session({
  cookie: {
    sameSite: 'strict',  // or 'lax'
    secure: true  // HTTPS only
  }
});
```

### CSRF Prevention Checklist
- [ ] CSRF tokens on state-changing requests
- [ ] SameSite cookie attribute
- [ ] Validate Origin/Referer headers
- [ ] Use custom headers for AJAX (X-Requested-With)

---

## Security Headers

### Essential Headers
```javascript
// GOOD: Security headers
app.use((req, res, next) => {
  // Prevent clickjacking
  res.setHeader('X-Frame-Options', 'DENY');

  // Prevent MIME sniffing
  res.setHeader('X-Content-Type-Options', 'nosniff');

  // Enable XSS filter
  res.setHeader('X-XSS-Protection', '1; mode=block');

  // Content Security Policy
  res.setHeader('Content-Security-Policy',
    "default-src 'self'; " +
    "script-src 'self' 'unsafe-inline'; " +
    "style-src 'self' 'unsafe-inline'"
  );

  // Strict Transport Security (HTTPS only)
  res.setHeader('Strict-Transport-Security',
    'max-age=31536000; includeSubDomains'
  );

  next();
});
```

---

## Dependency Security

### Vulnerability Scanning
```bash
# Check for vulnerabilities
npm audit
# or
yarn audit
# or
safety check  # Python
```

### Dependency Management
- **UPDATE** dependencies regularly
- **USE** `npm audit` or similar tools
- **PIN** dependency versions
- **REVIEW** security advisories
- **REMOVE** unused dependencies

---

## Error Handling

### Secure Error Messages
```javascript
// BAD: Leaks sensitive information
app.use((err, req, res, next) => {
  res.status(500).json({
    error: err.message,  // Leaks implementation details
    stack: err.stack  // Leaks file paths
  });
});

// GOOD: Generic error message
app.use((err, req, res, next) => {
  console.error('Error:', err);  // Log detailed error

  res.status(500).json({
    error: 'Internal server error'
  });
});
```

### Error Handling Rules
- ✅ **LOG** detailed errors server-side
- ✅ **RETURN** generic messages to clients
- ✅ **INCLUDE** error ID for support
- ❌ **NEVER** leak stack traces to clients
- ❌ **NEVER** expose file paths
- ❌ **NEVER** reveal database queries

---

## Logging & Monitoring

### Security Events to Log
- Failed authentication attempts
- Authorization failures
- Suspicious API requests
- Rate limit violations
- Data access by privileged users
- Configuration changes

### Log Security
```javascript
// GOOD: Security logging
logger.info('User login', {
  userId: user.id,
  ip: req.ip,
  userAgent: req.headers['user-agent'],
  timestamp: new Date()
});

// BAD: Logging sensitive data
logger.info('User login', {
  userId: user.id,
  password: user.password  // NEVER log passwords!
});
```

---

## Security Checklist

### Before Deployment
- [ ] Dependencies audited and updated
- [ ] Environment variables configured
- [ ] Secrets properly stored
- [ ] HTTPS/TLS configured
- [ ] Security headers set
- [ ] Rate limiting enabled
- [ ] Input validation on all inputs
- [ ] SQL injection prevention
- [ ] XSS prevention
- [ ] CSRF protection
- [ ] Authentication implemented
- [ ] Authorization checks
- [ ] Error handling secure
- [ ] Logging configured
- [ ] Security monitoring in place

---

## Summary

Security best practices:

1. **VALIDATE** all input
2. **SANITIZE** output
3. **ENCRYPT** sensitive data
4. **USE** parameterized queries
5. **IMPLEMENT** rate limiting
6. **SET** security headers
7. **LOG** security events
8. **UPDATE** dependencies
9. **PREPARE** for incidents
10. **ASSUME** you will be attacked

**Security is not a feature, it's a mindset.**

---

## Resources

- [OWASP Top 10](https://owasp.org/www-project-top-ten/)
- [OWASP Cheat Sheet Series](https://cheatsheetseries.owasp.org/)
- [CWE - Common Weakness Enumeration](https://cwe.mitre.org/)
- [Security Best Practices](https://github.com/FallibleInc/security-guide-for-developers)
