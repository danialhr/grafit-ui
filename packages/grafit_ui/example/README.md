# Grafit UI Example App

A comprehensive demo app showcasing all 59 Grafit UI components with interactive examples.

## Screens Created

### Home Screen (`home_screen.dart`)
- Welcome page with feature cards
- Component category grid with navigation
- 7 main categories: Form, Navigation, Overlay, Feedback, Data Display, Typography, Specialized

### Form Components Screen (`form_components_screen.dart`)
- **Button**: All 6 variants (primary, secondary, ghost, outline, link, destructive)
- **Button Sizes**: sm, md, lg, icon
- **Button States**: Default, disabled, loading
- **Input**: Text input with sizes (sm, md, lg)
- **Input States**: Disabled, error, readonly, password
- **Checkbox**: Checked, unchecked, indeterminate states
- **Switch**: On/off toggle with sizes
- **Slider**: Single and range modes
- **Textarea**: Multi-line with character count
- **Select**: Dropdown with search
- **Combobox**: Autocomplete with create option
- **Radio Group**: Single selection
- **Toggle Group**: Single/multi selection
- **Toggle**: Toggle button
- **Input OTP**: OTP digit input
- **Label**: With required indicator
- **Field**: Field wrapper with label/error
- **Input Group**: With prefix/suffix addons
- **Date Picker**: Calendar with popup
- **Button Group**: Connected buttons
- **Auto Form**: Schema-generated form
- **Form**: Complete form with validation
- **Native Select**: Platform dropdown

### Navigation Screen (`navigation_screen.dart`)
- **Tabs**: Horizontal/vertical, value/line variants
- **Breadcrumb**: Navigation trail with separators
- **Sidebar**: Collapsible sidebar with groups
- **Dropdown Menu**: 8 alignment options
- **Navigation Menu**: Horizontal with dropdowns
- **Menubar**: Classic menu bar with submenus
- **Pagination**: Page navigation with ellipsis

### Overlay Screen (`overlay_screen.dart`)
- **Dialog**: Modal dialogs
- **Alert Dialog**: Confirmation dialogs
- **Popover**: Floating content
- **Tooltip**: Hover tooltips
- **Hover Card**: Rich hover content
- **Context Menu**: Right-click menu
- **Sheet**: Slide-in panels (4 directions)
- **Drawer**: Directional slide-in
- **Command**: Command palette with search
- **Sonner**: Toast notifications (6 positions)
- **Collapsible**: Expand/collapse content

### Feedback Screen (`feedback_screen.dart`)
- **Alert**: All variants (default, destructive, warning)
- **Progress**: Determinate and indeterminate
- **Skeleton**: Loading placeholders (avatar, text, card)
- **Spinner**: Rotating loader with variants

### Data Display Screen (`data_display_screen.dart`)
- **Badge**: All 6 variants
- **Avatar**: With initials, images, fallback
- **Card**: With header/footer
- **Data Table**: With sorting and pagination
- **Table**: Basic table structure
- **Pagination**: Page navigation
- **Empty**: Empty state displays
- **Chart**: 12 chart types (line, bar, pie, donut, etc.)
- **Item**: List items with variants
- **Separator**: Horizontal/vertical dividers

### Typography Screen (`typography_screen.dart`)
- **Text**: All variants (display, headline, title, body, label)
- **Kbd**: Keyboard shortcuts display

### Specialized Screen (`specialized_screen.dart`)
- **Resizable**: Split panels (2-4 panels)
- **Scroll Area**: Custom scrollbars
- **Collapsible**: Expandable sections
- **Drawer**: Slide-in panels
- **Sheet**: Modal sheets
- **AspectRatio**: Common ratio presets
- **Calendar**: Month view with selection modes
- **Carousel**: Auto-play with loop
- **Direction**: LTR/RTL text direction

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
