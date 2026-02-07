import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../lib/src/theme/theme.dart';
import '../../lib/src/components/form/button.dart';

/// Helper widget that provides GrafitTheme for testing
class GrafitThemedTest extends StatelessWidget {
  final Widget child;
  final bool isDark;

  const GrafitThemedTest({
    Key? key,
    required this.child,
    this.isDark = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        extensions: [GrafitTheme.light()],
      ),
      darkTheme: ThemeData(
        extensions: [GrafitTheme.dark()],
      ),
      themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
      home: Scaffold(
        body: Center(
          child: child,
        ),
      ),
    );
  }
}

/// Helper function to pump widget with GrafitTheme
Future<void> pumpGrafitThemedWidget(
  WidgetTester tester, {
  required Widget child,
  bool isDark = false,
}) {
  return tester.pumpWidget(
    GrafitThemedTest(
      child: child,
      isDark: isDark,
    ),
  );
}

/// Find a widget by its type and text content
Finder findWidgetWithText(Type type, String text) {
  return find.ancestor(
    of: find.text(text),
    matching: find.byType(type),
  );
}

/// Common test delays for animations
const testShortDuration = Duration(milliseconds: 100);
const testMediumDuration = Duration(milliseconds: 300);
const testLongDuration = Duration(milliseconds: 500);
