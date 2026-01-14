---
description: Enforces REST API best practices and proper endpoint design
triggers:
  - file_pattern: "*Controller.java"
    when: "creating API endpoint", "adding route", "designing API"
  - file_pattern: "*Router.ts"
    when: "creating API endpoint", "adding route", "designing API"
  - file_pattern: "api/*.ts"
    when: "creating API endpoint", "adding route", "designing API"
  - file_pattern: "routes/*.js"
    when: "creating API endpoint", "adding route", "designing API"
  - file_pattern: "*Controller.ts"
    when: "creating API endpoint", "adding route", "designing API"
---

# API Design Skill

## Activation

This skill activates when:
- Creating API endpoints
- Adding routes
- Designing API interfaces
- Modifying controller/router files

**File patterns:**
- Java: `*Controller.java`
- TypeScript/JavaScript: `*Router.ts`, `*Controller.ts`, `api/*.ts`, `routes/*.js`

## Enforcement

**🌐 REST API BEST PRACTICES ENFORCEMENT:**

### 1. Proper HTTP Methods

Use correct HTTP verbs for operations:

| Method | Purpose | Example |
|--------|---------|---------|
| `GET` | Retrieve resource | `GET /api/users/123` |
| `POST` | Create resource | `POST /api/users` |
| `PUT` | Update resource (full) | `PUT /api/users/123` |
| `PATCH` | Update resource (partial) | `PATCH /api/users/123` |
| `DELETE` | Delete resource | `DELETE /api/users/123` |

**❌ BAD: Wrong HTTP method**
```java
@PostMapping("/users/{id}") // BAD: POST for update
public User updateUser(@PathVariable Long id, @RequestBody User user) {
  // ...
}
```

**✅ GOOD: Correct HTTP method**
```java
@PutMapping("/users/{id}") // GOOD: PUT for update
public User updateUser(@PathVariable Long id, @RequestBody User user) {
  // ...
}
```

### 2. DTO Usage (NOT Entities)

**🚨 NEVER expose entities directly in API**

Always use DTOs (Data Transfer Objects) for API requests/responses.

**❌ BAD: Entity exposed**
```java
@PostMapping("/users")
public User createUser(@RequestBody User user) { // BAD: Entity
  return userRepository.save(user);
}
```

**✅ GOOD: DTO used**
```java
@PostMapping("/users")
public UserResponseDTO createUser(@RequestBody CreateUserRequestDTO dto) {
  User user = userService.create(dto);
  return UserResponseDTO.from(user);
}
```

**Why?**
- Entities expose internal database structure
- Entities can cause JPA/Hibernate lazy loading issues
- Entities may contain sensitive data (passwords, etc.)
- DTOs provide API versioning flexibility
- DTOs separate API layer from domain model

### 3. RESTful Endpoint Naming

Follow REST conventions for resource naming:

