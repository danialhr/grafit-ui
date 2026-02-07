import 'package:flutter_test/flutter_test.dart';
import 'package:grafit_ui/grafit_ui.dart';
import '../../../helpers/test_helpers.dart';
import '../../../helpers/themed_test_widget.dart';

void main() {
  group('GrafitRadioGroup', () {
    final testItems = [
      GrafitRadioItem(value: 'option1', label: 'Option 1'),
      GrafitRadioItem(value: 'option2', label: 'Option 2'),
      GrafitRadioItem(value: 'option3', label: 'Option 3'),
    ];

    group('Smoke Test', () {
      testWidgets('renders radio group', (tester) async {
        await tester.pumpWidget(
          tester,
          child: GrafitRadioGroup<String>(
            items: testItems,
            onChanged: (_) {},
          ),
        );

        expect(find.byType(GrafitRadioGroup<String>), findsOneWidget);
      });

      testWidgets('displays all items', (tester) async {
        await tester.pumpWidget(
          tester,
          child: GrafitRadioGroup<String>(
            items: testItems,
            onChanged: (_) {},
          ),
        );

        expect(find.text('Option 1'), findsOneWidget);
        expect(find.text('Option 2'), findsOneWidget);
        expect(find.text('Option 3'), findsOneWidget);
      });

      testWidgets('item can be selected', (tester) async {
        String? selectedValue;

        await tester.pumpWidget(
          tester,
          child: GrafitRadioGroup<String>(
            items: testItems,
            onChanged: (v) => selectedValue = v,
          ),
        );

        await tester.tap(find.text('Option 2'));
        expect(selectedValue, 'option2');
      });
    });

    group('Selection', () {
      testWidgets('selected value is shown', (tester) async {
        await tester.pumpWidget(
          tester,
          child: GrafitRadioGroup<String>(
            items: testItems,
            value: 'option2',
            onChanged: (_) {},
          ),
        );

        expect(find.byType(GrafitRadioGroup<String>), findsOneWidget);
      });

      testWidgets('onChanged callback fires', (tester) async {
        String? firedValue;

        await tester.pumpWidget(
          tester,
          child: GrafitRadioGroup<String>(
            items: testItems,
            onChanged: (v) => firedValue = v,
          ),
        );

        await tester.tap(find.text('Option 1'));
        expect(firedValue, 'option1');
      });

      testWidgets('only one item can be selected', (tester) async {
        String? selectedValue = 'option1';

        await tester.pumpWidget(
          tester,
          child: StatefulBuilder(
            builder: (context, setState) {
              return GrafitRadioGroup<String>(
                items: testItems,
                value: selectedValue,
                onChanged: (v) => setState(() => selectedValue = v),
              );
            },
          ),
        );

        await tester.tap(find.text('Option 2'));
        await tester.pump();

        // Only one should be selected
        expect(selectedValue, 'option2');
      });
    });

    group('Sizes', () {
      testWidgets('small size renders', (tester) async {
        await tester.pumpWidget(
          tester,
          child: GrafitRadioGroup<String>(
            items: testItems,
            size: GrafitInputSize.sm,
            onChanged: (_) {},
          ),
        );

        expect(find.byType(GrafitRadioGroup<String>), findsOneWidget);
      });

      testWidgets('medium size renders', (tester) async {
        await tester.pumpWidget(
          tester,
          child: GrafitRadioGroup<String>(
            items: testItems,
            size: GrafitInputSize.md,
            onChanged: (_) {},
          ),
        );

        expect(find.byType(GrafitRadioGroup<String>), findsOneWidget);
      });

      testWidgets('large size renders', (tester) async {
        await tester.pumpWidget(
          tester,
          child: GrafitRadioGroup<String>(
            items: testItems,
            size: GrafitInputSize.lg,
            onChanged: (_) {},
          ),
        );

        expect(find.byType(GrafitRadioGroup<String>), findsOneWidget);
      });
    });

    group('Direction', () {
      testWidgets('vertical direction (default)', (tester) async {
        await tester.pumpWidget(
          tester,
          child: GrafitRadioGroup<String>(
            items: testItems,
            direction: Axis.vertical,
            onChanged: (_) {},
          ),
        );

        expect(find.byType(Column), findsWidgets);
      });

      testWidgets('horizontal direction', (tester) async {
        await tester.pumpWidget(
          tester,
          child: GrafitRadioGroup<String>(
            items: testItems,
            direction: Axis.horizontal,
            onChanged: (_) {},
          ),
        );

        expect(find.byType(Row), findsWidgets);
      });
    });

    group('States', () {
      testWidgets('enabled group can be interacted', (tester) async {
        String? selectedValue;

        await tester.pumpWidget(
          tester,
          child: GrafitRadioGroup<String>(
            items: testItems,
            enabled: true,
            onChanged: (v) => selectedValue = v,
          ),
        );

        await tester.tap(find.text('Option 1'));
        expect(selectedValue, 'option1');
      });

      testWidgets('disabled group cannot be interacted', (tester) async {
        String? selectedValue = null;

        await tester.pumpWidget(
          tester,
          child: GrafitRadioGroup<String>(
            items: testItems,
            enabled: false,
            onChanged: (v) => selectedValue = v,
          ),
        );

        await tester.tap(find.text('Option 1'));
        expect(selectedValue, isNull);
      });
    });

    group('Label', () {
      testWidgets('group label is displayed', (tester) async {
        await tester.pumpWidget(
          tester,
          child: GrafitRadioGroup<String>(
            items: testItems,
            label: 'Choose an option',
            onChanged: (_) {},
          ),
        );

        expect(find.text('Choose an option'), findsOneWidget);
      });

      testWidgets('label with items', (tester) async {
        await tester.pumpWidget(
          tester,
          child: GrafitRadioGroup<String>(
            items: testItems,
            label: 'Select Size',
            onChanged: (_) {},
          ),
        );

        expect(find.text('Select Size'), findsOneWidget);
        expect(find.text('Option 1'), findsOneWidget);
      });
    });

    group('Spacing', () {
      testWidgets('custom spacing is applied', (tester) async {
        await tester.pumpWidget(
          tester,
          child: GrafitRadioGroup<String>(
            items: testItems,
            spacing: 20,
            onChanged: (_) {},
          ),
        );

        expect(find.byType(GrafitRadioGroup<String>), findsOneWidget);
      });

      testWidgets('zero spacing', (tester) async {
        await tester.pumpWidget(
          tester,
          child: GrafitRadioGroup<String>(
            items: testItems,
            spacing: 0,
            onChanged: (_) {},
          ),
        );

        expect(find.byType(GrafitRadioGroup<String>), findsOneWidget);
      });
    });

    group('Edge Cases', () {
      testWidgets('single item', (tester) async {
        await tester.pumpWidget(
          tester,
          child: GrafitRadioGroup<String>(
            items: [testItems[0]],
            onChanged: (_) {},
          ),
        );

        expect(find.byType(GrafitRadioGroup<String>), findsOneWidget);
      });

      testWidgets('empty items list', (tester) async {
        await tester.pumpWidget(
          tester,
          child: GrafitRadioGroup<String>(
            items: const [],
            onChanged: (_) {},
          ),
        );

        expect(find.byType(GrafitRadioGroup<String>), findsOneWidget);
      });

      testWidgets('long labels', (tester) async {
        final longItems = [
          GrafitRadioItem(
            value: 'long',
            label: 'This is a very long label that should wrap properly',
          ),
        ];

        await tester.pumpWidget(
          tester,
          child: GrafitRadioGroup<String>(
            items: longItems,
            onChanged: (_) {},
          ),
        );

        expect(find.text('This is a very long label that should wrap properly'), findsOneWidget);
      });

      testWidgets('special characters in labels', (tester) async {
        final specialItems = [
          GrafitRadioItem(value: '1', label: 'Option & Test'),
          GrafitRadioItem(value: '2', label: '<Special>'),
        ];

        await tester.pumpWidget(
          tester,
          child: GrafitRadioGroup<String>(
            items: specialItems,
            onChanged: (_) {},
          ),
        );

        expect(find.text('Option & Test'), findsOneWidget);
        expect(find.text('<Special>'), findsOneWidget);
      });

      testWidgets('null value initially', (tester) async {
        await tester.pumpWidget(
          tester,
          child: GrafitRadioGroup<String>(
            items: testItems,
            onChanged: (_) {},
          ),
        );

        // Should render without error
        expect(find.byType(GrafitRadioGroup<String>), findsOneWidget);
      });
    });

    group('Individual Radio Items', () {
      testWidgets('GrafitRadioItem can be used standalone', (tester) async {
        await tester.pumpWidget(
          tester,
          child: const ThemedTestWidget(
            child: const GrafitRadioItem<String>(
            value: 'test',
            label: 'Test Item',
            groupValue: 'test',
            onChanged: null,
          ),
        );

        expect(find.byType(GrafitRadioItem<String>), findsOneWidget);
      });

      testWidgets('radio item without label', (tester) async {
        await tester.pumpWidget(
          tester,
          child: const ThemedTestWidget(
            child: const GrafitRadioItem<String>(
            value: 'test',
            groupValue: null,
            onChanged: null,
          ),
        );

        expect(find.byType(GrafitRadioItem<String>), findsOneWidget);
      });
    });

    group('Custom Content', () {
      testWidgets('items with custom widgets', (tester) async {
        final customItems = [
          GrafitRadioItem(
            value: 'custom1',
            child: const Row(
              children: [
                Icon(Icons.star),
                SizedBox(width: 8),
                Text('Custom Option'),
              ],
            ),
          ),
        ];

        await tester.pumpWidget(
          tester,
          child: GrafitRadioGroup<String>(
            items: customItems,
            onChanged: (_) {},
          ),
        );

        expect(find.byIcon(Icons.star), findsOneWidget);
        expect(find.text('Custom Option'), findsOneWidget);
      });
    });
  });
}
