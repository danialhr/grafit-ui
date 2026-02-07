# Golden Tests Quick Start Guide

## First Time Setup

1. **Install dependencies** (if not already done):
```bash
cd /Users/danharis/development/pikpo-ui-shadcn/packages/grafit_ui
flutter pub get
```

2. **Generate initial golden files**:
```bash
flutter test test/golden --update-goldens
```

This will create 87 PNG files in `test/goldens/`.

## Daily Workflow

### Before making changes:
```bash
# Run tests to ensure current state passes
flutter test test/golden --golden-tests
```

### After making styling changes:
```bash
# Re-generate golden files to match new styling
flutter test test/golden --update-goldens

# Review the generated images
open test/goldens/

# Commit everything
git add test/goldens/
git commit -m "Update golden files for [component] styling changes"
```

## Common Commands

### Run all golden tests:
```bash
flutter test test/golden --golden-tests
```

### Run specific component tests:
```bash
# Button tests only
flutter test test/golden/components/button_golden_test.dart --golden-tests

# Input tests only
flutter test test/golden/components/input_golden_test.dart --golden-tests
```

### Update specific golden files:
```bash
# Update all
flutter test test/golden --update-goldens

# Update specific component
flutter test test/golden/components/button_golden_test.dart --update-goldens
```

### Run with verbose output (for debugging):
```bash
flutter test test/golden --golden-tests --verbose
```

## What Gets Tested

### Form Components (37 tests)
- Button: 10 scenarios (variants, sizes, states)
- Input: 8 scenarios (sizes, error, disabled)
- Checkbox: 6 scenarios (states, sizes)
- Switch: 6 scenarios (states, sizes)
- Select: 7 scenarios (states, grouped)

### Data Display (24 tests)
- Badge: 8 scenarios (all variants)
- Card: 5 scenarios (header, footer, styles)
- Avatar: 5 scenarios (sizes, fallbacks)
- Table: 4 scenarios (data, header, footer)
- Alert: 5 scenarios (all variants)

### Navigation (14 tests)
- Tabs: 4 scenarios (variants, orientations)
- Breadcrumb: 5 scenarios (trail, icons, separators)
- Pagination: 7 scenarios (page states, modes)

### Overlay (8 tests)
- Dialog: 3 scenarios (content, buttons)
- Tooltip: 5 scenarios (targets, text lengths)

## Troubleshooting

### Test failures:
- Check if styling change was intentional
- If intentional: run with `--update-goldens`
- If not intentional: review code changes

### Platform differences:
- Always run on same platform (use CI)
- Mac: `flutter test --platform macos`
- Linux: `flutter test --platform linux`

### Font rendering differences:
- Ensure consistent test environment
- Use `GoldenTestWrapper` for theming
- Check `devicePixelRatio` settings

## CI Integration

Add to your CI pipeline:

```yaml
- name: Run golden tests
  run: |
    cd packages/grafit_ui
    flutter test test/golden --golden-tests
```

For updating goldens in PR reviews:
```yaml
- name: Update golden files (manual)
  if: github.event_name == 'workflow_dispatch'
  run: |
    cd packages/grafit_ui
    flutter test test/golden --update-goldens
```

## File Locations

- Test files: `test/golden/components/*.dart`
- Golden images: `test/goldens/*.png`
- Helper: `test/helpers/golden_helpers.dart`
- Documentation: `test/golden/README.md`
