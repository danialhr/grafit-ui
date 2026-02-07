import 'dart:io';

/// ANSI color codes for terminal output
class _AnsiColors {
  static const String reset = '\x1b[0m';
  static const String bold = '\x1b[1m';
  static const String dim = '\x1b[2m';
  static const String italic = '\x1b[3m';
  static const String underline = '\x1b[4m';

  // Foreground colors
  static const String black = '\x1b[30m';
  static const String red = '\x1b[31m';
  static const String green = '\x1b[32m';
  static const String yellow = '\x1b[33m';
  static const String blue = '\x1b[34m';
  static const String magenta = '\x1b[35m';
  static const String cyan = '\x1b[36m';
  static const String white = '\x1b[37m';

  // Bright foreground colors
  static const String brightBlack = '\x1b[90m';
  static const String brightRed = '\x1b[91m';
  static const String brightGreen = '\x1b[92m';
  static const String brightYellow = '\x1b[93m';
  static const String brightBlue = '\x1b[94m';
  static const String brightMagenta = '\x1b[95m';
  static const String brightCyan = '\x1b[96m';
  static const String brightWhite = '\x1b[97m';

  // Background colors
  static const String onBlack = '\x1b[40m';
  static const String onRed = '\x1b[41m';
  static const String onGreen = '\x1b[42m';
  static const String onYellow = '\x1b[43m';
  static const String onBlue = '\x1b[44m';
  static const String onMagenta = '\x1b[45m';
  static const String onCyan = '\x1b[46m';
  static const String onWhite = '\x1b[47m';
}

/// Check if terminal supports colors
bool _supportsColors() {
  // Check if running in CI
  if (Platform.environment['CI'] != null) return false;

  // Check NO_COLOR environment variable
  if (Platform.environment['NO_COLOR'] != null) return false;

  // Check if stdout is a terminal
  if (stdout.hasTerminal) {
    // Windows 10+ supports ANSI colors
    if (Platform.isWindows) return true;

    // Unix-like systems usually support colors
    return true;
  }

  return false;
}

/// Strip ANSI codes from string
String _stripAnsi(String text) {
  // Remove ANSI escape sequences
  final ansiPattern = RegExp('\x1b\\[[0-9;]*m');
  return text.replaceAll(ansiPattern, '');
}

/// Apply color to text if supported
String _colorize(String text, String color) {
  if (_supportsColors()) {
    return '$color$text${_AnsiColors.reset}';
  }
  return text;
}

/// Print a success message in green
void printSuccess(String message, {bool bold = true}) {
  final prefix = _colorize('✓', _AnsiColors.brightGreen);
  final msg = bold ? _colorize(message, _AnsiColors.bold + _AnsiColors.green) : _colorize(message, _AnsiColors.green);
  print('$prefix $msg');
}

/// Print an error message in red
void printError(String message, {bool bold = true}) {
  final prefix = _colorize('✗', _AnsiColors.brightRed);
  final msg = bold ? _colorize(message, _AnsiColors.bold + _AnsiColors.red) : _colorize(message, _AnsiColors.red);
  print('$prefix $msg');
}

/// Print an info message in cyan
void printInfo(String message, {bool bold = false}) {
  final prefix = _colorize('ℹ', _AnsiColors.brightCyan);
  final msg = bold ? _colorize(message, _AnsiColors.bold + _AnsiColors.cyan) : _colorize(message, _AnsiColors.cyan);
  print('$prefix $msg');
}

/// Print a warning message in yellow
void printWarning(String message, {bool bold = false}) {
  final prefix = _colorize('⚠', _AnsiColors.brightYellow);
  final msg = bold ? _colorize(message, _AnsiColors.bold + _AnsiColors.yellow) : _colorize(message, _AnsiColors.yellow);
  print('$prefix $msg');
}

/// Print a debug message in dim
void printDebug(String message) {
  final msg = _colorize(message, _AnsiColors.dim);
  print(msg);
}

/// Print a header/title
void printHeader(String title) {
  final line = '═' * (title.length + 4);
  final coloredTitle = _colorize(title, _AnsiColors.bold + _AnsiColors.brightCyan);
  final coloredLine = _colorize(line, _AnsiColors.dim + _AnsiColors.cyan);
  print('\n$coloredLine');
  print('  $coloredTitle  ');
  print('$coloredLine\n');
}

