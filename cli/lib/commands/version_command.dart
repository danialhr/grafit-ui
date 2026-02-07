import 'package:args/command_runner.dart';
import '../utils/output.dart';
import '../cli.dart';

class VersionCommand extends Command<void> {
  @override
  String get name => 'version';

  @override
  String get description => 'Show CLI version information';

  @override
  Future<void> run() async {
    printHeader('Grafit CLI');
    printSeparator();
    printPair('Version', GrafitCLI.version);
    printSeparator();
    printInfo('Flutter component library based on shadcn/ui');
    printInfo('A beautiful component library for Flutter with 59 components at 100% parity');
    printSeparator();
  }
}