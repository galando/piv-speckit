# PIV Skeleton Assets

This directory contains media assets for the PIV skeleton repository.

## Contents

### demo.gif
**Coming Soon!** Animated demo showing PIV in action.

The demo will showcase:
1. User running `/piv_loop:prime` to load context
2. User planning a feature with `/piv_loop:plan-feature`
3. Claude creating a detailed implementation plan
4. User executing with `/piv_loop:execute`
5. Automatic validation running and passing

**Size target:** < 2MB
**Duration:** 15-30 seconds
**Recording tools:** CleanShot X, Kap, or similar

### logo.png
**Coming Soon!** Project logo for branding and social sharing.

### og-image.png
**Coming Soon!** Social sharing preview image for Open Graph protocol.

---

## Creating the Demo GIF

When creating the demo.gif:

1. **Use a clean project** - Start with a simple example
2. **Show the complete cycle** - Prime → Plan → Execute → Validate
3. **Keep it short** - 15-30 seconds max
4. **Optimize size** - Use compression tools to keep under 2MB
5. **Highlight key moments** - Add arrows or text overlays for clarity

### Recording Tips

```bash
# Using Kap (macOS)
# 1. Open Kap
# 2. Select region (terminal window)
# 3. Record
# 4. Export as GIF, optimize for size

# Using CleanShot X (macOS)
# 1. Open CleanShot
# 2. Select "Recording" → "Select Area"
# 3. Record
# 4. Export as GIF
```

### Optimization

```bash
# Using gifsicle (if installed)
gifsicle -O3 --lossy=30 demo.gif -o demo-optimized.gif

# Check file size
ls -lh demo-optimized.gif
```

---

## Logo Guidelines

If creating a logo:

- **Style**: Clean, modern, professional
- **Colors**: Blue/green (matches badges), minimal
- **Format**: PNG with transparent background
- **Sizes**: 512x512, 256x256, 128x128, 64x64
- **Usage**: README, social previews, documentation

---

**Note:** Video tutorials (Phase 4) should be created separately and embedded from YouTube.
