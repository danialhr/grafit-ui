import 'package:flutter/material.dart';
import '../../theme/theme.dart';
import '../layout/accordion.dart';
import '../layout/card.dart';
import 'button.dart';
import 'checkbox.dart';
import 'form.dart';
import 'input.dart';
import 'label.dart';
import 'radio_group.dart';
import 'select.dart';
import 'switch.dart';
import 'textarea.dart';

/// Schema definition for AutoForm fields
class GrafitAutoFormField {
  /// Name of the field (key in form data)
  final String name;

  /// Label to display for the field
  final String? label;

  /// Type of the field
  final GrafitAutoFormFieldType type;

  /// Whether the field is required
  final bool required;

  /// Default value for the field
  final dynamic defaultValue;

  /// Helper/description text to display below the field
  final String? description;

  /// Placeholder text for input fields
  final String? placeholder;

  /// Error message to display when validation fails
  final String? validationMessage;

  /// Minimum value (for number fields)
  final num? min;

  /// Maximum value (for number fields)
  final num? max;

  /// Minimum length (for text fields)
  final int? minLength;

  /// Maximum length (for text fields)
  final int? maxLength;

  /// Options for select/radio fields
  final List<GrafitAutoFormOption>? options;

  /// Whether the field should use a specific component override
  final Widget Function(BuildContext context, dynamic value, String? error, VoidCallback onChanged)? customBuilder;

  /// Whether to show the label
  final bool showLabel;

  /// Whether the field is enabled
  final bool enabled;

  const GrafitAutoFormField({
    required this.name,
    required this.type,
    this.label,
    this.required = false,
    this.defaultValue,
    this.description,
    this.placeholder,
    this.validationMessage,
    this.min,
    this.max,
    this.minLength,
    this.maxLength,
    this.options,
    this.customBuilder,
    this.showLabel = true,
    this.enabled = true,
  });
}

/// Type of form field
enum GrafitAutoFormFieldType {
  /// Single-line text input
  text,

  /// Multi-line text input
  textarea,

  /// Number input
  number,

  /// Email input
  email,

  /// Password input
  password,

  /// Checkbox (boolean)
  checkbox,

  /// Switch (boolean)
  switch,

  /// Select dropdown
  select,

  /// Radio group
  radio,

  /// Date picker
  date,
}

/// Option for select/radio fields
class GrafitAutoFormOption {
  /// Value of the option
  final dynamic value;

  /// Label to display
  final String label;

  /// Optional description
  final String? description;

  const GrafitAutoFormOption({
    required this.value,
    required this.label,
    this.description,
  });
}

/// Field configuration for AutoForm
class GrafitAutoFormFieldConfig {
  /// Custom label override
  final String? label;

  /// Custom description
  final String? description;

  /// Whether to hide the label
  final bool? showLabel;

  /// Custom field type override
  final GrafitAutoFormFieldType? fieldType;

  /// Custom builder for the field
  final Widget Function(BuildContext context, dynamic value, String? error, VoidCallback onChanged)? builder;

  /// Input props for text fields
  final GrafitAutoFormInputProps? inputProps;

  /// Order priority (lower = higher priority)
  final int? order;

  const GrafitAutoFormFieldConfig({
    this.label,
    this.description,
    this.showLabel,
    this.fieldType,
    this.builder,
    this.inputProps,
    this.order,
  });
}

/// Input props for text fields
class GrafitAutoFormInputProps {
  final String? placeholder;
  final bool? obscureText;
  final int? maxLines;
  final int? minLength;
  final int? maxLength;

  const GrafitAutoFormInputProps({
    this.placeholder,
    this.obscureText,
    this.maxLines,
    this.minLength,
    this.maxLength,
  });
}

/// Schema definition for AutoForm
class GrafitAutoFormSchema {
  /// List of field definitions
  final List<GrafitAutoFormField> fields;

  /// Optional field configurations to override defaults
  final Map<String, GrafitAutoFormFieldConfig>? fieldConfig;

  const GrafitAutoFormSchema({
    required this.fields,
    this.fieldConfig,
  });
}

