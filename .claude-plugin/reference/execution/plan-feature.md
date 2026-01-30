# Plan a New Feature

## Feature: $ARGUMENTS

## Mission

Transform a feature request into a **comprehensive implementation plan** through systematic codebase analysis, external research, and strategic planning.

**Core Principle**: We do NOT write code in this phase. Our goal is to create a context-rich implementation plan that enables one-pass implementation success.

**Key Philosophy**: Context is King. The plan must contain ALL information needed for implementation - patterns, mandatory reading, documentation, validation commands - so the execution agent succeeds on the first attempt.

## Planning Process

### Phase 0: Auto-Prime (Silent, Automatic)

**This phase runs automatically before planning begins. No user action required.**

**Purpose:** Ensure codebase context is loaded and fresh before planning starts.

**How it works:**

1. **Check for existing context:** Look for `.claude/agents/context/prime-context.md`
2. **If missing:** Run a full prime scan silently (analyze structure, patterns, tech stack)
3. **If exists, check freshness:**
   - Read the `Last Updated` timestamp from the context file
   - Check git changes since last prime (gracefully handles missing file):
     ```bash
     # Returns empty if file was never committed (new projects)
     LAST_COMMIT=$(git log -1 --format=%H -- .claude/agents/context/prime-context.md 2>/dev/null || echo "")
     if [ -n "$LAST_COMMIT" ]; then
       git diff --stat "$LAST_COMMIT" HEAD
     fi
     ```
   - **Freshness thresholds** (configurable in CLAUDE.md):
     - Default: >20 files changed OR context >7 days old → re-scan
     - Override via CLAUDE.md: `prime_max_age_days: N` and `prime_max_changed_files: N`
4. **If fresh:** Skip, proceed directly to Phase 1

**Auto-Prime Scan (when triggered):**

```
Silently performs:
1. git ls-files → Map project structure
2. Read CLAUDE.md + rules/ → Project principles & constraints
3. Read .claude/memory/constitution.md (if exists) → Legacy project principles (backward compatibility)
4. Detect tech stack from pom.xml / package.json / pyproject.toml
5. Find key patterns: controllers, services, repositories, components
6. Save reference-based context to .claude/agents/context/prime-context.md
```

**Backward Compatibility:** If `.claude/memory/constitution.md` exists (from v2.x), it will be read and its principles merged with CLAUDE.md + rules/. New projects should use CLAUDE.md + rules/ directly.

**Context Format (reference-based, ~50 lines):**

```markdown
# Prime Context

**Project:** {name}
**Last Updated:** {timestamp}
**Tech Stack:** {backend} + {frontend} + {database}

## Where to Find Patterns

### REST Controllers
**Example:** `backend/src/main/java/.../UserController.java:1-45`
**Find all:** `grep -r "@RestController" backend/src/main/java/`

### Services
**Example:** `backend/src/main/java/.../UserService.java:1-60`
**Find all:** `grep -r "@Service" backend/src/main/java/`

### React Components
**Example:** `frontend/src/components/UserList.tsx:1-80`
**Find all:** `grep -r "export function" frontend/src/components/`

## Key Files
| Purpose | File |
|---------|------|
| Config  | `backend/src/main/resources/application.properties` |
| Routes  | `frontend/src/App.tsx` |

## Project Principles
Source: `.claude/CLAUDE.md` + `.claude/rules/` (loaded automatically by Claude Code)
```

**Why reference-based?** Full code dumps waste ~2000 tokens. References let Claude read files on-demand during planning, saving context for actual planning work.

**Note:** Users can still run `/piv-speckit:prime` manually to force a context refresh at any time.

---

### Phase 1: Feature Understanding

**Deep Feature Analysis:**

1. **Extract the Core Problem:**
   - What problem are we solving?
   - What is the user value?
   - What is the business impact?

2. **Identify Feature Type:**
   - New Capability (adds new functionality)
   - Enhancement (improves existing feature)
   - Refactor (restructures without changing behavior)
   - Bug Fix (fixes incorrect behavior)

3. **Assess Complexity:**
   - Low: Single component, minimal integration (< 4 hours)
   - Medium: Multiple components, some integration (< 2 days)
   - High: Cross-cutting changes, many integrations (> 2 days)

4. **Map Affected Systems:**
   - Backend components (controllers, services, repositories)
   - Frontend components (pages, components, context)
   - Database schema (new tables, migrations)
   - External APIs (new integrations)
   - Configuration (new properties)

**Create User Story Format:**

```
As a <type of user>
I want to <action/goal>
So that <benefit/value>
```

**Example:**
```
As a data searcher
I want to verify if data exists on External APIs
So that I don't get false "exclusive" alerts for properties that actually exist
```

