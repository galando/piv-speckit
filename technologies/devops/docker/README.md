# Docker

**Containerization with Docker**

---

## Overview

Docker enables you to separate your applications from your infrastructure so you can deliver software quickly.

## Version Support
- **Minimum Version**: Docker 24.0+, Docker Compose v2
- **Tested With**: Docker 24.x, Docker Compose 2.20.x
- **Status**: ✅ Stable

## Prerequisites
- Docker Desktop or Docker Engine installed
- Basic understanding of containers

## Quick Start

```bash
# Create Dockerfile
cat > Dockerfile << 'EOF'
FROM node:20-alpine
WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production
COPY . .
EXPOSE 3000
CMD ["npm", "start"]
EOF

# Build and run
docker build -t myapp .
docker run -p 3000:3000 myapp
```

## Project Structure

```
├── Dockerfile          # Application image
├── docker-compose.yml  # Multi-container setup
├── .dockerignore       # Files to exclude
└── docker/             # Docker-specific files
    ├── nginx.conf
    └── entrypoint.sh
```

## PIV Integration

### Rules Included
Rules auto-load for files matching: `Dockerfile*`, `docker-compose*.yml`, `.dockerignore`

| Rule File | Purpose |
|-----------|---------|
| 00-overview.md | Docker philosophy |
| 10-setup.md | Docker setup |
| 20-best-practices.md | Docker best practices |
| 30-multi-stage.md | Multi-stage builds |

## Key Principles

### Use Official Base Images
```dockerfile
# Good: Official, minimal image
FROM node:20-alpine

# Bad: Unofficial, large image
FROM random-user/node
```

### Multi-Stage Builds
Reduce final image size:
```dockerfile
# Build stage
FROM node:20 AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

# Production stage
FROM node:20-alpine
WORKDIR /app
COPY --from=builder /app/dist ./dist
COPY package*.json ./
RUN npm ci --only=production
CMD ["npm", "start"]
```

### .dockerignore
Exclude unnecessary files:
```
node_modules
npm-debug.log
.git
.env
README.md
```

### Non-Root User
Run as non-root for security:
```dockerfile
RUN addgroup -g 1001 -S nodejs
RUN adduser -S nodejs -u 1001
USER nodejs
```

## Common Patterns

### Development with Compose
```yaml
version: '3.8'
services:
  app:
    build: .
    ports:
      - "3000:3000"
    volumes:
      - .:/app
      - /app/node_modules
    environment:
      - NODE_ENV=development

  postgres:
    image: postgres:16-alpine
    environment:
      POSTGRES_PASSWORD: secret
    ports:
      - "5432:5432"
    volumes:
      - postgres-data:/var/lib/postgresql/data

volumes:
  postgres-data:
```

### Production with Compose
```yaml
version: '3.8'
services:
  app:
    image: myapp:latest
    restart: always
    ports:
      - "3000:3000"
    environment:
      - NODE_ENV=production
    depends_on:
      - postgres

  postgres:
    image: postgres:16-alpine
    restart: always
    environment:
      POSTGRES_PASSWORD: ${POSTGRES_PASSWORD}
    volumes:
      - postgres-data:/var/lib/postgresql/data

volumes:
  postgres-data:
```

### Health Checks
```dockerfile
HEALTHCHECK --interval=30s --timeout=3s \
  CMD curl -f http://localhost:3000/health || exit 1
```

## Best Practices

### Image Optimization
- Use minimal base images (alpine, distroless)
- Multi-stage builds
- Combine RUN statements
- Clean up in same layer

### Security
- Scan images: `docker scan myapp:latest`
- Use specific versions, not `latest`
- Run as non-root
- Don't include secrets

### Caching
Order instructions to maximize cache:
```dockerfile
# Good: Dependencies change less often
COPY package*.json ./
RUN npm ci
COPY . .

# Bad: Copies everything first
COPY . .
RUN npm ci
```

## Resources
- [Official Documentation](https://docs.docker.com/)
- [Dockerfile Best Practices](https://docs.docker.com/develop/develop-images/dockerfile_best-practices/)
- [Compose Reference](https://docs.docker.com/compose/compose-file/)

## Contributing
See [contributing guidelines](../../../../CONTRIBUTING.md)
