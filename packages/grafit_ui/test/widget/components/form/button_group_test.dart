import 'package:flutter_test/flutter_test.dart';
import 'package:grafit_ui/grafit_ui.dart';
import '../../../helpers/test_helpers.dart';
import '../../../helpers/themed_test_widget.dart';

void main() {
  group('GrafitButtonGroup', () {
    group('Smoke Test', () {
      testWidgets('renders button group', (tester) async {
        await tester.pumpWidget(
          tester,
          child: GrafitButtonGroup(
            children: [
              GrafitButtonGroupItem(
                child: const Text('Button 1'),
                onPressed: () {},
              ),
              GrafitButtonGroupItem(
                child: const Text('Button 2'),
                onPressed: () {},
              ),
            ],
          ),
        );

        expect(find.byType(GrafitButtonGroup), findsOneWidget);
      });

      testWidgets('displays all children', (tester) async {
        await tester.pumpWidget(
          tester,
          child: GrafitButtonGroup(
            children: [
              GrafitButtonGroupItem(
                child: const Text('Button 1'),
                onPressed: () {},
              ),
              GrafitButtonGroupItem(
                child: const Text('Button 2'),
                onPressed: () {},
              ),
              GrafitButtonGroupItem(
                child: const Text('Button 3'),
                onPressed: () {},
              ),
            ],
          ),
        );

        expect(find.text('Button 1'), findsOneWidget);
        expect(find.text('Button 2'), findsOneWidget);
        expect(find.text('Button 3'), findsOneWidget);
      });

      testWidgets('buttons are clickable', (tester) async {
        var clicked1 = false;
        var clicked2 = false;

        await tester.pumpWidget(
          tester,
          child: GrafitButtonGroup(
            children: [
              GrafitButtonGroupItem(
                child: const Text('Button 1'),
                onPressed: () => clicked1 = true,
              ),
              GrafitButtonGroupItem(
                child: const Text('Button 2'),
                onPressed: () => clicked2 = true,
              ),
            ],
          ),
        );

        await tester.tap(find.text('Button 1'));
        expect(clicked1, true);

        await tester.tap(find.text('Button 2'));
        expect(clicked2, true);
      });
    });

    group('Orientation', () {
      testWidgets('horizontal orientation (default)', (tester) async {
        await tester.pumpWidget(
          tester,
          child: GrafitButtonGroup(
            orientation: GrafitButtonGroupOrientation.horizontal,
            children: [
              GrafitButtonGroupItem(
                child: const Text('H1'),
                onPressed: () {},
              ),
              GrafitButtonGroupItem(
                child: const Text('H2'),
                onPressed: () {},
              ),
            ],
          ),
        );

        expect(find.byType(Row), findsWidgets);
      });

      testWidgets('vertical orientation', (tester) async {
        await tester.pumpWidget(
          tester,
          child: GrafitButtonGroup(
            orientation: GrafitButtonGroupOrientation.vertical,
            children: [
              GrafitButtonGroupItem(
                child: const Text('V1'),
                onPressed: () {},
              ),
              GrafitButtonGroupItem(
                child: const Text('V2'),
                onPressed: () {},
              ),
            ],
          ),
        );

        expect(find.byType(Column), findsWidgets);
      });
    });

    group('Alignment', () {
      testWidgets('start alignment', (tester) async {
        await tester.pumpWidget(
          tester,
          child: GrafitButtonGroup(
            alignment: MainAxisAlignment.start,
            children: [
              GrafitButtonGroupItem(
                child: const Text('A'),
                onPressed: () {},
              ),
            ],
          ),
        );

        expect(find.byType(GrafitButtonGroup), findsOneWidget);
      });

      testWidgets('center alignment', (tester) async {
        await tester.pumpWidget(
          tester,
          child: GrafitButtonGroup(
            alignment: MainAxisAlignment.center,
            children: [
              GrafitButtonGroupItem(
                child: const Text('B'),
                onPressed: () {},
              ),
            ],
          ),
        );

        expect(find.byType(GrafitButtonGroup), findsOneWidget);
      });

      testWidgets('end alignment', (tester) async {
        await tester.pumpWidget(
          tester,
          child: GrafitButtonGroup(
            alignment: MainAxisAlignment.end,
            children: [
              GrafitButtonGroupItem(
                child: const Text('C'),
                onPressed: () {},
              ),
            ],
          ),
        );

        expect(find.byType(GrafitButtonGroup), findsOneWidget);
      });
    });

    group('ButtonGroupItem', () {
      testWidgets('item with icon', (tester) async {
        await tester.pumpWidget(
          tester,
          child: GrafitButtonGroup(
            children: [
              GrafitButtonGroupItem(
                icon: Icons.favorite,
                child: const Text('Like'),
                onPressed: () {},
              ),
            ],
          ),
        );

        expect(find.byIcon(Icons.favorite), findsOneWidget);
      });

      testWidgets('item with custom variant', (tester) async {
        await tester.pumpWidget(
          tester,
          child: GrafitButtonGroup(
            children: [
              GrafitButtonGroupItem(
                variant: GrafitButtonVariant.primary,
                child: const Text('Primary'),
                onPressed: () {},
              ),
            ],
          ),
        );

        expect(find.text('Primary'), findsOneWidget);
      });

      testWidgets('disabled item', (tester) async {
        var clicked = false;

        await tester.pumpWidget(
          tester,
          child: GrafitButtonGroup(
            children: [
              GrafitButtonGroupItem(
                disabled: true,
                child: const Text('Disabled'),
                onPressed: () => clicked = true,
              ),
            ],
          ),
        );

        await tester.tap(find.text('Disabled'));
        expect(clicked, false);
      });

      testWidgets('null onPressed disables item', (tester) async {
        await tester.pumpWidget(
          tester,
          child: GrafitButtonGroup(
            children: const [
              GrafitButtonGroupItem(
                child: Text('No Callback'),
              ),
            ],
          ),
        );

        final clickable = tester.widget<GrafitClickable>(find.byType(GrafitClickable));
        expect(clickable.disabled, true);
      });
    });

    group('Separator', () {
      testWidgets('separator between items', (tester) async {
        await tester.pumpWidget(
          tester,
          child: GrafitButtonGroup(
            children: const [
              GrafitButtonGroupItem(
                child: Text('Before'),
                onPressed: null,
              ),
              GrafitButtonGroupSeparator(),
              GrafitButtonGroupItem(
                child: Text('After'),
                onPressed: null,
              ),
            ],
          ),
        );

        expect(find.byType(GrafitButtonGroupSeparator), findsOneWidget);
      });

      testWidgets('multiple separators', (tester) async {
        await tester.pumpWidget(
          tester,
          child: GrafitButtonGroup(
            children: const [
              GrafitButtonGroupItem(
                child: Text('1'),
                onPressed: null,
              ),
              GrafitButtonGroupSeparator(),
              GrafitButtonGroupItem(
                child: Text('2'),
                onPressed: null,
              ),
              GrafitButtonGroupSeparator(),
              GrafitButtonGroupItem(
                child: Text('3'),
                onPressed: null,
              ),
            ],
          ),
        );

        expect(find.byType(GrafitButtonGroupSeparator), findsNWidgets(2));
      });
    });

    group('Connected Borders', () {
      testWidgets('items have connected appearance', (tester) async {
        await tester.pumpWidget(
          tester,
          child: GrafitButtonGroup(
            children: [
              GrafitButtonGroupItem(
                child: const Text('First'),
                onPressed: () {},
              ),
              GrafitButtonGroupItem(
                child: const Text('Second'),
                onPressed: () {},
              ),
              GrafitButtonGroupItem(
                child: const Text('Third'),
                onPressed: () {},
              ),
            ],
          ),
        );

        // All buttons should be rendered
        expect(find.byType(GrafitButtonGroupItem), findsNWidgets(3));
      });
    });

    group('Edge Cases', () {
      testWidgets('single item', (tester) async {
        await tester.pumpWidget(
          tester,
          child: GrafitButtonGroup(
            children: [
              GrafitButtonGroupItem(
                child: const Text('Solo'),
                onPressed: () {},
              ),
            ],
          ),
        );

        expect(find.byType(GrafitButtonGroup), findsOneWidget);
      });

      testWidgets('empty children list', (tester) async {
        await tester.pumpWidget(
          tester,
          child: GrafitButtonGroup(
            children: const [],
          ),
        );

        expect(find.byType(GrafitButtonGroup), findsOneWidget);
      });

      testWidgets('many items', (tester) async {
        await tester.pumpWidget(
          tester,
          child: GrafitButtonGroup(
            children: List.generate(
              10,
              (i) => GrafitButtonGroupItem(
                child: Text('Btn $i'),
                onPressed: () {},
              ),
            ),
          ),
        );

        for (int i = 0; i < 10; i++) {
          expect(find.text('Btn $i'), findsOneWidget);
        }
      });

      testWidgets('mixed enabled and disabled', (tester) async {
        await tester.pumpWidget(
          tester,
          child: GrafitButtonGroup(
            children: [
              GrafitButtonGroupItem(
                child: const Text('Enabled'),
                onPressed: () {},
              ),
              GrafitButtonGroupItem(
                disabled: true,
                child: const Text('Disabled'),
                onPressed: () {},
              ),
              GrafitButtonGroupItem(
                child: const Text('Enabled'),
                onPressed: () {},
              ),
            ],
          ),
        );

        expect(find.text('Enabled'), findsNWidgets(2));
        expect(find.text('Disabled'), findsOneWidget);
      });
    });

    group('Complex Examples', () {
      testWidgets('pagination buttons', (tester) async {
        await tester.pumpWidget(
          tester,
          child: GrafitButtonGroup(
            children: [
              GrafitButtonGroupItem(
                child: const Text('Previous'),
                onPressed: () {},
              ),
              GrafitButtonGroupItem(
                child: const Text('1'),
                onPressed: () {},
              ),
              GrafitButtonGroupItem(
                child: const Text('2'),
                onPressed: () {},
              ),
              GrafitButtonGroupItem(
                child: const Text('Next'),
                onPressed: () {},
              ),
            ],
          ),
        );

        expect(find.text('Previous'), findsOneWidget);
        expect(find.text('Next'), findsOneWidget);
      });

      testWidgets('text formatting buttons', (tester) async {
        await tester.pumpWidget(
          tester,
          child: GrafitButtonGroup(
            children: [
              GrafitButtonGroupItem(
                icon: Icons.format_bold,
                onPressed: () {},
              ),
              GrafitButtonGroupItem(
                icon: Icons.format_italic,
                onPressed: () {},
              ),
              GrafitButtonGroupItem(
                icon: Icons.format_underlined,
                onPressed: () {},
              ),
            ],
          ),
        );

        expect(find.byIcon(Icons.format_bold), findsOneWidget);
        expect(find.byIcon(Icons.format_italic), findsOneWidget);
        expect(find.byIcon(Icons.format_underlined), findsOneWidget);
      });

      testWidgets('action menu with separator', (tester) async {
        await tester.pumpWidget(
          tester,
          child: GrafitButtonGroup(
            children: const [
              GrafitButtonGroupItem(
                child: Text('Save'),
                onPressed: null,
              ),
              GrafitButtonGroupItem(
                child: Text('Load'),
                onPressed: null,
              ),
              GrafitButtonGroupSeparator(),
              GrafitButtonGroupItem(
                child: Text('Export'),
                onPressed: null,
              ),
            ],
          ),
        );

        expect(find.text('Save'), findsOneWidget);
        expect(find.text('Load'), findsOneWidget);
        expect(find.text('Export'), findsOneWidget);
        expect(find.byType(GrafitButtonGroupSeparator), findsOneWidget);
      });
    });

    group('Variant Mixing', () {
      testWidgets('different variants in group', (tester) async {
        await tester.pumpWidget(
          tester,
          child: GrafitButtonGroup(
            children: [
              GrafitButtonGroupItem(
                variant: GrafitButtonVariant.primary,
                child: const Text('Primary'),
                onPressed: () {},
              ),
              GrafitButtonGroupItem(
                variant: GrafitButtonVariant.secondary,
                child: const Text('Secondary'),
                onPressed: () {},
              ),
              GrafitButtonGroupItem(
                variant: GrafitButtonVariant.outline,
                child: const Text('Outline'),
                onPressed: () {},
              ),
            ],
          ),
        );

        expect(find.text('Primary'), findsOneWidget);
        expect(find.text('Secondary'), findsOneWidget);
        expect(find.text('Outline'), findsOneWidget);
      });
    });

    group('Size Variations', () {
      testWidgets('different sizes in group', (tester) async {
        await tester.pumpWidget(
          tester,
          child: GrafitButtonGroup(
            children: [
              GrafitButtonGroupItem(
                size: GrafitButtonSize.sm,
                child: const Text('Small'),
                onPressed: () {},
              ),
              GrafitButtonGroupItem(
                size: GrafitButtonSize.md,
                child: const Text('Medium'),
                onPressed: () {},
              ),
              GrafitButtonGroupItem(
                size: GrafitButtonSize.lg,
                child: const Text('Large'),
                onPressed: () {},
              ),
            ],
          ),
        );

        expect(find.text('Small'), findsOneWidget);
        expect(find.text('Medium'), findsOneWidget);
        expect(find.text('Large'), findsOneWidget);
      });
    });

    group('Icon-Only Items', () {
      testWidgets('icon-only buttons in group', (tester) async {
        await tester.pumpWidget(
          tester,
          child: GrafitButtonGroup(
            children: [
              GrafitButtonGroupItem(
                icon: Icons.zoom_in,
                onPressed: () {},
              ),
              GrafitButtonGroupItem(
                icon: Icons.zoom_out,
                onPressed: () {},
              ),
              GrafitButtonGroupItem(
                icon: Icons.refresh,
                onPressed: () {},
              ),
            ],
          ),
        );

        expect(find.byIcon(Icons.zoom_in), findsOneWidget);
        expect(find.byIcon(Icons.zoom_out), findsOneWidget);
        expect(find.byIcon(Icons.refresh), findsOneWidget);
      });
    });
  });
}
