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
  final List<String> installedComponents;

  const GrafitConfig({
    this.style = 'default',
    this.componentsPath = 'lib/components/ui',
    this.themeExtension = 'GrafitTheme',
    this.baseColor = 'zinc',
    this.useThemeVariables = true,
    this.rtl = false,
    this.installedComponents = const [],
  });

  factory GrafitConfig.fromMap(Map<String, dynamic> map) {
    return GrafitConfig(
      style: map['style'] as String? ?? 'default',
      componentsPath: map['componentsPath'] as String? ?? 'lib/components/ui',
      themeExtension: map['themeExtension'] as String? ?? 'GrafitTheme',
      baseColor: map['baseColor'] as String? ?? 'zinc',
      useThemeVariables: map['useThemeVariables'] as bool? ?? true,
      rtl: map['rtl'] as bool? ?? false,
      installedComponents: (map['installedComponents'] as List?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
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
      'installedComponents': installedComponents,
    };
  }

  /// Get absolute path for components directory
  String get componentsAbsolutePath {
    final projectPath = _findProjectRoot();
    if (projectPath != null) {
      return p.join(projectPath, componentsPath);
    }
    return p.absolute(componentsPath);
  }

  /// Find project root by looking for pubspec.yaml
  String? _findProjectRoot() {
    String current = Directory.current.path;
    for (int i = 0; i < 10; i++) {
      if (File(p.join(current, 'pubspec.yaml')).existsSync()) {
        return current;
      }
      final parent = p.dirname(current);
      if (parent == current) break;
      current = parent;
    }
    return null;
  }

  /// Check if component is installed
  bool hasComponent(String componentName) {
    return installedComponents.contains(componentName);
  }

  /// Add component to installed list
  GrafitConfig addComponent(String componentName) {
    final newComponents = [...installedComponents];
    if (!newComponents.contains(componentName)) {
      newComponents.add(componentName);
    }
    return GrafitConfig(
      style: style,
      componentsPath: componentsPath,
      themeExtension: themeExtension,
      baseColor: baseColor,
      useThemeVariables: useThemeVariables,
      rtl: rtl,
      installedComponents: newComponents,
    );
  }

  /// Remove component from installed list
  GrafitConfig removeComponent(String componentName) {
    return GrafitConfig(
      style: style,
      componentsPath: componentsPath,
      themeExtension: themeExtension,
      baseColor: baseColor,
      useThemeVariables: useThemeVariables,
      rtl: rtl,
      installedComponents: installedComponents.where((c) => c != componentName).toList(),
    );
  }

  /// Load config from project
  static GrafitConfig load(String projectPath) {
    final configFile = File(p.join(projectPath, 'components.json'));
    if (!configFile.existsSync()) {
      return const GrafitConfig();
    }

    try {
      final content = configFile.readAsStringSync();
      final yaml = loadYaml(content);
      if (yaml is YamlMap) {
        final map = <String, dynamic>{};
        for (final entry in yaml.entries) {
          map[entry.key.toString()] = entry.value;
        }
        return GrafitConfig.fromMap(map);
      }
    } catch (e) {
      // Return default config on error
    }
    return const GrafitConfig();
  }

  /// Save config to project
  Future<void> save() async {
    final projectPath = _findProjectRoot();
    if (projectPath == null) {
      throw Exception('Could not find project root (pubspec.yaml)');
    }

    final configFile = File(p.join(projectPath, 'components.json'));

    // Simple JSON writer
    final buffer = StringBuffer();
    buffer.writeln('{');
    buffer.writeln('  "style": "$style",');
    buffer.writeln('  "componentsPath": "$componentsPath",');
    buffer.writeln('  "themeExtension": "$themeExtension",');
    buffer.writeln('  "baseColor": "$baseColor",');
    buffer.writeln('  "useThemeVariables": ${useThemeVariables ? 'true' : 'false'},');
    buffer.writeln('  "rtl": ${rtl ? 'true' : 'false'},');
    buffer.write('  "installedComponents": [');
    for (var i = 0; i < installedComponents.length; i++) {
      if (i > 0) buffer.write(', ');
      buffer.write('"${installedComponents[i]}"');
    }
    buffer.writeln(']');
    buffer.writeln('}');

    await configFile.writeAsString(buffer.toString());
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