### Phase 1.5: Pragmatic Programmer Principles Review

**IMPORTANT:** Before proceeding to codebase analysis, review your feature against proven software engineering principles from *The Pragmatic Programmer*.

**Why this matters:** These principles prevent technical debt, reduce rework, and ensure long-term maintainability.

**Checklist:**

#### ✅ DRY (Don't Repeat Yourself)

**From:** The Pragmatic Programmer, Chapter 2

**Principle:** Every piece of knowledge must have a single, unambiguous, authoritative representation within a system.

**Ask yourself:**
- Am I duplicating existing logic?
- Can I reuse an existing utility/helper/service?
- Is there already a pattern for this in the codebase?
- Should I extract something reusable before adding new code?

**Before proceeding:**
- [ ] Checked codebase for similar implementations
- [ ] Identified reusable patterns to follow
- [ ] Noted where to extract common logic (if any)

#### ✅ Shrapnel (Fix Broken Windows)

**From:** The Pragmatic Programmer, Chapter 3

**Principle:** Don't leave "broken windows" (bad designs, wrong decisions, or poor code) unrepaired. Fix them now, not later.

**Ask yourself:**
- Does this feature expose existing technical debt?
- Am I about to create more technical debt?
- Should I fix related issues while I'm here?
- Are there TODOs or FIXMEs in the affected code?

**Before proceeding:**
- [ ] Noted any broken windows discovered
- [ ] Added fixing them to plan (if appropriate)
- [ ] Avoided creating new broken windows

#### ✅ Automate, Automate, Automate

**From:** The Pragmatic Programmer, Chapter 5

**Principle:** If it's not automated, it's part of the problem, not the solution.

**Ask yourself:**
- Can this be automated instead of manual?
- Are there scripts/tests that can verify this?
- How can I make this repeatable and reliable?
- What would prevent this from being automated?

**Before proceeding:**
- [ ] Identified what can be automated
- [ ] Planned automation (tests, scripts, CI/CD)
- [ ] Avoided manual processes where possible

#### ✅ Design for Change

**From:** The Pragmatic Programmer, Chapter 6

**Principle:** Design your code to be modular and flexible, making future changes easier.

**Ask yourself:**
- What will likely change in the future?
- Is this design flexible for those changes?
- Am I coupling things that shouldn't be coupled?
- Can I make this more modular without over-engineering?

**Before proceeding:**
- [ ] Considered likely future changes
- [ ] Designed for flexibility (within reason)
- [ ] Avoided premature optimization
- [ ] Balanced flexibility with simplicity (YAGNI)

**Principle Review Complete:**

- [ ] All four principles reviewed
- [ ] Action items noted in plan (if any)
- [ ] Ready to proceed to Phase 2

**If any principle reveals major issues:**
- Consider asking user for clarification (see AskUserQuestion section below)
- Document the issue in the plan
- Adjust approach before proceeding

### Clarify Ambiguities Using AskUserQuestion

**IMPORTANT:** Use the AskUserQuestion tool to clarify requirements BEFORE proceeding with planning.

**When to use AskUserQuestion:**

✅ **Use at Phase 1 (Feature Understanding):**
- Requirements are vague or ambiguous
- Multiple valid approaches exist
- User preferences needed (libraries, patterns)
- Business value is unclear

❌ **Don't use for:**
- Asking "Is my plan ready?" (use ExitPlanMode for approval)
- Asking "Should I proceed?" (use ExitPlanMode for approval)
- Technical decisions you can make yourself
- Questions answered by reading codebase

**AskUserQuestion Integration Points:**

**Point 1: After Phase 1 (Feature Understanding)**

Ask about:
- Feature scope and boundaries
- User preferences (if multiple valid approaches)
- Business value and success criteria
- Priority of requirements

**Example questions:**
```
"Should this feature integrate with existing service X or create a new service?"
"Is performance more important than code simplicity for this feature?"
"Should we support edge case Y now or defer to future iteration?"
```

**Point 2: At Phase 4 (Deep Strategic Thinking)**

Ask about:
- Architectural decisions (multiple valid approaches)
- Trade-offs between quality attributes
- Implementation approach when alternatives exist
- Future extensibility vs. current simplicity

**Example questions:**
```
"Should we use Approach A (simpler, less flexible) or Approach B (more complex, more extensible)?"
"Is it acceptable to introduce dependency X for this feature, or should we find alternative?"
"Should we optimize for read performance or write performance?"
```

**Point 3: Before Finalizing Plan (After Phase 5)**

Ask about:
- Any remaining ambiguities
- Confirmation of approach
- Approval to proceed (if needed)

