library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Common test utilities for Grafit UI widget tests.
///
/// This file provides helper functions to reduce boilerplate in widget tests.
///
/// Usage:
/// ```dart
/// import '../../../helpers/test_helpers.dart';
///
/// testGrafitWidget('my test', (tester) async {
///   await tester.pumpWidget(
///     ThemedTestWidget(
///       child: GrafitButton(label: 'Click me'),
///     ),
///   );
///   expect(find.byType(GrafitButton), findsOneWidget);
/// });
/// ```

/// Default test wrapper with GrafitTheme
class TestApp extends StatelessWidget {
  final Widget child;
  final ThemeData? theme;
  final bool isDark;

  const TestApp({
    super.key,
    required this.child,
    this.theme,
    this.isDark = false,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: theme,
      home: Scaffold(
        body: child,
      ),
    );
  }
}

/// Custom testWidgets wrapper with GrafitTheme
///
/// Usage:
/// ```dart
/// testGrafitWidget('Button renders', (tester) async {
///   await tester.pumpWidget(
///     ThemedTestWidget(
///       child: GrafitButton(label: 'Click me'),
///     ),
///   );
///   expect(find.text('Click me'), findsOneWidget);
/// });
/// ```
typedef GrafitWidgetTestCallback = Future<void> Function(WidgetTester tester);

void testGrafitWidget(
  String description,
  GrafitWidgetTestCallback callback, {
  bool skip = false,
  Timeout? timeout,
}) {
  testWidgets(
    description,
    (tester) async {
      await callback(tester);
    },
    skip: skip,
    timeout: timeout,
  );
}

/// Finder helper to locate widget by type with debug check
///
/// Usage:
/// ```dart
/// final buttonFinder = findByType<GrafitButton>();
/// ```
Finder findByType<T extends Widget>() {
  return find.byType(T);
}

/// Finder helper to locate widget by key
///
/// Usage:
/// ```dart
/// final finder = findByKey(Key('my-key'));
/// ```
Finder findByKey(Key key) {
  return find.byKey(key);
}

/// Verify a widget exists and is visible
///
/// Usage:
/// ```dart
/// expectVisible(find.text('Hello'));
/// ```
void expectVisible(Finder finder, {String? reason}) {
  expect(finder, findsOneWidget, reason: reason);
}

/// Verify a widget does not exist
///
/// Usage:
/// ```dart
/// expectNotFound(find.text('Hidden'));
/// ```
void expectNotFound(Finder finder, {String? reason}) {
  expect(finder, findsNothing, reason: reason);
}

/// Tap a widget and wait for animations
///
/// Usage:
/// ```dart
/// await tapAndWait(tester, find.byType(GrafitButton));
/// ```
Future<void> tapAndWait(
  WidgetTester tester,
  Finder finder, {
  int milliseconds = 300,
}) async {
  await tester.tap(finder);
  await tester.pump(Duration(milliseconds: milliseconds ~/ 2));
  await tester.pump(Duration(milliseconds: milliseconds ~/ 2));
}

/// Enter text into a text field and wait
///
/// Usage:
/// ```dart
/// await enterText(tester, find.byType(TextField), 'test input');
/// ```
Future<void> enterText(
  WidgetTester tester,
  Finder finder,
  String text, {
  int milliseconds = 100,
}) async {
  await tester.enterText(finder, text);
  await tester.pump(Duration(milliseconds: milliseconds));
}

/// Wait for all animations to complete
///
/// Usage:
/// ```dart
/// await waitForAnimations(tester);
/// ```
Future<void> waitForAnimations(WidgetTester tester) async {
  await tester.pumpAndSettle();
}

/// Get widget of type from finder
///
/// Usage:
/// ```dart
/// final button = widgetOf<GrafitButton>(find.byType(GrafitButton));
/// ```
T widgetOf<T extends Widget>(Finder finder) {
  return finder.evaluate().single.widget as T;
}

/// Verify widget property value
///
/// Usage:
/// ```dart
/// expectProperty(
///   find.byType(GrafitButton),
///   (GrafitButton b) => b.label,
///   'Submit',
/// );
/// ```
void expectProperty<T extends Widget, R>(
  Finder finder,
  R Function(T widget) property,
  R expected, {
  String? reason,
}) {
  final widget = widgetOf<T>(finder);
  expect(property(widget), expected, reason: reason);
}

/// Create a test callback tracker
///
/// Usage:
/// ```dart
/// final callback = createCallbackTracker();
/// GrafitButton(onPressed: callback.voidCallback);
/// expect(callback.called, isTrue);
/// ```
CallbackTracker createCallbackTracker() {
  return CallbackTracker();
}

/// Callback tracker for testing user interactions
class CallbackTracker {
  int _callCount = 0;
  final List<dynamic> _positionalArgs = [];
  final Map<Symbol, dynamic> _namedArgs = {};

  int get callCount => _callCount;
  bool get called => _callCount > 0;
  List<dynamic> get positionalArgs => List.unmodifiable(_positionalArgs);
  Map<Symbol, dynamic> get namedArgs => Map.unmodifiable(_namedArgs);

  void call([List<dynamic> positionalArgs = const [], Map<Symbol, dynamic> namedArgs = const {}]) {
    _callCount++;
    _positionalArgs.addAll(positionalArgs);
    _namedArgs.addAll(namedArgs);
  }

  VoidCallback get voidCallback => () => call();

  void reset() {
    _callCount = 0;
    _positionalArgs.clear();
    _namedArgs.clear();
  }
}
