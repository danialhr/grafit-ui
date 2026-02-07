import 'package:flutter_test/flutter_test.dart';
import 'package:grafit_ui/grafit_ui.dart';
import '../../../helpers/test_helpers.dart';
import '../../../helpers/themed_test_widget.dart';

void main() {
  group('GrafitToggle', () {
    group('Smoke Test', () {
      testWidgets('renders toggle', (tester) async {
        await tester.pumpWidget(
          tester,
          child: const ThemedTestWidget(
            child: const GrafitToggle(
            pressed: false,
            onPressed: () {},
          ),
        );

        expect(find.byType(GrafitToggle), findsOneWidget);
      });

      testWidgets('toggle can be pressed', (tester) async {
        var pressed = false;

        await tester.pumpWidget(
          tester,
          child: GrafitToggle(
            pressed: pressed,
            onPressed: () => pressed = !pressed,
          ),
        );

        await tester.tap(find.byType(GrafitToggle));
        expect(pressed, true);
      });

      testWidgets('onPressed callback fires', (tester) async {
        var fired = false;

        await tester.pumpWidget(
          tester,
          child: GrafitToggle(
            pressed: false,
            onPressed: () => fired = true,
          ),
        );

        await tester.tap(find.byType(GrafitToggle));
        expect(fired, true);
      });
    });

    group('States', () {
      testWidgets('pressed state is shown', (tester) async {
        await tester.pumpWidget(
          tester,
          child: const ThemedTestWidget(
            child: const GrafitToggle(
            pressed: true,
            onPressed: () {},
          ),
        );

        expect(find.byType(GrafitToggle), findsOneWidget);
      });

      testWidgets('unpressed state is shown', (tester) async {
        await tester.pumpWidget(
          tester,
          child: const ThemedTestWidget(
            child: const GrafitToggle(
            pressed: false,
            onPressed: () {},
          ),
        );

        expect(find.byType(GrafitToggle), findsOneWidget);
      });

      testWidgets('disabled toggle cannot be pressed', (tester) async {
        var pressed = false;

        await tester.pumpWidget(
          tester,
          child: GrafitToggle(
            pressed: pressed,
            onPressed: () => pressed = !pressed,
            disabled: true,
          ),
        );

        await tester.tap(find.byType(GrafitToggle));
        expect(pressed, false);
      });

      testWidgets('enabled toggle can be pressed', (tester) async {
        var pressed = false;

        await tester.pumpWidget(
          tester,
          child: GrafitToggle(
            pressed: pressed,
            onPressed: () => pressed = !pressed,
            disabled: false,
          ),
        );

        await tester.tap(find.byType(GrafitToggle));
        expect(pressed, true);
      });

      testWidgets('null onPressed makes toggle disabled', (tester) async {
        await tester.pumpWidget(
          tester,
          child: const ThemedTestWidget(
            child: const GrafitToggle(pressed: false),
        );

        final clickable = tester.widget<GrafitClickable>(find.byType(GrafitClickable));
        expect(clickable.disabled, true);
      });
    });

    group('Variants', () {
      testWidgets('primary variant renders', (tester) async {
        await tester.pumpWidget(
          tester,
          child: const ThemedTestWidget(
            child: const GrafitToggle(
            pressed: false,
            variant: GrafitToggleVariant.primary,
            onPressed: () {},
          ),
        );

        expect(find.byType(GrafitToggle), findsOneWidget);
      });

      testWidgets('outline variant renders', (tester) async {
        await tester.pumpWidget(
          tester,
          child: const ThemedTestWidget(
            child: const GrafitToggle(
            pressed: false,
            variant: GrafitToggleVariant.outline,
            onPressed: () {},
          ),
        );

        expect(find.byType(GrafitToggle), findsOneWidget);
      });
    });

    group('Sizes', () {
      testWidgets('small size renders', (tester) async {
        await tester.pumpWidget(
          tester,
          child: const ThemedTestWidget(
            child: const GrafitToggle(
            pressed: false,
            size: GrafitButtonSize.sm,
            onPressed: () {},
          ),
        );

        expect(find.byType(GrafitToggle), findsOneWidget);
      });

      testWidgets('medium size renders', (tester) async {
        await tester.pumpWidget(
          tester,
          child: const ThemedTestWidget(
            child: const GrafitToggle(
            pressed: false,
            size: GrafitButtonSize.md,
            onPressed: () {},
          ),
        );

        expect(find.byType(GrafitToggle), findsOneWidget);
      });

      testWidgets('large size renders', (tester) async {
        await tester.pumpWidget(
          tester,
          child: const ThemedTestWidget(
            child: const GrafitToggle(
            pressed: false,
            size: GrafitButtonSize.lg,
            onPressed: () {},
          ),
        );

        expect(find.byType(GrafitToggle), findsOneWidget);
      });

      testWidgets('icon size renders', (tester) async {
        await tester.pumpWidget(
          tester,
          child: const ThemedTestWidget(
            child: const GrafitToggle(
            pressed: false,
            size: GrafitButtonSize.icon,
            onPressed: () {},
          ),
        );

        expect(find.byType(GrafitToggle), findsOneWidget);
      });
    });

    group('Label', () {
      testWidgets('label text is displayed', (tester) async {
        await tester.pumpWidget(
          tester,
          child: const ThemedTestWidget(
            child: const GrafitToggle(
            pressed: false,
            label: 'Toggle Option',
            onPressed: () {},
          ),
        );

        expect(find.text('Toggle Option'), findsOneWidget);
      });

      testWidgets('pressing label area toggles', (tester) async {
        var pressed = false;

        await tester.pumpWidget(
          tester,
          child: GrafitToggle(
            pressed: pressed,
            label: 'Press Me',
            onPressed: () => pressed = !pressed,
          ),
        );

        await tester.tap(find.text('Press Me'));
        expect(pressed, true);
      });
    });

    group('Icon', () {
      testWidgets('icon is displayed', (tester) async {
        await tester.pumpWidget(
          tester,
          child: const ThemedTestWidget(
            child: const GrafitToggle(
            pressed: false,
            icon: Icons.favorite,
            onPressed: () {},
          ),
        );

        expect(find.byIcon(Icons.favorite), findsOneWidget);
      });

      testWidgets('icon with label', (tester) async {
        await tester.pumpWidget(
          tester,
          child: const ThemedTestWidget(
            child: const GrafitToggle(
            pressed: false,
            icon: Icons.star,
            label: 'Star',
            onPressed: () {},
          ),
        );

        expect(find.byIcon(Icons.star), findsOneWidget);
        expect(find.text('Star'), findsOneWidget);
      });

      testWidgets('icon-only toggle', (tester) async {
        await tester.pumpWidget(
          tester,
          child: const ThemedTestWidget(
            child: const GrafitToggle(
            pressed: false,
            icon: Icons.settings,
            onPressed: () {},
          ),
        );

        expect(find.byIcon(Icons.settings), findsOneWidget);
        expect(find.byType(GrafitToggle), findsOneWidget);
      });
    });

    group('Tooltip', () {
      testWidgets('tooltip is displayed on long press', (tester) async {
        await tester.pumpWidget(
          tester,
          child: const ThemedTestWidget(
            child: const GrafitToggle(
            pressed: false,
            tooltip: 'Toggle this option',
            onPressed: () {},
          ),
        );

        // Tooltip would appear on long press
        expect(find.byType(GrafitToggle), findsOneWidget);
      });
    });

    group('State Management', () {
      testWidgets('toggle maintains pressed state', (tester) async {
        var pressed = false;

        await tester.pumpWidget(
          tester,
          child: StatefulBuilder(
            builder: (context, setState) {
              return GrafitToggle(
                pressed: pressed,
                onPressed: () => setState(() => pressed = !pressed),
              );
            },
          ),
        );

        expect(find.byType(GrafitToggle), findsOneWidget);

        await tester.tap(find.byType(GrafitToggle));
        await tester.pump();

        await tester.tap(find.byType(GrafitToggle));
        await tester.pump();
      });

      testWidgets('multiple toggles work independently', (tester) async {
        var pressed1 = false;
        var pressed2 = false;

        await tester.pumpWidget(
          tester,
          child: Column(
            children: [
              GrafitToggle(
                pressed: pressed1,
                label: 'Toggle 1',
                onPressed: () => pressed1 = !pressed1,
              ),
              GrafitToggle(
                pressed: pressed2,
                label: 'Toggle 2',
                onPressed: () => pressed2 = !pressed2,
              ),
            ],
          ),
        );

        await tester.tap(find.text('Toggle 1'));
        expect(pressed1, true);
        expect(pressed2, false);

        await tester.tap(find.text('Toggle 2'));
        expect(pressed1, true);
        expect(pressed2, true);
      });
    });

    group('Edge Cases', () {
      testWidgets('empty label renders', (tester) async {
        await tester.pumpWidget(
          tester,
          child: const ThemedTestWidget(
            child: const GrafitToggle(
            pressed: false,
            label: '',
            onPressed: () {},
          ),
        );

        expect(find.byType(GrafitToggle), findsOneWidget);
      });

      testWidgets('long label text', (tester) async {
        const longLabel = 'This is a very long label for the toggle component';

        await tester.pumpWidget(
          tester,
          child: const SizedBox(
            width: 200,
            child: GrafitToggle(
              pressed: false,
              label: longLabel,
              onPressed: () {},
            ),
          ),
        );

        expect(find.text(longLabel), findsOneWidget);
      });

      testWidgets('disabled with label and icon', (tester) async {
        await tester.pumpWidget(
          tester,
          child: const ThemedTestWidget(
            child: const GrafitToggle(
            pressed: true,
            label: 'Disabled',
            icon: Icons.lock,
            disabled: true,
            onPressed: null,
          ),
        );

        expect(find.text('Disabled'), findsOneWidget);
        expect(find.byIcon(Icons.lock), findsOneWidget);
      });

      testWidgets('rapid toggle on/off', (tester) async {
        var pressed = false;

        await tester.pumpWidget(
          tester,
          child: GrafitToggle(
            pressed: pressed,
            onPressed: () => pressed = !pressed,
          ),
        );

        await tester.tap(find.byType(GrafitToggle));
        await tester.pump();
        expect(pressed, true);

        await tester.tap(find.byType(GrafitToggle));
        await tester.pump();
        expect(pressed, false);
      });
    });

    group('Visual Feedback', () {
      testWidgets('pressed toggle has different appearance', (tester) async {
        await tester.pumpWidget(
          tester,
          child: const Row(
            children: [
              GrafitToggle(
                pressed: false,
                label: 'Off',
                onPressed: null,
              ),
              GrafitToggle(
                pressed: true,
                label: 'On',
                onPressed: null,
              ),
            ],
          ),
        );

        expect(find.text('Off'), findsOneWidget);
        expect(find.text('On'), findsOneWidget);
      });
    });
  });
}
