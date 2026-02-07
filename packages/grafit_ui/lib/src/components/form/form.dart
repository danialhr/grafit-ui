import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import '../../theme/theme.dart';
import '../../theme/theme_data.dart';
import 'label.dart';

/// Form field value type - can be any type
typedef FormFieldValue = dynamic;

/// Form field validator function type
typedef FormFieldValidator<T> = String? Function(T? value);

/// Form field async validator function type
typedef AsyncFormFieldValidator<T> = Future<String?> Function(T? value);

/// Form data model with generic type support
class GrafitFormData<T> {
  final Map<String, dynamic> _values = {};
  final Map<String, String?> _errors = {};
  final Map<String, bool> _touched = {};

  /// Get all values
  Map<String, dynamic> get values => Map.unmodifiable(_values);

  /// Get all errors
  Map<String, String?> get errors => Map.unmodifiable(_errors);

  /// Get all touched fields
  Map<String, bool> get touched => Map.unmodifiable(_touched);

  /// Get a value by field name
  T? getValue<T>(String fieldName) {
    return _values[fieldName] as T?;
  }

  /// Set a value by field name
  void setValue(String fieldName, dynamic value) {
    _values[fieldName] = value;
  }

  /// Get an error by field name
  String? getError(String fieldName) {
    return _errors[fieldName];
  }

  /// Set an error by field name
  void setError(String fieldName, String? error) {
    if (error == null) {
      _errors.remove(fieldName);
    } else {
      _errors[fieldName] = error;
    }
  }

  /// Check if field is touched
  bool isTouched(String fieldName) {
    return _touched[fieldName] ?? false;
  }

  /// Set field as touched
  void setTouched(String fieldName, bool touched) {
    _touched[fieldName] = touched;
  }

  /// Clear all errors
  void clearErrors() {
    _errors.clear();
  }

  /// Clear specific field error
  void clearFieldError(String fieldName) {
    _errors.remove(fieldName);
  }

  /// Reset form to initial state
  void reset() {
    _values.clear();
    _errors.clear();
    _touched.clear();
  }

  /// Check if form has any errors
  bool get hasErrors => _errors.isNotEmpty;

  /// Check if form is valid (no errors)
  bool get isValid => _errors.isEmpty;
}

/// Form controller with validation support
class GrafitFormController extends ChangeNotifier {
  final GrafitFormData _data = GrafitFormData();
  final Map<String, List<FormFieldValidator>> _validators = {};
  final Map<String, AsyncFormFieldValidator> _asyncValidators = {};

  /// Form data
  GrafitFormData get data => _data;

  /// Get all values
  Map<String, dynamic> get values => _data.values;

  /// Get all errors
  Map<String, String?> get errors => _data.errors;

  /// Check if form is valid
  bool get isValid => _data.isValid;

  /// Check if form has errors
  bool get hasErrors => _data.hasErrors;

  /// Register a validator for a field
  void registerValidator(String fieldName, FormFieldValidator validator) {
    _validators.putIfAbsent(fieldName, () => []).add(validator);
  }

  /// Register multiple validators for a field
  void registerValidators(String fieldName, List<FormFieldValidator> validators) {
    _validators[fieldName] = validators;
  }

  /// Register an async validator for a field
  void registerAsyncValidator(String fieldName, AsyncFormFieldValidator validator) {
    _asyncValidators[fieldName] = validator;
  }

  /// Unregister validators for a field
  void unregisterValidator(String fieldName) {
    _validators.remove(fieldName);
    _asyncValidators.remove(fieldName);
  }

  /// Validate a specific field
  String? validateField(String fieldName) {
    final value = _data.getValue(fieldName);
    final validators = _validators[fieldName];

    if (validators != null) {
      for (final validator in validators) {
        final error = validator(value);
        if (error != null) {
          _data.setError(fieldName, error);
          notifyListeners();
          return error;
        }
      }
    }

    _data.clearFieldError(fieldName);
    notifyListeners();
    return null;
  }

  /// Async validate a specific field
  Future<String?> validateFieldAsync(String fieldName) async {
    // Run sync validators first
    final syncError = validateField(fieldName);
    if (syncError != null) {
      return syncError;
    }

    // Run async validator
    final asyncValidator = _asyncValidators[fieldName];
    if (asyncValidator != null) {
      final value = _data.getValue(fieldName);
      final error = await asyncValidator(value);
      if (error != null) {
        _data.setError(fieldName, error);
        notifyListeners();
        return error;
      }
    }

    _data.clearFieldError(fieldName);
    notifyListeners();
    return null;
  }

