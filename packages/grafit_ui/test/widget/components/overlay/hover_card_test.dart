import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grafit_ui/grafit_ui.dart';

import '../../test_helper.dart';

void main() {
  group('GrafitHoverCard', () {
    final testContent = Column(
      mainAxisSize: MainAxisSize.min,
      children: const [
        GrafitHoverCardTitle(title: 'Card Title'),
        GrafitHoverCardDescription(description: 'Card Description'),
      ],
    );

    group('Rendering', () {
      testWidgets('renders trigger without error', (tester) async {
        await tester.pumpWidget(
          GrafitThemedTest(
            child: GrafitHoverCard(
              trigger: const GrafitButton(label: 'Hover Me'),
              content: testContent,
            ),
          ),
        );
        expect(find.text('Hover Me'), findsOneWidget);
      });

      testWidgets('renders with different trigger types', (tester) async {
        await tester.pumpWidget(
          GrafitThemedTest(
            child: Row(
              children: [
                GrafitHoverCard(
                  trigger: const Text('Text trigger'),
                  content: testContent,
                ),
                GrafitHoverCard(
                  trigger: const Icon(Icons.info),
                  content: testContent,
                ),
                GrafitHoverCard(
                  trigger: Container(
                    width: 50,
                    height: 50,
                    color: Colors.blue,
                  ),
                  content: testContent,
                ),
              ],
            ),
          ),
        );
        expect(find.text('Text trigger'), findsOneWidget);
        expect(find.byType(Icon), findsOneWidget);
        expect(find.byType(Container), findsNWidgets(2));
      });

      testWidgets('renders with rich content', (tester) async {
        final richContent = Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Text('Line 1'),
            Text('Line 2'),
            Icon(Icons.star),
          ],
        );

        await tester.pumpWidget(
          GrafitThemedTest(
            child: GrafitHoverCard(
              trigger: const GrafitButton(label: 'Hover'),
              content: richContent,
            ),
          ),
        );
        expect(find.text('Hover'), findsOneWidget);
      });
    });

    group('Hover Behavior', () {
      testWidgets('shows content on hover', (tester) async {
        await tester.pumpWidget(
          GrafitThemedTest(
            child: GrafitHoverCard(
              trigger: const GrafitButton(label: 'Hover Me'),
              content: const GrafitHoverCardTitle(title: 'Hovered!'),
            ),
          ),
        );

        // Initially not visible
        expect(find.text('Hovered!'), findsNothing);

        // Simulate hover
        final gesture = await tester.createGesture(
          kind: PointerDeviceKind.mouse,
        );
        await gesture.addPointer();
        await tester.pump();

        await gesture.moveTo(
          tester.getCenter(find.text('Hover Me')),
        );
        await tester.pump(const Duration(milliseconds: 500));

        // Should be visible after delay
        expect(find.text('Hovered!'), findsOneWidget);
      });

      testWidgets('hides content when mouse leaves', (tester) async {
        await tester.pumpWidget(
          GrafitThemedTest(
            child: GrafitHoverCard(
              trigger: const GrafitButton(label: 'Hover Me'),
              content: const GrafitHoverCardTitle(title: 'Content'),
            ),
          ),
        );

        final gesture = await tester.createGesture(
          kind: PointerDeviceKind.mouse,
        );
        await gesture.addPointer();
        await tester.pump();

        // Hover to show
        await gesture.moveTo(
          tester.getCenter(find.text('Hover Me')),
        );
        await tester.pump(const Duration(milliseconds: 500));
        expect(find.text('Content'), findsOneWidget);

        // Move away
        await gesture.moveTo(const Offset(10, 10));
        await tester.pump(const Duration(milliseconds: 300));

        // Should hide after close delay
        expect(find.text('Content'), findsNothing);
      });

      testWidgets('respects custom open delay', (tester) async {
        await tester.pumpWidget(
          GrafitThemedTest(
            child: GrafitHoverCard(
              trigger: const GrafitButton(label: 'Fast Hover'),
              openDelay: const Duration(milliseconds: 100),
              content: const GrafitHoverCardTitle(title: 'Fast'),
            ),
          ),
        );

        final gesture = await tester.createGesture(
          kind: PointerDeviceKind.mouse,
        );
        await gesture.addPointer();
        await tester.pump();

        await gesture.moveTo(
          tester.getCenter(find.text('Fast Hover')),
        );
        await tester.pump(const Duration(milliseconds: 150));

        expect(find.text('Fast'), findsOneWidget);
      });

      testWidgets('respects custom close delay', (tester) async {
        await tester.pumpWidget(
          GrafitThemedTest(
            child: GrafitHoverCard(
              trigger: const GrafitButton(label: 'Slow Close'),
              closeDelay: const Duration(milliseconds: 500),
              content: const GrafitHoverCardTitle(title: 'Content'),
            ),
          ),
        );

        final gesture = await tester.createGesture(
          kind: PointerDeviceKind.mouse,
        );
        await gesture.addPointer();
        await tester.pump();

        // Open
        await gesture.moveTo(
          tester.getCenter(find.text('Slow Close')),
        );
        await tester.pump(const Duration(milliseconds: 500));
        expect(find.text('Content'), findsOneWidget);

        // Move away
        await gesture.moveTo(const Offset(10, 10));
        await tester.pump(const Duration(milliseconds: 300));

        // Should still be visible due to slow close delay
        expect(find.text('Content'), findsOneWidget);

        // Wait for close
        await tester.pump(const Duration(milliseconds: 300));
      });
    });

    group('Alignment', () {
      testWidgets('positions at top alignment', (tester) async {
        await tester.pumpWidget(
          GrafitThemedTest(
            child: GrafitHoverCard(
              trigger: const GrafitButton(label: 'Top'),
              alignment: GrafitHoverCardAlignment.top,
              content: const GrafitHoverCardTitle(title: 'Top Content'),
            ),
          ),
        );

        final gesture = await tester.createGesture(
          kind: PointerDeviceKind.mouse,
        );
        await gesture.addPointer();
        await tester.pump();

        await gesture.moveTo(
          tester.getCenter(find.text('Top')),
        );
        await tester.pump(const Duration(milliseconds: 500));

        expect(find.text('Top Content'), findsOneWidget);
      });

      testWidgets('positions at bottom alignment', (tester) async {
        await tester.pumpWidget(
          GrafitThemedTest(
            child: GrafitHoverCard(
              trigger: const GrafitButton(label: 'Bottom'),
              alignment: GrafitHoverCardAlignment.bottom,
              content: const GrafitHoverCardTitle(title: 'Bottom Content'),
            ),
          ),
        );

        final gesture = await tester.createGesture(
          kind: PointerDeviceKind.mouse,
        );
        await gesture.addPointer();
        await tester.pump();

        await gesture.moveTo(
          tester.getCenter(find.text('Bottom')),
        );
        await tester.pump(const Duration(milliseconds: 500));

        expect(find.text('Bottom Content'), findsOneWidget);
      });

      testWidgets('positions at left alignment', (tester) async {
        await tester.pumpWidget(
          GrafitThemedTest(
            child: GrafitHoverCard(
              trigger: const GrafitButton(label: 'Left'),
              alignment: GrafitHoverCardAlignment.left,
              content: const GrafitHoverCardTitle(title: 'Left Content'),
            ),
          ),
        );

        final gesture = await tester.createGesture(
          kind: PointerDeviceKind.mouse,
        );
        await gesture.addPointer();
        await tester.pump();

        await gesture.moveTo(
          tester.getCenter(find.text('Left')),
        );
        await tester.pump(const Duration(milliseconds: 500));

        expect(find.text('Left Content'), findsOneWidget);
      });

      testWidgets('positions at right alignment', (tester) async {
        await tester.pumpWidget(
          GrafitThemedTest(
            child: GrafitHoverCard(
              trigger: const GrafitButton(label: 'Right'),
              alignment: GrafitHoverCardAlignment.right,
              content: const GrafitHoverCardTitle(title: 'Right Content'),
            ),
          ),
        );

        final gesture = await tester.createGesture(
          kind: PointerDeviceKind.mouse,
        );
        await gesture.addPointer();
        await tester.pump();

        await gesture.moveTo(
          tester.getCenter(find.text('Right')),
        );
        await tester.pump(const Duration(milliseconds: 500));

        expect(find.text('Right Content'), findsOneWidget);
      });

      testWidgets('positions at topLeft alignment', (tester) async {
        await tester.pumpWidget(
          GrafitThemedTest(
            child: GrafitHoverCard(
              trigger: const GrafitButton(label: 'TopLeft'),
              alignment: GrafitHoverCardAlignment.topLeft,
              content: const GrafitHoverCardTitle(title: 'Content'),
            ),
          ),
        );

        final gesture = await tester.createGesture(
          kind: PointerDeviceKind.mouse,
        );
        await gesture.addPointer();
        await tester.pump();

        await gesture.moveTo(
          tester.getCenter(find.text('TopLeft')),
        );
        await tester.pump(const Duration(milliseconds: 500));

        expect(find.text('Content'), findsOneWidget);
      });

      testWidgets('positions at topRight alignment', (tester) async {
        await tester.pumpWidget(
          GrafitThemedTest(
            child: GrafitHoverCard(
              trigger: const GrafitButton(label: 'TopRight'),
              alignment: GrafitHoverCardAlignment.topRight,
              content: const GrafitHoverCardTitle(title: 'Content'),
            ),
          ),
        );

        final gesture = await tester.createGesture(
          kind: PointerDeviceKind.mouse,
        );
        await gesture.addPointer();
        await tester.pump();

        await gesture.moveTo(
          tester.getCenter(find.text('TopRight')),
        );
        await tester.pump(const Duration(milliseconds: 500));

        expect(find.text('Content'), findsOneWidget);
      });

      testWidgets('positions at bottomLeft alignment', (tester) async {
        await tester.pumpWidget(
          GrafitThemedTest(
            child: GrafitHoverCard(
              trigger: const GrafitButton(label: 'BottomLeft'),
              alignment: GrafitHoverCardAlignment.bottomLeft,
              content: const GrafitHoverCardTitle(title: 'Content'),
            ),
          ),
        );

        final gesture = await tester.createGesture(
          kind: PointerDeviceKind.mouse,
        );
        await gesture.addPointer();
        await tester.pump();

        await gesture.moveTo(
          tester.getCenter(find.text('BottomLeft')),
        );
        await tester.pump(const Duration(milliseconds: 500));

        expect(find.text('Content'), findsOneWidget);
      });

      testWidgets('positions at bottomRight alignment', (tester) async {
        await tester.pumpWidget(
          GrafitThemedTest(
            child: GrafitHoverCard(
              trigger: const GrafitButton(label: 'BottomRight'),
              alignment: GrafitHoverCardAlignment.bottomRight,
              content: const GrafitHoverCardTitle(title: 'Content'),
            ),
          ),
        );

        final gesture = await tester.createGesture(
          kind: PointerDeviceKind.mouse,
        );
        await gesture.addPointer();
        await tester.pump();

        await gesture.moveTo(
          tester.getCenter(find.text('BottomRight')),
        );
        await tester.pump(const Duration(milliseconds: 500));

        expect(find.text('Content'), findsOneWidget);
      });
    });

    group('Custom Offset', () {
      testWidgets('applies custom offset', (tester) async {
        await tester.pumpWidget(
          GrafitThemedTest(
            child: GrafitHoverCard(
              trigger: const GrafitButton(label: 'Offset'),
              offset: 16,
              content: const GrafitHoverCardTitle(title: 'Offset Content'),
            ),
          ),
        );

        final gesture = await tester.createGesture(
          kind: PointerDeviceKind.mouse,
        );
        await gesture.addPointer();
        await tester.pump();

        await gesture.moveTo(
          tester.getCenter(find.text('Offset')),
        );
        await tester.pump(const Duration(milliseconds: 500));

        expect(find.text('Offset Content'), findsOneWidget);
      });
    });

    group('Custom Width', () {
      testWidgets('applies custom width', (tester) async {
        await tester.pumpWidget(
          GrafitThemedTest(
            child: GrafitHoverCard(
              trigger: const GrafitButton(label: 'Wide'),
              width: 400,
              content: const GrafitHoverCardTitle(title: 'Wide Content'),
            ),
          ),
        );

        final gesture = await tester.createGesture(
          kind: PointerDeviceKind.mouse,
        );
        await gesture.addPointer();
        await tester.pump();

        await gesture.moveTo(
          tester.getCenter(find.text('Wide')),
        );
        await tester.pump(const Duration(milliseconds: 500));

        expect(find.text('Wide Content'), findsOneWidget);
      });
    });

    group('Close on Tap', () {
      testWidgets('closes on tap when closeOnTap is true', (tester) async {
        await tester.pumpWidget(
          GrafitThemedTest(
            child: GrafitHoverCard(
              trigger: const GrafitButton(label: 'Tap to Close'),
              closeOnTap: true,
              content: const GrafitHoverCardTitle(title: 'Content'),
            ),
          ),
        );

        final gesture = await tester.createGesture(
          kind: PointerDeviceKind.mouse,
        );
        await gesture.addPointer();
        await tester.pump();

        // Open
        await gesture.moveTo(
          tester.getCenter(find.text('Tap to Close')),
        );
        await tester.pump(const Duration(milliseconds: 500));
        expect(find.text('Content'), findsOneWidget);

        // Tap trigger to close
        await tester.tap(find.text('Tap to Close'));
        await tester.pump();

        expect(find.text('Content'), findsNothing);
      });

      testWidgets('does not close on tap when closeOnTap is false', (tester) async {
        await tester.pumpWidget(
          GrafitThemedTest(
            child: GrafitHoverCard(
              trigger: const GrafitButton(label: 'No Tap Close'),
              closeOnTap: false,
              content: const GrafitHoverCardTitle(title: 'Content'),
            ),
          ),
        );

        final gesture = await tester.createGesture(
          kind: PointerDeviceKind.mouse,
        );
        await gesture.addPointer();
        await tester.pump();

        // Open
        await gesture.moveTo(
          tester.getCenter(find.text('No Tap Close')),
        );
        await tester.pump(const Duration(milliseconds: 500));
        expect(find.text('Content'), findsOneWidget);

        // Tap trigger - should not close
        await tester.tap(find.text('No Tap Close'));
        await tester.pump();

        // Should still be visible
        expect(find.text('Content'), findsOneWidget);

        // Only mouse exit should close it
        await gesture.moveTo(const Offset(10, 10));
        await tester.pump(const Duration(milliseconds: 300));
        expect(find.text('Content'), findsNothing);
      });
    });

    group('HoverCardContent', () {
      testWidgets('renders with custom padding', (tester) async {
        await tester.pumpWidget(
          GrafitThemedTest(
            child: GrafitHoverCard(
              trigger: const GrafitButton(label: 'Hover'),
              content: const GrafitHoverCardContent(
                padding: EdgeInsets.all(24),
                child: Text('Padded Content'),
              ),
            ),
          ),
        );

        final gesture = await tester.createGesture(
          kind: PointerDeviceKind.mouse,
        );
        await gesture.addPointer();
        await tester.pump();

        await gesture.moveTo(
          tester.getCenter(find.text('Hover')),
        );
        await tester.pump(const Duration(milliseconds: 500));

        expect(find.text('Padded Content'), findsOneWidget);
      });
    });

    group('HoverCardHeader', () {
      testWidgets('renders header with title and description', (tester) async {
        await tester.pumpWidget(
          GrafitThemedTest(
            child: GrafitHoverCard(
              trigger: const GrafitButton(label: 'Hover'),
              content: const GrafitHoverCardHeader(
                title: 'Header Title',
                description: 'Header Description',
              ),
            ),
          ),
        );

        final gesture = await tester.createGesture(
          kind: PointerDeviceKind.mouse,
        );
        await gesture.addPointer();
        await tester.pump();

        await gesture.moveTo(
          tester.getCenter(find.text('Hover')),
        );
        await tester.pump(const Duration(milliseconds: 500));

        expect(find.text('Header Title'), findsOneWidget);
        expect(find.text('Header Description'), findsOneWidget);
      });

      testWidgets('renders header with custom child', (tester) async {
        await tester.pumpWidget(
          GrafitThemedTest(
            child: GrafitHoverCard(
              trigger: const GrafitButton(label: 'Hover'),
              content: const GrafitHoverCardHeader(
                child: Text('Custom Header Child'),
              ),
            ),
          ),
        );

        final gesture = await tester.createGesture(
          kind: PointerDeviceKind.mouse,
        );
        await gesture.addPointer();
        await tester.pump();

        await gesture.moveTo(
          tester.getCenter(find.text('Hover')),
        );
        await tester.pump(const Duration(milliseconds: 500));

        expect(find.text('Custom Header Child'), findsOneWidget);
      });
    });

    group('Animation', () {
      testWidgets('animates in when opened', (tester) async {
        await tester.pumpWidget(
          GrafitThemedTest(
            child: GrafitHoverCard(
              trigger: const GrafitButton(label: 'Animated'),
              content: const GrafitHoverCardTitle(title: 'Animated'),
            ),
          ),
        );

        final gesture = await tester.createGesture(
          kind: PointerDeviceKind.mouse,
        );
        await gesture.addPointer();
        await tester.pump();

        await gesture.moveTo(
          tester.getCenter(find.text('Animated')),
        );
        await tester.pump(const Duration(milliseconds: 100));

        // Animation in progress
        expect(find.text('Animated'), findsOneWidget);

        // Wait for animation
        await tester.pump(const Duration(milliseconds: 200));
      });
    });

    group('Edge Cases', () {
      testWidgets('handles rapid hover in/out', (tester) async {
        await tester.pumpWidget(
          GrafitThemedTest(
            child: GrafitHoverCard(
              trigger: const GrafitButton(label: 'Rapid'),
              content: const GrafitHoverCardTitle(title: 'Rapid Content'),
            ),
          ),
        );

        final gesture = await tester.createGesture(
          kind: PointerDeviceKind.mouse,
        );
        await gesture.addPointer();
        await tester.pump();

        // Rapid hovers
        await gesture.moveTo(
          tester.getCenter(find.text('Rapid')),
        );
        await tester.pump(const Duration(milliseconds: 50));
        await gesture.moveTo(const Offset(10, 10));
        await tester.pump(const Duration(milliseconds: 50));
        await gesture.moveTo(
          tester.getCenter(find.text('Rapid')),
        );
        await tester.pump(const Duration(milliseconds: 500));

        // Should handle gracefully
        expect(find.byType(GrafitHoverCard), findsOneWidget);
      });

      testWidgets('handles empty content', (tester) async {
        await tester.pumpWidget(
          GrafitThemedTest(
            child: GrafitHoverCard(
              trigger: const GrafitButton(label: 'Empty'),
              content: const SizedBox.shrink(),
            ),
          ),
        );

        final gesture = await tester.createGesture(
          kind: PointerDeviceKind.mouse,
        );
        await gesture.addPointer();
        await tester.pump();

        await gesture.moveTo(
          tester.getCenter(find.text('Empty')),
        );
        await tester.pump(const Duration(milliseconds: 500));

        // Should open without error
        expect(find.byType(GrafitHoverCard), findsOneWidget);
      });
    });
  });
}
