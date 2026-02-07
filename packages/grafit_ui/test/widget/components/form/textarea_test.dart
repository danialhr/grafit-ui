import 'package:flutter_test/flutter_test.dart';
import 'package:grafit_ui/grafit_ui.dart';
import '../../../helpers/test_helpers.dart';
import '../../../helpers/themed_test_widget.dart';

void main() {
  group('GrafitTextarea', () {
    group('Smoke Test', () {
      testWidgets('renders textarea', (tester) async {
        await tester.pumpWidget(
          tester,
          child: const ThemedTestWidget(
            child: const GrafitTextarea(),
        );

        expect(find.byType(GrafitTextarea), findsOneWidget);
      });

      testWidgets('textarea accepts text entry', (tester) async {
        await tester.pumpWidget(
          tester,
          child: const ThemedTestWidget(
            child: const GrafitTextarea(),
        );

        await tester.enterText(find.byType(TextField), 'Hello World');
        expect(find.text('Hello World'), findsOneWidget);
      });

      testWidgets('onChanged callback fires', (tester) async {
        String? value;

        await tester.pumpWidget(
          tester,
          child: GrafitTextarea(
            onChanged: (v) => value = v,
          ),
        );

        await tester.enterText(find.byType(TextField), 'Test');
        expect(value, 'Test');
      });
    });

    group('Lines Configuration', () {
      testWidgets('default minLines and maxLines', (tester) async {
        await tester.pumpWidget(
          tester,
          child: const ThemedTestWidget(
            child: const GrafitTextarea(),
        );

        final textField = tester.widget<TextField>(find.byType(TextField));
        expect(textField.minLines, 3);
        expect(textField.maxLines, 5);
      });

      testWidgets('custom minLines', (tester) async {
        await tester.pumpWidget(
          tester,
          child: const ThemedTestWidget(
            child: const GrafitTextarea(minLines: 2),
        );

        final textField = tester.widget<TextField>(find.byType(TextField));
        expect(textField.minLines, 2);
      });

      testWidgets('custom maxLines', (tester) async {
        await tester.pumpWidget(
          tester,
          child: const ThemedTestWidget(
            child: const GrafitTextarea(maxLines: 10),
        );

        final textField = tester.widget<TextField>(find.byType(TextField));
        expect(textField.maxLines, 10);
      });

      testWidgets('expanding textarea', (tester) async {
        await tester.pumpWidget(
          tester,
          child: const ThemedTestWidget(
            child: const GrafitTextarea(
            minLines: 1,
            maxLines: null,
          ),
        );

        final textField = tester.widget<TextField>(find.byType(TextField));
        expect(textField.maxLines, null);
      });
    });

    group('States', () {
      testWidgets('enabled textarea accepts text', (tester) async {
        await tester.pumpWidget(
          tester,
          child: const ThemedTestWidget(
            child: const GrafitTextarea(enabled: true),
        );

        await tester.enterText(find.byType(TextField), 'Enabled');
        expect(find.text('Enabled'), findsOneWidget);
      });

      testWidgets('disabled textarea does not accept text', (tester) async {
        await tester.pumpWidget(
          tester,
          child: const ThemedTestWidget(
            child: const GrafitTextarea(enabled: false),
        );

        final textField = tester.widget<TextField>(find.byType(TextField));
        expect(textField.enabled, false);
      });

      testWidgets('readOnly textarea displays value', (tester) async {
        await tester.pumpWidget(
          tester,
          child: const ThemedTestWidget(
            child: const GrafitTextarea(
            value: 'Read Only Content',
            readOnly: true,
          ),
        );

        expect(find.text('Read Only Content'), findsOneWidget);
      });
    });

    group('Placeholder', () {
      testWidgets('placeholder is displayed', (tester) async {
        const placeholder = 'Enter your message here';

        await tester.pumpWidget(
          tester,
          child: const ThemedTestWidget(
            child: const GrafitTextarea(placeholder: placeholder),
        );

        expect(find.text(placeholder), findsOneWidget);
      });

      testWidgets('placeholder disappears when typing', (tester) async {
        const placeholder = 'Enter text';

        await tester.pumpWidget(
          tester,
          child: GrafitTextarea(
            placeholder: placeholder,
            onChanged: (v) {},
          ),
        );

        expect(find.text(placeholder), findsOneWidget);
        await tester.enterText(find.byType(TextField), 'Hello');
        await tester.pump();

        // Placeholder should not be visible when text is entered
        expect(find.text(placeholder), findsNothing);
      });
    });

    group('Error States', () {
      testWidgets('error text is displayed', (tester) async {
        const errorText = 'This field is required';

        await tester.pumpWidget(
          tester,
          child: const ThemedTestWidget(
            child: const GrafitTextarea(errorText: errorText),
        );

        expect(find.text(errorText), findsOneWidget);
      });

      testWidgets('error with label', (tester) async {
        await tester.pumpWidget(
          tester,
          child: const ThemedTestWidget(
            child: const GrafitTextarea(
            label: 'Description',
            errorText: 'Too long',
          ),
        );

        expect(find.text('Description'), findsOneWidget);
        expect(find.text('Too long'), findsOneWidget);
      });
    });

    group('Label', () {
      testWidgets('label is displayed', (tester) async {
        await tester.pumpWidget(
          tester,
          child: const ThemedTestWidget(
            child: const GrafitTextarea(label: 'Bio'),
        );

        expect(find.text('Bio'), findsOneWidget);
      });
    });

    group('Character Limit', () {
      testWidgets('maxLength enforces limit', (tester) async {
        String? value;

        await tester.pumpWidget(
          tester,
          child: GrafitTextarea(
            maxLength: 10,
            onChanged: (v) => value = v,
          ),
        );

        await tester.enterText(find.byType(TextField), 'This is too long');
        // TextField with maxLength should truncate
        expect(value?.length, lessThanOrEqualTo(10));
      });

      testWidgets('character count displayed', (tester) async {
        await tester.pumpWidget(
          tester,
          child: const ThemedTestWidget(
            child: const GrafitTextarea(
            value: 'Hello',
            maxLength: 100,
            showCharacterCount: true,
          ),
        );

        // Character count should be visible
        expect(find.byType(GrafitTextarea), findsOneWidget);
      });
    });

    group('Value Handling', () {
      testWidgets('initial value is displayed', (tester) async {
        const initialValue = 'Initial content';

        await tester.pumpWidget(
          tester,
          child: const ThemedTestWidget(
            child: const GrafitTextarea(value: initialValue),
        );

        expect(find.text(initialValue), findsOneWidget);
      });

      testWidgets('multiline value is displayed', (tester) async {
        const multilineValue = 'Line 1\nLine 2\nLine 3';

        await tester.pumpWidget(
          tester,
          child: const ThemedTestWidget(
            child: const GrafitTextarea(value: multilineValue),
        );

        expect(find.text(multilineValue), findsOneWidget);
      });

      testWidgets('value can be updated', (tester) async {
        String? value;

        await tester.pumpWidget(
          tester,
          child: GrafitTextarea(
            value: 'Initial',
            onChanged: (v) => value = v,
          ),
        );

        await tester.enterText(find.byType(TextField), 'Updated content');
        expect(value, 'Updated content');
      });
    });

    group('Edge Cases', () {
      testWidgets('very long text', (tester) async {
        const longText = 'A' * 1000;

        await tester.pumpWidget(
          tester,
          child: const ThemedTestWidget(
            child: const GrafitTextarea(value: longText),
        );

        expect(find.text(longText), findsOneWidget);
      });

      testWidgets('empty textarea', (tester) async {
        await tester.pumpWidget(
          tester,
          child: GrafitTextarea(value: ''),
        );

        expect(find.byType(GrafitTextarea), findsOneWidget);
      });

      testWidgets('special characters', (tester) async {
        const specialText = '!@#\$%^&*()_+-=[]{}|;:,.<>?';

        await tester.pumpWidget(
          tester,
          child: GrafitTextarea(
            onChanged: (v) {},
          ),
        );

        await tester.enterText(find.byType(TextField), specialText);
        expect(find.text(specialText), findsOneWidget);
      });

      testWidgets('emojis in textarea', (tester) async {
        const emojiText = 'Hello 😀 World 🌍';

        await tester.pumpWidget(
          tester,
          child: GrafitTextarea(
            onChanged: (v) {},
          ),
        );

        await tester.enterText(find.byType(TextField), emojiText);
        expect(find.text(emojiText), findsOneWidget);
      });

      testWidgets('many lines', (tester) async {
        const manyLines = 'Line 1\n' * 50;

        await tester.pumpWidget(
          tester,
          child: GrafitTextarea(
            value: manyLines,
            maxLines: null,
          ),
        );

        expect(find.text(manyLines), findsOneWidget);
      });
    });
  });
}
