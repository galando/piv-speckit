# Database Rules

## Spring Data JDBC Patterns

### Repository Pattern
```java
@Repository
public interface UserRepository extends Repository<User, Long> {
    Optional<User> findById(Long id);
    List<User> findAll();
}
```

### Best Practices
- ✅ Use Spring Data JDBC (NOT JPA/Hibernate)
- ✅ Constructor injection with `@RequiredArgsConstructor`
- ✅ Return DTOs from services (never expose entities)
- ✅ Use `Optional` for nullable results
- ❌ Don't use entities in controllers

### Transaction Management
```java
@Transactional
public void createUserWithProfile(User user, Profile profile) {
    userRepository.save(user);
    profileRepository.save(profile);
}
```

## Query Guidelines
- ✅ Use parameterized queries (SQL injection prevention)
- ✅ Define queries in repository interfaces
- ✅ Use `@Query` for complex queries
- ❌ Never concatenate user input into SQL

**For complete patterns:** `Read .claude/reference/rules-full/database-full.md`
