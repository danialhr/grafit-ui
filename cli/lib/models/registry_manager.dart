import 'dart:io';
import 'package:yaml/yaml.dart';
import 'package:path/path.dart' as p;
import 'component_info.dart';

/// Manages loading and accessing the component registry
class RegistryManager {
  static ComponentRegistry? _cachedRegistry;

  /// Get the path to the COMPONENT_REGISTRY.yaml file
  static String getRegistryPath() {
    // The CLI is in /cli, registry is at root /COMPONENT_REGISTRY.yaml
    final cliDir = Directory.current;
    final projectRoot = p.dirname(cliDir.path);
    return p.join(projectRoot, 'COMPONENT_REGISTRY.yaml');
  }

  /// Load the component registry from YAML
  static ComponentRegistry loadRegistry() {
    if (_cachedRegistry != null) {
      return _cachedRegistry!;
    }

    final registryPath = getRegistryPath();
    final registryFile = File(registryPath);

    if (!registryFile.existsSync()) {
      throw Exception('Registry file not found at: $registryPath');
    }

    final yamlContent = registryFile.readAsStringSync();
    final yaml = loadYaml(yamlContent) as YamlMap;

    // Parse upstream info
    final upstream = (yaml['upstream'] as YamlMap?)?.toMap() ?? {};

    // Parse categories
    final categories = <String, String>{};
    final categoriesYaml = yaml['categories'] as YamlMap?;
    if (categoriesYaml != null) {
      for (final entry in categoriesYaml.entries) {
        final key = entry.key.toString();
        final value = entry.value?.toString() ?? key;
        categories[key] = value;
      }
    }

    // Parse flutter components
    final components = <String, ComponentInfo>{};
    final flutterComponents = yaml['flutter_components'] as YamlMap?;
    if (flutterComponents != null) {
      for (final entry in flutterComponents.entries) {
        final name = entry.key.toString();
        final data = (entry.value as YamlMap).toMap();
        components[name] = ComponentInfo.fromYaml(name, data, categories);
      }
    }

    _cachedRegistry = ComponentRegistry(
      upstream: upstream,
      components: components,
      categories: categories,
    );

    return _cachedRegistry!;
  }

  /// Get the grafit_ui package path
  static String getGrafitPackagePath() {
    final cliDir = Directory.current;
    final projectRoot = p.dirname(cliDir.path);
    return p.join(projectRoot, 'packages', 'grafit_ui');
  }

  /// Get the full path to a component file
  static String getComponentPath(String flutterRelativePath) {
    final packagePath = getGrafitPackagePath();
    return p.join(packagePath, flutterRelativePath);
  }

  /// Clear the cached registry (useful for testing)
  static void clearCache() {
    _cachedRegistry = null;
  }
}