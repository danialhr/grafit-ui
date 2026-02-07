import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:yaml/yaml.dart';
import '../models/component.dart';
import '../models/registry.dart';

/// Loader for component registry from Grafit UI package
class RegistryLoader {
  static ComponentRegistry? _cachedRegistry;

  /// Convert YamlMap to regular Map
  static Map<String, dynamic>? _yamlMapToMap(YamlMap? yaml) {
    if (yaml == null) return {};
    final map = <String, dynamic>{};
    for (final entry in yaml.entries) {
      final value = entry.value;
      if (value is YamlMap) {
        map[entry.key.toString()] = _yamlMapToMap(value);
      } else if (value is YamlList) {
        map[entry.key.toString()] = value.map((e) =>
            e is YamlMap ? _yamlMapToMap(e) : e).toList();
      } else {
        map[entry.key.toString()] = value;
      }
    }
    return map;
  }

  /// Load the component registry from a Grafit UI package path
  static ComponentRegistry load(String grafitUiPath) {
    if (_cachedRegistry != null) {
      return _cachedRegistry!;
    }

    // Try to load from COMPONENT_REGISTRY.yaml at monorepo root first
    final monorepoRoot = _findMonorepoRoot();
    if (monorepoRoot != null) {
      final registryFile = File(p.join(monorepoRoot, 'COMPONENT_REGISTRY.yaml'));
      if (registryFile.existsSync()) {
        _cachedRegistry = _loadFromComponentRegistry(registryFile, grafitUiPath);
        return _cachedRegistry!;
      }
    }

    // Fallback to loading from lib/registry.yaml
    return ComponentRegistry.load(grafitUiPath);
  }

  /// Load from current directory or find Grafit UI package
  static ComponentRegistry loadFromCurrent() {
    final grafitPath = _findGrafitUiPath();
    return load(grafitPath);
  }

  /// Find the monorepo root directory
  static String? _findMonorepoRoot() {
    String current = Directory.current.path;

    // Search up for COMPONENT_REGISTRY.yaml
    while (current.isNotEmpty && current != '/') {
      final registryFile = File(p.join(current, 'COMPONENT_REGISTRY.yaml'));
      if (registryFile.existsSync()) {
        return current;
      }

      final parent = p.dirname(current);
      if (parent == current) break;
      current = parent;
    }

    return null;
  }

  /// Load from COMPONENT_REGISTRY.yaml format
  static ComponentRegistry _loadFromComponentRegistry(
    File registryFile,
    String grafitUiPath,
  ) {
    final content = registryFile.readAsStringSync();
    final yaml = loadYaml(content) as YamlMap;

    final data = <String, dynamic>{
      'version': '1.0.0',
      'name': 'grafit-ui',
      'upstream': _yamlMapToMap(yaml['upstream'] as YamlMap?),
    };

    // Parse categories
    final categoriesYaml = yaml['categories'] as YamlMap?;
    final categories = <String, String>{};
    if (categoriesYaml != null) {
      for (final entry in categoriesYaml.entries) {
        final key = entry.key.toString();
        final value = entry.value?.toString() ?? key;
        categories[key] = value;
      }
    }

    // Parse flutter components
    final componentsList = <GrafitComponent>[];
    final flutterComponents = yaml['flutter_components'] as YamlMap?;

    if (flutterComponents != null) {
      for (final entry in flutterComponents.entries) {
        final name = entry.key.toString();
        final compData = _yamlMapToMap(entry.value as YamlMap?) ?? {};

        // Map to GrafitComponent format
        final categoryKey = compData['category'] as String?;
        final category = categories[categoryKey] ?? categoryKey ?? 'specialized';

        componentsList.add(GrafitComponent(
          name: name,
          category: category,
          description: 'Component from shadcn-ui/ui',
          sourcePath: compData['flutter'] as String? ?? '',
          dartPath: compData['flutter'] as String? ?? '',
          status: (compData['status'] as String?) ?? 'stable',
          parity: (compData['parity'] as num?)?.toInt() ?? 100,
          dependencies: [], // Could be parsed from metadata if needed
          files: [
            compData['flutter'] as String? ?? '',
            compData['metadata'] as String? ?? '',
          ],
        ));
      }
    }

    return ComponentRegistry(
      data: data,
      components: componentsList,
    );
  }

