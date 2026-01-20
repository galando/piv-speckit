# Repository Rename: January 2025

**Date**: January 15, 2025
**Change**: `claude-piv-skeleton` → `universal-ai-dev-framework`

---

## Summary

This repository has been renamed from **claude-piv-skeleton** to **universal-ai-dev-framework** to better communicate its purpose as a production-ready development framework for Claude Code.

## What Changed

### Repository Name
- **Old**: `claude-piv-skeleton`
- **New**: `universal-ai-dev-framework`
- **URL**: https://github.com/galando/universal-ai-dev-framework

### GitHub Pages
- **Old URL**: https://galando.github.io/claude-piv-skeleton/
- **New URL**: https://galando.github.io/universal-ai-dev-framework/

### Documentation Updates
- All repository URLs updated throughout documentation
- Improved PIV methodology explanations (always explaining "Prime-Implement-Validate" on first use)
- Enhanced attribution to Cole Medin as creator of PIV methodology
- Redesigned GitHub Pages landing page with modern, distinctive visual design

## Breaking Changes

**None for end users.**

GitHub automatically redirects all old URLs to the new ones:
- Old repository URLs redirect to new repository
- Old GitHub Pages URLs redirect to new GitHub Pages
- All existing links continue to work

## Migration Guide

### For Contributors with Local Clones

If you have a local clone of this repository, update your remote URL:

```bash
cd claude-piv-skeleton  # or your local directory name
git remote set-url origin https://github.com/galando/universal-ai-dev-framework.git
git fetch origin
```

### For Users

No action required. All old URLs automatically redirect to the new ones.

If you've referenced this repository in documentation, you can update the URLs at your convenience:

```bash
# Old (still works due to redirects)
git clone https://github.com/galando/claude-piv-skeleton.git

# New (preferred)
git clone https://github.com/galando/universal-ai-dev-framework.git
```

## Rationale

### Why "Universal AI Dev Framework"?

The new name better communicates the project's value:

- **"Framework"** vs "Skeleton": Signals production-ready tooling rather than an incomplete template
- **"Dev"** vs "PIV": More accessible to new users while still preserving PIV methodology
- **Clear positioning**: Emphasizes this is for AI-assisted development with Claude Code

### PIV Methodology Preservation

The PIV (Prime-Implement-Validate) methodology remains central to this framework:

- Creator attribution to Cole Medin is preserved throughout
- First mentions always explain "PIV (Prime-Implement-Validate)"
- Internal `.claude/` structure unchanged for backward compatibility
- All commands and rules continue to work as before

## Internal Structure

**No changes to internal structure.**

The `.claude/` directory structure remains unchanged:
- All commands work identically
- All rules load as before
- All file paths are preserved
- Backward compatibility maintained

This ensures existing installations and workflows continue without interruption.

## Questions?

If you have questions or encounter any issues after the rename, please:

1. Check if old URLs are redirecting correctly (they should!)
2. Update local clone remote URL if you're a contributor
3. Open an issue if you encounter problems

## Thank You

Thanks for using Universal AI Dev Framework! The rename reflects the project's evolution and commitment to providing the best AI-assisted development experience for Claude Code users.
