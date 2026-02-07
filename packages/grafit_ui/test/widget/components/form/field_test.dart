import 'package:flutter_test/flutter_test.dart';
import 'package:grafit_ui/grafit_ui.dart';
import '../../../helpers/test_helpers.dart';
import '../../../helpers/themed_test_widget.dart';

void main() {
  group('GrafitField', () {
    group('Smoke Test', () {
      testWidgets('renders field', (tester) async {
        await tester.pumpWidget(
          tester,
          child: GrafitField(
            child: const ThemedTestWidget(
            child: const GrafitInput(),
          ),
        );

        expect(find.byType(GrafitField), findsOneWidget);
      });

      testWidgets('child is rendered', (tester) async {
        await tester.pumpWidget(
          tester,
          child: GrafitField(
            child: const ThemedTestWidget(
            child: const GrafitInput(),
          ),
        );

        expect(find.byType(GrafitInput), findsOneWidget);
      });
    });

    group('Orientation', () {
      testWidgets('vertical orientation (default)', (tester) async {
        await tester.pumpWidget(
          tester,
          child: GrafitField(
            orientation: GrafitFieldOrientation.vertical,
            child: const ThemedTestWidget(
            child: const GrafitInput(),
          ),
        );

        expect(find.byType(Column), findsWidgets);
      });

      testWidgets('horizontal orientation', (tester) async {
        await tester.pumpWidget(
          tester,
          child: GrafitField(
            orientation: GrafitFieldOrientation.horizontal,
            child: const ThemedTestWidget(
            child: const GrafitInput(),
          ),
        );

        expect(find.byType(Row), findsWidgets);
      });

      testWidgets('responsive orientation', (tester) async {
        await tester.pumpWidget(
          tester,
          child: GrafitField(
            orientation: GrafitFieldOrientation.responsive,
            child: const ThemedTestWidget(
            child: const GrafitInput(),
          ),
        );

        expect(find.byType(GrafitField), findsOneWidget);
      });
    });

    group('States', () {
      testWidgets('invalid state', (tester) async {
        await tester.pumpWidget(
          tester,
          child: GrafitField(
            invalid: true,
            child: const ThemedTestWidget(
            child: const GrafitInput(),
          ),
        );

        expect(find.byType(GrafitField), findsOneWidget);
      });

      testWidgets('disabled state', (tester) async {
        await tester.pumpWidget(
          tester,
          child: GrafitField(
            disabled: true,
            child: const ThemedTestWidget(
            child: const GrafitInput(),
          ),
        );

        expect(find.byType(GrafitField), findsOneWidget);
      });

      testWidgets('invalid and disabled together', (tester) async {
        await tester.pumpWidget(
          tester,
          child: GrafitField(
            invalid: true,
            disabled: true,
            child: const ThemedTestWidget(
            child: const GrafitInput(),
          ),
        );

        expect(find.byType(GrafitField), findsOneWidget);
      });
    });

    group('Field Name', () {
      testWidgets('fieldName is used for identification', (tester) async {
        await tester.pumpWidget(
          tester,
          child: GrafitField(
            fieldName: 'email',
            child: const ThemedTestWidget(
            child: const GrafitInput(),
          ),
        );

        expect(find.byType(GrafitField), findsOneWidget);
      });
    });

    group('Padding', () {
      testWidgets('default padding', (tester) async {
        await tester.pumpWidget(
          tester,
          child: GrafitField(
            child: const ThemedTestWidget(
            child: const GrafitInput(),
          ),
        );

        expect(find.byType(GrafitField), findsOneWidget);
      });

      testWidgets('custom padding', (tester) async {
        await tester.pumpWidget(
          tester,
          child: GrafitField(
            padding: const EdgeInsets.all(20),
            child: const ThemedTestWidget(
            child: const GrafitInput(),
          ),
        );

        expect(find.byType(GrafitField), findsOneWidget);
      });

      testWidgets('zero padding', (tester) async {
        await tester.pumpWidget(
          tester,
          child: GrafitField(
            padding: EdgeInsets.zero,
            child: const ThemedTestWidget(
            child: const GrafitInput(),
          ),
        );

        expect(find.byType(GrafitField), findsOneWidget);
      });
    });

    group('GrafitFieldSet', () {
      testWidgets('renders field set', (tester) async {
        await tester.pumpWidget(
          tester,
          child: const ThemedTestWidget(
            child: const GrafitFieldSet(
            label: 'Personal Information',
            child: Text('Content'),
          ),
        );

        expect(find.byType(GrafitFieldSet), findsOneWidget);
      });

      testWidgets('label is displayed', (tester) async {
        await tester.pumpWidget(
          tester,
          child: const ThemedTestWidget(
            child: const GrafitFieldSet(
            label: 'Contact Info',
            child: Text('Fields'),
          ),
        );

        expect(find.text('Contact Info'), findsOneWidget);
      });

      testWidgets('child is rendered', (tester) async {
        await tester.pumpWidget(
          tester,
          child: const ThemedTestWidget(
            child: const GrafitFieldSet(
            label: 'Section',
            child: Text('Content'),
          ),
        );

        expect(find.text('Content'), findsOneWidget);
      });

      testWidgets('required field set', (tester) async {
        await tester.pumpWidget(
          tester,
          child: const ThemedTestWidget(
            child: const GrafitFieldSet(
            label: 'Required',
            required: true,
            child: Text('Content'),
          ),
        );

        expect(find.text('Required'), findsOneWidget);
        expect(find.text(' *'), findsOneWidget);
      });

      testWidgets('disabled field set', (tester) async {
        await tester.pumpWidget(
          tester,
          child: const ThemedTestWidget(
            child: const GrafitFieldSet(
            label: 'Disabled',
            disabled: true,
            child: Text('Content'),
          ),
        );

        expect(find.text('Disabled'), findsOneWidget);
      });

      testWidgets('invalid field set', (tester) async {
        await tester.pumpWidget(
          tester,
          child: const ThemedTestWidget(
            child: const GrafitFieldSet(
            label: 'Invalid',
            invalid: true,
            child: Text('Content'),
          ),
        );

        expect(find.text('Invalid'), findsOneWidget);
      });
    });

    group('GrafitFieldGroup', () {
      testWidgets('renders field group', (tester) async {
        await tester.pumpWidget(
          tester,
          child: GrafitFieldGroup(
            children: [
              GrafitField(
                child: const ThemedTestWidget(
            child: const GrafitInput(),
              ),
              GrafitField(
                child: const ThemedTestWidget(
            child: const GrafitInput(),
              ),
            ],
          ),
        );

        expect(find.byType(GrafitFieldGroup), findsOneWidget);
      });

      testWidgets('all children are rendered', (tester) async {
        await tester.pumpWidget(
          tester,
          child: GrafitFieldGroup(
            children: [
              GrafitField(
                child: const ThemedTestWidget(
            child: const GrafitInput(hint: 'Field 1'),
              ),
              GrafitField(
                child: const ThemedTestWidget(
            child: const GrafitInput(hint: 'Field 2'),
              ),
              GrafitField(
                child: const ThemedTestWidget(
            child: const GrafitInput(hint: 'Field 3'),
              ),
            ],
          ),
        );

        expect(find.byType(GrafitInput), findsNWidgets(3));
      });

      testWidgets('group with spacing', (tester) async {
        await tester.pumpWidget(
          tester,
          child: GrafitFieldGroup(
            spacing: 20,
            children: [
              GrafitField(
                child: const ThemedTestWidget(
            child: const GrafitInput(),
              ),
              GrafitField(
                child: const ThemedTestWidget(
            child: const GrafitInput(),
              ),
            ],
          ),
        );

        expect(find.byType(GrafitFieldGroup), findsOneWidget);
      });

      testWidgets('group with orientation', (tester) async {
        await tester.pumpWidget(
          tester,
          child: GrafitFieldGroup(
            orientation: GrafitFieldOrientation.horizontal,
            children: [
              GrafitField(
                child: const ThemedTestWidget(
            child: const GrafitInput(),
              ),
              GrafitField(
                child: const ThemedTestWidget(
            child: const GrafitInput(),
              ),
            ],
          ),
        );

        expect(find.byType(Row), findsWidgets);
      });
    });

    group('GrafitFieldError', () {
      testWidgets('renders field error', (tester) async {
        await tester.pumpWidget(
          tester,
          child: const ThemedTestWidget(
            child: const GrafitFieldError(
            message: 'This field is required',
          ),
        );

        expect(find.byType(GrafitFieldError), findsOneWidget);
      });

      testWidgets('error message is displayed', (tester) async {
        await tester.pumpWidget(
          tester,
          child: const ThemedTestWidget(
            child: const GrafitFieldError(
            message: 'Invalid email format',
          ),
        );

        expect(find.text('Invalid email format'), findsOneWidget);
      });

      testWidgets('empty message renders', (tester) async {
        await tester.pumpWidget(
          tester,
          child: const ThemedTestWidget(
            child: const GrafitFieldError(message: ''),
        );

        expect(find.byType(GrafitFieldError), findsOneWidget);
      });

      testWidgets('error with icon', (tester) async {
        await tester.pumpWidget(
          tester,
          child: const ThemedTestWidget(
            child: const GrafitFieldError(
            message: 'Error occurred',
            showIcon: true,
          ),
        );

        expect(find.text('Error occurred'), findsOneWidget);
      });
    });

    group('Complex Examples', () {
      testWidgets('field with input and label', (tester) async {
        await tester.pumpWidget(
          tester,
          child: GrafitField(
            child: GrafitInput(
              label: 'Email',
              hint: 'Enter your email',
              onChanged: (_) {},
            ),
          ),
        );

        expect(find.text('Email'), findsOneWidget);
        expect(find.text('Enter your email'), findsOneWidget);
      });

      testWidgets('field set with multiple fields', (tester) async {
        await tester.pumpWidget(
          tester,
          child: const ThemedTestWidget(
            child: const GrafitFieldSet(
            label: 'Address',
            child: Column(
              children: [
                GrafitInput(hint: 'Street'),
                GrafitInput(hint: 'City'),
              ],
            ),
          ),
        );

        expect(find.text('Address'), findsOneWidget);
        expect(find.byType(GrafitInput), findsNWidgets(2));
      });

      testWidgets('nested field groups', (tester) async {
        await tester.pumpWidget(
          tester,
          child: GrafitFieldGroup(
            children: [
              GrafitField(
                child: GrafitInput(
                  label: 'Name',
                  hint: 'Full name',
                  onChanged: (_) {},
                ),
              ),
              GrafitFieldGroup(
                spacing: 10,
                children: [
                  GrafitField(
                    child: GrafitInput(
                      label: 'Email',
                      hint: 'Email address',
                      onChanged: (_) {},
                    ),
                  ),
                  GrafitField(
                    child: GrafitInput(
                      label: 'Phone',
                      hint: 'Phone number',
                      onChanged: (_) {},
                    ),
                  ),
                ],
              ),
            ],
          ),
        );

        expect(find.text('Name'), findsOneWidget);
        expect(find.text('Email'), findsOneWidget);
        expect(find.text('Phone'), findsOneWidget);
      });

      testWidgets('field with error state', (tester) async {
        await tester.pumpWidget(
          tester,
          child: GrafitField(
            invalid: true,
            child: Column(
              children: [
                GrafitInput(
                  label: 'Password',
                  hint: 'Enter password',
                  errorText: 'Password is too short',
                  onChanged: (_) {},
                ),
                const GrafitFieldError(
                  message: 'Must be at least 8 characters',
                ),
              ],
            ),
          ),
        );

        expect(find.text('Password is too short'), findsOneWidget);
        expect(find.text('Must be at least 8 characters'), findsOneWidget);
      });
    });

    group('Edge Cases', () {
      testWidgets('empty field group', (tester) async {
        await tester.pumpWidget(
          tester,
          child: GrafitFieldGroup(
            children: const [],
          ),
        );

        expect(find.byType(GrafitFieldGroup), findsOneWidget);
      });

      testWidgets('field with null children', (tester) async {
        await tester.pumpWidget(
          tester,
          child: GrafitField(
            child: const SizedBox.shrink(),
          ),
        );

        expect(find.byType(GrafitField), findsOneWidget);
      });

      testWidgets('field set with long label', (tester) async {
        const longLabel = 'This is a very long label for the field set component';

        await tester.pumpWidget(
          tester,
          child: const ThemedTestWidget(
            child: const GrafitFieldSet(
            label: longLabel,
            child: Text('Content'),
          ),
        );

        expect(find.text(longLabel), findsOneWidget);
      });

      testWidgets('field error with very long message', (tester) async {
        const longMessage = 'This is a very long error message that should be displayed properly';

        await tester.pumpWidget(
          tester,
          child: GrafitFieldError(
            message: longMessage,
          ),
        );

        expect(find.text(longMessage), findsOneWidget);
      });
    });

    group('Responsive Behavior', () {
      testWidgets('responsive field changes orientation', (tester) async {
        await tester.pumpWidget(
          tester,
          child: Builder(
            builder: (context) {
              final width = MediaQuery.of(context).size.width;
              return GrafitField(
                orientation: GrafitFieldOrientation.responsive,
                child: const ThemedTestWidget(
            child: const GrafitInput(),
              );
            },
          ),
        );

        expect(find.byType(GrafitField), findsOneWidget);
      });
    });
  });
}
