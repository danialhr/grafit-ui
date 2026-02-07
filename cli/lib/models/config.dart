import 'dart:io';
import 'package:yaml/yaml.dart';
import 'package:path/path.dart' as p;
import '../utils/file_utils.dart';

/// Grafit UI project configuration
class GrafitConfig {
  /// Path to the Flutter project
  final String projectPath;

  /// List of installed component names
  final List<String> installedComponents;

  /// Grafit UI version
  final String grafitUiVersion;

  /// Components output path
  final String componentsPath;

  /// Style variant (default, new-york, etc.)
  final String style;

  /// Base color scheme
  final String baseColor;

  /// Whether to use theme variables
  final bool useThemeVariables;

  GrafitConfig({
    required this.projectPath,
    required this.installedComponents,
    required this.grafitUiVersion,
    this.componentsPath = 'lib/ui/grafit_ui',
    this.style = 'default',
    this.baseColor = 'zinc',
    this.useThemeVariables = true,
  });

  /// Load configuration from project directory
  factory GrafitConfig.load(String projectPath) {
    final configPath = _getConfigPath(projectPath);
    final configFile = File(configPath);

    if (!configFile.existsSync()) {
      // Return default config if not exists
      return GrafitConfig(
        projectPath: projectPath,
        installedComponents: [],
        grafitUiVersion: '0.0.0',
      );
    }

    final content = configFile.readAsStringSync();
    final yaml = loadYaml(content) as YamlMap?;

    if (yaml == null) {
      return GrafitConfig(
        projectPath: projectPath,
        installedComponents: [],
        grafitUiVersion: '0.0.0',
      );
    }

    final map = _yamlToMap(yaml);

    return GrafitConfig(
      projectPath: projectPath,
      installedComponents: (map['components'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      grafitUiVersion: map['version'] as String? ?? '0.0.0',
      componentsPath: map['componentsPath'] as String? ?? 'lib/ui/grafit_ui',
      style: map['style'] as String? ?? 'default',
      baseColor: map['baseColor'] as String? ?? 'zinc',
      useThemeVariables: map['useThemeVariables'] as bool? ?? true,
    );
  }

  /// Convert YAML map to regular Map
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

  /// Get config file path
  static String _getConfigPath(String projectPath) {
    return p.join(projectPath, 'gft.yaml');
  }

  /// Save configuration to file
  Future<void> save() async {
    final configPath = _getConfigPath(projectPath);
    final configFile = File(configPath);

    final buffer = StringBuffer();
    buffer.writeln('# Grafit UI Configuration');
    buffer.writeln('version: $grafitUiVersion');
    buffer.writeln('project: ${p.basename(projectPath)}');
    buffer.writeln('style: $style');
    buffer.writeln('baseColor: $baseColor');
    buffer.writeln('useThemeVariables: $useThemeVariables');
    buffer.writeln('componentsPath: $componentsPath');
    buffer.writeln('components:');

    if (installedComponents.isEmpty) {
      buffer.writeln('  # No components installed yet');
      buffer.writeln('  # - button');
      buffer.writeln('  # - input');
    } else {
      for (final component in installedComponents) {
        buffer.writeln('  - $component');
      }
    }

    await configFile.writeAsString(buffer.toString());
  }

  /// Add a component to installed list
  void addComponent(String componentName) {
    if (!installedComponents.contains(componentName)) {
      installedComponents.add(componentName);
    }
  }

  /// Remove a component from installed list
  void removeComponent(String componentName) {
    installedComponents.remove(componentName);
  }

  /// Check if component is installed
  bool hasComponent(String componentName) {
    return installedComponents.contains(componentName);
  }

  /// Get absolute path to components directory
  String get componentsAbsolutePath {
    return p.join(projectPath, componentsPath);
  }

  /// Convert to map
  Map<String, dynamic> toMap() {
    return {
      'version': grafitUiVersion,
      'project': p.basename(projectPath),
      'style': style,
      'baseColor': baseColor,
      'useThemeVariables': useThemeVariables,
      'componentsPath': componentsPath,
      'components': installedComponents,
    };
  }

  @override
  String toString() {
    return 'GrafitConfig(version: $grafitUiVersion, components: ${installedComponents.length})';
  }
}
