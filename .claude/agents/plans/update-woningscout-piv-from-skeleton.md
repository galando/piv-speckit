# Feature: Update WoningScout PIV Methodology from Skeleton

**Created**: 2025-01-11
**Status**: Planned
**Priority**: High - Align with latest PIV methodology v1.0

## Context

WoningScout has an outdated PIV implementation (manual validation) compared to the skeleton's latest PIV v1.0 (automatic validation). The skeleton contains:
- Complete PIV-METHODOLOGY.md (missing in WoningScout)
- Universal rules system (missing in WoningScout)
- Automatic validation triggers (manual in WoningScout)
- Latest command definitions (outdated in WoningScout)

WoningScout has excellent domain-specific content that should be preserved:
- Comprehensive backend rules (scraping, data quality, market trends)
- Excellent reference documentation
- Rich agent artifacts structure
- Project-specific commands (publishers, performance audits, etc.)

## Requirements

### Functional Requirements
- [ ] FR-1: Add skeleton's PIV-METHODOLOGY.md as universal reference
- [ ] FR-2: Add universal rules from skeleton (00-general, 10-git, 20-testing, 21-testing, 30-documentation, 40-security)
- [ ] FR-3: Update PIV core commands to support automatic validation
- [ ] FR-4: Merge skeleton's backend rules with WoningScout's domain-specific rules
- [ ] FR-5: Update validation commands to match skeleton's latest version
- [ ] FR-6: Preserve all WoningScout-specific content (commands, rules, references, agents)

### Non-Functional Requirements
- [ ] NFR-1: No breaking changes to existing WoningScout workflows
- [ ] NFR-2: Maintain backward compatibility with existing commands
- [ ] NFR-3: Zero downtime during update
- [ ] NFR-4: All existing functionality must continue working

## Technical Approach

### Strategy
**Hybrid Approach**: Add skeleton's universal foundation while preserving WoningScout's domain-specific enhancements

### Architecture
```
WoningScout .claude/ Structure (After Update):

.claude/
├── PIV-METHODOLOGY.md          # NEW - Universal methodology (from skeleton)
├── CLAUDE.md                    # UPDATE - Reference universal methodology
├── PIV-ADOPTION-GUIDE.md        # KEEP - WoningScout-specific guide
├── GIT_PERMISSIONS_GUIDE.md     # KEEP - Project-specific
├── INSTRUCTIONS.md              # KEEP - Project-specific
├── rules/
│   ├── 00-general.md           # NEW - Universal principles
│   ├── 10-git.md               # NEW - Git workflow
│   ├── 20-testing.md           # NEW - Testing philosophy
│   ├── 21-testing.md           # NEW - Given-When-When pattern
│   ├── 30-documentation.md     # NEW - Documentation standards
│   ├── 40-security.md          # NEW - Security guidelines
│   ├── README.md               # KEEP - Rules overview
│   ├── anti-patterns.md        # KEEP - WoningScout patterns
│   ├── code-review.md          # KEEP - WoningScout guidelines
│   ├── environment.md          # KEEP - LOCAL vs PROD
│   ├── testing.md              # KEEP - WoningScout testing
│   └── backend/
│       ├── 10-api-design.md    # MERGE - Skeleton + WoningScout
│       ├── 20-database.md      # MERGE - Skeleton + WoningScout
│       ├── api-design.md       # KEEP - WoningScout version
│       ├── database.md         # KEEP - WoningScout version
│       ├── data-quality.md     # KEEP - WoningScout-specific
│       ├── email.md            # KEEP - WoningScout-specific
│       ├── market-trends.md    # KEEP - WoningScout-specific
│       ├── monitoring.md       # KEEP - WoningScout-specific
│       ├── scraping.md         # KEEP - WoningScout-specific
│       └── security.md         # KEEP - WoningScout version
├── commands/
│   ├── piv_loop/
│   │   ├── prime.md            # UPDATE - Merge skeleton + WoningScout customizations
│   │   ├── plan-feature.md     # UPDATE - Merge skeleton + WoningScout customizations
│   │   └── execute.md          # UPDATE - Add automatic validation trigger
│   ├── validation/
│   │   ├── validate.md         # UPDATE - Support automatic execution
│   │   ├── code-review.md      # UPDATE - Sync with skeleton
│   │   ├── code-review-fix.md  # UPDATE - Sync with skeleton
│   │   ├── execution-report.md # UPDATE - Sync with skeleton
│   │   └── system-review.md    # UPDATE - Sync with skeleton
│   ├── bug_fix/
│   │   ├── rca.md              # UPDATE - Sync with skeleton
│   │   └── implement-fix.md     # UPDATE - Sync with skeleton
│   └── [WoningScout-specific commands]  # KEEP - All 13+ commands
├── agents/
│   ├── context/                # KEEP
│   ├── plans/                  # KEEP
│   ├── reports/                # KEEP
│   ├── reviews/                # KEEP
│   ├── code-reviews/           # KEEP
│   ├── system-reviews/         # KEEP
│   ├── rcas/                   # KEEP
│   ├── validation-reports/     # KEEP
│   └── [other agents]          # KEEP
├── reference/                  # KEEP - All excellent docs
│   ├── geoapify-client-api.md
│   ├── java-24-modern-patterns.md
│   ├── jsoup-element-api.md
│   ├── postgresql-patterns.md
│   ├── react-frontend-best-practices.md
│   ├── spring-boot-best-practices.md
│   ├── spring-data-jdbc-patterns.md
│   ├── spring-test-configuration.md
│   └── [... more ...]
└── skills/                     # KEEP - Project-specific skills
```

