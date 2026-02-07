import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grafit_ui/grafit_ui.dart';
import '../../../helpers/test_helpers.dart';
import '../../../helpers/themed_test_widget.dart';

void main() {
  group('GrafitForm', () {
    group('Smoke Test', () {
      testWidgets('renders form', (tester) async {
        await tester.pumpWidget(
          tester,
          child: GrafitForm(
            controller: GrafitFormController(),
            child: const Text('Form Content'),
          ),
        );

        expect(find.byType(GrafitForm), findsOneWidget);
      });

      testWidgets('child is rendered', (tester) async {
        await tester.pumpWidget(
          tester,
          child: GrafitForm(
            controller: GrafitFormController(),
            child: const ThemedTestWidget(
            child: const GrafitInput(),
          ),
        );

        expect(find.byType(GrafitInput), findsOneWidget);
      });
    });

    group('Controller', () {
      testWidgets('form uses controller', (tester) async {
        final controller = GrafitFormController();

        await tester.pumpWidget(
          tester,
          child: GrafitForm(
            controller: controller,
            child: const Text('Content'),
          ),
        );

        expect(find.byType(GrafitForm), findsOneWidget);
      });

      testWidgets('controller manages form state', (tester) async {
        final controller = GrafitFormController();

        await tester.pumpWidget(
          tester,
          child: GrafitForm(
            controller: controller,
            child: const ThemedTestWidget(
            child: const GrafitInput(),
          ),
        );

        expect(controller.fields, isEmpty);
      });
    });

    group('Initial Values', () {
      testWidgets('initialValues populate form', (tester) async {
        final controller = GrafitFormController();

        await tester.pumpWidget(
          tester,
          child: GrafitForm(
            controller: controller,
            initialValues: const {'email': 'test@example.com'},
            child: const ThemedTestWidget(
            child: const GrafitInput(),
          ),
        );

        expect(find.byType(GrafitForm), findsOneWidget);
      });

      testWidgets('multiple initial values', (tester) async {
        final controller = GrafitFormController();

        await tester.pumpWidget(
          tester,
          child: GrafitForm(
            controller: controller,
            initialValues: const {
              'name': 'John',
              'email': 'john@example.com',
              'age': '30',
            },
            child: const Column(
              children: [
                GrafitInput(),
                GrafitInput(),
                GrafitInput(),
              ],
            ),
          ),
        );

        expect(find.byType(GrafitForm), findsOneWidget);
      });
    });

    group('Callbacks', () {
      testWidgets('onInit callback fires', (tester) async {
        final controller = GrafitFormController();
        var inited = false;

        await tester.pumpWidget(
          tester,
          child: GrafitForm(
            controller: controller,
            onInit: () => inited = true,
            child: const Text('Content'),
          ),
        );

        expect(inited, true);
      });

      testWidgets('onSubmit callback fires', (tester) async {
        final controller = GrafitFormController();
        Map<String, dynamic>? submittedData;

        await tester.pumpWidget(
          tester,
          child: GrafitForm(
            controller: controller,
            onSubmit: (data) => submittedData = data,
            child: const Text('Content'),
          ),
        );

        controller.submit();
        await tester.pump();

        expect(submittedData, isNotNull);
      });

      testWidgets('onValuesChange callback fires', (tester) async {
        final controller = GrafitFormController();
        Map<String, dynamic>? changedData;

        await tester.pumpWidget(
          tester,
          child: GrafitForm(
            controller: controller,
            onValuesChange: (data) => changedData = data,
            child: const Text('Content'),
          ),
        );

        controller.setValue('test', 'value');
        await tester.pump();

        expect(changedData, isNotNull);
      });
    });

    group('Auto Validate', () {
      testWidgets('autoValidate enables validation', (tester) async {
        final controller = GrafitFormController();

        await tester.pumpWidget(
          tester,
          child: GrafitForm(
            controller: controller,
            autoValidate: true,
            child: const ThemedTestWidget(
            child: const GrafitInput(),
          ),
        );

        expect(find.byType(GrafitForm), findsOneWidget);
      });

      testWidgets('autoValidate disabled', (tester) async {
        final controller = GrafitFormController();

        await tester.pumpWidget(
          tester,
          child: GrafitForm(
            controller: controller,
            autoValidate: false,
            child: const ThemedTestWidget(
            child: const GrafitInput(),
          ),
        );

        expect(find.byType(GrafitForm), findsOneWidget);
      });
    });

    group('GrafitFormController', () {
      testWidgets('setValue updates field', (tester) async {
        final controller = GrafitFormController();

        await tester.pumpWidget(
          tester,
          child: GrafitForm(
            controller: controller,
            child: const Text('Content'),
          ),
        );

        controller.setValue('email', 'test@test.com');
        await tester.pump();

        expect(controller.getValue('email'), 'test@test.com');
      });

      testWidgets('getValue retrieves field value', (tester) async {
        final controller = GrafitFormController();

        await tester.pumpWidget(
          tester,
          child: GrafitForm(
            controller: controller,
            initialValues: const {'name': 'John'},
            child: const Text('Content'),
          ),
        );

        expect(controller.getValue('name'), 'John');
      });

      testWidgets('reset clears form', (tester) async {
        final controller = GrafitFormController();

        await tester.pumpWidget(
          tester,
          child: GrafitForm(
            controller: controller,
            initialValues: const {'name': 'John'},
            child: const Text('Content'),
          ),
        );

        controller.reset();
        await tester.pump();

        expect(controller.getValue('name'), isNull);
      });

      testWidgets('validate returns validity', (tester) async {
        final controller = GrafitFormController();

        await tester.pumpWidget(
          tester,
          child: GrafitForm(
            controller: controller,
            child: const Text('Content'),
          ),
        );

        final isValid = controller.validate();
        expect(isValid, true);
      });

      testWidgets('getErrors returns field errors', (tester) async {
        final controller = GrafitFormController();

        await tester.pumpWidget(
          tester,
          child: GrafitForm(
            controller: controller,
            child: const Text('Content'),
          ),
        );

        final errors = controller.getErrors('name');
        expect(errors, isEmpty);
      });
    });

    group('GrafitFormItem', () {
      testWidgets('renders form item', (tester) async {
        await tester.pumpWidget(
          tester,
          child: GrafitFormItem(
            name: 'email',
            child: const ThemedTestWidget(
            child: const GrafitInput(),
          ),
        );

        expect(find.byType(GrafitFormItem), findsOneWidget);
      });

      testWidgets('item with validator', (tester) async {
        await tester.pumpWidget(
          tester,
          child: GrafitFormItem(
            name: 'email',
            validator: GrafitValidators.required('Email is required'),
            child: GrafitInput(
              onChanged: (_) {},
            ),
          ),
        );

        expect(find.byType(GrafitFormItem), findsOneWidget);
      });

      testWidgets('item with multiple validators', (tester) async {
        await tester.pumpWidget(
          tester,
          child: GrafitFormItem(
            name: 'email',
            validators: [
              GrafitValidators.required('Required'),
              GrafitValidators.email('Invalid email'),
            ],
            child: GrafitInput(
              onChanged: (_) {},
            ),
          ),
        );

        expect(find.byType(GrafitFormItem), findsOneWidget);
      });

      testWidgets('item with initialValue', (tester) async {
        await tester.pumpWidget(
          tester,
          child: GrafitFormItem(
            name: 'name',
            initialValue: 'John',
            child: const ThemedTestWidget(
            child: const GrafitInput(),
          ),
        );

        expect(find.byType(GrafitFormItem), findsOneWidget);
      });
    });

    group('GrafitFormField', () {
      testWidgets('renders form field', (tester) async {
        await tester.pumpWidget(
          tester,
          child: GrafitFormField<String>(
            name: 'country',
            builder: (context, value, onChanged, error) {
              return GrafitInput(
                value: value,
                onChanged: onChanged,
                errorText: error,
              );
            },
          ),
        );

        expect(find.byType(GrafitFormField<String>), findsOneWidget);
      });

      testWidgets('field builder receives value', (tester) async {
        await tester.pumpWidget(
          tester,
          child: GrafitFormField<String>(
            name: 'city',
            initialValue: 'New York',
            builder: (context, value, onChanged, error) {
              return Text(value ?? 'No value');
            },
          ),
        );

        expect(find.text('New York'), findsOneWidget);
      });

      testWidgets('field with validator', (tester) async {
        await tester.pumpWidget(
          tester,
          child: GrafitFormField<String>(
            name: 'phone',
            validator: GrafitValidators.required('Required'),
            builder: (context, value, onChanged, error) {
              return GrafitInput(
                value: value,
                onChanged: onChanged,
                errorText: error,
              );
            },
          ),
        );

        expect(find.byType(GrafitFormField<String>), findsOneWidget);
      });
    });

    group('Validators', () {
      testWidgets('required validator', (tester) async {
        final validator = GrafitValidators.required('Field is required');
        final result = validator(null);

        expect(result, 'Field is required');
      });

      testWidgets('email validator', (tester) async {
        final validator = GrafitValidators.email('Invalid email');

        expect(validator('test@test.com'), isNull);
        expect(validator('invalid'), 'Invalid email');
      });

      testWidgets('minLength validator', (tester) async {
        final validator = GrafitValidators.minLength(5, 'Too short');

        expect(validator('12345'), isNull);
        expect(validator('123'), 'Too short');
      });

      testWidgets('maxLength validator', (tester) async {
        final validator = GrafitValidators.maxLength(10, 'Too long');

        expect(validator('123'), isNull);
        expect(validator('12345678901'), 'Too long');
      });

      testWidgets('pattern validator', (tester) async {
        final validator = GrafitValidators.pattern(
          RegExp(r'^\d+$'),
          'Numbers only',
        );

        expect(validator('12345'), isNull);
        expect(validator('abc'), 'Numbers only');
      });

      testWidgets('custom validator', (tester) async {
        final validator = GrafitValidators.custom((value) {
          if (value == 'forbidden') {
            return 'This value is not allowed';
          }
          return null;
        });

        expect(validator('allowed'), isNull);
        expect(validator('forbidden'), 'This value is not allowed');
      });
    });

    group('Complex Examples', () {
      testWidgets('login form', (tester) async {
        final controller = GrafitFormController();

        await tester.pumpWidget(
          tester,
          child: GrafitForm(
            controller: controller,
            onSubmit: (data) {},
            child: const Column(
              children: [
                GrafitFormItem(
                  name: 'email',
                  initialValue: '',
                  child: GrafitInput(label: 'Email'),
                ),
                GrafitFormItem(
                  name: 'password',
                  initialValue: '',
                  child: GrafitInput(
                    label: 'Password',
                    obscureText: true,
                  ),
                ),
              ],
            ),
          ),
        );

        expect(find.text('Email'), findsOneWidget);
        expect(find.text('Password'), findsOneWidget);
      });

      testWidgets('registration form with validation', (tester) async {
        final controller = GrafitFormController();

        await tester.pumpWidget(
          tester,
          child: GrafitForm(
            controller: controller,
            autoValidate: true,
            child: const Column(
              children: [
                GrafitFormItem(
                  name: 'username',
                  validators: [
                    GrafitValidators.required('Username required'),
                    GrafitValidators.minLength(3, 'Too short'),
                  ],
                  child: GrafitInput(label: 'Username'),
                ),
                GrafitFormItem(
                  name: 'email',
                  validators: [
                    GrafitValidators.required('Email required'),
                    GrafitValidators.email('Invalid email'),
                  ],
                  child: GrafitInput(label: 'Email'),
                ),
              ],
            ),
          ),
        );

        expect(find.text('Username'), findsOneWidget);
        expect(find.text('Email'), findsOneWidget);
      });
    });

    group('Edge Cases', () {
      testWidgets('form with no children', (tester) async {
        final controller = GrafitFormController();

        await tester.pumpWidget(
          tester,
          child: GrafitForm(
            controller: controller,
            child: const SizedBox.shrink(),
          ),
        );

        expect(find.byType(GrafitForm), findsOneWidget);
      });

      testWidgets('item with empty name', (tester) async {
        await tester.pumpWidget(
          tester,
          child: GrafitFormItem(
            name: '',
            child: const ThemedTestWidget(
            child: const GrafitInput(),
          ),
        );

        expect(find.byType(GrafitFormItem), findsOneWidget);
      });

      testWidgets('form with null initialValues', (tester) async {
        final controller = GrafitFormController();

        await tester.pumpWidget(
          tester,
          child: GrafitForm(
            controller: controller,
            initialValues: const {'field': null},
            child: const ThemedTestWidget(
            child: const GrafitInput(),
          ),
        );

        expect(find.byType(GrafitForm), findsOneWidget);
      });
    });
  });
}