/// Dependency between fields
class GrafitAutoFormDependency {
  /// Source field that this dependency depends on
  final String sourceField;

  /// Target field that is affected
  final String targetField;

  /// Type of dependency
  final GrafitAutoFormDependencyType type;

  /// Function to determine when dependency applies
  final bool Function(dynamic sourceValue) when;

  /// Options to set (for SETS_OPTIONS type)
  final List<GrafitAutoFormOption>? options;

  const GrafitAutoFormDependency({
    required this.sourceField,
    required this.targetField,
    required this.type,
    required this.when,
    this.options,
  });
}

/// Type of dependency
enum GrafitAutoFormDependencyType {
  /// Hide the target field
  hides,

  /// Disable the target field
  disables,

  /// Mark the target field as required
  requires,

  /// Set options for the target field
  setsOptions,
}

/// Main AutoForm widget - automatically generates form fields from a schema
///
/// This widget simplifies form creation by automatically generating form fields
/// based on a schema definition. It supports various field types and integrates
/// seamlessly with GrafitForm.
///
/// Example usage:
/// ```dart
/// GrafitAutoForm(
///   schema: GrafitAutoFormSchema(
///     fields: [
///       GrafitAutoFormField(
///         name: 'username',
///         type: GrafitAutoFormFieldType.text,
///         label: 'Username',
///         required: true,
///         minLength: 2,
///       ),
///       GrafitAutoFormField(
///         name: 'email',
///         type: GrafitAutoFormFieldType.email,
///         label: 'Email',
///         required: true,
///       ),
///     ],
///   ),
///   onSubmit: (values) {
///     print('Form submitted: $values');
///   },
/// )
/// ```
class GrafitAutoForm extends StatefulWidget {
  /// Schema defining the form fields
  final GrafitAutoFormSchema schema;

  /// Callback when form is submitted with valid data
  final void Function(Map<String, dynamic> values) onSubmit;

  /// Callback when form values change
  final void Function(Map<String, dynamic> values)? onValuesChange;

  /// Optional initial values
  final Map<String, dynamic>? initialValues;

  /// Field-specific configurations
  final Map<String, GrafitAutoFormFieldConfig>? fieldConfig;

  /// Dependencies between fields
  final List<GrafitAutoFormDependency>? dependencies;

  /// Submit button text
  final String submitButtonText;

  /// Whether to show the submit button
  final bool showSubmitButton;

  /// Custom submit button widget
  final Widget? submitButton;

  /// Optional children to render below the form
  final List<Widget>? children;

  /// Padding around the form
  final EdgeInsetsGeometry? padding;

  /// Spacing between form fields
  final double fieldSpacing;

  const GrafitAutoForm({
    super.key,
    required this.schema,
    required this.onSubmit,
    this.onValuesChange,
    this.initialValues,
    this.fieldConfig,
    this.dependencies,
    this.submitButtonText = 'Submit',
    this.showSubmitButton = true,
    this.submitButton,
    this.children,
    this.padding,
    this.fieldSpacing = 16,
  });

  @override
  State<GrafitAutoForm> createState() => GrafitAutoFormState();
}

class GrafitAutoFormState extends State<GrafitAutoForm> {
  late GrafitFormController _controller;
  final Map<String, bool> _hiddenFields = {};
  final Map<String, bool> _disabledFields = {};
  final Map<String, bool> _requiredFields = {};

  @override
  void initState() {
    super.initState();
    _controller = GrafitFormController();
    _initializeForm();
  }

  void _initializeForm() {
    // Set initial values
    final initialValues = widget.initialValues ?? {};
    for (final field in widget.schema.fields) {
      final value = initialValues[field.name] ?? field.defaultValue;
      if (value != null) {
        _controller.setValue(field.name, value, validate: false);
      }
    }

    // Register validators
    _registerValidators();
  }

