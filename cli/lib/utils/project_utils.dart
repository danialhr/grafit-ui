import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:yaml/yaml.dart';
import 'file_utils.dart';

/// Result of Flutter project detection
class FlutterProjectInfo {
  final String path;
  final String name;
  final bool isValid;
  final bool hasGrafit;
  final String? grafitConfigPath;

  FlutterProjectInfo({
    required this.path,
    required this.name,
    required this.isValid,
    required this.hasGrafit,
    this.grafitConfigPath,
  });
}

/// Utilities for detecting and working with Flutter projects
class ProjectUtils {
  /// Detect Flutter project root from current or given directory
  ///
  /// Traverses up the directory tree until finding pubspec.yaml
  static String detectFlutterProject([String? startPath]) {
    String currentPath = startPath ?? Directory.current.path;

    // Check if current path is valid
    while (currentPath.isNotEmpty && currentPath != '/') {
      final pubspecPath = p.join(currentPath, 'pubspec.yaml');
      if (File(pubspecPath).existsSync()) {
        return currentPath;
      }

      // Move up one directory
      final parent = p.dirname(currentPath);
      if (parent == currentPath) break;
      currentPath = parent;
    }

    throw Exception('No Flutter project found (pubspec.yaml not found)');
  }

  /// Validate that a directory is a valid Flutter project
  static bool isValidFlutterProject(String path) {
    // Check for pubspec.yaml
    final pubspecPath = p.join(path, 'pubspec.yaml');
    if (!File(pubspecPath).existsSync()) {
      return false;
    }

    // Check if it's a Flutter project by reading pubspec.yaml
    try {
      final content = File(pubspecPath).readAsStringSync();
      final yaml = loadYaml(content) as YamlMap?;

      if (yaml == null) return false;

      // Check for Flutter dependency
      final dependencies = yaml['dependencies'] as YamlMap?;
      if (dependencies != null && dependencies.containsKey('flutter')) {
        return true;
      }

      // Check for flutter_sdk environment
      final environment = yaml['environment'] as YamlMap?;
      if (environment != null && environment.containsKey('flutter')) {
        return true;
      }
    } catch (e) {
      return false;
    }

    return false;
  }

  /// Get comprehensive Flutter project information
  static FlutterProjectInfo getProjectInfo([String? path]) {
    try {
      final projectPath = path ?? detectFlutterProject();
      final pubspecPath = p.join(projectPath, 'pubspec.yaml');
      final content = File(pubspecPath).readAsStringSync();
      final yaml = loadYaml(content) as YamlMap?;

      final name = yaml?['name']?.toString() ?? p.basename(projectPath);
      final isValid = isValidFlutterProject(projectPath);
      final hasGrafit = hasGrafitConfig(projectPath);
      final grafitConfigPath = hasGrafit ? getGrafitConfigPath(projectPath) : null;

      return FlutterProjectInfo(
        path: projectPath,
        name: name,
        isValid: isValid,
        hasGrafit: hasGrafit,
        grafitConfigPath: grafitConfigPath,
      );
    } catch (e) {
      return FlutterProjectInfo(
        path: path ?? Directory.current.path,
        name: p.basename(path ?? Directory.current.path),
        isValid: false,
        hasGrafit: false,
      );
    }
  }

  /// Check if project has Grafit UI configuration
  static bool hasGrafitConfig(String projectPath) {
    return _getGftConfigPath(projectPath) != null;
  }

  /// Get Grafit config file path (gft.yaml)
  static String? getGrafitConfigPath(String projectPath) {
    return _getGftConfigPath(projectPath);
  }

  /// Internal: Get gft.yaml path or null
  static String? _getGftConfigPath(String projectPath) {
    final gftPath = p.join(projectPath, 'gft.yaml');
    if (File(gftPath).existsSync()) {
      return gftPath;
    }

    // Check for components.json (alternative config)
    final componentsPath = p.join(projectPath, 'components.json');
    if (File(componentsPath).existsSync()) {
      return componentsPath;
    }

    return null;
  }

  /// Get lib directory path
  static String getLibPath(String projectPath) {
    return p.join(projectPath, 'lib');
  }

