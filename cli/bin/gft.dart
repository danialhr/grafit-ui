#!/usr/bin/env dart

import 'package:args/command_runner.dart';
import 'package:grafit_cli/commands/init_command.dart';
import 'package:grafit_cli/commands/add_command.dart';
import 'package:grafit_cli/commands/list_command.dart';
import 'package:grafit_cli/commands/view_command.dart';

void main(List<String> args) async {
  final runner = CommandRunner('gft', 'Grafit - Flutter port of shadcn/ui')
    ..addCommand(InitCommand())
    ..addCommand(AddCommand())
    ..addCommand(ListCommand())
    ..addCommand(ViewCommand())
    ..argParser.addFlag('version',
        abbr: 'v', negatable: false, help: 'Print the CLI version');

  try {
    await runner.run(args);
  } catch (e) {
    print('Error: $e');
  }
}
