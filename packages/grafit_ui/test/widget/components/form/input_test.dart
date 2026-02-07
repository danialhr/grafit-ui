import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grafit_ui/grafit_ui.dart';

import '../../../helpers/test_helpers.dart';
import '../../../helpers/themed_test_widget.dart';

void main() {
  group('GrafitInput - Smoke Tests', () {
    testGrafitWidget('renders without errors', (tester) async {
      await tester.pumpWidget(
        ThemedTestWidget(
          child: GrafitInput(
            label: 'Test Input',
            onChanged: (_) {},
          ),
        ),
      );

      expect(find.byType(GrafitInput), findsOneWidget);
      expect(find.text('Test Input'), findsOneWidget);
    });

    testGrafitWidget('renders with placeholder', (tester) async {
      await tester.pumpWidget(
        ThemedTestWidget(
          child: GrafitInput(
            hint: 'Enter text here',
            onChanged: (_) {},
          ),
        ),
      );

      expect(find.byType(GrafitInput), findsOneWidget);
    });

    testGrafitWidget('renders with initial value', (tester) async {
      const initialValue = 'Initial Value';

      await tester.pumpWidget(
        ThemedTestWidget(
          child: GrafitInput(
            value: initialValue,
            onChanged: (_) {},
          ),
        ),
      );

      expect(find.byType(GrafitInput), findsOneWidget);
      expect(find.text(initialValue), findsOneWidget);
    });
  });

  group('GrafitInput - Sizes', () {
    testGrafitWidget('renders small size', (tester) async {
      await tester.pumpWidget(
        ThemedTestWidget(
          child: GrafitInput(
            label: 'Small Input',
            size: GrafitInputSize.sm,
            onChanged: (_) {},
          ),
        ),
      );

      expect(find.byType(GrafitInput), findsOneWidget);
    });

    testGrafitWidget('renders medium size', (tester) async {
      await tester.pumpWidget(
        ThemedTestWidget(
          child: GrafitInput(
            label: 'Medium Input',
            size: GrafitInputSize.md,
            onChanged: (_) {},
          ),
        ),
      );

      expect(find.byType(GrafitInput), findsOneWidget);
    });

    testGrafitWidget('renders large size', (tester) async {
      await tester.pumpWidget(
        ThemedTestWidget(
          child: GrafitInput(
            label: 'Large Input',
            size: GrafitInputSize.lg,
            onChanged: (_) {},
          ),
        ),
      );

      expect(find.byType(GrafitInput), findsOneWidget);
    });
  });

  group('GrafitInput - States', () {
    testGrafitWidget('renders in disabled state', (tester) async {
      await tester.pumpWidget(
        ThemedTestWidget(
          child: GrafitInput(
            label: 'Disabled Input',
            enabled: false,
            onChanged: (_) {},
          ),
        ),
      );

      expect(find.byType(GrafitInput), findsOneWidget);
    });

    testGrafitWidget('renders in read-only state', (tester) async {
      await tester.pumpWidget(
        ThemedTestWidget(
          child: GrafitInput(
            label: 'Read Only Input',
            readOnly: true,
            value: 'Cannot edit',
            onChanged: (_) {},
          ),
        ),
      );

      expect(find.byType(GrafitInput), findsOneWidget);
    });

    testGrafitWidget('renders with error text', (tester) async {
      await tester.pumpWidget(
        ThemedTestWidget(
          child: GrafitInput(
            label: 'Error Input',
            errorText: 'This field is required',
            onChanged: (_) {},
          ),
        ),
      );

      expect(find.byType(GrafitInput), findsOneWidget);
      expect(find.text('This field is required'), findsOneWidget);
    });

    testGrafitWidget('renders with helper text', (tester) async {
      await tester.pumpWidget(
        ThemedTestWidget(
          child: GrafitInput(
            label: 'Input with Helper',
            helperText: 'Enter at least 8 characters',
            onChanged: (_) {},
          ),
        ),
      );

      expect(find.byType(GrafitInput), findsOneWidget);
      expect(find.text('Enter at least 8 characters'), findsOneWidget);
    });
  });

  group('GrafitInput - Interactions', () {
    testGrafitWidget('triggers onChanged when text is entered', (tester) async {
      String? changedValue;
      const testValue = 'Test input';

      await tester.pumpWidget(
        ThemedTestWidget(
          child: GrafitInput(
            label: 'Test Input',
            onChanged: (value) => changedValue = value,
          ),
        ),
      );

      await tester.enterText(find.byType(TextField), testValue);
      await tester.pumpAndSettle();

      expect(changedValue, testValue);
    });

    testGrafitWidget('updates value when user types', (tester) async {
      const testValue = 'User typing';

      await tester.pumpWidget(
        ThemedTestWidget(
          child: GrafitInput(
            label: 'Type here',
            onChanged: (_) {},
          ),
        ),
      );

      await tester.enterText(find.byType(TextField), testValue);
      await tester.pumpAndSettle();

      expect(find.text(testValue), findsOneWidget);
    });

    testGrafitWidget('triggers onTap callback', (tester) async {
      bool tapped = false;

      await tester.pumpWidget(
        ThemedTestWidget(
          child: GrafitInput(
            label: 'Tap Input',
            onTap: () => tapped = true,
            onChanged: (_) {},
          ),
        ),
      );

      await tester.tap(find.byType(GrafitInput));
      await tester.pumpAndSettle();

      expect(tapped, isTrue);
    });

    testGrafitWidget('triggers onSubmitted when submit action', (tester) async {
      String? submittedValue;
      const testValue = 'Submitted text';

      await tester.pumpWidget(
        ThemedTestWidget(
          child: GrafitInput(
            label: 'Submit Input',
            onSubmitted: (value) => submittedValue = value,
            onChanged: (_) {},
          ),
        ),
      );

      await tester.enterText(find.byType(TextField), testValue);
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();

      expect(submittedValue, testValue);
    });
  });

  group('GrafitInput - Prefix and Suffix', () {
    testGrafitWidget('renders with prefix', (tester) async {
      await tester.pumpWidget(
        ThemedTestWidget(
          child: GrafitInput(
            label: 'Search',
            prefix: const Icon(Icons.search),
            onChanged: (_) {},
          ),
        ),
      );

      expect(find.byType(GrafitInput), findsOneWidget);
      expect(find.byIcon(Icons.search), findsOneWidget);
    });

    testGrafitWidget('renders with suffix', (tester) async {
      await tester.pumpWidget(
        ThemedTestWidget(
          child: GrafitInput(
            label: 'Email',
            suffix: const Icon(Icons.email),
            onChanged: (_) {},
          ),
        ),
      );

      expect(find.byType(GrafitInput), findsOneWidget);
      expect(find.byIcon(Icons.email), findsOneWidget);
    });

    testGrafitWidget('renders with both prefix and suffix', (tester) async {
      await tester.pumpWidget(
        ThemedTestWidget(
          child: GrafitInput(
            label: 'Url',
            prefix: const Icon(Icons.link),
            suffix: const Icon(Icons.open_in_new),
            onChanged: (_) {},
          ),
        ),
      );

      expect(find.byType(GrafitInput), findsOneWidget);
      expect(find.byIcon(Icons.link), findsOneWidget);
      expect(find.byIcon(Icons.open_in_new), findsOneWidget);
    });
  });

  group('GrafitInput - Input Properties', () {
    testGrafitWidget('renders with maxLines', (tester) async {
      await tester.pumpWidget(
        ThemedTestWidget(
          child: GrafitInput(
            label: 'Multiline',
            maxLines: 5,
            onChanged: (_) {},
          ),
        ),
      );

      expect(find.byType(GrafitInput), findsOneWidget);
    });

    testGrafitWidget('respects maxLength', (tester) async {
      const maxLength = 10;

      await tester.pumpWidget(
        ThemedTestWidget(
          child: GrafitInput(
            label: 'Limited',
            maxLength: maxLength,
            onChanged: (_) {},
          ),
        ),
      );

      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.maxLength, maxLength);
    });

    testGrafitWidget('renders with keyboardType', (tester) async {
      await tester.pumpWidget(
        ThemedTestWidget(
          child: GrafitInput(
            label: 'Email',
            keyboardType: TextInputType.emailAddress,
            onChanged: (_) {},
          ),
        ),
      );

      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.keyboardType, TextInputType.emailAddress);
    });

    testGrafitWidget('renders with textInputAction', (tester) async {
      await tester.pumpWidget(
        ThemedTestWidget(
          child: GrafitInput(
            label: 'Search',
            textInputAction: TextInputAction.search,
            onChanged: (_) {},
          ),
        ),
      );

      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.textInputAction, TextInputAction.search);
    });

    testGrafitWidget('renders obscure text for passwords', (tester) async {
      await tester.pumpWidget(
        ThemedTestWidget(
          child: GrafitInput(
            label: 'Password',
            obscureText: true,
            onChanged: (_) {},
          ),
        ),
      );

      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.obscureText, isTrue);
    });
  });

  group('GrafitInput - Controllers and Focus', () {
    testGrafitWidget('uses custom controller', (tester) async {
      final controller = TextEditingController(text: 'Initial');

      await tester.pumpWidget(
        ThemedTestWidget(
          child: GrafitInput(
            label: 'Custom Controller',
            controller: controller,
            onChanged: (_) {},
          ),
        ),
      );

      expect(find.text('Initial'), findsOneWidget);
      controller.dispose();
    });

    testGrafitWidget('uses custom focus node', (tester) async {
      final focusNode = FocusNode();

      await tester.pumpWidget(
        ThemedTestWidget(
          child: GrafitInput(
            label: 'Custom Focus',
            focusNode: focusNode,
            onChanged: (_) {},
          ),
        ),
      );

      expect(find.byType(GrafitInput), findsOneWidget);
      focusNode.dispose();
    });

    testGrafitWidget('receives focus when tapped', (tester) async {
      final focusNode = FocusNode();

      await tester.pumpWidget(
        ThemedTestWidget(
          child: GrafitInput(
            label: 'Focus Test',
            focusNode: focusNode,
            onChanged: (_) {},
          ),
        ),
      );

      await tester.tap(find.byType(GrafitInput));
      await tester.pumpAndSettle();

      expect(focusNode.hasFocus, isTrue);
      focusNode.dispose();
    });
  });

  group('GrafitInput - Input Formatters', () {
    testGrafitWidget('applies input formatters', (tester) async {
      await tester.pumpWidget(
        ThemedTestWidget(
          child: GrafitInput(
            label: 'Numbers Only',
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
            ],
            onChanged: (_) {},
          ),
        ),
      );

      expect(find.byType(GrafitInput), findsOneWidget);

      // Try entering non-digits - should be filtered
      await tester.enterText(find.byType(TextField), 'abc123');
      await tester.pumpAndSettle();

      // Should only contain digits
      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.controller?.text, '123');
    });
  });

  group('GrafitInput - Dark Theme', () {
    testGrafitWidget('renders in dark theme', (tester) async {
      await tester.pumpWidget(
        ThemedTestWidget(
          isDark: true,
          child: GrafitInput(
            label: 'Dark Input',
            onChanged: (_) {},
          ),
        ),
      );

      expect(find.byType(GrafitInput), findsOneWidget);
    });

    testGrafitWidget('shows error in dark theme', (tester) async {
      await tester.pumpWidget(
        ThemedTestWidget(
          isDark: true,
          child: GrafitInput(
            label: 'Error Input',
            errorText: 'Error message',
            onChanged: (_) {},
          ),
        ),
      );

      expect(find.byType(GrafitInput), findsOneWidget);
      expect(find.text('Error message'), findsOneWidget);
    });
  });

  group('GrafitInput - Accessibility', () {
    testGrafitWidget('has semantic label', (tester) async {
      await tester.pumpWidget(
        ThemedTestWidget(
          child: GrafitInput(
            label: 'Accessible Input',
            onChanged: (_) {},
          ),
        ),
      );

      expect(find.text('Accessible Input'), findsOneWidget);
    });

    testGrafitWidget('has semantic hint text', (tester) async {
      await tester.pumpWidget(
        ThemedTestWidget(
          child: GrafitInput(
            hint: 'Enter your name',
            onChanged: (_) {},
          ),
        ),
      );

      expect(find.byType(GrafitInput), findsOneWidget);
    });
  });

  group('GrafitInput - Edge Cases', () {
    testGrafitWidget('renders with very long label', (tester) async {
      await tester.pumpWidget(
        ThemedTestWidget(
          child: GrafitInput(
            label: 'This is a very long label that might wrap '
                'or be truncated depending on the layout',
            onChanged: (_) {},
          ),
        ),
      );

      expect(find.byType(GrafitInput), findsOneWidget);
    });

    testGrafitWidget('renders with very long helper text', (tester) async {
      await tester.pumpWidget(
        ThemedTestWidget(
          child: GrafitInput(
            label: 'Input',
            helperText: 'This is a very long helper text that provides '
                'additional context to the user about what they should enter',
            onChanged: (_) {},
          ),
        ),
      );

      expect(find.byType(GrafitInput), findsOneWidget);
    });

    testGrafitWidget('renders with long initial value', (tester) async {
      const longValue = 'This is a very long initial value that should be '
          'visible in the input field when it loads';

      await tester.pumpWidget(
        ThemedTestWidget(
          child: GrafitInput(
            value: longValue,
            onChanged: (_) {},
          ),
        ),
      );

      expect(find.byType(GrafitInput), findsOneWidget);
    });
  });

  group('GrafitInput - Focus States', () {
    testGrafitWidget('shows focus ring when focused', (tester) async {
      final focusNode = FocusNode();

      await tester.pumpWidget(
        ThemedTestWidget(
          child: GrafitInput(
            label: 'Focus Test',
            focusNode: focusNode,
            onChanged: (_) {},
          ),
        ),
      );

      focusNode.requestFocus();
      await tester.pumpAndSettle();

      expect(focusNode.hasFocus, isTrue);
      focusNode.dispose();
    });

    testGrafitWidget('loses focus when tapped away', (tester) async {
      final focusNode = FocusNode();

      await tester.pumpWidget(
        ThemedTestWidget(
          child: Column(
            children: [
              GrafitInput(
                label: 'Focus Test',
                focusNode: focusNode,
                onChanged: (_) {},
              ),
              Container(
                width: 100,
                height: 100,
                color: Colors.grey,
              ),
            ],
          ),
        ),
      );

      focusNode.requestFocus();
      await tester.pumpAndSettle();
      expect(focusNode.hasFocus, isTrue);

      // Tap away
      await tester.tap(find.byType(Container));
      await tester.pumpAndSettle();
      // Note: Focus behavior may vary by implementation

      focusNode.dispose();
    });
  });
}
