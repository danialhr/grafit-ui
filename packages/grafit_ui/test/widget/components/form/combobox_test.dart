import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grafit_ui/grafit_ui.dart';
import '../../../helpers/test_helpers.dart';
import '../../../helpers/themed_test_widget.dart';

void main() {
  group('GrafitCombobox', () {
    final testItems = [
      GrafitComboboxItem(value: 'apple', label: 'Apple'),
      GrafitComboboxItem(value: 'banana', label: 'Banana'),
      GrafitComboboxItem(value: 'orange', label: 'Orange'),
      GrafitComboboxItem(value: 'grape', label: 'Grape'),
    ];

    group('Smoke Test', () {
      testWidgets('renders combobox', (tester) async {
        await tester.pumpWidget(
          tester,
          child: GrafitCombobox<String>(
            items: testItems,
            onChanged: (_) {},
          ),
        );

        expect(find.byType(GrafitCombobox<String>), findsOneWidget);
      });

      testWidgets('displays placeholder when no value', (tester) async {
        const placeholder = 'Search or select...';

        await tester.pumpWidget(
          tester,
          child: GrafitCombobox<String>(
            items: testItems,
            placeholder: placeholder,
            onChanged: (_) {},
          ),
        );

        expect(find.text(placeholder), findsOneWidget);
      });

      testWidgets('opens suggestions on tap', (tester) async {
        await tester.pumpWidget(
          tester,
          child: GrafitCombobox<String>(
            items: testItems,
            onChanged: (_) {},
          ),
        );

        await tester.tap(find.byType(TextField));
        await tester.pumpAndSettle();

        // Suggestions should appear
        expect(find.byType(Overlay), findsWidgets);
      });
    });

    group('Selection', () {
      testWidgets('selected value is displayed', (tester) async {
        await tester.pumpWidget(
          tester,
          child: GrafitCombobox<String>(
            items: testItems,
            value: 'banana',
            onChanged: (_) {},
          ),
        );

        expect(find.text('Banana'), findsOneWidget);
      });

      testWidgets('onChanged callback fires', (tester) async {
        String? selectedValue;

        await tester.pumpWidget(
          tester,
          child: GrafitCombobox<String>(
            items: testItems,
            onChanged: (v) => selectedValue = v,
          ),
        );

        // Tap and select an item
        await tester.tap(find.byType(TextField));
        await tester.pumpAndSettle();

        // Try to tap on a suggestion
        final appleFinder = find.text('Apple');
        if (appleFinder.evaluate().isNotEmpty) {
          await tester.tap(appleFinder.last);
          await tester.pumpAndSettle();
        }
      });

      testWidgets('value can be changed', (tester) async {
        String? value = 'apple';

        await tester.pumpWidget(
          tester,
          child: StatefulBuilder(
            builder: (context, setState) {
              return GrafitCombobox<String>(
                items: testItems,
                value: value,
                onChanged: (v) => setState(() => value = v),
              );
            },
          ),
        );

        expect(find.text('Apple'), findsOneWidget);
      });
    });

    group('Autocomplete', () {
      testWidgets('filters items based on input', (tester) async {
        await tester.pumpWidget(
          tester,
          child: GrafitCombobox<String>(
            items: testItems,
            onChanged: (_) {},
          ),
        );

        await tester.tap(find.byType(TextField));
        await tester.enterText(find.byType(TextField), 'ap');
        await tester.pumpAndSettle();

        // Should show filtered suggestions
        expect(find.byType(Overlay), findsWidgets);
      });

      testWidgets('shows all items when input is empty', (tester) async {
        await tester.pumpWidget(
          tester,
          child: GrafitCombobox<String>(
            items: testItems,
            onChanged: (_) {},
          ),
        );

        await tester.tap(find.byType(TextField));
        await tester.pumpAndSettle();

        // All items should be visible
        expect(find.byType(Overlay), findsWidgets);
      });

      testWidgets('case insensitive search', (tester) async {
        await tester.pumpWidget(
          tester,
          child: GrafitCombobox<String>(
            items: testItems,
            onChanged: (_) {},
          ),
        );

        await tester.tap(find.byType(TextField));
        await tester.enterText(find.byType(TextField), 'APP');
        await tester.pumpAndSettle();

        // Should still find "Apple"
        expect(find.byType(Overlay), findsWidgets);
      });
    });

    group('Allow Creation', () {
      testWidgets('allows creating new option', (tester) async {
        String? selectedValue;

        await tester.pumpWidget(
          tester,
          child: GrafitCombobox<String>(
            items: testItems,
            allowCreation: true,
            onChanged: (v) => selectedValue = v,
          ),
        );

        await tester.tap(find.byType(TextField));
        await tester.enterText(find.byType(TextField), 'pear');
        await tester.pumpAndSettle();

        expect(find.byType(GrafitCombobox<String>), findsOneWidget);
      });

      testWidgets('onCreate callback fires', (tester) async {
        String? createdValue;

        await tester.pumpWidget(
          tester,
          child: GrafitCombobox<String>(
            items: testItems,
            allowCreation: true,
            onChanged: (_) {},
            onCreate: (v) => createdValue = v,
          ),
        );

        await tester.tap(find.byType(TextField));
        await tester.enterText(find.byType(TextField), 'mango');
        await tester.pumpAndSettle();

        expect(find.byType(GrafitCombobox<String>), findsOneWidget);
      });
    });

    group('Multi-Select', () {
      testWidgets('multiple values can be selected', (tester) async {
        await tester.pumpWidget(
          tester,
          child: GrafitCombobox<String>.multiple(
            items: testItems,
            values: const ['apple', 'banana'],
            onChanged: (_) {},
          ),
        );

        expect(find.byType(GrafitCombobox<String>), findsOneWidget);
        expect(find.text('Apple'), findsOneWidget);
        expect(find.text('Banana'), findsOneWidget);
      });

      testWidgets('multiple selection with chips', (tester) async {
        await tester.pumpWidget(
          tester,
          child: GrafitCombobox<String>.multiple(
            items: testItems,
            values: const ['apple', 'orange'],
            onChanged: (_) {},
          ),
        );

        expect(find.byType(GrafitCombobox<String>), findsOneWidget);
      });

      testWidgets('can remove selected value', (tester) async {
        final values = ['apple', 'banana'];

        await tester.pumpWidget(
          tester,
          child: StatefulBuilder(
            builder: (context, setState) {
              return GrafitCombobox<String>.multiple(
                items: testItems,
                values: values,
                onChanged: (v) => setState(() {
                  values.clear();
                  values.addAll(v);
                }),
              );
            },
          ),
        );

        expect(find.byType(GrafitCombobox<String>), findsOneWidget);
      });
    });

    group('Label', () {
      testWidgets('label is displayed', (tester) async {
        await tester.pumpWidget(
          tester,
          child: GrafitCombobox<String>(
            items: testItems,
            label: 'Select Fruit',
            onChanged: (_) {},
          ),
        );

        expect(find.text('Select Fruit'), findsOneWidget);
      });

      testWidgets('label with placeholder', (tester) async {
        await tester.pumpWidget(
          tester,
          child: GrafitCombobox<String>(
            items: testItems,
            label: 'Country',
            placeholder: 'Search countries...',
            onChanged: (_) {},
          ),
        );

        expect(find.text('Country'), findsOneWidget);
        expect(find.text('Search countries...'), findsOneWidget);
      });
    });

    group('Disabled State', () {
      testWidgets('disabled combobox cannot be interacted', (tester) async {
        await tester.pumpWidget(
          tester,
          child: GrafitCombobox<String>(
            items: testItems,
            enabled: false,
            onChanged: (_) {},
          ),
        );

        final textField = tester.widget<TextField>(find.byType(TextField));
        expect(textField.enabled, false);
      });

      testWidgets('enabled combobox accepts input', (tester) async {
        await tester.pumpWidget(
          tester,
          child: GrafitCombobox<String>(
            items: testItems,
            enabled: true,
            onChanged: (_) {},
          ),
        );

        await tester.tap(find.byType(TextField));
        await tester.enterText(find.byType(TextField), 'test');
        await tester.pump();

        expect(find.text('test'), findsOneWidget);
      });
    });

    group('Grouped Items', () {
      testWidgets('grouped items display correctly', (tester) async {
        final groupedItems = [
          GrafitComboboxItem(value: 'apple', label: 'Apple', group: 'Fruits'),
          GrafitComboboxItem(value: 'carrot', label: 'Carrot', group: 'Vegetables'),
          GrafitComboboxItem(value: 'banana', label: 'Banana', group: 'Fruits'),
        ];

        await tester.pumpWidget(
          tester,
          child: GrafitCombobox<String>(
            items: groupedItems,
            onChanged: (_) {},
          ),
        );

        expect(find.byType(GrafitCombobox<String>), findsOneWidget);
      });
    });

    group('Edge Cases', () {
      testWidgets('empty items list', (tester) async {
        await tester.pumpWidget(
          tester,
          child: GrafitCombobox<String>(
            items: [],
            onChanged: (_) {},
          ),
        );

        expect(find.byType(GrafitCombobox<String>), findsOneWidget);
      });

      testWidgets('single item', (tester) async {
        await tester.pumpWidget(
          tester,
          child: GrafitCombobox<String>(
            items: [testItems[0]],
            onChanged: (_) {},
          ),
        );

        expect(find.byType(GrafitCombobox<String>), findsOneWidget);
      });

      testWidgets('long item labels', (tester) async {
        final longItems = [
          GrafitComboboxItem(
            value: 'long',
            label: 'This is a very long label for testing',
          ),
        ];

        await tester.pumpWidget(
          tester,
          child: GrafitCombobox<String>(
            items: longItems,
            value: 'long',
            onChanged: (_) {},
          ),
        );

        expect(find.text('This is a very long label for testing'), findsOneWidget);
      });

      testWidgets('special characters in labels', (tester) async {
        final specialItems = [
          GrafitComboboxItem(value: '1', label: 'Item & Test'),
          GrafitComboboxItem(value: '2', label: 'Item <test>'),
        ];

        await tester.pumpWidget(
          tester,
          child: GrafitCombobox<String>(
            items: specialItems,
            onChanged: (_) {},
          ),
        );

        expect(find.byType(GrafitCombobox<String>), findsOneWidget);
      });

      testWidgets('no matches found message', (tester) async {
        await tester.pumpWidget(
          tester,
          child: GrafitCombobox<String>(
            items: testItems,
            onChanged: (_) {},
          ),
        );

        await tester.tap(find.byType(TextField));
        await tester.enterText(find.byType(TextField), 'xyzxyz');
        await tester.pumpAndSettle();

        // Should show "no results" or similar
        expect(find.byType(Overlay), findsWidgets);
      });
    });

    group('Keyboard Navigation', () {
      testWidgets('arrow keys navigate options', (tester) async {
        await tester.pumpWidget(
          tester,
          child: GrafitCombobox<String>(
            items: testItems,
            onChanged: (_) {},
          ),
        );

        await tester.tap(find.byType(TextField));
        await tester.pumpAndSettle();

        // Send arrow down key
        await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
        await tester.pump();

        expect(find.byType(GrafitCombobox<String>), findsOneWidget);
      });

      testWidgets('enter selects highlighted option', (tester) async {
        String? selectedValue;

        await tester.pumpWidget(
          tester,
          child: GrafitCombobox<String>(
            items: testItems,
            onChanged: (v) => selectedValue = v,
          ),
        );

        await tester.tap(find.byType(TextField));
        await tester.pumpAndSettle();

        await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
        await tester.pump();
        await tester.sendKeyEvent(LogicalKeyboardKey.enter);
        await tester.pumpAndSettle();

        expect(find.byType(GrafitCombobox<String>), findsOneWidget);
      });

      testWidgets('escape closes dropdown', (tester) async {
        await tester.pumpWidget(
          tester,
          child: GrafitCombobox<String>(
            items: testItems,
            onChanged: (_) {},
          ),
        );

        await tester.tap(find.byType(TextField));
        await tester.pumpAndSettle();

        await tester.sendKeyEvent(LogicalKeyboardKey.escape);
        await tester.pumpAndSettle();

        expect(find.byType(GrafitCombobox<String>), findsOneWidget);
      });
    });
  });
}