  /// Validate all fields
  bool validate() {
    bool isValid = true;
    for (final fieldName in _validators.keys) {
      final error = validateField(fieldName);
      if (error != null) {
        isValid = false;
      }
    }
    notifyListeners();
    return isValid;
  }

  /// Async validate all fields
  Future<bool> validateAsync() async {
    bool isValid = true;
    for (final fieldName in _validators.keys) {
      final error = await validateFieldAsync(fieldName);
      if (error != null) {
        isValid = false;
      }
    }
    notifyListeners();
    return isValid;
  }

  /// Set value for a field
  void setValue(String fieldName, dynamic value, {bool validate = true}) {
    _data.setValue(fieldName, value);
    if (validate && _data.isTouched(fieldName)) {
      validateField(fieldName);
    } else {
      notifyListeners();
    }
  }

  /// Mark field as touched
  void markTouched(String fieldName) {
    _data.setTouched(fieldName, true);
    validateField(fieldName);
  }

  /// Mark all fields as touched
  void markAllTouched() {
    for (final fieldName in _validators.keys) {
      _data.setTouched(fieldName, true);
    }
    notifyListeners();
  }

  /// Clear all errors
  void clearErrors() {
    _data.clearErrors();
    notifyListeners();
  }

  /// Reset form
  void reset() {
    _data.reset();
    notifyListeners();
  }

  /// Get value for a field
  T? getValue<T>(String fieldName) {
    return _data.getValue<T>(fieldName);
  }

  /// Get error for a field
  String? getError(String fieldName) {
    return _data.getError(fieldName);
  }

  /// Check if field is touched
  bool isTouched(String fieldName) {
    return _data.isTouched(fieldName);
  }
}

/// Inherited widget to share form state
class GrafitFormScope extends InheritedWidget {
  final GrafitFormController controller;

  const GrafitFormScope({
    super.key,
    required this.controller,
    required Widget child,
  }) : super(child: child);

  static GrafitFormScope of(BuildContext context) {
    final GrafitFormScope? result =
        context.dependOnInheritedWidgetOfExactType<GrafitFormScope>();
    assert(result != null, 'No GrafitFormScope found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(GrafitFormScope oldWidget) {
    return controller != oldWidget.controller;
  }
}

/// Main form widget with state management
class GrafitForm extends StatefulWidget {
  final GrafitFormController? controller;
  final Map<String, dynamic>? initialValues;
  final Widget child;
  final void Function(GrafitFormController)? onInit;
  final void Function(GrafitFormController)? onDispose;
  final bool Function(GrafitFormController)? onSubmit;
  final bool autoValidate;
  final EdgeInsetsGeometry? padding;

  const GrafitForm({
    super.key,
    this.controller,
    this.initialValues,
    required this.child,
    this.onInit,
    this.onDispose,
    this.onSubmit,
    this.autoValidate = false,
    this.padding,
  });

  @override
  State<GrafitForm> createState() => GrafitFormState();
}

class GrafitFormState extends State<GrafitForm> {
  late GrafitFormController _controller;

  GrafitFormController get controller => _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? GrafitFormController();

    // Set initial values
    if (widget.initialValues != null) {
      widget.initialValues!.forEach((key, value) {
        _controller.setValue(key, value, validate: false);
      });
    }

    widget.onInit?.call(_controller);
  }

  @override
  void didUpdateWidget(GrafitForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      _controller = widget.controller ?? GrafitFormController();
    }
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    widget.onDispose?.call(_controller);
    super.dispose();
  }

  void submit() {
    final isValid = _controller.validate();
    final shouldSubmit = widget.onSubmit?.call(_controller) ?? true;
    if (isValid && shouldSubmit) {
      // Form submitted successfully
    }
  }

  Future<void> submitAsync() async {
    final isValid = await _controller.validateAsync();
    final shouldSubmit = widget.onSubmit?.call(_controller) ?? true;
    if (isValid && shouldSubmit) {
      // Form submitted successfully
    }
  }

  @override
  Widget build(BuildContext context) {
    return GrafitFormScope(
      controller: _controller,
      child: GestureDetector(
        onTap: () {
          final scope = GrafitFormScope.of(context);
          scope.controller.markAllTouched();
        },
        child: Container(
          padding: widget.padding,
          child: widget.child,
        ),
      ),
    );
  }
}

/// Form item context
class _FormFieldItemContext {
  final String fieldName;
  final String id;

  _FormFieldItemContext({
    required this.fieldName,
    required this.id,
  });
}

