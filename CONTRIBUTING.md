# Contributing to Grafit UI

Thank you for your interest in contributing to Grafit UI!

## Project Overview

Grafit UI is a Flutter component library inspired by [shadcn/ui](https://ui.shadcn.com/) with 59 components at 100% feature parity.

- **59 Components** across 8 categories
- **100% Parity** with shadcn-ui/ui
- **Widgetbook Documentation** with 400+ use cases
- **Comprehensive Tests** - widget tests and golden tests
- **CI/CD Pipeline** - automated testing and building

## Development Setup

### Prerequisites

- Flutter 3.27+
- Dart 3.6+
- Melos (workspace management)

### Setup

```bash
# Clone the repository
git clone https://github.com/danialhr/grafit-ui.git
cd grafit-ui

# Install Melos
dart pub global activate melos

# Bootstrap the workspace
melos bootstrap
```

## Project Structure

```
grafit-ui/
├── packages/
│   ├── grafit_ui/              # Main package
│   │   ├── lib/src/components/   # Component implementations
│   │   ├── test/                  # Tests
│   │   └── example/               # Demo app
│   └── widgetbook/              # Interactive documentation
├── cli/                        # Command-line tool
├── COMPONENT_REGISTRY.yaml      # Component tracking
├── SYNC_LOG.md                 # Implementation history
└── .github/workflows/          # CI/CD
```

## Using the CLI

Grafit UI includes a CLI tool (`gft`) for component management.

### Quick Start

```bash
# Initialize Grafit UI in a Flutter project
dart run cli/bin/gft.dart init

# List available components
dart run cli/bin/gft.dart list

# Add a component
dart run cli/bin/gft.dart add button

# View component source
dart run cli/bin/gft.dart view badge

# Check project health
dart run cli/bin/gft.dart doctor
```

### For Users

If you're using Grafit UI in your Flutter project:

1. Run `gft init` to set up
2. Run `gft list` to see available components
3. Run `gft add <component>` to add components
4. Run `gft doctor` to check your setup

See [cli/README.md](cli/README.md) for complete CLI documentation.

## Adding Components

### Quick Start with CLI

Use the CLI to scaffold a new component from shadcn-ui:

```bash
# List available shadcn-ui components
dart run cli/bin/gft.dart new --list

# Scaffold a new component
dart run cli/bin/gft.dart new toast --category feedback
```

The CLI will:
1. Fetch component source from shadcn-ui
2. Provide scaffold guidance
3. Create the component structure

### Manual Component Creation

Follow these steps to add a component manually:

### 1. Implement the Component

Create a new component in `packages/grafit_ui/lib/src/components/{category}/`:

```dart
import 'package:flutter/widgets.dart';
import '../../theme/theme.dart';
import '../../primitives/clickable.dart';

class GrafitMyComponent extends StatefulWidget {
  const GrafitMyComponent({
    super.key,
    required this.label,
    this.onPressed,
  });

  final String label;
  final VoidCallback? onPressed;

  @override
  State<GrafitMyComponent> createState() => _GrafitMyComponentState();
}

class _GrafitMyComponentState extends State<GrafitMyComponent> {
  @override
  Widget build(BuildContext context) {
    final theme = GrafitTheme.of(context);

    return GrafitClickable(
      onTap: widget.onPressed,
      child: Container(
        decoration: BoxDecoration(
          color: theme.colors.primary,
        ),
        child: Text(widget.label),
      ),
    );
  }
}
```

### 2. Add Metadata

Create a `.component.yaml` file:

```yaml
# my_component.component.yaml
source:
  repository: https://github.com/shadcn-ui/ui
  component: my-component
  sourcePath: apps/v4/registry/new-york-v4/ui/my-component.tsx
  commit: null
  lastChecked: 2025-02-07
  lastSynced: 2025-02-07

flutter:
  path: lib/src/components/{category}/my_component.dart
  class: GrafitMyComponent
  status: implemented

parity:
  target: 100
  current: 100
  gap: []

mapping:
  # Component mapping details
```

### 3. Export the Component

Add to `packages/grafit_ui/lib/grafit_ui.dart`:

```dart
// {category} components
export 'src/components/{category}/my_component.dart';
```

### 4. Update Registry

Add to `COMPONENT_REGISTRY.yaml`:

```yaml
flutter_components:
  my-component:
    upstream: my-component
    flutter: lib/src/components/{category}/my_component.dart
    metadata: lib/src/components/{category}/my_component.component.yaml
    category: *{category}
    status: implemented
    parity: 100
    lastChecked: 2025-02-07
    lastSynced: 2025-02-07
```

### 5. Add Tests

Create test files in `packages/grafit_ui/test/`:

```dart
// test/widget/components/{category}/my_component_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:grafit_ui/grafit_ui.dart';
import '../../../helpers/test_helpers.dart';
import '../../../helpers/themed_test_widget.dart';

void main() {
  group('GrafitMyComponent', () {
    testGrafitWidget('renders without error', (tester) async {
      await tester.pumpWidget(
        ThemedTestWidget(
          child: GrafitMyComponent(
            label: 'Test',
            onPressed: () {},
          ),
        ),
      );
      expect(find.byType(GrafitMyComponent), findsOneWidget);
    });
  });
}
```

### 6. Add Widgetbook Use Cases

Create in `packages/widgetbook/lib/components/`:

```dart
import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:grafit_ui/grafit_ui.dart';

@widgetbook.UseCase(
  name: 'Default',
  type: GrafitMyComponent,
)
Widget myComponentDefault(BuildContext context) {
  return GrafitMyComponent(
    label: context.knobs.string(
      label: 'Label',
      initialValue: 'Hello World',
    ),
    onPressed: () {},
  );
}
```

## Coding Standards

### Dart Style

- Follow [Effective Dart](https://dart.dev/guides/language/effective-dart)
- Use `flutter analyze` to check code
- Run `dart format` before committing

### Component Guidelines

1. **Use GrafitClickable** for interactive components
2. **Use GrafitFocusable** for focusable components
3. **Use GrafitTheme** for all styling
4. **Support light/dark themes**
5. **Include semantic labels** for accessibility
6. **Add const constructors** where possible

### Naming Conventions

- Classes: `GrafitComponentName`
- Enums: `GrafitComponentTypeName`
- Extensions: `ComponentNameX`
- Private classes: `_ComponentName`

## Testing

### Run Tests

```bash
# All tests
flutter test

# Widget tests
flutter test test/widget/

# Golden tests
flutter test test/golden --update-goldens

# With coverage
flutter test --coverage
```

### Test Requirements

- All components must have widget tests
- Cover all variants, sizes, and states
- Include accessibility tests
- Add golden tests for visual components

## Documentation

- Update relevant documentation
- Add usage examples in Widgetbook
- Update SYNC_LOG.md with changes
- Update COMPONENT_REGISTRY.yaml

## Pull Request Process

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Run tests: `flutter test`
5. Run analyzer: `flutter analyze`
6. Format code: `dart format .`
7. Submit a pull request with:
   - Description of changes
   - Related issue number
   - Screenshot for UI changes

## CI/CD

All pull requests are automatically tested by GitHub Actions:

- **Analyze**: Code quality checks
- **Test**: Widget and golden tests
- **Build**: Example app and Widgetbook

## Questions?

- Open an issue for bugs or feature requests
- Start a discussion for questions
- Check existing issues first

## License

By contributing, you agree that your contributions will be licensed under the MIT License.
