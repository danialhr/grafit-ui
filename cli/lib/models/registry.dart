import 'dart:io';
import 'package:yaml/yaml.dart';
import 'package:path/path.dart' as p;
import 'component.dart';

/// Registry of all available Grafit UI components
class ComponentRegistry {
  /// Raw registry data from YAML
  final Map<String, dynamic> data;

  /// Parsed components list
  final List<GrafitComponent> components;

  /// Registry version
  String get version => data['version'] as String? ?? '1.0.0';

  /// Registry name
  String get name => data['name'] as String? ?? 'grafit-ui';

  ComponentRegistry({
    required this.data,
    required this.components,
  });

  /// Load registry from Grafit UI package
  factory ComponentRegistry.load(String grafitUiPath) {
    final registryPath = p.join(grafitUiPath, 'lib', 'registry.yaml');

    final registryFile = File(registryPath);
    if (!registryFile.existsSync()) {
      // Return empty registry if file doesn't exist
      return ComponentRegistry(
        data: {'version': '1.0.0', 'name': 'grafit-ui', 'components': []},
        components: [],
      );
    }

    final content = registryFile.readAsStringSync();
    final yaml = loadYaml(content) as YamlMap?;

    if (yaml == null) {
      return ComponentRegistry(
        data: {'version': '1.0.0', 'name': 'grafit-ui', 'components': []},
        components: [],
      );
    }

    final data = _yamlToMap(yaml);
    final componentsList = data['components'] as List<dynamic>? ?? [];

    final components = componentsList
        .whereType<YamlMap>()
        .map((yaml) => GrafitComponent.fromYamlNode(yaml))
        .toList();

    return ComponentRegistry(
      data: data,
      components: components,
    );
  }

  /// Convert YAML to regular Map
  static Map<String, dynamic> _yamlToMap(YamlMap yaml) {
    final map = <String, dynamic>{};
    for (final entry in yaml.entries) {
      final value = entry.value;
      if (value is YamlMap) {
        map[entry.key.toString()] = _yamlToMap(value);
      } else if (value is YamlList) {
        map[entry.key.toString()] =
            value.map((e) => e is YamlMap ? _yamlToMap(e) : e).toList();
      } else {
        map[entry.key.toString()] = value;
      }
    }
    return map;
  }

  /// Get all unique categories
  List<String> get categories {
    final cats = components.map((c) => c.category).toSet().toList();
    cats.sort();
    return cats;
  }

  /// Get components by category
  List<GrafitComponent> getComponentsByCategory(String category) {
    return components.where((c) => c.category == category).toList();
  }

  /// Get component by name
  GrafitComponent? getComponent(String name) {
    try {
      return components.firstWhere((c) => c.name == name);
    } catch (e) {
      return null;
    }
  }

  /// Search components by name or description
  List<GrafitComponent> searchComponents(String query) {
    final lowerQuery = query.toLowerCase();
    return components.where((c) {
      return c.name.toLowerCase().contains(lowerQuery) ||
          c.description.toLowerCase().contains(lowerQuery);
    }).toList();
  }

  /// Get only stable components
  List<GrafitComponent> get stableComponents {
    return components.where((c) => c.isStable).toList();
  }

  /// Get only beta components
  List<GrafitComponent> get betaComponents {
    return components.where((c) => c.isBeta).toList();
  }

  /// Get components with full parity
  List<GrafitComponent> get fullParityComponents {
    return components.where((c) => c.hasFullParity).toList();
  }

  /// Get components by parity range
  List<GrafitComponent> getComponentsByParityRange(int min, int max) {
    return components
        .where((c) => c.parity >= min && c.parity <= max)
        .toList();
  }

  /// Check if component exists
  bool hasComponent(String name) {
    return getComponent(name) != null;
  }

  /// Get component count
  int get componentCount => components.length;

  /// Get component count by category
  Map<String, int> getComponentCountByCategory() {
    final counts = <String, int>{};
    for (final component in components) {
      counts[component.category] = (counts[component.category] ?? 0) + 1;
    }
    return counts;
  }

  @override
  String toString() {
    return 'ComponentRegistry(version: $version, components: $componentCount, categories: ${categories.length})';
  }
}
