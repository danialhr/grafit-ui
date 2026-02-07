# Grafit UI

> A Flutter component library inspired by [shadcn/ui](https://ui.shadcn.com/) with 100% feature parity across 59 components.

[![Flutter](https://img.shields.io/badge/Flutter-3.27+-02569B?logo=flutter)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.6+-0175C2?logo=dart)](https://dart.dev)
[![License](https://img.shields.io/badge/License-MIT-green)](LICENSE)

## Features

- ✅ **59 Components** - All shadcn/ui components ported to Flutter
- ✅ **100% Parity** - Full feature parity with upstream
- ✅ **Theme System** - Light/dark themes with multiple color schemes
- ✅ **Widgetbook** - Interactive documentation with live previews
- ✅ **Tests** - Widget tests and golden tests
- ✅ **CI/CD** - Automated testing and building
- ✅ **Type Safe** - Full Dart type safety throughout

## Components

### Form (18)
Button, Input, Checkbox, Switch, Slider, Textarea, Label, Select, Combobox, Radio Group, Toggle Group, Toggle, Input OTP, Form, Auto Form, Field, Input Group, Native Select, Button Group, Date Picker

### Navigation (7)
Tabs, Breadcrumb, Sidebar, Dropdown Menu, Navigation Menu, Menubar, Pagination

### Overlay (8)
Dialog, Tooltip, Popover, Alert Dialog, Command, Context Menu, Hover Card, Sonner (Toast), Collapsible

### Feedback (5)
Alert, Progress, Skeleton, Spinner, Sonner

### Data Display (9)
Badge, Avatar, Card, Data Table, Table, Pagination, Empty, Chart, Item, Separator

### Typography (2)
Text, Kbd

### Layout (3)
Card, Separator, Accordion

### Specialized (11)
Resizable, Scroll Area, Collapsible, Drawer, Sheet, Aspect Ratio, Calendar, Carousel, Direction, Date Picker

## Quick Start

### Installation

Add `grafit_ui` to your `pubspec.yaml`:

```yaml
dependencies:
  grafit_ui:
    git:
      url: https://github.com/danialhr/grafit-ui.git
      ref: main
      path: packages/grafit_ui
```

Then run:

```bash
flutter pub get
```

### Basic Usage

```dart
import 'package:grafit_ui/grafit_ui.dart';

void main() {
  runApp(
    GrafitTheme(
      data: GrafitThemeData.light(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            GrafitButton.primary(
              label: 'Click me',
              onPressed: () => print('Clicked!'),
            ),
            const SizedBox(height: 16),
            GrafitInput(
              label: 'Email',
              placeholder: 'Enter your email',
            ),
          ],
        ),
      ),
    );
  }
}
```

### Theming

Grafit UI includes a complete theme system:

```dart
// Light theme
GrafitTheme(
  data: GrafitThemeData.light(),
  child: MyApp(),
)

// Dark theme
GrafitTheme(
  data: GrafitThemeData.dark(),
  child: MyApp(),
)

// Custom theme
GrafitTheme(
  data: GrafitThemeData(
    colorScheme: GrafitColorScheme.fromSeed(
      seedColor: Color(0xFF6366F1), // Indigo
      brightness: Brightness.light,
    ),
  ),
  child: MyApp(),
)
```

## Documentation

### Interactive Documentation (Widgetbook)

Explore all 59 components with live, interactive examples:

```bash
cd packages/widgetbook
flutter run -d chrome
```

[Visit Widgetbook Documentation](packages/widgetbook/README.md)

### API Documentation

- [Component Registry](COMPONENT_REGISTRY.yaml) - Complete component tracking
- [Sync Log](SYNC_LOG.md) - Implementation history
- [Test Guide](packages/grafit_ui/test/README.md) - Testing documentation

### Examples

Run the example app to see components in action:

```bash
cd packages/grafit_ui/example
flutter run
```

## Development

### Setup

```bash
# Install Melos (workspace management)
dart pub global activate melos

# Bootstrap the workspace
melos bootstrap
```

### Running Tests

```bash
cd packages/grafit_ui

# All tests
flutter test

# With coverage
flutter test --coverage

# Golden tests
flutter test test/golden --update-goldens

# Specific test file
flutter test test/widget/components/form/button_test.dart
```

### Code Generation

For Widgetbook use cases:

```bash
cd packages/widgetbook
flutter pub run build_runner build --delete-conflicting-outputs
```

## Project Structure

```
grafit-ui/
├── packages/
│   ├── grafit_ui/              # Main package
│   │   ├── lib/
│   │   │   ├── src/
│   │   │   │   ├── theme/       # Theme system
│   │   │   │   ├── primitives/  # Base widgets
│   │   │   │   └── components/  # UI components
│   │   ├── test/               # Tests
│   │   │   ├── widget/         # Widget tests
│   │   │   ├── golden/         # Golden tests
│   │   │   └── helpers/        # Test utilities
│   │   └── example/            # Demo app
│   └── widgetbook/             # Interactive docs
├── COMPONENT_REGISTRY.yaml      # Component tracking
├── SYNC_LOG.md                 # Implementation log
└── .github/workflows/          # CI/CD
```

## Component Categories

| Category | Components |
|----------|------------|
| Form | 18 components |
| Navigation | 7 components |
| Overlay | 8 components |
| Feedback | 5 components |
| Data Display | 9 components |
| Typography | 2 components |
| Layout | 3 components |
| Specialized | 11 components |

## Roadmap

- [x] Implement all shadcn/ui components (59/59)
- [x] Achieve 100% feature parity
- [x] Add Widgetbook documentation
- [x] Add comprehensive tests
- [x] Set up CI/CD pipeline
- [ ] Publish to pub.dev
- [ ] Add CLI tool for component management

## Contributing

Contributions are welcome! Please see [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

## License

MIT © [Danial Haris](https://github.com/danialhr)

---

Inspired by [shadcn/ui](https://ui.shadcn.com/) - Copyright (c) 2023 shadcn