/// Inherited widget to share form field context
class _FormFieldItemInherited extends InheritedWidget {
  final _FormFieldItemContext context;

  const _FormFieldItemInherited({
    required this.context,
    required super.child,
  });

  static _FormFieldItemInherited of(BuildContext context) {
    final result =
        context.dependOnInheritedWidgetOfExactType<_FormFieldItemInherited>();
    assert(result != null, 'No _FormFieldItemInherited found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(_FormFieldItemInherited oldWidget) {
    return context != oldWidget.context;
  }
}

/// Form item wrapper for a single form field
class GrafitFormItem extends StatelessWidget {
  final String fieldName;
  final Widget child;
  final bool showError;

  const GrafitFormItem({
    super.key,
    required this.fieldName,
    required this.child,
    this.showError = true,
  });

  @override
  Widget build(BuildContext context) {
    final id = 'form-item-${fieldName.hashCode}';
    final scope = GrafitFormScope.of(context);

    return _FormFieldItemInherited(
      context: _FormFieldItemContext(
        fieldName: fieldName,
        id: id,
      ),
      child: AnimatedBuilder(
        animation: scope.controller,
        builder: (context, child) {
          final error = scope.controller.getError(fieldName);
          final hasError = error != null && showError;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              child,
              if (hasError) ...[
                const SizedBox(height: 4),
                GrafitFormMessage(
                  error: error,
                ),
              ],
            ],
          );
        },
        child: child,
      ),
    );
  }
}

/// Form label with error state support
class GrafitFormLabel extends StatelessWidget {
  final String text;
  final bool required;

  const GrafitFormLabel({
    super.key,
    required this.text,
    this.required = false,
  });