  /// Find the Grafit UI package path
  ///
  /// Searches in:
  /// 1. Current directory
  /// 2. Parent directories
  /// 3. Sibling directories
  /// 4. Common package locations
  static String _findGrafitUiPath() {
    String current = Directory.current.path;

    // Search up the directory tree
    while (current.isNotEmpty && current != '/') {
      // Check if current directory is grafit_ui
      if (_isGrafitUiPackage(current)) {
        return current;
      }

      // Check for grafit_ui in subdirectories
      final libDir = Directory(p.join(current, 'lib'));
      if (libDir.existsSync()) {
        final registryFile = File(p.join(current, 'lib', 'registry.yaml'));
        if (registryFile.existsSync()) {
          return current;
        }
      }

      // Move up
      final parent = p.dirname(current);
      if (parent == current) break;
      current = parent;
    }

    // Search in common package locations
    final searchPaths = [
      // Relative to monorepo root
      p.join(Directory.current.path, '..', 'grafit_ui'),
      p.join(Directory.current.path, '..', 'packages', 'grafit_ui'),
      // Local development
      p.join(Directory.current.path, 'grafit_ui'),
      // Home directory
      p.join(
        Platform.environment['HOME'] ?? '',
        'development',
        'pikpo-ui-shadcn',
        'packages',
        'grafit_ui',
      ),
    ];

    for (final path in searchPaths) {
      if (_isGrafitUiPackage(path)) {
        return path;
      }
    }

    throw Exception(
      'Could not find Grafit UI package. '
      'Please run this command from within a Grafit UI project or specify the path.',
    );
  }

  /// Check if a directory is a Grafit UI package
  static bool _isGrafitUiPackage(String path) {
    final pubspec = File(p.join(path, 'pubspec.yaml'));
    if (!pubspec.existsSync()) {
      return false;
    }

    try {
      final content = pubspec.readAsStringSync();
      final yaml = loadYaml(content) as YamlMap?;
      final name = yaml?['name']?.toString().toLowerCase();
      return name == 'grafit_ui';
    } catch (e) {
      return false;
    }
  }

  /// Get all component YAML files from registry
  static List<File> getComponentFiles(String grafitUiPath) {
    final registryPath = p.join(grafitUiPath, 'lib', 'registry');
    final registryDir = Directory(registryPath);

    if (!registryDir.existsSync()) {
      return [];
    }

    return registryDir
        .listSync(recursive: true)
        .whereType<File>()
        .where((file) => file.path.endsWith('.yaml'))
        .toList();
  }

  /// Parse a component YAML file
  static GrafitComponent? parseComponentFile(File file) {
    try {
      final content = file.readAsStringSync();
      final yaml = loadYaml(content) as YamlMap?;

      if (yaml == null) return null;

      return GrafitComponent.fromYamlNode(yaml);
    } catch (e) {
      return null;
    }
  }

  /// Get component file by name
  static File? getComponentFile(String grafitUiPath, String componentName) {
    final registryPath = p.join(grafitUiPath, 'lib', 'registry');
    final componentFile = File(p.join(
      registryPath,
      '$componentName.component.yaml',
    ));

    if (componentFile.existsSync()) {
      return componentFile;
    }

    // Try with underscore
    final underscoreFile = File(p.join(
      registryPath,
      '${componentName.replaceAll('-', '_')}.component.yaml',
    ));

    if (underscoreFile.existsSync()) {
      return underscoreFile;
    }

    return null;
  }

  /// Get all available component names from registry
  static List<String> getAvailableComponents(String grafitUiPath) {
    final registry = load(grafitUiPath);
    return registry.components.map((c) => c.name).toList()..sort();
  }

  /// Validate component dependencies
  static List<String> validateDependencies(
    ComponentRegistry registry,
    String componentName,
  ) {
    final component = registry.getComponent(componentName);
    if (component == null) {
      return ['Component not found: $componentName'];
    }

    final issues = <String>[];

    for (final dep in component.dependencies) {
      if (!registry.hasComponent(dep)) {
        issues.add('Missing dependency: $dep');
      }
    }

    return issues;
  }

  /// Get component installation order (topological sort)
  static List<String> getInstallationOrder(
    ComponentRegistry registry,
    List<String> components,
  ) {
    final ordered = <String>[];
    final visited = <String>{};
    final visiting = <String>{};

    void visit(String name) {
      if (visited.contains(name)) return;
      if (visiting.contains(name)) {
        throw Exception('Circular dependency detected involving: $name');
      }

      visiting.add(name);

      final component = registry.getComponent(name);
      if (component != null) {
        for (final dep in component.dependencies) {
          if (components.contains(dep)) {
            visit(dep);
          }
        }
      }

      visiting.remove(name);
      visited.add(name);
      ordered.add(name);
    }

    for (final name in components) {
      visit(name);
    }

    return ordered;
  }

  /// Clear the cached registry
  static void clearCache() {
    _cachedRegistry = null;
  }

  /// Get the Grafit UI package source path for a component
  static String getComponentSourcePath(String grafitUiPath, String relativePath) {
    return p.join(grafitUiPath, relativePath);
  }
}