**Example questions:**
```
"I identified two potential issues with the current plan: X and Y. How should we handle them?"
"The plan assumes Z is acceptable. Is this correct?"
"Ready to proceed with implementation based on this plan?"
```

**Remember:** Use AskUserQuestion to clarify REQUIREMENTS and APPROACHES, not for plan approval. Use ExitPlanMode when the plan is complete and ready for user approval.

**Clarification Check (Phase 1 → Phase 2 Gateway):**

Before proceeding to Phase 2, ask yourself:

1. **Are requirements clear?**
   - Do I understand exactly what to build?
   - Do I know the success criteria?

2. **Are there ambiguities?**
   - Multiple valid approaches?
   - User preferences needed?
   - Architectural decisions unclear?

3. **Is the problem well-defined?**
   - Can I explain what we're solving?
   - Do I know why this matters?

**If YES to all:** Proceed to Phase 2 (Codebase Intelligence Gathering)

**If NO to any:** Use AskUserQuestion tool to clarify:

```
AskUserQuestion with questions about:
- Feature scope/boundaries (if unclear)
- Implementation preferences (if multiple options)
- Trade-offs and priorities (if not obvious)
```

**Only proceed to Phase 2 when requirements are clear.**

### Phase 2: Codebase Intelligence Gathering

**IMPORTANT: Start by reading the prime context:**

```bash
# Read the prime context file
Read .claude/agents/context/prime-context.md
```

**Then perform targeted analysis:**

**1. Project Structure Analysis**

- Detect primary language(s), frameworks, and runtime versions
- Map directory structure and architectural patterns
- Identify service/component boundaries and integration points
- Locate configuration files (pom.xml, package.json, application.properties)
- Find environment setup and build processes

**2. Pattern Recognition**

Use specialized subagents when beneficial:

- **Search for similar implementations in codebase:**
  ```bash
  # Find similar features
  grep -r "keyword" backend/src/main/java/
  grep -r "keyword" frontend/src/
  ```

- **Identify coding conventions:**
  - Naming patterns (CamelCase for Java, kebab-case for files)
  - File organization and module structure
  - Error handling approaches
  - Logging patterns and standards

- **Extract common patterns for the feature's domain:**
  - Controller patterns (REST endpoints, request/response)
  - Service patterns (business logic, transactions)
  - Repository patterns (queries, Spring Data JDBC)
  - Component patterns (React hooks, state management)

- **Document anti-patterns to avoid:**
  - Check `.claude/rules/anti-patterns.md`
  - Check `.claude/rules/backend/` for backend anti-patterns
  - Check `.claude/rules/` for general anti-patterns

- **Check CLAUDE.md and .claude/rules/ for project-specific rules:**
  ```bash
  # Read relevant rule files
  Read .claude/CLAUDE.md
  Read .claude/rules/backend/api-design.md
  Read .claude/rules/backend/database.md
  Read .claude/rules/backend/fetching.md  # if data collector-related
  Read .claude/rules/testing.md
  ```

**3. Dependency Analysis**

- **Catalog external libraries relevant to feature:**
  - Check `backend/pom.xml` for Java dependencies
  - Check `frontend/package.json` for JavaScript dependencies

- **Understand how libraries are integrated:**
  - Check imports in relevant files
  - Check configuration files

- **Find relevant documentation:**
  - Check `docs/` directory
  - Check `.claude/reference/` for best practices

- **Note library versions and compatibility requirements:**

**4. Testing Patterns**

- **Identify test framework and structure:**
  - JUnit 5 for backend unit tests
  - Mockito for mocking
  - @SpringBootTest for integration tests
  - Testcontainers for PostgreSQL

- **Find similar test examples for reference:**
  ```bash
  # Find test files
  find backend/src/test -name "*Test.java"
  find backend/src/test -name "*IT.java"
  ```

- **Understand test organization:**
  - Unit tests: `*Test.java` (fast, no external dependencies)
  - Integration tests: `*IT.java` (slower, with database/external APIs)

- **Note coverage requirements:**
  - Target: 80%+ coverage for new code

**5. Integration Points**

- **Identify existing files that need updates:**
  - Controllers to add new endpoints
  - Services to add new business logic
  - Repositories to add new queries
  - Components to add new UI elements
  - Routes to add new pages

- **Determine new files that need creation:**
  - New controller for new API
  - New service for new business logic
  - New repository for new data access
  - New entity/DTO for new data model
  - New migration for database changes
  - New component/page for frontend

- **Map router/API registration patterns:**
  - REST endpoint patterns: `/api/{resource}`
  - Frontend routing: React Router v7

