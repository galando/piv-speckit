# Issue Tracker Detection

Auto-detects issue tracker type from input arguments for unified bug fix workflows.

## Detection Function

Analyze `$ARGUMENTS` to determine the issue tracker type.

## Detection Rules (in priority order)

### 1. Direct Bug Description
- **Pattern:** `direct:`
- **Returns:** `{ type: "direct", description: "...", tracker: null }`
- **Example:** `direct:Properties with special characters cause geocoding to fail`

### 2. Jira with Instance URL
- **Pattern:** `^[A-Z]+-[0-9]+@https?://`
- **Returns:** `{ type: "jira", key: "...", url: "...", tracker: "jira" }`
- **Example:** `PROJ-123@https://jira.example.com`

### 3. Explicit Jira Prefix
- **Pattern:** `^jira:[A-Z]+-[0-9]+`
- **Returns:** `{ type: "jira", key: "...", tracker: "jira" }`
- **Example:** `jira:PROJ-123`

### 4. Jira Key Pattern (Standard)
- **Pattern:** `^[A-Z]+-[0-9]+$`
- **Returns:** `{ type: "jira", key: "...", tracker: "jira" }`
- **Example:** `PROJ-123`, `ABC-456`, `DEMO-789`

### 5. GitHub URL
- **Pattern:** `^https://github\.com/.+/issues/[0-9]+$`
- **Returns:** `{ type: "github", number: "...", repo: "...", tracker: "github" }`
- **Example:** `https://github.com/owner/repo/issues/123`

### 6. GitHub Hash Prefix
- **Pattern:** `^#[0-9]+$`
- **Returns:** `{ type: "github", number: "...", tracker: "github" }`
- **Example:** `#123`, `#456`

### 7. Default (Plain Number)
- **Pattern:** `^[0-9]+$`
- **Returns:** `{ type: "github", number: "...", tracker: "github" }`
- **Example:** `123`, `456`

## Usage in Commands

```bash
# Read detection logic
Read .claude/lib/issue-tracker/detector.md

# Apply detection to $ARGUMENTS
# Result stored in variables for subsequent operations
```

## Variables Exported

After detection, set these variables for use in commands:

| Variable | Description | Example |
|----------|-------------|---------|
| `$TRACKER_TYPE` | "github" \| "jira" \| "direct" | `github` |
| `$ISSUE_KEY` | Issue identifier | `PROJ-123` or `123` |
| `$ISSUE_URL` | Full URL (if applicable) | `https://github.com/...` |
| `$JIRA_INSTANCE` | Jira base URL (if provided) | `https://jira.example.com` |

## Detection Decision Tree

```
$ARGUMENTS
    │
    ├─ Starts with "direct:"?
    │   └─ YES → Direct bug description
    │
    ├─ Contains "@" and matches JIRA-KEY@URL?
    │   └─ YES → Jira with custom instance
    │
    ├─ Starts with "jira:"?
    │   └─ YES → Explicit Jira
    │
    ├─ Matches ^[A-Z]+-[0-9]+$?
    │   └─ YES → Jira key pattern
    │
    ├─ GitHub URL?
    │   └─ YES → GitHub issue
    │
    ├─ Starts with "#"?
    │   └─ YES → GitHub with hash prefix
    │
    └─ Plain number?
        └─ YES → GitHub (default)
```

## Regex Patterns Reference

| Use Case | Pattern | Matches |
|----------|---------|---------|
| Jira key | `^[A-Z]+-[0-9]+$` | `PROJ-123` |
| Jira with URL | `^[A-Z]+-[0-9]+@https?://.+` | `PROJ-123@https://...` |
| GitHub URL | `^https://github\.com/.+/issues/\d+$` | Full issue URL |
| GitHub hash | `^#\d+$` | `#123` |
| Plain number | `^\d+$` | `123` |
| Direct prefix | `^direct:.+` | `direct:...` |

## Example Workflows

### GitHub Issue (Plain Number)
```bash
$ARGUMENTS = "123"
→ TRACKER_TYPE = "github"
→ ISSUE_KEY = "123"
→ ISSUE_URL = null
→ Use: gh issue view 123
```

### Jira Ticket
```bash
$ARGUMENTS = "PROJ-123"
→ TRACKER_TYPE = "jira"
→ ISSUE_KEY = "PROJ-123"
→ JIRA_INSTANCE = null (uses default)
→ Use: jira issue view PROJ-123
```

### Jira with Custom Instance
```bash
$ARGUMENTS = "PROJ-123@https://custom.jira.com"
→ TRACKER_TYPE = "jira"
→ ISSUE_KEY = "PROJ-123"
→ JIRA_INSTANCE = "https://custom.jira.com"
→ Use: jira issue view PROJ-123 --server https://custom.jira.com
```

### Direct Bug Report
```bash
$ARGUMENTS = "direct:Login fails when password contains special chars"
→ TRACKER_TYPE = "direct"
→ ISSUE_KEY = null
→ Proceed with manual context gathering
```

## Edge Cases

### Ambiguous Input: `ABC-1`

**Pattern Collision Risk:** Strings matching `^[A-Z]+-[0-9]+$` (like `CONFIG-1`, `ERROR-500`, `FEATURE-123`) will be detected as Jira keys even if they're not actual Jira tickets.

**Resolution:**
- Default to Jira if pattern matches (assumes user intent)
- User can override with explicit `#` prefix for GitHub: `#1`
- User can use `jira:` prefix to force Jira detection when uncertain
- For non-tracker strings, use `direct:` prefix

**Examples:**
| Input | Detected | Override Option |
|-------|----------|-----------------|
| `FEATURE-123` | Jira | Use `#123` for GitHub or `direct:FEATURE-123` |
| `CONFIG-1` | Jira | Use `#1` for GitHub |
| `ERROR-500` | Jira | Use `direct:ERROR-500` |

### Mixed Environments (GitHub + Jira)
- Some teams use Jira for GitHub repos
- **Resolution:** Detect based on input format
- Branch naming uses detected tracker's format

## Integration Points

This detection module is used by:
- `.claude/commands/bug_fix/rca.md` - Root Cause Analysis
- `.claude/commands/bug_fix/implement-fix.md` - Fix implementation
- `.claude/commands/piv_loop/plan-feature.md` - Feature planning

## Testing

Test inputs and expected outputs:

| Input | Tracker | Key |
|-------|---------|-----|
| `123` | github | `123` |
| `#456` | github | `456` |
| `https://github.com/org/repo/issues/789` | github | `789` |
| `PROJ-123` | jira | `PROJ-123` |
| `PROJ-123@https://jira.example.com` | jira | `PROJ-123` |
| `jira:PROJ-456` | jira | `PROJ-456` |
| `direct:Bug description` | direct | N/A |
