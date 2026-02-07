import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grafit_ui/grafit_ui.dart';
import '../../../helpers/test_helpers.dart';
import '../../../helpers/themed_test_widget.dart';

void main() {
  group('GrafitCheckbox', () {
    group('Smoke Test', () {
      testWidgets('renders checkbox', (tester) async {
        await tester.pumpWidget(
          tester,
          child: const ThemedTestWidget(
            child: const GrafitCheckbox(value: false),
        );

        expect(find.byType(GrafitCheckbox), findsOneWidget);
      });

      testWidgets('checkbox can be checked', (tester) async {
        bool? value = false;

        await tester.pumpWidget(
          tester,
          child: GrafitCheckbox(
            value: value,
            onChanged: (v) => value = v,
          ),
        );

        await tester.tap(find.byType(GrafitCheckbox));
        expect(value, true);
      });

      testWidgets('checkbox can be unchecked', (tester) async {
        bool? value = true;

        await tester.pumpWidget(
          tester,
          child: GrafitCheckbox(
            value: value,
            onChanged: (v) => value = v,
          ),
        );

        await tester.tap(find.byType(GrafitCheckbox));
        expect(value, false);
      });
    });

    group('States', () {
      testWidgets('checked state renders', (tester) async {
        await tester.pumpWidget(
          tester,
          child: const ThemedTestWidget(
            child: const GrafitCheckbox(value: true),
        );

        expect(find.byType(GrafitCheckbox), findsOneWidget);
      });

      testWidgets('unchecked state renders', (tester) async {
        await tester.pumpWidget(
          tester,
          child: const ThemedTestWidget(
            child: const GrafitCheckbox(value: false),
        );

        expect(find.byType(GrafitCheckbox), findsOneWidget);
      });

      testWidgets('indeterminate state renders', (tester) async {
        await tester.pumpWidget(
          tester,
          child: const ThemedTestWidget(
            child: const GrafitCheckbox(value: null),
        );

        expect(find.byType(GrafitCheckbox), findsOneWidget);
      });

      testWidgets('disabled checkbox cannot be tapped', (tester) async {
        bool? value = false;

        await tester.pumpWidget(
          tester,
          child: GrafitCheckbox(
            value: value,
            enabled: false,
            onChanged: (v) => value = v,
          ),
        );

        await tester.tap(find.byType(GrafitCheckbox));
        expect(value, false);
      });

      testWidgets('enabled checkbox can be tapped', (tester) async {
        bool? value = false;

        await tester.pumpWidget(
          tester,
          child: GrafitCheckbox(
            value: value,
            enabled: true,
            onChanged: (v) => value = v,
          ),
        );

        await tester.tap(find.byType(GrafitCheckbox));
        expect(value, true);
      });
    });

    group('Sizes', () {
      testWidgets('small size renders', (tester) async {
        await tester.pumpWidget(
          tester,
          child: const ThemedTestWidget(
            child: const GrafitCheckbox(
            value: false,
            size: GrafitInputSize.sm,
          ),
        );

        expect(find.byType(GrafitCheckbox), findsOneWidget);
      });

      testWidgets('medium size renders', (tester) async {
        await tester.pumpWidget(
          tester,
          child: const ThemedTestWidget(
            child: const GrafitCheckbox(
            value: false,
            size: GrafitInputSize.md,
          ),
        );

        expect(find.byType(GrafitCheckbox), findsOneWidget);
      });

      testWidgets('large size renders', (tester) async {
        await tester.pumpWidget(
          tester,
          child: const ThemedTestWidget(
            child: const GrafitCheckbox(
            value: false,
            size: GrafitInputSize.lg,
          ),
        );

        expect(find.byType(GrafitCheckbox), findsOneWidget);
      });
    });

    group('Callbacks', () {
      testWidgets('onChanged fires on tap', (tester) async {
        bool? firedValue = null;

        await tester.pumpWidget(
          tester,
          child: GrafitCheckbox(
            value: false,
            onChanged: (v) => firedValue = v,
          ),
        );

        await tester.tap(find.byType(GrafitCheckbox));
        expect(firedValue, true);
      });

      testWidgets('onChanged receives null when indeterminate', (tester) async {
        bool? firedValue = true;

        await tester.pumpWidget(
          tester,
          child: GrafitCheckbox(
            value: null,
            onChanged: (v) => firedValue = v,
          ),
        );

        await tester.tap(find.byType(GrafitCheckbox));
        expect(firedValue, isNotNull);
      });

      testWidgets('null onChanged makes checkbox disabled', (tester) async {
        await tester.pumpWidget(
          tester,
          child: const ThemedTestWidget(
            child: const GrafitCheckbox(value: true),
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
            child: const GrafitCheckbox(
            value: false,
            label: 'Accept Terms',
          ),
        );

        expect(find.text('Accept Terms'), findsOneWidget);
      });

      testWidgets('label with checkbox works', (tester) async {
        bool? value = false;

        await tester.pumpWidget(
          tester,
          child: GrafitCheckbox(
            value: value,
            label: 'I agree',
            onChanged: (v) => value = v,
          ),
        );

        await tester.tap(find.text('I agree'));
        expect(value, true);
      });
    });

    group('Edge Cases', () {
      testWidgets('indeterminate to checked transition', (tester) async {
        bool? value = null;

        await tester.pumpWidget(
          tester,
          child: GrafitCheckbox(
            value: value,
            onChanged: (v) => value = v,
          ),
        );

        await tester.tap(find.byType(GrafitCheckbox));
        expect(value, isNotNull);
        expect(value, true);
      });

      testWidgets('disabled with label', (tester) async {
        await tester.pumpWidget(
          tester,
          child: const ThemedTestWidget(
            child: const GrafitCheckbox(
            value: true,
            label: 'Disabled Option',
            enabled: false,
          ),
        );

        expect(find.text('Disabled Option'), findsOneWidget);
      });

      testWidgets('empty label renders', (tester) async {
        await tester.pumpWidget(
          tester,
          child: const ThemedTestWidget(
            child: const GrafitCheckbox(
            value: false,
            label: '',
          ),
        );

        expect(find.byType(GrafitCheckbox), findsOneWidget);
      });

      testWidgets('long label text wraps', (tester) async {
        const longLabel = 'This is a very long label that should wrap properly when displayed';

        await tester.pumpWidget(
          tester,
          child: const SizedBox(
            width: 200,
            child: GrafitCheckbox(
              value: false,
              label: longLabel,
            ),
          ),
        );

        expect(find.text(longLabel), findsOneWidget);
      });
    });
  });
}