  @override
  Widget build(BuildContext context) {
    final scope = GrafitFormScope.of(context);
    final itemContext = _FormFieldItemInherited.of(context).context;
    final error = scope.controller.getError(itemContext.fieldName);
    final hasError = error != null;

    final theme = Theme.of(context).extension<GrafitTheme>()!;
    final colors = theme.colors;

    return GrafitLabel(
      text: text,
      required: required,
      disabled: false,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Text(
              text,
              style: TextStyle(
                color: hasError ? colors.destructive : colors.foreground,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          if (required)
            Text(
              ' *',
              style: TextStyle(
                color: hasError ? colors.destructive : colors.destructive,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
        ],
      ),
    );
  }
}

/// Form control wrapper for input widgets
class GrafitFormControl extends StatelessWidget {
  final Widget child;

  const GrafitFormControl({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final itemContext = _FormFieldItemInherited.of(context).context;
    final scope = GrafitFormScope.of(context);
    final error = scope.controller.getError(itemContext.fieldName);
    final hasError = error != null;

    return Container(
      key: ValueKey('${itemContext.id}-control'),
      child: child,
    );
  }
}

/// Form description helper text
class GrafitFormDescription extends StatelessWidget {
  final String text;

  const GrafitFormDescription({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<GrafitTheme>()!;
    final colors = theme.colors;

    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Text(
        text,
        style: theme.text.labelSmall?.copyWith(
          color: colors.mutedForeground,
        ),
      ),
    );
  }
}

/// Form error/validation message
class GrafitFormMessage extends StatelessWidget {
  final String? error;
  final String? message;

  const GrafitFormMessage({
    super.key,
    this.error,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<GrafitTheme>()!;
    final colors = theme.colors;
    final text = error ?? message;

    if (text == null || text.isEmpty) {
      return const SizedBox.shrink();
    }

    return Text(
      text,
      style: theme.text.labelSmall?.copyWith(
        color: colors.destructive,
      ),
    );
  }
}

/// Form field with validation and state management
class GrafitFormField<T> extends StatefulWidget {
  final String name;
  final T? initialValue;
  final List<FormFieldValidator<T>> validators;
  final AsyncFormFieldValidator<T>? asyncValidator;
  final bool autovalidate;
  final Widget Function(BuildContext context, T? value, String? error) builder;
  final void Function(T? value)? onChanged;
  final bool enabled;

  const GrafitFormField({
    super.key,
    required this.name,
    this.initialValue,
    this.validators = const [],
    this.asyncValidator,
    this.autovalidate = false,
    required this.builder,
    this.onChanged,
    this.enabled = true,
  });

  @override
  State<GrafitFormField<T>> createState() => GrafitFormFieldState<T>();
}

class GrafitFormFieldState<T> extends State<GrafitFormField<T>> {
  late T? _value;

  @override
  void initState() {
    super.initState();
    _value = widget.initialValue;
    _registerField();
  }

  @override
  void didUpdateWidget(GrafitFormField<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialValue != oldWidget.initialValue) {
      _value = widget.initialValue;
    }
    if (widget.name != oldWidget.name ||
        widget.validators != oldWidget.validators ||
        widget.asyncValidator != oldWidget.asyncValidator) {
      _registerField();
    }
  }

  @override
  void dispose() {
    _unregisterField();
    super.dispose();
  }

  void _registerField() {
    final scope = GrafitFormScope.of(context);
    scope.controller.registerValidators(widget.name, widget.validators);
    if (widget.asyncValidator != null) {
      scope.controller.registerAsyncValidator(widget.name, widget.asyncValidator!);
    }
    if (widget.initialValue != null) {
      scope.controller.setValue(widget.name, widget.initialValue, validate: false);
    }
  }

  void _unregisterField() {
    final scope = GrafitFormScope.of(context);
    scope.controller.unregisterValidator(widget.name);
  }

  void _handleChange(T? value) {
    setState(() {
      _value = value;
    });

    final scope = GrafitFormScope.of(context);
    scope.controller.setValue(
      widget.name,
      value,
      validate: widget.autovalidate,
    );

    widget.onChanged?.call(value);
  }

  void _handleTap() {
    final scope = GrafitFormScope.of(context);
    scope.controller.markTouched(widget.name);
  }

  @override
  Widget build(BuildContext context) {
    return GrafitFormItem(
      fieldName: widget.name,
      showError: widget.autovalidate,
      child: GestureDetector(
        onTap: _handleTap,
        child: AnimatedBuilder(
          animation: GrafitFormScope.of(context).controller,
          builder: (context, child) {
            final scope = GrafitFormScope.of(context);
            final error = scope.controller.getError(widget.name);
            final currentValue = scope.controller.getValue<T>(widget.name) ?? _value;

            return widget.builder(context, currentValue, error);
          },
        ),
      ),
    );
  }
}

/// Common validators
class GrafitValidators {
  /// Required field validator
  static FormFieldValidator<String> required({String message = 'This field is required'}) {
    return (value) {
      if (value == null || value.isEmpty) {
        return message;
      }
      return null;
    };
  }

  /// Email validator
  static FormFieldValidator<String> email({String message = 'Invalid email address'}) {
    return (value) {
      if (value == null || value.isEmpty) {
        return null;
      }
      final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
      if (!emailRegex.hasMatch(value)) {
        return message;
      }
      return null;
    };
  }

  /// Min length validator
  static FormFieldValidator<String> minLength(int length, {String? message}) {
    return (value) {
      if (value == null || value.isEmpty) {
        return null;
      }
      if (value.length < length) {
        return message ?? 'Must be at least $length characters';
      }
      return null;
    };
  }

  /// Max length validator
  static FormFieldValidator<String> maxLength(int length, {String? message}) {
    return (value) {
      if (value == null || value.isEmpty) {
        return null;
      }
      if (value.length > length) {
        return message ?? 'Must be at most $length characters';
      }
      return null;
    };
  }

  /// Min value validator for numbers
  static FormFieldValidator<num> min(num min, {String? message}) {
    return (value) {
      if (value == null) {
        return null;
      }
      if (value < min) {
        return message ?? 'Must be at least $min';
      }
      return null;
    };
  }

  /// Max value validator for numbers
  static FormFieldValidator<num> max(num max, {String? message}) {
    return (value) {
      if (value == null) {
        return null;
      }
      if (value > max) {
        return message ?? 'Must be at most $max';
      }
      return null;
    };
  }

  /// Pattern validator
  static FormFieldValidator<String> pattern(String pattern, {String? message}) {
    return (value) {
      if (value == null || value.isEmpty) {
        return null;
      }
      final regex = RegExp(pattern);
      if (!regex.hasMatch(value)) {
        return message ?? 'Invalid format';
      }
      return null;
    };
  }

  /// Custom validator
  static FormFieldValidator<T> custom<T>(FormFieldValidator<T> validator) {
    return validator;
  }
}

/// Extension to easily access form controller from context
extension GrafitFormExtension on BuildContext {
  GrafitFormController get formController {
    return GrafitFormScope.of(this).controller;
  }
}

// ============================================================
// WIDGETBOOK USE CASES
// ============================================================

@widgetbook.UseCase(
  name: 'Default',
  type: GrafitForm,
  path: 'Form/Form',
)
Widget formDefault(BuildContext context) {
  final controller = GrafitFormController();

  return Padding(
    padding: const EdgeInsets.all(24.0),
    child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 400),
      child: GrafitForm(
        controller: controller,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            GrafitFormLabel(text: 'Email'),
            const SizedBox(height: 8),
            GrafitFormField<String>(
              name: 'email',
              initialValue: '',
              validators: [
                GrafitValidators.required(),
                GrafitValidators.email(),
              ],
              builder: (context, value, error) {
                return TextField(
                  decoration: InputDecoration(
                    hintText: 'Enter your email',
                    errorText: error,
                  ),
                  onChanged: (newValue) {
                    context.formController.setValue('email', newValue);
                  },
                );
              },
            ),
            const SizedBox(height: 16),
            GrafitFormLabel(text: 'Password'),
            const SizedBox(height: 8),
            GrafitFormField<String>(
              name: 'password',
              initialValue: '',
              validators: [
                GrafitValidators.required(),
                GrafitValidators.minLength(8),
              ],
              builder: (context, value, error) {
                return TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'Enter your password',
                    errorText: error,
                  ),
                  onChanged: (newValue) {
                    context.formController.setValue('password', newValue);
                  },
                );
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (controller.validate()) {
                  print('Form submitted: ${controller.values}');
                }
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'With Validation',
  type: GrafitForm,
  path: 'Form/Form',
)
Widget formWithValidation(BuildContext context) {
  final controller = GrafitFormController();

  return Padding(
    padding: const EdgeInsets.all(24.0),
    child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 400),
      child: GrafitForm(
        controller: controller,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            GrafitFormLabel(text: 'Username'),
            const SizedBox(height: 8),
            GrafitFormField<String>(
              name: 'username',
              initialValue: '',
              validators: [
                GrafitValidators.required(message: 'Username is required'),
                GrafitValidators.minLength(3, message: 'Must be at least 3 characters'),
              ],
              builder: (context, value, error) {
                return TextField(
                  decoration: InputDecoration(
                    hintText: 'Enter username',
                    errorText: error,
                  ),
                  onChanged: (newValue) {
                    context.formController.setValue('username', newValue);
                  },
                );
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                controller.validate();
              },
              child: const Text('Validate'),
            ),
          ],
        ),
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'Nested Form',
  type: GrafitForm,
  path: 'Form/Form',
)
Widget formNested(BuildContext context) {
  final controller = GrafitFormController();

  return Padding(
    padding: const EdgeInsets.all(24.0),
    child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 400),
      child: GrafitForm(
        controller: controller,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            GrafitFormLabel(text: 'Address'),
            const SizedBox(height: 8),
            GrafitFormField<String>(
              name: 'address.street',
              initialValue: '',
              validators: [GrafitValidators.required()],
              builder: (context, value, error) {
                return TextField(
                  decoration: InputDecoration(
                    labelText: 'Street',
                    errorText: error,
                  ),
                  onChanged: (newValue) {
                    context.formController.setValue('address.street', newValue);
                  },
                );
              },
            ),
            const SizedBox(height: 8),
            GrafitFormField<String>(
              name: 'address.city',
              initialValue: '',
              validators: [GrafitValidators.required()],
              builder: (context, value, error) {
                return TextField(
                  decoration: InputDecoration(
                    labelText: 'City',
                    errorText: error,
                  ),
                  onChanged: (newValue) {
                    context.formController.setValue('address.city', newValue);
                  },
                );
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (controller.validate()) {
                  print('Form values: ${controller.values}');
                }
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'Interactive',
  type: GrafitForm,
  path: 'Form/Form',
)
Widget formInteractive(BuildContext context) {
  final controller = GrafitFormController();
  final showValidation = context.knobs.boolean(label: 'Show Validation', initialValue: false);

  return Padding(
    padding: const EdgeInsets.all(24.0),
    child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 400),
      child: GrafitForm(
        controller: controller,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            GrafitFormLabel(text: 'Email'),
            const SizedBox(height: 8),
            GrafitFormField<String>(
              name: 'email',
              initialValue: '',
              validators: showValidation
                  ? [
                      GrafitValidators.required(),
                      GrafitValidators.email(),
                    ]
                  : [],
              builder: (context, value, error) {
                return TextField(
                  decoration: InputDecoration(
                    hintText: 'Enter your email',
                    errorText: error,
                  ),
                  onChanged: (newValue) {
                    context.formController.setValue('email', newValue);
                  },
                );
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (controller.validate()) {
                  print('Form submitted: ${controller.values}');
                }
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    ),
  );
}

