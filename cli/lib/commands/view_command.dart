import 'dart:io';
import 'package:args/command_runner.dart';
import 'package:path/path.dart' as p;
import 'package:yaml/yaml.dart';

class ViewCommand extends Command<void> {
  @override
  String get name => 'view';

  @override
  String get description => 'View component source before installing';

  @override
  Future<void> run() async {
    if (argResults!.rest.isEmpty) {
      print('Error: No component specified');
      print('Usage: grafit view <component>');
      return;
    }

    final componentName = argResults!.rest.first.toLowerCase();

    // Get registry path from CLI package
    final cliPath = p.dirname(p.dirname(p.fromUri(Platform.script)));
    final registryPath = p.join(
      p.dirname(cliPath),
      'packages',
      'registry',
      'components',
      componentName,
    );

    // Check if component exists
    if (!Directory(registryPath).existsSync()) {
      print('Error: Component "$componentName" not found');
      print('Run: grafit list to see available components');
      return;
    }

    // Load component metadata
    final yamlPath = p.join(registryPath, '$componentName.yaml');
    if (!File(yamlPath).existsSync()) {
      print('Error: Component metadata not found');
      return;
    }

    final yamlContent = File(yamlPath).readAsStringSync();
    final yaml = loadYaml(yamlContent) as YamlMap;

    print('═══════════════════════════════════════════════════════════════');
    print('  Component: ${yaml['name']}');
    print('  Category: ${yaml['category']}');
    print('═══════════════════════════════════════════════════════════════');
    print('');
    print('Description:');
    print('  ${yaml['description']}');
    print('');
    print('Dependencies:');
    final deps = yaml['dependencies'] as List?;
    if (deps == null || deps.isEmpty) {
      print('  None');
    } else {
      for (final dep in deps) {
        print('  - $dep');
      }
    }
    print('');
    print('Files:');
    final files = yaml['files'] as List?;
    if (files != null) {
      for (final file in files) {
        print('  - $file');
      }
    }
    print('');

    // Display source code if available
    final templatePath = p.join(registryPath, yaml['template'] as String? ?? '$componentName.dart.template');
    if (File(templatePath).existsSync()) {
      print('Source Preview:');
      print('───────────────────────────────────────────────────────────────');
      final source = File(templatePath).readAsStringSync();
      final lines = source.split('\n');
      final previewLines = lines.take(30).toList();
      for (var i = 0; i < previewLines.length; i++) {
        print('${(i + 1).toString().padLeft(3).padRight(5)} ${previewLines[i]}');
      }
      if (lines.length > 30) {
        print('     ... (${lines.length - 30} more lines)');
      }
      print('───────────────────────────────────────────────────────────────');
    }

    print('');
    print('To install this component, run: grafit add $componentName');
  }
}
