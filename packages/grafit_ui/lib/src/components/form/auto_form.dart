import 'package:flutter/material.dart' hide FormFieldValidator;
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import '../../theme/theme.dart';
import '../layout/accordion.dart';
import '../layout/card.dart';
import 'button.dart';
import 'checkbox.dart';
import 'form.dart';
import 'input.dart';
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
  final Widget Function(BuildContext context, dynamic value, String? error, void Function(dynamic) onChanged)? customBuilder;

  /// Whether to show the label
  final bool showLabel;

  /// Whether the field is enabled
  final bool enabled;

  /// Array field configuration (for arrays of objects)
  final GrafitAutoFormArrayConfig? arrayConfig;

  /// Nested object configuration (for nested objects)
  final GrafitAutoFormObjectConfig? objectConfig;

  /// Section configuration (for accordion sections)
  final GrafitAutoFormSectionConfig? sectionConfig;

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
    this.arrayConfig,
    this.objectConfig,
    this.sectionConfig,
  });
}

/// Configuration for array fields (arrays of objects)
class GrafitAutoFormArrayConfig {
  /// Schema for array items
  final GrafitAutoFormSchema itemSchema;

  /// Minimum number of items
  final int? minItems;

  /// Maximum number of items
  final int? maxItems;

  /// Label for the "Add" button
  final String addLabel;

  /// Label for the "Remove" button
  final String removeLabel;

  /// Whether items can be reordered
  final bool reorderable;

  /// Custom builder for array items
  final Widget Function(BuildContext context, Map<String, dynamic> item, int index, VoidCallback onRemove)? itemBuilder;

  const GrafitAutoFormArrayConfig({
    required this.itemSchema,
    this.minItems,
    this.maxItems,
    this.addLabel = 'Add Item',
    this.removeLabel = 'Remove',
    this.reorderable = true,
    this.itemBuilder,
  });
}

/// Configuration for nested object fields
class GrafitAutoFormObjectConfig {
  /// Schema for the nested object
  final GrafitAutoFormSchema schema;

  /// Whether to show a border around the object
  final bool bordered;

  /// Whether to collapse the object by default
  final bool collapsible;

  /// Title for the object section
  final String? title;

  const GrafitAutoFormObjectConfig({
    required this.schema,
    this.bordered = true,
    this.collapsible = false,
    this.title,
  });
}

/// Configuration for section grouping (accordion)
class GrafitAutoFormSectionConfig {
  /// List of field names in this section
  final List<String> fields;

  /// Title for the section
  final String title;

  /// Description for the section
  final String? description;

  /// Whether the section is collapsible
  final bool collapsible;

  /// Whether the section is collapsed by default
  final bool collapsedByDefault;

  /// Icon for the section
  final IconData? icon;

