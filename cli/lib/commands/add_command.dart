import 'dart:io';
import 'package:args/args.dart';
import 'package:args/command_runner.dart';
import '../config/config_manager.dart';
import '../utils/file_utils.dart';

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
    final projectPath = '.';
    final addAll = args['all'] as bool;
    final overwrite = args['overwrite'] as bool;
    final customPath = args['path'] as String?;
    final skipConfirm = args['yes'] as bool;

    // Check if initialized
    if (!ConfigManager.isInitialized(projectPath)) {
      print('Error: Grafit not initialized in this project.');
      print('Run: pikpo init');
      return;
    }

    final config = ConfigManager.loadConfig(projectPath)!;
    final componentsPath = customPath ??
        FileUtils.joinPath(projectPath, config.componentsPath);

    if (addAll) {
      print('Adding all components...');
      print('(This will add all available components)');
      print('Not implemented yet - use specific component names');
      return;
    }

    // Get component name from arguments
    if (argResults!.rest.isEmpty) {
      print('Error: No component specified');
      print('Usage: pikpo add <component>');
      print('Run: pikpo list to see available components');
      return;
    }

    final componentName = argResults!.rest.first.toLowerCase();

    // Validate component exists (TODO: check registry)
    print('Adding component: $componentName');
    print('Output path: $componentsPath');
    print('');
    print('Note: Component registry not yet implemented.');
    print('This will copy component files to your project.');
    print('');
    print('(Component installation will be implemented in Phase 2)');
  }
}
