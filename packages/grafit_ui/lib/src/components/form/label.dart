import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import '../../theme/theme.dart';
import '../../theme/theme_data.dart';

/// Label component
class GrafitLabel extends StatelessWidget {
  final String text;
  final Widget? child;
  final bool required;
  final bool disabled;

  const GrafitLabel({
    super.key,
    required this.text,
    this.child,
    this.required = false,
    this.disabled = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<GrafitTheme>()!;
    final colors = theme.colors;

    final labelChild = child ??
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Text(
                text,
                style: TextStyle(
                  color: disabled
                      ? colors.mutedForeground
                      : colors.foreground,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            if (required)
              Text(
                ' *',
                style: TextStyle(
                  color: colors.destructive,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
          ],
        );

    return Opacity(
      opacity: disabled ? 0.5 : 1.0,
      child: labelChild,
    );
  }
}

// ============================================================
// WIDGETBOOK USE CASES
// ============================================================

@widgetbook.UseCase(
  name: 'Default',
  type: GrafitLabel,
  path: 'Form/Label',
)
Widget labelDefault(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.all(24.0),
    child: GrafitLabel(text: 'Email'),
  );
}

@widgetbook.UseCase(
  name: 'Required',
  type: GrafitLabel,
  path: 'Form/Label',
)
Widget labelRequired(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.all(24.0),
    child: GrafitLabel(
      text: 'Password',
      required: true,
    ),
  );
}

@widgetbook.UseCase(
  name: 'Disabled',
  type: GrafitLabel,
  path: 'Form/Label',
)
Widget labelDisabled(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.all(24.0),
    child: GrafitLabel(
      text: 'Disabled Label',
      disabled: true,
    ),
  );
}

@widgetbook.UseCase(
  name: 'Multiple Labels',
  type: GrafitLabel,
  path: 'Form/Label',
)
Widget labelMultiple(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.all(24.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GrafitLabel(text: 'First Name'),
        SizedBox(height: 8),
        GrafitLabel(text: 'Last Name', required: true),
        SizedBox(height: 8),
        GrafitLabel(text: 'Disabled Field', disabled: true),
      ],
    ),
  );
}

@widgetbook.UseCase(
  name: 'Interactive',
  type: GrafitLabel,
  path: 'Form/Label',
)
Widget labelInteractive(BuildContext context) {
  // Widgetbook-only: ignore undefined_getter, undefined_method, invalid_annotation_value
  final text = context.knobs.string(label: 'Text', initialValue: 'Email');
  // Widgetbook-only: ignore undefined_getter, undefined_method, invalid_annotation_value
  final required = context.knobs.boolean(label: 'Required', initialValue: false);
  // Widgetbook-only: ignore undefined_getter, undefined_method, invalid_annotation_value
  final disabled = context.knobs.boolean(label: 'Disabled', initialValue: false);

  return Padding(
    padding: const EdgeInsets.all(24.0),
    child: GrafitLabel(
      text: text.isNotEmpty ? text : 'Label',
      required: required,
      disabled: disabled,
    ),
  );
}

