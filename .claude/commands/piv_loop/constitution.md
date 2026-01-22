---
description: "Create project constitution with core principles"
argument-hint: ""
---

# Constitution: Define Project Principles

**Goal:** Create a project constitution that guides all AI-assisted development decisions.

## Execution

1. Check if `.claude/memory/constitution.md` exists
2. If exists, read it and summarize current principles
3. If not, offer to create from template

## What is a Constitution?

A **constitution** is a one-time document that defines:
- **Project purpose**: What this project is and why it exists
- **Core principles**: Quality standards, testing requirements, code style
- **Technology stack**: Frameworks, languages, databases
- **Technical constraints**: What to use and what to avoid
- **Development guidelines**: Git workflow, code review, testing
- **Security requirements**: Security standards and practices
- **Performance requirements**: Performance targets

## Why Create a Constitution?

**Benefits:**
- Guides all AI decisions for consistent output
- Single source of truth for project choices
- Reduces ambiguity in technical decisions
- Onboards new developers quickly
- Prevents technical debt through clear principles

## Constitution vs. Spec Artifacts

| Aspect | Constitution | Spec/Plan/Tasks |
|--------|--------------|-----------------|
| Scope | Entire project | Single feature |
| Frequency | Once per project | Per feature |
| Changes | Rarely | Often |
| Content | Principles, stack, guidelines | Requirements, approach, steps |

## Location

Constitution is stored at: `.claude/memory/constitution.md`

This file is read automatically during:
- `/piv-speckit:plan-feature` - Planning phase reads constitution
- `/piv-speckit:prime` - Prime checks for constitution existence

## Template

A template is available at: `.claude/memory/constitution.template.md`

## Usage

**Create constitution:**
```
/piv-speckit:constitution
```

**Update constitution:**
Edit `.claude/memory/constitution.md` directly