  void _registerValidators() {
    for (final field in widget.schema.fields) {
      final validators = <FormFieldValidator>[];

      if (field.required || _requiredFields[field.name] == true) {
        validators.add(GrafitValidators.required(
          message: field.validationMessage ?? '${field.label ?? field.name} is required',
        ));
      }

      switch (field.type) {
        case GrafitAutoFormFieldType.email:
          validators.add(GrafitValidators.email());
          break;
        case GrafitAutoFormFieldType.text:
        case GrafitAutoFormFieldType.textarea:
        case GrafitAutoFormFieldType.password:
          if (field.minLength != null) {
            validators.add(GrafitValidators.minLength(field.minLength!));
          }
          if (field.maxLength != null) {
            validators.add(GrafitValidators.maxLength(field.maxLength!));
          }
          break;
        case GrafitAutoFormFieldType.number:
          if (field.min != null) {
            validators.add(GrafitValidators.min(field.min!));
          }
          if (field.max != null) {
            validators.add(GrafitValidators.max(field.max!));
          }
          break;
        default:
          break;
      }

      if (validators.isNotEmpty) {
        _controller.registerValidators(field.name, validators);
      }
    }
  }

  void _handleFieldChanged(String fieldName, dynamic value) {
    _controller.setValue(fieldName, value, validate: true);

    // Notify of value change
    widget.onValuesChange?.call(_controller.values);

    // Update dependencies
    _updateDependencies(fieldName, value);
  }

  void _updateDependencies(String sourceField, dynamic sourceValue) {
    if (widget.dependencies == null) return;

    setState(() {
      for (final dependency in widget.dependencies!) {
        if (dependency.sourceField == sourceField) {
          final shouldApply = dependency.when(sourceValue);

          switch (dependency.type) {
            case GrafitAutoFormDependencyType.hides:
              _hiddenFields[dependency.targetField] = shouldApply;
              break;
            case GrafitAutoFormDependencyType.disables:
              _disabledFields[dependency.targetField] = shouldApply;
              break;
            case GrafitAutoFormDependencyType.requires:
              _requiredFields[dependency.targetField] = shouldApply;
              break;
            case GrafitAutoFormDependencyType.setsOptions:
              // Options are handled in field builder
              break;
          }
        }
      }
    });
  }

  bool _isFieldHidden(String fieldName) {
    return _hiddenFields[fieldName] ?? false;
  }

  bool _isFieldDisabled(String fieldName) {
    return _disabledFields[fieldName] ?? false;
  }

  bool _isFieldRequired(String fieldName) {
    final field = widget.schema.fields.firstWhere(
      (f) => f.name == fieldName,
      orElse: () => widget.schema.fields.first,
    );
    return field.required || (_requiredFields[fieldName] ?? false);
  }

  List<GrafitAutoFormOption>? _getFieldOptions(String fieldName) {
    // Check if options are overridden by dependencies
    for (final dependency in widget.dependencies ?? []) {
      if (dependency.targetField == fieldName &&
          dependency.type == GrafitAutoFormDependencyType.setsOptions) {
        final sourceValue = _controller.getValue(dependency.sourceField);
        if (dependency.when(sourceValue)) {
          return dependency.options;
        }
      }
    }
    return widget.schema.fields.firstWhere(
      (f) => f.name == fieldName,
      orElse: () => widget.schema.fields.first,
    ).options;
  }

  void _handleSubmit() {
    if (_controller.validate()) {
      widget.onSubmit(_controller.values);
    }
  }

  GrafitAutoFormFieldConfig? _getFieldConfig(String fieldName) {
    return widget.fieldConfig?[fieldName] ?? widget.schema.fieldConfig?[fieldName];
  }

