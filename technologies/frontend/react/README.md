# React + TypeScript

**React frontend with strict TypeScript**

---

## Overview

React is a JavaScript library for building user interfaces. Combined with TypeScript, it provides type safety and excellent developer experience.

## Version Support
- **Minimum Version**: React 18+, TypeScript 5+
- **Tested With**: React 18.2.x, TypeScript 5.3.x
- **Status**: ✅ Stable

## Prerequisites
- Node.js 18+ or 20 LTS
- npm or yarn or pnpm

## Quick Start

```bash
# Create with Vite (recommended)
npm create vite@latest my-react-app -- --template react-ts
cd my-react-app
npm install
npm run dev

# Or with Create React App (legacy)
npx create-react-app my-react-app --template typescript
cd my-react-app
npm start
```

## Project Structure

```
src/
├── components/     # Reusable components
├── pages/          # Page components
├── hooks/          # Custom hooks
├── services/       # API calls
├── types/          # TypeScript types
├── utils/          # Utility functions
├── App.tsx         # Root component
└── main.tsx        # Entry point
```

## PIV Integration

### Rules Included
Rules auto-load for files matching: `**/*.tsx`, `**/*.ts`, `package.json`, `vite.config.ts`

| Rule File | Purpose |
|-----------|---------|
| 00-overview.md | React philosophy |
| 10-setup.md | Project setup |
| 20-coding-standards.md | React/TypeScript conventions |
| 30-testing.md | Testing with Vitest/Jest |

## Key Principles

### Functional Components
Only functional components with hooks:
```typescript
interface Props {
  title: string;
  onSave: () => void;
}

export function Button({ title, onSave }: Props) {
  return <button onClick={onSave}>{title}</button>;
}
```

### TypeScript Strict Mode
Always use strict mode:
```json
{
  "compilerOptions": {
    "strict": true,
    "noUncheckedIndexedAccess": true
  }
}
```

### Custom Hooks for Logic
Extract logic into custom hooks:
```typescript
function useUsers() {
  const [users, setUsers] = useState<User[]>([]);
  const [loading, setLoading] = useState(false);

  useEffect(() => {
    fetchUsers().then(setUsers);
  }, []);

  return { users, loading };
}
```

### No Inline Styles
Use TailwindCSS or CSS modules:
```typescript
// Good: Tailwind
<button className="px-4 py-2 bg-blue-500 rounded">Click</button>

// Good: CSS Modules
<button className={styles.button}>Click</button>

// Bad: Inline styles
<button style={{padding: '1rem'}}>Click</button>
```

## Resources
- [Official React Docs](https://react.dev/)
- [TypeScript Handbook](https://www.typescriptlang.org/docs/)
- [Vite Guide](https://vitejs.dev/guide/)
- [TailwindCSS](https://tailwindcss.com/docs)

## Contributing
See [contributing guidelines](../../../../CONTRIBUTING.md)
