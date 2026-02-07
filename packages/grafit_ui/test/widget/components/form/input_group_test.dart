import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grafit_ui/grafit_ui.dart';
import '../../../helpers/test_helpers.dart';
import '../../../helpers/themed_test_widget.dart';

void main() {
  group('GrafitInputGroup', () {
    group('Smoke Test', () {
      testWidgets('renders input group', (tester) async {
        await tester.pumpWidget(
          tester,
          child: GrafitInputGroup(
            child: const ThemedTestWidget(
            child: const GrafitInput(),
          ),
        );

        expect(find.byType(GrafitInputGroup), findsOneWidget);
      });

      testWidgets('child input is rendered', (tester) async {
        await tester.pumpWidget(
          tester,
          child: GrafitInputGroup(
            child: const ThemedTestWidget(
            child: const GrafitInput(),
          ),
        );

        expect(find.byType(GrafitInput), findsOneWidget);
      });

      testWidgets('input accepts text entry', (tester) async {
        await tester.pumpWidget(
          tester,
          child: GrafitInputGroup(
            child: GrafitInput(
              onChanged: (_) {},
            ),
          ),
        );

        await tester.enterText(find.byType(TextField), 'test');
        expect(find.text('test'), findsOneWidget);
      });
    });

    group('Left Addon', () {
      testWidgets('left addon is displayed', (tester) async {
        await tester.pumpWidget(
          tester,
          child: GrafitInputGroup(
            left: const GrafitInputGroupText(text: 'https://'),
            child: const ThemedTestWidget(
            child: const GrafitInput(),
          ),
        );

        expect(find.text('https://'), findsOneWidget);
      });

      testWidgets('left text addon', (tester) async {
        await tester.pumpWidget(
          tester,
          child: GrafitInputGroup(
            left: const GrafitInputGroupText(text: '\$'),
            child: const ThemedTestWidget(
            child: const GrafitInput(),
          ),
        );

        expect(find.text('\$'), findsOneWidget);
      });

      testWidgets('left icon addon', (tester) async {
        await tester.pumpWidget(
          tester,
          child: GrafitInputGroup(
            left: GrafitInputGroupText(
              icon: Icons.search,
              text: 'Search',
            ),
            child: const ThemedTestWidget(
            child: const GrafitInput(),
          ),
        );

        expect(find.byIcon(Icons.search), findsOneWidget);
      });

      testWidgets('left button addon', (tester) async {
        await tester.pumpWidget(
          tester,
          child: GrafitInputGroup(
            left: GrafitInputGroupButton(
              onPressed: () {},
              icon: Icons.calendar_today,
            ),
            child: const ThemedTestWidget(
            child: const GrafitInput(),
          ),
        );

        expect(find.byIcon(Icons.calendar_today), findsOneWidget);
      });
    });

    group('Right Addon', () {
      testWidgets('right addon is displayed', (tester) async {
        await tester.pumpWidget(
          tester,
          child: GrafitInputGroup(
            right: const GrafitInputGroupText(text: '.com'),
            child: const ThemedTestWidget(
            child: const GrafitInput(),
          ),
        );

        expect(find.text('.com'), findsOneWidget);
      });

      testWidgets('right text addon', (tester) async {
        await tester.pumpWidget(
          tester,
          child: GrafitInputGroup(
            right: const GrafitInputGroupText(text: 'kg'),
            child: const ThemedTestWidget(
            child: const GrafitInput(),
          ),
        );

        expect(find.text('kg'), findsOneWidget);
      });

      testWidgets('right icon addon', (tester) async {
        await tester.pumpWidget(
          tester,
          child: GrafitInputGroup(
            right: GrafitInputGroupText(
              icon: Icons.check,
              text: 'Valid',
            ),
            child: const ThemedTestWidget(
            child: const GrafitInput(),
          ),
        );

        expect(find.byIcon(Icons.check), findsOneWidget);
      });

      testWidgets('right button addon', (tester) async {
        var pressed = false;

        await tester.pumpWidget(
          tester,
          child: GrafitInputGroup(
            right: GrafitInputGroupButton(
              onPressed: () => pressed = true,
              icon: Icons.send,
            ),
            child: const ThemedTestWidget(
            child: const GrafitInput(),
          ),
        );

        await tester.tap(find.byIcon(Icons.send));
        expect(pressed, true);
      });
    });

    group('Top Addon', () {
      testWidgets('top addon is displayed', (tester) async {
        await tester.pumpWidget(
          tester,
          child: GrafitInputGroup(
            top: const GrafitInputGroupText(text: 'Label above'),
            child: const ThemedTestWidget(
            child: const GrafitInput(),
          ),
        );

        expect(find.text('Label above'), findsOneWidget);
      });
    });

    group('Bottom Addon', () {
      testWidgets('bottom addon is displayed', (tester) async {
        await tester.pumpWidget(
          tester,
          child: GrafitInputGroup(
            bottom: const GrafitInputGroupText(text: 'Helper text'),
            child: const ThemedTestWidget(
            child: const GrafitInput(),
          ),
        );

        expect(find.text('Helper text'), findsOneWidget);
      });

      testWidgets('bottom addon with error', (tester) async {
        await tester.pumpWidget(
          tester,
          child: GrafitInputGroup(
            bottom: const GrafitInputGroupText(
              text: 'Error message',
              isError: true,
            ),
            child: const ThemedTestWidget(
            child: const GrafitInput(),
          ),
        );

        expect(find.text('Error message'), findsOneWidget);
      });
    });

    group('Multiple Addons', () {
      testWidgets('left and right addons', (tester) async {
        await tester.pumpWidget(
          tester,
          child: GrafitInputGroup(
            left: const GrafitInputGroupText(text: 'From: '),
            right: const GrafitInputGroupText(text: 'To: '),
            child: const ThemedTestWidget(
            child: const GrafitInput(),
          ),
        );

        expect(find.text('From: '), findsOneWidget);
        expect(find.text('To: '), findsOneWidget);
      });

      testWidgets('all four positions', (tester) async {
        await tester.pumpWidget(
          tester,
          child: GrafitInputGroup(
            top: const GrafitInputGroupText(text: 'Top'),
            left: const GrafitInputGroupText(text: 'Left'),
            right: const GrafitInputGroupText(text: 'Right'),
            bottom: const GrafitInputGroupText(text: 'Bottom'),
            child: const ThemedTestWidget(
            child: const GrafitInput(),
          ),
        );

        expect(find.text('Top'), findsOneWidget);
        expect(find.text('Left'), findsOneWidget);
        expect(find.text('Right'), findsOneWidget);
        expect(find.text('Bottom'), findsOneWidget);
      });
    });

    group('States', () {
      testWidgets('disabled state', (tester) async {
        await tester.pumpWidget(
          tester,
          child: GrafitInputGroup(
            disabled: true,
            left: const GrafitInputGroupText(text: '\$'),
            child: const ThemedTestWidget(
            child: const GrafitInput(),
          ),
        );

        expect(find.byType(GrafitInputGroup), findsOneWidget);
      });

      testWidgets('error state', (tester) async {
        await tester.pumpWidget(
          tester,
          child: GrafitInputGroup(
            hasError: true,
            child: const ThemedTestWidget(
            child: const GrafitInput(),
          ),
        );

        expect(find.byType(GrafitInputGroup), findsOneWidget);
      });
    });

    group('Specialized Components', () {
      testWidgets('GrafitInputGroupInput', (tester) async {
        await tester.pumpWidget(
          tester,
          child: const ThemedTestWidget(
            child: const GrafitInputGroupInput(
            hint: 'Enter text',
          ),
        );

        expect(find.byType(GrafitInput), findsOneWidget);
      });

      testWidgets('GrafitInputGroupTextarea', (tester) async {
        await tester.pumpWidget(
          tester,
          child: const ThemedTestWidget(
            child: const GrafitInputGroupTextarea(
            placeholder: 'Enter message',
          ),
        );

        expect(find.byType(GrafitTextarea), findsOneWidget);
      });
    });

    group('Addon Components', () {
      testWidgets('GrafitInputGroupText with icon only', (tester) async {
        await tester.pumpWidget(
          tester,
          child: GrafitInputGroup(
            left: const GrafitInputGroupText(
              icon: Icons.search,
            ),
            child: const ThemedTestWidget(
            child: const GrafitInput(),
          ),
        );

        expect(find.byIcon(Icons.search), findsOneWidget);
      });

      testWidgets('GrafitInputGroupText with text only', (tester) async {
        await tester.pumpWidget(
          tester,
          child: GrafitInputGroup(
            left: const GrafitInputGroupText(text: 'Prefix'),
            child: const ThemedTestWidget(
            child: const GrafitInput(),
          ),
        );

        expect(find.text('Prefix'), findsOneWidget);
      });

      testWidgets('GrafitInputGroupButton callback', (tester) async {
        var clicked = false;

        await tester.pumpWidget(
          tester,
          child: GrafitInputGroup(
            left: GrafitInputGroupButton(
              onPressed: () => clicked = true,
              icon: Icons.add,
            ),
            child: const ThemedTestWidget(
            child: const GrafitInput(),
          ),
        );

        await tester.tap(find.byIcon(Icons.add));
        expect(clicked, true);
      });

      testWidgets('GrafitInputGroupButton disabled', (tester) async {
        var clicked = false;

        await tester.pumpWidget(
          tester,
          child: GrafitInputGroup(
            left: GrafitInputGroupButton(
              onPressed: () => clicked = true,
              disabled: true,
              icon: Icons.remove,
            ),
            child: const ThemedTestWidget(
            child: const GrafitInput(),
          ),
        );

        await tester.tap(find.byIcon(Icons.remove));
        expect(clicked, false);
      });

      testWidgets('GrafitInputGroupButton with label', (tester) async {
        await tester.pumpWidget(
          tester,
          child: GrafitInputGroup(
            left: GrafitInputGroupButton(
              onPressed: () {},
              icon: Icons.upload,
              label: 'Upload',
            ),
            child: const ThemedTestWidget(
            child: const GrafitInput(),
          ),
        );

        expect(find.text('Upload'), findsOneWidget);
        expect(find.byIcon(Icons.upload), findsOneWidget);
      });
    });

    group('Edge Cases', () {
      testWidgets('empty addons', (tester) async {
        await tester.pumpWidget(
          tester,
          child: GrafitInputGroup(
            child: const ThemedTestWidget(
            child: const GrafitInput(),
          ),
        );

        expect(find.byType(GrafitInput), findsOneWidget);
      });

      testWidgets('very long addon text', (tester) async {
        await tester.pumpWidget(
          tester,
          child: GrafitInputGroup(
            left: const GrafitInputGroupText(
              text: 'Very long prefix text',
            ),
            child: const ThemedTestWidget(
            child: const GrafitInput(),
          ),
        );

        expect(find.text('Very long prefix text'), findsOneWidget);
      });

      testWidgets('multiple addons on same side', (tester) async {
        await tester.pumpWidget(
          tester,
          child: GrafitInputGroup(
            left: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                GrafitInputGroupText(text: 'Line 1'),
                GrafitInputGroupText(text: 'Line 2'),
              ],
            ),
            child: const ThemedTestWidget(
            child: const GrafitInput(),
          ),
        );

        expect(find.text('Line 1'), findsOneWidget);
        expect(find.text('Line 2'), findsOneWidget);
      });
    });

    group('Complex Examples', () {
      testWidgets('URL input group', (tester) async {
        await tester.pumpWidget(
          tester,
          child: GrafitInputGroup(
            left: const GrafitInputGroupText(text: 'https://'),
            right: const GrafitInputGroupText(text: '.com'),
            child: const ThemedTestWidget(
            child: const GrafitInput(hint: 'example'),
          ),
        );

        expect(find.text('https://'), findsOneWidget);
        expect(find.text('.com'), findsOneWidget);
        expect(find.text('example'), findsOneWidget);
      });

      testWidgets('Currency input group', (tester) async {
        await tester.pumpWidget(
          tester,
          child: GrafitInputGroup(
            left: const GrafitInputGroupText(text: '\$'),
            right: const GrafitInputGroupText(text: 'USD'),
            child: const ThemedTestWidget(
            child: const GrafitInput(hint: '0.00'),
          ),
        );

        expect(find.text('\$'), findsOneWidget);
        expect(find.text('USD'), findsOneWidget);
      });

      testWidgets('Search input group', (tester) async {
        await tester.pumpWidget(
          tester,
          child: GrafitInputGroup(
            left: const GrafitInputGroupText(icon: Icons.search),
            right: GrafitInputGroupButton(
              onPressed: () {},
              icon: Icons.clear,
            ),
            child: const ThemedTestWidget(
            child: const GrafitInput(hint: 'Search...'),
          ),
        );

        expect(find.byIcon(Icons.search), findsOneWidget);
        expect(find.byIcon(Icons.clear), findsOneWidget);
      });

      testWidgets('Date picker input group', (tester) async {
        await tester.pumpWidget(
          tester,
          child: GrafitInputGroup(
            right: GrafitInputGroupButton(
              onPressed: () {},
              icon: Icons.calendar_month,
              label: 'Pick',
            ),
            child: const ThemedTestWidget(
            child: const GrafitInput(hint: 'Select date'),
          ),
        );

        expect(find.byIcon(Icons.calendar_month), findsOneWidget);
        expect(find.text('Pick'), findsOneWidget);
      });
    });
  });
}
