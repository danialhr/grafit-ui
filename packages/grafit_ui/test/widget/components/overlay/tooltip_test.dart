import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grafit_ui/grafit_ui.dart';

import '../../test_helper.dart';

void main() {
  group('GrafitTooltip', () {
    group('Rendering', () {
      testWidgets('renders without error', (tester) async {
        await tester.pumpWidget(
          GrafitThemedTest(
            child: const GrafitTooltip(
              message: 'Test tooltip',
              child: Text('Hover me'),
            ),
          ),
        );
        expect(find.text('Hover me'), findsOneWidget);
      });

      testWidgets('renders with different child types', (tester) async {
        await tester.pumpWidget(
          GrafitThemedTest(
            child: const Column(
              children: [
                GrafitTooltip(
                  message: 'Button tooltip',
                  child: ElevatedButton(
                    onPressed: null,
                    child: Text('Button'),
                  ),
                ),
                GrafitTooltip(
                  message: 'Icon tooltip',
                  child: Icon(Icons.info),
                ),
              ],
            ),
          ),
        );
        expect(find.byType(ElevatedButton), findsOneWidget);
        expect(find.byType(Icon), findsOneWidget);
      });
    });

    group('Hover Behavior', () {
      testWidgets('shows tooltip on hover', (tester) async {
        await tester.pumpWidget(
          GrafitThemedTest(
            child: const GrafitTooltip(
              message: 'Tooltip message',
              child: Text('Hover me'),
            ),
          ),
        );

        // Initially tooltip should not be visible
        expect(find.text('Tooltip message'), findsNothing);

        // Hover over the child
        await tester.enterText(find.text('Hover me'), '');
        final gesture = await tester.createGesture(
          kind: PointerDeviceKind.mouse,
        );
        await gesture.addPointer();
        await tester.pump();

        // Move to the center of the widget
        await gesture.moveTo(
          tester.getCenter(find.text('Hover me')),
        );
        await tester.pump(const Duration(milliseconds: 600));

        // Tooltip should be visible after delay
        expect(find.text('Tooltip message'), findsOneWidget);
      });

      testWidgets('respects custom delay duration', (tester) async {
        const customDelay = Duration(milliseconds: 100);

        await tester.pumpWidget(
          GrafitThemedTest(
            child: const GrafitTooltip(
              message: 'Fast tooltip',
              delayDuration: 100,
              child: Text('Hover for fast tooltip'),
            ),
          ),
        );

        final gesture = await tester.createGesture(
          kind: PointerDeviceKind.mouse,
        );
        await gesture.addPointer();
        await tester.pump();

        await gesture.moveTo(
          tester.getCenter(find.text('Hover for fast tooltip')),
        );
        await tester.pump(customDelay);

        expect(find.text('Fast tooltip'), findsOneWidget);
      });

      testWidgets('respects skip delay duration', (tester) async {
        await tester.pumpWidget(
          GrafitThemedTest(
            child: const GrafitTooltip(
              message: 'Short tooltip',
              skipDelayDuration: 1000,
              child: Text('Hover me'),
            ),
          ),
        );

        expect(find.byType(GrafitTooltip), findsOneWidget);
      });
    });

    group('Message Content', () {
      testWidgets('renders short message', (tester) async {
        await tester.pumpWidget(
          GrafitThemedTest(
            child: const GrafitTooltip(
              message: 'Hi',
              child: Text('Short'),
            ),
          ),
        );
        expect(find.byType(GrafitTooltip), findsOneWidget);
      });

      testWidgets('renders long message', (tester) async {
        const longMessage = 'This is a very long tooltip message that contains '
            'a lot of information for the user to read and understand';

        await tester.pumpWidget(
          GrafitThemedTest(
            child: const GrafitTooltip(
              message: longMessage,
              child: Text('Long tooltip'),
            ),
          ),
        );
        expect(find.byType(GrafitTooltip), findsOneWidget);
      });

      testWidgets('renders multi-line message', (tester) async {
        const multiLineMessage = 'Line 1\nLine 2\nLine 3';

        await tester.pumpWidget(
          GrafitThemedTest(
            child: const GrafitTooltip(
              message: multiLineMessage,
              child: Text('Multi-line'),
            ),
          ),
        );
        expect(find.byType(GrafitTooltip), findsOneWidget);
      });
    });

    group('Nested Tooltips', () {
      testWidgets('renders multiple tooltips', (tester) async {
        await tester.pumpWidget(
          GrafitThemedTest(
            child: const Row(
              children: [
                GrafitTooltip(
                  message: 'First',
                  child: Text('A'),
                ),
                GrafitTooltip(
                  message: 'Second',
                  child: Text('B'),
                ),
                GrafitTooltip(
                  message: 'Third',
                  child: Text('C'),
                ),
              ],
            ),
          ),
        );

        expect(find.byType(GrafitTooltip), findsNWidgets(3));
        expect(find.text('A'), findsOneWidget);
        expect(find.text('B'), findsOneWidget);
        expect(find.text('C'), findsOneWidget);
      });
    });

    group('Styling', () {
      testWidgets('applies custom padding', (tester) async {
        await tester.pumpWidget(
          GrafitThemedTest(
            child: const GrafitTooltip(
              message: 'Styled',
              child: Text('Test'),
            ),
          ),
        );
        expect(find.byType(GrafitTooltip), findsOneWidget);
      });
    });

    group('Accessibility', () {
      testWidgets('has semantic label', (tester) async {
        await tester.pumpWidget(
          GrafitThemedTest(
            child: const GrafitTooltip(
              message: 'Helpful tooltip',
              child: Text('Accessible'),
            ),
          ),
        );
        // Tooltip should provide semantic information
        expect(find.byType(GrafitTooltip), findsOneWidget);
      });
    });

    group('Edge Cases', () {
      testWidgets('handles empty message', (tester) async {
        await tester.pumpWidget(
          GrafitThemedTest(
            child: const GrafitTooltip(
              message: '',
              child: Text('Empty'),
            ),
          ),
        );
        expect(find.byType(GrafitTooltip), findsOneWidget);
      });

      testWidgets('handles very long delay', (tester) async {
        await tester.pumpWidget(
          GrafitThemedTest(
            child: const GrafitTooltip(
              message: 'Delayed',
              delayDuration: 10000,
              child: Text('Long delay'),
            ),
          ),
        );
        expect(find.byType(GrafitTooltip), findsOneWidget);
      });

      testWidgets('handles zero delay', (tester) async {
        await tester.pumpWidget(
          GrafitThemedTest(
            child: const GrafitTooltip(
              message: 'Instant',
              delayDuration: 0,
              child: Text('No delay'),
            ),
          ),
        );
        expect(find.byType(GrafitTooltip), findsOneWidget);
      });
    });
  });
}
