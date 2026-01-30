---
paths: backend/**/*.java
---

# Spring Boot API Design Rules

## Service Layer Pattern

**✅ ALWAYS:**
- Keep controllers thin - only handle HTTP concerns
- Move ALL business logic to service layer
- Use dependency injection via constructor
- Use `@RequiredArgsConstructor` from Lombok

```java
// ✅ GOOD: Thin controller
@RestController
@RequestMapping("/api/resources")
@RequiredArgsConstructor
public class ResourceController {
    private final ResourceService resourceService;

    @GetMapping
    public ResponseEntity<List<ResourceDTO>> getAll() {
        return ResponseEntity.ok(resourceService.getAll());
    }
}
```

```java
// ❌ BAD: Business logic in controller
@GetMapping
public ResponseEntity<?> getAll() {
    List<Resource> resources = resourceRepository.findAll(); // NO!
    // Filtering logic in controller - BAD!
    return ResponseEntity.ok(resources.stream()...);
}
```

## DTOs for API Responses

**✅ ALWAYS use DTOs, NEVER return entities:**

```java
// ✅ GOOD: Use DTOs
@GetMapping
public List<ResourceDTO> getAll() {
    return resourceService.getAll()
        .stream()
        .map(ResourceDTO::from)
        .collect(Collectors.toList());
}
```

```java
// ❌ BAD: Returning entities exposes internal structure
@GetMapping
public List<Resource> getAll() {
    return resourceRepository.findAll(); // NO!
}
```

## Circular Dependencies

**PROBLEM:** ServiceA needs ServiceB, ServiceB needs ServiceA

**SOLUTION:** Use `@Lazy` annotation:

```java
@Service
@RequiredArgsConstructor
public class ServiceA {
    private final ServiceB serviceB;

    public ServiceA(@Lazy ServiceB serviceB) {
        this.serviceB = serviceB;
    }
}
```

## Error Handling & Logging

**STRUCTURED LOGGING:**

```java
log.info("Processing completed: source={}, found={}, duration={}ms",
         sourceName, itemsFound, duration);
```

**GRACEFUL ERROR HANDLING:**

```java
// Continue processing even if one item fails
for (String item : items) {
    try {
        processItem(item);
    } catch (Exception e) {
        log.error("Failed to process item: {}", item, e);
        // Continue with next item
    }
}
```

## Request Validation

**USE `@Valid` FOR REQUEST BODY VALIDATION:**

```java
@PostMapping
public ResponseEntity<ResourceDTO> create(@Valid @RequestBody CreateResourceRequest request) {
    return ResponseEntity.ok(resourceService.create(request));
}
```

**DTO WITH VALIDATION:**

```java
public class CreateResourceRequest {
    @NotBlank(message = "Name is required")
    @Size(max = 100, message = "Name must be less than 100 characters")
    private String name;

    @Email(message = "Invalid email format")
    private String email;
}
```

## Response Standards

**SUCCESS RESPONSES:**

```java
// GET 200 - Return data
@GetMapping("/{id}")
public ResponseEntity<ResourceDTO> getById(@PathVariable Long id) {
    return ResponseEntity.ok(resourceService.getById(id));
}

// POST 201 - Return created resource
@PostMapping
public ResponseEntity<ResourceDTO> create(@RequestBody CreateResourceRequest request) {
    ResourceDTO created = resourceService.create(request);
    return ResponseEntity.status(HttpStatus.CREATED).body(created);
}
```

**ERROR RESPONSES:**

```java
// 400 - Bad Request (validation failed)
@ExceptionHandler(MethodArgumentNotValidException.class)
public ResponseEntity<ErrorResponse> handleValidationException(MethodArgumentNotValidException ex) {
    ErrorResponse error = new ErrorResponse("Validation failed", ex.getBindingResult().getAllErrors());
    return ResponseEntity.badRequest().body(error);
}

// 404 - Not Found
@ExceptionHandler(ResourceNotFoundException.class)
public ResponseEntity<ErrorResponse> handleNotFound(ResourceNotFoundException ex) {
    ErrorResponse error = new ErrorResponse(ex.getMessage());
    return ResponseEntity.status(HttpStatus.NOT_FOUND).body(error);
}
```

## RESTful Conventions

**ENDPOINT NAMING:**

```
GET    /api/resources          - List all resources
GET    /api/resources/{id}     - Get specific resource
POST   /api/resources          - Create new resource
PUT    /api/resources/{id}     - Update resource (full)
PATCH  /api/resources/{id}     - Update resource (partial)
DELETE /api/resources/{id}     - Delete resource
```

**PATH VARIABLES:**

```java
@GetMapping("/api/resources/{id}")
public ResponseEntity<ResourceDTO> getById(@PathVariable Long id) {
    return ResponseEntity.ok(resourceService.getById(id));
}
```

**QUERY PARAMETERS:**

```java
@GetMapping("/api/resources")
public ResponseEntity<List<ResourceDTO>> search(
    @RequestParam(required = false) String name,
    @RequestParam(defaultValue = "0") int page,
    @RequestParam(defaultValue = "20") int size
) {
    return ResponseEntity.ok(resourceService.search(name, page, size));
}
```

## Summary

**Key Principles:**

1. **Thin controllers** - Only HTTP concerns
2. **DTOs for APIs** - Never expose entities
3. **Constructor injection** - Use @RequiredArgsConstructor
4. **Structured logging** - Key-value pairs
5. **Graceful errors** - Continue processing when possible
6. **Validation** - Use @Valid and Bean Validation
7. **RESTful conventions** - Standard HTTP methods and status codes
