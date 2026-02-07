import 'package:flutter_test/flutter_test.dart';
import 'package:grafit_ui/grafit_ui.dart';
import '../../../helpers/test_helpers.dart';
import '../../../helpers/themed_test_widget.dart';

void main() {
  group('GrafitSwitch', () {
    group('Smoke Test', () {
      testWidgets('renders switch', (tester) async {
        await tester.pumpWidget(
          tester,
          child: const ThemedTestWidget(
            child: const GrafitSwitch(value: false),
        );

        expect(find.byType(GrafitSwitch), findsOneWidget);
      });

      testWidgets('switch can be toggled on', (tester) async {
        bool value = false;

        await tester.pumpWidget(
          tester,
          child: GrafitSwitch(
            value: value,
            onChanged: (v) => value = v,
          ),
        );

        await tester.tap(find.byType(GrafitSwitch));
        expect(value, true);
      });

      testWidgets('switch can be toggled off', (tester) async {
        bool value = true;

        await tester.pumpWidget(
          tester,
          child: GrafitSwitch(
            value: value,
            onChanged: (v) => value = v,
          ),
        );

        await tester.tap(find.byType(GrafitSwitch));
        expect(value, false);
      });
    });

    group('States', () {
      testWidgets('on state renders', (tester) async {
        await tester.pumpWidget(
          tester,
          child: const ThemedTestWidget(
            child: const GrafitSwitch(value: true),
        );

        expect(find.byType(GrafitSwitch), findsOneWidget);
      });

      testWidgets('off state renders', (tester) async {
        await tester.pumpWidget(
          tester,
          child: const ThemedTestWidget(
            child: const GrafitSwitch(value: false),
        );

        expect(find.byType(GrafitSwitch), findsOneWidget);
      });

      testWidgets('disabled switch cannot be toggled', (tester) async {
        bool value = false;

        await tester.pumpWidget(
          tester,
          child: GrafitSwitch(
            value: value,
            enabled: false,
            onChanged: (v) => value = v,
          ),
        );

        await tester.tap(find.byType(GrafitSwitch));
        expect(value, false);
      });

      testWidgets('enabled switch can be toggled', (tester) async {
        bool value = false;

        await tester.pumpWidget(
          tester,
          child: GrafitSwitch(
            value: value,
            enabled: true,
            onChanged: (v) => value = v,
          ),
        );

        await tester.tap(find.byType(GrafitSwitch));
        expect(value, true);
      });
    });

    group('Sizes', () {
      testWidgets('small size renders', (tester) async {
        await tester.pumpWidget(
          tester,
          child: const ThemedTestWidget(
            child: const GrafitSwitch(
            value: false,
            size: GrafitSwitchSize.sm,
          ),
        );

        expect(find.byType(GrafitSwitch), findsOneWidget);
      });

      testWidgets('default size renders', (tester) async {
        await tester.pumpWidget(
          tester,
          child: const ThemedTestWidget(
            child: const GrafitSwitch(value: false),
        );

        expect(find.byType(GrafitSwitch), findsOneWidget);
      });
    });

    group('Callbacks', () {
      testWidgets('onChanged fires on tap', (tester) async {
        bool? firedValue = null;

        await tester.pumpWidget(
          tester,
          child: GrafitSwitch(
            value: false,
            onChanged: (v) => firedValue = v,
          ),
        );

        await tester.tap(find.byType(GrafitSwitch));
        expect(firedValue, true);
      });

      testWidgets('onChanged receives new value', (tester) async {
        bool? firedValue = null;

        await tester.pumpWidget(
          tester,
          child: GrafitSwitch(
            value: true,
            onChanged: (v) => firedValue = v,
          ),
        );

        await tester.tap(find.byType(GrafitSwitch));
        expect(firedValue, false);
      });

      testWidgets('null onChanged makes switch disabled', (tester) async {
        await tester.pumpWidget(
          tester,
          child: const ThemedTestWidget(
            child: const GrafitSwitch(value: true),
        );

        final clickable = tester.widget<GrafitClickable>(find.byType(GrafitClickable));
        expect(clickable.disabled, true);
      });
    });

    group('Label', () {
      testWidgets('label text is displayed', (tester) async {
        await tester.pumpWidget(
          tester,
          child: const ThemedTestWidget(
            child: const GrafitSwitch(
            value: false,
            label: 'Enable Notifications',
          ),
        );

        expect(find.text('Enable Notifications'), findsOneWidget);
      });

      testWidgets('label with switch works', (tester) async {
        bool value = false;

        await tester.pumpWidget(
          tester,
          child: GrafitSwitch(
            value: value,
            label: 'Dark Mode',
            onChanged: (v) => value = v,
          ),
        );

        await tester.tap(find.text('Dark Mode'));
        expect(value, true);
      });

      testWidgets('tapping switch area toggles', (tester) async {
        bool value = false;

        await tester.pumpWidget(
          tester,
          child: GrafitSwitch(
            value: value,
            label: 'Switch',
            onChanged: (v) => value = v,
          ),
        );

        await tester.tap(find.byType(GrafitSwitch));
        expect(value, true);
      });
    });

    group('Edge Cases', () {
      testWidgets('disabled with label', (tester) async {
        await tester.pumpWidget(
          tester,
          child: const ThemedTestWidget(
            child: const GrafitSwitch(
            value: true,
            label: 'Disabled Switch',
            enabled: false,
          ),
        );

        expect(find.text('Disabled Switch'), findsOneWidget);
      });

      testWidgets('empty label renders', (tester) async {
        await tester.pumpWidget(
          tester,
          child: const ThemedTestWidget(
            child: const GrafitSwitch(
            value: false,
            label: '',
          ),
        );

        expect(find.byType(GrafitSwitch), findsOneWidget);
      });

      testWidgets('long label text wraps', (tester) async {
        const longLabel = 'This is a very long label for the switch component';

        await tester.pumpWidget(
          tester,
          child: const SizedBox(
            width: 200,
            child: GrafitSwitch(
              value: false,
              label: longLabel,
            ),
          ),
        );

        expect(find.text(longLabel), findsOneWidget);
      });

      testWidgets('rapid toggle on/off', (tester) async {
        bool value = false;

        await tester.pumpWidget(
          tester,
          child: GrafitSwitch(
            value: value,
            onChanged: (v) => value = v,
          ),
        );

        await tester.tap(find.byType(GrafitSwitch));
        expect(value, true);

        await tester.tap(find.byType(GrafitSwitch));
        expect(value, false);
      });
    });

    group('Animation', () {
      testWidgets('switch animation completes', (tester) async {
        bool value = false;

        await tester.pumpWidget(
          tester,
          child: GrafitSwitch(
            value: value,
            onChanged: (v) => value = v,
          ),
        );

        await tester.tap(find.byType(GrafitSwitch));
        await tester.pumpAndSettle();

        expect(value, true);
      });
    });
  });
}