  const GrafitAutoFormSectionConfig({
    required this.fields,
    required this.title,
    this.description,
    this.collapsible = true,
    this.collapsedByDefault = false,
    this.icon,
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
  toggleSwitch,

  /// Select dropdown
  select,

  /// Radio group
  radio,

  /// Date picker
  date,

  /// Array of objects
  array,

  /// Nested object
  object,

  /// Section (accordion)
  section,
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
  final Widget Function(BuildContext context, dynamic value, String? error, void Function(dynamic) onChanged)? builder;

  /// Input props for text fields
  final GrafitAutoFormInputProps? inputProps;

  /// Order priority (lower = higher priority)
  final int? order;

  /// Nested field configurations (for array/object types)
  final Map<String, GrafitAutoFormFieldConfig>? nestedConfig;

  const GrafitAutoFormFieldConfig({
    this.label,
    this.description,
    this.showLabel,
    this.fieldType,
    this.builder,
    this.inputProps,
    this.order,
    this.nestedConfig,
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

  // State for array fields (dynamic field lists)
  final Map<String, List<Map<String, dynamic>>> _arrayValues = {};

  // State for collapsible sections
  final Map<String, bool> _collapsedSections = {};

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
      if (field.type == GrafitAutoFormFieldType.array && field.arrayConfig != null) {
        final arrayValue = initialValues[field.name] as List<dynamic>? ?? field.defaultValue as List<dynamic>? ?? [];
        _arrayValues[field.name] = arrayValue.cast<Map<String, dynamic>>();
      } else if (field.type == GrafitAutoFormFieldType.object) {
        final objectValue = initialValues[field.name] as Map<String, dynamic>? ?? field.defaultValue as Map<String, dynamic>?;
        if (objectValue != null) {
          _setNestedObjectValues(field.name, objectValue);
        }
      } else if (field.type == GrafitAutoFormFieldType.section) {
        final collapsedByDefault = field.sectionConfig?.collapsedByDefault ?? false;
        _collapsedSections[field.name] = collapsedByDefault;
      } else {
        final value = initialValues[field.name] ?? field.defaultValue;
        if (value != null) {
          _controller.setValue(field.name, value, validate: false);
        }
      }
    }

    // Register validators
    _registerValidators();
  }

  void _setNestedObjectValues(String fieldName, Map<String, dynamic> objectValue) {
    objectValue.forEach((key, value) {
      _controller.setValue('$fieldName.$key', value, validate: false);
    });
  }

  Map<String, dynamic> _getNestedObjectValues(String fieldName, GrafitAutoFormSchema schema) {
    final result = <String, dynamic>{};
    for (final field in schema.fields) {
      final value = _controller.getValue('$fieldName.${field.name}');
      if (value != null) {
        result[field.name] = value;
      }
    }
    return result;
  }

  void _registerValidators() {
    for (final field in widget.schema.fields) {
      // Skip array, object, and section types - they have their own validation
      if (field.type == GrafitAutoFormFieldType.array ||
          field.type == GrafitAutoFormFieldType.object ||
          field.type == GrafitAutoFormFieldType.section) {
        continue;
      }

      final validators = <FormFieldValidator<dynamic>>[];

      if (field.required || _requiredFields[field.name] == true) {
        validators.add((value) {
          return GrafitValidators.required(
            message: field.validationMessage ?? '${field.label ?? field.name} is required',
          )(value as String?);
        });
      }

      switch (field.type) {
        case GrafitAutoFormFieldType.email:
          validators.add((value) => GrafitValidators.email()(value as String?));
          break;
        case GrafitAutoFormFieldType.text:
        case GrafitAutoFormFieldType.textarea:
        case GrafitAutoFormFieldType.password:
          if (field.minLength != null) {
            validators.add((value) => GrafitValidators.minLength(field.minLength!)(value as String?));
          }
          if (field.maxLength != null) {
            validators.add((value) => GrafitValidators.maxLength(field.maxLength!)(value as String?));
          }
          break;
        case GrafitAutoFormFieldType.number:
          if (field.min != null) {
            validators.add((value) => GrafitValidators.min(field.min!)(value as num?));
          }
          if (field.max != null) {
            validators.add((value) => GrafitValidators.max(field.max!)(value as num?));
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
    if (!_controller.validate()) {
      return;
    }

    // Build the final form values including nested structures
    final values = Map<String, dynamic>.from(_controller.values);

    // Add array field values
    for (final field in widget.schema.fields) {
      if (field.type == GrafitAutoFormFieldType.array && field.arrayConfig != null) {
        values[field.name] = _arrayValues[field.name] ?? [];
      } else if (field.type == GrafitAutoFormFieldType.object && field.objectConfig != null) {
        values[field.name] = _getNestedObjectValues(field.name, field.objectConfig!.schema);
      }
    }

    widget.onSubmit(values);
  }

  GrafitAutoFormFieldConfig? _getFieldConfig(String fieldName) {
    return widget.fieldConfig?[fieldName] ?? widget.schema.fieldConfig?[fieldName];
  }

  @override
  Widget build(BuildContext context) {
    // Separate sections from regular fields
    final sections = <GrafitAutoFormField>[];
    final regularFields = <GrafitAutoFormField>[];

    for (final field in widget.schema.fields) {
      if (field.type == GrafitAutoFormFieldType.section) {
        sections.add(field);
      } else {
        regularFields.add(field);
      }
    }

    // Sort regular fields by order
    final regularFieldsWithOrder = regularFields.map((field) {
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
          // Render regular fields
          for (final entry in regularFieldsWithOrder)
            if (!_isFieldHidden(entry.key.name)) ...[
              _buildField(context, entry.key),
              SizedBox(height: widget.fieldSpacing),
            ],
          // Render sections
          for (final section in sections)
            if (!_isFieldHidden(section.name))
              _buildSection(context, section),
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
      case GrafitAutoFormFieldType.toggleSwitch:
        return _buildSwitchField(context, field, config, isDisabled);
      case GrafitAutoFormFieldType.select:
        return _buildSelectField(context, field, config, isDisabled);
      case GrafitAutoFormFieldType.radio:
        return _buildRadioField(context, field, config, isDisabled);
      case GrafitAutoFormFieldType.date:
        return _buildDateField(context, field, config, isDisabled);
      case GrafitAutoFormFieldType.array:
        return _buildArrayField(context, field, config, isDisabled);
      case GrafitAutoFormFieldType.object:
        return _buildObjectField(context, field, config, isDisabled);
      case GrafitAutoFormFieldType.section:
        return const SizedBox.shrink(); // Sections are handled separately
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
              label: showLabel ? null : Text(label),
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
              value: value,
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

  Widget _buildArrayField(
    BuildContext context,
    GrafitAutoFormField field,
    GrafitAutoFormFieldConfig? config,
    bool isDisabled,
  ) {
    final label = config?.label ?? field.label ?? _formatLabel(field.name);
    final arrayConfig = field.arrayConfig;
    if (arrayConfig == null) return const SizedBox.shrink();

    final items = _arrayValues[field.name] ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label.isNotEmpty) ...[
          GrafitFormLabel(
            text: label,
            required: field.required,
          ),
          const SizedBox(height: 6),
        ],
        ...List.generate(items.length, (index) {
          return _buildArrayItem(
            context,
            field.name,
            arrayConfig,
            items[index],
            index,
            isDisabled,
          );
        }),
        if ((arrayConfig.maxItems == null || items.length < arrayConfig.maxItems!) && !isDisabled)
          GrafitButton(
            onPressed: () => _addArrayItem(field.name, arrayConfig),
            variant: GrafitButtonVariant.outline,
            size: GrafitButtonSize.sm,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.add, size: 16),
                const SizedBox(width: 4),
                Text(arrayConfig.addLabel),
              ],
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
  }

  Widget _buildArrayItem(
    BuildContext context,
    String fieldName,
    GrafitAutoFormArrayConfig arrayConfig,
    Map<String, dynamic> item,
    int index,
    bool isDisabled,
  ) {
    final theme = Theme.of(context).extension<GrafitTheme>()!;
    final colors = theme.colors;

    return GrafitCard(
      key: ValueKey('$fieldName-$index'),
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 12),
      bordered: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Item ${index + 1}',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: colors.foreground,
                ),
              ),
              if (!isDisabled && (arrayConfig.minItems == null || _arrayValues[fieldName]!.length > arrayConfig.minItems!))
                GrafitButton(
                  onPressed: () => _removeArrayItem(fieldName, index),
                  variant: GrafitButtonVariant.ghost,
                  size: GrafitButtonSize.sm,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.delete_outline, size: 16),
                      const SizedBox(width: 4),
                      Text(arrayConfig.removeLabel),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          _buildNestedSchema(context, arrayConfig.itemSchema, '$fieldName[$index]', isDisabled),
        ],
      ),
    );
  }

  Widget _buildObjectField(
    BuildContext context,
    GrafitAutoFormField field,
    GrafitAutoFormFieldConfig? config,
    bool isDisabled,
  ) {
    final label = config?.label ?? field.label ?? _formatLabel(field.name);
    final objectConfig = field.objectConfig;
    if (objectConfig == null) return const SizedBox.shrink();

    final title = objectConfig.title ?? label;

    return GrafitCard(
      padding: objectConfig.bordered ? const EdgeInsets.all(16) : EdgeInsets.zero,
      margin: EdgeInsets.zero,
      bordered: objectConfig.bordered,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (title.isNotEmpty) ...[
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).extension<GrafitTheme>()!.colors.foreground,
              ),
            ),
            const SizedBox(height: 16),
          ],
          _buildNestedSchema(context, objectConfig.schema, field.name, isDisabled),
        ],
      ),
    );
  }

  Widget _buildNestedSchema(
    BuildContext context,
    GrafitAutoFormSchema schema,
    String prefix,
    bool isDisabled,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final field in schema.fields)
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: _buildNestedField(context, field, '$prefix.${field.name}', isDisabled),
          ),
      ],
    );
  }

  Widget _buildNestedField(
    BuildContext context,
    GrafitAutoFormField field,
    String fullFieldName,
    bool isDisabled,
  ) {
    final config = widget.fieldConfig?[fullFieldName] ?? widget.schema.fieldConfig?[fullFieldName];

    if (config?.builder != null || field.customBuilder != null) {
      return GrafitFormField<dynamic>(
        name: fullFieldName,
        initialValue: field.defaultValue,
        autovalidate: true,
        builder: (context, value, error) {
          return (config?.builder ?? field.customBuilder!)(
            context,
            value,
            error,
            (newValue) => _handleFieldChanged(fullFieldName, newValue),
          );
        },
      );
    }

    switch (config?.fieldType ?? field.type) {
      case GrafitAutoFormFieldType.text:
      case GrafitAutoFormFieldType.email:
      case GrafitAutoFormFieldType.password:
        return _buildNestedTextField(context, field, fullFieldName, config, isDisabled);
      case GrafitAutoFormFieldType.textarea:
        return _buildNestedTextareaField(context, field, fullFieldName, config, isDisabled);
      case GrafitAutoFormFieldType.number:
        return _buildNestedNumberField(context, field, fullFieldName, config, isDisabled);
      case GrafitAutoFormFieldType.checkbox:
        return _buildNestedCheckboxField(context, field, fullFieldName, config, isDisabled);
      case GrafitAutoFormFieldType.toggleSwitch:
        return _buildNestedSwitchField(context, field, fullFieldName, config, isDisabled);
      case GrafitAutoFormFieldType.select:
        return _buildNestedSelectField(context, field, fullFieldName, config, isDisabled);
      case GrafitAutoFormFieldType.radio:
        return _buildNestedRadioField(context, field, fullFieldName, config, isDisabled);
      case GrafitAutoFormFieldType.date:
        return _buildNestedDateField(context, field, fullFieldName, config, isDisabled);
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildNestedTextField(
    BuildContext context,
    GrafitAutoFormField field,
    String fullFieldName,
    GrafitAutoFormFieldConfig? config,
    bool isDisabled,
  ) {
    final inputProps = config?.inputProps;
    final label = config?.label ?? field.label ?? _formatLabel(field.name);
    final showLabel = config?.showLabel ?? field.showLabel;

    return GrafitFormField<String>(
      name: fullFieldName,
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
                required: field.required,
              ),
              const SizedBox(height: 6),
            ],
            GrafitInput(
              label: showLabel ? null : label,
              hint: inputProps?.placeholder ?? field.placeholder,
              value: value ?? '',
              onChanged: (newValue) => _handleFieldChanged(fullFieldName, newValue),
              enabled: !isDisabled,
              obscureText: field.type == GrafitAutoFormFieldType.password ||
                  (inputProps?.obscureText ?? false),
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

  Widget _buildNestedTextareaField(
    BuildContext context,
    GrafitAutoFormField field,
    String fullFieldName,
    GrafitAutoFormFieldConfig? config,
    bool isDisabled,
  ) {
    final inputProps = config?.inputProps;
    final label = config?.label ?? field.label ?? _formatLabel(field.name);
    final showLabel = config?.showLabel ?? field.showLabel;

    return GrafitFormField<String>(
      name: fullFieldName,
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
                required: field.required,
              ),
              const SizedBox(height: 6),
            ],
            GrafitTextarea(
              label: showLabel ? null : Text(label),
              hint: inputProps?.placeholder ?? field.placeholder,
              value: value ?? '',
              onChanged: (newValue) => _handleFieldChanged(fullFieldName, newValue),
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

  Widget _buildNestedNumberField(
    BuildContext context,
    GrafitAutoFormField field,
    String fullFieldName,
    GrafitAutoFormFieldConfig? config,
    bool isDisabled,
  ) {
    final label = config?.label ?? field.label ?? _formatLabel(field.name);
    final showLabel = config?.showLabel ?? field.showLabel;

    return GrafitFormField<num>(
      name: fullFieldName,
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
                required: field.required,
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
                  _handleFieldChanged(fullFieldName, numValue);
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

  Widget _buildNestedCheckboxField(
    BuildContext context,
    GrafitAutoFormField field,
    String fullFieldName,
    GrafitAutoFormFieldConfig? config,
    bool isDisabled,
  ) {
    final label = config?.label ?? field.label ?? _formatLabel(field.name);

    return GrafitFormField<bool>(
      name: fullFieldName,
      initialValue: field.defaultValue as bool? ?? false,
      autovalidate: true,
      builder: (context, value, error) {
        return GrafitCheckbox(
          label: label,
          value: value ?? false,
          onChanged: isDisabled
              ? null
              : (newValue) => _handleFieldChanged(fullFieldName, newValue),
          enabled: !isDisabled,
        );
      },
    );
  }

  Widget _buildNestedSwitchField(
    BuildContext context,
    GrafitAutoFormField field,
    String fullFieldName,
    GrafitAutoFormFieldConfig? config,
    bool isDisabled,
  ) {
    final label = config?.label ?? field.label ?? _formatLabel(field.name);

    return GrafitFormField<bool>(
      name: fullFieldName,
      initialValue: field.defaultValue as bool? ?? false,
      autovalidate: true,
      builder: (context, value, error) {
        return Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  GrafitFormLabel(
                    text: label,
                    required: field.required,
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
                  : (newValue) => _handleFieldChanged(fullFieldName, newValue),
            ),
          ],
        );
      },
    );
  }

  Widget _buildNestedSelectField(
    BuildContext context,
    GrafitAutoFormField field,
    String fullFieldName,
    GrafitAutoFormFieldConfig? config,
    bool isDisabled,
  ) {
    final label = config?.label ?? field.label ?? _formatLabel(field.name);
    final options = field.options ?? [];
    final showLabel = config?.showLabel ?? field.showLabel;

    return GrafitFormField<dynamic>(
      name: fullFieldName,
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
                required: field.required,
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
                  : (newValue) => _handleFieldChanged(fullFieldName, newValue),
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

  Widget _buildNestedRadioField(
    BuildContext context,
    GrafitAutoFormField field,
    String fullFieldName,
    GrafitAutoFormFieldConfig? config,
    bool isDisabled,
  ) {
    final label = config?.label ?? field.label ?? _formatLabel(field.name);
    final options = field.options ?? [];

    return GrafitFormField<dynamic>(
      name: fullFieldName,
      initialValue: field.defaultValue,
      autovalidate: true,
      builder: (context, value, error) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            GrafitFormLabel(
              text: label,
              required: field.required,
            ),
            const SizedBox(height: 6),
            GrafitRadioGroup(
              items: options
                  .map((option) => GrafitRadioItemData(
                        value: option.value,
                        label: option.label,
                      ))
                  .toList(),
              value: value,
              onChanged: isDisabled
                  ? null
                  : (newValue) => _handleFieldChanged(fullFieldName, newValue),
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

  Widget _buildNestedDateField(
    BuildContext context,
    GrafitAutoFormField field,
    String fullFieldName,
    GrafitAutoFormFieldConfig? config,
    bool isDisabled,
  ) {
    final label = config?.label ?? field.label ?? _formatLabel(field.name);
    final showLabel = config?.showLabel ?? field.showLabel;

    return GrafitFormField<DateTime>(
      name: fullFieldName,
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
                required: field.required,
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
                        _handleFieldChanged(fullFieldName, picked);
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

  Widget _buildSection(BuildContext context, GrafitAutoFormField sectionField) {
    final sectionConfig = sectionField.sectionConfig;
    if (sectionConfig == null) return const SizedBox.shrink();

    // Get fields that belong to this section
    final sectionFields = widget.schema.fields
        .where((f) => sectionConfig.fields.contains(f.name) && !_isFieldHidden(f.name))
        .toList();

    if (sectionFields.isEmpty) return const SizedBox.shrink();

    // Check if section is collapsible
    if (sectionConfig.collapsible) {
      final isCollapsed = _collapsedSections[sectionField.name] ?? false;
      return GrafitAccordion(
        type: GrafitAccordionType.multiple,
        initialOpenIndices: isCollapsed ? null : {0},
        items: [
          GrafitAccordionItem(
            value: sectionField.name,
            trigger: GrafitAccordionTrigger(
              label: sectionConfig.title,
              icon: sectionConfig.icon != null
                  ? Icon(sectionConfig.icon, size: 16)
                  : null,
            ),
            content: GrafitAccordionContent(
              child: _buildSectionFields(context, sectionFields),
            ),
          ),
        ],
      );
    }

    // Non-collapsible section - just render with a title
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (sectionConfig.title.isNotEmpty) ...[
          Text(
            sectionConfig.title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).extension<GrafitTheme>()!.colors.foreground,
            ),
          ),
          if (sectionConfig.description != null) ...[
            const SizedBox(height: 4),
            Text(
              sectionConfig.description!,
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(context).extension<GrafitTheme>()!.colors.mutedForeground,
              ),
            ),
          ],
          const SizedBox(height: 16),
        ],
        _buildSectionFields(context, sectionFields),
      ],
    );
  }

  Widget _buildSectionFields(BuildContext context, List<GrafitAutoFormField> fields) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final field in fields) ...[
          _buildField(context, field),
          SizedBox(height: widget.fieldSpacing),
        ],
      ],
    );
  }

  void _addArrayItem(String fieldName, GrafitAutoFormArrayConfig arrayConfig) {
    setState(() {
      final newItem = <String, dynamic>{};
      // Initialize with default values from schema
      for (final field in arrayConfig.itemSchema.fields) {
        if (field.defaultValue != null) {
          newItem[field.name] = field.defaultValue;
        }
      }
      _arrayValues[fieldName] = [..._arrayValues[fieldName] ?? [], newItem];
    });
    widget.onValuesChange?.call(_controller.values);
  }

  void _removeArrayItem(String fieldName, int index) {
    setState(() {
      final items = _arrayValues[fieldName] ?? [];
      if (index >= 0 && index < items.length) {
        items.removeAt(index);
        _arrayValues[fieldName] = items;
      }
    });
    widget.onValuesChange?.call(_controller.values);
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
      type: GrafitAutoFormFieldType.toggleSwitch,
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

  /// Add an array field (array of objects)
  GrafitAutoFormSchemaBuilder addArray({
    required String name,
    required GrafitAutoFormSchema itemSchema,
    String? label,
    bool required = false,
    String? description,
    String? validationMessage,
    int? minItems,
    int? maxItems,
    String addLabel = 'Add Item',
    String removeLabel = 'Remove',
    bool reorderable = true,
  }) {
    return addField(GrafitAutoFormField(
      name: name,
      type: GrafitAutoFormFieldType.array,
      label: label,
      required: required,
      description: description,
      validationMessage: validationMessage,
      arrayConfig: GrafitAutoFormArrayConfig(
        itemSchema: itemSchema,
        minItems: minItems,
        maxItems: maxItems,
        addLabel: addLabel,
        removeLabel: removeLabel,
        reorderable: reorderable,
      ),
    ));
  }

  /// Add an object field (nested object)
  GrafitAutoFormSchemaBuilder addObject({
    required String name,
    required GrafitAutoFormSchema schema,
    String? label,
    bool required = false,
    String? description,
    String? validationMessage,
    bool bordered = true,
    bool collapsible = false,
    String? title,
  }) {
    return addField(GrafitAutoFormField(
      name: name,
      type: GrafitAutoFormFieldType.object,
      label: label,
      required: required,
      description: description,
      validationMessage: validationMessage,
      objectConfig: GrafitAutoFormObjectConfig(
        schema: schema,
        bordered: bordered,
        collapsible: collapsible,
        title: title,
      ),
    ));
  }

  /// Add a section field (accordion section)
  GrafitAutoFormSchemaBuilder addSection({
    required String name,
    required List<String> fields,
    required String title,
    String? description,
    bool collapsible = true,
    bool collapsedByDefault = false,
    IconData? icon,
  }) {
    return addField(GrafitAutoFormField(
      name: name,
      type: GrafitAutoFormFieldType.section,
      sectionConfig: GrafitAutoFormSectionConfig(
        fields: fields,
        title: title,
        description: description,
        collapsible: collapsible,
        collapsedByDefault: collapsedByDefault,
        icon: icon,
      ),
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

/// Extension on GrafitAutoFormField to provide factory constructors for complex field types
extension GrafitAutoFormFieldExtension on GrafitAutoFormField {
  /// Factory constructor for array field items
  static GrafitAutoFormField array({
    required String name,
    required GrafitAutoFormSchema itemSchema,
    String? label,
    bool required = false,
    String? description,
    int? minItems,
    int? maxItems,
    String addLabel = 'Add Item',
    String removeLabel = 'Remove',
  }) {
    return GrafitAutoFormField(
      name: name,
      type: GrafitAutoFormFieldType.array,
      label: label,
      required: required,
      description: description,
      arrayConfig: GrafitAutoFormArrayConfig(
        itemSchema: itemSchema,
        minItems: minItems,
        maxItems: maxItems,
        addLabel: addLabel,
        removeLabel: removeLabel,
      ),
    );
  }

  /// Factory constructor for nested object fields
  static GrafitAutoFormField object({
    required String name,
    required GrafitAutoFormSchema schema,
    String? label,
    bool required = false,
    String? description,
    bool bordered = true,
    bool collapsible = false,
    String? title,
  }) {
    return GrafitAutoFormField(
      name: name,
      type: GrafitAutoFormFieldType.object,
      label: label,
      required: required,
      description: description,
      objectConfig: GrafitAutoFormObjectConfig(
        schema: schema,
        bordered: bordered,
        collapsible: collapsible,
        title: title,
      ),
    );
  }

  /// Factory constructor for section fields
  static GrafitAutoFormField section({
    required String name,
    required List<String> fields,
    required String title,
    String? description,
    bool collapsible = true,
    bool collapsedByDefault = false,
    IconData? icon,
  }) {
    return GrafitAutoFormField(
      name: name,
      type: GrafitAutoFormFieldType.section,
      sectionConfig: GrafitAutoFormSectionConfig(
        fields: fields,
        title: title,
        description: description,
        collapsible: collapsible,
        collapsedByDefault: collapsedByDefault,
        icon: icon,
      ),
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

// ============================================================
// WIDGETBOOK USE CASES
// ============================================================

@widgetbook.UseCase(
  name: 'Default',
  type: GrafitAutoForm,
  path: 'Form/AutoForm',
)
Widget autoFormDefault(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(24.0),
    child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 500),
      child: GrafitAutoForm(
        schema: GrafitAutoFormSchema(
          fields: [
            GrafitAutoFormField(
              name: 'username',
              type: GrafitAutoFormFieldType.text,
              label: 'Username',
              required: true,
              minLength: 3,
            ),
            GrafitAutoFormField(
              name: 'email',
              type: GrafitAutoFormFieldType.email,
              label: 'Email',
              required: true,
            ),
            GrafitAutoFormField(
              name: 'age',
              type: GrafitAutoFormFieldType.number,
              label: 'Age',
              min: 18,
              max: 100,
            ),
          ],
        ),
        onSubmit: (values) {
          print('Form submitted: $values');
        },
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'With Sections',
  type: GrafitAutoForm,
  path: 'Form/AutoForm',
)
Widget autoFormWithSections(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(24.0),
    child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 500),
      child: GrafitAutoForm(
        schema: GrafitAutoFormSchema(
          fields: [
            GrafitAutoFormField(
              name: 'username',
              type: GrafitAutoFormFieldType.text,
              label: 'Username',
              required: true,
            ),
            GrafitAutoFormField(
              name: 'profile',
              type: GrafitAutoFormFieldType.section,
              sectionConfig: GrafitAutoFormSectionConfig(
                fields: ['bio', 'location'],
                title: 'Profile Information',
                description: 'Tell us about yourself',
                collapsible: true,
              ),
            ),
            GrafitAutoFormField(
              name: 'bio',
              type: GrafitAutoFormFieldType.textarea,
              label: 'Bio',
            ),
            GrafitAutoFormField(
              name: 'location',
              type: GrafitAutoFormFieldType.text,
              label: 'Location',
            ),
          ],
        ),
        onSubmit: (values) {
          print('Form submitted: $values');
        },
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'Complete Form',
  type: GrafitAutoForm,
  path: 'Form/AutoForm',
)
Widget autoFormComplete(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(24.0),
    child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 500),
      child: GrafitAutoForm(
        schema: GrafitAutoFormSchema(
          fields: [
            GrafitAutoFormField(
              name: 'fullName',
              type: GrafitAutoFormFieldType.text,
              label: 'Full Name',
              required: true,
              placeholder: 'John Doe',
            ),
            GrafitAutoFormField(
              name: 'email',
              type: GrafitAutoFormFieldType.email,
              label: 'Email',
              required: true,
              placeholder: 'john@example.com',
            ),
            GrafitAutoFormField(
              name: 'role',
              type: GrafitAutoFormFieldType.select,
              label: 'Role',
              required: true,
              options: [
                GrafitAutoFormOption(value: 'user', label: 'User'),
                GrafitAutoFormOption(value: 'admin', label: 'Admin'),
                GrafitAutoFormOption(value: 'moderator', label: 'Moderator'),
              ],
            ),
            GrafitAutoFormField(
              name: 'notifications',
              type: GrafitAutoFormFieldType.toggleSwitch,
              label: 'Email Notifications',
              defaultValue: true,
            ),
            GrafitAutoFormField(
              name: 'bio',
              type: GrafitAutoFormFieldType.textarea,
              label: 'Bio',
              placeholder: 'Tell us about yourself',
            ),
          ],
        ),
        onSubmit: (values) {
          print('Form submitted: $values');
        },
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'Interactive',
  type: GrafitAutoForm,
  path: 'Form/AutoForm',
)
Widget autoFormInteractive(BuildContext context) {
  // Widgetbook-only: ignore undefined_getter, undefined_method, invalid_annotation_value
  final showValidation = context.knobs.boolean(label: 'Show Validation', initialValue: false);
  // Widgetbook-only: ignore undefined_getter, undefined_method, invalid_annotation_value
  final submitButtonText = context.knobs.string(label: 'Submit Button', initialValue: 'Submit');

  return Padding(
    padding: const EdgeInsets.all(24.0),
    child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 500),
      child: GrafitAutoForm(
        schema: GrafitAutoFormSchema(
          fields: [
            GrafitAutoFormField(
              name: 'username',
              type: GrafitAutoFormFieldType.text,
              label: 'Username',
              required: showValidation,
            ),
            GrafitAutoFormField(
              name: 'email',
              type: GrafitAutoFormFieldType.email,
              label: 'Email',
              required: showValidation,
            ),
            GrafitAutoFormField(
              name: 'terms',
              type: GrafitAutoFormFieldType.checkbox,
              label: 'I accept the terms',
              required: showValidation,
            ),
          ],
        ),
        submitButtonText: submitButtonText,
        onSubmit: (values) {
          print('Form submitted: $values');
        },
      ),
    ),
  );
}

