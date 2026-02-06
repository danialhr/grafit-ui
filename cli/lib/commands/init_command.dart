import 'dart:io';
import 'package:args/args.dart';
import 'package:args/command_runner.dart';
import '../config/config_manager.dart';
import '../utils/file_utils.dart';

class InitCommand extends Command<void> {
  @override
  String get name => 'init';

  @override
  String get description => 'Initialize a Flutter project with Grafit';

  @override
  ArgParser get argParser {
    return ArgParser()
      ..addFlag('src-dir',
          negatable: false,
          help: 'Use src/ directory for components (not implemented yet)')
      ..addFlag('css-variables',
          defaultsTo: true,
          negatable: true,
          help: 'Use theme variables (default: true)')
      ..addOption('base-color',
          defaultsTo: 'zinc',
          allowed: ['zinc', 'slate', 'neutral', 'stone'],
          help: 'Base color scheme')
      ..addFlag('yes',
          abbr: 'y',
          negatable: false,
          help: 'Skip confirmation prompts')
      ..addFlag('force',
          abbr: 'f',
          negatable: false,
          help: 'Overwrite existing config');
  }

  @override
  Future<void> run() async {
    final args = argResults!;
    final projectPath = argResults!.rest.isNotEmpty ? argResults!.rest.first : '.';
    final useThemeVars = args['css-variables'] as bool;
    final baseColor = args['base-color'] as String;
    final skipConfirm = args['yes'] as bool;
    final force = args['force'] as bool;

    // Validate Flutter project
    if (!ConfigManager.isFlutterProject(projectPath)) {
      print('Error: Not a valid Flutter project (pubspec.yaml not found)');
      return;
    }

    // Check if already initialized
    if (ConfigManager.isInitialized(projectPath) && !force) {
      print('Grafit is already initialized in this project.');
      print('Use --force to overwrite existing configuration.');
      return;
    }

    // Confirm initialization
    if (!skipConfirm) {
      print('Initializing Grafit in: $projectPath');
      print('Base color: $baseColor');
      print('Components path: lib/components/ui');
      print('');
      stdout.write('Continue? (y/n) ');
      final response = stdin.readLineSync()?.toLowerCase();
      if (response != 'y' && response != 'yes') {
        print('Aborted.');
        return;
      }
    }

    try {
      // Create configuration
      final config = GrafitConfig(
        style: 'default',
        componentsPath: 'lib/components/ui',
        themeExtension: 'PikpoTheme',
        baseColor: baseColor,
        useThemeVariables: useThemeVars,
        rtl: false,
      );

      // Save config
      await ConfigManager.saveConfig(projectPath, config);
      print('✓ Created components.json');

      // Create components directory
      final componentsPath = FileUtils.joinPath(projectPath, 'lib', 'components');
      await FileUtils.ensureDirectory(componentsPath);
      print('✓ Created lib/components/');

      // Create .gitkeep to keep directory in version control
      await FileUtils.createFile(
        FileUtils.joinPath(componentsPath, '.gitkeep'),
        '',
      );

      print('');
      print('Grafit initialized successfully!');
      print('');
      print('Next steps:');
      print('  1. Add PikpoTheme to your MaterialApp');
      print('  2. Run: pikpo add button');
      print('  3. Check docs/ for more information');
    } catch (e) {
      print('Error: $e');
    }
  }
}
