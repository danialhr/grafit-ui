# Grafit UI Example App

A comprehensive demo app showcasing all Grafit UI components.

## Screens Created

### Home Screen (`home_screen.dart`)
- Welcome page with feature cards
- Component category grid with navigation
- 6 main categories: Form, Navigation, Overlay, Feedback, Data Display, Specialized

### Form Components Screen (`form_components_screen.dart`)
- **Buttons**: All variants (primary, secondary, outline, ghost, destructive, link)
- **Button Sizes**: Small, medium, large, icon
- **Button States**: Default, disabled, loading
- **Inputs**: Text input, email, password, disabled, with error
- **Checkboxes**: Multiple states with labels
- **Switches**: Toggle switches
- **Sliders**: Value display slider

### Navigation Screen (`navigation_screen.dart`)
- **Tabs**: Horizontal tabs with content panels
- **Breadcrumb**: Navigation breadcrumb
- **Dropdown Menu**: Interactive dropdown
- **Navigation Menu**: Side navigation

### Overlay Screen (`overlay_screen.dart`)
- **Dialog**: Modal dialogs with confirm/cancel
- **Alert Dialog**: Warning dialogs
- **Popover**: Hover-triggered content
- **Tooltip**: Hover tooltips
- **Hover Card**: Rich hover content
- **Context Menu**: Right-click menu
- **Sheet**: Side/bottom sliding panels

### Feedback Screen (`feedback_screen.dart`)
- **Alert**: Info, warning, error alerts
- **Progress**: Linear and indeterminate progress
- **Skeleton**: Loading placeholders
- **Sonner/Toast**: Success, error, warning, info, loading toasts

### Data Display Screen (`data_display_screen.dart`)
- **Badge**: Various badge styles
- **Avatar**: Text, image, icon avatars
- **Data Table**: Sortable table with selection
- **Pagination**: Page navigation

### Specialized Screen (`specialized_screen.dart`)
- **Calendar**: Date picker
- **Carousel**: Image/content carousel
- **Resizable**: Split panels
- **Drawer**: Slide-in panels
- **Scroll Area**: Custom scrollbars
- **Accordion**: Expandable sections

## How to Run

```bash
cd packages/grafit_ui/example
flutter run
```

## Features Included

1. **Comprehensive Component Coverage**: All major Grafit UI components demonstrated
2. **Interactive Demos**: Working examples with state management
3. **Best Practices**: Shows proper usage patterns
4. **Code Examples**: Copy-paste friendly code structure
5. **GrafitTheme Integration**: Uses proper theming throughout
6. **Light/Dark Mode**: Automatic theme switching

## File Structure

```
example/lib/
├── main.dart                    # App entry point with routes
└── screens/
    ├── home_screen.dart         # Home page
    ├── form_components_screen.dart
    ├── navigation_screen.dart
    ├── overlay_screen.dart
    ├── feedback_screen.dart
    ├── data_display_screen.dart
    └── specialized_screen.dart
```

## Component Categories

- **Form Components**: Button, Input, Checkbox, Switch, Slider, Textarea
- **Navigation**: Tabs, Breadcrumb, Dropdown Menu
- **Overlay**: Dialog, Alert Dialog, Popover, Tooltip, Sheet
- **Feedback**: Alert, Progress, Skeleton, Sonner (Toast)
- **Data Display**: Badge, Avatar, Data Table, Pagination
- **Specialized**: Calendar, Carousel, Resizable, Drawer, Scroll Area, Accordion
