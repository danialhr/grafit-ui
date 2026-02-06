import 'dart:io';
import 'package:yaml/yaml.dart';
import 'package:path/path.dart' as p;

/// Configuration for Grafit in a Flutter project
class GrafitConfig {
  final String style;
  final String componentsPath;
  final String themeExtension;
  final String baseColor;
  final bool useThemeVariables;
  final bool rtl;

  const GrafitConfig({
    this.style = 'default',
    this.componentsPath = 'lib/components/ui',
    this.themeExtension = 'GrafitTheme',
    this.baseColor = 'zinc',
    this.useThemeVariables = true,
    this.rtl = false,
  });

  factory GrafitConfig.fromMap(Map<String, dynamic> map) {
    return GrafitConfig(
      style: map['style'] as String? ?? 'default',
      componentsPath: map['componentsPath'] as String? ?? 'lib/components/ui',
      themeExtension: map['themeExtension'] as String? ?? 'GrafitTheme',
      baseColor: map['baseColor'] as String? ?? 'zinc',
      useThemeVariables: map['useThemeVariables'] as bool? ?? true,
      rtl: map['rtl'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'style': style,
      'componentsPath': componentsPath,
      'themeExtension': themeExtension,
      'baseColor': baseColor,
      'useThemeVariables': useThemeVariables,
      'rtl': rtl,
    };
  }
}

/// Manages the components.json configuration file
class ConfigManager {
  /// Get the config file path for a project directory
  static String getConfigPath(String projectPath) {
    return p.join(projectPath, 'components.json');
  }

  /// Check if a project has Grafit initialized
  static bool isInitialized(String projectPath) {
    return File(getConfigPath(projectPath)).existsSync();
  }

  /// Load the configuration from a project
  static GrafitConfig? loadConfig(String projectPath) {
    final configFile = File(getConfigPath(projectPath));
    if (!configFile.existsSync()) {
      return null;
    }

    final content = configFile.readAsStringSync();
    final yaml = loadYaml(content) as YamlMap;

    return GrafitConfig.fromMap(
      yaml.nodes.map((key, value) => MapEntry(key.toString(), value)),
    );
  }

  /// Save the configuration to a project
  static Future<void> saveConfig(
    String projectPath,
    GrafitConfig config,
  ) async {
    final configFile = File(getConfigPath(projectPath));
    final yamlMap = config.toMap();

    // Convert to YAML string
    final yamlString = yamlMap.entries
        .map((e) =>
            '${e.key}: ${e.value is String ? '"${e.value}"' : e.value}')
        .join('\n');

    await configFile.writeAsString(yamlString);
  }

  /// Get the components directory path
  static String getComponentsPath(String projectPath) {
    final config = loadConfig(projectPath);
    if (config == null) {
      return p.join(projectPath, 'lib', 'components', 'ui');
    }
    return p.join(projectPath, config.componentsPath);
  }

  /// Check if this is a valid Flutter project
  static bool isFlutterProject(String projectPath) {
    return File(p.join(projectPath, 'pubspec.yaml')).existsSync();
  }
}
