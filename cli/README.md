# Grafit CLI (`gft`)

Command-line interface for Grafit UI - Flutter component library based on shadcn/ui.

## Installation

The CLI is included in the Grafit UI repository. Run it from the repository root:

```bash
dart run cli/bin/gft.dart <command>
```

For convenience, you can create an alias in your shell:

```bash
# Add to ~/.zshrc or ~/.bashrc
alias gft='dart run /path/to/grafit-ui/cli/bin/gft.dart'

# Then use directly
gft list
```

## Commands

### `gft init`

Initialize Grafit UI in a Flutter project.

```bash
gft init [options]
```

**Options:**
- `--src-dir` - Use src/ directory for components
- `--css-variables` - Use theme variables (default: true)
- `--base-color` - Base color scheme (zinc, slate, neutral, stone)
- `--components-path` - Path to components directory (default: lib/ui)
- `-y, --yes` - Skip confirmation prompts
- `-f, --force` - Overwrite existing configuration

**Example:**
```bash
gft init --base-color slate --components-path lib/components
```

**Creates:**
- `components.json` - Project configuration
- `lib/ui/` - Components directory
- `lib/ui/grafit_ui.dart` - Export file

---

### `gft add`

Add a component to your project.

```bash
gft add <component> [options]
```

**Options:**
- `-a, --all` - Add all available components
- `-o, --overwrite` - Overwrite existing files
- `--path` - Custom output path for components
- `-y, --yes` - Skip confirmation prompts

**Examples:**
```bash
# Add a single component
gft add button

# Add all components
gft add --all

# Add with custom path
gft add button --path lib/ui/components

# Skip prompts
gft add button --yes
```

---

### `gft remove`

Remove a component from your project.

```bash
gft remove <component> [options]
```

**Options:**
- `-f, --force` - Force removal without confirmation
- `-y, --yes` - Skip confirmation prompts

**Example:**
```bash
gft remove button
```

**Removes:**
- Component directory
- Export from grafit_ui.dart
- Entry from components.json

---

### `gft list`

List all available components.

```bash
gft list
```

**Output:**
```
══════════════════════════════════
  Available Grafit UI Components
══════════════════════════════════

Form
────────────────────────────────────────
  ✓ button (100%)
  ✓ input (90%)
  ✓ checkbox (90%)
  ...
```

**Status indicators:**
- `✓` - Stable component (90%+ parity)
- `~` - In development (70-89% parity)
- `○` - Early stage (<70% parity)

---

### `gft view`

View component source code.

```bash
gft view <component> [options]
```

**Options:**
- `-e, --editor` - Open source in editor (code, vim, nano, etc.)
- `--metadata` - Show component metadata only

**Examples:**
```bash
# View source preview
gft view button

# Open in VS Code
gft view button --editor code

# Show metadata only
gft view button --metadata
```

---

### `gft new`

Scaffold a new component from shadcn-ui.

```bash
gft new <component> [options]
```

**Options:**
- `-c, --category` - Component category
- `-o, --output` - Output directory
- `-l, --list` - List available shadcn-ui components

**Examples:**
```bash
# List available components
gft new --list

# Scaffold a new component
gft new toast --category feedback
```

**Available categories:**
- form
- layout
- navigation
- overlay
- feedback
- data-display
- typography
- specialized

---

### `gft doctor`

Check project health and configuration.

```bash
gft doctor
```

**Checks:**
- Flutter/Dart installation
- Project structure
- Grafit UI initialization
- Dependencies
- Component status

**Example output:**
```
══════════════════════════
  Grafit UI Health Check
══════════════════════════

✓ Flutter Installation
✓ Dart Installation
✓ Flutter Project
⚠ Grafit Initialization
   Run: gft init to get started

✓ Healthy: 3
⚠ Warnings: 1
```

---

### `gft upgrade`

Upgrade components to latest versions.

```bash
gft upgrade [options]
```

**Options:**
- `-c, --check` - Check for updates without upgrading
- `-a, --all` - Upgrade all components
- `-y, --yes` - Skip confirmation prompts

**Examples:**
```bash
# Check for updates
gft upgrade --check

# Upgrade all components
gft upgrade --all

# Upgrade with confirmation
gft upgrade
```

---

### `gft update`

Update Grafit UI components (alias for upgrade).

```bash
gft update
```

---

### `gft version`

Show CLI version information.

```bash
gft version
```

**Output:**
```
══════════════
  Grafit CLI
══════════════

  Version: 0.1.0
────────────────────────────────────────────────────────────────────────────────
ℹ Flutter component library based on shadcn/ui
ℹ A beautiful component library for Flutter with 59 components at 100% parity
```

---

## Configuration

The CLI stores configuration in `components.json`:

```json
{
  "style": "default",
  "componentsPath": "lib/ui",
  "themeExtension": "GrafitTheme",
  "baseColor": "zinc",
  "useThemeVariables": true,
  "rtl": false,
  "installedComponents": ["button", "input", "checkbox"]
}
```

## Exit Codes

- `0` - Success
- `1` - General error
- `64` - Usage error (invalid command or arguments)

## Global Options

- `-h, --help` - Show help information
- `-V, --verbose` - Enable verbose output

## Examples

### Complete Workflow

```bash
# 1. Initialize in a Flutter project
gft init

# 2. List available components
gft list

# 3. Add components
gft add button
gft add input
gft add checkbox

# 4. Check project health
gft doctor

# 5. View component source
gft view button

# 6. Later, remove a component
gft remove checkbox

# 7. Check for updates
gft upgrade --check
```

### Quick Start

```bash
# Initialize and add all components at once
gft init --yes
gft add --all --yes
```

## Troubleshooting

### "Grafit not initialized"

Run `gft init` in your Flutter project root.

### "Component not found"

Run `gft list` to see available components.

### "Not a valid Flutter project"

Ensure you're in a directory with `pubspec.yaml`.

### Check project health

Run `gft doctor` to diagnose issues.

## Development

### Running from Source

```bash
cd /path/to/grafit-ui
dart run cli/bin/gft.dart <command>
```

### Building the CLI

```bash
cd cli
dart compile exe bin/gft.dart -o build/gft
```

### Running Tests

```bash
cd cli
dart test
```

## Contributing

See [CONTRIBUTING.md](../CONTRIBUTING.md) for guidelines.

## License

MIT © [Danial Haris](https://github.com/danialhr)
