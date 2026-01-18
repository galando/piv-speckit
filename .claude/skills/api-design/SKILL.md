---
description: Enforces REST API best practices
triggers:
  - file_pattern: "*Controller.java;*Router.ts;api/*.ts;routes/*.js"
---

# API Design Skill

**Checks:**
- HTTP methods correct (GET/POST/PUT/DELETE)
- DTOs only (NO entities)
- RESTful names (/users not /getUsers)
- Status codes (200/201/204/400/404)
- @Valid on request bodies
- Error handling
- Auth on protected endpoints

`Read .claude/reference/skills-full/api-design-full.md`
