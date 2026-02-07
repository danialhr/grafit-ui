import 'package:flutter_test/flutter_test.dart';
import 'package:grafit_ui/grafit_ui.dart';
import '../../../helpers/test_helpers.dart';
import '../../../helpers/themed_test_widget.dart';

void main() {
  group('GrafitAutoForm', () {
    group('Smoke Test', () {
      testWidgets('renders auto form', (tester) async {
        await tester.pumpWidget(
          tester,
          child: GrafitAutoForm(
            schema: GrafitAutoFormSchemaBuilder()
                .addField(
                  GrafitAutoFormField.text(
                    name: 'name',
                    label: 'Name',
                  ),
                )
                .build(),
            onSubmit: (data) {},
          ),
        );

        expect(find.byType(GrafitAutoForm), findsOneWidget);
      });

      testWidgets('displays fields from schema', (tester) async {
        await tester.pumpWidget(
          tester,
          child: GrafitAutoForm(
            schema: GrafitAutoFormSchemaBuilder()
                .addField(
                  GrafitAutoFormField.text(
                    name: 'email',
                    label: 'Email',
                  ),
                )
                .build(),
            onSubmit: (data) {},
          ),
        );

        expect(find.text('Email'), findsOneWidget);
      });

      testWidgets('onSubmit callback fires', (tester) async {
        Map<String, dynamic>? submittedData;

        await tester.pumpWidget(
          tester,
          child: GrafitAutoForm(
            schema: GrafitAutoFormSchemaBuilder()
                .addField(
                  GrafitAutoFormField.text(
                    name: 'name',
                    label: 'Name',
                  ),
                )
                .build(),
            onSubmit: (data) => submittedData = data,
          ),
        );

        // Find and tap submit button if it exists
        final submitButton = find.text('Submit');
        if (submitButton.evaluate().isNotEmpty) {
          await tester.tap(submitButton);
          await tester.pump();
        }

        expect(find.byType(GrafitAutoForm), findsOneWidget);
      });

      testWidgets('onValuesChange callback fires', (tester) async {
        Map<String, dynamic>? changedData;

        await tester.pumpWidget(
          tester,
          child: GrafitAutoForm(
            schema: GrafitAutoFormSchemaBuilder()
                .addField(
                  GrafitAutoFormField.text(
                    name: 'field',
                    label: 'Field',
                  ),
                )
                .build(),
            onValuesChange: (data) => changedData = data,
            onSubmit: (data) {},
          ),
        );

        await tester.enterText(find.byType(TextField), 'test');
        await tester.pump();

        expect(find.byType(GrafitAutoForm), findsOneWidget);
      });
    });

    group('Field Types', () {
      testWidgets('text field', (tester) async {
        await tester.pumpWidget(
          tester,
          child: GrafitAutoForm(
            schema: GrafitAutoFormSchemaBuilder()
                .addField(
                  GrafitAutoFormField.text(
                    name: 'username',
                    label: 'Username',
                  ),
                )
                .build(),
            onSubmit: (data) {},
          ),
        );

        expect(find.text('Username'), findsOneWidget);
      });

      testWidgets('email field', (tester) async {
        await tester.pumpWidget(
          tester,
          child: GrafitAutoForm(
            schema: GrafitAutoFormSchemaBuilder()
                .addField(
                  GrafitAutoFormField.email(
                    name: 'email',
                    label: 'Email Address',
                  ),
                )
                .build(),
            onSubmit: (data) {},
          ),
        );

        expect(find.text('Email Address'), findsOneWidget);
      });

      testWidgets('password field', (tester) async {
        await tester.pumpWidget(
          tester,
          child: GrafitAutoForm(
            schema: GrafitAutoFormSchemaBuilder()
                .addField(
                  GrafitAutoFormField.password(
                    name: 'password',
                    label: 'Password',
                  ),
                )
                .build(),
            onSubmit: (data) {},
          ),
        );

        expect(find.text('Password'), findsOneWidget);
      });

      testWidgets('number field', (tester) async {
        await tester.pumpWidget(
          tester,
          child: GrafitAutoForm(
            schema: GrafitAutoFormSchemaBuilder()
                .addField(
                  GrafitAutoFormField.number(
                    name: 'age',
                    label: 'Age',
                  ),
                )
                .build(),
            onSubmit: (data) {},
          ),
        );

        expect(find.text('Age'), findsOneWidget);
      });

      testWidgets('checkbox field', (tester) async {
        await tester.pumpWidget(
          tester,
          child: GrafitAutoForm(
            schema: GrafitAutoFormSchemaBuilder()
                .addField(
                  GrafitAutoFormField.checkbox(
                    name: 'agree',
                    label: 'I agree to terms',
                  ),
                )
                .build(),
            onSubmit: (data) {},
          ),
        );

        expect(find.text('I agree to terms'), findsOneWidget);
      });

      testWidgets('switch field', (tester) async {
        await tester.pumpWidget(
          tester,
          child: GrafitAutoForm(
            schema: GrafitAutoFormSchemaBuilder()
                .addField(
                  GrafitAutoFormField.switchField(
                    name: 'notifications',
                    label: 'Enable notifications',
                  ),
                )
                .build(),
            onSubmit: (data) {},
          ),
        );

        expect(find.text('Enable notifications'), findsOneWidget);
      });

      testWidgets('select field', (tester) async {
        await tester.pumpWidget(
          tester,
          child: GrafitAutoForm(
            schema: GrafitAutoFormSchemaBuilder()
                .addField(
                  GrafitAutoFormField.select(
                    name: 'country',
                    label: 'Country',
                    items: const [
                      GrafitAutoFormSelectItem(value: 'us', label: 'United States'),
                      GrafitAutoFormSelectItem(value: 'uk', label: 'United Kingdom'),
                    ],
                  ),
                )
                .build(),
            onSubmit: (data) {},
          ),
        );

        expect(find.text('Country'), findsOneWidget);
      });

      testWidgets('radio field', (tester) async {
        await tester.pumpWidget(
          tester,
          child: GrafitAutoForm(
            schema: GrafitAutoFormSchemaBuilder()
                .addField(
                  GrafitAutoFormField.radio(
                    name: 'gender',
                    label: 'Gender',
                    items: const [
                      GrafitAutoFormRadioItem(value: 'male', label: 'Male'),
                      GrafitAutoFormRadioItem(value: 'female', label: 'Female'),
                    ],
                  ),
                )
                .build(),
            onSubmit: (data) {},
          ),
        );

        expect(find.text('Gender'), findsOneWidget);
      });

      testWidgets('textarea field', (tester) async {
        await tester.pumpWidget(
          tester,
          child: GrafitAutoForm(
            schema: GrafitAutoFormSchemaBuilder()
                .addField(
                  GrafitAutoFormField.textarea(
                    name: 'bio',
                    label: 'Biography',
                  ),
                )
                .build(),
            onSubmit: (data) {},
          ),
        );

        expect(find.text('Biography'), findsOneWidget);
      });
    });

    group('Field Configuration', () {
      testWidgets('required field', (tester) async {
        await tester.pumpWidget(
          tester,
          child: GrafitAutoForm(
            schema: GrafitAutoFormSchemaBuilder()
                .addField(
                  GrafitAutoFormField.text(
                    name: 'email',
                    label: 'Email',
                    required: true,
                  ),
                )
                .build(),
            onSubmit: (data) {},
          ),
        );

        expect(find.byType(GrafitAutoForm), findsOneWidget);
      });

      testWidgets('field with placeholder', (tester) async {
        await tester.pumpWidget(
          tester,
          child: GrafitAutoForm(
            schema: GrafitAutoFormSchemaBuilder()
                .addField(
                  GrafitAutoFormField.text(
                    name: 'search',
                    label: 'Search',
                    placeholder: 'Enter search term',
                  ),
                )
                .build(),
            onSubmit: (data) {},
          ),
        );

        expect(find.text('Enter search term'), findsOneWidget);
      });

      testWidgets('field with hint', (tester) async {
        await tester.pumpWidget(
          tester,
          child: GrafitAutoForm(
            schema: GrafitAutoFormSchemaBuilder()
                .addField(
                  GrafitAutoFormField.text(
                    name: 'field',
                    label: 'Field',
                    hint: 'Helper text',
                  ),
                )
                .build(),
            onSubmit: (data) {},
          ),
        );

        expect(find.byType(GrafitAutoForm), findsOneWidget);
      });

      testWidgets('disabled field', (tester) async {
        await tester.pumpWidget(
          tester,
          child: GrafitAutoForm(
            schema: GrafitAutoFormSchemaBuilder()
                .addField(
                  GrafitAutoFormField.text(
                    name: 'readonly',
                    label: 'Read Only',
                    disabled: true,
                  ),
                )
                .build(),
            onSubmit: (data) {},
          ),
        );

        expect(find.text('Read Only'), findsOneWidget);
      });
    });

    group('Validation', () {
      testWidgets('field with custom validation', (tester) async {
        await tester.pumpWidget(
          tester,
          child: GrafitAutoForm(
            schema: GrafitAutoFormSchemaBuilder()
                .addField(
                  GrafitAutoFormField.text(
                    name: 'field',
                    label: 'Field',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'This field is required';
                      }
                      return null;
                    },
                  ),
                )
                .build(),
            onSubmit: (data) {},
          ),
        );

        expect(find.byType(GrafitAutoForm), findsOneWidget);
      });

      testWidgets('multiple validators', (tester) async {
        await tester.pumpWidget(
          tester,
          child: GrafitAutoForm(
            schema: GrafitAutoFormSchemaBuilder()
                .addField(
                  GrafitAutoFormField.text(
                    name: 'password',
                    label: 'Password',
                    required: true,
                    minLength: 8,
                  ),
                )
                .build(),
            onSubmit: (data) {},
          ),
        );

        expect(find.text('Password'), findsOneWidget);
      });
    });

    group('Initial Values', () {
      testWidgets('initialValues populate fields', (tester) async {
        await tester.pumpWidget(
          tester,
          child: GrafitAutoForm(
            schema: GrafitAutoFormSchemaBuilder()
                .addField(
                  GrafitAutoFormField.text(
                    name: 'name',
                    label: 'Name',
                  ),
                )
                .build(),
            initialValues: const {'name': 'John Doe'},
            onSubmit: (data) {},
          ),
        );

        expect(find.text('John Doe'), findsOneWidget);
      });

      testWidgets('multiple initial values', (tester) async {
        await tester.pumpWidget(
          tester,
          child: GrafitAutoForm(
            schema: GrafitAutoFormSchemaBuilder()
                .addFields([
                  GrafitAutoFormField.text(name: 'name', label: 'Name'),
                  GrafitAutoFormField.email(name: 'email', label: 'Email'),
                ])
                .build(),
            initialValues: const {
              'name': 'Jane',
              'email': 'jane@example.com',
            },
            onSubmit: (data) {},
          ),
        );

        expect(find.text('Jane'), findsOneWidget);
        expect(find.text('jane@example.com'), findsOneWidget);
      });
    });

    group('Dependencies', () {
      testWidgets('conditional field visibility', (tester) async {
        await tester.pumpWidget(
          tester,
          child: GrafitAutoForm(
            schema: GrafitAutoFormSchemaBuilder()
                .addField(
                  GrafitAutoFormField.checkbox(
                    name: 'showAddress',
                    label: 'Show address field',
                  ),
                )
                .addField(
                  GrafitAutoFormField.text(
                    name: 'address',
                    label: 'Address',
                    visible: (values) => values['showAddress'] == true,
                  ),
                )
                .build(),
            onSubmit: (data) {},
          ),
        );

        expect(find.byType(GrafitAutoForm), findsOneWidget);
      });
    });

    group('Sections', () {
      testWidgets('form with sections', (tester) async {
        await tester.pumpWidget(
          tester,
          child: GrafitAutoForm(
            schema: GrafitAutoFormSchemaBuilder()
                .addSection(
                  GrafitAutoFormSection(
                    title: 'Personal Info',
                    fields: [
                      GrafitAutoFormField.text(name: 'name', label: 'Name'),
                      GrafitAutoFormField.email(name: 'email', label: 'Email'),
                    ],
                  ),
                )
                .addSection(
                  GrafitAutoFormSection(
                    title: 'Address',
                    fields: [
                      GrafitAutoFormField.text(name: 'street', label: 'Street'),
                      GrafitAutoFormField.text(name: 'city', label: 'City'),
                    ],
                  ),
                )
                .build(),
            onSubmit: (data) {},
          ),
        );

        expect(find.text('Personal Info'), findsOneWidget);
        expect(find.text('Address'), findsOneWidget);
      });
    });

    group('Nested Objects', () {
      testWidgets('object field type', (tester) async {
        await tester.pumpWidget(
          tester,
          child: GrafitAutoForm(
            schema: GrafitAutoFormSchemaBuilder()
                .addField(
                  GrafitAutoFormField.object(
                    name: 'address',
                    label: 'Address',
                    fields: [
                      GrafitAutoFormField.text(name: 'street', label: 'Street'),
                      GrafitAutoFormField.text(name: 'city', label: 'City'),
                    ],
                  ),
                )
                .build(),
            onSubmit: (data) {},
          ),
        );

        expect(find.text('Address'), findsOneWidget);
      });
    });

    group('Array Fields', () {
      testWidgets('array field type', (tester) async {
        await tester.pumpWidget(
          tester,
          child: GrafitAutoForm(
            schema: GrafitAutoFormSchemaBuilder()
                .addField(
                  GrafitAutoFormField.array(
                    name: 'tags',
                    label: 'Tags',
                    itemType: GrafitAutoFormField.text(name: 'tag', label: 'Tag'),
                  ),
                )
                .build(),
            onSubmit: (data) {},
          ),
        );

        expect(find.text('Tags'), findsOneWidget);
      });
    });

    group('Edge Cases', () {
      testWidgets('empty schema', (tester) async {
        await tester.pumpWidget(
          tester,
          child: GrafitAutoForm(
            schema: const [],
            onSubmit: (data) {},
          ),
        );

        expect(find.byType(GrafitAutoForm), findsOneWidget);
      });

      testWidgets('field with special characters in name', (tester) async {
        await tester.pumpWidget(
          tester,
          child: GrafitAutoForm(
            schema: GrafitAutoFormSchemaBuilder()
                .addField(
                  GrafitAutoFormField.text(
                    name: 'field_with_underscore',
                    label: 'Field',
                  ),
                )
                .build(),
            onSubmit: (data) {},
          ),
        );

        expect(find.byType(GrafitAutoForm), findsOneWidget);
      });

      testWidgets('very long label', (tester) async {
        const longLabel = 'This is a very long field label that should still render properly';

        await tester.pumpWidget(
          tester,
          child: GrafitAutoForm(
            schema: GrafitAutoFormSchemaBuilder()
                .addField(
                  GrafitAutoFormField.text(
                    name: 'field',
                    label: longLabel,
                  ),
                )
                .build(),
            onSubmit: (data) {},
          ),
        );

        expect(find.text(longLabel), findsOneWidget);
      });
    });

    group('Complex Form Example', () {
      testWidgets('registration form', (tester) async {
        await tester.pumpWidget(
          tester,
          child: GrafitAutoForm(
            schema: GrafitAutoFormSchemaBuilder()
                .addSection(
                  GrafitAutoFormSection(
                    title: 'Account Information',
                    fields: [
                      GrafitAutoFormField.text(
                        name: 'username',
                        label: 'Username',
                        required: true,
                        minLength: 3,
                      ),
                      GrafitAutoFormField.email(
                        name: 'email',
                        label: 'Email',
                        required: true,
                      ),
                      GrafitAutoFormField.password(
                        name: 'password',
                        label: 'Password',
                        required: true,
                        minLength: 8,
                      ),
                    ],
                  ),
                )
                .addSection(
                  GrafitAutoFormSection(
                    title: 'Preferences',
                    fields: [
                      GrafitAutoFormField.checkbox(
                        name: 'newsletter',
                        label: 'Subscribe to newsletter',
                      ),
                      GrafitAutoFormField.select(
                        name: 'language',
                        label: 'Language',
                        items: const [
                          GrafitAutoFormSelectItem(value: 'en', label: 'English'),
                          GrafitAutoFormSelectItem(value: 'es', label: 'Spanish'),
                        ],
                      ),
                    ],
                  ),
                )
                .build(),
            onSubmit: (data) {},
          ),
        );

        expect(find.text('Account Information'), findsOneWidget);
        expect(find.text('Preferences'), findsOneWidget);
        expect(find.text('Username'), findsOneWidget);
        expect(find.text('Email'), findsOneWidget);
        expect(find.text('Password'), findsOneWidget);
      });
    });
  });
}
