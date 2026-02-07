import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grafit_ui/grafit_ui.dart';

import '../../test_helper.dart';

void main() {
  group('GrafitDialog', () {
    group('Rendering', () {
      testWidgets('renders without error', (tester) async {
        await tester.pumpWidget(
          GrafitThemedTest(
            child: AlertDialog(
              title: const Text('Test Dialog'),
              content: const Text('Dialog content'),
            ),
          ),
        );
        expect(find.text('Test Dialog'), findsOneWidget);
        expect(find.text('Dialog content'), findsOneWidget);
      });

      testWidgets('renders with title and description', (tester) async {
        await tester.pumpWidget(
          GrafitThemedTest(
            child: AlertDialog(
              title: const Text('Title'),
              content: const Text('Description'),
            ),
          ),
        );
        expect(find.text('Title'), findsOneWidget);
        expect(find.text('Description'), findsOneWidget);
      });

      testWidgets('renders with custom actions', (tester) async {
        await tester.pumpWidget(
          GrafitThemedTest(
            child: AlertDialog(
              title: const Text('Test'),
              actions: [
                TextButton(onPressed: () {}, child: const Text('Cancel')),
                TextButton(onPressed: () {}, child: const Text('OK')),
              ],
            ),
          ),
        );
        expect(find.text('Cancel'), findsOneWidget);
        expect(find.text('OK'), findsOneWidget);
      });
    });

    group('Dialog.show()', () {
      testWidgets('shows dialog using show method', (tester) async {
        await tester.pumpWidget(
          GrafitThemedTest(
            child: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  GrafitDialog.show(
                    context,
                    title: 'Test Dialog',
                    description: 'Test Description',
                  );
                },
                child: const Text('Open'),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Open'));
        await tester.pumpAndSettle();

        expect(find.text('Test Dialog'), findsOneWidget);
        expect(find.text('Test Description'), findsOneWidget);
      });

      testWidgets('returns result when confirmed', (tester) async {
        bool? result;
        await tester.pumpWidget(
          GrafitThemedTest(
            child: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () async {
                  result = await GrafitDialog.show(
                    context,
                    title: 'Confirm',
                    description: 'Are you sure?',
                  );
                },
                child: const Text('Open'),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Open'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Confirm'));
        await tester.pumpAndSettle();

        expect(result, isNotNull);
      });

      testWidgets('calls onConfirm callback', (tester) async {
        bool confirmed = false;
        await tester.pumpWidget(
          GrafitThemedTest(
            child: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  GrafitDialog.show(
                    context,
                    title: 'Test',
                    onConfirm: () => confirmed = true,
                  );
                },
                child: const Text('Open'),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Open'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Confirm'));
        await tester.pumpAndSettle();

        expect(confirmed, isTrue);
      });

      testWidgets('calls onCancel callback', (tester) async {
        bool cancelled = false;
        await tester.pumpWidget(
          GrafitThemedTest(
            child: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  GrafitDialog.show(
                    context,
                    title: 'Test',
                    onCancel: () => cancelled = true,
                  );
                },
                child: const Text('Open'),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Open'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Cancel'));
        await tester.pumpAndSettle();

        expect(cancelled, isTrue);
      });
    });

    group('Backdrop and Dismissal', () {
      testWidgets('dismisses on backdrop tap', (tester) async {
        await tester.pumpWidget(
          GrafitThemedTest(
            child: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => GrafitDialog(
                      title: 'Test',
                      description: 'Content',
                    ),
                  );
                },
                child: const Text('Open'),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Open'));
        await tester.pumpAndSettle();

        expect(find.text('Test'), findsOneWidget);

        // Tap outside dialog
        await tester.tapAt(const Offset(10, 10));
        await tester.pumpAndSettle();

        expect(find.text('Test'), findsNothing);
      });

      testWidgets('dismisses on escape key', (tester) async {
        await tester.pumpWidget(
          GrafitThemedTest(
            child: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => const GrafitDialog(
                      title: 'Test',
                      description: 'Content',
                    ),
                  );
                },
                child: const Text('Open'),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Open'));
        await tester.pumpAndSettle();

        expect(find.text('Test'), findsOneWidget);

        // Simulate escape key
        await tester.sendKeyEvent(LogicalKeyboardKey.escape);
        await tester.pumpAndSettle();

        expect(find.text('Test'), findsNothing);
      });
    });

    group('Animation', () {
      testWidgets('animates in when shown', (tester) async {
        await tester.pumpWidget(
          GrafitThemedTest(
            child: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  GrafitDialog.show(context, title: 'Test');
                },
                child: const Text('Open'),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Open'));
        await tester.pump();

        // Dialog should be visible after first pump
        expect(find.text('Test'), findsOneWidget);

        // Wait for animation to complete
        await tester.pumpAndSettle();
      });
    });

    group('Custom Button Text', () {
      testWidgets('uses custom confirm button text', (tester) async {
        await tester.pumpWidget(
          GrafitThemedTest(
            child: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  GrafitDialog.show(
                    context,
                    title: 'Test',
                    confirmText: 'Delete',
                  );
                },
                child: const Text('Open'),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Open'));
        await tester.pumpAndSettle();

        expect(find.text('Delete'), findsOneWidget);
      });

      testWidgets('uses custom cancel button text', (tester) async {
        await tester.pumpWidget(
          GrafitThemedTest(
            child: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  GrafitDialog.show(
                    context,
                    title: 'Test',
                    cancelText: 'Close',
                  );
                },
                child: const Text('Open'),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Open'));
        await tester.pumpAndSettle();

        expect(find.text('Close'), findsOneWidget);
      });

      testWidgets('hides cancel button when showCancel is false', (tester) async {
        await tester.pumpWidget(
          GrafitThemedTest(
            child: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  GrafitDialog.show(
                    context,
                    title: 'Test',
                    showCancel: false,
                  );
                },
                child: const Text('Open'),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Open'));
        await tester.pumpAndSettle();

        expect(find.text('Cancel'), findsNothing);
        expect(find.text('Confirm'), findsOneWidget);
      });
    });

    group('Content', () {
      testWidgets('renders custom content widget', (tester) async {
        await tester.pumpWidget(
          GrafitThemedTest(
            child: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  GrafitDialog.show(
                    context,
                    title: 'Test',
                    content: const TextField(
                      decoration: InputDecoration(hintText: 'Enter text'),
                    ),
                  );
                },
                child: const Text('Open'),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Open'));
        await tester.pumpAndSettle();

        expect(find.byType(TextField), findsOneWidget);
        expect(find.text('Enter text'), findsOneWidget);
      });
    });
  });
}
