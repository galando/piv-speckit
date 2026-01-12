---
paths: backend/**/*.java
---

# Spring Boot Database Rules

## Spring Data JDBC (NOT JPA/Hibernate)

**WHY WE USE SPRING DATA JDBC:**
- Simpler and more predictable than JPA
- No lazy loading issues or unexpected queries
- More control over SQL queries
- Better performance for read-heavy workloads
- Explicit transaction boundaries

```java
// ✅ GOOD: Spring Data JDBC - explicit, clear
@Repository
public interface ResourceRepository extends CrudRepository<Resource, Long> {
    @Query("SELECT * FROM resources WHERE status = :status ORDER BY created_at DESC")
    List<Resource> findByStatus(String status);
}
```

```java
// ❌ BAD: Don't use JPA annotations
@Entity
@Table(name = "resources")
public class Resource {
    @ManyToOne(fetch = FetchType.LAZY) // NO! Avoid JPA relationships
    private Category category;
}
```

## HikariCP Connection Pooling

**RECOMMENDED CONFIGURATION:**

```properties
# Connection Pool Settings
spring.datasource.hikari.maximum-pool-size=10
spring.datasource.hikari.minimum-idle=5
spring.datasource.hikari.connection-timeout=30000
spring.datasource.hikari.idle-timeout=600000
spring.datasource.hikari.max-lifetime=1800000

# PostgreSQL Optimizations
spring.datasource.hikari.data-source-properties.tcpKeepAlive=true
```

**Note:** For production, tune based on your database server's capacity.

## Flyway Migrations

**CRITICAL RULES:**
- NEVER modify existing migrations
- Create new migration files for schema changes
- Use descriptive names: `V{version}__{description}.sql`
- Test migrations on local database first

**Naming Convention:**
```
V1__create_initial_schema.sql
V2__add_users_table.sql
V3__add_index_on_users_email.sql
```

**Migration Example:**

```sql
-- V3__add_notification_preferences.sql
CREATE TABLE IF NOT EXISTS user_notification_preferences (
    id BIGSERIAL PRIMARY KEY,
    user_id UUID NOT NULL,
    receive_email_alerts BOOLEAN DEFAULT TRUE,
    receive_push_notifications BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    CONSTRAINT fk_user_preferences FOREIGN KEY (user_id)
        REFERENCES users(id) ON DELETE CASCADE
);

CREATE INDEX idx_user_preferences_user_id ON user_notification_preferences(user_id);
```

**Best Practices:**
- Use `IF NOT EXISTS` for backward compatibility
- Include foreign key constraints
- Add indexes for columns used in WHERE/JOIN
- Use TIMESTAMPTZ for timestamps
- Include created_at/updated_at columns

## Entity Design

**SIMPLE ENTITIES (Spring Data JDBC):**

```java
// ✅ GOOD: Simple entity
public class Resource {
    @Id
    private Long id;
    private String name;
    private String status;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    // Getters and setters
    // No @ManyToOne, @OneToMany, etc.
}
```

```java
// ❌ BAD: JPA-style entity
@Entity
public class Resource {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "category_id")
    private Category category; // NO! Avoid relationships

    @OneToMany(mappedBy = "resource")
    private List<Tag> tags; // NO! Avoid collections
}
```

## Repository Patterns

**CUSTOM QUERIES:**

```java
@Repository
public interface ResourceRepository extends CrudRepository<Resource, Long> {

    // Custom query with parameter
    @Query("SELECT * FROM resources WHERE status = :status")
    List<Resource> findByStatus(@Param("status") String status);

    // Custom query with multiple parameters
    @Query("SELECT * FROM resources WHERE created_at > :date AND status = :status")
    List<Resource> findRecentByStatusAndDate(
        @Param("date") LocalDateTime date,
        @Param("status") String status
    );
}
```

**TRANSACTIONS:**

```java
@Service
@RequiredArgsConstructor
public class ResourceService {
    private final ResourceRepository resourceRepository;
    private final AuditLogRepository auditLogRepository;

    @Transactional
    public void createWithAudit(Resource resource) {
        resourceRepository.save(resource);
        auditLogRepository.log("Resource created", resource.getId());
        // Both operations in one transaction
    }
}
```

## Database Performance

**INDEXING:**

```sql
-- Good: Index for WHERE clause
CREATE INDEX idx_resources_status ON resources(status);

-- Good: Index for JOIN column
CREATE INDEX idx_resources_user_id ON resources(user_id);

-- Good: Composite index for multiple columns
CREATE INDEX idx_resources_status_created ON resources(status, created_at DESC);

-- Bad: Low cardinality column (not selective)
CREATE INDEX idx_resources_type ON resources(type); -- Only 3-4 distinct values
```

**QUERY OPTIMIZATION:**

```java
// ✅ GOOD: Use specific columns
@Query("SELECT id, name FROM resources WHERE status = :status")
List<ResourceTuple> findSummariesByStatus(String status);

// ❌ BAD: SELECT *
@Query("SELECT * FROM resources WHERE status = :status")
List<Resource> findByStatus(String status);
```

## Testing with Databases

**UNIT TESTS (no database):**
```java
@ExtendWith(MockitoExtension.class)
class ResourceServiceTest {
    @Mock
    private ResourceRepository resourceRepository;

    @Test
    void shouldReturnResourceWhenExists() {
        // Test with mocked repository
    }
}
```

**INTEGRATION TESTS (with database):**
```java
@SpringBootTest
@Testcontainers
class ResourceRepositoryTest {
    @Container
    static PostgreSQLContainer<?> postgres = new PostgreSQLContainer<>("postgres:16");

    @Test
    void shouldSaveAndRetrieveResource() {
        // Test with real database
    }
}
```

## Summary

**Key Principles:**

1. **Spring Data JDBC** - Explicit, predictable
2. **HikariCP** - Connection pooling
3. **Flyway** - Version-controlled migrations
4. **Simple entities** - No JPA relationships
5. **Custom queries** - @Query for complex queries
6. **Transactions** - @Transactional for multi-step operations
7. **Indexes** - For performance
8. **Testcontainers** - Integration testing with real database