### Patterns
1. **Preserve-First Strategy**: Keep WoningScout's content, add skeleton's universal content
2. **Merge Strategy**: For files in both, merge content (skeleton universal + WoningScout specific)
3. **Backup Strategy**: Create `.pre-piv-update` backups before modifying
4. **Validation Strategy**: Run PIV validation after update to ensure nothing breaks

### Trade-offs
- **Pro**: WoningScout gets latest PIV methodology with automatic validation
- **Pro**: Universal rules provide best practices WoningScout may be missing
- **Con**: Update requires careful merging to avoid losing WoningScout customizations
- **Con**: Some duplicate content may exist temporarily (clean up in follow-up)

### Dependencies
- WoningScout project must be accessible
- Skeleton PIV files must be available
- Git backup recommended before update

## Implementation Steps

### Step 1: Backup Current Configuration
**Purpose**: Ensure we can rollback if needed

**Files**:
- `.claude/` directory (entire backup)

**Actions**:
```bash
cd /Users/galando/dev/woningscout
cp -r .claude .claude.backup-before-piv-update-$(date +%Y%m%d)
```

**Notes**: Create timestamped backup of entire `.claude/` directory

---

### Step 2: Add Universal Methodology File
**Purpose**: Provide complete PIV methodology reference

**Files**:
- Create: `.claude/PIV-METHODOLOGY.md`
- Update: `.claude/CLAUDE.md` (add reference to methodology)

**Actions**:
```bash
# Copy from skeleton
cp /Users/galando/dev/claude-piv-skeleton/.claude/PIV-METHODOLOGY.md \
   /Users/galando/dev/woningscout/.claude/PIV-METHODOLOGY.md

# Update CLAUDE.md to reference it
```

**Notes**: This is the critical missing file - complete methodology guide

---

### Step 3: Add Universal Rules
**Purpose**: Add skeleton's universal best practices

**Files**:
- Create: `.claude/rules/00-general.md`
- Create: `.claude/rules/10-git.md`
- Create: `.claude/rules/20-testing.md`
- Create: `.claude/rules/21-testing.md`
- Create: `.claude/rules/30-documentation.md`
- Create: `.claude/rules/40-security.md`

**Actions**:
```bash
cd /Users/galando/dev/woningscout/.claude/rules/

# Copy universal rules from skeleton
for file in 00-general.md 10-git.md 20-testing.md 21-testing.md 30-documentation.md 40-security.md; do
    cp /Users/galando/dev/claude-piv-skeleton/.claude/rules/$file .
done
```

**Notes**: These complement WoningScout's domain-specific rules, don't replace them

---

### Step 4: Update PIV Core Commands
**Purpose**: Add automatic validation and latest improvements

**Files**:
- Update: `.claude/commands/piv_loop/prime.md`
- Update: `.claude/commands/piv_loop/plan-feature.md`
- Update: `.claude/commands/piv_loop/execute.md` (CRITICAL)

**Actions**:
For each command file:
1. Read skeleton version
2. Read WoningScout version
3. Identify WoningScout-specific customizations
4. Merge skeleton's automatic validation logic
5. Preserve WoningScout's Java/Spring Boot specifics
6. Test that command still works

**Critical Change**: `execute.md` must trigger automatic validation at end

**Notes**: Most careful step - must preserve WoningScout customizations

---

