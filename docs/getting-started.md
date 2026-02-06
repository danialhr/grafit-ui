# Getting Started with Grafit

Grafit is a Flutter port of [shadcn/ui](https://ui.shadcn.com/) following the copy-paste philosophy. Components are copied directly into your project, giving you full ownership and customization capabilities.

## Installation

### Prerequisites

- Flutter 3.27 or higher
- Dart 3.6 or higher

### Quick Start

1. **Install Melos** (for workspace management)

```bash
dart pub global activate melos
```

2. **Navigate to your Flutter project**

```bash
cd my_flutter_app
```

3. **Initialize Grafit**

```bash
gft init
```

This creates:
- `components.json` - Configuration file
- `lib/components/ui/` - Directory for your components
- Theme configuration

## Basic Usage

### Adding the Theme

First, add GrafitTheme to your MaterialApp:

```dart
import 'package:flutter/material.dart';
import 'package:grafit_ui/grafit_ui.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      theme: ThemeData(
        useMaterial3: true,
        extensions: [
          GrafitTheme.light(baseColor: 'zinc'),
        ],
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        extensions: [
          GrafitTheme.dark(baseColor: 'zinc'),
        ],
      ),
      themeMode: ThemeMode.system,
      home: HomePage(),
    );
  }
}
```

### Adding Components

Add individual components as needed:

```bash
# Add a button component
gft add button

# Add an input component
gft add input

# Add all components
gft add --all
```

### Using Components

```dart
import 'package:flutter/material.dart';
import 'package:grafit_ui/grafit_ui.dart';

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<GrafitTheme>()!;

    return Scaffold(
      backgroundColor: theme.colors.background,
      body: Center(
        child: Column(
          children: [
            GrafitText.headlineLarge('Welcome to Grafit'),
            const SizedBox(height: 16),
            GrafitButton(
              label: 'Get Started',
              variant: GrafitButtonVariant.primary,
              onPressed: () {
                // Handle button press
              },
            ),
          ],
        ),
      ),
    );
  }
}
```

## Configuration

The `components.json` file controls how components are added:

```json
{
  "style": "default",
  "componentsPath": "lib/components/ui",
  "themeExtension": "GrafitTheme",
  "baseColor": "zinc",
  "useThemeVariables": true,
  "rtl": false
}
```

### Options

- **style**: Component style variant (default only for now)
- **componentsPath**: Where components are copied
- **themeExtension**: Theme extension class name
- **baseColor**: Base color scheme (zinc, slate, neutral, stone)
- **useThemeVariables**: Enable theme variables (recommended)
- **rtl**: Enable right-to-left layout support

## CLI Commands

### `gft init`

Initialize a Flutter project with Grafit.

```bash
gft init [options]
```

Options:
- `--base-color`: Base color (zinc, slate, neutral, stone)
- `--force`: Overwrite existing config
- `--yes`: Skip confirmation prompts

### `gft add`

Add a component to your project.

```bash
gft add <component> [options]
```

Options:
- `--all`: Add all components
- `--overwrite`: Overwrite existing files
- `--yes`: Skip confirmation

### `gft list`

List all available components.

```bash
gft list
```

### `gft view`

View component source before installing.

```bash
gft view <component>
```

## Theming

Grafit supports light and dark themes with multiple color schemes:

```dart
// Light theme with zinc color
GrafitTheme.light(baseColor: 'zinc')

// Dark theme with slate color
GrafitTheme.dark(baseColor: 'slate')

// Other options: neutral, stone
```

See [Theming](theming.md) for more details.

## Next Steps

- Explore [all components](components/README.md)
- Customize [theming](theming.md)
- Learn [CLI commands](cli-reference.md)