- **Understand database/model patterns if applicable:**
  - Spring Data JDBC entities
  - Flyway migrations
  - DTO naming conventions

**Clarify Ambiguities:**

- If requirements are unclear at this point, **ask the user to clarify** before you continue
- Get specific implementation preferences (libraries, approaches, patterns)
- Resolve architectural decisions before proceeding

### Phase 3: External Research & Documentation

**Use specialized subagents when beneficial for external research:**

**Documentation Gathering:**

- **Research latest library versions and best practices:**
  - Spring Boot 3.2.0 documentation
  - Java 24 features (if using new Java 24 APIs)
  - React 19 documentation
  - Library-specific docs (e.g., GeoService API)

- **Find official documentation with specific section anchors:**
  - Spring Boot reference guide
  - Spring Data JDBC documentation
  - React 19 documentation

- **Locate implementation examples and tutorials:**
  - Official examples
  - Stack Overflow answers (if applicable)
  - GitHub repositories with similar patterns

- **Identify common gotchas and known issues:**
  - Spring Data JDBC limitations
  - React 19 breaking changes
  - Java 24 migration issues

- **Check for breaking changes and migration guides:**
  - Spring Boot 3.x changes
  - React 19 changes

**Technology Trends:**

- **Research current best practices for the technology stack:**
  - Spring Boot best practices
  - React 19 best practices
  - Java 24 modern patterns

- **Find relevant blog posts, guides, or case studies:**
  - Baeldung for Spring Boot
  - React blog for React patterns

- **Identify performance optimization patterns:**
  - Database query optimization
  - React performance (memo, useMemo, useCallback)

- **Document security considerations:**
  - OWASP Top 10 for the technology stack
  - Input validation
  - Authentication/authorization

**Compile Research References:**

```markdown
## Relevant Documentation

- [Spring Boot Data JDBC](https://docs.spring.io/spring-data/jdbc/docs/current/reference/html/#reference)
  - Specific section: Repository interfaces
  - Why: Needed for data access patterns

- [React 19 Hooks](https://react.dev/reference/react)
  - Specific section: useEffect, useState
  - Why: Component state management

- [External API Docs](https://api.example.com/docs)
  - Specific section: Authentication
  - Why: Required for API integration
```

### Phase 4: Deep Strategic Thinking

**Think Harder About:**

1. **Architecture Fit:**
   - How does this feature fit into the existing architecture?
   - Does it follow existing patterns?
   - Does it require new patterns?

2. **Dependencies and Order:**
   - What are the critical dependencies?
   - What is the order of operations?
   - Can we break this into smaller phases?

3. **Potential Issues:**
   - What could go wrong? (Edge cases, race conditions, errors)
   - How do we handle failures?
   - What are the performance implications?

4. **Testing Strategy:**
   - How will this be tested comprehensively?
   - What are the edge cases?
   - How do we mock external dependencies?

5. **Performance:**
   - What are the performance implications?
   - Are there any N+1 query issues?
   - Are there any memory leaks?

6. **Security:**
   - Are there security considerations?
   - Input validation?
   - Authentication/authorization?
   - SQL injection? XSS?

7. **Maintainability:**
   - How maintainable is this approach?
   - Is it easy to understand?
   - Is it easy to modify?

**Design Decisions:**

- **Choose between alternative approaches with clear rationale:**
  - Why this approach over alternatives?
  - What are the trade-offs?

- **Design for extensibility and future modifications:**
  - Can this be extended later?
  - Is it flexible?

- **Plan for backward compatibility if needed:**
  - Will this break existing functionality?
  - Do we need a migration strategy?

- **Consider scalability implications:**
  - Will this scale?
  - Are there any bottlenecks?

**Architectural Decision Check (Phase 4 → Phase 5 Gateway):**

Before proceeding to Phase 5, ask yourself:

1. **Are architectural decisions clear?**
   - Do I know which approach to take?
   - Have I justified the choice?

2. **Are there multiple valid options?**
   - Could different approaches work?
   - Are there significant trade-offs?

3. **Do I need user input on trade-offs?**
   - Performance vs. simplicity?
   - Flexibility vs. development time?
   - New dependency vs. existing solution?

**If YES (decisions clear, one best approach):** Proceed to Phase 5 (Plan Structure Generation)

**If NO (multiple valid approaches, trade-offs unclear):** Use AskUserQuestion tool:

```
AskUserQuestion with questions about:
- Architectural approach (if multiple options)
- Trade-off preferences (if not obvious)
- Dependency acceptance (if new libraries proposed)
```

**Only proceed to Phase 5 when architectural approach is clear.**

### Phase 5: Plan Structure Generation

