import 'dart:io';
import 'package:args/command_runner.dart';
import 'commands/init_command.dart';
import 'commands/add_command.dart';
import 'commands/list_command.dart';
import 'commands/view_command.dart';
import 'commands/update_command.dart';
import 'commands/version_command.dart';

/// Main CLI class for Grafit UI
class GrafitCLI extends CommandRunner<void> {
  GrafitCLI()
      : super(
          'gft',
          'Grafit UI - Flutter component library\n'
          'A beautiful component library for Flutter with 59 components at 100% parity '
          'with shadcn/ui.',
        ) {
    // Add commands
    addCommand(InitCommand());
    addCommand(AddCommand());
    addCommand(ListCommand());
    addCommand(ViewCommand());
    addCommand(UpdateCommand());
    addCommand(VersionCommand());

    // Add global flags
    argParser.addFlag('verbose',
        abbr: 'V', negatable: false, help: 'Enable verbose output');
  }

  static String get version => '0.1.0';
}

/// Main entry point for the CLI
Future<void> runCli(List<String> args) async {
  final cli = GrafitCLI();

  try {
    await cli.run(args);
  } on UsageException catch (e) {
    print(e.toString());
    exit(64); // EX_USAGE
  } catch (e) {
    print('Error: $e');
    exit(1);
  }
}