### Step 5: Update Validation Commands
**Purpose**: Support automatic validation execution

**Files**:
- Update: `.claude/commands/validation/validate.md`
- Update: `.claude/commands/validation/code-review.md`
- Update: `.claude/commands/validation/code-review-fix.md`
- Update: `.claude/commands/validation/execution-report.md`
- Update: `.claude/commands/validation/system-review.md`

**Actions**:
```bash
# Update validation commands to support automatic execution
# Key change: validate.md must work non-interactively when called from execute
```

**Notes**: WoningScout has environment checks (LOCAL vs PROD) - preserve these

---

### Step 6: Update Bug Fix Commands
**Purpose**: Sync with skeleton's latest versions

**Files**:
- Update: `.claude/commands/bug_fix/rca.md`
- Update: `.claude/commands/bug_fix/implement-fix.md`

**Actions**: Copy from skeleton, verify no WoningScout-specific customizations lost

**Notes**: These commands are likely identical between projects

---

### Step 7: Merge Backend Rules
**Purpose**: Add skeleton's universal backend principles to WoningScout's domain-specific rules

**Files**:
- Update: `.claude/rules/backend/10-api-design.md` (merge with existing api-design.md)
- Update: `.claude/rules/backend/20-database.md` (merge with existing database.md)

**Actions**:
1. Read skeleton backend rules
2. Read WoningScout backend rules
3. Merge skeleton's universal principles with WoningScout's practices
4. Keep both versions if content is complementary

**Notes**: WoningScout has more comprehensive rules - enhance, don't replace

---

### Step 8: Verification
**Purpose**: Ensure update didn't break anything

**Actions**:
1. Test all PIV commands still work
2. Verify WoningScout-specific commands still work
3. Check that CLAUDE.md references are correct
4. Run manual validation to ensure nothing broke
5. Verify git status shows expected changes only

**Notes**: This is a quality gate - fix any issues before proceeding

---

## Files to Create

| File | Purpose | Source |
|------|---------|--------|
| `.claude/PIV-METHODOLOGY.md` | Complete methodology guide | Skeleton |
| `.claude/rules/00-general.md` | Universal development principles | Skeleton |
| `.claude/rules/10-git.md` | Git workflow rules | Skeleton |
| `.claude/rules/20-testing.md` | Testing philosophy | Skeleton |
| `.claude/rules/21-testing.md` | Given-When-Then pattern | Skeleton |
| `.claude/rules/30-documentation.md` | Documentation standards | Skeleton |
| `.claude/rules/40-security.md` | Security guidelines | Skeleton |
| `.claude/backup-before-piv-update-TIMESTAMP/` | Backup of current state | N/A |

## Files to Modify

| File | Changes | Strategy |
|------|---------|----------|
| `.claude/CLAUDE.md` | Add reference to PIV-METHODOLOGY.md | Append reference |
| `.claude/commands/piv_loop/prime.md` | Merge skeleton + WoningScout customizations | Careful merge |
| `.claude/commands/piv_loop/plan-feature.md` | Merge skeleton + WoningScout customizations | Careful merge |
| `.claude/commands/piv_loop/execute.md` | Add automatic validation trigger | Critical merge |
| `.claude/commands/validation/validate.md` | Support automatic execution | Update logic |
| `.claude/commands/validation/*.md` | Sync with skeleton versions | Copy & verify |
| `.claude/commands/bug_fix/*.md` | Sync with skeleton versions | Copy & verify |
| `.claude/rules/backend/*.md` | Merge skeleton principles | Enhance, don't replace |

## Files to Preserve (No Changes)

**All WoningScout-specific content:**

### Commands (13+ commands)
- `add-agency-website.md`
- `add-changelog.md`
- `code-review.md`
- `performance-audit.md`
- `project-health-check.md`
- `publisher-all.md`
- `publisher-linkedin.md`
- `refactor-code.md`
- `secrets-scanner.md`
- `security-audit.md`
- `test-coverage.md`
- `update-docs.md`
- `write-tests.md`

### Domain-Specific Rules
- `rules/backend/data-quality.md`
- `rules/backend/email.md`
- `rules/backend/market-trends.md`
- `rules/backend/monitoring.md`
- `rules/backend/scraping.md`
- `rules/anti-patterns.md`
- `rules/code-review.md`
- `rules/environment.md`
- `rules/testing.md`