  /// Get components directory path
  static String getComponentsPath(String projectPath, {String defaultPath = 'lib/ui/grafit_ui'}) {
    // Try to read from gft.yaml
    final gftPath = _getGftConfigPath(projectPath);
    if (gftPath != null) {
      try {
        final content = File(gftPath).readAsStringSync();
        final yaml = loadYaml(content) as YamlMap?;
        if (yaml != null && yaml['componentsPath'] != null) {
          final componentsPath = yaml['componentsPath'].toString();
          // If relative, join with project path
          if (p.isRelative(componentsPath)) {
            return p.join(projectPath, componentsPath);
          }
          return componentsPath;
        }
      } catch (e) {
        // Fall through to default
      }
    }

    return p.join(projectPath, defaultPath);
  }

  /// Create components directory structure
  static Future<void> createComponentsStructure(String projectPath) async {
    final componentsPath = getComponentsPath(projectPath);
    await FileUtils.ensureDirectory(componentsPath);

    // Create subdirectories
    final subdirs = [
      'components',
      'hooks',
      'themes',
      'utils',
    ];

    for (final subdir in subdirs) {
      await FileUtils.ensureDirectory(p.join(componentsPath, subdir));
    }
  }

  /// Get project name from pubspec.yaml
  static String getProjectName(String projectPath) {
    final pubspecPath = p.join(projectPath, 'pubspec.yaml');
    try {
      final content = File(pubspecPath).readAsStringSync();
      final yaml = loadYaml(content) as YamlMap?;
      return yaml?['name']?.toString() ?? p.basename(projectPath);
    } catch (e) {
      return p.basename(projectPath);
    }
  }

  /// Check if Grafit UI is in dependencies
  static bool hasGrafitUiDependency(String projectPath) {
    final pubspecPath = p.join(projectPath, 'pubspec.yaml');
    try {
      final content = File(pubspecPath).readAsStringSync();
      final yaml = loadYaml(content) as YamlMap?;
      final dependencies = yaml?['dependencies'] as YamlMap?;

      if (dependencies != null) {
        // Check for grafit_ui or local path
        for (final key in dependencies.keys) {
          final name = key.toString().toLowerCase();
          if (name == 'grafit_ui') {
            return true;
          }
        }
      }
    } catch (e) {
      return false;
    }

    return false;
  }

  /// Find all Dart files in lib directory
  static List<String> findDartFiles(String projectPath, {String relativeTo = 'lib'}) {
    final libPath = p.join(projectPath, relativeTo);
    final libDir = Directory(libPath);

    if (!libDir.existsSync()) {
      return [];
    }

    return libDir
        .listSync(recursive: true)
        .whereType<File>()
        .where((file) => file.path.endsWith('.dart'))
        .map((file) => p.relative(file.path, from: projectPath))
        .toList();
  }

  /// Get pubspec.yaml content as Map
  static Map<String, dynamic>? getPubspecContent(String projectPath) {
    final pubspecPath = p.join(projectPath, 'pubspec.yaml');
    try {
      final content = File(pubspecPath).readAsStringSync();
      final yaml = loadYaml(content) as YamlMap?;

      if (yaml == null) return null;

      return _yamlToMap(yaml);
    } catch (e) {
      return null;
    }
  }

  /// Convert YamlMap to regular Map
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

  /// Get Grafit UI version from pubspec
  static String? getGrafitUiVersion(String projectPath) {
    final pubspec = getPubspecContent(projectPath);
    final dependencies = pubspec?['dependencies'] as Map<String, dynamic>?;

    if (dependencies != null) {
      for (final key in dependencies.keys) {
        if (key.toString().toLowerCase() == 'grafit_ui') {
          return dependencies[key]?.toString();
        }
      }
    }

    return null;
  }

  /// Check if running from within Grafit UI package itself
  static bool isGrafitUiPackage(String path) {
    final pubspecPath = p.join(path, 'pubspec.yaml');
    try {
      final content = File(pubspecPath).readAsStringSync();
      final yaml = loadYaml(content) as YamlMap?;
      final name = yaml?['name']?.toString();
      return name == 'grafit_ui';
    } catch (e) {
      return false;
    }
  }

  /// Get the Grafit UI package path (when developing CLI)
  static String? getGrafitUiPackagePath() {
    String current = Directory.current.path;

    // Search up for grafit_ui package
    while (current.isNotEmpty && current != '/') {
      if (isGrafitUiPackage(current)) {
        return current;
      }

      // Check siblings
      final parent = p.dirname(current);
      final grafitPath = p.join(parent, 'grafit_ui');
      if (Directory(grafitPath).existsSync() && isGrafitUiPackage(grafitPath)) {
        return grafitPath;
      }

      final currentParent = p.dirname(current);
      if (currentParent == current) break;
      current = currentParent;
    }

    return null;
  }
}
