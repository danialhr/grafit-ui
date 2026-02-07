# Golden Tests

This directory contains visual regression tests for Grafit UI components using golden file testing.

## Overview

Golden tests capture screenshots of widgets and compare them against reference images ("golden files") to detect visual regressions. When component styling changes, the golden files must be updated to reflect the new appearance.

## Running Golden Tests

### Run all golden tests:
```bash
flutter test test/golden --golden-tests
```

### Run specific golden test file:
```bash
flutter test test/golden/components/button_golden_test.dart --golden-tests
```

### Update golden files (when you intentionally changed styling):
```bash
flutter test test/golden --update-goldens
```

### Run with verbose output for debugging:
```bash
flutter test test/golden --golden-tests --verbose
```

## Components with Golden Tests

The following 15 key components have golden test coverage:

### Form Components (5)
- **button** - All 6 variants (primary, secondary, ghost, link, destructive, outline)
- **input** - All 3 sizes + error state
- **checkbox** - Checked, unchecked states
- **switch** - On, off states
- **select** - Open/closed states

### Data Display Components (5)
- **badge** - All variants (default, primary, secondary, destructive, outline, ghost)
- **card** - With header/footer
- **avatar** - Sizes, fallback states
- **table** - With data rows
- **alert** - All variants (default, destructive, warning)

### Navigation Components (3)
- **tabs** - Value/line variants
- **breadcrumb** - With separators
- **pagination** - Middle page state

### Overlay Components (2)
- **dialog** - Open state with content
- **tooltip** - Hover state simulation

## Directory Structure

```
test/
├── golden/
│   ├── components/          # Golden test files for each component
│   │   ├── button_golden_test.dart
│   │   ├── input_golden_test.dart
│   │   └── ...
│   └── README.md           # This file
├── helpers/
│   └── golden_helpers.dart  # Helper utilities for golden tests
└── goldens/                 # Generated golden files (PNG images)
    ├── button_primary.png
    ├── button_secondary.png
    └── ...
```

## Golden Test Helper

The `golden_helpers.dart` file provides utilities:

- `matchGolden()` - Main function to compare widget output against golden files
- `GoldenTestWrapper` - MaterialApp wrapper with consistent theming
- `defaultGoldenDevice` - Standard device configuration (400x800)
- `largeGoldenDevice` - Large device for tables/cards (800x600)
- `smallGoldenDevice` - Small device for badges/buttons (200x100)

## Creating New Golden Tests

1. Create a new test file in `test/golden/components/`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:grafit_ui/grafit_ui.dart';
import '../helpers/golden_helpers.dart';

void main() {
  group('MyComponent Golden Tests', () {
    testWidgets('scenario name', (tester) async {
      await tester.pumpWidget(
        GoldenTestWrapper(
          device: defaultGoldenDevice,
          child: MyComponent(),
        ),
      );
      await matchGolden(tester, 'mycomponent_scenario', device: defaultGoldenDevice);
    });
  });
}
```

2. Run the test to generate initial golden files:
```bash
flutter test test/golden/components/mycomponent_golden_test.dart --update-goldens
```

## Updating Golden Files

When you intentionally change component styling:

1. Update the component code
2. Re-generate golden files:
```bash
flutter test test/golden --update-goldens
```

3. Review the generated images in `test/goldens/`
4. Commit the updated golden files with your code changes

## CI/CD Integration

Golden tests should run in CI with the `--update-goldens` flag disabled to catch regressions:

```yaml
# Example GitHub Actions step
- name: Run golden tests
  run: flutter test test/golden --golden-tests
```

## Troubleshooting

### Tests fail due to pixel differences

Golden tests are sensitive to:
- Font rendering differences across platforms
- Anti-aliasing variations
- Theme updates
- Device pixel ratio differences

**Solutions:**
- Run tests on consistent platform (e.g., always Linux on CI)
- Use `pumpAndSettle()` to let animations complete
- Ensure consistent theme wrapping via `GoldenTestWrapper`

### Golden files don't exist yet

Run with `--update-goldens` flag to generate initial golden files:
```bash
flutter test test/golden --update-goldens
```

### Network images in tests

For components that load network images (e.g., Avatar with imageUrl):
```dart
import 'package:network_image_mock/network_image_mock.dart';

testWidgets('with network image', (tester) async {
  await tester.pumpWidget(
    GoldenTestWrapper(
      device: defaultGoldenDevice,
      child: YourComponent(),
    ),
  );
  await matchGolden(tester, 'component_network', device: defaultGoldenDevice);
});
```

## Best Practices

1. **Test meaningful states** - Test each variant, size, and important state
2. **Use consistent theming** - Always use `GoldenTestWrapper` for consistent styling
3. **Name golden files descriptively** - `button_primary.png` not `button.png`
4. **Keep tests focused** - One scenario per test, grouped by component
5. **Document visual changes** - When updating goldens, explain why in commit message
6. **Use appropriate device size** - `defaultGoldenDevice`, `largeGoldenDevice`, or `smallGoldenDevice`

## Related Documentation

- [Flutter Golden Testing](https://docs.flutter.dev/cookbook/testing/goldens)
- [golden_toolkit package](https://pub.dev/packages/golden_toolkit)
