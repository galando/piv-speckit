# PostgreSQL Best Practices

**Database:** PostgreSQL 14+ (prefer 16)

## Overview

This document outlines PostgreSQL best practices and patterns for building efficient, maintainable database schemas.

## Table of Contents

1. [Schema Design](#schema-design)
2. [Naming Conventions](#naming-conventions)
3. [Data Types](#data-types)
4. [Indexes](#indexes)
5. [Constraints](#constraints)
6. [Performance](#performance)
7. [Security](#security)
8. [Migration Strategy](#migration-strategy)

---

## Schema Design

### Table Organization

**Principles:**
- Normalize to 3NF (Third Normal Form)
- Denormalize only for proven performance reasons
- Use joins, avoid duplicate data
- Separate concerns (users, user_profiles, etc.)

### Example Schema

```sql
-- Users table (core data)
CREATE TABLE users (
    id BIGSERIAL PRIMARY KEY,
    email VARCHAR(255) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- User profiles (extended data, one-to-one)
CREATE TABLE user_profiles (
    user_id BIGINT PRIMARY KEY REFERENCES users(id) ON DELETE CASCADE,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    bio TEXT,
    birth_date DATE
);

-- Posts (many-to-one with users)
CREATE TABLE posts (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    title VARCHAR(255) NOT NULL,
    content TEXT NOT NULL,
    published_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ DEFAULT NOW()
);
```

---

## Naming Conventions

### General Rules

- **Tables:** `snake_case`, plural (`users`, `user_profiles`)
- **Columns:** `snake_case` (`created_at`, `first_name`)
- **Primary keys:** `id` (auto-increment or UUID)
- **Foreign keys:** `{table}_id` (`user_id`, `post_id`)
- **Indexes:** `idx_{table}_{column}` (`idx_users_email`)
- **Unique constraints:** `uq_{table}_{column}` (`uq_users_email`)
- **Check constraints:** `chk_{table}_{condition}` (`chk_users_age`)

### Examples

```sql
-- Good naming
CREATE TABLE user_orders (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL REFERENCES users(id),
    order_date TIMESTAMPTZ DEFAULT NOW(),
    status VARCHAR(50) NOT NULL,
    CONSTRAINT chk_user_orders_status
        CHECK (status IN ('pending', 'processing', 'completed', 'cancelled'))
);

CREATE INDEX idx_user_orders_user_id ON user_orders(user_id);
CREATE INDEX idx_user_orders_status ON user_orders(status);
CREATE INDEX idx_user_orders_date ON user_orders(order_date DESC);
```

---

## Data Types

### Common Data Types

| Purpose | Type | Notes |
|---------|------|-------|
| Primary keys | `BIGSERIAL`, `UUID` | Use UUID for distributed systems |
| Foreign keys | `BIGINT`, `UUID` | Match referenced primary key |
| Text data | `TEXT` | No length limit, prefer over VARCHAR |
| Short text | `VARCHAR(n)` | Use only when length constraint matters |
| Email | `VARCHAR(255)` | Standard email length |
| URLs | `VARCHAR(2048)` | Accommodate long URLs |
| Money | `NUMERIC(19,4)` | Exact precision for financial data |
| Percentages | `DECIMAL(5,2)` | 0.00 to 100.00 |
| Dates | `DATE` | Calendar date (no time) |
| Timestamps | `TIMESTAMPTZ` | Always use timezone-aware |
| Booleans | `BOOLEAN` | True/false/null |
| JSON | `JSONB` | Binary JSON, indexed |
| Arrays | `TEXT[]`, `INTEGER[]` | PostgreSQL-specific arrays |

### Examples

```sql
CREATE TABLE products (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    price NUMERIC(19,4) NOT NULL,  -- Money
    discount_percent DECIMAL(5,2), -- 0.00 to 100.00
    active BOOLEAN DEFAULT true,
    tags TEXT[],                    -- Array of tags
    metadata JSONB,                 -- Flexible metadata
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);
```

---

## Indexes

### When to Create Indexes

**Create indexes on:**
- Columns in WHERE clauses
- Columns in JOIN conditions
- Columns in ORDER BY
- Columns frequently queried together (composite)

**Don't create indexes on:**
- Low cardinality columns (status, type, boolean)
- Tables rarely read
- Columns in small tables (< 1000 rows)

### Index Examples

```sql
-- Single column index
CREATE INDEX idx_users_email ON users(email);

-- Composite index (order matters!)
CREATE INDEX idx_posts_user_id_date ON posts(user_id, published_at DESC);

-- Partial index (only index specific rows)
CREATE INDEX idx_orders_processing ON orders(status)
WHERE status = 'processing';

-- Unique index
CREATE UNIQUE INDEX idx_users_email ON users(email);
```

### Index Best Practices

```sql
-- ✅ GOOD: Composite index for common query pattern
CREATE INDEX idx_posts_user_status_date ON posts(user_id, status, created_at DESC);
-- Query: SELECT * FROM posts WHERE user_id = ? AND status = ? ORDER BY created_at DESC

-- ❌ BAD: Index on low cardinality
CREATE INDEX idx_posts_status ON posts(status);
-- Status only has 3-4 values, index won't help much

-- ✅ GOOD: Partial index for common filter
CREATE INDEX idx_active_users ON users(email) WHERE active = true;
-- Only indexes active users, smaller index

-- ✅ GOOD: Covering index (include columns)
CREATE INDEX idx_orders_covering ON orders(user_id, status) INCLUDE (total);
-- Can satisfy query without accessing table
```

---

## Constraints

### Primary Keys

```sql
-- Auto-increment (default)
CREATE TABLE users (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(255)
);

-- UUID (for distributed systems)
CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(255)
);
```

### Foreign Keys

```sql
-- Foreign key with CASCADE delete
ALTER TABLE posts
ADD CONSTRAINT fk_posts_user
FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE;

-- Foreign key with RESTRICT (default)
ALTER TABLE posts
ADD CONSTRAINT fk_posts_user
FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE RESTRICT;

-- Foreign key with SET NULL
ALTER TABLE posts
ADD CONSTRAINT fk_posts_user
FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL;
```

### Unique Constraints

```sql
-- Single column unique
ALTER TABLE users
ADD CONSTRAINT uq_users_email UNIQUE (email);

-- Composite unique (multi-column)
ALTER TABLE user_votes
ADD CONSTRAINT uq_user_vote UNIQUE (user_id, post_id);
-- Each user can vote only once per post
```

### Check Constraints

```sql
-- Ensure age is valid
ALTER TABLE users
ADD CONSTRAINT chk_users_age CHECK (age >= 18);

-- Ensure price is positive
ALTER TABLE products
ADD CONSTRAINT chk_products_price CHECK (price > 0);

-- Ensure status is valid
ALTER TABLE orders
ADD CONSTRAINT chk_orders_status
CHECK (status IN ('pending', 'processing', 'completed', 'cancelled'));
```

---

## Performance

### Query Optimization

**Use EXPLAIN ANALYZE:**

```sql
EXPLAIN ANALYZE
SELECT u.name, COUNT(p.id)
FROM users u
LEFT JOIN posts p ON p.user_id = u.id
WHERE u.active = true
GROUP BY u.id;
```

**Avoid N+1 queries:**

```sql
-- ❌ BAD: N+1 problem
-- For each user, query their posts
SELECT * FROM users;  -- 1 query
SELECT * FROM posts WHERE user_id = 1;  -- N queries

-- ✅ GOOD: Use JOIN or IN clause
SELECT u.*, COUNT(p.id) as post_count
FROM users u
LEFT JOIN posts p ON p.user_id = u.id
GROUP BY u.id;  -- 1 query
```

### Connection Pooling

```properties
# HikariCP configuration
spring.datasource.hikari.maximum-pool-size=10
spring.datasource.hikari.minimum-idle=5
spring.datasource.hikari.connection-timeout=30000
```

---

## Security

### Least Privilege

```sql
-- Create read-only user
CREATE USER readonly_user WITH PASSWORD 'secure_password';
GRANT CONNECT ON DATABASE mydb TO readonly_user;
GRANT USAGE ON SCHEMA public TO readonly_user;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO readonly_user;
```

### Input Validation

```sql
-- Use parameterized queries (prepared statements)
-- ✅ GOOD
SELECT * FROM users WHERE id = $1;

-- ❌ BAD (SQL injection risk)
SELECT * FROM users WHERE id = '{user_input}';
```

### Sensitive Data

```sql
-- Encrypt sensitive columns
CREATE TABLE users (
    id BIGSERIAL PRIMARY KEY,
    email VARCHAR(255) NOT NULL UNIQUE,
    -- Store password hash, never plain text
    password_hash VARCHAR(255) NOT NULL,
    -- Use pgcrypto for encryption
    ssn_encrypted BYTEA
);

-- Enable pgcrypto extension
CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- Encrypt data
INSERT INTO users (email, password_hash, ssn_encrypted)
VALUES ('user@example.com', 'hash', pgp_sym_encrypt('123-45-6789', 'encryption_key'));
```

---

## Migration Strategy

### Versioned Migrations

```sql
-- V1__create_initial_schema.sql
CREATE TABLE users (
    id BIGSERIAL PRIMARY KEY,
    email VARCHAR(255) NOT NULL UNIQUE,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- V2__add_users_table.sql
CREATE TABLE posts (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL REFERENCES users(id),
    title VARCHAR(255) NOT NULL,
    content TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- V3__add_index_on_posts.sql
CREATE INDEX idx_posts_user_id ON posts(user_id);
CREATE INDEX idx_posts_created_at ON posts(created_at DESC);
```

### Migration Rules

1. **NEVER** modify existing migrations
2. **ALWAYS** create new migration for changes
3. **TEST** migrations on local database first
4. **USE** transactions for multi-step migrations
5. **BACKWARD** compatible when possible

### Rollback Strategy

```sql
-- V3__add_index_on_posts.sql
-- To rollback: DROP INDEX CONCURRENTLY idx_posts_user_id;
CREATE INDEX CONCURRENTLY idx_posts_user_id ON posts(user_id);
```

---

## Summary

**Key Principles:**

1. **Naming:** `snake_case`, plural tables, clear prefixes
2. **Types:** Use appropriate types (TEXT, JSONB, TIMESTAMPTZ)
3. **Indexes:** On WHERE/JOIN columns, not low cardinality
4. **Constraints:** Primary keys, foreign keys, unique, check
5. **Performance:** EXPLAIN ANALYZE, avoid N+1, connection pooling
6. **Security:** Parameterized queries, least privilege, encryption
7. **Migrations:** Versioned, never modify, test first

**External References:**
- [PostgreSQL Documentation](https://www.postgresql.org/docs/)
- [PostgreSQL Exercises](https://pgexercises.com/)
- [SQL Style Guide](https://www.sqlstyle.guide/)
