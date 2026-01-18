# API Design Rules

## RESTful Principles

- **Nouns over verbs:** `/users` not `/getUsers`
- **Plural nouns:** `/users` not `/user`
- **HTTP verbs:** GET (read), POST (create), PUT (update), DELETE (remove)
- **Resource hierarchy:** `/users/{id}/posts`

## Response Format

**Success:**
```json
{
  "data": { ... },
  "meta": { "page": 1, "total": 100 }
}
```

**Error:**
```json
{
  "error": "ErrorCode",
  "message": "Human-readable description",
  "details": { ... }
}
```

## Best Practices

- ✅ Use sensible status codes (200, 201, 400, 404, 500)
- ✅ Validate input requests
- ✅ Return consistent response structure
- ✅ Version your API (`/v1/users`)
- ✅ Rate limit endpoints
- ❌ Never expose internal IDs in URLs
- ❌ Don't nest resources more than 3 levels

**For complete guide:** `Read .claude/reference/rules-full/api-design-full.md`
