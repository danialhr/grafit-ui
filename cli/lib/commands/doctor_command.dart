import 'dart:io';
import 'package:args/command_runner.dart';
import 'package:path/path.dart' as p;
import '../utils/output.dart';
import '../config/config_manager.dart';
import '../registry/registry_loader.dart';

/// Health check result
enum HealthStatus {
  healthy,
  warning,
  error,
}

class HealthCheck {
  final String name;
  final String description;
  final HealthStatus status;
  final String? message;
  final String? fix;

  HealthCheck({
    required this.name,
    required this.description,
    required this.status,
    this.message,
    this.fix,
  });

  String get statusIcon {
    switch (status) {
      case HealthStatus.healthy:
        return '✓';
      case HealthStatus.warning:
        return '⚠';
      case HealthStatus.error:
        return '✗';
    }
  }
}

class DoctorCommand extends Command<void> {
  @override
  String get name => 'doctor';

  @override
  String get description => 'Check project health and configuration';

  @override
  Future<void> run() async {
    printHeader('Grafit UI Health Check');
    printSeparator();

    final checks = <HealthCheck>[];

    // Run all health checks
    checks.addAll(await _checkFlutterEnvironment());
    checks.addAll(await _checkProjectStructure());
    checks.addAll(await _checkGrafitConfig());
    checks.addAll(await _checkDependencies());
    checks.addAll(await _checkComponents());

    // Display results
    print('');
    printHeader('Health Check Results');
    printSeparator();

    var healthyCount = 0;
    var warningCount = 0;
    var errorCount = 0;

    for (final check in checks) {
      final icon = check.statusIcon;
      final statusText = _getStatusText(check.status);
      print('$icon $statusText ${check.name}');

      if (check.message != null) {
        print('    ${check.message}');
      }

      if (check.fix != null) {
        print('    Fix: ${check.fix}');
      }

      print('');

      switch (check.status) {
        case HealthStatus.healthy:
          healthyCount++;
          break;
        case HealthStatus.warning:
          warningCount++;
          break;
        case HealthStatus.error:
          errorCount++;
          break;
      }
    }

    // Summary
    printSeparator();
    printHeader('Summary');
    printSuccess('Healthy: $healthyCount');
    if (warningCount > 0) {
      printWarning('Warnings: $warningCount');
    }
    if (errorCount > 0) {
      printError('Errors: $errorCount');
    }
    printSeparator();

    // Overall status
    if (errorCount > 0) {
      printError('Project has issues that need attention.');
    } else if (warningCount > 0) {
      printWarning('Project is healthy with some warnings.');
    } else {
      printSuccess('Project is healthy!');
    }

    // Exit with error code if there are errors
    if (errorCount > 0) {
      exit(1);
    }
  }

  String _getStatusText(HealthStatus status) {
    switch (status) {
      case HealthStatus.healthy:
        return '';
      case HealthStatus.warning:
        return '[WARN]';
      case HealthStatus.error:
        return '[ERROR]';
    }
  }

  Future<List<HealthCheck>> _checkFlutterEnvironment() async {
    final checks = <HealthCheck>[];

    // Check Flutter installation
    final flutterResult = await Process.run('flutter', ['--version']);
    if (flutterResult.exitCode == 0) {
      final output = flutterResult.stdout as String;
      final version = output.split('\n').first.trim();
      checks.add(HealthCheck(
        name: 'Flutter Installation',
        description: 'Flutter SDK is installed',
        status: HealthStatus.healthy,
        message: version,
      ));
    } else {
      checks.add(HealthCheck(
        name: 'Flutter Installation',
        description: 'Flutter SDK is not installed or not in PATH',
        status: HealthStatus.error,
        message: 'flutter command not found',
        fix: 'Install Flutter from https://flutter.dev/docs/get-started/install',
      ));
    }

    // Check Dart installation
    final dartResult = await Process.run('dart', ['--version']);
    if (dartResult.exitCode == 0) {
      checks.add(HealthCheck(
        name: 'Dart Installation',
        description: 'Dart SDK is installed',
        status: HealthStatus.healthy,
      ));
    } else {
      checks.add(HealthCheck(
        name: 'Dart Installation',
        description: 'Dart SDK is not available',
        status: HealthStatus.warning,
        message: 'Dart usually comes with Flutter',
      ));
    }

    return checks;
  }

