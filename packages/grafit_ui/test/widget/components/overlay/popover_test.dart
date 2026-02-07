import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grafit_ui/grafit_ui.dart';

import '../../test_helper.dart';

void main() {
  group('GrafitPopover', () {
    group('Rendering', () {
      testWidgets('renders trigger without error', (tester) async {
        await tester.pumpWidget(
          const GrafitThemedTest(
            child: GrafitPopover(
              trigger: Text('Open Popover'),
              content: Text('Popover content'),
            ),
          ),
        );
        expect(find.text('Open Popover'), findsOneWidget);
      });

      testWidgets('renders with header content', (tester) async {
        await tester.pumpWidget(
          const GrafitThemedTest(
            child: GrafitPopover(
              trigger: Text('Trigger'),
              content: Column(
                children: [
                  GrafitPopoverTitle(title: 'Title'),
                  GrafitPopoverDescription(description: 'Description'),
                ],
              ),
            ),
          ),
        );
        expect(find.text('Trigger'), findsOneWidget);
      });

      testWidgets('renders with custom content widget', (tester) async {
        await tester.pumpWidget(
          const GrafitThemedTest(
            child: GrafitPopover(
              trigger: Text('Click'),
              content: TextField(
                decoration: InputDecoration(hintText: 'Type here'),
              ),
            ),
          ),
        );
        expect(find.text('Click'), findsOneWidget);
      });
    });

    group('Open/Close Behavior', () {
      testWidgets('opens on trigger tap', (tester) async {
        await tester.pumpWidget(
          const GrafitThemedTest(
            child: GrafitPopover(
              trigger: Text('Open'),
              content: Text('Content'),
            ),
          ),
        );

        // Popover should not be visible initially
        expect(find.text('Content'), findsNothing);

        // Tap the trigger
        await tester.tap(find.text('Open'));
        await tester.pump();

        // Content should now be visible
        expect(find.text('Content'), findsOneWidget);
      });

      testWidgets('closes on second trigger tap', (tester) async {
        await tester.pumpWidget(
          const GrafitThemedTest(
            child: GrafitPopover(
              trigger: Text('Toggle'),
              content: Text('Content'),
            ),
          ),
        );

        // Open
        await tester.tap(find.text('Toggle'));
        await tester.pump();
        expect(find.text('Content'), findsOneWidget);

        // Close
        await tester.tap(find.text('Toggle'));
        await tester.pump();
        expect(find.text('Content'), findsNothing);
      });

      testWidgets('animates in when opened', (tester) async {
        await tester.pumpWidget(
          const GrafitThemedTest(
            child: GrafitPopover(
              trigger: Text('Open'),
              content: Text('Animated'),
            ),
          ),
        );

        await tester.tap(find.text('Open'));
        await tester.pump(const Duration(milliseconds: 100));

        // Animation should be in progress
        expect(find.text('Animated'), findsOneWidget);

        // Wait for animation to complete
        await tester.pump(const Duration(milliseconds: 200));
      });
    });

    group('Backdrop Dismissal', () {
      testWidgets('dismisses on backdrop tap when dismissible is true', (tester) async {
        await tester.pumpWidget(
          const GrafitThemedTest(
            child: GrafitPopover(
              trigger: Text('Open'),
              content: Text('Content'),
              dismissible: true,
            ),
          ),
        );

        await tester.tap(find.text('Open'));
        await tester.pump();
        expect(find.text('Content'), findsOneWidget);

        // Tap outside the popover
        await tester.tapAt(const Offset(10, 10));
        await tester.pump();

        expect(find.text('Content'), findsNothing);
      });

      testWidgets('does not dismiss on backdrop tap when dismissible is false', (tester) async {
        await tester.pumpWidget(
          const GrafitThemedTest(
            child: GrafitPopover(
              trigger: Text('Open'),
              content: Text('Content'),
              dismissible: false,
            ),
          ),
        );

        await tester.tap(find.text('Open'));
        await tester.pump();
        expect(find.text('Content'), findsOneWidget);

        // Tap outside
        await tester.tapAt(const Offset(10, 10));
        await tester.pump();

        // Content should still be visible
        expect(find.text('Content'), findsOneWidget);
      });
    });

    group('Alignment', () {
      testWidgets('positions at top alignment', (tester) async {
        await tester.pumpWidget(
          const GrafitThemedTest(
            child: GrafitPopover(
              trigger: Text('Top'),
              alignment: GrafitPopoverAlignment.top,
              content: Text('Top content'),
            ),
          ),
        );

        await tester.tap(find.text('Top'));
        await tester.pump();

        expect(find.text('Top content'), findsOneWidget);
      });

      testWidgets('positions at bottom alignment', (tester) async {
        await tester.pumpWidget(
          const GrafitThemedTest(
            child: GrafitPopover(
              trigger: Text('Bottom'),
              alignment: GrafitPopoverAlignment.bottom,
              content: Text('Bottom content'),
            ),
          ),
        );

        await tester.tap(find.text('Bottom'));
        await tester.pump();

        expect(find.text('Bottom content'), findsOneWidget);
      });

      testWidgets('positions at left alignment', (tester) async {
        await tester.pumpWidget(
          const GrafitThemedTest(
            child: GrafitPopover(
              trigger: Text('Left'),
              alignment: GrafitPopoverAlignment.left,
              content: Text('Left content'),
            ),
          ),
        );

        await tester.tap(find.text('Left'));
        await tester.pump();

        expect(find.text('Left content'), findsOneWidget);
      });

      testWidgets('positions at right alignment', (tester) async {
        await tester.pumpWidget(
          const GrafitThemedTest(
            child: GrafitPopover(
              trigger: Text('Right'),
              alignment: GrafitPopoverAlignment.right,
              content: Text('Right content'),
            ),
          ),
        );

        await tester.tap(find.text('Right'));
        await tester.pump();

        expect(find.text('Right content'), findsOneWidget);
      });

      testWidgets('positions at topLeft alignment', (tester) async {
        await tester.pumpWidget(
          const GrafitThemedTest(
            child: GrafitPopover(
              trigger: Text('TopLeft'),
              alignment: GrafitPopoverAlignment.topLeft,
              content: Text('Content'),
            ),
          ),
        );

        await tester.tap(find.text('TopLeft'));
        await tester.pump();

        expect(find.text('Content'), findsOneWidget);
      });

      testWidgets('positions at topRight alignment', (tester) async {
        await tester.pumpWidget(
          const GrafitThemedTest(
            child: GrafitPopover(
              trigger: Text('TopRight'),
              alignment: GrafitPopoverAlignment.topRight,
              content: Text('Content'),
            ),
          ),
        );

        await tester.tap(find.text('TopRight'));
        await tester.pump();

        expect(find.text('Content'), findsOneWidget);
      });

      testWidgets('positions at bottomLeft alignment', (tester) async {
        await tester.pumpWidget(
          const GrafitThemedTest(
            child: GrafitPopover(
              trigger: Text('BottomLeft'),
              alignment: GrafitPopoverAlignment.bottomLeft,
              content: Text('Content'),
            ),
          ),
        );

        await tester.tap(find.text('BottomLeft'));
        await tester.pump();

        expect(find.text('Content'), findsOneWidget);
      });

      testWidgets('positions at bottomRight alignment', (tester) async {
        await tester.pumpWidget(
          const GrafitThemedTest(
            child: GrafitPopover(
              trigger: Text('BottomRight'),
              alignment: GrafitPopoverAlignment.bottomRight,
              content: Text('Content'),
            ),
          ),
        );

        await tester.tap(find.text('BottomRight'));
        await tester.pump();

        expect(find.text('Content'), findsOneWidget);
      });
    });

    group('Custom Offset', () {
      testWidgets('applies custom offset', (tester) async {
        await tester.pumpWidget(
          const GrafitThemedTest(
            child: GrafitPopover(
              trigger: Text('Offset'),
              offset: 16,
              content: Text('Offset content'),
            ),
          ),
        );

        await tester.tap(find.text('Offset'));
        await tester.pump();

        expect(find.text('Offset content'), findsOneWidget);
      });

      testWidgets('applies zero offset', (tester) async {
        await tester.pumpWidget(
          const GrafitThemedTest(
            child: GrafitPopover(
              trigger: Text('No Offset'),
              offset: 0,
              content: Text('Content'),
            ),
          ),
        );

        await tester.tap(find.text('No Offset'));
        await tester.pump();

        expect(find.text('Content'), findsOneWidget);
      });
    });

    group('Popover Components', () {
      testWidgets('renders PopoverHeader', (tester) async {
        await tester.pumpWidget(
          const GrafitThemedTest(
            child: GrafitPopover(
              trigger: Text('Open'),
              content: GrafitPopoverHeader(
                title: 'Header Title',
                description: 'Header Description',
              ),
            ),
          ),
        );

        await tester.tap(find.text('Open'));
        await tester.pump();

        expect(find.text('Header Title'), findsOneWidget);
        expect(find.text('Header Description'), findsOneWidget);
      });

      testWidgets('renders PopoverTitle', (tester) async {
        await tester.pumpWidget(
          const GrafitThemedTest(
            child: GrafitPopover(
              trigger: Text('Open'),
              content: GrafitPopoverTitle(title: 'Title Only'),
            ),
          ),
        );

        await tester.tap(find.text('Open'));
        await tester.pump();

        expect(find.text('Title Only'), findsOneWidget);
      });

      testWidgets('renders PopoverDescription', (tester) async {
        await tester.pumpWidget(
          const GrafitThemedTest(
            child: GrafitPopover(
              trigger: Text('Open'),
              content: GrafitPopoverDescription(description: 'Description Only'),
            ),
          ),
        );

        await tester.tap(find.text('Open'));
        await tester.pump();

        expect(find.text('Description Only'), findsOneWidget);
      });
    });

    group('Edge Cases', () {
      testWidgets('handles empty content', (tester) async {
        await tester.pumpWidget(
          const GrafitThemedTest(
            child: GrafitPopover(
              trigger: Text('Empty'),
              content: SizedBox.shrink(),
            ),
          ),
        );

        await tester.tap(find.text('Empty'));
        await tester.pump();

        // Should open without error
        expect(find.byType(GrafitPopover), findsOneWidget);
      });

      testWidgets('handles multiple rapid taps', (tester) async {
        await tester.pumpWidget(
          const GrafitThemedTest(
            child: GrafitPopover(
              trigger: Text('Rapid'),
              content: Text('Content'),
            ),
          ),
        );

        // Tap multiple times rapidly
        await tester.tap(find.text('Rapid'));
        await tester.pump(const Duration(milliseconds: 50));
        await tester.tap(find.text('Rapid'));
        await tester.pump(const Duration(milliseconds: 50));
        await tester.tap(find.text('Rapid'));
        await tester.pump();

        // Should handle gracefully
        expect(find.byType(GrafitPopover), findsOneWidget);
      });
    });

    group('Rich Content', () {
      testWidgets('renders complex content with multiple widgets', (tester) async {
        await tester.pumpWidget(
          const GrafitThemedTest(
            child: GrafitPopover(
              trigger: Text('Rich'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Line 1'),
                  TextField(),
                  ElevatedButton(
                    onPressed: null,
                    child: Text('Button'),
                  ),
                ],
              ),
            ),
          ),
        );

        await tester.tap(find.text('Rich'));
        await tester.pump();

        expect(find.text('Line 1'), findsOneWidget);
        expect(find.byType(TextField), findsOneWidget);
        expect(find.text('Button'), findsOneWidget);
      });
    });
  });
}
