import 'package:flutter/material.dart';
import '../../lib/src/theme/theme.dart';

/// Test wrapper widget that provides GrafitTheme to child widgets
///
/// This utility ensures that all Grafit UI components are tested with proper
/// theming, matching real-world usage.
///
/// Usage:
/// ```dart
/// await tester.pumpWidget(
///   ThemedTestWidget(
///     child: GrafitButton(label: 'Click me'),
///   ),
/// );
/// ```
class ThemedTestWidget extends StatelessWidget {
  final Widget child;
  final GrafitTheme? theme;
  final bool isDark;

  const ThemedTestWidget({
    super.key,
    required this.child,
    this.theme,
    this.isDark = false,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveTheme = theme ?? (isDark ? GrafitTheme.dark() : GrafitTheme.light());

    return MaterialApp(
      title: 'Grafit UI Test',
      theme: ThemeData(
        colorScheme: effectiveTheme.base,
        extensions: [effectiveTheme],
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: effectiveTheme.base,
        extensions: [effectiveTheme],
        useMaterial3: true,
      ),
      themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
      home: Scaffold(
        backgroundColor: effectiveTheme.colors.background,
        body: Center(child: child),
      ),
    );
  }
}

/// Test wrapper with light theme
///
/// Usage:
/// ```dart
/// await tester.pumpWidget(
///   LightThemedTestWidget(child: GrafitButton(label: 'Click')),
/// );
/// ```
class LightThemedTestWidget extends StatelessWidget {
  final Widget child;
  final GrafitTheme? theme;

  const LightThemedTestWidget({
    super.key,
    required this.child,
    this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return ThemedTestWidget(
      theme: theme ?? GrafitTheme.light(),
      isDark: false,
      child: child,
    );
  }
}

/// Test wrapper with dark theme
///
/// Usage:
/// ```dart
/// await tester.pumpWidget(
///   DarkThemedTestWidget(child: GrafitButton(label: 'Click')),
/// );
/// ```
class DarkThemedTestWidget extends StatelessWidget {
  final Widget child;
  final GrafitTheme? theme;

  const DarkThemedTestWidget({
    super.key,
    required this.child,
    this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return ThemedTestWidget(
      theme: theme ?? GrafitTheme.dark(),
      isDark: true,
      child: child,
    );
  }
}

/// Test wrapper with scaffold for layout testing
///
/// Usage:
/// ```dart
/// await tester.pumpWidget(
///   ScaffoldTestWidget(
///     body: GrafitInput(label: 'Test'),
///   ),
/// );
/// ```
class ScaffoldTestWidget extends StatelessWidget {
  final Widget body;
  final AppBar? appBar;
  final Widget? floatingActionButton;
  final GrafitTheme? theme;
  final bool isDark;

  const ScaffoldTestWidget({
    super.key,
    required this.body,
    this.appBar,
    this.floatingActionButton,
    this.theme,
    this.isDark = false,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveTheme = theme ?? (isDark ? GrafitTheme.dark() : GrafitTheme.light());

    return MaterialApp(
      theme: ThemeData(
        colorScheme: effectiveTheme.base,
        extensions: [effectiveTheme],
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: effectiveTheme.base,
        extensions: [effectiveTheme],
        useMaterial3: true,
      ),
      themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
      home: Scaffold(
        appBar: appBar,
        body: body,
        floatingActionButton: floatingActionButton,
      ),
    );
  }
}

/// Test wrapper with scrolling enabled
///
/// Usage:
/// ```dart
/// await tester.pumpWidget(
///   ScrollableTestWidget(
///     child: Column(
///       children: List.generate(100, (i) => Text('Item $i')),
///     ),
///   ),
/// );
/// ```
class ScrollableTestWidget extends StatelessWidget {
  final Widget child;
  final ScrollController? controller;
  final Axis scrollDirection;
  final GrafitTheme? theme;
  final bool isDark;

  const ScrollableTestWidget({
    super.key,
    required this.child,
    this.controller,
    this.scrollDirection = Axis.vertical,
    this.theme,
    this.isDark = false,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveTheme = theme ?? (isDark ? GrafitTheme.dark() : GrafitTheme.light());

    return MaterialApp(
      theme: ThemeData(
        colorScheme: effectiveTheme.base,
        extensions: [effectiveTheme],
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: effectiveTheme.base,
        extensions: [effectiveTheme],
        useMaterial3: true,
      ),
      themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
      home: Scaffold(
        body: SingleChildScrollView(
          controller: controller,
          scrollDirection: scrollDirection,
          child: child,
        ),
      ),
    );
  }
}

/// Test wrapper with custom constraints (for responsive testing)
///
/// Usage:
/// ```dart
/// await tester.pumpWidget(
///   ConstrainedTestWidget(
///     width: 400,
///     height: 600,
///     child: GrafitButton(label: 'Click'),
///   ),
/// );
/// ```
class ConstrainedTestWidget extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final BoxConstraints? constraints;
  final GrafitTheme? theme;
  final bool isDark;

  const ConstrainedTestWidget({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.constraints,
    this.theme,
    this.isDark = false,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveTheme = theme ?? (isDark ? GrafitTheme.dark() : GrafitTheme.light());

    return MaterialApp(
      theme: ThemeData(
        colorScheme: effectiveTheme.base,
        extensions: [effectiveTheme],
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: effectiveTheme.base,
        extensions: [effectiveTheme],
        useMaterial3: true,
      ),
      themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
      home: Scaffold(
        body: Center(
          child: ConstrainedBox(
            constraints: constraints ??
                BoxConstraints(
                  maxWidth: width ?? double.infinity,
                  maxHeight: height ?? double.infinity,
                ),
            child: child,
          ),
        ),
      ),
    );
  }
}

/// Test wrapper with overlay support (for dialogs, popovers, etc.)
///
/// Usage:
/// ```dart
/// await tester.pumpWidget(
///   OverlayTestWidget(
///     child: Builder(
///       builder: (context) => GrafitButton(
///         label: 'Show Dialog',
///         onPressed: () => showDialog(context: context, builder: (_) => ...),
///       ),
///     ),
///   ),
/// );
/// ```
class OverlayTestWidget extends StatelessWidget {
  final Widget child;
  final GrafitTheme? theme;
  final bool isDark;

  const OverlayTestWidget({
    super.key,
    required this.child,
    this.theme,
    this.isDark = false,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveTheme = theme ?? (isDark ? GrafitTheme.dark() : GrafitTheme.light());

    return MaterialApp(
      theme: ThemeData(
        colorScheme: effectiveTheme.base,
        extensions: [effectiveTheme],
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: effectiveTheme.base,
        extensions: [effectiveTheme],
        useMaterial3: true,
      ),
      themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
      home: Scaffold(
        body: child,
      ),
    );
  }
}
