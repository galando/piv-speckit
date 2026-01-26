# Changelog

All notable changes to PIV Spec-Kit project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [2.0.1] - 2025-01-22

### 🔧 Fixed

#### Template Distribution for Plugin Users
- **Constitution template**: Now embedded directly in `/piv_loop:constitution` command
  - Previously referenced `.claude/memory/constitution.template.md` (not distributed with plugin)
  - Template now travels with plugin - works immediately after installation
- **Spec-Kit templates**: Now embedded in `.claude/reference/execution/plan-feature.md`
  - Includes spec.md, plan.md, tasks.md, quickstart.md templates
  - `/piv_loop:plan-feature` can generate artifacts without external template files
- **README**: Updated to clarify "Embedded in plugin" for templates
- **plugin.json**: Bumped version to 2.0.1

**Impact**: Plugin users can now use all template features without manual setup or local repo clone.

---

## [1.0.0] - 2025-01-12

### 🎉 Initial Release - World-Class PIV Skeleton

First official release of the universal PIV (Prime-Implement-Validate) methodology skeleton for Claude Code.

### ✨ Added

#### Core PIV Methodology
- Universal PIV methodology implementation (Prime → Implement → Validate)
- Modular rules system with universal and technology-specific rules
- Complete command infrastructure for PIV workflow
- Automatic validation pipeline after execution
- Comprehensive methodology documentation

#### Command Infrastructure
- `/piv-speckit:prime` - Load codebase context
- `/piv-speckit:plan-feature` - Create detailed implementation plans
- `/piv-speckit:execute` - Execute plans with automatic validation
- `/piv-speckit:validate` - Complete validation pipeline
- `/piv-speckit:code-review` - Technical code review
- `/piv-speckit:code-review-fix` - Auto-fix code review issues
- `/piv-speckit:execution-report` - View implementation reports
- `/piv-speckit:system-review` - Process improvement analysis
- `/piv-speckit:rca` - Root cause analysis for bugs
- `/piv-speckit:implement-fix` - Implement bug fixes from RCA

#### Technology Templates
- **Backend**: Spring Boot (Java/Kotlin)
- **Backend**: Node.js + Express
- **Backend**: Python + FastAPI
- **Frontend**: React + TypeScript
- **Database**: PostgreSQL
- **DevOps**: Docker

#### Documentation
- Complete PIV methodology guide
- Getting started guides (installation, quick start, first feature)
- Technology-specific documentation
- Troubleshooting guide
- FAQ (15+ common questions)
- Comparison: PIV vs Traditional vs Ad-hoc AI
- Roadmap with future plans
- Contributing guidelines

#### Community Features
- GitHub issue templates (bug report, feature request, question)
- GitHub pull request template
- GitHub repository description for SEO
- GitHub topics (15+ keywords for discoverability)
- "Used By" section for project showcases
- Social sharing buttons (Twitter, LinkedIn, Reddit)
- README badges (PIV, Claude Code, License, Stars, PRs Welcome)

#### Installer
- Interactive installer script for existing projects
- Automatic technology stack detection
- Backup creation before installation
- Preserves existing configuration
- Idempotent (can run multiple times safely)

#### Rules System
- Universal rules (general, git, testing, documentation, security)
- Technology-specific rules (auto-loaded based on file patterns)
- Path-based rule loading
- Numbered rule files for load order control

### 🔧 Setup & Configuration
- MIT License
- `.claude/` directory structure for Claude Code
- Agent artifact directories (context, plans, reports, reviews)
- Comprehensive README with examples
- Star History integration

### 📚 Documentation Examples
- Real-world example workflows
- Code patterns reference
- Best practices for each technology
- Extension guides

### 🎨 Visual Enhancements
- Professional README badges
- Star History chart
- Clear section hierarchy
- Markdown formatting for readability
- Assets directory for future media (demo GIF, logo)

### 🙏 Attribution
- Cole Medin (coleam00) credited as PIV methodology creator
- Links to Cole's context-engineering-intro and habit-tracker projects
- Reference implementation: WoningScout

### 🎯 Quality Features
- Automatic validation after execute
- Code review with issue detection
- Structured logging support
- Test coverage requirements
- Security guidelines
- Given-When-Then testing pattern

---

## [2.0.0] - 2025-01-21

### 🎉 Spec-Kit Integration - Structured Specifications for PIV

Major update integrating [GitHub's Spec-Kit](https://github.com/github/spec-kit) best practices into the PIV methodology. Adds structured specification artifacts and multi-AI compatibility.

### ⚠️ Breaking Changes

- **Plugin renamed**: `piv` → `piv-speckit`
- Users must run: `/plugin install piv-speckit` (instead of `/plugin install piv`)

### ✨ Added

#### Phase 0: Constitution (New)
- `/piv-speckit:constitution` command for one-time project definition
- `.claude/memory/constitution.md` - Project principles document
- `.claude/memory/constitution.template.md` - Constitution template
- Defines: project purpose, core principles, technology stack, constraints, development guidelines

#### Split Spec Artifacts (New)
- `.claude/specs/{XXX-feature-name}/` directory structure
- `spec.md` - WHAT: User stories, requirements, workflows
- `plan.md` - HOW: Technical approach, architecture, APIs
- `tasks.md` - DO: Step-by-step implementation tasks
- `quickstart.md` - TL;DR: Quick reference for humans
- Templates in `.claude/specs/.templates/` for all artifact types

#### Multi-AI Compatibility
- All artifacts are pure Markdown (no Claude-specific syntax)
- Works with: Claude Code, Cursor, GitHub Copilot, ChatGPT, Claude Web
- No Claude Code dependency for planning or implementation

### 🔧 Updated

- `.claude-plugin/plugin.json`: Version 2.0.0, renamed to `piv-speckit`
- `.claude-plugin/marketplace.json`: Updated plugin name and description
- `.claude/CLAUDE.md`: Added constitution command to quick reference
- `.claude/commands/piv_loop/plan-feature.md`: Added Phase 6 (split artifacts), multi-AI docs
- `.claude/commands/piv_loop/execute.md`: Updated for split artifacts (tasks.md)
- `.claude/reference/methodology/PIV-METHODOLOGY.md`: Added Phase 0 (Constitution), split artifact structures
- `README.md`: Spec-Kit badge, "Enhanced with Spec-Kit" section, multi-AI compatibility docs
- `docs/index.html`: Updated hero, methodology cards (Constitution added), installation command

### ✅ Backward Compatibility

- Legacy single-file plans (`.claude/agents/plans/`) still supported
- Old plans can be migrated to split format
- All existing commands continue to work

### 📚 Documentation

- Constitution vs Spec Artifacts comparison table
- Multi-AI compatibility examples
- Updated methodology with Phase 0

---

## Links

- **GitHub**: https://github.com/galando/claude-dev-framework
- **Issues**: https://github.com/galando/claude-dev-framework/issues
- **Discussions**: https://github.com/galando/claude-dev-framework/discussions
- **Cole Medin's Work**: https://github.com/coleam00

---

**Note:** This project follows [Keep a Changelog](https://keepachangelog.com/) recommendations.
