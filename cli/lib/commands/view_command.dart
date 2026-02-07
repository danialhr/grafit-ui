import 'dart:io';
import 'package:args/args.dart';
import 'package:args/command_runner.dart';
import 'package:path/path.dart' as p;
import '../utils/output.dart';
import '../registry/registry_loader.dart';
import '../models/component.dart';

class ViewCommand extends Command<void> {
  @override
  String get name => 'view';

  @override
  String get description => 'View component source code';

  @override
  ArgParser get argParser {
    return ArgParser()
      ..addOption('editor',
          abbr: 'e',
          help: 'Editor to open source in (code, vim, nano, etc.)')
      ..addFlag('metadata',
          negatable: false,
          help: 'Show component metadata only');
  }

  @override
  Future<void> run() async {
    if (argResults!.rest.isEmpty) {
      printError('No component specified');
      printInfo('Usage: gft view <component>');
      printInfo('Run: gft list to see available components');
      return;
    }

    final componentName = argResults!.rest.first.toLowerCase();
    final editor = argResults!['editor'] as String?;
    final metadataOnly = argResults!['metadata'] as bool;

    try {
      final registry = RegistryLoader.loadFromCurrent();
      final component = registry.getComponent(componentName);

      if (component == null) {
        printError('Component "$componentName" not found');
        printInfo('Run: gft list to see available components');
        return;
      }

      // Get the component file path using registry loader's path resolution
      final grafitUiPath = p.join(Directory.current.path, 'packages', 'grafit_ui');
      final componentPath = p.join(grafitUiPath, component.sourcePath);
      final componentFile = File(componentPath);

      if (!componentFile.existsSync()) {
        printError('Component source file not found at: $componentPath');
        return;
      }

      // Display component metadata
      _displayComponentInfo(component);

      // If editor specified, open the file
      if (editor != null) {
        _openInEditor(componentPath, editor);
        return;
      }

      // If metadata only, don't show source
      if (metadataOnly) {
        return;
      }

      // Display source preview
      printHeader('Source Preview');
      printSeparator();

      final source = componentFile.readAsStringSync();
      final lines = source.split('\n');
      final previewLines = lines.take(40).toList();

      for (var i = 0; i < previewLines.length; i++) {
        final lineNum = (i + 1).toString().padLeft(4);
        final line = previewLines[i];
        printDebug('$lineNum $line');
      }

      if (lines.length > 40) {
        print('');
        printDebug('... (${lines.length - 40} more lines)');
      }

      printSeparator();
      printPair('File', componentPath);
      printInfo('To open in editor: gft view $componentName -e <editor>');

    } catch (e) {
      printError('Failed to view component: $e');
    }
  }

  void _displayComponentInfo(GrafitComponent component) {
    printSeparator();
    printHeader('Component: ${component.name}');
    printSeparator();
    print('');

    printPair('Category', component.category);
    printPair('Status', component.status);
    printPair('Parity', '${component.parity}%');

    if (component.dependencies.isNotEmpty) {
      printPair('Dependencies', component.dependencies.join(', '));
    }

    print('');
    printHeader('Paths');
    printIndent('Source: ${component.sourcePath}');
    printIndent('Dart: ${component.dartPath}');
    print('');

    if (component.files.isNotEmpty) {
      printHeader('Files');
      for (final file in component.files) {
        printIndent('• $file');
      }
      print('');
    }
  }

  void _openInEditor(String filePath, String editor) {
    printInfo('Opening in $editor...');

    Process.start(editor, [filePath]).then((process) {
      printSuccess('Opened: $filePath');
    }).catchError((e) {
      printError('Failed to open editor: $e');
      printInfo('Try opening manually: $filePath');
    });
  }
}
