import 'dart:io';

/// ANSI color codes for terminal output
class AnsiColors {
  static const String reset = '\x1B[0m';
  static const String bold = '\x1B[1m';
  static const String dim = '\x1B[2m';
  
  // Foreground colors
  static const String red = '\x1B[31m';
  static const String green = '\x1B[32m';
  static const String yellow = '\x1B[33m';
  static const String blue = '\x1B[34m';
  static const String magenta = '\x1B[35m';
  static const String cyan = '\x1B[36m';
  static const String white = '\x1B[37m';
  
  // Background colors
  static const String redBg = '\x1B[41m';
  static const String greenBg = '\x1B[42m';
  static const String yellowBg = '\x1B[43m';
  static const String blueBg = '\x1B[44m';
}

/// CLI output utilities
class CliOutput {
  /// Print a success message in green
  static void success(String message) {
    print('${AnsiColors.green}$message${AnsiColors.reset}');
  }

  /// Print an error message in red
  static void error(String message) {
    stderr.writeln('${AnsiColors.red}Error: $message${AnsiColors.reset}');
  }

  /// Print a warning message in yellow
  static void warning(String message) {
    print('${AnsiColors.yellow}$message${AnsiColors.reset}');
  }

  /// Print an info message in cyan
  static void info(String message) {
    print('${AnsiColors.cyan}$message${AnsiColors.reset}');
  }

  /// Print a header with bold text
  static void header(String message) {
    print('${AnsiColors.bold}$message${AnsiColors.reset}');
  }

  /// Print a dim (subtle) message
  static void dim(String message) {
    print('${AnsiColors.dim}$message${AnsiColors.reset}');
  }

  /// Print a checkmark with success message
  static void check(String message) {
    success('✓ $message');
  }

  /// Print a cross mark with error message
  static void cross(String message) {
    error('✗ $message');
  }

  /// Print a section divider
  static void divider({String char = '─', int length = 60}) {
    print(char * length);
  }

  /// Print a category header
  static void categoryHeader(String category) {
    print('');
    header('${AnsiColors.bold}${AnsiColors.blue}$category${AnsiColors.reset}');
  }

  /// Print component status with appropriate color
  static void componentStatus(String name, String status, {int? parity}) {
    final statusLower = status.toLowerCase();
    String color;
    String symbol;

    if (statusLower == 'implemented' || (parity ?? 0) == 100) {
      color = AnsiColors.green;
      symbol = '✓';
    } else if (statusLower == 'partial' || (parity ?? 0) >= 80) {
      color = AnsiColors.yellow;
      symbol = '~';
    } else {
      color = AnsiColors.dim;
      symbol = '○';
    }

    final parityStr = parity != null ? ' ($parity%)' : '';
    print('$color$symbol $name$parityStr${AnsiColors.reset}');
  }

  /// Confirm an action with user
  static Future<bool> confirm(String message, {bool defaultValue = false}) async {
    final prompt = '$message ${defaultValue ? '[Y/n]' : '[y/N]'}: ';
    stdout.write(prompt);
    
    final response = stdin.readLineSync()?.toLowerCase().trim();
    if (response == null || response.isEmpty) {
      return defaultValue;
    }
    
    return response == 'y' || response == 'yes';
  }
}

/// Progress indicator for long-running operations
class ProgressIndicator {
  final String message;
  int _current = 0;
  int _total = 0;

  ProgressIndicator(this.message);

  void start(int total) {
    _total = total;
    _current = 0;
    _update();
  }

  void increment() {
    _current++;
    _update();
  }

  void _update() {
    if (_total > 0) {
      final percent = ((_current / _total) * 100).toInt();
      stdout.write('\r$message [${'=' * (percent ~/ 5)}${' ' * (20 - percent ~/ 5)}] $percent%');
    } else {
      stdout.write('\r$message...');
    }
    
    if (_current >= _total) {
      print(''); // New line when complete
    }
  }

  void complete() {
    stdout.write('\r');
    CliOutput.check('$message completed');
  }
}