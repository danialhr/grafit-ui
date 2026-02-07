import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grafit_ui/src/components/navigation/tabs.dart';
import 'package:grafit_ui/src/theme/theme.dart';

/// Test helper widget for Grafit themed tests
class GrafitThemedTest extends StatelessWidget {
  final Widget child;

  const GrafitThemedTest({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        extensions: [GrafitTheme.light()],
      ),
      home: Scaffold(body: child),
    );
  }
}

void main() {
  group('GrafitTabs', () {
    group('Rendering', () {
      testWidgets('renders without error', (tester) async {
        await tester.pumpWidget(
          GrafitThemedTest(
            child: SizedBox(
              height: 300,
              child: GrafitTabs(
                tabs: const [
                  GrafitTab(label: 'Tab 1', content: Text('Content 1')),
                  GrafitTab(label: 'Tab 2', content: Text('Content 2')),
                ],
              ),
            ),
          ),
        );
        expect(find.byType(GrafitTabs), findsOneWidget);
      });

      testWidgets('renders value variant correctly', (tester) async {
        await tester.pumpWidget(
          GrafitThemedTest(
            child: SizedBox(
              height: 300,
              child: GrafitTabs(
                variant: GrafitTabsVariant.value,
                tabs: const [
                  GrafitTab(label: 'Tab 1', content: Text('Content 1')),
                ],
              ),
            ),
          ),
        );
        expect(find.byType(GrafitTabs), findsOneWidget);
        expect(find.text('Tab 1'), findsOneWidget);
      });

      testWidgets('renders line variant correctly', (tester) async {
        await tester.pumpWidget(
          GrafitThemedTest(
            child: SizedBox(
              height: 300,
              child: GrafitTabs(
                variant: GrafitTabsVariant.line,
                tabs: const [
                  GrafitTab(label: 'Tab 1', content: Text('Content 1')),
                ],
              ),
            ),
          ),
        );
        expect(find.byType(GrafitTabs), findsOneWidget);
        expect(find.text('Tab 1'), findsOneWidget);
      });

      testWidgets('renders horizontal orientation by default', (tester) async {
        await tester.pumpWidget(
          GrafitThemedTest(
            child: SizedBox(
              height: 300,
              child: GrafitTabs(
                tabs: const [
                  GrafitTab(label: 'Tab 1', content: Text('Content 1')),
                ],
              ),
            ),
          ),
        );
        expect(find.byType(GrafitTabs), findsOneWidget);
      });

      testWidgets('renders vertical orientation correctly', (tester) async {
        await tester.pumpWidget(
          GrafitThemedTest(
            child: SizedBox(
              height: 300,
              child: GrafitTabs(
                orientation: GrafitTabsOrientation.vertical,
                tabs: const [
                  GrafitTab(label: 'Tab 1', content: Text('Content 1')),
                  GrafitTab(label: 'Tab 2', content: Text('Content 2')),
                ],
              ),
            ),
          ),
        );
        expect(find.byType(GrafitTabs), findsOneWidget);
      });

      testWidgets('renders single tab', (tester) async {
        await tester.pumpWidget(
          GrafitThemedTest(
            child: SizedBox(
              height: 300,
              child: GrafitTabs(
                tabs: const [
                  GrafitTab(label: 'Only Tab', content: Text('Only Content')),
                ],
              ),
            ),
          ),
        );
        expect(find.byType(GrafitTabs), findsOneWidget);
        expect(find.text('Only Tab'), findsOneWidget);
      });

      testWidgets('renders many tabs', (tester) async {
        await tester.pumpWidget(
          GrafitThemedTest(
            child: SizedBox(
              height: 300,
              child: GrafitTabs(
                tabs: const [
                  GrafitTab(label: 'Tab 1', content: Text('Content 1')),
                  GrafitTab(label: 'Tab 2', content: Text('Content 2')),
                  GrafitTab(label: 'Tab 3', content: Text('Content 3')),
                  GrafitTab(label: 'Tab 4', content: Text('Content 4')),
                  GrafitTab(label: 'Tab 5', content: Text('Content 5')),
                ],
              ),
            ),
          ),
        );
        expect(find.byType(GrafitTabs), findsOneWidget);
        expect(find.text('Tab 1'), findsOneWidget);
        expect(find.text('Tab 5'), findsOneWidget);
      });
    });

    group('Tab Switching', () {
      testWidgets('switches to next tab on tap', (tester) async {
        int? changedIndex;

        await tester.pumpWidget(
          GrafitThemedTest(
            child: SizedBox(
              height: 300,
              child: GrafitTabs(
                tabs: const [
                  GrafitTab(label: 'Tab 1', content: Text('Content 1')),
                  GrafitTab(label: 'Tab 2', content: Text('Content 2')),
                ],
                onChanged: (index) => changedIndex = index,
              ),
            ),
          ),
        );

        await tester.tap(find.text('Tab 2'));
        await tester.pumpAndSettle();

        expect(changedIndex, equals(1));
      });

      testWidgets('respects initial index', (tester) async {
        await tester.pumpWidget(
          GrafitThemedTest(
            child: SizedBox(
              height: 300,
              child: GrafitTabs(
                initialIndex: 2,
                tabs: const [
                  GrafitTab(label: 'Tab 1', content: Text('Content 1')),
                  GrafitTab(label: 'Tab 2', content: Text('Content 2')),
                  GrafitTab(label: 'Tab 3', content: Text('Content 3')),
                ],
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('Content 3'), findsOneWidget);
      });

      testWidgets('displays correct content for each tab', (tester) async {
        await tester.pumpWidget(
          GrafitThemedTest(
            child: SizedBox(
              height: 300,
              child: GrafitTabs(
                tabs: const [
                  GrafitTab(label: 'First', content: Text('First Content')),
                  GrafitTab(label: 'Second', content: Text('Second Content')),
                ],
              ),
            ),
          ),
        );

        expect(find.text('First Content'), findsOneWidget);
        expect(find.text('Second Content'), findsNothing);

        await tester.tap(find.text('Second'));
        await tester.pumpAndSettle();

        expect(find.text('First Content'), findsNothing);
        expect(find.text('Second Content'), findsOneWidget);
      });
    });

    group('Vertical Tabs', () {
      testWidgets('switches tabs in vertical orientation', (tester) async {
        await tester.pumpWidget(
          GrafitThemedTest(
            child: SizedBox(
              height: 300,
              child: GrafitTabs(
                orientation: GrafitTabsOrientation.vertical,
                tabs: const [
                  GrafitTab(label: 'Tab 1', content: Text('Content 1')),
                  GrafitTab(label: 'Tab 2', content: Text('Content 2')),
                ],
              ),
            ),
          ),
        );

        expect(find.text('Content 1'), findsOneWidget);

        await tester.tap(find.text('Tab 2'));
        await tester.pumpAndSettle();

        expect(find.text('Content 2'), findsOneWidget);
      });

      testWidgets('renders vertical line variant', (tester) async {
        await tester.pumpWidget(
          GrafitThemedTest(
            child: SizedBox(
              height: 300,
              child: GrafitTabs(
                variant: GrafitTabsVariant.line,
                orientation: GrafitTabsOrientation.vertical,
                tabs: const [
                  GrafitTab(label: 'Tab 1', content: Text('Content 1')),
                  GrafitTab(label: 'Tab 2', content: Text('Content 2')),
                ],
              ),
            ),
          ),
        );
        expect(find.byType(GrafitTabs), findsOneWidget);
      });
    });

    group('Complex Content', () {
      testWidgets('renders rich tab content', (tester) async {
        await tester.pumpWidget(
          GrafitThemedTest(
            child: SizedBox(
              height: 300,
              child: GrafitTabs(
                tabs: [
                  GrafitTab(
                    label: 'Settings',
                    content: const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Text('Account Settings', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          SizedBox(height: 16),
                          Text('Manage your account settings here.'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
        expect(find.text('Account Settings'), findsOneWidget);
      });

      testWidgets('handles interactive content in tabs', (tester) async {
        await tester.pumpWidget(
          GrafitThemedTest(
            child: SizedBox(
              height: 300,
              child: GrafitTabs(
                tabs: [
                  GrafitTab(
                    label: 'Interactive',
                    content: Column(
                      children: const [
                        TextField(key: Key('field1'), decoration: InputDecoration(labelText: 'Field 1')),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
        expect(find.byKey(const Key('field1')), findsOneWidget);
      });
    });
  });
}