  @override
  Widget build(BuildContext context) {
    final fieldsWithOrder = widget.schema.fields.map((field) {
      final config = _getFieldConfig(field.name);
      return MapEntry(field, config?.order ?? 0);
    }).toList()
      ..sort((a, b) => a.value.compareTo(b.value));

    return GrafitForm(
      controller: _controller,
      padding: widget.padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final entry in fieldsWithOrder)
            if (!_isFieldHidden(entry.key.name)) ...[
              _buildField(context, entry.key),
              SizedBox(height: widget.fieldSpacing),
            ],
          if (widget.showSubmitButton) ...[
            _buildSubmitButton(context),
            SizedBox(height: widget.fieldSpacing),
          ],
          if (widget.children != null) ...widget.children!,
        ],
      ),
    );
  }

  Widget _buildField(BuildContext context, GrafitAutoFormField field) {
    final config = _getFieldConfig(field.name);
    final isDisabled = _isFieldDisabled(field.name) || !field.enabled;

    if (config?.builder != null || field.customBuilder != null) {
      return GrafitFormField<dynamic>(
        name: field.name,
        initialValue: field.defaultValue,
        autovalidate: true,
        builder: (context, value, error) {
          return (config?.builder ?? field.customBuilder!)(
            context,
            value,
            error,
            (newValue) => _handleFieldChanged(field.name, newValue),
          );
        },
      );
    }

    switch (config?.fieldType ?? field.type) {
      case GrafitAutoFormFieldType.text:
      case GrafitAutoFormFieldType.email:
      case GrafitAutoFormFieldType.password:
        return _buildTextField(context, field, config, isDisabled);
      case GrafitAutoFormFieldType.textarea:
        return _buildTextareaField(context, field, config, isDisabled);
      case GrafitAutoFormFieldType.number:
        return _buildNumberField(context, field, config, isDisabled);
      case GrafitAutoFormFieldType.checkbox:
        return _buildCheckboxField(context, field, config, isDisabled);
      case GrafitAutoFormFieldType.switch:
        return _buildSwitchField(context, field, config, isDisabled);
      case GrafitAutoFormFieldType.select:
        return _buildSelectField(context, field, config, isDisabled);
      case GrafitAutoFormFieldType.radio:
        return _buildRadioField(context, field, config, isDisabled);
      case GrafitAutoFormFieldType.date:
        return _buildDateField(context, field, config, isDisabled);
    }
  }

  Widget _buildTextField(
    BuildContext context,
    GrafitAutoFormField field,
    GrafitAutoFormFieldConfig? config,
    bool isDisabled,
  ) {
    final inputProps = config?.inputProps;
    final label = config?.label ?? field.label ?? _formatLabel(field.name);
    final showLabel = config?.showLabel ?? field.showLabel;

    return GrafitFormField<String>(
      name: field.name,
      initialValue: field.defaultValue?.toString(),
      autovalidate: true,
      builder: (context, value, error) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (showLabel && label.isNotEmpty) ...[
              GrafitFormLabel(
                text: label,
                required: _isFieldRequired(field.name),
              ),
              const SizedBox(height: 6),
            ],
            GrafitInput(
              label: showLabel ? null : label,
              hint: inputProps?.placeholder ?? field.placeholder,
              value: value ?? '',
              onChanged: (newValue) => _handleFieldChanged(field.name, newValue),
              enabled: !isDisabled,
              obscureText: field.type == GrafitAutoFormFieldType.password ||
                  (inputProps?.obscureText ?? false),
              errorText: error,
              keyboardType: field.type == GrafitAutoFormFieldType.email
                  ? TextInputType.emailAddress
                  : TextInputType.text,
            ),
            if (field.description != null || config?.description != null) ...[
              const SizedBox(height: 4),
              GrafitFormDescription(
                text: config?.description ?? field.description!,
              ),
            ],
          ],
        );
      },
    );
  }

  Widget _buildTextareaField(
    BuildContext context,
    GrafitAutoFormField field,
    GrafitAutoFormFieldConfig? config,
    bool isDisabled,
  ) {
    final inputProps = config?.inputProps;
    final label = config?.label ?? field.label ?? _formatLabel(field.name);
    final showLabel = config?.showLabel ?? field.showLabel;

    return GrafitFormField<String>(
      name: field.name,
      initialValue: field.defaultValue?.toString(),
      autovalidate: true,
      builder: (context, value, error) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (showLabel && label.isNotEmpty) ...[
              GrafitFormLabel(
                text: label,
                required: _isFieldRequired(field.name),
              ),
              const SizedBox(height: 6),
            ],
            GrafitTextarea(
              label: showLabel ? null : label,
              hint: inputProps?.placeholder ?? field.placeholder,
              value: value ?? '',
              onChanged: (newValue) => _handleFieldChanged(field.name, newValue),
              enabled: !isDisabled,
              errorText: error,
              maxLines: inputProps?.maxLines ?? 3,
              minLines: inputProps?.maxLines ?? 3,
            ),
            if (field.description != null || config?.description != null) ...[
              const SizedBox(height: 4),
              GrafitFormDescription(
                text: config?.description ?? field.description!,
              ),
            ],
          ],
        );
      },
    );
  }

  Widget _buildNumberField(
    BuildContext context,
    GrafitAutoFormField field,
    GrafitAutoFormFieldConfig? config,
    bool isDisabled,
  ) {
    final label = config?.label ?? field.label ?? _formatLabel(field.name);
    final showLabel = config?.showLabel ?? field.showLabel;

    return GrafitFormField<num>(
      name: field.name,
      initialValue: field.defaultValue as num?,
      autovalidate: true,
      builder: (context, value, error) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (showLabel && label.isNotEmpty) ...[
              GrafitFormLabel(
                text: label,
                required: _isFieldRequired(field.name),
              ),
              const SizedBox(height: 6),
            ],
            GrafitInput(
              label: showLabel ? null : label,
              hint: field.placeholder,
              value: value?.toString() ?? '',
              onChanged: (newValue) {
                final numValue = num.tryParse(newValue);
                if (numValue != null) {
                  _handleFieldChanged(field.name, numValue);
                }
              },
              enabled: !isDisabled,
              errorText: error,
              keyboardType: TextInputType.number,
            ),
            if (field.description != null || config?.description != null) ...[
              const SizedBox(height: 4),
              GrafitFormDescription(
                text: config?.description ?? field.description!,
              ),
            ],
          ],
        );
      },
    );
  }

  Widget _buildCheckboxField(
    BuildContext context,
    GrafitAutoFormField field,
    GrafitAutoFormFieldConfig? config,
    bool isDisabled,
  ) {
    final label = config?.label ?? field.label ?? _formatLabel(field.name);

    return GrafitFormField<bool>(
      name: field.name,
      initialValue: field.defaultValue as bool? ?? false,
      autovalidate: true,
      builder: (context, value, error) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            GrafitCheckbox(
              label: label,
              value: value ?? false,
              onChanged: isDisabled
                  ? null
                  : (newValue) => _handleFieldChanged(field.name, newValue),
              enabled: !isDisabled,
            ),
            if (error != null) ...[
              const SizedBox(height: 4),
              GrafitFormMessage(error: error),
            ],
            if (field.description != null || config?.description != null) ...[
              const SizedBox(height: 4),
              GrafitFormDescription(
                text: config?.description ?? field.description!,
              ),
            ],
          ],
        );
      },
    );
  }

  Widget _buildSwitchField(
    BuildContext context,
    GrafitAutoFormField field,
    GrafitAutoFormFieldConfig? config,
    bool isDisabled,
  ) {
    final label = config?.label ?? field.label ?? _formatLabel(field.name);

    return GrafitFormField<bool>(
      name: field.name,
      initialValue: field.defaultValue as bool? ?? false,
      autovalidate: true,
      builder: (context, value, error) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GrafitFormLabel(
                        text: label,
                        required: _isFieldRequired(field.name),
                      ),
                      if (field.description != null || config?.description != null) ...[
                        const SizedBox(height: 2),
                        GrafitFormDescription(
                          text: config?.description ?? field.description!,
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                GrafitSwitch(
                  value: value ?? false,
                  onChanged: isDisabled
                      ? null
                      : (newValue) => _handleFieldChanged(field.name, newValue),
                ),
              ],
            ),
            if (error != null) ...[
              const SizedBox(height: 4),
              GrafitFormMessage(error: error),
            ],
          ],
        );
      },
    );
  }

  Widget _buildSelectField(
    BuildContext context,
    GrafitAutoFormField field,
    GrafitAutoFormFieldConfig? config,
    bool isDisabled,
  ) {
    final label = config?.label ?? field.label ?? _formatLabel(field.name);
    final options = _getFieldOptions(field.name) ?? field.options ?? [];
    final showLabel = config?.showLabel ?? field.showLabel;

    return GrafitFormField<dynamic>(
      name: field.name,
      initialValue: field.defaultValue,
      autovalidate: true,
      builder: (context, value, error) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (showLabel && label.isNotEmpty) ...[
              GrafitFormLabel(
                text: label,
                required: _isFieldRequired(field.name),
              ),
              const SizedBox(height: 6),
            ],
            GrafitSelect<dynamic>(
              items: options
                  .map((option) => GrafitSelectItemData(
                        value: option.value,
                        label: option.label,
                        description: option.description,
                      ))
                  .toList(),
              value: value,
              onChanged: isDisabled
                  ? null
                  : (newValue) => _handleFieldChanged(field.name, newValue),
              placeholder: field.placeholder,
              enabled: !isDisabled,
              errorText: error,
            ),
            if (field.description != null || config?.description != null) ...[
              const SizedBox(height: 4),
              GrafitFormDescription(
                text: config?.description ?? field.description!,
              ),
            ],
          ],
        );
      },
    );
  }

  Widget _buildRadioField(
    BuildContext context,
    GrafitAutoFormField field,
    GrafitAutoFormFieldConfig? config,
    bool isDisabled,
  ) {
    final label = config?.label ?? field.label ?? _formatLabel(field.name);
    final options = _getFieldOptions(field.name) ?? field.options ?? [];

    return GrafitFormField<dynamic>(
      name: field.name,
      initialValue: field.defaultValue,
      autovalidate: true,
      builder: (context, value, error) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            GrafitFormLabel(
              text: label,
              required: _isFieldRequired(field.name),
            ),
            const SizedBox(height: 6),
            GrafitRadioGroup(
              items: options
                  .map((option) => GrafitRadioItemData(
                        value: option.value,
                        label: option.label,
                      ))
                  .toList(),
              groupValue: value,
              onChanged: isDisabled
                  ? null
                  : (newValue) => _handleFieldChanged(field.name, newValue),
              enabled: !isDisabled,
            ),
            if (error != null) ...[
              const SizedBox(height: 4),
              GrafitFormMessage(error: error),
            ],
            if (field.description != null || config?.description != null) ...[
              const SizedBox(height: 4),
              GrafitFormDescription(
                text: config?.description ?? field.description!,
              ),
            ],
          ],
        );
      },
    );
  }

  Widget _buildDateField(
    BuildContext context,
    GrafitAutoFormField field,
    GrafitAutoFormFieldConfig? config,
    bool isDisabled,
  ) {
    final label = config?.label ?? field.label ?? _formatLabel(field.name);
    final showLabel = config?.showLabel ?? field.showLabel;

    return GrafitFormField<DateTime>(
      name: field.name,
      initialValue: field.defaultValue as DateTime?,
      autovalidate: true,
      builder: (context, value, error) {
        final formattedDate = value != null
            ? '${value.year}-${value.month.toString().padLeft(2, '0')}-${value.day.toString().padLeft(2, '0')}'
            : '';

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (showLabel && label.isNotEmpty) ...[
              GrafitFormLabel(
                text: label,
                required: _isFieldRequired(field.name),
              ),
              const SizedBox(height: 6),
            ],
            GestureDetector(
              onTap: isDisabled
                  ? null
                  : () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: value ?? DateTime.now(),
                        firstDate: DateTime(1900),
                        lastDate: DateTime(2100),
                      );
                      if (picked != null) {
                        _handleFieldChanged(field.name, picked);
                      }
                    },
              child: AbsorbPointer(
                child: GrafitInput(
                  label: showLabel ? null : label,
                  hint: field.placeholder ?? 'YYYY-MM-DD',
                  value: formattedDate,
                  onChanged: (_) {},
                  enabled: !isDisabled,
                  errorText: error,
                ),
              ),
            ),
            if (field.description != null || config?.description != null) ...[
              const SizedBox(height: 4),
              GrafitFormDescription(
                text: config?.description ?? field.description!,
              ),
            ],
          ],
        );
      },
    );
  }

  Widget _buildSubmitButton(BuildContext context) {
    if (widget.submitButton != null) {
      return widget.submitButton!;
    }

    return GrafitButton(
      onPressed: _handleSubmit,
      variant: GrafitButtonVariant.primary,
      child: Text(widget.submitButtonText),
    );
  }

  String _formatLabel(String fieldName) {
    // Convert camelCase to Title Case
    final result = fieldName.replaceAllMapped(
      RegExp(r'([a-z])([A-Z])'),
      (match) => '${match.group(1)} ${match.group(2)}',
    );
    return result[0].toUpperCase() + result.substring(1);
  }
}

