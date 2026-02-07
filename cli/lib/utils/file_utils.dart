import 'dart:io';
import 'package:path/path.dart' as p;
import 'dart:math' as math;

/// Utilities for file operations in the CLI
class FileUtils {
  /// Copy a file from source to destination
  static Future<void> copyFile(String source, String destination) async {
    final sourceFile = File(source);
    if (!sourceFile.existsSync()) {
      throw FileSystemException('Source file not found', source);
    }

    final destFile = File(destination);
    await destFile.parent.create(recursive: true);
    await sourceFile.copy(destination);
  }

  /// Copy a directory recursively
  static Future<void> copyDirectory(String source, String destination) async {
    final sourceDir = Directory(source);
    if (!sourceDir.existsSync()) {
      throw FileSystemException('Source directory not found', source);
    }

    final destDir = Directory(destination);
    await destDir.create(recursive: true);

    await for (final entity in sourceDir.list(recursive: true)) {
      final relativePath = p.relative(entity.path, from: source);
      final destPath = p.join(destination, relativePath);

      if (entity is File) {
        await entity.copy(destPath);
      } else if (entity is Directory) {
        await Directory(destPath).create(recursive: true);
      }
    }
  }

  /// Create a file with content
  static Future<void> createFile(String path, String content) async {
    final file = File(path);
    await file.parent.create(recursive: true);
    await file.writeAsString(content);
  }

  /// Create a directory if it doesn't exist
  static Future<void> ensureDirectory(String path) async {
    final dir = Directory(path);
    if (!dir.existsSync()) {
      await dir.create(recursive: true);
    }
  }

  /// Read file content as string
  static String readFile(String path) {
    final file = File(path);
    if (!file.existsSync()) {
      throw FileSystemException('File not found', path);
    }
    return file.readAsStringSync();
  }

  /// Check if a file exists
  static bool fileExists(String path) {
    return File(path).existsSync();
  }

  /// Check if a directory exists
  static bool directoryExists(String path) {
    return Directory(path).existsSync();
  }

  /// Delete a file if it exists
  static Future<void> deleteFile(String path) async {
    final file = File(path);
    if (file.existsSync()) {
      await file.delete();
    }
  }

  /// Delete a directory if it exists
  static Future<void> deleteDirectory(String path) async {
    final dir = Directory(path);
    if (dir.existsSync()) {
      await dir.delete(recursive: true);
    }
  }

  /// List all files in a directory
  static List<File> listFiles(String path, {String? extension}) {
    final dir = Directory(path);
    if (!dir.existsSync()) {
      return [];
    }

    return dir
        .listSync(recursive: true)
        .whereType<File>()
        .where((file) => extension == null || file.path.endsWith(extension))
        .toList();
  }

  /// Get the relative path from base to target
  static String relativePath(String target, String base) {
    return p.relative(target, from: base);
  }

  /// Join path segments
  static String joinPath(String part1, String part2, [String? part3]) {
    return p.join(part1, part2, part3 ?? '');
  }

  /// Get the file extension
  static String getExtension(String path) {
    return p.extension(path);
  }

  /// Get the basename without extension
  static String getBasename(String path) {
    return p.basenameWithoutExtension(path);
  }

  /// Normalize a path
  static String normalizePath(String path) {
    return p.normalize(path);
  }

  /// Update pubspec.yaml with a new dependency
  ///
  /// Returns true if pubspec was modified, false if dependency already exists
  static Future<bool> updatePubspec(
    String projectPath, {
    required String packageName,
    String? version,
    bool isDevDependency = false,
  }) async {
    final pubspecPath = p.join(projectPath, 'pubspec.yaml');
    final pubspecFile = File(pubspecPath);

    if (!pubspecFile.existsSync()) {
      throw FileSystemException('pubspec.yaml not found', pubspecPath);
    }

    final content = await pubspecFile.readAsString();
    final lines = content.split('\n');

    // Check if dependency already exists
    final depKey = '$packageName:';
    final depExists = lines.any((line) =>
        line.trim().startsWith(depKey) ||
        line.replaceAll(' ', '').startsWith(depKey));

    if (depExists) {
      return false;
    }

    // Find the dependencies section
    final depSection = isDevDependency ? 'dev_dependencies:' : 'dependencies:';
    int insertIndex = -1;

    for (var i = 0; i < lines.length; i++) {
      if (lines[i].trim() == depSection) {
        // Found the section, insert after it
        insertIndex = i + 1;

        // Skip existing dependencies
        while (insertIndex < lines.length &&
            (lines[insertIndex].startsWith('  ') ||
                lines[insertIndex].trim().isEmpty)) {
          // Look for next section start (not indented or empty)
          if (insertIndex + 1 < lines.length &&
              !lines[insertIndex + 1].startsWith('  ') &&
              lines[insertIndex + 1].trim().isNotEmpty) {
            break;
          }
          insertIndex++;
        }
        break;
      }
    }

    if (insertIndex == -1) {
      // Add dependencies section at end
      final newIndex = lines.length;
      lines.add('');
      lines.add(depSection);
      insertIndex = newIndex + 1;
    }

    // Insert the new dependency
    final versionStr = version ?? 'any';
    final newDepLine = '  $packageName: $versionStr';
    lines.insert(insertIndex, newDepLine);

    // Write back
    await pubspecFile.writeAsString(lines.join('\n'));
    return true;
  }

  /// Create or update the grafit_ui.dart export file
  static Future<void> createExports(
    String libPath, {
    List<String> components = const [],
    String exportFileName = 'grafit_ui.dart',
  }) async {
    final exportFilePath = p.join(libPath, exportFileName);
    final exportFile = File(exportFilePath);

    // Build content
    final buffer = StringBuffer();
    buffer.writeln('// Grafit UI - Component Library');
    buffer.writeln('// Auto-generated. Do not edit manually.');
    buffer.writeln();
    buffer.writeln("library grafit_ui;");
    buffer.writeln();

    // Add component exports
    if (components.isNotEmpty) {
      buffer.writeln('// Components');
      for (final component in components) {
        final className = _toClassName(component);
        buffer.writeln("export 'components/$component.dart' show $className;");
      }
      buffer.writeln();
    }

    // Add theme exports
    buffer.writeln('// Themes');
    buffer.writeln("export 'themes/grafit_theme.dart';");
    buffer.writeln();

    // Add utils exports
    buffer.writeln('// Utilities');
    buffer.writeln("export 'utils/grafit_utils.dart';");

    await exportFile.writeAsString(buffer.toString());
  }

  /// Convert kebab-case to PascalCase
  static String _toClassName(String name) {
    return name
        .split('-')
        .map((part) => part.isEmpty
            ? ''
            : part[0].toUpperCase() + part.substring(1))
        .join();
  }

  /// Create directory recursively (alias for ensureDirectory)
  static Future<void> createDirectory(String path) async {
    await ensureDirectory(path);
  }
}
