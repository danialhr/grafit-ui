import 'dart:io';
import 'package:args/command_runner.dart';
import 'package:path/path.dart' as p;
import '../config/config_manager.dart';
import '../utils/output.dart';
import '../utils/file_utils.dart';
import '../registry/registry_loader.dart';
import '../models/component.dart';
import '../models/registry.dart';

class UpdateCommand extends Command<void> {
  @override
  String get name => 'update';

  @override
  String get description => 'Update Grafit UI components';

  @override
  Future<void> run() async {
    final projectPath = p.absolute('.');

    // Check if initialized
    final config = GrafitConfig.load(projectPath);
    if (config.installedComponents.isEmpty) {
      printWarning('Grafit not initialized in this project.');
      printInfo('Run: gft init');
      return;
    }

    try {
      final registry = RegistryLoader.loadFromCurrent();
      final grafitUiPath = _findGrafitUiPath();
      final componentsPath = config.componentsAbsolutePath;

      printHeader('Grafit UI Component Update');
      printSeparator();

      // Find components that need updating
      final componentsToUpdate = _findComponentsToUpdate(registry, config, componentsPath);

      if (componentsToUpdate.isEmpty) {
        printSuccess('All components are up to date!');
        return;
      }

      printInfo('Found ${componentsToUpdate.length} component(s) that can be updated:');
      printSeparator();

      for (final entry in componentsToUpdate.entries) {
        final component = entry.key;
        final info = entry.value;

        if (info.hasUpdate) {
          printInfo('  ${component.name}: ${info.currentParity}% → ${component.parity}%');
        } else {
          printDebug('  ${component.name}: Update available');
        }
      }

      printSeparator();

      // Confirm update
      stdout.write('Update these components? [y/N]: ');
      final response = stdin.readLineSync()?.toLowerCase();
      if (response != 'y' && response != 'yes') {
        printDebug('Aborted.');
        return;
      }

      // Update components
      int successCount = 0;
      int failCount = 0;

      for (final entry in componentsToUpdate.entries) {
        final component = entry.key;

        try {
          await _updateComponent(component, grafitUiPath, componentsPath);
          successCount++;
        } catch (e) {
          failCount++;
          printError('Failed to update ${component.name}: $e');
        }
      }

      printSeparator();
      printHeader('Update Summary');
      printSuccess('Updated: $successCount components');
      if (failCount > 0) {
        printError('Failed: $failCount components');
      }

    } catch (e) {
      printError('Failed to check for updates: $e');
    }
  }

  String _findGrafitUiPath() {
    final searchPaths = [
      p.join(Directory.current.path, '..', 'packages', 'grafit_ui'),
      p.join(Directory.current.path, '..', 'grafit_ui'),
    ];

    for (final path in searchPaths) {
      if (Directory(path).existsSync()) {
        return path;
      }
    }

    return p.join(Directory.current.path, '..', 'packages', 'grafit_ui');
  }

  Map<GrafitComponent, _UpdateInfo> _findComponentsToUpdate(
    ComponentRegistry registry,
    GrafitConfig config,
    String componentsPath,
  ) {
    final updates = <GrafitComponent, _UpdateInfo>{};

    for (final componentName in config.installedComponents) {
      final component = registry.getComponent(componentName);
      if (component == null) continue;

      final componentDir = Directory(p.join(componentsPath, component.name));
      if (!componentDir.existsSync()) continue;

      final componentFile = File(p.join(componentsPath, component.name, '${component.name}.dart'));
      if (!componentFile.existsSync()) continue;

      // Check if component has newer parity available
      final currentParity = component.parity;
      final hasUpdate = currentParity < 100; // Simplified check

      if (hasUpdate) {
        updates[component] = _UpdateInfo(
          currentParity: currentParity,
          hasUpdate: true,
        );
      }
    }

    return updates;
  }

  Future<void> _updateComponent(
    GrafitComponent component,
    String grafitUiPath,
    String componentsPath,
  ) async {
    printInfo('Updating ${component.name}...');

    final sourcePath = p.join(grafitUiPath, component.sourcePath);
    final destPath = p.join(componentsPath, component.name, '${component.name}.dart');

    await FileUtils.copyFile(sourcePath, destPath);
    printSuccess('Updated ${component.name}');
  }
}

class _UpdateInfo {
  final int currentParity;
  final bool hasUpdate;

  _UpdateInfo({
    required this.currentParity,
    required this.hasUpdate,
  });
}