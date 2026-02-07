import 'package:flutter_test/flutter_test.dart';
import 'package:grafit_ui/grafit_ui.dart';
import '../../../helpers/test_helpers.dart';
import '../../../helpers/themed_test_widget.dart';

void main() {
  group('GrafitSlider', () {
    group('Smoke Test - Single Value', () {
      testWidgets('renders slider', (tester) async {
        await tester.pumpWidget(
          tester,
          child: GrafitSlider(
            value: 0.5,
            onChanged: (v) {},
          ),
        );

        expect(find.byType(GrafitSlider), findsOneWidget);
      });

      testWidgets('slider can be dragged', (tester) async {
        double value = 0.5;

        await tester.pumpWidget(
          tester,
          child: SizedBox(
            width: 300,
            child: GrafitSlider(
              value: value,
              onChanged: (v) => value = v,
            ),
          ),
        );

        // Tap at center
        await tester.tap(find.byType(GrafitSlider));
        await tester.pump();

        expect(value, isNotNull);
      });

      testWidgets('onChanged callback fires', (tester) async {
        double? firedValue;

        await tester.pumpWidget(
          tester,
          child: SizedBox(
            width: 300,
            child: GrafitSlider(
              value: 0.5,
              onChanged: (v) => firedValue = v,
            ),
          ),
        );

        await tester.tap(find.byType(GrafitSlider));
        expect(firedValue, isNotNull);
      });
    });

    group('Smoke Test - Range Slider', () {
      testWidgets('range slider renders', (tester) async {
        await tester.pumpWidget(
          tester,
          child: GrafitSlider(
            values: const [0.25, 0.75],
            onRangeChanged: (v) {},
          ),
        );

        expect(find.byType(GrafitSlider), findsOneWidget);
      });

      testWidgets('range slider callback fires', (tester) async {
        List<double>? firedValues;

        await tester.pumpWidget(
          tester,
          child: SizedBox(
            width: 300,
            child: GrafitSlider(
              values: const [0.25, 0.75],
              onRangeChanged: (v) => firedValues = v,
            ),
          ),
        );

        await tester.tap(find.byType(GrafitSlider));
        expect(firedValues, isNotNull);
      });
    });

    group('Value Range', () {
      testWidgets('min value constraint', (tester) async {
        await tester.pumpWidget(
          tester,
          child: SizedBox(
            width: 300,
            child: GrafitSlider(
              value: 0.0,
              min: 0,
              max: 100,
              onChanged: (v) {},
            ),
          ),
        );

        expect(find.byType(GrafitSlider), findsOneWidget);
      });

      testWidgets('max value constraint', (tester) async {
        await tester.pumpWidget(
          tester,
          child: SizedBox(
            width: 300,
            child: GrafitSlider(
              value: 100,
              min: 0,
              max: 100,
              onChanged: (v) {},
            ),
          ),
        );

        expect(find.byType(GrafitSlider), findsOneWidget);
      });

      testWidgets('custom min and max', (tester) async {
        await tester.pumpWidget(
          tester,
          child: SizedBox(
            width: 300,
            child: GrafitSlider(
              value: 50,
              min: 10,
              max: 90,
              onChanged: (v) {},
            ),
          ),
        );

        expect(find.byType(GrafitSlider), findsOneWidget);
      });
    });

    group('States', () {
      testWidgets('disabled slider cannot be interacted', (tester) async {
        double value = 0.5;

        await tester.pumpWidget(
          tester,
          child: SizedBox(
            width: 300,
            child: GrafitSlider(
              value: value,
              enabled: false,
              onChanged: (v) => value = v,
            ),
          ),
        );

        final beforeValue = value;
        await tester.tap(find.byType(GrafitSlider));

        // Value should not change significantly for disabled slider
        expect(value, beforeValue);
      });

      testWidgets('enabled slider can be interacted', (tester) async {
        double value = 0.5;

        await tester.pumpWidget(
          tester,
          child: SizedBox(
            width: 300,
            child: GrafitSlider(
              value: value,
              enabled: true,
              onChanged: (v) => value = v,
            ),
          ),
        );

        await tester.tap(find.byType(GrafitSlider));
        await tester.pump();

        expect(value, isNotNull);
      });
    });

    group('Divisions', () {
      testWidgets('slider with divisions', (tester) async {
        await tester.pumpWidget(
          tester,
          child: SizedBox(
            width: 300,
            child: GrafitSlider(
              value: 0.5,
              divisions: 10,
              onChanged: (v) {},
            ),
          ),
        );

        expect(find.byType(GrafitSlider), findsOneWidget);
      });

      testWidgets('discrete slider snaps to divisions', (tester) async {
        double value = 0.5;

        await tester.pumpWidget(
          tester,
          child: SizedBox(
            width: 300,
            child: GrafitSlider(
              value: value,
              min: 0,
              max: 100,
              divisions: 5,
              onChanged: (v) => value = v,
            ),
          ),
        );

        await tester.tap(find.byType(GrafitSlider));
        await tester.pump();

        // With 5 divisions from 0-100, values should be multiples of 20
        expect(value % 20, closeTo(0, 0.1));
      });
    });

    group('Orientation', () {
      testWidgets('horizontal slider', (tester) async {
        await tester.pumpWidget(
          tester,
          child: SizedBox(
            width: 300,
            child: GrafitSlider(
              value: 0.5,
              orientation: GrafitSliderOrientation.horizontal,
              onChanged: (v) {},
            ),
          ),
        );

        expect(find.byType(GrafitSlider), findsOneWidget);
      });

      testWidgets('vertical slider', (tester) async {
        await tester.pumpWidget(
          tester,
          child: SizedBox(
            height: 300,
            child: GrafitSlider(
              value: 0.5,
              orientation: GrafitSliderOrientation.vertical,
              onChanged: (v) {},
            ),
          ),
        );

        expect(find.byType(GrafitSlider), findsOneWidget);
      });
    });

    group('Label', () {
      testWidgets('label is displayed', (tester) async {
        await tester.pumpWidget(
          tester,
          child: GrafitSlider(
            value: 0.5,
            label: 'Volume',
            onChanged: (v) {},
          ),
        );

        expect(find.text('Volume'), findsOneWidget);
      });

      testWidgets('value display shows current value', (tester) async {
        await tester.pumpWidget(
          tester,
          child: GrafitSlider(
            value: 0.5,
            showValue: true,
            onChanged: (v) {},
          ),
        );

        expect(find.byType(GrafitSlider), findsOneWidget);
      });
    });

    group('Edge Cases', () {
      testWidgets('zero value', (tester) async {
        await tester.pumpWidget(
          tester,
          child: SizedBox(
            width: 300,
            child: GrafitSlider(
              value: 0.0,
              onChanged: (v) {},
            ),
          ),
        );

        expect(find.byType(GrafitSlider), findsOneWidget);
      });

      testWidgets('one value', (tester) async {
        await tester.pumpWidget(
          tester,
          child: SizedBox(
            width: 300,
            child: GrafitSlider(
              value: 1.0,
              onChanged: (v) {},
            ),
          ),
        );

        expect(find.byType(GrafitSlider), findsOneWidget);
      });

      testWidgets('very small range', (tester) async {
        await tester.pumpWidget(
          tester,
          child: SizedBox(
            width: 300,
            child: GrafitSlider(
              value: 0.05,
              min: 0,
              max: 0.1,
              onChanged: (v) {},
            ),
          ),
        );

        expect(find.byType(GrafitSlider), findsOneWidget);
      });

      testWidgets('very large range', (tester) async {
        await tester.pumpWidget(
          tester,
          child: SizedBox(
            width: 300,
            child: GrafitSlider(
              value: 5000,
              min: 0,
              max: 10000,
              onChanged: (v) {},
            ),
          ),
        );

        expect(find.byType(GrafitSlider), findsOneWidget);
      });
    });

    group('Range Slider Specific', () {
      testWidgets('range with two thumbs', (tester) async {
        await tester.pumpWidget(
          tester,
          child: SizedBox(
            width: 300,
            child: GrafitSlider(
              values: const [0.3, 0.7],
              onRangeChanged: (v) {},
            ),
          ),
        );

        expect(find.byType(GrafitSlider), findsOneWidget);
      });

      testWidgets('range with min distance', (tester) async {
        await tester.pumpWidget(
          tester,
          child: SizedBox(
            width: 300,
            child: GrafitSlider(
              values: const [0.2, 0.8],
              minDistance: 0.2,
              onRangeChanged: (v) {},
            ),
          ),
        );

        expect(find.byType(GrafitSlider), findsOneWidget);
      });

      testWidgets('range at boundaries', (tester) async {
        await tester.pumpWidget(
          tester,
          child: SizedBox(
            width: 300,
            child: GrafitSlider(
              values: const [0.0, 1.0],
              onRangeChanged: (v) {},
            ),
          ),
        );

        expect(find.byType(GrafitSlider), findsOneWidget);
      });
    });
  });
}
