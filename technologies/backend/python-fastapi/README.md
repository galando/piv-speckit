# Python + FastAPI

**Modern Python async framework with FastAPI**

---

## Overview

FastAPI is a modern, fast (high-performance) web framework for building APIs with Python 3.8+ based on standard Python type hints.

## Version Support
- **Minimum Version**: Python 3.8+, FastAPI 0.100+
- **Tested With**: Python 3.11, FastAPI 0.110.x
- **Status**: ✅ Stable

## Prerequisites
- Python 3.8+
- pip or poetry

## Quick Start

```bash
# Create project
mkdir my-fastapi-app
cd my-fastapi-app

# Install FastAPI
pip install fastapi uvicorn

# Create app
cat > main.py << 'EOF'
from fastapi import FastAPI
app = FastAPI()

@app.get("/")
def read_root():
    return {"Hello": "World"}
EOF

# Run
uvicorn main:app --reload
```

## Project Structure

```
app/
├── api/            # API routes
├── models/         # Pydantic models
├── services/       # Business logic
├── repositories/   # Data access
├── schemas/        # Request/response schemas
├── core/           # Config, security
└── main.py         # Application entry
```

## PIV Integration

### Rules Included
Rules auto-load for files matching: `**/*.py`, `pyproject.toml`, `requirements.txt`

| Rule File | Purpose |
|-----------|---------|
| 00-overview.md | FastAPI philosophy |
| 10-setup.md | Project setup |
| 20-coding-standards.md | Python conventions |
| 30-testing.md | Testing with pytest |

## Key Principles

### Type Hints Required
Always use type hints:
```python
def create_user(email: str, password: str) -> User:
    return User(email=email, password_hash=hash_password(password))
```

### Pydantic for Validation
Use Pydantic models for all data:
```python
class UserCreate(BaseModel):
    email: EmailStr
    password: SecretStr
```

### Async by Default
Use async for I/O operations:
```python
@app.get("/users/{user_id}")
async def get_user(user_id: int):
    return await user_service.find_by_id(user_id)
```

### Dependency Injection
FastAPI's dependency system is powerful:
```python
@app.get("/users/{user_id}")
async def get_user(
    user_id: int,
    service: UserService = Depends(get_user_service)
):
    return await service.find_by_id(user_id)
```

## Resources
- [Official Documentation](https://fastapi.tiangolo.com/)
- [Tutorial](https://fastapi.tiangolo.com/tutorial/)
- [Pydantic](https://docs.pydantic.dev/)

## Contributing
See [contributing guidelines](../../../../CONTRIBUTING.md)
