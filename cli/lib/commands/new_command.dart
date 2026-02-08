import 'dart:io';
import 'package:args/args.dart';
import 'package:args/command_runner.dart';
import 'package:path/path.dart' as p;
import '../utils/output.dart';
import '../registry/registry_loader.dart';

/// Available component categories from shadcn-ui
const shadcnCategories = [
  'form',
  'layout',
  'navigation',
  'overlay',
  'feedback',
  'data-display',
  'typography',
  'specialized',
];

class NewCommand extends Command<void> {
  @override
  String get name => 'new';

  @override
  String get description => 'Scaffold a new component from shadcn-ui source';

  @override
  ArgParser get argParser {
    return ArgParser()
      ..addOption('category',
          abbr: 'c',
          help: 'Component category',
          allowed: shadcnCategories)
      ..addOption('output',
          abbr: 'o',
          help: 'Output directory (relative to packages/grafit_ui/lib/src/components)')
      ..addFlag('list',
          abbr: 'l',
          negatable: false,
          help: 'List available shadcn-ui components');
  }

  @override
  Future<void> run() async {
    final args = argResults!;

    // Handle list flag
    if (args['list'] as bool) {
      _listAvailableComponents();
      return;
    }

    // Get component name
    if (argResults!.rest.isEmpty) {
      printError('No component specified');
      printInfo('Usage: gft new <component-name>');
      printInfo('Run: gft new --list to see available components');
      return;
    }

    final componentName = argResults!.rest.first;
    final category = args['category'] as String?;
    final outputDir = args['output'] as String?;

    printHeader('Creating New Component: $componentName');
    printSeparator();

    // Validate component name
    if (!_isValidComponentName(componentName)) {
      printError('Invalid component name: $componentName');
      printInfo('Use lowercase, letters, numbers, and hyphens only');
      return;
    }

    // Check if component already exists
    final registry = RegistryLoader.loadFromCurrent();
    if (registry.getComponent(componentName) != null) {
      printError('Component "$componentName" already exists');
      printInfo('Run: gft view $componentName to see the existing component');
      return;
    }

    await _createComponent(componentName, category, outputDir);
  }

  bool _isValidComponentName(String name) {
    final regex = RegExp(r'^[a-z][a-z0-9-]*$');
    return regex.hasMatch(name);
  }

  void _listAvailableComponents() {
    printHeader('Available shadcn-ui Components');
    printSeparator();
    printInfo('This is a reference list of components available in shadcn-ui');
    printInfo('Visit: https://ui.shadcn.com/docs/components');
    printSeparator();

    final components = {
      'Form': ['accordion', 'alert', 'alert-dialog', 'auto-form', 'avatar', 'badge',
        'button', 'calendar', 'card', 'checkbox', 'collapsible', 'combobox',
        'command', 'context-menu', 'data-table', 'date-picker', 'dialog',
        'drawer', 'dropdown-menu', 'form', 'hover-card', 'input', 'input-otp',
        'label', 'menubar', 'native-select', 'navigation-menu', 'pagination',
        'popover', 'progress', 'radio-group', 'resizable', 'scroll-area', 'select',
        'separator', 'sheet', 'sidebar', 'skeleton', 'slider', 'sonner', 'switch',
        'table', 'tabs', 'textarea', 'toast', 'toggle', 'toggle-group', 'tooltip'],
      'Layout': ['aspect-ratio', 'container', 'direction', 'empty', 'separator', 'spacer'],
      'Navigation': ['breadcrumb', 'menubar', 'navigation-menu', 'pagination', 'sidebar', 'tabs'],
      'Overlay': ['dialog', 'drawer', 'dropdown-menu', 'popover', 'sheet', 'toast'],
      'Feedback': ['alert', 'alert-dialog', 'progress', 'sonner', 'toast', 'tooltip'],
      'Data Display': ['aspect-ratio', 'avatar', 'badge', 'calendar', 'card', 'carousel',
        'chart', 'data-table', 'empty', 'separator', 'skeleton', 'table'],
      'Typography': ['blockquote', 'inline-code', 'kbd', 'list', 'p', 'small'],
      'Specialized': ['accordion', 'collapsible', 'command', 'context-menu', 'direction',
        'field', 'hover-card', 'input-group', 'item', 'resizable', 'scroll-area',
        'sonner', 'spinner', 'toggle', 'toggle-group'],
    };

    components.forEach((category, items) {
      print('');
      printHeader(category);
      for (var item in items) {
        final exists = _componentExists(item);
        final status = exists ? '✓' : '○';
        print('  $status $item');
      }
    });

    print('');
    printSeparator();
    printInfo('✓ = Already implemented in Grafit UI');
    printInfo('○ = Available to scaffold');
    printSeparator();
    printInfo('Usage: gft new <component-name> [--category=<category>]');
  }

  bool _componentExists(String name) {
    try {
      final registry = RegistryLoader.loadFromCurrent();
      return registry.getComponent(name) != null;
    } catch (e) {
      return false;
    }
  }

  Future<void> _createComponent(
    String componentName,
    String? category,
    String? outputDir,
  ) async {
    printInfo('This will create a new component from shadcn-ui source');
    printSeparator();
    printInfo('Component: $componentName');
    if (category != null) {
      printInfo('Category: $category');
    }
    if (outputDir != null) {
      printInfo('Output: $outputDir');
    }
    printSeparator();

    print('');
    printWarning('This feature is a placeholder for future implementation.');
    printInfo('');
    printInfo('To scaffold a new component from shadcn-ui:');
    printIndent('1. Visit: https://ui.shadcn.com/docs/components/$componentName');
    printIndent('2. Review the React/Tsx source code');
    printIndent('3. Convert to Flutter/Dart patterns');
    printIndent('4. Add to packages/grafit_ui/lib/src/components/');
    printIndent('5. Create metadata file in lib/registry/');
    printIndent('6. Update COMPONENT_REGISTRY.yaml');
    print('');
    printInfo('See CONTRIBUTING.md for detailed component creation guide.');

    // In a full implementation, this would:
    // 1. Fetch component source from shadcn-ui repository
    // 2. Parse the React/TSX code
    // 3. Convert to Flutter/Dart patterns
    // 4. Create the component file
    // 5. Create the metadata file
    // 6. Update the registry
    // 7. Create Widgetbook use cases
    // 8. Create tests
  }
}