**Create comprehensive plan with the following structure:**

```markdown
# Feature: <feature-name>

**IMPORTANT:** Before implementing, validate documentation and codebase patterns. Pay special attention to naming of existing utils, types, and models. Import from the right files.

## Feature Description

<Detailed description of the feature, its purpose, and value to users>

## User Story

As a <type of user>
I want to <action/goal>
So that <benefit/value>

## Problem Statement

<Clearly define the specific problem or opportunity this feature addresses>

## Solution Statement

<Describe the proposed solution approach and how it solves the problem>

## Feature Metadata

**Feature Type:** [New Capability/Enhancement/Refactor/Bug Fix]
**Estimated Complexity:** [Low/Medium/High]
**Primary Systems Affected:** [List of main components/services]
**Dependencies:** [External libraries or services required]

---

## CONTEXT REFERENCES

### Prime Context (READ THIS FIRST!)

- `.claude/agents/context/prime-context.md` - COMPLETE codebase overview
  - **WHY:** Contains all project patterns, configurations, and architecture
  - **ACTION:** Read this file first to understand the codebase

### Relevant Codebase Files (MUST READ BEFORE IMPLEMENTING!)

<List files with line numbers and relevance>

- `backend/src/main/java/com/example/controller/ExampleController.java` (lines 15-45)
  - **WHY:** Contains REST API pattern to mirror
  - **PATTERN:** Thin controller, delegates to service layer

- `backend/src/main/java/com/example/service/ExampleService.java` (lines 100-120)
  - **WHY:** Shows business logic pattern to follow
  - **PATTERN:** @Service with @RequiredArgsConstructor

- `backend/src/main/java/com/example/entity/Example.java`
  - **WHY:** Entity structure for Spring Data JDBC
  - **PATTERN:** Simple entity, no JPA annotations

- `frontend/src/components/ExampleComponent.tsx`
  - **WHY:** React component pattern
  - **PATTERN:** Functional component with hooks

### New Files to Create

- `backend/src/main/java/com/example/controller/NewController.java` - New REST API endpoints
- `backend/src/main/java/com/example/service/NewService.java` - Business logic for feature
- `backend/src/main/java/com/example/dto/NewDTO.java` - Data transfer object
- `backend/src/main/java/com/example/repository/NewRepository.java` - Data access layer
- `backend/src/main/resources/db/migration/V{next}__{description}.sql` - Database migration
- `backend/src/test/java/com/example/controller/NewControllerTest.java` - Unit tests
- `frontend/src/components/NewComponent.tsx` - New React component

### Relevant Documentation (MUST READ!)

- [Spring Boot Data JDBC Docs](https://docs.spring.io/spring-data/jdbc/docs/current/reference/html/)
  - **Section:** Repository interfaces
  - **WHY:** Required for data access patterns

- [React 19 Documentation](https://react.dev/)
  - **Section:** Hooks Reference
  - **WHY:** Component state management patterns

### Patterns to Follow

**Backend Controller Pattern:**

```java
// ✅ GOOD: Thin controller with DTOs
@RestController
@RequestMapping("/api/resource")
@RequiredArgsConstructor
public class ExampleController {
    private final ExampleService exampleService;

    @GetMapping
    public ResponseEntity<List<ExampleDTO>> getAll() {
        return ResponseEntity.ok(exampleService.getAll());
    }

    @PostMapping
    public ResponseEntity<ExampleDTO> create(@RequestBody CreateExampleRequest request) {
        return ResponseEntity.ok(exampleService.create(request));
    }
}
```

**Backend Service Pattern:**

```java
// ✅ GOOD: Service with constructor injection
@Service
@RequiredArgsConstructor
public class ExampleService {
    private final ExampleRepository repository;
    private final AnotherDependency dependency;

    public List<ExampleDTO> getAll() {
        return repository.findAll()
            .stream()
            .map(ExampleDTO::from)
            .collect(Collectors.toList());
    }

    @Transactional
    public ExampleDTO create(CreateExampleRequest request) {
        Example entity = new Example();
        entity.setName(request.getName());
        Example saved = repository.save(entity);
        return ExampleDTO.from(saved);
    }
}
```

**Backend Repository Pattern:**

```java
// ✅ GOOD: Spring Data JDBC repository
@Repository
public interface ExampleRepository extends CrudRepository<Example, Long> {
    @Query("SELECT * FROM examples WHERE status = :status")
    List<Example> findByStatus(String status);
}
```

**Frontend Component Pattern:**

```typescript
// ✅ GOOD: Functional component with hooks
interface Props {
    data: DataType[];
    onUpdate: (id: string) => void;
}

