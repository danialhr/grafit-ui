import 'package:flutter_test/flutter_test.dart';
import 'package:grafit_ui/grafit_ui.dart';
import '../../../helpers/test_helpers.dart';
import '../../../helpers/themed_test_widget.dart';

void main() {
  group('GrafitLabel', () {
    group('Smoke Test', () {
      testGrafitWidget('renders with text', (tester) async {
        await tester.pumpWidget(
          const ThemedTestWidget(
            child: GrafitLabel(text: 'Email'),
          ),
        );

        expect(find.text('Email'), findsOneWidget);
      });

      testGrafitWidget('label displays text correctly', (tester) async {
        await tester.pumpWidget(
          const ThemedTestWidget(
            child: GrafitLabel(text: 'Password'),
          ),
        );

        final textWidget = tester.widget<Text>(find.text('Password'));
        expect(textWidget.data, 'Password');
      });
    });

    group('States', () {
      testGrafitWidget('required shows asterisk', (tester) async {
        await tester.pumpWidget(
          const ThemedTestWidget(
            child: GrafitLabel(
              text: 'Required Field',
              required: true,
            ),
          ),
        );

        expect(find.text('Required Field'), findsOneWidget);
        expect(find.text(' *'), findsOneWidget);
      });

      testGrafitWidget('non-required does not show asterisk', (tester) async {
        await tester.pumpWidget(
          const ThemedTestWidget(
            child: GrafitLabel(
              text: 'Optional Field',
              required: false,
            ),
          ),
        );

        expect(find.text('Optional Field'), findsOneWidget);
        expect(find.text(' *'), findsNothing);
      });

      testGrafitWidget('disabled label has reduced opacity', (tester) async {
        await tester.pumpWidget(
          const ThemedTestWidget(
            child: GrafitLabel(
              text: 'Disabled',
              disabled: true,
            ),
          ),
        );

        final opacity = tester.widget<Opacity>(find.byType(Opacity));
        expect(opacity.opacity, 0.5);
      });

      testGrafitWidget('enabled label has full opacity', (tester) async {
        await tester.pumpWidget(
          const ThemedTestWidget(
            child: GrafitLabel(
              text: 'Enabled',
              disabled: false,
            ),
          ),
        );

        final opacity = tester.widget<Opacity>(find.byType(Opacity));
        expect(opacity.opacity, 1.0);
      });
    });

    group('Custom Child', () {
      testGrafitWidget('renders with custom child', (tester) async {
        await tester.pumpWidget(
          ThemedTestWidget(
            child: GrafitLabel(
              text: 'Custom',
              child: const Text('Custom Widget'),
            ),
          ),
        );

        expect(find.text('Custom Widget'), findsOneWidget);
      });

      testGrafitWidget('custom child overrides default rendering', (tester) async {
        await tester.pumpWidget(
          ThemedTestWidget(
            child: GrafitLabel(
              text: 'Label',
              child: const Row(
                children: [
                  Icon(Icons.star),
                  Text('Starred Label'),
                ],
              ),
            ),
          ),
        );

        expect(find.byIcon(Icons.star), findsOneWidget);
        expect(find.text('Starred Label'), findsOneWidget);
      });
    });

    group('Edge Cases', () {
      testGrafitWidget('empty text renders', (tester) async {
        await tester.pumpWidget(
          const ThemedTestWidget(
            child: GrafitLabel(text: ''),
          ),
        );

        expect(find.text(''), findsOneWidget);
      });

      testGrafitWidget('long text wraps properly', (tester) async {
        const longText = 'This is a very long label text that should wrap properly';

        await tester.pumpWidget(
          const ThemedTestWidget(
            child: SizedBox(
              width: 200,
              child: GrafitLabel(text: longText),
            ),
          ),
        );

        expect(find.text(longText), findsOneWidget);
      });

      testGrafitWidget('required and disabled together', (tester) async {
        await tester.pumpWidget(
          const ThemedTestWidget(
            child: GrafitLabel(
              text: 'Required & Disabled',
              required: true,
              disabled: true,
            ),
          ),
        );

        expect(find.text('Required & Disabled'), findsOneWidget);
        expect(find.text(' *'), findsOneWidget);

        final opacity = tester.widget<Opacity>(find.byType(Opacity));
        expect(opacity.opacity, 0.5);
      });
    });
  });
}