/// AutoForm submit button widget
///
/// A pre-styled submit button for use with GrafitAutoForm.
/// Can be used as a child of GrafitAutoForm or standalone.
class GrafitAutoFormSubmit extends StatelessWidget {
  /// Label for the submit button
  final String label;

  /// Whether the button is disabled
  final bool disabled;

  /// Variant of the button
  final GrafitButtonVariant? variant;

  /// Callback when button is pressed
  final VoidCallback? onPressed;

  const GrafitAutoFormSubmit({
    super.key,
    this.label = 'Submit',
    this.disabled = false,
    this.variant,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GrafitButton(
      onPressed: disabled ? null : onPressed,
      variant: variant ?? GrafitButtonVariant.primary,
      child: Text(label),
    );
  }
}

/// Schema builder for creating AutoForm schemas
///
/// Provides a fluent API for building form schemas programmatically.
class GrafitAutoFormSchemaBuilder {
  final List<GrafitAutoFormField> _fields = [];
  final Map<String, GrafitAutoFormFieldConfig> _fieldConfig = {};

  /// Add a field to the schema
  GrafitAutoFormSchemaBuilder addField(GrafitAutoFormField field) {
    _fields.add(field);
    return this;
  }

  /// Add a text field
  GrafitAutoFormSchemaBuilder addText({
    required String name,
    String? label,
    bool required = false,
    String? defaultValue,
    String? description,
    String? placeholder,
    String? validationMessage,
    int? minLength,
    int? maxLength,
  }) {
    return addField(GrafitAutoFormField(
      name: name,
      type: GrafitAutoFormFieldType.text,
      label: label,
      required: required,
      defaultValue: defaultValue,
      description: description,
      placeholder: placeholder,
      validationMessage: validationMessage,
      minLength: minLength,
      maxLength: maxLength,
    ));
  }

