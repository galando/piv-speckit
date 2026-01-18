---
description: Enforces security best practices when handling authentication, user data, and sensitive information
triggers:
  - file_pattern: "*Auth*.java"
    when: "handling authentication", "processing user input", "working with sensitive data"
  - file_pattern: "*Auth*.ts"
    when: "handling authentication", "processing user input", "working with sensitive data"
  - file_pattern: "*User*.java"
    when: "handling authentication", "processing user input", "working with sensitive data"
  - file_pattern: "*User*.ts"
    when: "handling authentication", "processing user input", "working with sensitive data"
  - file_pattern: "*Security*.java"
    when: "handling authentication", "processing user input", "working with sensitive data"
---

# Security Skill

## Activation

This skill activates when:
- Handling authentication/authorization
- Processing user input
- Working with sensitive data (passwords, tokens, PII)
- Managing user accounts
- Implementing security controls

**File patterns:**
- `*Auth*.java`, `*Auth*.ts` - Authentication/authorization
- `*User*.java`, `*User*.ts` - User management
- `*Security*.java` - Security configuration

## Enforcement

**🔒 SECURITY BEST PRACTICES ENFORCEMENT:**

### 1. Input Validation (ALL User Inputs)

**🚨 NEVER trust user input**

Validate ALL input at system boundaries:

```java
@PostMapping("/users")
public ResponseEntity<?> createUser(@RequestBody @Valid CreateUserRequestDTO dto) {
  // Validation annotations on DTO:
  // - @NotBlank, @Size, @Email, @Pattern, etc.
}
```

**Required validations:**
- [ ] Required fields present
- [ ] Data type correct
- [ ] Format valid (email, URL, etc.)
- [ ] Length constraints (min/max)
- [ ] Value range constraints
- [ ] Sanitized (remove dangerous content)

### 2. SQL Injection Prevention

**🚨 ALWAYS use parameterized queries**

**❌ VULNERABLE:**
```java
String query = "SELECT * FROM users WHERE id = '" + userId + "'"; // SQL INJECTION!
```

**✅ SECURE:**
```java
// Parameterized query
String query = "SELECT * FROM users WHERE id = ?";
User user = jdbcTemplate.queryForObject(query, User.class, userId);

// OR: JPA Repository
@Query("SELECT u FROM User u WHERE u.id = :id")
User findById(@Param("id") Long id);
```

**✅ SECURE:**
```java
// Spring Data JPA (auto-parameterized)
public interface UserRepository extends JpaRepository<User, Long> {
  Optional<User> findById(Long id); // Safe!
}
```

**Rules:**
- ✅ ALWAYS use parameterized queries
- ✅ Use ORM/JPA repositories when possible
- ❌ NEVER concatenate user input into SQL
- ❌ NEVER use string formatting for queries

### 3. XSS Prevention

**🚨 Sanitize and escape user input**

**❌ VULNERABLE:**
```java
@GetMapping("/search")
public String search(@RequestParam String q) {
  return "<div>Results for: " + q + "</div>"; // XSS!
}
```

**✅ SECURE:**
```java
@GetMapping("/search")
public String search(@RequestParam String q) {
  String sanitized = HtmlUtils.htmlEscape(q); // Escape HTML
  return "<div>Results for: " + sanitized + "</div>";
}
```

**✅ BETTER:**
```java
// Use template engines that auto-escape
@GetMapping("/users/{id}")
public String showUser(@PathVariable Long id, Model model) {
  model.addAttribute("user", userService.findById(id));
  return "user/profile"; // Thymeleaf auto-escapes
}
```

**Rules:**
- ✅ Escape output before rendering
- ✅ Use Content-Security-Policy headers
- ✅ Use frameworks that auto-escape (React, Thymeleaf, etc.)
- ❌ NEVER render untrusted user input directly

### 4. CSRF Protection

**🚨 Protect state-changing operations**

```java
@Configuration
@EnableWebSecurity
public class SecurityConfig {

  @Bean
  public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
    http
      .csrf(csrf -> csrf
        .csrfTokenRepository(CookieCsrfTokenRepository.withHttpOnlyFalse())
      );
    return http.build();
  }
}
```

**For state-changing operations:**
- POST, PUT, DELETE, PATCH must have CSRF token
- GET operations (safe/read-only) don't need CSRF

**For API clients (e.g., React/Spring):**
```java
http
  .csrf(csrf -> csrf
    .csrfTokenRepository(CsrfTokenRepository.withHttpOnlyFalse())
    .ignoringRequestMatchers("/api/**") // APIs use token auth instead
  );
```

### 5. Password Storage

**🚨 NEVER store plain text passwords**

**❌ INSECURE:**
```java
// Plain text - TERRIBLE
public void saveUser(String username, String password) {
  user.setPassword(password); // BAD!
  repository.save(user);
}

// Weak hashing - BAD
public void saveUser(String username, String password) {
  user.setPassword(md5(password)); // MD5 is broken
  repository.save(user);
}
```

