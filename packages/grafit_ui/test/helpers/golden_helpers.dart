library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

/// Golden test utilities for Grafit UI.
///
/// Usage:
/// ```dart
/// import '../../../helpers/golden_helpers.dart';
///
/// testGolden('button_primary', 
///   const GrafitButton(label: 'Click', variant: GrafitButtonVariant.primary),
/// );
/// ```

/// Default device for golden tests
final Device defaultGoldenDevice = Device(
  size: const Size(400, 800),
  devicePixelRatio: 1.0,
  name: 'test',
);

/// Large device for components that need more space
final Device largeGoldenDevice = Device(
  size: const Size(800, 600),
  devicePixelRatio: 1.0,
  name: 'large',
);

/// Small device for compact component testing
final Device smallGoldenDevice = Device(
  size: const Size(200, 100),
  devicePixelRatio: 1.0,
  name: 'small',
);

/// Configuration for golden tests
class GoldenConfig {
  final String sceneName;
  final String? variant;
  final String? size;
  final bool enabled;
  final bool darkMode;

  const GoldenConfig({
    required this.sceneName,
    this.variant,
    this.size,
    this.enabled = true,
    this.darkMode = false,
  });

  String get fileName {
    final parts = [sceneName];
    if (variant != null) parts.add(variant!);
    if (size != null) parts.add(size!);
    if (enabled) parts.add('disabled');
    if (darkMode) parts.add('dark');
    return parts.join('_');
  }
}

/// Run a golden test for a widget
///
/// Usage:
/// ```dart
/// testGolden(
///   'button_primary',
///   const GrafitButton(label: 'Click', variant: GrafitButtonVariant.primary),
/// );
/// ```
void testGolden(
  String name,
  Widget widget, {
  GoldenConfig config = const GoldenConfig(sceneName: 'default'),
  bool skip = false,
}) {
  testWidgets(
    'Golden: $name',
    (tester) async {
      await tester.pumpWidgetBuilder(
        MaterialApp(
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          themeMode: config.darkMode ? ThemeMode.dark : ThemeMode.light,
          home: Scaffold(
            body: Center(
              child: widget,
            ),
          ),
        ),
      );

      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/${config.fileName}.png'),
      );
    },
    skip: skip,
  );
}

/// Run golden tests for all variants of a component
///
/// Usage:
/// ```dart
/// testGoldenVariants(
///   'button',
///   {
///     'primary': GrafitButton(label: 'Click', variant: GrafitButtonVariant.primary),
///     'secondary': GrafitButton(label: 'Click', variant: GrafitButtonVariant.secondary),
///     'ghost': GrafitButton(label: 'Click', variant: GrafitButtonVariant.ghost),
///   },
/// );
/// ```
void testGoldenVariants(
  String componentName,
  Map<String, Widget> variants, {
  bool skip = false,
  bool includeDarkMode = false,
}) {
  group('Golden: $componentName', () {
    for (final entry in variants.entries) {
      final variantName = entry.key;
      final widget = entry.value;

      testGolden(
        '$componentName\_$variantName',
        widget,
        config: GoldenConfig(
          sceneName: componentName,
          variant: variantName,
        ),
        skip: skip,
      );

      if (includeDarkMode) {
        testGolden(
          '$componentName\_$variantName\_dark',
          widget,
          config: GoldenConfig(
            sceneName: componentName,
            variant: variantName,
            darkMode: true,
          ),
          skip: skip,
        );
      }
    }
  });
}

/// Run golden tests for all sizes of a component
///
/// Usage:
/// ```dart
/// testGoldenSizes(
///   'button',
///   {
///     'sm': GrafitButton(label: 'Click', size: GrafitButtonSize.sm),
///     'md': GrafitButton(label: 'Click', size: GrafitButtonSize.md),
///     'lg': GrafitButton(label: 'Click', size: GrafitButtonSize.lg),
///   },
/// );
/// ```
void testGoldenSizes(
  String componentName,
  Map<String, Widget> sizes, {
  bool skip = false,
}) {
  group('Golden: $componentName\_sizes', () {
    for (final entry in sizes.entries) {
      final sizeName = entry.key;
      final widget = entry.value;

      testGolden(
        '$componentName\_$sizeName',
        widget,
        config: GoldenConfig(
          sceneName: componentName,
          size: sizeName,
        ),
        skip: skip,
      );
    }
  });
}

/// Create a golden test wrapper with custom theme
///
/// Usage:
/// ```dart
/// await tester.pumpWidget(
///   goldenWrapper(
///     GrafitButton(label: 'Click'),
///     theme: GrafitTheme.light(),
///   ),
/// );
/// ```
Widget goldenWrapper(
  Widget child, {
  ThemeData? theme,
  bool isDark = false,
}) {
  return MediaQuery(
    data: const MediaQueryData(),
    child: MaterialApp(
      theme: theme,
      darkTheme: ThemeData.dark(),
      themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
      home: Scaffold(
        body: Center(child: child),
      ),
    ),
  );
}