  /// Add an email field
  GrafitAutoFormSchemaBuilder addEmail({
    required String name,
    String? label,
    bool required = false,
    String? defaultValue,
    String? description,
    String? placeholder,
    String? validationMessage,
  }) {
    return addField(GrafitAutoFormField(
      name: name,
      type: GrafitAutoFormFieldType.email,
      label: label,
      required: required,
      defaultValue: defaultValue,
      description: description,
      placeholder: placeholder ?? 'email@example.com',
      validationMessage: validationMessage,
    ));
  }

  /// Add a password field
  GrafitAutoFormSchemaBuilder addPassword({
    required String name,
    String? label,
    bool required = false,
    String? defaultValue,
    String? description,
    String? placeholder,
    String? validationMessage,
    int? minLength,
  }) {
    return addField(GrafitAutoFormField(
      name: name,
      type: GrafitAutoFormFieldType.password,
      label: label,
      required: required,
      defaultValue: defaultValue,
      description: description,
      placeholder: placeholder,
      validationMessage: validationMessage,
      minLength: minLength,
    ));
  }

  /// Add a textarea field
  GrafitAutoFormSchemaBuilder addTextarea({
    required String name,
    String? label,
    bool required = false,
    String? defaultValue,
    String? description,
    String? placeholder,
    String? validationMessage,
    int? minLength,
    int? maxLength,
  }) {
    return addField(GrafitAutoFormField(
      name: name,
      type: GrafitAutoFormFieldType.textarea,
      label: label,
      required: required,
      defaultValue: defaultValue,
      description: description,
      placeholder: placeholder,
      validationMessage: validationMessage,
      minLength: minLength,
      maxLength: maxLength,
    ));
  }