| Pattern | Example |
|---------|---------|
| `/api/resources` | `GET /api/users` (list all) |
| `/api/resources/{id}` | `GET /api/users/123` (get one) |
| `/api/resources?query` | `GET /api/users?email=john@example.com` (search) |
| Nested resources | `/api/users/123/orders` (user's orders) |

**❌ BAD: Non-RESTful naming**
```java
@GetMapping("/getAllUsers") // BAD: Verbs in URL
@GetMapping("/getUserById") // BAD: Verbs in URL
@PostMapping("/createUser") // BAD: "create" redundant with POST
```

**✅ GOOD: RESTful naming**
```java
@GetMapping("/users") // GOOD: Noun, plural
@GetMapping("/users/{id}") // GOOD: Resource by ID
@PostMapping("/users") // GOOD: POST implies creation
```

### 4. Proper Status Codes

Return appropriate HTTP status codes:

| Code | Meaning | Usage |
|------|---------|-------|
| 200 | OK | Successful GET, PUT, PATCH, DELETE |
| 201 | Created | Successful POST |
| 204 | No Content | Successful DELETE (no response body) |
| 400 | Bad Request | Invalid input |
| 401 | Unauthorized | Missing/invalid authentication |
| 403 | Forbidden | Valid auth but insufficient permissions |
| 404 | Not Found | Resource doesn't exist |
| 409 | Conflict | Resource conflict (duplicate) |
| 500 | Internal Server Error | Unexpected server error |

**❌ BAD: Always returns 200**
```java
@PostMapping("/users")
public ResponseEntity<User> createUser(@RequestBody User user) {
  User created = userService.create(user);
  return ResponseEntity.ok(created); // BAD: Should be 201 Created
}

@DeleteMapping("/users/{id}")
public ResponseEntity<Void> deleteUser(@PathVariable Long id) {
  userService.delete(id);
  return ResponseEntity.ok().build(); // BAD: Should be 204 No Content
}
```

**✅ GOOD: Correct status codes**
```java
@PostMapping("/users")
public ResponseEntity<UserResponseDTO> createUser(@RequestBody CreateUserRequestDTO dto) {
  User created = userService.create(dto);
  return ResponseEntity.status(HttpStatus.CREATED).body(UserResponseDTO.from(created));
}

@DeleteMapping("/users/{id}")
public ResponseEntity<Void> deleteUser(@PathVariable Long id) {
  userService.delete(id);
  return ResponseEntity.noContent().build();
}
```

### 5. Error Handling

All endpoints must handle errors gracefully:

**❌ BAD: No error handling**
```java
@GetMapping("/users/{id}")
public User getUser(@PathVariable Long id) {
  return userRepository.findById(id).get(); // BAD: Throws exception if not found
}
```

**✅ GOOD: Proper error handling**
```java
@GetMapping("/users/{id}")
public ResponseEntity<?> getUser(@PathVariable Long id) {
  return userRepository.findById(id)
    .map(user -> ResponseEntity.ok(UserResponseDTO.from(user)))
    .orElseThrow(() -> new NotFoundException("User not found")); // 404
}
```

**Error response format:**
```json
{
  "error": "Not Found",
  "message": "User not found with id: 123",
  "status": 404,
  "timestamp": "2025-01-14T10:30:00Z"
}
```

### 6. Input Validation

All input must be validated:

**✅ GOOD: Validation annotations**
```java
@PostMapping("/users")
public ResponseEntity<UserResponseDTO> createUser(
    @RequestBody @Valid CreateUserRequestDTO dto // @Valid triggers validation
) {
  // ...
}

public class CreateUserRequestDTO {
  @NotBlank(message = "Name is required")
  @Size(min = 2, max = 100, message = "Name must be between 2 and 100 characters")
  private String name;

  @NotBlank(message = "Email is required")
  @Email(message = "Email must be valid")
  private String email;

  @NotBlank(message = "Password is required")
  @Size(min = 8, message = "Password must be at least 8 characters")
  private String password;
}
```

**On validation failure:**
```java
@ExceptionHandler(MethodArgumentNotValidException.class)
public ResponseEntity<ErrorResponse> handleValidationException(
    MethodArgumentNotValidException ex
) {
  Map<String, String> errors = new HashMap<>();
  ex.getBindingResult().getFieldErrors().forEach(error ->
    errors.put(error.getField(), error.getDefaultMessage())
  );

  ErrorResponse response = new ErrorResponse(
    "Validation failed",
    errors,
    HttpStatus.BAD_REQUEST.value()
  );
  return ResponseEntity.badRequest().body(response);
}
```

### 7. Authentication/Authorization

Protected endpoints must have auth checks:

**✅ GOOD: Authorization checks**
```java
@GetMapping("/users/{id}")
@PreAuthorize("hasRole('USER')") // Requires authentication
public ResponseEntity<UserResponseDTO> getUser(
    @PathVariable Long id,
    @AuthenticationPrincipal UserPrincipal principal // Current user
) {
  // Only allow users to get their own data (unless admin)
  if (!principal.isAdmin() && !principal.getId().equals(id)) {
    throw new ForbiddenException("Access denied");
  }

  User user = userService.findById(id);
  return ResponseEntity.ok(UserResponseDTO.from(user));
}

@DeleteMapping("/users/{id}")
@PreAuthorize("hasRole('ADMIN')") // Only admins can delete
public ResponseEntity<Void> deleteUser(@PathVariable Long id) {
  userService.delete(id);
  return ResponseEntity.noContent().build();
}
```

### 8. API Documentation

All endpoints must be documented (OpenAPI/Swagger):

**✅ GOOD: Swagger annotations**
```java
@Operation(summary = "Get user by ID", description = "Returns a single user")
@ApiResponses(value = {
  @ApiResponse(responseCode = "200", description = "User found",
    content = @Content(schema = @Schema(implementation = UserResponseDTO.class))),
  @ApiResponse(responseCode = "404", description = "User not found",
    content = @Content(schema = @Schema(implementation = ErrorResponse.class))),
  @ApiResponse(responseCode = "403", description = "Access denied",
    content = @Content(schema = @Schema(implementation = ErrorResponse.class)))
})
@GetMapping("/users/{id}")
@PreAuthorize("hasRole('USER')")
public ResponseEntity<UserResponseDTO> getUser(
    @Parameter(description = "User ID") @PathVariable Long id
) {
  // ...
}
```

## Behavior

When this skill activates:

### 1. Review HTTP Methods

Check if HTTP method matches operation:
- POST for create? ✅
- PUT/PATCH for update? ✅
- DELETE for delete? ✅
- GET for retrieval? ✅

If wrong method:
- Suggest correct HTTP verb
- Explain REST convention

### 2. Review DTO Usage

Check if entities are exposed:
- Entity class used in @RequestBody? ❌
- Entity class used in @ResponseBody? ❌
- Entity returned directly from controller? ❌

If entity exposed:
```
⚠️ ENTITY EXPOSURE ISSUE

Controller exposes entity directly in API.

Problems:
- Entity exposes internal database structure
- Potential JPA lazy loading issues
- May expose sensitive data
- No API versioning flexibility

Solution: Use DTOs
- Create RequestDTO for input
- Create ResponseDTO for output
- Map between DTO ↔ Entity in service layer
```

### 3. Review Endpoint Naming

Check if endpoint names follow REST conventions:
- Nouns (not verbs)? ✅
- Plural form? ✅
- No redundant actions? ✅

If naming wrong:
- Suggest RESTful name
- Show before/after examples

### 4. Review Status Codes

Check if status codes are appropriate:
- 201 for POST (created)? ✅
- 204 for DELETE (no content)? ✅
- 404 for not found? ✅
- 400 for bad request? ✅

If status codes wrong:
- Suggest correct status code
- Explain HTTP semantics

### 5. Review Error Handling

Check for error handling:
- Validation errors handled? ✅
- Not found errors handled? ✅
- Authorization errors handled? ✅
- Server errors handled? ✅

If error handling missing:
```
⚠️ ERROR HANDLING MISSING

Endpoint doesn't handle error cases.

Add error handling for:
- Input validation (400 Bad Request)
- Resource not found (404 Not Found)
- Authorization failures (403 Forbidden)
- Server errors (500 Internal Server Error)

Example:
  return repository.findById(id)
    .orElseThrow(() -> new NotFoundException("User not found"));
```

### 6. Review Input Validation

Check for input validation:
- @Valid annotation used? ✅
- Validation annotations on DTO fields? ✅
- Custom validators for complex validation? ✅

If validation missing:
```
⚠️ INPUT VALIDATION MISSING

Request body is not validated.

Add validation:
1. Add @Valid to @RequestBody parameter
2. Add validation annotations to DTO fields
3. Handle validation errors gracefully

Example:
  @PostMapping("/users")
  public ResponseEntity<?> create(@RequestBody @Valid CreateUserRequestDTO dto) {
    // ...
  }
```

### 7. Review Authentication/Authorization

Check for auth on protected endpoints:
- @PreAuthorize on endpoint? ✅
- Role checks appropriate? ✅
- Resource ownership checks? ✅

If auth missing:
```
⚠️ AUTHORIZATION MISSING

Endpoint doesn't check user permissions.

Add authorization:
- @PreAuthorize("hasRole('ROLE_NAME')")
- Check resource ownership for non-admins
- Use @AuthenticationPrincipal to access current user

Example:
  @PreAuthorize("hasRole('USER')")
  public ResponseEntity<?> getOwnData(@AuthenticationPrincipal UserPrincipal principal) {
    // Only return principal's data, not all users
  }
```

## Examples

### ✅ GOOD: Well-Designed Endpoint

```java
@RestController
@RequestMapping("/api/users")
@Tag(name = "Users", description = "User management API")
@Validated
public class UserController {

  @GetMapping("/{id}")
  @Operation(summary = "Get user by ID")
  @PreAuthorize("hasRole('USER')")
  public ResponseEntity<UserResponseDTO> getUser(
    @PathVariable Long id,
    @AuthenticationPrincipal UserPrincipal principal
  ) {
    // Auth check: only own data or admin
    if (!principal.isAdmin() && !principal.getId().equals(id)) {
      throw new ForbiddenException("Access denied");
    }

    User user = userService.findById(id)
      .orElseThrow(() -> new NotFoundException("User not found"));

    return ResponseEntity.ok(UserResponseDTO.from(user));
  }

  @PostMapping
  @Operation(summary = "Create new user")
  public ResponseEntity<UserResponseDTO> createUser(
    @RequestBody @Valid CreateUserRequestDTO dto
  ) {
    User user = userService.create(dto);
    return ResponseEntity
      .status(HttpStatus.CREATED)
      .body(UserResponseDTO.from(user));
  }

  @PutMapping("/{id}")
  @Operation(summary = "Update user")
  @PreAuthorize("hasRole('USER')")
  public ResponseEntity<UserResponseDTO> updateUser(
    @PathVariable Long id,
    @RequestBody @Valid UpdateUserRequestDTO dto,
    @AuthenticationPrincipal UserPrincipal principal
  ) {
    // Auth check: only own account or admin
    if (!principal.isAdmin() && !principal.getId().equals(id)) {
      throw new ForbiddenException("Access denied");
    }

    User user = userService.update(id, dto);
    return ResponseEntity.ok(UserResponseDTO.from(user));
  }

  @DeleteMapping("/{id}")
  @Operation(summary = "Delete user")
  @PreAuthorize("hasRole('ADMIN')")
  public ResponseEntity<Void> deleteUser(@PathVariable Long id) {
    userService.delete(id);
    return ResponseEntity.noContent().build();
  }
}
```

**Why this is good:**
- ✅ RESTful naming (nouns, plural)
- ✅ Correct HTTP methods (GET, POST, PUT, DELETE)
- ✅ DTOs used (not entities)
- ✅ Proper status codes (200, 201, 204)
- ✅ Authentication/authorization checks
- ✅ Input validation (@Valid)
- ✅ Error handling (NotFoundException)
- ✅ API documentation (@Operation)
- ✅ Resource ownership checks

### ❌ BAD: Poor API Design

```java
@RestController
public class UserController {

  @PostMapping("/getAllUsers") // BAD: Wrong method, wrong naming
  public List<User> getAllUsers() { // BAD: Entity exposed
    return userRepository.findAll(); // BAD: No auth check
  }

  @GetMapping("/createUser") // BAD: GET for creation, verb in URL
  public User createUser(@RequestBody User user) { // BAD: Entity exposed
    return userRepository.save(user); // BAD: No validation
  }
}
```

**Problems:**
- ❌ Wrong HTTP methods (POST for getting, GET for creating)
- ❌ Non-RESTful naming (verbs in URL)
- ❌ Entities exposed directly
- ❌ No authentication/authorization
- ❌ No input validation
- ❌ Wrong status codes
- ❌ No error handling
- ❌ No API documentation

## Checklist

Before completing an API endpoint:

- [ ] HTTP method matches operation (GET/POST/PUT/PATCH/DELETE)
- [ ] DTOs used (not entities)
- [ ] RESTful naming (nouns, plural, no verbs)
- [ ] Proper status codes (200/201/204/400/404/403/500)
- [ ] Error handling for all cases
- [ ] Input validation (@Valid, validation annotations)
- [ ] Authentication/authorization checks
- [ ] API documentation (OpenAPI/Swagger annotations)

**If any checklist item fails:**
- **FIX** the endpoint
- **THEN** consider it complete

## Resources

**See Also:**
- `.claude/rules/40-security.md` - Security guidelines
- `.claude/skills/security/SKILL.md` - Security enforcement skill

**Learn More:**
- [REST API Tutorial](https://restfulapi.net/)
- [Spring MVC Documentation](https://docs.spring.io/spring-framework/docs/current/reference/html/web.html)
- [OpenAPI Specification](https://swagger.io/specification/)
