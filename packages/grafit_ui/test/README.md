# Grafit UI Test Suite

This directory contains the comprehensive test infrastructure for Grafit UI components.

## Directory Structure

```
test/
├── helpers/                    # Reusable test utilities
│   ├── test_helpers.dart       # Common widget test helpers
│   ├── golden_helpers.dart     # Golden (screenshot) test helpers
│   ├── mock_data.dart          # Sample data for testing
│   └── themed_test_widget.dart # Test wrapper with GrafitTheme
├── widget/                     # Widget tests
│   └── components/
│       ├── form/              # Form component tests
│       │   ├── button_test.dart
│       │   └── input_test.dart
│       └── data-display/      # Data display component tests
│           └── badge_test.dart
├── golden/                    # Golden test files (generated)
│   └── components/
│       ├── form/
│       └── data-display/
└── test_config.dart           # Global test configuration
```

## Running Tests

### Run All Tests

```bash
# From the package root
flutter test

# With coverage
flutter test --coverage

# Run specific test file
flutter test test/widget/components/form/button_test.dart

# Run tests in a directory
flutter test test/widget/components/form/
```

### Run Widget Tests Only

```bash
flutter test test/widget/
```

### Run Golden Tests

```bash
# Run all golden tests
flutter test test/golden/

# Update golden files
flutter test --update-goldens test/golden/

# Skip golden tests (useful for CI)
flutter test --skip-golden-tests
```

### Run Tests with Tags

```bash
# Run only smoke tests
flutter test --name="smoke"

# Run specific test group
flutter test --name="GrafitButton"
```

## Test Organization

### Widget Tests (`test/widget/`)

Widget tests verify the behavior and rendering of individual components. Each component should have tests covering:

1. **Smoke Tests** - Basic rendering without errors
2. **Variants** - All visual variants (primary, secondary, ghost, etc.)
3. **Sizes** - All size options (sm, md, lg)
4. **States** - Disabled, loading, error, focus states
5. **Interactions** - Callbacks are triggered correctly
6. **Accessibility** - Semantic labels and screen reader support
7. **Edge Cases** - Empty values, long text, special characters
8. **Theme Support** - Light and dark theme rendering

### Golden Tests (`test/golden/`)

Golden tests (screenshot tests) ensure visual consistency across changes.

#### Running Golden Tests

1. **Initial Setup** - Generate golden files:
```bash
flutter test --update-goldens test/golden/
```

2. **Verify Visual Changes** - Compare against golden files:
```bash
flutter test test/golden/
```

3. **Update Golden Files** - When intentional visual changes are made:
```bash
flutter test --update-goldens test/golden/
```

#### Golden Test Guidelines

- Use meaningful file names that describe the component, variant, and state
- Test all variants and sizes
- Test both light and dark themes
- Test edge cases (empty states, long content, etc.)
- Keep golden files under version control

## Test Helpers

### `test_helpers.dart`

Common utilities for widget testing:

```dart
import 'package:grafit_ui/grafit_ui.dart';
import '../helpers/test_helpers.dart';

void main() {
  testGrafitWidget('my test', (tester) async {
    await tester.pumpWidget(
      ThemedTestWidget(
        child: GrafitButton(label: 'Click me'),
      ),
    );
    
    expect(find.byType(GrafitButton), findsOneWidget);
  });
}
```

**Available Helpers:**

- `testGrafitWidget()` - Wrapper for testWidgets with GrafitTheme
- `pumpTestWidget()` - Pump widget with theme applied
- `findByType<T>()` - Find widget by type
- `findByKey()` - Find widget by key
- `expectVisible()` - Assert widget is visible
- `expectNotFound()` - Assert widget doesn't exist
- `tapAndWait()` - Tap widget and wait for animations
- `enterText()` - Enter text and wait
- `createCallbackTracker()` - Track callback invocations
- `CallbackTracker` - Verify callbacks were called

### `golden_helpers.dart`

Utilities for golden (screenshot) testing:

```dart
import '../helpers/golden_helpers.dart';

void main() {
  testGolden('button_primary', 
    GrafitButton(label: 'Click', variant: GrafitButtonVariant.primary),
  );
  
  testGoldenVariants('button', {
    'primary': GrafitButton(label: 'Click', variant: GrafitButtonVariant.primary),
    'secondary': GrafitButton(label: 'Click', variant: GrafitButtonVariant.secondary),
  });
}
```

**Available Helpers:**

- `testGolden()` - Run a single golden test
- `testGoldenVariants()` - Test all variants of a component
- `testGoldenSizes()` - Test all sizes of a component
- `compareGolden()` - Compare two widgets visually
- `goldenWrapper()` - Wrap widget for golden testing
- `testGoldenDevices()` - Test across different device sizes

### `mock_data.dart`

Sample data for tests:

