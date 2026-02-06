# Theming with Grafit

Grafit provides a comprehensive theming system based on Flutter's ThemeExtension. This allows for consistent styling across all components while maintaining full customization capabilities.

## Theme Structure

GrafitTheme is composed of several parts:

- **Color Scheme**: All colors used in components
- **Text Styles**: Typography scale
- **Border Theme**: Border radii and styles
- **Shadow Theme**: Shadow definitions

## Basic Setup

### Adding GrafitTheme

```dart
import 'package:flutter/material.dart';
import 'package:gft_ui/gft_ui.dart';

MaterialApp(
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
  // ...
)
```

## Color Schemes

### Available Base Colors

Grafit supports four base color schemes:

- **Zinc**: Neutral grays with cool undertones
- **Slate**: Blue-gray tones
- **Neutral**: Pure grays
- **Stone**: Warm gray tones

### Using Different Base Colors

```dart
// Zinc (default)
GrafitTheme.light(baseColor: 'zinc')

// Slate
GrafitTheme.light(baseColor: 'slate')

// Neutral
GrafitTheme.light(baseColor: 'neutral')

// Stone
GrafitTheme.light(baseColor: 'stone')
```

## Theme Colors

The color scheme provides semantic colors for all component states:

### Background & Foreground

```dart
colors.background       // Main background
colors.foreground       // Main foreground/text
colors.card            // Card background
colors.cardForeground  // Card text
colors.popover         // Popover/tooltip background
colors.popoverForeground // Popover/tooltip text
```

### Primary Colors

```dart
colors.primary           // Primary action color
colors.primaryForeground // Text on primary
```

### Secondary Colors

```dart
colors.secondary           // Secondary background
colors.secondaryForeground // Text on secondary
```

### Muted Colors

```dart
colors.muted            // Muted background
colors.mutedForeground  // Muted text
```

### Accent Colors

```dart
colors.accent           // Accent background
colors.accentForeground // Text on accent
```

### Destructive Colors

```dart
colors.destructive           // Error/danger
colors.destructiveForeground // Text on destructive
```

### Border & Input

```dart
colors.border  // Border color
colors.input   // Input border color
colors.ring    // Focus ring color
```

## Customizing Themes

### Override Individual Colors

```dart
GrafitTheme.light(baseColor: 'zinc').copyWith(
  colors: GrafitColorScheme(
    // Override specific colors
    primary: Color(0xFF3B82F6),
    destructive: Color(0xFFDC2626),
    // ... other colors
  ),
)
```

### Custom Theme Extension

```dart
class CustomTheme extends GrafitTheme {
  CustomTheme({required Color customColor})
      : super(
          base: ColorScheme.light(),
          colors: _createColorScheme(customColor),
          text: GrafitTextTheme.light(ThemeData.light().textTheme),
          borders: const GrafitBorderTheme(),
          shadows: const GrafitShadowTheme(),
        );

  static GrafitColorScheme _createColorScheme(Color customColor) {
    // Return custom color scheme
    return GrafitColorScheme(
      // Your custom colors
      background: Colors.white,
      foreground: Colors.black,
      // ... rest of colors
    );
  }
}
```

## Text Styles

Grafit includes a complete typography scale following Flutter's text theme:

```dart
theme.text.displayLarge     // 57px, bold
theme.text.displayMedium    // 45px, bold
theme.text.displaySmall     // 36px, bold
theme.text.headlineLarge    // 32px, semibold
theme.text.headlineMedium   // 28px, semibold
theme.text.headlineSmall    // 24px, semibold
theme.text.titleLarge       // 22px, semibold
theme.text.titleMedium      // 16px, medium
theme.text.titleSmall       // 14px, medium
theme.text.bodyLarge        // 16px, regular
theme.text.bodyMedium       // 14px, regular
theme.text.bodySmall        // 12px, regular
theme.text.labelLarge       // 14px, medium
theme.text.labelMedium      // 12px, medium
theme.text.labelSmall       // 11px, medium
```

## Border Radius

```dart
theme.borders.radius  // Base radius multiplier (default 0.5)
theme.borders.sm      // Small radius
theme.borders.md      // Medium radius
theme.borders.lg      // Large radius
theme.borders.xl      // Extra large radius
```

Usage in components:

```dart
BorderRadius.circular(colors.radius * 8)  // 4px radius
BorderRadius.circular(colors.radius * 12) // 6px radius
```

## Shadows

```dart
theme.shadows.sm  // Small shadow
theme.shadows.md  // Medium shadow
theme.shadows.lg  // Large shadow
theme.shadows.xl  // Extra large shadow
```

## Dark Mode

Dark mode is automatically handled by using both light and dark themes:

```dart
MaterialApp(
  theme: ThemeData(
    extensions: [GrafitTheme.light()],
  ),
  darkTheme: ThemeData(
    extensions: [GrafitTheme.dark()],
  ),
  themeMode: ThemeMode.system, // or .light, .dark
)
```

### Manual Dark Mode Toggle

```dart
class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  void toggleTheme() {
    _themeMode = _themeMode == ThemeMode.light
        ? ThemeMode.dark
        : ThemeMode.light;
    notifyListeners();
  }
}
```

## Accessing Theme in Components

```dart
class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<GrafitTheme>()!;
    final colors = theme.colors;

    return Container(
      color: colors.background,
      child: Text(
        'Hello',
        style: theme.text.bodyLarge,
      ),
    );
  }
}
```

Or using the extension:

```dart
import 'package:gft_ui/gft_ui.dart';

class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = context.gftTheme;
    final colors = theme.colors;

    return Container(
      color: colors.primary,
      child: Text('Hello'),
    );
  }
}
```

## Component-Level Customization

Since you own the component code, you can customize any component directly:

```dart
// lib/components/ui/custom_button.dart
import 'package:gft_ui/gft_ui.dart';

class CustomButton extends StatelessWidget {
  // ... your custom implementation using GrafitTheme
}
```

## Best Practices

1. **Use Theme Colors**: Always reference theme colors instead of hardcoded values
2. **Respect Base Color**: Choose a base color and stick with it for consistency
3. **Test Both Modes**: Ensure components work in light and dark modes
4. **Semantic Naming**: Use semantic color names (primary, destructive, etc.)
5. **Minimal Customization**: Start with default theme, customize only what's needed

## Examples

### Themed Card

```dart
GrafitCard(
  child: Column(
    children: [
      GrafitText.headlineSmall('Title'),
      const SizedBox(height: 8),
      GrafitText.muted('Description'),
    ],
  ),
)
```

### Custom Colored Button

```dart
GrafitButton(
  label: 'Delete',
  variant: GrafitButtonVariant.destructive,
  onPressed: () {},
)
```

### Themed Alert

```dart
GrafitAlert(
  title: 'Warning',
  description: 'Something went wrong',
  variant: GrafitAlertVariant.warning,
)
```
