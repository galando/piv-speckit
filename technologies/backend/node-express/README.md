# Node.js + Express

**JavaScript/TypeScript backend with Express framework**

---

## Overview

Express is a minimal and flexible Node.js web application framework that provides a robust set of features for web and mobile applications.

## Version Support
- **Minimum Version**: Node 18+, Express 4.18+
- **Tested With**: Node 20 LTS, Express 4.19.x
- **Status**: ✅ Stable

## Prerequisites
- Node.js 18+ or 20 LTS
- npm or yarn or pnpm

## Quick Start

```bash
# Create project
mkdir my-express-app
cd my-express-app
npm init -y

# Install dependencies
npm install express

# Create server
cat > index.js << 'EOF'
import express from 'express';
const app = express();
app.get('/', (req, res) => res.send('Hello World'));
app.listen(3000);
EOF

# Run
node index.js
```

## Project Structure

```
src/
├── controllers/    # Request handlers
├── services/       # Business logic
├── repositories/   # Data access
├── middleware/     # Express middleware
├── routes/         # Route definitions
├── models/         # Data models
└── utils/          # Utilities
```

## PIV Integration

### Rules Included
Rules auto-load for files matching: `**/*.js`, `**/*.ts`, `package.json`

| Rule File | Purpose |
|-----------|---------|
| 00-overview.md | Express philosophy |
| 10-setup.md | Project setup |
| 20-coding-standards.md | JavaScript/TypeScript conventions |
| 30-testing.md | Testing with Jest/Vitest |

## Key Principles

### TypeScript Preferred
Use TypeScript for type safety:
```typescript
interface CreateUserRequest {
  email: string;
  password: string;
}
```

### Async/Await
Always use async/await over callbacks:
```typescript
app.get('/users/:id', async (req, res) => {
  const user = await userService.findById(req.params.id);
  res.json(user);
});
```

### Middleware Pattern
Express is all about middleware:
```typescript
app.use(express.json());
app.use(loggingMiddleware);
app.use(errorHandler);
```

## Resources
- [Official Documentation](https://expressjs.com/)
- [TypeScript Express Guide](https://github.com/DefinitelyTyped/express)
- [Best Practices](https://github.com/goldbergyoni/nodebestpractices)

## Contributing
See [contributing guidelines](../../../../CONTRIBUTING.md)
