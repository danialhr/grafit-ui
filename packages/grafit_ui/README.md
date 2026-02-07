# Grafit UI

> A Flutter component library with 59 beautiful components inspired by shadcn/ui.

## Installation

Add this package to your `pubspec.yaml`:

```yaml
dependencies:
  grafit_ui:
    git:
      url: https://github.com/danialhr/grafit-ui.git
      ref: main
      path: packages/grafit_ui
```

## Quick Start

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
```

## Components

### Form Components
- `GrafitButton` - Button with 6 variants (primary, secondary, ghost, outline, link, destructive)
- `GrafitInput` - Text input with 3 sizes
- `GrafitCheckbox` - Checkbox with tri-state support
- `GrafitSwitch` - Toggle switch
- `GrafitSlider` - Slider with range mode
- `GrafitTextarea` - Multi-line input
- `GrafitLabel` - Form label with required indicator
- `GrafitSelect` - Dropdown select
- `GrafitCombobox` - Autocomplete combobox
- `GrafitRadioGroup` - Radio button group
- `GrafitToggleGroup` - Toggle button group
- `GrafitToggle` - Toggle button
- `GrafitInputOtp` - OTP input with auto-focus
- `GrafitForm` - Form state management
- `GrafitAutoForm` - Auto-generated form from schema
- `GrafitField` - Form field wrapper
- `GrafitInputGroup` - Input with prefix/suffix addons
- `GrafitNativeSelect` - Native platform select
- `GrafitButtonGroup` - Connected button group
- `GrafitDatePicker` - Date picker with calendar

### Navigation Components
- `GrafitTabs` - Tabs (value/line variants, horizontal/vertical)
- `GrafitBreadcrumb` - Navigation breadcrumb
- `GrafitSidebar` - Collapsible sidebar
- `GrafitDropdownMenu` - Dropdown menu
- `GrafitNavigationMenu` - Navigation menu with dropdowns
- `GrafitMenubar` - Menu bar
- `GrafitPagination` - Page pagination

### Overlay Components
- `GrafitDialog` - Modal dialog
- `GrafitTooltip` - Hover tooltip
- `GrafitPopover` - Floating content
- `GrafitAlertDialog` - Alert dialog
- `GrafitCommand` - Command palette
- `GrafitContextMenu` - Right-click menu
- `GrafitHoverCard` - Hover card
- `GrafitSonner` - Toast notifications
- `GrafitSheet` - Slide-in panel
- `GrafitDrawer` - Slide-in drawer
- `GrafitCollapsible` - Collapsible content

### Feedback Components
- `GrafitAlert` - Alert banner
- `GrafitProgress` - Progress indicator
- `GrafitSkeleton` - Loading skeleton
- `GrafitSpinner` - Loading spinner

### Data Display Components
- `GrafitBadge` - Status badge
- `GrafitAvatar` - User avatar
- `GrafitCard` - Content card
- `GrafitDataTable` - Structured data table
- `GrafitTable` - Basic table
- `GrafitPagination` - Page pagination
- `GrafitEmpty` - Empty state
- `GrafitChart` - Grammar of graphics chart
- `GrafitItem` - List item
- `GrafitSeparator` - Visual separator

### Typography Components
- `GrafitText` - Typography with variants
- `GrafitKbd` - Keyboard key styling

### Layout Components
- `GrafitCard` - Content card
- `GrafitSeparator` - Visual separator
- `GrafitAccordion` - Collapsible accordion

### Specialized Components
- `GrafitResizable` - Resizable panels
- `GrafitScrollArea` - Custom scroll area
- `GrafitCollapsible` - Collapsible content
- `GrafitDrawer` - Slide-in drawer
- `GrafitSheet` - Slide-in sheet
- `GrafitAspectRatio` - Aspect ratio container
- `GrafitCalendar` - Calendar widget
- `GrafitCarousel` - Image carousel
- `GrafitDirection` - Text direction (LTR/RTL)

## Theming

Grafit UI uses a comprehensive theme system:

```dart
// Pre-built themes
GrafitThemeData.light()
GrafitThemeData.dark()

// Custom from seed color
GrafitColorScheme.fromSeed(
  seedColor: Colors.blue,
  brightness: Brightness.light,
)

// Custom theme
GrafitThemeData(
  colorScheme: GrafitColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFF6366F1),
    secondary: Color(0xFF8B5CF6),
    // ... other colors
  ),
)
```

## Documentation

- **Interactive Docs**: Run `cd ../widgetbook && flutter run -d chrome`
- **Component Registry**: See [COMPONENT_REGISTRY.yaml](../../COMPONENT_REGISTRY.yaml)
- **Tests**: See [test/README.md](test/README.md)

## License

MIT
