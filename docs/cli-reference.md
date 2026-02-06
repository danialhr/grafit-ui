# CLI Reference

Complete reference for all Grafit CLI commands.

## Installation

Install the CLI globally (one-time setup):

```bash
dart pub global activate --source path ./cli
```

After activation, use commands directly:

```bash
gft <command>
```

Or run directly without activation:

```bash
dart ./cli/bin/gft.dart <command>
```

## Global Options

- `-h, --help`: Show help
- `-v, --version`: Show CLI version

## Commands

### `init`

Initialize a Flutter project with Grafit.

**Usage:**
```bash
gft init [options]
```

**Options:**
- `--src-dir`: Use src/ directory for components (not implemented yet)
- `--no-css-variables`: Disable theme variables (default: true)
- `--base-color <color>`: Base color scheme (zinc, slate, neutral, stone)
- `-y, --yes`: Skip confirmation prompts
- `-f, --force`: Overwrite existing config

**Examples:**

```bash
# Default initialization
gft init

# With slate color scheme
gft init --base-color slate

# Skip prompts
gft init --yes

# Force re-initialization
gft init --force
```

**What it creates:**
- `components.json` - Configuration file
- `lib/components/ui/` - Components directory
- Theme setup instructions

### `add`

Add a component to your project.

**Usage:**
```bash
gft add <component> [options]
gft add <component1> <component2> ... [options]
```

**Options:**
- `-a, --all`: Add all available components
- `--overwrite`: Overwrite existing component files
- `--path <path>`: Custom output path
- `-y, --yes`: Skip confirmation prompts

**Examples:**

```bash
# Add a single component
gft add button

# Add multiple components
gft add button input checkbox

# Add all components
gft add --all

# Add to custom path
gft add button --path lib/widgets

# Overwrite existing component
gft add button --overwrite
```

**What it does:**
1. Reads component from registry
2. Processes template variables
3. Copies component files to project
4. Adds dependencies if needed
5. Runs `dart pub get`

### `list`

List all available components.

**Usage:**
```bash
gft list
```

**Output:**
```
Available Components:

FORM
  button - Button with variants
  input - Text input field
  checkbox - Checkbox input
  switch - Toggle switch
  ...

Total: 47 components
```

**Examples:**

```bash
# List all components
gft list
```

### `view`

View component source before installing.

**Usage:**
```bash
gft view <component>
```

**Output:**
```
═══════════════════════════════════════════════════════════════
  Component: button
  Category: form
═══════════════════════════════════════════════════════════════

Description:
  Button component with variants (primary, secondary, ghost, link)

Dependencies:
  None

Files:
  - button.dart

Source Preview:
───────────────────────────────────────────────────────────────
     1	// This is a template file
     2	import 'package:flutter/material.dart';
     ...
───────────────────────────────────────────────────────────────

To install this component, run: gft add button
```

**Examples:**

```bash
# View button component
gft view button

# View input component
gft view input
```

## Configuration File

The `components.json` file controls CLI behavior:

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

### Fields

- **style**: Component style variant (currently only "default")
- **componentsPath**: Where components are copied to
- **themeExtension**: Theme extension class name
- **baseColor**: Default base color for themes
- **useThemeVariables**: Enable theme variable usage
- **rtl**: Enable right-to-left layout support

## Component Naming

Components use kebab-case for CLI commands:

```bash
gft add button-group
gft add radio-group
gft add date-picker
gft add context-menu
```

## Exit Codes

- `0`: Success
- `1`: Error occurred
- `2`: Invalid usage

## Error Messages

### "Not a valid Flutter project"

The `pubspec.yaml` file is missing. Run this command in a Flutter project directory.

### "Grafit is already initialized"

Use `--force` to re-initialize or modify `components.json` directly.

### "Component not found"

The component doesn't exist. Use `gft list` to see available components.

## Tips

1. **Check Before Adding**: Use `gft view` to see component source before adding
2. **Add What You Need**: Only add components you'll use to keep project small
3. **Version Control**: Commit `components.json` to track configuration
4. **Customize Freely**: Since components are copied, you can modify them directly

## Troubleshooting

### CLI Not Found

Make sure the CLI bin directory is in your PATH:

```bash
export PATH="$PATH:$HOME/.pub-cache/bin"
```

### Components Not Found

Check that `componentsPath` in `components.json` matches your actual directory structure.

### Theme Errors

Ensure `GrafitTheme` is added to your `MaterialApp` extensions:

```dart
MaterialApp(
  theme: ThemeData(
    extensions: [GrafitTheme.light()],
  ),
)
```

## Advanced Usage

### Aliases

Create aliases for common commands:

```bash
# In ~/.bashrc or ~/.zshrc
alias pi='gft init'
alias pa='gft add'
alias pl='gft list'
alias pv='gft view'
```

### Scripts

Add to `package.json` or scripts:

```json
{
  "scripts": {
    "ui:init": "gft init --yes",
    "ui:add": "gft add",
    "ui:add:all": "gft add --all"
  }
}
```

### CI/CD

Use in CI/CD pipelines:

```yaml
- name: Setup Grafit
  run: |
    gft init --yes
    gft add button input
```