**✅ SECURE:**
```java
// Strong hashing with bcrypt
public void saveUser(String username, String password) {
  String hashed = BCrypt.hashpw(password, BCrypt.gensalt(12));
  user.setPassword(hashed);
  repository.save(user);
}

// Or use Spring Security
public void saveUser(String username, String password) {
  user.setPassword(passwordEncoder.encode(password)); // Uses bcrypt
  repository.save(user);
}
```

**Password rules:**
- ✅ Use bcrypt, scrypt, or Argon2
- ✅ Minimum 12 rounds for bcrypt
- ✅ Unique salt per password (built into bcrypt)
- ❌ NEVER MD5, SHA1, SHA256 for passwords
- ❌ NEVER plain text
- ❌ NEVER reversible encryption

### 6. Secrets Management

**🚨 NEVER commit secrets to git**

**❌ WRONG:**
```java
// application.properties
database.password=MySecretPassword123 // BAD! Committed to git
api.key=sk_live_abc123xyz789 // BAD! API key in code

@Value("${api.key}")
private String apiKey; // Don't commit secrets!
```

**✅ CORRECT:**
```java
// application.properties (committed)
database.password=${DB_PASSWORD} // From environment
api.key=${API_KEY} // From environment

// application-local.properties (NOT committed)
DB_PASSWORD=MySecretPassword123
API_KEY=sk_live_abc123xyz789

// .gitignore
application-local.properties
.env
*.key
*.pem
secrets/
```

**Environment variables:**
```bash
# Set environment variables
export DB_PASSWORD="MySecretPassword123"
export API_KEY="sk_live_abc123xyz789"

# Use in application
@Value("${DB_PASSWORD}")
private String dbPassword;
```

**Secrets best practices:**
- ✅ Use environment variables for secrets
- ✅ Never commit secrets to git
- ✅ Use secret management (AWS Secrets Manager, HashiCorp Vault)
- ✅ Rotate secrets regularly
- ✅ Different secrets for dev/staging/prod

### 7. JWT Security

**✅ Secure JWT configuration:**

```java
@Service
public class TokenService {

  private static final String SECRET = "your-256-bit-secret-key-here"; // 256+ bits!
  private static final long EXPIRATION = 3600000; // 1 hour

  public String generateToken(User user) {
    return Jwts.builder()
      .setSubject(user.getId().toString())
      .claim("role", user.getRole())
      .setIssuedAt(new Date())
      .setExpiration(new Date(System.currentTimeMillis() + EXPIRATION))
      .signWith(SignatureAlgorithm.HS256, SECRET)
      .compact();
  }

  public Claims validateToken(String token) {
    try {
      return Jwts.parserBuilder()
        .setSigningKey(SECRET)
        .build()
        .parseClaimsJws(token)
        .getBody();
    } catch (JwtException e) {
      throw new AuthenticationException("Invalid token");
    }
  }
}
```

**JWT best practices:**
- ✅ Strong secret key (256+ bits)
- ✅ Short expiration (1 hour or less)
- ✅ Refresh token rotation
- ✅ Validate all claims (exp, iss, aud)
- ✅ HTTPS only (never HTTP)
- ✅ Secure storage (HttpOnly cookies)

### 8. Authentication/Authorization

**✅ Proper auth checks:**

```java
@RestController
@RequestMapping("/api/users")
public class UserController {

  // Public endpoint (no auth required)
  @PostMapping("/register")
  public ResponseEntity<?> register(@RequestBody @Valid RegisterDTO dto) {
    // Anyone can register
    userService.register(dto);
    return ResponseEntity.ok().build();
  }

  // Protected endpoint (authentication required)
  @GetMapping("/me")
  @PreAuthorize("isAuthenticated()")
  public ResponseEntity<?> getCurrentUser(@AuthenticationPrincipal UserPrincipal principal) {
    // Only authenticated users
    return ResponseEntity.ok(principal.getUser());
  }

  // Admin-only endpoint
  @DeleteMapping("/{id}")
  @PreAuthorize("hasRole('ADMIN')")
  public ResponseEntity<?> deleteUser(@PathVariable Long id) {
    // Only admins can delete
    userService.delete(id);
    return ResponseEntity.noContent().build();
  }

  // Resource ownership check
  @PatchMapping("/{id}")
  @PreAuthorize("isAuthenticated()")
  public ResponseEntity<?> updateUser(
    @PathVariable Long id,
    @RequestBody @Valid UpdateUserDTO dto,
    @AuthenticationPrincipal UserPrincipal principal
  ) {
    // Only update own account (unless admin)
    if (!principal.isAdmin() && !principal.getId().equals(id)) {
      throw new ForbiddenException("Access denied");
    }
    userService.update(id, dto);
    return ResponseEntity.ok().build();
  }
}
```

**Authorization rules:**
- ✅ Check authentication on protected endpoints
- ✅ Check authorization (roles/permissions)
- ✅ Verify resource ownership for non-admins
- ✅ Use method-level security (@PreAuthorize)
- ✅ Fail closed (deny by default)

### 9. Sensitive Data Logging

**🚨 NEVER log sensitive data**