```dart
import '../helpers/mock_data.dart';

// Strings
TestStrings.medium  // 'Hello World'
TestStrings.email   // 'test@example.com'

// Lists
TestLists.simple    // ['Item 1', 'Item 2', 'Item 3']

// Form data
TestFormData.valid  // Valid form values
TestFormData.invalid // Invalid form values

// Users
TestUsers.basic     // Basic user data
TestUsers.detailed  // Detailed user data
```

### `themed_test_widget.dart`

Test wrappers that provide GrafitTheme:

```dart
import '../helpers/themed_test_widget.dart';

// Light theme
await tester.pumpWidget(
  LightThemedTestWidget(
    child: GrafitButton(label: 'Click'),
  ),
);

// Dark theme
await tester.pumpWidget(
  DarkThemedTestWidget(
    child: GrafitButton(label: 'Click'),
  ),
);

// With scaffold
await tester.pumpWidget(
  ScaffoldTestWidget(
    body: GrafitInput(label: 'Test'),
  ),
);

// With constraints
await tester.pumpWidget(
  ConstrainedTestWidget(
    width: 400,
    height: 600,
    child: GrafitButton(label: 'Click'),
  ),
);
```

## Writing New Tests

### 1. Widget Test Template

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:grafit_ui/grafit_ui.dart';
import '../../../helpers/test_helpers.dart';
import '../../../helpers/themed_test_widget.dart';

void main() {
  group('GrafitComponent - Smoke Tests', () {
    testGrafitWidget('renders without errors', (tester) async {
      await tester.pumpWidget(
        ThemedTestWidget(
          child: GrafitComponent(),
        ),
      );

      expect(find.byType(GrafitComponent), findsOneWidget);
    });
  });

  group('GrafitComponent - Variants', () {
    // Test each variant
    for (final variant in GrafitComponentVariant.values) {
      testGrafitWidget('renders $variant variant', (tester) async {
        await tester.pumpWidget(
          ThemedTestWidget(
            child: GrafitComponent(variant: variant),
          ),
        );

        expect(find.byType(GrafitComponent), findsOneWidget);
      });
    }
  });

  group('GrafitComponent - Interactions', () {
    testGrafitWidget('triggers callback', (tester) async {
      final callback = createCallbackTracker();

      await tester.pumpWidget(
        ThemedTestWidget(
          child: GrafitComponent(
            onTap: callback.voidCallback,
          ),
        ),
      );

      await tapAndWait(tester, find.byType(GrafitComponent));

      expect(callback.called, isTrue);
    });
  });
}
```

### 2. Golden Test Template

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:grafit_ui/grafit_ui.dart';
import '../../../helpers/golden_helpers.dart';

void main() {
  testGoldenVariants('grafit_component', {
    'variant1': GrafitComponent(variant: GrafitComponentVariant.variant1),
    'variant2': GrafitComponent(variant: GrafitComponentVariant.variant2),
  });

  testGoldenSizes('grafit_component', {
    'sm': GrafitComponent(size: GrafitComponentSize.sm),
    'md': GrafitComponent(size: GrafitComponentSize.md),
    'lg': GrafitComponent(size: GrafitComponentSize.lg),
  });
}
```

## Test Coverage

To check test coverage:

```bash
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

## Continuous Integration

Tests run automatically on:

- Pull requests
- Main branch pushes
- Scheduled runs

### CI Environment Variables

- `SKIP_GOLDEN_TESTS` - Set to `true` to skip golden tests in CI

## Best Practices

1. **Keep Tests Fast** - Widget tests should run quickly
2. **Test Behavior, Not Implementation** - Focus on user-facing behavior
3. **Use Descriptive Names** - Test names should clearly describe what they test
4. **One Assertion Per Test** - Keep tests focused
5. **Use Helper Functions** - Reduce boilerplate with provided helpers
6. **Test Edge Cases** - Don't forget empty states, error states, etc.
7. **Keep Tests Isolated** - Tests should not depend on each other
8. **Maintain Golden Files** - Update golden files when visual changes are intentional

## Troubleshooting

### Golden Test Failures

If golden tests fail due to intentional visual changes:

```bash
flutter test --update-goldens test/golden/
```

### Timeout Errors

If tests timeout, increase timeout in `test_config.dart` or individual tests:

```dart
testWidgets('slow test', (tester) async {
  // test code
}, timeout: Timeout(Duration(minutes: 5)));
```

### Theme Not Found Error

Make sure to wrap widgets in `ThemedTestWidget` or `LightThemedTestWidget`:

```dart
await tester.pumpWidget(
  LightThemedTestWidget(
    child: YourComponent(),
  ),
);
```

## Resources

- [Flutter Testing Documentation](https://docs.flutter.dev/cookbook/testing)
- [Widget Testing Guide](https://docs.flutter.dev/cookbook/testing/widget/introduction)
- [Golden Toolkit Package](https://pub.dev/packages/golden_toolkit)