  Future<List<HealthCheck>> _checkProjectStructure() async {
    final checks = <HealthCheck>[];
    final projectPath = p.absolute('.');

    // Check if we're in a Flutter project
    final pubspecFile = File(p.join(projectPath, 'pubspec.yaml'));
    if (pubspecFile.existsSync()) {
      checks.add(HealthCheck(
        name: 'Flutter Project',
        description: 'Valid Flutter project structure',
        status: HealthStatus.healthy,
        message: 'pubspec.yaml found',
      ));
    } else {
      checks.add(HealthCheck(
        name: 'Flutter Project',
        description: 'Not a valid Flutter project',
        status: HealthStatus.error,
        message: 'pubspec.yaml not found',
        fix: 'Run this command in a Flutter project directory',
      ));
    }

    // Check for lib directory
    final libDir = Directory(p.join(projectPath, 'lib'));
    if (libDir.existsSync()) {
      checks.add(HealthCheck(
        name: 'Source Directory',
        description: 'lib/ directory exists',
        status: HealthStatus.healthy,
      ));
    } else {
      checks.add(HealthCheck(
        name: 'Source Directory',
        description: 'lib/ directory not found',
        status: HealthStatus.warning,
      ));
    }

    return checks;
  }

  Future<List<HealthCheck>> _checkGrafitConfig() async {
    final checks = <HealthCheck>[];
    final projectPath = p.absolute('.');

    // Check for Grafit initialization
    final config = GrafitConfig.load(projectPath);

    if (config.installedComponents.isNotEmpty) {
      checks.add(HealthCheck(
        name: 'Grafit Initialization',
        description: 'Grafit UI is initialized',
        status: HealthStatus.healthy,
        message: '${config.installedComponents.length} components installed',
      ));

      // Check components directory
      final componentsDir = Directory(config.componentsAbsolutePath);
      if (componentsDir.existsSync()) {
        checks.add(HealthCheck(
          name: 'Components Directory',
          description: 'Components directory exists',
          status: HealthStatus.healthy,
          message: config.componentsPath,
        ));
      } else {
        checks.add(HealthCheck(
          name: 'Components Directory',
          description: 'Components directory not found',
          status: HealthStatus.error,
          message: 'Configured as ${config.componentsPath}',
          fix: 'Run: gft init --force',
        ));
      }
    } else {
      checks.add(HealthCheck(
        name: 'Grafit Initialization',
        description: 'Grafit UI is not initialized',
        status: HealthStatus.warning,
        message: 'Run: gft init to get started',
      ));
    }

    return checks;
  }

  Future<List<HealthCheck>> _checkDependencies() async {
    final checks = <HealthCheck>[];
    final pubspecFile = File(p.absolute('pubspec.yaml'));

    if (!pubspecFile.existsSync()) {
      return checks;
    }

    final content = await pubspecFile.readAsString();

    // Check for common dependencies
    final dependencies = {
      'flutter': true,
      'cupertino_icons': false,
      'material': false,
    };

    for (final dep in dependencies.entries) {
      if (content.contains(dep.key)) {
        checks.add(HealthCheck(
          name: 'Dependency: ${dep.key}',
          description: 'Required dependency present',
          status: HealthStatus.healthy,
        ));
      } else if (dep.value) {
        checks.add(HealthCheck(
          name: 'Dependency: ${dep.key}',
          description: 'Required dependency missing',
          status: HealthStatus.error,
          fix: 'Add ${dep.key} to pubspec.yaml',
        ));
      }
    }

    return checks;
  }

  Future<List<HealthCheck>> _checkComponents() async {
    final checks = <HealthCheck>[];
    final projectPath = p.absolute('.');
    final config = GrafitConfig.load(projectPath);

    if (config.installedComponents.isEmpty) {
      return checks;
    }

    // Check installed components
    final componentsPath = config.componentsAbsolutePath;
    final componentsDir = Directory(componentsPath);

    if (!componentsDir.existsSync()) {
      checks.add(HealthCheck(
        name: 'Component Files',
        description: 'Cannot verify components',
        status: HealthStatus.warning,
        message: 'Components directory not found',
      ));
      return checks;
    }

    // Load registry
    try {
      final registry = RegistryLoader.loadFromCurrent();
      checks.add(HealthCheck(
        name: 'Component Registry',
        description: 'Component registry loaded',
        status: HealthStatus.healthy,
        message: '${registry.componentCount} components available',
      ));

      // Check for outdated components
      var outdatedCount = 0;
      for (final componentName in config.installedComponents) {
        final component = registry.getComponent(componentName);
        if (component != null && component.parity < 90) {
          outdatedCount++;
        }
      }

      if (outdatedCount > 0) {
        checks.add(HealthCheck(
          name: 'Component Updates',
          description: 'Some components may have updates',
          status: HealthStatus.warning,
          message: '$outdatedCount components below 90% parity',
          fix: 'Run: gft upgrade',
        ));
      } else {
        checks.add(HealthCheck(
          name: 'Component Updates',
          description: 'All components up to date',
          status: HealthStatus.healthy,
        ));
      }
    } catch (e) {
      checks.add(HealthCheck(
        name: 'Component Registry',
        description: 'Failed to load registry',
        status: HealthStatus.warning,
        message: e.toString(),
      ));
    }

    return checks;
  }
}