  /// Add a number field
  GrafitAutoFormSchemaBuilder addNumber({
    required String name,
    String? label,
    bool required = false,
    num? defaultValue,
    String? description,
    String? placeholder,
    String? validationMessage,
    num? min,
    num? max,
  }) {
    return addField(GrafitAutoFormField(
      name: name,
      type: GrafitAutoFormFieldType.number,
      label: label,
      required: required,
      defaultValue: defaultValue,
      description: description,
      placeholder: placeholder,
      validationMessage: validationMessage,
      min: min,
      max: max,
    ));
  }

  /// Add a checkbox field
  GrafitAutoFormSchemaBuilder addCheckbox({
    required String name,
    String? label,
    bool required = false,
    bool? defaultValue,
    String? description,
    String? validationMessage,
  }) {
    return addField(GrafitAutoFormField(
      name: name,
      type: GrafitAutoFormFieldType.checkbox,
      label: label,
      required: required,
      defaultValue: defaultValue ?? false,
      description: description,
      validationMessage: validationMessage,
    ));
  }

  /// Add a switch field
  GrafitAutoFormSchemaBuilder addSwitch({
    required String name,
    String? label,
    bool required = false,
    bool? defaultValue,
    String? description,
    String? validationMessage,
  }) {
    return addField(GrafitAutoFormField(
      name: name,
      type: GrafitAutoFormFieldType.switch,
      label: label,
      required: required,
      defaultValue: defaultValue ?? false,
      description: description,
      validationMessage: validationMessage,
    ));
  }