### Reference Documentation (11 files)
- `reference/geoapify-client-api.md`
- `reference/java-24-modern-patterns.md`
- `reference/jsoup-element-api.md`
- `reference/postgresql-patterns.md`
- `reference/react-frontend-best-practices.md`
- `reference/spring-boot-best-practices.md`
- `reference/spring-data-jdbc-patterns.md`
- `reference/spring-test-configuration.md`
- `reference/test-funda-pararius-verification.md`
- `reference/testing-and-logging.md`
- `reference/web-scraping-guidelines.md`

### Project-Specific Files
- `PIV-ADOPTION-GUIDE.md`
- `GIT_PERMISSIONS_GUIDE.md`
- `INSTRUCTIONS.md`

### Agent Artifacts (All)
- `agents/**/*` - Entire structure preserved

### Skills (All)
- `skills/**/*` - Project-specific skills

## Testing Strategy

### Manual Tests
- [ ] Test 1: Verify backup created successfully
- [ ] Test 2: Verify PIV-METHODOLOGY.md copied and accessible
- [ ] Test 3: Verify universal rules exist and are readable
- [ ] Test 4: Test `/piv_loop:prime` still works
- [ ] Test 5: Test `/piv_loop:plan-feature` still works
- [ ] Test 6: Test `/piv_loop:execute` triggers automatic validation
- [ ] Test 7: Test WoningScout-specific commands still work (test-coverage, performance-audit, etc.)
- [ ] Test 8: Verify reference documentation still accessible
- [ ] Test 9: Verify no syntax errors in command files
- [ ] Test 10: Verify git status shows only expected changes

### Automated Checks
- [ ] Check 1: All markdown files are valid
- [ ] Check 2: No broken internal references
- [ ] Check 3: All command files have proper frontmatter
- [ ] Check 4: Backup directory exists and is complete

### Validation Criteria
- [ ] Criterion 1: Zero existing commands broken
- [ ] Criterion 2: All new methodology files accessible
- [ ] Criterion 3: Automatic validation works
- [ ] Criterion 4: WoningScout-specific content preserved
- [ ] Criterion 5: No duplicate or conflicting content
- [ ] Criterion 6: Backup available for rollback

## Risk Mitigation

### Risks
1. **Risk**: Breaking existing WoningScout workflows
   **Mitigation**: Comprehensive backup, manual testing before commit

2. **Risk**: Losing WoningScout-specific customizations
   **Mitigation**: Careful merge strategy, preserve-first approach

3. **Risk**: Conflicts between universal and domain-specific rules
   **Mitigation**: Keep both, clarify in documentation

4. **Risk**: Automatic validation may fail in WoningScout environment
   **Mitigation**: Validation should be graceful, not block workflow

### Rollback Plan
If update breaks critical functionality:
```bash
cd /Users/galando/dev/woningscout
rm -rf .claude
mv .claude.backup-before-piv-update-TIMESTAMP .claude
```

## Notes

### Key Insights
1. **WoningScout's PIV is outdated** - Still uses manual validation, missing universal methodology
2. **WoningScout has excellent domain content** - Reference docs, domain-specific rules are better than skeleton
3. **Skeleton has better universal foundation** - Universal rules, automatic validation
4. **Best of both worlds** - Skeleton's universal foundation + WoningScout's domain expertise

### Critical Success Factors
1. **Preserve WoningScout customizations** - Don't overwrite domain-specific content
2. **Add automatic validation** - This is the key improvement from skeleton
3. **Merge carefully** - Especially for PIV core commands
4. **Test thoroughly** - Ensure nothing breaks

### Edge Cases
- **Environment checks**: WoningScout has LOCAL vs PROD environment validation - must preserve this
- **Git workflow**: WoningScout may have custom git rules - don't override with skeleton's git rules
- **Testing rules**: WoningScout has comprehensive testing rules - enhance with skeleton's Given-When-Then, don't replace

### Post-Update Tasks (Future)
- [ ] Remove duplicate content if any
- [ ] Update PIV-ADOPTION-GUIDE.md to reference new methodology
- [ ] Train team on automatic validation workflow
- [ ] Update project documentation to reflect new PIV setup

## Related Issues
- PIV Methodology v1.0 Release
- WoningScout PIV Adoption
- Automatic Validation Implementation

## Estimated Effort
- **Preparation**: 15 minutes (backup, review)
- **Implementation**: 45-60 minutes (careful merging)
- **Testing**: 30 minutes (verify everything works)
- **Total**: 1.5-2 hours

## Priority
**HIGH** - Align with latest PIV methodology for better AI-assisted development workflow
