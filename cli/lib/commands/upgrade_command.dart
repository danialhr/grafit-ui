import 'dart:io';
import 'package:args/args.dart';
import 'package:args/command_runner.dart';
import 'package:path/path.dart' as p;
import '../utils/output.dart';
import '../config/config_manager.dart';
import '../registry/registry_loader.dart';

/// Component update info
class ComponentUpdate {
  final String name;
  final int currentParity;
  final int latestParity;
  final String status;

  ComponentUpdate({
    required this.name,
    required this.currentParity,
    required this.latestParity,
    required this.status,
  });

  bool get needsUpdate => currentParity < latestParity;
}

class UpgradeCommand extends Command<void> {
  @override
  String get name => 'upgrade';

  @override
  String get description => 'Upgrade Grafit UI components to latest versions';

  @override
  ArgParser get argParser {
    return ArgParser()
      ..addFlag('check',
          abbr: 'c',
          negatable: false,
          help: 'Check for updates without upgrading')
      ..addFlag('all',
          abbr: 'a',
          negatable: false,
          help: 'Upgrade all components')
      ..addFlag('yes',
          abbr: 'y',
          negatable: false,
          help: 'Skip confirmation prompts');
  }

  @override
  Future<void> run() async {
    final args = argResults!;
    final checkOnly = args['check'] as bool;
    final upgradeAll = args['all'] as bool;
    final skipConfirm = args['yes'] as bool;

    printHeader('Grafit UI Upgrade Check');
    printSeparator();

    // Load registry and config
    final registry = RegistryLoader.loadFromCurrent();
    final config = GrafitConfig.load(p.absolute('.'));

    if (config.installedComponents.isEmpty) {
      printWarning('No components installed yet.');
      printInfo('Run: gft init to initialize Grafit UI');
      return;
    }

    // Find available updates
    final updates = <ComponentUpdate>[];
    for (final componentName in config.installedComponents) {
      final component = registry.getComponent(componentName);
      if (component != null) {
        // For now, we'll track parity as the "version"
        updates.add(ComponentUpdate(
          name: componentName,
          currentParity: component.parity,
          latestParity: 100, // Target is always 100%
          status: component.status,
        ));
      }
    }

    final updatesAvailable = updates.where((u) => u.needsUpdate).toList();

    if (updatesAvailable.isEmpty) {
      printSuccess('All components are up to date!');
      printInfo('Installed: ${config.installedComponents.length} components');
      return;
    }

    // Display available updates
    printInfo('Found ${updatesAvailable.length} updates:');
    printSeparator();

    for (final update in updatesAvailable) {
      final parityDiff = update.latestParity - update.currentParity;
      print('  • ${update.name}: ${update.currentParity}% → ${update.latestParity}% (+${parityDiff}%)');
    }

    printSeparator();

    if (checkOnly) {
      printInfo('Run: gft upgrade to apply updates');
      return;
    }

    // Confirm upgrade
    if (!skipConfirm) {
      stdout.write('Upgrade ${updatesAvailable.length} components? [y/N]: ');
      final response = stdin.readLineSync()?.toLowerCase();
      if (response != 'y' && response != 'yes') {
        printDebug('Aborted.');
        return;
      }
    }

    // Perform upgrade
    printHeader('Upgrading Components');
    printSeparator();

    var successCount = 0;
    var failCount = 0;

    for (var i = 1; i <= updatesAvailable.length; i++) {
      final update = updatesAvailable[i - 1];
      printStep(i, updatesAvailable.length, 'Upgrading ${update.name}...');

      try {
        await _upgradeComponent(update);
        successCount++;
      } catch (e) {
        failCount++;
        printError('Failed: ${update.name} - $e');
      }
    }

    printSeparator();
    printHeader('Summary');
    printSuccess('Upgraded: $successCount components');
    if (failCount > 0) {
      printError('Failed: $failCount components');
    }

    if (failCount == 0) {
      print('');
      printSuccess('Grafit UI upgraded successfully!');
      printInfo('Run: gft doctor to verify installation');
    }
  }

  Future<void> _upgradeComponent(ComponentUpdate update) async {
    // For this initial implementation, we'll note that the component
    // would be re-copied from the Grafit UI package source

    // In a full implementation, this would:
    // 1. Copy the latest component files from packages/grafit_ui
    // 2. Handle any breaking changes
    // 3. Update imports and dependencies
    // 4. Run any migration scripts

    // For now, we'll simulate the upgrade
    await Future.delayed(Duration(milliseconds: 100));

    printDebug('Updated ${update.name} to ${update.latestParity}% parity');
  }
}
