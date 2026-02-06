# Grafit - shadcn/ui for Flutter

A Flutter port of [shadcn/ui](https://ui.shadcn.com/) with a CLI tool for component management, following the copy-paste philosophy.

## Features

✅ **Theme System**: Light/dark themes with zinc, slate, neutral, and stone color schemes
✅ **Base Primitives**: Clickable, Focusable, and Dismissible widgets
✅ **Core Components**: Button, Input, Text, Typography
✅ **Form Components**: Checkbox, Switch, Slider
✅ **Layout Components**: Card, Separator
✅ **Navigation**: Tabs component
✅ **Overlays**: Dialog, Tooltip
✅ **Feedback**: Alert component
✅ **Data Display**: Badge, Avatar
✅ **Specialized**: Resizable, ScrollArea, Collapsible
✅ **CLI Tool**: init, add, list, view commands

## Philosophy

- **Copy-paste model**: Components are copied directly into projects (not a pub.dev package)
- **Full ownership**: Developers can modify components at source level
- **Theme-based customization**: Centralized theming system
- **State management agnostic**: Works with Bloc, Provider, Riverpod, etc.

## Project Structure

```
pikpo-ui-shadcn/
├── cli/                          # CLI tool
│   ├── bin/gft.dart              # Main entry point
│   └── lib/
│       ├── commands/             # CLI commands
│       ├── config/               # Configuration manager
│       └── utils/                # File utilities
├── packages/
│   ├── grafit_ui/                # Core component library
│   │   ├── lib/
│   │   │   ├── src/
│   │   │   │   ├── theme/        # Theme system
│   │   │   │   ├── primitives/    # Base widgets
│   │   │   │   └── components/    # UI components
│   │   └── example/              # Demo app
│   └── registry/                 # Component templates
├── docs/                         # Documentation
├── melos.yaml                   # Melos workspace
└── README.md
```

## Installation

### Prerequisites

- Flutter 3.27+
- Dart 3.6+
- Melos (for workspace management)

```bash
dart pub global activate melos
```

### Setup

```bash
# Install dependencies
melos bootstrap

# Run the demo app
cd packages/grafit_ui/example
flutter run
```

### CLI Usage

```bash
# Activate CLI globally (first time only)
dart pub global activate --source path ./cli

# Initialize in a Flutter project
gft init

# Add components
gft add button
gft add --all

# List components
gft list

# View component source
gft view button
```

## Documentation

- [Getting Started](docs/getting-started.md)
- [Theming](docs/theming.md)
- [CLI Reference](docs/cli-reference.md)

## Status

This is an early implementation. The foundation is in place with:

- ✅ Project structure and Melos workspace
- ✅ Theme system with light/dark modes
- ✅ Base primitives (Clickable, Focusable, Dismissible)
- ✅ Core components (Button, Input, Text)
- ✅ Additional components (Card, Tabs, Dialog, Alert, Badge, Avatar, etc.)
- ✅ CLI tool with init, add, list, view commands
- ✅ Demo app
- ✅ Documentation

## Contributing

Contributions are welcome! Please see [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

## License

MIT
