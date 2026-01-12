# Spring Boot Best Practices

**Framework:** Spring Boot 3.x
**Java Version:** 17+ (prefer 21 LTS)

## Overview

This document outlines Spring Boot best practices and patterns. These patterns should be followed for all new Spring Boot development.

## Table of Contents

1. [Application Structure](#application-structure)
2. [Dependency Injection](#dependency-injection)
3. [Configuration Management](#configuration-management)
4. [Controller Layer](#controller-layer)
5. [Service Layer](#service-layer)
6. [Repository Layer](#repository-layer)
7. [Exception Handling](#exception-handling)
8. [Validation](#validation)
9. [Async Processing](#async-processing)
10. [Scheduled Tasks](#scheduled-tasks)
11. [Logging](#logging)
12. [Testing](#testing)

---

## Application Structure

### Package Organization

```
com.example/
├── Application.java           # Main application class
├── controller/                # REST API endpoints
├── service/                   # Business logic
├── repository/                # Data access
├── entity/                    # Database entities
├── dto/                       # Data transfer objects
├── config/                    # Configuration classes
└── exception/                 # Custom exceptions
```

**Key Principles:**
- Clear separation of concerns
- Each layer has single responsibility
- Controllers thin, services contain logic
- No circular dependencies

### Main Application Class

```java
@SpringBootApplication
@EnableScheduling
public class Application {
    public static void main(String[] args) {
        SpringApplication.run(Application.class, args);
    }
}
```

---

## Dependency Injection

### Constructor Injection (REQUIRED)

**✅ GOOD: Use constructor injection with @RequiredArgsConstructor**

```java
@Service
@RequiredArgsConstructor
public class ResourceService {
    private final ResourceRepository repository;
    private final EmailService emailService;

    public ResourceDTO create(CreateResourceRequest request) {
        Resource resource = new Resource();
        resource.setName(request.getName());
        Resource saved = repository.save(resource);
        return ResourceDTO.from(saved);
    }
}
```

**❌ BAD: Field injection**

```java
@Service
public class ResourceService {
    @Autowired
    private ResourceRepository repository; // NO!
}
```

---

## Configuration Management

### Using @ConfigurationProperties

```java
@ConfigurationProperties(prefix = "app")
public record AppProperties(
    String name,
    int maxConnections,
    Duration timeout
) {
    @PostConstruct
    void init() {
        // Validation logic
    }
}
```

### Profiles

```properties
# application-dev.properties
app.name=My App (Dev)
spring.datasource.url=jdbc:postgresql://localhost:5432/myapp

# application-prod.properties
app.name=My App (Prod)
spring.datasource.url=jdbc:postgresql://prod-db:5432/myapp
```

---

## Controller Layer

### REST Controllers

```java
@RestController
@RequestMapping("/api/resources")
@RequiredArgsConstructor
public class ResourceController {
    private final ResourceService resourceService;

    @GetMapping
    public ResponseEntity<List<ResourceDTO>> getAll() {
        return ResponseEntity.ok(resourceService.getAll());
    }

    @GetMapping("/{id}")
    public ResponseEntity<ResourceDTO> getById(@PathVariable Long id) {
        return ResponseEntity.ok(resourceService.getById(id));
    }

    @PostMapping
    public ResponseEntity<ResourceDTO> create(@Valid @RequestBody CreateResourceRequest request) {
        ResourceDTO created = resourceService.create(request);
        return ResponseEntity.status(HttpStatus.CREATED).body(created);
    }
}
```

**Key Points:**
- Keep controllers thin
- Only handle HTTP concerns (status codes, content type)
- Delegate all logic to service layer
- Use DTOs, not entities

---

## Service Layer

### Business Logic

```java
@Service
@RequiredArgsConstructor
@Transactional
public class ResourceService {
    private final ResourceRepository repository;
    private final AuditService auditService;

    public ResourceDTO create(CreateResourceRequest request) {
        Resource resource = new Resource();
        resource.setName(request.getName());
        resource.setStatus(Status.ACTIVE);

        Resource saved = repository.save(resource);
        auditService.log("Resource created", saved.getId());

        return ResourceDTO.from(saved);
    }

    public List<ResourceDTO> getAll() {
        return repository.findAll()
            .stream()
            .map(ResourceDTO::from)
            .collect(Collectors.toList());
    }
}
```

**Key Points:**
- Contains all business logic
- Use @Transactional for database operations
- Map entities to DTOs before returning

---

## Repository Layer

### Spring Data JDBC

```java
@Repository
public interface ResourceRepository extends CrudRepository<Resource, Long> {

    @Query("SELECT * FROM resources WHERE status = :status ORDER BY created_at DESC")
    List<Resource> findByStatus(@Param("status") String status);

    @Query("SELECT * FROM resources WHERE name LIKE :name")
    List<Resource> findByNameContaining(@Param("name") String name);
}
```

**Key Points:**
- Use Spring Data JDBC (NOT JPA/Hibernate)
- Keep queries simple and explicit
- Use @Query for complex queries
- No @ManyToOne, @OneToMany annotations

---

## Exception Handling

### Global Exception Handler

```java
@RestControllerAdvice
public class GlobalExceptionHandler {

    @ExceptionHandler(ResourceNotFoundException.class)
    public ResponseEntity<ErrorResponse> handleNotFound(ResourceNotFoundException ex) {
        ErrorResponse error = new ErrorResponse(
            HttpStatus.NOT_FOUND.value(),
            ex.getMessage()
        );
        return ResponseEntity.status(HttpStatus.NOT_FOUND).body(error);
    }

    @ExceptionHandler(MethodArgumentNotValidException.class)
    public ResponseEntity<ErrorResponse> handleValidation(MethodArgumentNotValidException ex) {
        List<String> errors = ex.getBindingResult()
            .getAllErrors()
            .stream()
            .map(ObjectError::getDefaultMessage)
            .collect(Collectors.toList());

        ErrorResponse error = new ErrorResponse(
            HttpStatus.BAD_REQUEST.value(),
            "Validation failed",
            errors
        );
        return ResponseEntity.badRequest().body(error);
    }

    @ExceptionHandler(Exception.class)
    public ResponseEntity<ErrorResponse> handleGeneric(Exception ex) {
        ErrorResponse error = new ErrorResponse(
            HttpStatus.INTERNAL_SERVER_ERROR.value(),
            "An unexpected error occurred"
        );
        log.error("Unexpected error", ex);
        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(error);
    }
}
```

---

## Validation

### Request Validation

```java
public class CreateResourceRequest {
    @NotBlank(message = "Name is required")
    @Size(max = 100, message = "Name must be less than 100 characters")
    private String name;

    @Email(message = "Invalid email format")
    @NotBlank(message = "Email is required")
    private String email;

    @Min(value = 1, message = "Value must be positive")
    private int quantity;
}
```

### Custom Validators

```java
@Target({ElementType.FIELD})
@Retention(RetentionPolicy.RUNTIME)
@Constraint(validatedBy = UniqueEmailValidator.class)
public @interface UniqueEmail {
    String message() default "Email already exists";
    Class<?>[] groups() default {};
    Class<? extends Payload>[] payload() default {};
}
```

---

## Async Processing

### @Async Method

```java
@Service
public class EmailService {

    @Async
    public void sendEmail(String to, String subject, String body) {
        // Runs in separate thread
        emailClient.send(to, subject, body);
    }
}
```

### Configuration

```java
@Configuration
@EnableAsync
public class AsyncConfig implements AsyncConfigurer {

    @Override
    public Executor getAsyncExecutor() {
        ThreadPoolTaskExecutor executor = new ThreadPoolTaskExecutor();
        executor.setCorePoolSize(5);
        executor.setMaxPoolSize(10);
        executor.setQueueCapacity(100);
        executor.setThreadNamePrefix("async-");
        executor.initialize();
        return executor;
    }
}
```

---

## Scheduled Tasks

### @Scheduled Methods

```java
@Component
public class ScheduledTasks {

    @Scheduled(cron = "0 0 * * * *") // Every hour
    public void cleanupOldData() {
        // Cleanup logic
    }

    @Scheduled(fixedRate = 60000) // Every minute
    public void checkStatus() {
        // Status check logic
    }
}
```

---

## Logging

### Structured Logging

```java
@Slf4j
@Service
@RequiredArgsConstructor
public class ResourceService {

    public void processBatch(List<Resource> resources) {
        log.info("Processing batch: size={}", resources.size());

        for (Resource resource : resources) {
            try {
                process(resource);
            } catch (Exception e) {
                log.error("Failed to process resource: id={}, error={}",
                    resource.getId(), e.getMessage(), e);
            }
        }

        log.info("Batch processing completed: processed={}, duration={}ms",
            resources.size(), duration);
    }
}
```

**Key Points:**
- Use @Slf4j annotation
- Structured logging with key-value pairs
- Log errors with stack trace
- Include context (ids, counts, duration)

---

## Testing

### Unit Tests

```java
@ExtendWith(MockitoExtension.class)
class ResourceServiceTest {

    @Mock(lenient = true)
    private ResourceRepository repository;

    @InjectMocks
    private ResourceService resourceService;

    @Test
    void shouldReturnResourceWhenExists() {
        // Given
        Resource resource = new Resource();
        resource.setId(1L);
        resource.setName("Test");
        when(repository.findById(1L)).thenReturn(Optional.of(resource));

        // When
        ResourceDTO result = resourceService.getById(1L);

        // Then
        assertThat(result).isNotNull();
        assertThat(result.getName()).isEqualTo("Test");
        verify(repository).findById(1L);
    }
}
```

### Integration Tests

```java
@SpringBootTest
@Testcontainers
class ResourceRepositoryTest {

    @Container
    static PostgreSQLContainer<?> postgres =
        new PostgreSQLContainer<>("postgres:16");

    @Autowired
    private ResourceRepository resourceRepository;

    @Test
    void shouldSaveAndRetrieveResource() {
        // Given
        Resource resource = new Resource();
        resource.setName("Test");

        // When
        Resource saved = resourceRepository.save(resource);

        // Then
        assertThat(saved.getId()).isNotNull();
        assertThat(resourceRepository.findById(saved.getId())).isPresent();
    }
}
```

---

## Summary

**Key Principles:**

1. **Structure:** Clear layer separation (controller/service/repository)
2. **DI:** Constructor injection with @RequiredArgsConstructor
3. **Database:** Spring Data JDBC (not JPA)
4. **DTOs:** Use DTOs in API, never entities
5. **Logging:** Structured logging with context
6. **Testing:** Unit tests with mocks, integration tests with Testcontainers
7. **Validation:** Bean Validation annotations
8. **Exception Handling:** Global exception handler
9. **Async:** @Async for background tasks
10. **Scheduling:** @Scheduled for periodic tasks

**External References:**
- [Spring Boot Reference](https://docs.spring.io/spring-boot/docs/current/reference/html/)
- [Spring Data JDBC](https://docs.spring.io/spring-data/jdbc/docs/current/reference/html/)
- [Bean Validation](https://docs.jboss.org/hibernate/stable/validator/reference/)
