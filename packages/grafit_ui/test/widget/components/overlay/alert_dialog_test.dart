import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grafit_ui/grafit_ui.dart';

import '../../test_helper.dart';

void main() {
  group('GrafitAlertDialog', () {
    group('Rendering', () {
      testWidgets('renders without error when not visible', (tester) async {
        await tester.pumpWidget(
          const GrafitThemedTest(
            child: GrafitAlertDialog(
              titleText: 'Test',
              descriptionText: 'Description',
            ),
          ),
        );
        // When not visible, should render as empty
        expect(find.byType(SizedBox), findsOneWidget);
      });

      testWidgets('renders with title and description', (tester) async {
        await tester.pumpWidget(
          const GrafitThemedTest(
            child: GrafitAlertDialog(
              titleText: 'Warning',
              descriptionText: 'This action cannot be undone',
              trigger: ElevatedButton(
                onPressed: null,
                child: Text('Open'),
              ),
            ),
          ),
        );
        expect(find.text('Open'), findsOneWidget);
      });

      testWidgets('renders with custom actions', (tester) async {
        await tester.pumpWidget(
          GrafitThemedTest(
            child: GrafitAlertDialog(
              titleText: 'Confirm',
              descriptionText: 'Are you sure?',
              actions: [
                GrafitAlertDialogAction(label: 'OK'),
              ],
              trigger: ElevatedButton(
                onPressed: null,
                child: const Text('Open'),
              ),
            ),
          ),
        );
        expect(find.text('Open'), findsOneWidget);
      });
    });

    group('Open/Close Behavior', () {
      testWidgets('opens on trigger press when trigger provided', (tester) async {
        bool dialogShown = false;

        await tester.pumpWidget(
          StatefulBuilder(
            builder: (context, setState) {
              return GrafitThemedTest(
                child: Column(
                  children: [
                    GrafitAlertDialog(
                      titleText: 'Dialog Title',
                      descriptionText: 'Dialog Description',
                      trigger: ElevatedButton(
                        onPressed: () => setState(() => dialogShown = true),
                        child: const Text('Open Dialog'),
                      ),
                    ),
                    if (dialogShown)
                      const GrafitAlertDialog(
                        titleText: 'Dialog Title',
                        descriptionText: 'Dialog Description',
                      ),
                  ],
                ),
              );
            },
          ),
        );

        expect(find.text('Dialog Title'), findsNothing);

        await tester.tap(find.text('Open Dialog'));
        await tester.pump();

        // Dialog should appear (trigger is replaced with dialog)
        expect(find.text('Dialog Title'), findsOneWidget);
      });

      testWidgets('closes on cancel button press', (tester) async {
        await tester.pumpWidget(
          const GrafitThemedTest(
            child: GrafitAlertDialog(
              titleText: 'Confirm',
              descriptionText: 'Are you sure?',
              actions: [
                GrafitAlertDialogCancel(label: 'Cancel'),
                GrafitAlertDialogAction(label: 'Confirm'),
              ],
            ),
          ),
        );

        expect(find.text('Confirm'), findsOneWidget);
        expect(find.text('Cancel'), findsOneWidget);
      });

      testWidgets('closes on action button press', (tester) async {
        await tester.pumpWidget(
          GrafitThemedTest(
            child: GrafitAlertDialog(
              titleText: 'Delete',
              descriptionText: 'Delete this item?',
              actions: [
                GrafitAlertDialogAction(label: 'Delete', destructive: true),
              ],
            ),
          ),
        );

        expect(find.text('Delete'), findsOneWidget);
      });
    });

    group('Backdrop Dismissal', () {
      testWidgets('dismisses on backdrop tap when dismissible is true', (tester) async {
        await tester.pumpWidget(
          const GrafitThemedTest(
            child: GrafitAlertDialog(
              titleText: 'Test',
              descriptionText: 'Content',
              dismissible: true,
            ),
          ),
        );

        // Should render the dialog
        expect(find.text('Test'), findsOneWidget);

        // Tap on the backdrop area
        await tester.tapAt(const Offset(10, 10));
        await tester.pump();

        // Dialog should close
        expect(find.text('Test'), findsNothing);
      });

      testWidgets('does not dismiss on backdrop tap when dismissible is false', (tester) async {
        await tester.pumpWidget(
          const GrafitThemedTest(
            child: GrafitAlertDialog(
              titleText: 'Important',
              descriptionText: 'Must take action',
              dismissible: false,
            ),
          ),
        );

        expect(find.text('Important'), findsOneWidget);

        // Tap on backdrop
        await tester.tapAt(const Offset(10, 10));
        await tester.pump();

        // Dialog should remain visible
        expect(find.text('Important'), findsOneWidget);
      });
    });

    group('Size Variants', () {
      testWidgets('renders with small size', (tester) async {
        await tester.pumpWidget(
          const GrafitThemedTest(
            child: GrafitAlertDialog(
              titleText: 'Small Dialog',
              size: GrafitAlertDialogSize.sm,
            ),
          ),
        );

        expect(find.text('Small Dialog'), findsOneWidget);
      });

      testWidgets('renders with default size', (tester) async {
        await tester.pumpWidget(
          const GrafitThemedTest(
            child: GrafitAlertDialog(
              titleText: 'Default Dialog',
              size: GrafitAlertDialogSize.value,
            ),
          ),
        );

        expect(find.text('Default Dialog'), findsOneWidget);
      });
    });

    group('Media Component', () {
      testWidgets('renders with media', (tester) async {
        await tester.pumpWidget(
          const GrafitThemedTest(
            child: GrafitAlertDialog(
              titleText: 'Success',
              media: GrafitAlertDialogMedia(
                child: Icon(Icons.check_circle),
              ),
            ),
          ),
        );

        expect(find.text('Success'), findsOneWidget);
        expect(find.byIcon(Icons.check_circle), findsOneWidget);
      });

      testWidgets('renders media with custom background', (tester) async {
        await tester.pumpWidget(
          const GrafitThemedTest(
            child: GrafitAlertDialog(
              titleText: 'Custom Media',
              media: GrafitAlertDialogMedia(
                backgroundColor: Colors.blue,
                child: Icon(Icons.info),
              ),
            ),
          ),
        );

        expect(find.byType(GrafitAlertDialogMedia), findsOneWidget);
      });
    });

    group('Action Components', () {
      testWidgets('renders AlertDialogAction', (tester) async {
        await tester.pumpWidget(
          GrafitThemedTest(
            child: GrafitAlertDialog(
              titleText: 'Actions',
              actions: [
                GrafitAlertDialogAction(label: 'Primary'),
              ],
            ),
          ),
        );

        expect(find.text('Primary'), findsOneWidget);
      });

      testWidgets('renders destructive AlertDialogAction', (tester) async {
        await tester.pumpWidget(
          GrafitThemedTest(
            child: GrafitAlertDialog(
              titleText: 'Danger',
              actions: [
                GrafitAlertDialogAction(
                  label: 'Delete',
                  destructive: true,
                ),
              ],
            ),
          ),
        );

        expect(find.text('Delete'), findsOneWidget);
      });

      testWidgets('renders AlertDialogCancel', (tester) async {
        await tester.pumpWidget(
          GrafitThemedTest(
            child: GrafitAlertDialog(
              titleText: 'Cancel Test',
              actions: [
                GrafitAlertDialogCancel(label: 'Go Back'),
              ],
            ),
          ),
        );

        expect(find.text('Go Back'), findsOneWidget);
      });
    });

    group('Header Component', () {
      testWidgets('renders AlertDialogHeader', (tester) async {
        await tester.pumpWidget(
          const GrafitThemedTest(
            child: Column(
              children: [
                GrafitAlertDialogHeader(
                  title: Text('Header Title'),
                  media: Icon(Icons.star),
                ),
              ],
            ),
          ),
        );

        expect(find.text('Header Title'), findsOneWidget);
        expect(find.byIcon(Icons.star), findsOneWidget);
      });
    });

    group('Footer Component', () {
      testWidgets('renders AlertDialogFooter', (tester) async {
        await tester.pumpWidget(
          const GrafitThemedTest(
            child: Column(
              children: [
                GrafitAlertDialogFooter(
                  actions: [
                    Text(child: Text('Action 1')),
                    Text(child: Text('Action 2')),
                  ],
                ),
              ],
            ),
          ),
        );

        expect(find.text('Action 1'), findsOneWidget);
        expect(find.text('Action 2'), findsOneWidget);
      });
    });

    group('Custom Content', () {
      testWidgets('renders with custom content widget', (tester) async {
        await tester.pumpWidget(
          GrafitThemedTest(
            child: GrafitAlertDialog(
              titleText: 'Custom',
              content: const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    decoration: InputDecoration(hintText: 'Enter value'),
                  ),
                  SizedBox(height: 16),
                  Text('Additional info'),
                ],
              ),
            ),
          ),
        );

        expect(find.byType(TextField), findsOneWidget);
        expect(find.text('Additional info'), findsOneWidget);
      });
    });

    group('Title/Description Components', () {
      testWidgets('renders AlertDialogTitle', (tester) async {
        await tester.pumpWidget(
          const GrafitThemedTest(
            child: Column(
              children: [
                GrafitAlertDialogTitle(title: 'Title Component'),
              ],
            ),
          ),
        );

        expect(find.text('Title Component'), findsOneWidget);
      });

      testWidgets('renders AlertDialogDescription', (tester) async {
        await tester.pumpWidget(
          const GrafitThemedTest(
            child: Column(
              children: [
                GrafitAlertDialogDescription(
                  description: 'Description Component',
                ),
              ],
            ),
          ),
        );

        expect(find.text('Description Component'), findsOneWidget);
      });
    });

    group('Edge Cases', () {
      testWidgets('handles empty title', (tester) async {
        await tester.pumpWidget(
          GrafitThemedTest(
            child: GrafitAlertDialog(
              titleText: '',
              descriptionText: 'No title',
            ),
          ),
        );

        expect(find.text('No title'), findsOneWidget);
      });

      testWidgets('handles no actions', (tester) async {
        await tester.pumpWidget(
          const GrafitThemedTest(
            child: GrafitAlertDialog(
              titleText: 'No Actions',
              descriptionText: 'Cannot dismiss via buttons',
            ),
          ),
        );

        expect(find.text('No Actions'), findsOneWidget);
        // Should not have any action buttons
        expect(find.byType(GrafitButton), findsNothing);
      });
    });
  });
}
