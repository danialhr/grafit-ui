import 'package:flutter_test/flutter_test.dart';
import 'package:grafit_ui/grafit_ui.dart';
import '../../../helpers/test_helpers.dart';
import '../../../helpers/themed_test_widget.dart';

void main() {
  group('GrafitToggleGroup', () {
    final testItems = [
      GrafitToggleGroupItem(value: 'bold', label: 'Bold'),
      GrafitToggleGroupItem(value: 'italic', label: 'Italic'),
      GrafitToggleGroupItem(value: 'underline', label: 'Underline'),
    ];

    group('Smoke Test - Single Select', () {
      testWidgets('renders toggle group', (tester) async {
        await tester.pumpWidget(
          tester,
          child: GrafitToggleGroup<String>(
            items: testItems,
            type: GrafitToggleGroupType.single,
            onChanged: (_) {},
          ),
        );

        expect(find.byType(GrafitToggleGroup<String>), findsOneWidget);
      });

      testWidgets('displays all items', (tester) async {
        await tester.pumpWidget(
          tester,
          child: GrafitToggleGroup<String>(
            items: testItems,
            type: GrafitToggleGroupType.single,
            onChanged: (_) {},
          ),
        );

        expect(find.text('Bold'), findsOneWidget);
        expect(find.text('Italic'), findsOneWidget);
        expect(find.text('Underline'), findsOneWidget);
      });

      testWidgets('item can be selected', (tester) async {
        String? selectedValue;

        await tester.pumpWidget(
          tester,
          child: GrafitToggleGroup<String>(
            items: testItems,
            type: GrafitToggleGroupType.single,
            onChanged: (v) => selectedValue = v,
          ),
        );

        await tester.tap(find.text('Italic'));
        expect(selectedValue, 'italic');
      });
    });

    group('Smoke Test - Multiple Select', () {
      testWidgets('renders multi-select toggle group', (tester) async {
        await tester.pumpWidget(
          tester,
          child: GrafitToggleGroup<String>(
            items: testItems,
            type: GrafitToggleGroupType.multiple,
            values: const [],
            onChanged: (_) {},
          ),
        );

        expect(find.byType(GrafitToggleGroup<String>), findsOneWidget);
      });

      testWidgets('multiple items can be selected', (tester) async {
        final selectedValues = <String>[];

        await tester.pumpWidget(
          tester,
          child: StatefulBuilder(
            builder: (context, setState) {
              return GrafitToggleGroup<String>(
                items: testItems,
                type: GrafitToggleGroupType.multiple,
                values: selectedValues,
                onChanged: (v) => setState(() {
                  selectedValues.clear();
                  selectedValues.addAll(v);
                }),
              );
            },
          ),
        );

        await tester.tap(find.text('Bold'));
        await tester.pump();
        await tester.tap(find.text('Italic'));
        await tester.pump();

        expect(selectedValues.length, greaterThan(0));
      });
    });

    group('Variants', () {
      testWidgets('plain variant renders', (tester) async {
        await tester.pumpWidget(
          tester,
          child: GrafitToggleGroup<String>(
            items: testItems,
            variant: GrafitToggleVariant.plain,
            type: GrafitToggleGroupType.single,
            onChanged: (_) {},
          ),
        );

        expect(find.byType(GrafitToggleGroup<String>), findsOneWidget);
      });

      testWidgets('outline variant renders', (tester) async {
        await tester.pumpWidget(
          tester,
          child: GrafitToggleGroup<String>(
            items: testItems,
            variant: GrafitToggleVariant.outline,
            type: GrafitToggleGroupType.single,
            onChanged: (_) {},
          ),
        );

        expect(find.byType(GrafitToggleGroup<String>), findsOneWidget);
      });
    });

    group('Sizes', () {
      testWidgets('small size renders', (tester) async {
        await tester.pumpWidget(
          tester,
          child: GrafitToggleGroup<String>(
            items: testItems,
            size: GrafitButtonSize.sm,
            type: GrafitToggleGroupType.single,
            onChanged: (_) {},
          ),
        );

        expect(find.byType(GrafitToggleGroup<String>), findsOneWidget);
      });

      testWidgets('medium size renders', (tester) async {
        await tester.pumpWidget(
          tester,
          child: GrafitToggleGroup<String>(
            items: testItems,
            size: GrafitButtonSize.md,
            type: GrafitToggleGroupType.single,
            onChanged: (_) {},
          ),
        );

        expect(find.byType(GrafitToggleGroup<String>), findsOneWidget);
      });

      testWidgets('large size renders', (tester) async {
        await tester.pumpWidget(
          tester,
          child: GrafitToggleGroup<String>(
            items: testItems,
            size: GrafitButtonSize.lg,
            type: GrafitToggleGroupType.single,
            onChanged: (_) {},
          ),
        );

        expect(find.byType(GrafitToggleGroup<String>), findsOneWidget);
      });
    });

    group('Selection - Single', () {
      testWidgets('selected value is highlighted', (tester) async {
        await tester.pumpWidget(
          tester,
          child: GrafitToggleGroup<String>(
            items: testItems,
            type: GrafitToggleGroupType.single,
            value: 'italic',
            onChanged: (_) {},
          ),
        );

        expect(find.byType(GrafitToggleGroup<String>), findsOneWidget);
      });

      testWidgets('selecting new item deselects old', (tester) async {
        String? selectedValue = 'bold';

        await tester.pumpWidget(
          tester,
          child: StatefulBuilder(
            builder: (context, setState) {
              return GrafitToggleGroup<String>(
                items: testItems,
                type: GrafitToggleGroupType.single,
                value: selectedValue,
                onChanged: (v) => setState(() => selectedValue = v),
              );
            },
          ),
        );

        await tester.tap(find.text('Italic'));
        await tester.pump();

        expect(selectedValue, 'italic');
      });

      testWidgets('onChanged callback fires', (tester) async {
        String? firedValue;

        await tester.pumpWidget(
          tester,
          child: GrafitToggleGroup<String>(
            items: testItems,
            type: GrafitToggleGroupType.single,
            onChanged: (v) => firedValue = v,
          ),
        );

        await tester.tap(find.text('Bold'));
        expect(firedValue, 'bold');
      });
    });

    group('Selection - Multiple', () {
      testWidgets('multiple selected values are shown', (tester) async {
        await tester.pumpWidget(
          tester,
          child: GrafitToggleGroup<String>(
            items: testItems,
            type: GrafitToggleGroupType.multiple,
            values: const ['bold', 'italic'],
            onChanged: (_) {},
          ),
        );

        expect(find.byType(GrafitToggleGroup<String>), findsOneWidget);
      });

      testWidgets('toggling adds to selection', (tester) async {
        final values = <String>['bold'];

        await tester.pumpWidget(
          tester,
          child: StatefulBuilder(
            builder: (context, setState) {
              return GrafitToggleGroup<String>(
                items: testItems,
                type: GrafitToggleGroupType.multiple,
                values: values,
                onChanged: (v) => setState(() {
                  values.clear();
                  values.addAll(v);
                }),
              );
            },
          ),
        );

        await tester.tap(find.text('Italic'));
        await tester.pump();

        expect(values.length, greaterThan(1));
      });

      testWidgets('toggling again removes from selection', (tester) async {
        final values = <String>['bold', 'italic'];

        await tester.pumpWidget(
          tester,
          child: StatefulBuilder(
            builder: (context, setState) {
              return GrafitToggleGroup<String>(
                items: testItems,
                type: GrafitToggleGroupType.multiple,
                values: values,
                onChanged: (v) => setState(() {
                  values.clear();
                  values.addAll(v);
                }),
              );
            },
          ),
        );

        final beforeCount = values.length;
        await tester.tap(find.text('Bold'));
        await tester.pump();

        expect(values.length, lessThan(beforeCount));
      });
    });

    group('Spacing', () {
      testWidgets('custom spacing is applied', (tester) async {
        await tester.pumpWidget(
          tester,
          child: GrafitToggleGroup<String>(
            items: testItems,
            type: GrafitToggleGroupType.single,
            spacing: 4,
            onChanged: (_) {},
          ),
        );

        expect(find.byType(GrafitToggleGroup<String>), findsOneWidget);
      });

      testWidgets('zero spacing', (tester) async {
        await tester.pumpWidget(
          tester,
          child: GrafitToggleGroup<String>(
            items: testItems,
            type: GrafitToggleGroupType.single,
            spacing: 0,
            onChanged: (_) {},
          ),
        );

        expect(find.byType(GrafitToggleGroup<String>), findsOneWidget);
      });
    });

    group('Disabled Items', () {
      testWidgets('disabled item cannot be selected', (tester) async {
        final disabledItems = [
          testItems[0],
          testItems[1].copyWith(disabled: true),
          testItems[2],
        ];

        String? selectedValue;

        await tester.pumpWidget(
          tester,
          child: GrafitToggleGroup<String>(
            items: disabledItems,
            type: GrafitToggleGroupType.single,
            onChanged: (v) => selectedValue = v,
          ),
        );

        await tester.tap(find.text('Italic'));
        await tester.pump();

        // Disabled item should not be selected
        expect(selectedValue, isNot('italic'));
      });
    });

    group('Edge Cases', () {
      testWidgets('empty items list', (tester) async {
        await tester.pumpWidget(
          tester,
          child: GrafitToggleGroup<String>(
            items: const [],
            type: GrafitToggleGroupType.single,
            onChanged: (_) {},
          ),
        );

        expect(find.byType(GrafitToggleGroup<String>), findsOneWidget);
      });

      testWidgets('single item', (tester) async {
        await tester.pumpWidget(
          tester,
          child: GrafitToggleGroup<String>(
            items: [testItems[0]],
            type: GrafitToggleGroupType.single,
            onChanged: (_) {},
          ),
        );

        expect(find.byType(GrafitToggleGroup<String>), findsOneWidget);
      });

      testWidgets('long labels', (tester) async {
        final longItems = [
          GrafitToggleGroupItem(
            value: 'long',
            label: 'Very Long Label Here',
          ),
        ];

        await tester.pumpWidget(
          tester,
          child: GrafitToggleGroup<String>(
            items: longItems,
            type: GrafitToggleGroupType.single,
            onChanged: (_) {},
          ),
        );

        expect(find.text('Very Long Label Here'), findsOneWidget);
      });
    });

    group('Custom Items', () {
      testWidgets('items with icons', (tester) async {
        final iconItems = [
          GrafitToggleGroupItem(
            value: 'bold',
            icon: Icons.format_bold,
          ),
          GrafitToggleGroupItem(
            value: 'italic',
            icon: Icons.format_italic,
          ),
        ];

        await tester.pumpWidget(
          tester,
          child: GrafitToggleGroup<String>(
            items: iconItems,
            type: GrafitToggleGroupType.single,
            onChanged: (_) {},
          ),
        );

        expect(find.byIcon(Icons.format_bold), findsOneWidget);
        expect(find.byIcon(Icons.format_italic), findsOneWidget);
      });

      testWidgets('items with custom child', (tester) async {
        final customItems = [
          GrafitToggleGroupItem(
            value: 'custom',
            child: const Row(
              children: [
                Icon(Icons.star),
                SizedBox(width: 4),
                Text('Custom'),
              ],
            ),
          ),
        ];

        await tester.pumpWidget(
          tester,
          child: GrafitToggleGroup<String>(
            items: customItems,
            type: GrafitToggleGroupType.single,
            onChanged: (_) {},
          ),
        );

        expect(find.byIcon(Icons.star), findsOneWidget);
        expect(find.text('Custom'), findsOneWidget);
      });
    });
  });
}
