import 'dart:io';
import 'package:args/command_runner.dart';
import 'package:path/path.dart' as p;
import '../config/config_manager.dart';
import '../utils/output.dart';
import '../registry/registry_loader.dart';
import '../models/registry.dart';

class ListCommand extends Command<void> {
  @override
  String get name => 'list';

  @override
  String get description => 'List all available components';

  @override
  Future<void> run() async {
    final projectPath = p.absolute('.');

    // Load registry
    try {
      final registry = RegistryLoader.loadFromCurrent();
      final config = GrafitConfig.load(projectPath);
      final isInitialized = config.installedComponents.isNotEmpty;

      printHeader('Available Grafit UI Components');
      printSeparator();

      // Get categories and sort them
      final categories = registry.categories;

      for (final category in categories) {
        _displayCategory(registry, category, config);
      }

      // Summary
      final totalComponents = registry.componentCount;
      final implementedComponents = registry.stableComponents.length;
      final fullParityComponents = registry.fullParityComponents.length;

      printSeparator();
      printHeader('Summary');
      printPair('Total components', '$totalComponents');
      printSuccess('Stable: $implementedComponents');
      printInfo('Full parity (90%+): $fullParityComponents');
      printSeparator();

      if (!isInitialized) {
        printWarning('Run "gft init" to initialize Grafit in your project');
      }

    } catch (e) {
      printError('Failed to load component registry: $e');
    }
  }

  void _displayCategory(ComponentRegistry registry, String category, GrafitConfig config) {
    final components = registry.getComponentsByCategory(category);

    if (components.isEmpty) return;

    print('');
    print(_formatCategory(category));
    printSeparator(char: '─', length: 40);

    // Sort by name
    components.sort((a, b) => a.name.compareTo(b.name));

    for (final component in components) {
      final parityStr = component.parity > 0 ? ' (${component.parity}%)' : '';
      final installedStr = config.hasComponent(component.name) ? ' [installed]' : '';
      final statusColor = component.hasFullParity ? '✓' : (component.isStable ? '~' : '○');

      print('  $statusColor ${component.name}$parityStr$installedStr');
    }
  }

  String _formatCategory(String category) {
    // Format category names nicely
    return category.split('-').map((word) =>
      word[0].toUpperCase() + word.substring(1)
    ).join(' ');
  }
}
