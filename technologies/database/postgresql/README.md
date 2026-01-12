# PostgreSQL

**Relational database with PostgreSQL**

---

## Overview

PostgreSQL is a powerful, open source object-relational database system with over 35 years of active development.

## Version Support
- **Minimum Version**: PostgreSQL 14+
- **Tested With**: PostgreSQL 16.x
- **Status**: ✅ Stable

## Prerequisites
- PostgreSQL 14+ installed locally, or
- Docker for containerized PostgreSQL

## Quick Start

```bash
# With Docker
docker run --name postgres -e POSTGRES_PASSWORD=mysecretpassword \
  -p 5432:5432 -d postgres:16-alpine

# Connect
psql -h localhost -U postgres

# Create database
CREATE DATABASE myapp;
\c myapp
```

## Schema Best Practices

### Naming Conventions
- Tables: `snake_case`, plural
- Columns: `snake_case`
- Primary keys: `id` (UUID or auto-increment)
- Foreign keys: `{table}_id`
- Indexes: `idx_{table}_{column}`
- Unique constraints: `uq_{table}_{column}`

### Example Schema
```sql
CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    email VARCHAR(255) NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE UNIQUE INDEX uq_users_email ON users(email);

CREATE INDEX idx_users_created_at ON users(created_at);
```

## PIV Integration

### Rules Included
Rules auto-load for files matching: `**/*.sql`, `**/schema.sql`, `migrations/*.sql`

| Rule File | Purpose |
|-----------|---------|
| 00-overview.md | PostgreSQL philosophy |
| 10-setup.md | Database setup |
| 20-schema-design.md | Schema best practices |
| 30-query-patterns.md | Common query patterns |

## Key Principles

### Use Transactions
Always wrap multi-step operations in transactions:
```sql
BEGIN;
INSERT INTO users (email, password_hash) VALUES (...);
INSERT INTO user_profiles (user_id, ...) VALUES (...);
COMMIT;
-- Or ROLLBACK on error
```

### Parameterized Queries
Never concatenate user input:
```sql
-- GOOD
SELECT * FROM users WHERE id = $1;

-- BAD
SELECT * FROM users WHERE id = '{user_input}';
```

### Foreign Keys
Use foreign keys for referential integrity:
```sql
ALTER TABLE posts
ADD CONSTRAINT fk_posts_user_id
FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE;
```

### Indexes Strategically
Index columns used in WHERE, JOIN, ORDER BY:
```sql
-- Good: For lookup
CREATE INDEX idx_users_email ON users(email);

-- Good: For sorting
CREATE INDEX idx_posts_created_at ON posts(created_at DESC);

-- Bad: Low cardinality
CREATE INDEX idx_users_status ON users(status); -- status has few values
```

## Common Patterns

### UUID Primary Keys
```sql
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    -- ...
);
```

### Timestamps with Timezone
```sql
CREATE TABLE users (
    -- Always use TIMESTAMPTZ
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Update trigger
CREATE OR REPLACE FUNCTION update_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_users_updated_at
    BEFORE UPDATE ON users
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at();
```

### Soft Deletes
```sql
ALTER TABLE users ADD COLUMN deleted_at TIMESTAMPTZ;

-- Always filter
SELECT * FROM users WHERE deleted_at IS NULL;

-- Soft delete
UPDATE users SET deleted_at = NOW() WHERE id = $1;
```

## Resources
- [Official Documentation](https://www.postgresql.org/docs/)
- [SQL Style Guide](https://www.sqlstyle.guide/)
- [PostgreSQL Exercises](https://pgexercises.com/)

## Contributing
See [contributing guidelines](../../../../CONTRIBUTING.md)
