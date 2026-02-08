import 'dart:io';
import 'package:args/args.dart';
import 'package:args/command_runner.dart';
import 'package:path/path.dart' as p;
import '../config/config_manager.dart';
import '../utils/file_utils.dart';
import '../utils/output.dart';
import '../registry/registry_loader.dart';
import '../models/registry.dart';

class RemoveCommand extends Command<void> {
  @override
  String get name => 'remove';

  @override
  String get description => 'Remove a component from your project';

  @override
  ArgParser get argParser {
    return ArgParser()
      ..addFlag('force',
          abbr: 'f',
          negatable: false,
          help: 'Force removal without confirmation')
      ..addFlag('yes',
          abbr: 'y',
          negatable: false,
          help: 'Skip confirmation prompts');
  }

  @override
  Future<void> run() async {
    final args = argResults!;
    final projectPath = p.absolute('.');
    final force = args['force'] as bool;
    final skipConfirm = args['yes'] as bool;

    // Check if initialized
    final config = GrafitConfig.load(projectPath);
    if (config.installedComponents.isEmpty) {
      printWarning('Grafit not initialized in this project.');
      printInfo('Run: gft init');
      return;
    }

    final componentsPath = config.componentsAbsolutePath;

    // Get component name from arguments
    if (argResults!.rest.isEmpty) {
      printError('No component specified');
      printInfo('Usage: gft remove <component>');
      printInfo('Run: gft list to see installed components');
      return;
    }

    final componentName = argResults!.rest.first.toLowerCase();

    // Check if component is installed
    if (!config.hasComponent(componentName)) {
      printError('Component "$componentName" is not installed');
      printInfo('Run: gft list to see installed components');
      return;
    }

    await _removeComponent(componentName, componentsPath, force, skipConfirm, config);
  }

  Future<void> _removeComponent(
    String componentName,
    String componentsPath,
    bool force,
    bool skipConfirm,
    GrafitConfig config,
  ) async {
    printHeader('Removing component: $componentName');
    printSeparator();

    // Determine component directory
    final componentDir = Directory(p.join(componentsPath, componentName));

    if (!componentDir.existsSync()) {
      printWarning('Component directory not found: ${componentDir.path}');
      printInfo('Removing from config only...');
    } else {
      // List files that will be removed
      final files = componentDir.listSync(recursive: true);
      printInfo('Files to be removed: ${files.length}');

      for (final file in files) {
        final relativePath = p.relative(file.path, from: componentsPath);
        printIndent('• $relativePath');
      }

      printSeparator();

      // Confirm removal
      if (!skipConfirm) {
        stdout.write('Remove $componentName? [y/N]: ');
        final response = stdin.readLineSync()?.toLowerCase();
        if (response != 'y' && response != 'yes') {
          printDebug('Aborted.');
          return;
        }
      }

      try {
        // Remove component directory
        if (force) {
          await componentDir.delete(recursive: true);
        } else {
          // Try to remove, handle errors gracefully
          await componentDir.delete(recursive: true);
        }
        printSuccess('Removed ${componentDir.path}');
      } catch (e) {
        if (!force) {
          printError('Failed to remove directory: $e');
          printInfo('Use --force to retry');
          return;
        }
        rethrow;
      }
    }

    // Update exports file
    await _removeFromExports(componentsPath, componentName);
    printSuccess('Updated exports');

    // Update config
    final newConfig = config.removeComponent(componentName);
    await newConfig.save();
    printDebug('Updated components.json');

    printSeparator();
    printSuccess('Component $componentName removed successfully!');
    printInfo('Installed components: ${newConfig.installedComponents.length}');
  }

  Future<void> _removeFromExports(String componentsPath, String componentName) async {
    final exportFile = File(p.join(componentsPath, 'grafit_ui.dart'));

    if (!exportFile.existsSync()) {
      return;
    }

    final content = await exportFile.readAsString();
    final exportLine = "export '$componentName/$componentName.dart';";

    if (!content.contains(exportLine)) {
      return;
    }

    // Remove the export line
    final lines = content.split('\n');
    final newLines = lines.where((line) => line.trim() != exportLine).toList();
    await exportFile.writeAsString(newLines.join('\n'));
  }
}