export function ExampleComponent({ data, onUpdate }: Props) {
    const [loading, setLoading] = useState(false);

    useEffect(() => {
        // Side effect
    }, []);

    return (
        <div className="p-4">
            {/* JSX */}
        </div>
    );
}
```

**Logging Pattern:**

```java
// ✅ GOOD: Structured logging
log.info("Processing completed: count={}, duration={}ms", count, duration);
log.error("Failed to process: id={}, error={}", id, error.getMessage(), error);
```

**Error Handling Pattern:**

```java
// ✅ GOOD: Graceful error handling
try {
    // Risky operation
} catch (Exception e) {
    log.error("Operation failed: {}", entity, e);
    // Continue processing
    return fallback;
}
```

---

## IMPLEMENTATION PLAN

### Phase 1: Foundation

<Describe foundational work needed before main implementation>

**Tasks:**

- Set up base structures (entities, DTOs, interfaces)
- Configure necessary dependencies
- Create foundational utilities or helpers

**Order:** These tasks must be completed first before moving to Phase 2.

### Phase 2: Core Implementation

<Describe the main implementation work>

**Tasks:**

- Implement core business logic in service layer
- Create REST API endpoints in controller layer
- Implement data models and repository
- Add frontend components

**Order:** Depends on Phase 1 completion.

### Phase 3: Integration

<Describe how feature integrates with existing functionality>

**Tasks:**

- Connect to existing routers/handlers
- Register new components
- Update configuration files
- Add migrations

**Order:** Depends on Phase 2 completion.

### Phase 4: Testing & Validation

<Describe testing approach>

**Tasks:**

- Implement unit tests for each component
- Create integration tests for feature workflow
- Add edge case tests
- Validate against acceptance criteria

**Order:** Can be done incrementally with each phase.

---

## STEP-BY-STEP TASKS

**IMPORTANT:** Execute every task in order, top to bottom. Each task is atomic and independently testable.

### Task Format Guidelines

Use information-dense keywords for clarity:

- **CREATE**: New files or components
- **UPDATE**: Modify existing files
- **ADD**: Insert new functionality into existing code
- **REMOVE**: Delete deprecated code
- **REFACTOR**: Restructure without changing behavior
- **MIRROR**: Copy pattern from elsewhere in codebase

### Task 1: CREATE {target_file}

- **IMPLEMENT:** {Specific implementation detail}
- **PATTERN:** {Reference to existing pattern - file:line}
- **IMPORTS:** {Required imports and dependencies}
- **GOTCHA:** {Known issues or constraints to avoid}
- **VALIDATE:** `{executable validation command}`

### Task 2: UPDATE {target_file}

- **IMPLEMENT:** {Specific implementation detail}
- **PATTERN:** {Reference to existing pattern - file:line}
- **IMPORTS:** {Required imports}
- **GOTCHA:** {Known issues}
- **VALIDATE:** `{executable validation command}`

### Task 3: CREATE {test_file}

- **IMPLEMENT:** {Test cases}
- **PATTERN:** {Reference to existing test - file:line}
- **VALIDATE:** `mvn test -Dtest={TestClass}`

<Continue with all tasks in dependency order...>

---

## TESTING STRATEGY

<Define testing approach based on project's test framework and patterns discovered during research>

### Unit Tests

**Scope and Requirements:**

- Test all public methods in services
- Test all REST endpoints in controllers
- Mock external dependencies (repositories, APIs)
- Use JUnit 5 + Mockito

**Pattern:**

```java
@Test
void shouldReturnDataWhenValidInput() {
    // Given
    ExampleDTO expected = new ExampleDTO("test");
    when(repository.findById(1L)).thenReturn(Optional.of(entity));

    // When
    ExampleDTO result = service.getById(1L);

    // Then
    assertThat(result).isEqualTo(expected);
    verify(repository).findById(1L);
}
```

### Integration Tests

**Scope and Requirements:**

- Test complete workflows
- Use @SpringBootTest with Testcontainers
- Test database operations
- Test API endpoints end-to-end

**Pattern:**

```java
@SpringBootTest
@Testcontainers
class ExampleIntegrationTest {
    @Container
    static PostgreSQLContainer<?> postgres = new PostgreSQLContainer<>("postgres:16");