**❌ WRONG:**
```java
logger.info("User login: {}", user); // Logs entire user object
logger.info("Password: {}", password); // Logs password!
logger.info("Token: {}", token); // Logs token!
```

**✅ CORRECT:**
```java
logger.info("User login: userId={}", user.getId()); // Safe
logger.info("Password reset requested for email={}", email); // Safe
logger.debug("Token validated for userId={}", userId); // Safe (don't log token)
```

**What NOT to log:**
- ❌ Passwords (ever)
- ❌ API keys/tokens
- ❌ Credit card numbers
- ❌ SSN/tax IDs
- ❌ Session IDs
- ❌ Full request bodies (may contain sensitive data)

**What TO log:**
- ✅ User IDs (not usernames/emails)
- ✅ Action performed
- ✅ Success/failure status
- ✅ Timestamp
- ✅ IP address (for audit)

## Behavior

When this skill activates:

### 1. Review Input Validation

Check for input validation:
- All user inputs validated? ✅
- Sanitization applied? ✅
- Type checking enforced? ✅

If validation missing:
```
⚠️ INPUT VALIDATION MISSING

User input is not validated.

Add validation:
1. Use @Valid on request body
2. Add validation annotations
3. Sanitize dangerous content

Example:
  @PostMapping("/users")
  public ResponseEntity<?> create(@RequestBody @Valid CreateUserDTO dto) {
    // ...
  }
```

### 2. Review SQL Query Safety

Check for SQL injection vulnerabilities:
- Parameterized queries used? ✅
- ORM/JPA used? ✅
- No string concatenation? ✅

If SQL injection risk:
```
🚨 SQL INJECTION RISK

Query concatenates user input directly.

Vulnerability: Attacker can inject malicious SQL
Fix: Use parameterized queries

Example:
  // BAD
  "SELECT * FROM users WHERE id = '" + id + "'"

  // GOOD
  "SELECT * FROM users WHERE id = ?"
```

### 3. Review XSS Prevention

Check for XSS vulnerabilities:
- Output escaped? ✅
- Content-Security-Policy set? ✅
- Framework auto-escaping used? ✅

If XSS risk:
```
⚠️ XSS VULNERABILITY

User input rendered without escaping.

Vulnerability: Attacker can inject malicious scripts
Fix: Escape output, use CSP headers

Example:
  // BAD
  return "<div>" + userInput + "</div>";

  // GOOD
  return "<div>" + HtmlUtils.htmlEscape(userInput) + "</div>";
```

### 4. Review Password Handling

Check password handling:
- Strong hashing used? ✅
- NOT plain text? ✅
- NOT weak algorithms? ✅

If insecure password handling:
```
🚨 INSECURE PASSWORD STORAGE

Password stored insecurely.

Risk: Passwords exposed in data breach
Fix: Use bcrypt/scrypt/Argon2

Example:
  // BAD
  user.setPassword(password);

  // GOOD
  user.setPassword(BCrypt.hashpw(password, BCrypt.gensalt(12)));
```

### 5. Review Secrets Management

Check for committed secrets:
- API keys in code? ❌
- Passwords in code? ❌
- Secrets in git history? ❌

If secrets exposed:
```
🚨 SECRETS EXPOSED

Sensitive data committed to code.

Risk: Credentials compromised
Fix: Use environment variables, rotate secrets

Action:
1. Remove secrets from code immediately
2. Rotate all exposed credentials
3. Use environment variables
4. Add secrets to .gitignore
```

### 6. Review Sensitive Data Logging

Check for sensitive data in logs:
- Passwords logged? ❌
- Tokens logged? ❌
- PII logged? ❌

If sensitive data logged:
```
⚠️ SENSITIVE DATA LOGGED

Logs contain sensitive information.

Risk: Logs expose credentials/PII
Fix: Remove sensitive data from logs

Example:
  // BAD
  logger.info("User: {}", user); // Logs everything

  // GOOD
  logger.info("User ID: {}", user.getId()); // Logs only ID
```

## Checklist

Before completing security-related code:

- [ ] ALL input validated and sanitized
- [ ] SQL injection prevented (parameterized queries)
- [ ] XSS prevented (output escaping)
- [ ] CSRF protection enabled (state-changing ops)
- [ ] Passwords hashed with bcrypt/scrypt/Argon2
- [ ] Secrets NOT in code (use env vars)
- [ ] JWT properly configured (strong secret, short expiry)
- [ ] Authentication/authorization checks in place
- [ ] Sensitive data NOT logged
- [ ] HTTPS enforced in production

**If any checklist item fails:**
- **FIX** security issue
- **THEN** consider it complete

## Resources

**See Also:**
- `.claude/rules/40-security.md` - Comprehensive security rules
- [OWASP Top 10](https://owasp.org/www-project-top-ten/)
- [OWASP Cheat Sheet Series](https://cheatsheetseries.owasp.org/)

**Learn More:**
- [OWASP SQL Injection](https://owasp.org/www-community/attacks/SQL_Injection)
- [OWASP XSS Prevention](https://owasp.org/www-community/attacks/xss/)
- [Spring Security Reference](https://docs.spring.io/spring-security/reference/)