  /// Add a select field
  GrafitAutoFormSchemaBuilder addSelect({
    required String name,
    required List<GrafitAutoFormOption> options,
    String? label,
    bool required = false,
    dynamic defaultValue,
    String? description,
    String? placeholder,
    String? validationMessage,
  }) {
    return addField(GrafitAutoFormField(
      name: name,
      type: GrafitAutoFormFieldType.select,
      label: label,
      required: required,
      defaultValue: defaultValue,
      description: description,
      placeholder: placeholder,
      validationMessage: validationMessage,
      options: options,
    ));
  }

  /// Add a radio field
  GrafitAutoFormSchemaBuilder addRadio({
    required String name,
    required List<GrafitAutoFormOption> options,
    String? label,
    bool required = false,
    dynamic defaultValue,
    String? description,
    String? validationMessage,
  }) {
    return addField(GrafitAutoFormField(
      name: name,
      type: GrafitAutoFormFieldType.radio,
      label: label,
      required: required,
      defaultValue: defaultValue,
      description: description,
      validationMessage: validationMessage,
      options: options,
    ));
  }

  /// Add a date field
  GrafitAutoFormSchemaBuilder addDate({
    required String name,
    String? label,
    bool required = false,
    DateTime? defaultValue,
    String? description,
    String? placeholder,
    String? validationMessage,
  }) {
    return addField(GrafitAutoFormField(
      name: name,
      type: GrafitAutoFormFieldType.date,
      label: label,
      required: required,
      defaultValue: defaultValue,
      description: description,
      placeholder: placeholder,
      validationMessage: validationMessage,
    ));
  }

  /// Add configuration for a field
  GrafitAutoFormSchemaBuilder configureField(
    String fieldName,
    GrafitAutoFormFieldConfig config,
  ) {
    _fieldConfig[fieldName] = config;
    return this;
  }

  /// Build the schema
  GrafitAutoFormSchema build() {
    return GrafitAutoFormSchema(
      fields: _fields,
      fieldConfig: _fieldConfig.isNotEmpty ? _fieldConfig : null,
    );
  }
}

/// Extension for easy access to AutoForm controller from context
extension GrafitAutoFormExtension on BuildContext {
  /// Get the form controller from the nearest GrafitForm ancestor
  GrafitFormController get autoFormController {
    return GrafitFormScope.of(this).controller;
  }
}
