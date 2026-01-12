# Spring Boot

**Java/Kotlin backend framework with Spring Boot**

---

## Overview

Spring Boot makes it easy to create stand-alone, production-grade Spring based Applications that you can "just run".

## Version Support
- **Minimum Version**: 3.0+
- **Tested With**: 3.2.x
- **Status**: ✅ Stable

## Prerequisites
- Java 17+ or Kotlin 1.9+
- Maven or Gradle

## Quick Start

```bash
# Create new Spring Boot project
curl https://start.spring.io/starter.zip \
  -d dependencies=web,data-jpa,postgresql \
  -d type=maven-project \
  -d bootVersion=3.2.0 \
  -o my-project.zip

unzip my-project.zip
cd my-project
mvn spring-boot:run
```

## Project Structure

```
src/main/java/
├── controller/     # REST controllers
├── service/        # Business logic
├── repository/     # Data access (Spring Data JDBC)
├── model/          # Domain entities
└── config/         # Configuration
```

## PIV Integration

### Rules Included
Rules auto-load for files matching: `**/*.java`, `**/*.kt`, `pom.xml`, `build.gradle*`

| Rule File | Purpose |
|-----------|---------|
| 00-overview.md | Spring Boot philosophy |
| 10-setup.md | Project setup |
| 20-coding-standards.md | Java/Kotlin conventions |
| 30-testing.md | Testing with JUnit 5 |

## Key Principles

### Spring Data JDBC (Not JPA)
We prefer Spring Data JDBC over JPA/Hibernate:
- Simpler mental model
- No hidden lazy loading
- Explicit queries
- Better performance understanding

### Constructor Injection
```kotlin
@RequiredArgsConstructor
@Service
class UserService(
    private val repository: UserRepository,
    private val passwordEncoder: PasswordEncoder
)
```

### DTOs for APIs
Never expose entities directly:
```kotlin
data class UserResponse(
    val id: String,
    val email: String
    // Password hash NOT included
)
```

## Resources
- [Official Documentation](https://spring.io/projects/spring-boot)
- [Spring Data JDBC](https://spring.io/projects/spring-data-jdbc)
- [Baeldung Tutorials](https://www.baeldung.com/spring-boot)

## Contributing
See [contributing guidelines](../../../../CONTRIBUTING.md)