    @Test
    void shouldCreateAndRetrieveData() {
        // Test complete workflow
    }
}
```

### Edge Cases

**List specific edge cases that must be tested for this feature:**

- Null inputs
- Empty collections
- External API failures
- Database connection failures
- Concurrent access
- Invalid data formats

---

## VALIDATION COMMANDS

**⚠️ CRITICAL SAFETY RULE: ALL validation must be done in LOCAL DEV MODE!**

**Environment Requirements:**
- ✅ Use `backend/.env.local` configuration (NOT `backend/.env`)
- ✅ Connect to LOCAL Docker PostgreSQL (NOT CloudProvider production)
- ✅ Start with `./start-local.sh` (NOT `./start.sh`)
- ❌ NEVER validate against CloudProvider production database

**Prerequisites:**

```bash
# 1. Start LOCAL dev environment
./start-local.sh

# 2. Verify we're in LOCAL mode
cat backend/.env.local | grep DATABASE_URL
# Expected: localhost or 127.0.0.1 (NOT production.example.com)

# 3. Verify local database is running
docker ps | grep postgres
```

**Define validation commands based on project's tools discovered in Phase 2**

Execute every command to ensure zero regressions and 100% feature correctness in **LOCAL DEV MODE**.

### Level 0: Environment Verification (CRITICAL)

```bash
# Verify LOCAL mode before proceeding
cat backend/.env.local | grep DATABASE_URL | grep -v "production.example.com" && echo "✅ SAFE: LOCAL mode" || echo "❌ UNSAFE: PRODUCTION mode detected!"
```

**Expected:** ✅ SAFE: LOCAL mode
**Expected:** Database URL contains `localhost` or `127.0.0.1`
**Unsafe:** Database URL contains `production.example.com`

**If unsafe, STOP and fix configuration immediately!**

### Level 1: Backend Compilation

```bash
cd backend && mvn clean compile
```

**Expected:** Build succeeds with no compilation errors

### Level 2: Backend Unit Tests

```bash
cd backend && mvn test
```

**Expected:** All unit tests pass, execution time < 60 seconds

### Level 3: Backend Integration Tests (LOCAL MODE)

```bash
cd backend && mvn verify -DskipUnitTests=true
```

**Expected:** All integration tests pass

**Note:** Uses LOCAL Docker PostgreSQL via `.env.local`

### Level 4: Test Coverage

```bash
cd backend && mvn jacoco:report
```

**Expected:** Coverage >= 80% for new code

### Level 5: Frontend Build

```bash
cd frontend && npm run build
```

**Expected:** Build completes successfully

### Level 6: Manual Validation (LOCAL MODE)

<Feature-specific manual testing steps - API calls, UI testing, etc.>

```bash
# Test API endpoint (LOCAL backend)
curl -X GET http://localhost:8080/api/resource

# Verify UI: Navigate to `/page` and test functionality
# Verify database: Check tables in LOCAL PostgreSQL
docker exec -it <postgres-container> psql -U example -d example -c "SELECT * FROM table_name;"
```

**All manual validation should be done against LOCAL environment only!**

---

## ACCEPTANCE CRITERIA

<List specific, measurable criteria that must be met for completion>

- [ ] Feature implements all specified functionality
- [ ] All validation commands pass with zero errors
- [ ] Unit test coverage meets requirements (80%+)
- [ ] Integration tests verify end-to-end workflows
- [ ] Code follows project conventions and patterns
- [ ] No regressions in existing functionality
- [ ] Documentation is updated (if applicable)
- [ ] Performance meets requirements (if applicable)
- [ ] Security considerations addressed (if applicable)

---

## COMPLETION CHECKLIST

- [ ] All tasks completed in order
- [ ] Each task validation passed immediately
- [ ] All validation commands executed successfully
- [ ] Full test suite passes (unit + integration)
- [ ] No linting or type checking errors
- [ ] Manual testing confirms feature works
- [ ] Acceptance criteria all met
- [ ] Code reviewed for quality and maintainability

---

## NOTES

<Additional context, design decisions, trade-offs>

**Design Rationale:**

- **Why this approach?** Explain architectural decisions
- **Alternatives considered:** List alternatives and why rejected
- **Trade-offs:** What was traded off?

**Future Considerations:**

- **Potential improvements:** What could be improved later
- **Known limitations:** What this doesn't do
- **Extension points:** How to extend in future
```

**Final Plan Review (Before Output):**

Before generating the plan file, ask yourself:

1. **Are all requirements addressed?**
   - Does the plan solve the stated problem?
   - Are all user needs met?

2. **Are there any remaining ambiguities?**
   - Unclear dependencies?
   - Missing implementation details?
   - Open questions about approach?

3. **Are there potential issues the user should know about?**
   - Identified risks or concerns?
   - Technical debt to address?
   - Assumptions that might be wrong?

**If plan is complete and clear:** Proceed to generate plan file

**If there are remaining questions or issues:** Use AskUserQuestion tool:

```
AskUserQuestion with questions about:
- Remaining ambiguities
- Risk acceptance
- Assumption verification
- Issue handling approach
```

