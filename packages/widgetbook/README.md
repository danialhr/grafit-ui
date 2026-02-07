# Widgetbook for Grafit UI

This package contains an interactive component showcase for the Grafit UI library using [Widgetbook](https://widgetbook.io/).

## What is Widgetbook?

Widgetbook is a Flutter package that helps developers create and showcase interactive component libraries. It provides:

- **Interactive Knobs**: Modify component properties in real-time
- **Theme Switching**: Test components in different themes (light/dark)
- **Text Scaling**: Test accessibility with different text scales
- **Organization**: Structure components in a logical hierarchy

## Running Widgetbook

### Run on Chrome (Web)
```bash
cd packages/widgetbook
flutter run -d chrome
```

### Run on other devices
```bash
# macOS
flutter run -d macos

# Windows
flutter run -d windows

# Linux
flutter run -d linux

# Mobile (ensure device is connected)
flutter run
```

## Adding New Use Cases

To add a new component to Widgetbook:

### 1. Create a new use case file

Create a new file in `lib/components/` (e.g., `my_component_use_case.dart`):

```dart
import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:grafit_ui/grafit_ui.dart';

Widget myComponentUseCase(BuildContext context) {
  // Add knobs for interactive properties
  final title = context.knobs.string(
    label: 'Title',
    defaultValue: 'Hello World',
  );
  
  final disabled = context.knobs.boolean(
    label: 'Disabled',
    defaultValue: false,
  );
  
  return Center(
    child: GrafitMyComponent(
      title: title,
      disabled: disabled,
    ),
  );
}
```

### 2. Register the use case

Add your use case to `lib/widgetbook.dart`:

```dart
import 'components/my_component_use_case.dart';

// In the WidgetbookCategory children:
WidgetbookComponent(
  name: 'My Component',
  useCases: [
    WidgetbookUseCase(
      name: 'My Component',
      builder: myComponentUseCase,
    ),
  ],
),
```

## Available Knobs

Widgetbook provides various knobs for different data types:

- `context.knobs.string()` - Text input
- `context.knobs.boolean()` - Toggle switch
- `context.knobs.double.slider()` - Slider for numeric values
- `context.knobs.object.dropdown()` - Dropdown selection for enums
- `context.knobs.color()` - Color picker

## Addons

Widgetbook comes with several addons configured:

### MaterialThemeAddon
Switch between light and dark themes with GrafitTheme.

### TextScaleAddon
Test accessibility with text scaling:
- 1.0 (normal)
- 1.5 (150%)
- 2.0 (200%)

## Project Structure

```
packages/widgetbook/
├── lib/
│   ├── components/          # Component use cases
│   │   ├── buttons_use_case.dart
│   │   ├── inputs_use_case.dart
│   │   ├── cards_use_case.dart
│   │   ├── dialogs_use_case.dart
│   │   └── tabs_use_case.dart
│   └── widgetbook.dart      # Main entry point
├── pubspec.yaml
└── README.md
```

## Implemented Components

All 59 Grafit UI components have interactive use cases with 400+ scenarios total:

### Form Components (18)
- Button, Input, Checkbox, Switch, Slider, Textarea, Label, Select, Combobox, Radio Group, Toggle Group, Toggle, Input OTP, Form, Auto Form, Field, Input Group, Native Select, Button Group, Date Picker

### Navigation Components (7)
- Tabs, Breadcrumb, Sidebar, Dropdown Menu, Navigation Menu, Menubar, Pagination

### Overlay Components (8)
- Dialog, Tooltip, Popover, Alert Dialog, Command, Context Menu, Hover Card, Sonner, Sheet, Drawer, Collapsible

### Feedback Components (5)
- Alert, Progress, Skeleton, Spinner, Sonner

### Data Display Components (9)
- Badge, Avatar, Card, Data Table, Table, Pagination, Empty, Chart, Item, Separator

### Typography Components (2)
- Text, Kbd

### Layout Components (3)
- Card, Separator, Accordion

### Specialized Components (11)
- Resizable, Scroll Area, Collapsible, Drawer, Sheet, Aspect Ratio, Calendar, Carousel, Direction

### Use Cases per Component
- Each component has 5-15 use cases covering:
  - Default/basic usage
  - All variants (primary, secondary, ghost, outline, etc.)
  - All sizes (sm, md, lg, xl)
  - States (disabled, error, loading)
  - Interactive knobs for real-time customization

## Tips for Great Use Cases

1. **Show All Variants**: Display all variants (sizes, colors, states) of a component
2. **Interactive Knobs**: Make key properties adjustable with knobs
3. **Realistic Content**: Use realistic content, not just "Lorem Ipsum"
4. **States**: Show different states (disabled, error, loading, etc.)
5. **Combinations**: Show how components work together
6. **Responsive**: Ensure components work well on different screen sizes

## Troubleshooting

### Hot reload not working
If hot reload doesn't pick up changes to use cases, try hot restart (`r` in terminal) or rebuild.

### Theme not applying
Ensure you're using the theme extension in your components:
```dart
final theme = Theme.of(context).extension<GrafitTheme>()!;
final colors = theme.colors;
```

## Resources

- [Widgetbook Documentation](https://docs.widgetbook.io/)
- [Widgetbook GitHub](https://github.com/widgetbook/widgetbook)
- [Grafit UI Documentation](../grafit_ui/README.md)