/// Print a separator line
void printSeparator({String char = '─', int length = 80}) {
  final line = char * length;
  print(_colorize(line, _AnsiColors.dim));
}

/// Print a step counter
void printStep(int step, int total, String description) {
  final stepStr = _colorize('[$step/$total]', _AnsiColors.dim);
  final desc = _colorize(description, _AnsiColors.brightBlue);
  print('$stepStr $desc');
}

/// Print formatted table
void printTable(List<String> headers, List<List<String>> rows) {
  if (headers.isEmpty || rows.isEmpty) {
    printWarning('No data to display');
    return;
  }

  // Calculate column widths
  final colCount = headers.length;
  final widths = List<int>.filled(colCount, 0);

  // Check headers width
  for (var i = 0; i < colCount; i++) {
    widths[i] = _stripAnsi(headers[i]).length;
  }

  // Check rows width
  for (final row in rows) {
    for (var i = 0; i < colCount && i < row.length; i++) {
      final len = _stripAnsi(row[i]).length;
      if (len > widths[i]) widths[i] = len;
    }
  }

  // Add padding
  for (var i = 0; i < widths.length; i++) {
    widths[i] += 2;
  }

  // Print header
  final headerStr = _buildRow(headers, widths, isHeader: true);
  print(headerStr);

  // Print separator
  final sep = _buildSeparator(widths);
  print(_colorize(sep, _AnsiColors.dim));

  // Print rows
  for (final row in rows) {
    print(_buildRow(row, widths));
  }
}

/// Build a table row
String _buildRow(List<String> cells, List<int> widths, {bool isHeader = false}) {
  final buffer = StringBuffer();

  for (var i = 0; i < widths.length && i < cells.length; i++) {
    final cell = cells[i];
    final width = widths[i];
    final cellLen = _stripAnsi(cell).length;
    final padding = width - cellLen;

    final prefix = ' ' * (padding ~/ 2);
    final suffix = ' ' * (padding - (padding ~/ 2));

    if (isHeader) {
      buffer.write(_colorize('$prefix$suffix', _AnsiColors.bold + _AnsiColors.brightCyan));
      buffer.write(_colorize(cell, _AnsiColors.bold + _AnsiColors.brightCyan));
    } else {
      buffer.write(prefix);
      buffer.write(cell);
      buffer.write(suffix);
    }

    if (i < widths.length - 1) {
      buffer.write(_colorize('│', _AnsiColors.dim));
    }
  }

  return buffer.toString();
}

/// Build a separator line for table
String _buildSeparator(List<int> widths) {
  final parts = widths.map((w) => '─' * w).join('┼');
  return '┌$parts┐';
}

/// Print a list with bullets
void printList(List<String> items, {String bullet = '•'}) {
  for (final item in items) {
    final b = _colorize(bullet, _AnsiColors.cyan);
    print('  $b $item');
  }
}

/// Print indented text
void printIndent(String text, {int spaces = 2}) {
  final indent = ' ' * spaces;
  print('$indent$text');
}

/// Print a key-value pair
void printPair(String key, String value) {
  final k = _colorize(key, _AnsiColors.brightBlue);
  final v = _colorize(value, _AnsiColors.white);
  print('  $k: $v');
}

/// Clear the terminal screen
void clearScreen() {
  if (_supportsColors()) {
    print('\x1b[2J\x1b[H');
  }
}

/// Print a progress bar
void printProgress(int current, int total, {String label = 'Progress', int width = 50}) {
  final percent = (current / total * 100).floor();
  final filled = (current / total * width).floor();
  final empty = width - filled;

  final bar = '█' * filled + '░' * empty;
  final coloredBar = _colorize(bar, _AnsiColors.brightGreen);

  final percentStr = _colorize('$percent%', _AnsiColors.brightBlue);
  final labelStr = _colorize(label, _AnsiColors.cyan);

  // Clear line and print
  stdout.write('\r\x1b[K$labelStr: [$coloredBar] $percentStr');
  stdout.flush();
}
