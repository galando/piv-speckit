# React Best Practices

**Framework:** React 18+
**Language:** TypeScript
**Build Tool:** Vite (recommended) or Next.js

## Overview

This document outlines React best practices and patterns for building type-safe, maintainable React applications.

## Table of Contents

1. [Component Design](#component-design)
2. [TypeScript Patterns](#typescript-patterns)
3. [State Management](#state-management)
4. [Data Fetching](#data-fetching)
5. [Performance](#performance)
6. [Styling](#styling)
7. [Testing](#testing)
8. [Common Patterns](#common-patterns)

---

## Component Design

### Functional Components Only

```tsx
// ✅ GOOD: Functional component with hooks
interface Props {
  title: string;
  onSave: () => void;
}

export function Button({ title, onSave }: Props) {
  const [isSaving, setIsSaving] = useState(false);

  const handleClick = async () => {
    setIsSaving(true);
    await onSave();
    setIsSaving(false);
  };

  return (
    <button onClick={handleClick} disabled={isSaving}>
      {isSaving ? 'Saving...' : title}
    </button>
  );
}

// ❌ BAD: Class component (outdated)
class Button extends React.Component {
  // Don't use class components anymore
}
```

### Component Structure

```tsx
// 1. Imports
import { useState, useEffect } from 'react';

// 2. Types/Interfaces
interface Props {
  // ...
}

// 3. Component
export function ComponentName({ prop1, prop2 }: Props) {
  // 3a. Hooks
  const [state, setState] = useState(initialValue);

  // 3b. Event handlers
  const handleClick = () => {
    // ...
  };

  // 3c. Effects
  useEffect(() => {
    // ...
  }, []);

  // 3d. Derived values
  const derivedValue = useMemo(() => {
    // ...
  }, [dependency]);

  // 3e. Render
  return (
    <div>...</div>
  );
}
```

---

## TypeScript Patterns

### Define Props Interfaces

```tsx
// ✅ GOOD: Explicit interface
interface UserCardProps {
  user: User;
  onEdit: (id: string) => void;
  onDelete: (id: string) => void;
  showActions?: boolean; // Optional prop
}

export function UserCard({ user, onEdit, onDelete, showActions = true }: UserCardProps) {
  return (
    <div>
      <h2>{user.name}</h2>
      {showActions && (
        <div>
          <button onClick={() => onEdit(user.id)}>Edit</button>
          <button onClick={() => onDelete(user.id)}>Delete</button>
        </div>
      )}
    </div>
  );
}

// ❌ BAD: No types or inline types
export function UserCard({ user, onEdit, onDelete, showActions }: any) {
  // ...
}
```

### Type Utilities

```tsx
// Extract prop types from component
type ButtonProps = ComponentProps<'button'> & {
  loading?: boolean;
};

export function Button({ loading, children, ...props }: ButtonProps) {
  return (
    <button disabled={loading} {...props}>
      {loading ? 'Loading...' : children}
    </button>
  );
}
```

---

## State Management

### When to Use What

| State Type | Solution | Scope |
|------------|----------|-------|
| Local component state | useState | Single component |
| Form state | useState + controlled inputs | Form component |
| Global UI state | Context API | Multiple components |
| Server cache | React Query / SWR | App-wide |
| Complex state | Zustand / Redux | App-wide |

### useState Patterns

```tsx
// ✅ GOOD: Simple state
const [count, setCount] = useState(0);

// ✅ GOOD: Object state with updates
const [user, setUser] = useState<User | null>(null);

const updateUser = (field: keyof User, value: string) => {
  setUser(prev => prev ? { ...prev, [field]: value } : null);
};

// ❌ BAD: Multiple related states
const [name, setName] = useState('');
const [email, setEmail] = useState('');
const [age, setAge] = useState(0);
// Should be single object or use reducer
```

### Context API for Global State

```tsx
// context/AuthContext.tsx
interface AuthContextType {
  user: User | null;
  login: (credentials: Credentials) => Promise<void>;
  logout: () => void;
}

const AuthContext = createContext<AuthContextType | null>(null);

export function AuthProvider({ children }: { children: ReactNode }) {
  const [user, setUser] = useState<User | null>(null);

  const login = async (credentials: Credentials) => {
    const user = await api.login(credentials);
    setUser(user);
  };

  const logout = () => {
    setUser(null);
  };

  return (
    <AuthContext.Provider value={{ user, login, logout }}>
      {children}
    </AuthContext.Provider>
  );
}

export function useAuth() {
  const context = useContext(AuthContext);
  if (!context) {
    throw new Error('useAuth must be used within AuthProvider');
  }
  return context;
}
```

---

## Data Fetching

### React Query (Recommended)

```tsx
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';

function UserProfile({ userId }: { userId: string }) {
  const queryClient = useQueryClient();

  // Fetch data
  const { data: user, isLoading, error } = useQuery({
    queryKey: ['user', userId],
    queryFn: () => api.getUser(userId),
  });

  // Mutation
  const updateMutation = useMutation({
    mutationFn: (data: UpdateUserDto) => api.updateUser(userId, data),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['user', userId] });
    },
  });

  if (isLoading) return <div>Loading...</div>;
  if (error) return <div>Error loading user</div>;

  return (
    <div>
      <h1>{user.name}</h1>
      <button onClick={() => updateMutation.mutate({ name: 'New Name' })}>
        Update Name
      </button>
    </div>
  );
}
```

### useEffect for Fetching (Fallback)

```tsx
function UserProfile({ userId }: { userId: string }) {
  const [user, setUser] = useState<User | null>(null);
  const [isLoading, setIsLoading] = useState(true);
  const [error, setError] = useState<Error | null>(null);

  useEffect(() => {
    let cancelled = false;

    const fetchUser = async () => {
      try {
        setIsLoading(true);
        const data = await api.getUser(userId);
        if (!cancelled) {
          setUser(data);
        }
      } catch (err) {
        if (!cancelled) {
          setError(err as Error);
        }
      } finally {
        if (!cancelled) {
          setIsLoading(false);
        }
      }
    };

    fetchUser();

    return () => {
      cancelled = true;
    };
  }, [userId]);

  if (isLoading) return <div>Loading...</div>;
  if (error) return <div>Error: {error.message}</div>;
  if (!user) return null;

  return <div>{user.name}</div>;
}
```

---

## Performance

### useMemo for Expensive Computations

```tsx
function ExpensiveList({ items }: { items: Item[] }) {
  const sortedItems = useMemo(() => {
    console.log('Sorting items...');
    return items.sort((a, b) => a.value - b.value);
  }, [items]);

  return (
    <ul>
      {sortedItems.map(item => (
        <li key={item.id}>{item.name}</li>
      ))}
    </ul>
  );
}
```

### useCallback for Stable Function References

```tsx
function Parent() {
  const [count, setCount] = useState(0);

  // Without useCallback, Child re-renders on every parent render
  const handleClick = useCallback(() => {
    setCount(c => c + 1);
  }, []);

  return <Child onClick={handleClick} />;
}
```

### Code Splitting with React.lazy

```tsx
import { lazy, Suspense } from 'react';

const HeavyComponent = lazy(() => import('./HeavyComponent'));

function App() {
  return (
    <Suspense fallback={<div>Loading...</div>}>
      <HeavyComponent />
    </Suspense>
  );
}
```

---

## Styling

### TailwindCSS (Recommended)

```tsx
// ✅ GOOD: Utility classes
export function Button({ variant = 'primary', children, ...props }: ButtonProps) {
  const baseStyles = 'px-4 py-2 rounded font-medium transition-colors';

  const variantStyles = {
    primary: 'bg-blue-600 text-white hover:bg-blue-700',
    secondary: 'bg-gray-200 text-gray-800 hover:bg-gray-300',
    danger: 'bg-red-600 text-white hover:bg-red-700',
  }[variant];

  return (
    <button className={`${baseStyles} ${variantStyles}`} {...props}>
      {children}
    </button>
  );
}

// ❌ BAD: Inline styles
export function Button({ children }) {
  return (
    <button style={{ padding: '0.5rem 1rem', borderRadius: '0.25rem' }}>
      {children}
    </button>
  );
}
```

### CSS Modules

```tsx
import styles from './Button.module.css';

export function Button({ variant, children }) {
  return (
    <button className={`${styles.button} ${styles[variant]}`}>
      {children}
    </button>
  );
}
```

---

## Testing

### Component Testing with React Testing Library

```tsx
import { render, screen, fireEvent, waitFor } from '@testing-library/react';
import { Button } from './Button';

describe('Button', () => {
  it('calls onClick when clicked', () => {
    const handleClick = jest.fn();
    render(<Button onClick={handleClick}>Click me</Button>);

    fireEvent.click(screen.getByText('Click me'));

    expect(handleClick).toHaveBeenCalledTimes(1);
  });

  it('shows loading state', () => {
    render(<Button loading={true}>Submit</Button>);

    expect(screen.getByText('Loading...')).toBeInTheDocument();
  });
});
```

### Hook Testing

```tsx
import { renderHook, act } from '@testing-library/react';
import { useCounter } from './useCounter';

describe('useCounter', () => {
  it('increments counter', () => {
    const { result } = renderHook(() => useCounter());

    act(() => {
      result.current.increment();
    });

    expect(result.current.count).toBe(1);
  });
});
```

---

## Common Patterns

### Custom Hooks

```tsx
function useLocalStorage<T>(key: string, initialValue: T) {
  const [storedValue, setStoredValue] = useState<T>(() => {
    try {
      const item = window.localStorage.getItem(key);
      return item ? JSON.parse(item) : initialValue;
    } catch (error) {
      return initialValue;
    }
  });

  const setValue = (value: T) => {
    try {
      setStoredValue(value);
      window.localStorage.setItem(key, JSON.stringify(value));
    } catch (error) {
      console.error(error);
    }
  };

  return [storedValue, setValue] as const;
}
```

### Render Props

```tsx
interface DataFetcherProps<T> {
  url: string;
  children: (data: T | null, loading: boolean, error: Error | null) => ReactNode;
}

export function DataFetcher<T>({ url, children }: DataFetcherProps<T>) {
  const [data, setData] = useState<T | null>(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<Error | null>(null);

  useEffect(() => {
    fetch(url)
      .then(res => res.json())
      .then(setData)
      .catch(setError)
      .finally(() => setLoading(false));
  }, [url]);

  return <>{children(data, loading, error)}</>;
}

// Usage
<DataFetcher<User> url="/api/user/1">
  {(user, loading, error) => {
    if (loading) return <div>Loading...</div>;
    if (error) return <div>Error: {error.message}</div>;
    if (!user) return null;
    return <div>{user.name}</div>;
  }}
</DataFetcher>
```

---

## Summary

**Key Principles:**

1. **Functional components** - Use hooks, not classes
2. **TypeScript** - Strict mode, explicit types
3. **Composition** - Prefer composition over inheritance
4. **Performance** - useMemo, useCallback, code splitting
5. **State management** - Use appropriate tool for scope
6. **Data fetching** - Prefer React Query over useEffect
7. **Styling** - TailwindCSS utility classes
8. **Testing** - React Testing Library, test behavior not implementation

**External References:**
- [React Documentation](https://react.dev/)
- [TypeScript Handbook](https://www.typescriptlang.org/docs/)
- [React Query](https://tanstack.com/query/latest)
- [React Testing Library](https://testing-library.com/react)
- [TailwindCSS](https://tailwindcss.com/docs)