**Then:** Use ExitPlanMode to present plan for user approval.

**Remember:** AskUserQuestion is for CLARIFICATION. ExitPlanMode is for APPROVAL.

## Spec-Kit Templates (Embedded)

When generating split artifacts, use these template structures. **Templates are embedded here** so they travel with the plugin distribution.

### Spec Template (spec.md)

```markdown
# Spec: {Feature Name}

**ID:** {XXX-feature-name}
**Status:** DRAFT
**Created:** {DATE}

## Overview

{Brief description of what this feature delivers}

## User Stories

### Story 1: {Story Title}
**As a** {type of user}
**I want** {action}
**So that** {benefit}

**Acceptance Criteria:**
- [ ] {Criteria 1}
- [ ] {Criteria 2}

## Functional Requirements

| ID | Requirement | Priority |
|----|-------------|----------|
| FR1 | {Requirement 1} | HIGH |

## Edge Cases
- {Edge case 1}

## Out of Scope
{What is explicitly NOT included}
```

### Plan Template (plan.md)

```markdown
# Plan: {Feature Name}

**Feature ID:** {XXX-feature-name}
**Status:** DRAFT
**Created:** {DATE}

## Technical Approach

{High-level technical solution}

## Architecture

### Component Diagram
```
┌─────────────┐    ┌─────────────┐
│   Frontend  │───▶│    API      │
└─────────────┘    └─────────────┘
```

## Technology Choices

| Component | Technology | Rationale |
|-----------|------------|-----------|
| API | {Choice} | {Why} |

## Security Considerations
- {Security item 1}
```

### Tasks Template (tasks.md)

```markdown
# Tasks: {Feature Name}

**Feature ID:** {XXX-feature-name}

## Task Breakdown

**Legend:**
- `[P]` = Can run in parallel
- `(file: path)` = Target file

## Story 1: {Story Name}

- [ ] Task 1.1 [P] {Task description} (file: `path/to/file.ext`)
- [ ] Task 1.2 {Task description} (depends on Task 1.1)
  - Test: `path/to/test.ext`
```

### Quickstart Template (quickstart.md)

```markdown
# Quickstart: {Feature Name}

**Feature ID:** {XXX-feature-name}

## What This Feature Does

{One-sentence description}

## Files Created:
- `path/to/file1.ext` - {Purpose}

## Test Command:
```bash
{test command}
```
```

**Note:** Replace `{PLACEHOLDERS}` with feature-specific values.

## Output Format

**Filename:** `.claude/agents/plans/{kebab-case-feature-name}.md`

**Example:** `.claude/agents/plans/example-feature-address-validation.md`

**Directory:** Create `.claude/agents/plans/` if it doesn't exist

## Quality Criteria

### Context Completeness ✓

- [ ] All necessary patterns identified and documented
- [ ] External library usage documented with links
- [ ] Integration points clearly mapped
- [ ] Gotchas and anti-patterns captured
- [ ] Every task has executable validation command

### Implementation Ready ✓

- [ ] Another developer could execute without additional context
- [ ] Tasks ordered by dependency (can execute top-to-bottom)
- [ ] Each task is atomic and independently testable
- [ ] Pattern references include specific file:line numbers

### Pattern Consistency ✓

- [ ] Tasks follow existing codebase conventions
- [ ] New patterns justified with clear rationale
- [ ] No reinvention of existing patterns or utils
- [ ] Testing approach matches project standards

### Information Density ✓

- [ ] No generic references (all specific and actionable)
- [ ] URLs include section anchors when applicable
- [ ] Task descriptions use codebase keywords
- [ ] Validation commands are non-interactable executable

## Success Metrics

**One-Pass Implementation:** Execution agent can complete feature without additional research or clarification

**Validation Complete:** Every task has at least one working validation command

**Context Rich:** The plan passes "No Prior Knowledge Test" - someone unfamiliar with codebase can implement using only plan content

**Confidence Score:** #/10 that execution will succeed on first attempt

## Report

After creating the plan, provide:

- **Summary:** Brief overview of feature and approach
- **Plan Path:** Full path to created plan file
- **Complexity Assessment:** Low/Medium/High with rationale
- **Key Risks:** Implementation risks or considerations
- **Confidence Score:** #/10 for one-pass success

---

**IMPORTANT:** Before saving the plan, verify:

1. ✅ Prime context is referenced
2. ✅ All "MUST READ" files are listed with line numbers
3. ✅ Patterns include code examples from Example codebase
4. ✅ Every task has a validation command
5. ✅ Testing strategy is specific to the feature
6. ✅ Acceptance criteria are measurable
