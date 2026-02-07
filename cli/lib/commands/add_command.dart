import 'dart:io';
import 'package:args/args.dart';
import 'package:args/command_runner.dart';
import 'package:path/path.dart' as p;
import '../config/config_manager.dart';
import '../utils/file_utils.dart';
import '../utils/output.dart';
import '../registry/registry_loader.dart';
import '../models/component.dart';
import '../models/registry.dart';

class AddCommand extends Command<void> {
  @override
  String get name => 'add';

  @override
  String get description => 'Add a component to your project';

  @override
  ArgParser get argParser {
    return ArgParser()
      ..addFlag('all',
          abbr: 'a',
          negatable: false,
          help: 'Add all available components')
      ..addFlag('overwrite',
          abbr: 'o',
          negatable: false,
          help: 'Overwrite existing files')
      ..addOption('path',
          help: 'Custom output path for components')
      ..addFlag('yes',
          abbr: 'y',
          negatable: false,
          help: 'Skip confirmation prompts');
  }

  @override
  Future<void> run() async {
    final args = argResults!;
    final projectPath = p.absolute('.');
    final addAll = args['all'] as bool;
    final overwrite = args['overwrite'] as bool;
    final customPath = args['path'] as String?;
    final skipConfirm = args['yes'] as bool;

    // Check if initialized
    final config = GrafitConfig.load(projectPath);
    if (config.installedComponents.isEmpty && customPath == null) {
      printWarning('Grafit not initialized in this project.');
      printInfo('Run: gft init');
      return;
    }

    final componentsPath = customPath ?? config.componentsAbsolutePath;

    // Load registry
    final registry = RegistryLoader.loadFromCurrent();
    final grafitUiPath = _findGrafitUiPath();

    if (addAll) {
      return _addAllComponents(registry, grafitUiPath, componentsPath, overwrite, skipConfirm, config);
    }

    // Get component name from arguments
    if (argResults!.rest.isEmpty) {
      printError('No component specified');
      printInfo('Usage: gft add <component>');
      printInfo('Run: gft list to see available components');
      return;
    }

    final componentName = argResults!.rest.first.toLowerCase();

    // Validate component exists
    final component = registry.getComponent(componentName);
    if (component == null) {
      printError('Component "$componentName" not found');
      printInfo('Run: gft list to see available components');
      return;
    }

    await _addComponent(component, grafitUiPath, componentsPath, overwrite, skipConfirm, config);
  }

  String _findGrafitUiPath() {
    // Search for grafit_ui package
    final searchPaths = [
      p.join(Directory.current.path, '..', 'packages', 'grafit_ui'),
      p.join(Directory.current.path, '..', 'grafit_ui'),
    ];

    for (final path in searchPaths) {
      if (Directory(path).existsSync()) {
        return path;
      }
    }

    // Fallback to current directory's packages
    return p.join(Directory.current.path, '..', 'packages', 'grafit_ui');
  }

  Future<void> _addComponent(
    GrafitComponent component,
    String grafitUiPath,
    String componentsPath,
    bool overwrite,
    bool skipConfirm,
    GrafitConfig config,
  ) async {
    printHeader('Adding component: ${component.name}');
    printPair('Category', component.category);
    printPair('Parity', '${component.parity}%');
    printPair('Status', component.status);
    printSeparator();

    // Get source file path
    final sourcePath = p.join(grafitUiPath, component.sourcePath);
    final sourceFile = File(sourcePath);

    if (!sourceFile.existsSync()) {
      printError('Source file not found: $sourcePath');
      return;
    }

    // Determine destination path
    final destPath = p.join(componentsPath, component.name);
    final destFile = File(p.join(destPath, '${component.name}.dart'));

    // Check if file exists
    if (destFile.existsSync() && !overwrite) {
      printWarning('Component already exists at: $destPath');
      stdout.write('Overwrite? [y/N]: ');
      final response = stdin.readLineSync()?.toLowerCase();
      if (response != 'y' && response != 'yes') {
        printDebug('Skipped.');
        return;
      }
    }

    // Confirm if not skipping
    if (!skipConfirm) {
      stdout.write('Add ${component.name}? [Y/n]: ');
      final response = stdin.readLineSync()?.toLowerCase();
      if (response == 'n' || response == 'no') {
        printDebug('Aborted.');
        return;
      }
    }

    try {
      // Create component directory
      await FileUtils.ensureDirectory(destPath);

      // Copy component file
      await FileUtils.copyFile(sourcePath, destFile.path);
      printSuccess('Copied ${component.name}.dart');

      // Update exports file
      await _updateExports(componentsPath, component.name);
      printSuccess('Updated exports');

      // Update config
      config.addComponent(component.name);
      await config.save();
      printDebug('Updated gft.yaml');

      printSeparator();
      printSuccess('Component ${component.name} added successfully!');
      printInfo("Import: import 'package:your_app/ui/${component.name}/${component.name}.dart';");

    } catch (e) {
      printError('Failed to add component: $e');
    }
  }

  Future<void> _addAllComponents(
    ComponentRegistry registry,
    String grafitUiPath,
    String componentsPath,
    bool overwrite,
    bool skipConfirm,
    GrafitConfig config,
  ) async {
    final components = registry.stableComponents;

    printHeader('Adding all components');
    printInfo('Found ${components.length} stable components');
    printSeparator();

    if (!skipConfirm) {
      stdout.write('Add all ${components.length} components? [y/N]: ');
      final response = stdin.readLineSync()?.toLowerCase();
      if (response != 'y' && response != 'yes') {
        printDebug('Aborted.');
        return;
      }
    }

    int successCount = 0;
    int failCount = 0;

    for (var i = 1; i <= components.length; i++) {
      final component = components[i - 1];
      printStep(i, components.length, 'Adding ${component.name}...');

      try {
        await _addComponent(component, grafitUiPath, componentsPath, overwrite, true, config);
        successCount++;
      } catch (e) {
        failCount++;
        printError('Failed: ${component.name} - $e');
      }
    }

    printSeparator();
    printHeader('Summary');
    printSuccess('Added: $successCount components');
    if (failCount > 0) {
      printError('Failed: $failCount components');
    }
  }

  Future<void> _updateExports(String componentsPath, String componentName) async {
    final exportFile = File(p.join(componentsPath, 'grafit_ui.dart'));

    String content;
    if (exportFile.existsSync()) {
      content = await exportFile.readAsString();
    } else {
      content = '''
/// Grafit UI Components Export
/// Auto-generated by Grafit CLI
///

library grafit_ui;

// Export all components
''';
    }

    // Add export if not already present
    final exportLine = "export '$componentName/$componentName.dart';";
    if (!content.contains(exportLine)) {
      // Find the "// Export all components" line and add after it
      final lines = content.split('\n');
      final insertIndex = lines.indexWhere((line) =>
          line.contains('// Export all components'));

      if (insertIndex != -1) {
        // Find the end of the comment block
        int endOfComments = insertIndex + 1;
        while (endOfComments < lines.length && lines[endOfComments].trim().startsWith('//')) {
          endOfComments++;
        }

        lines.insert(endOfComments, exportLine);
        content = lines.join('\n');
      } else {
        content += '\n$exportLine';
      }

      await exportFile.writeAsString(content);
    }
  }
}
