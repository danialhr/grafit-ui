import 'package:flutter/material.dart';
import '../../theme/theme.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

/// Separator component
class GrafitSeparator extends StatelessWidget {
  final bool horizontal;
  final double? thickness;
  final Color? color;
  final double? spacing;
  final bool decorative;

  const GrafitSeparator({
    super.key,
    this.horizontal = true,
    this.thickness,
    this.color,
    this.spacing,
    this.decorative = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<GrafitTheme>()!;
    final colors = theme.colors;

    final separator = horizontal
        ? Container(
            height: thickness ?? 1,
            margin: EdgeInsets.symmetric(vertical: spacing ?? 8),
            decoration: BoxDecoration(
              color: color ?? colors.border,
            ),
          )
        : Container(
            width: thickness ?? 1,
            margin: EdgeInsets.symmetric(horizontal: spacing ?? 8),
            decoration: BoxDecoration(
              color: color ?? colors.border,
            ),
          );

    // Use Semantics for accessibility when decorative=false
    if (decorative) {
      return Semantics(
        container: true,
        child: separator,
      );
    }

    return ExcludeSemantics(
      child: separator,
    );
  }
}

// Widgetbook use cases
@widgetbook.UseCase(
  name: 'Horizontal',
  type: GrafitSeparator,
  path: 'Layout/Separator',
)
Widget separatorHorizontal(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.all(16.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Content above separator'),
        GrafitSeparator(),
        Text('Content below separator'),
      ],
    ),
  );
}

@widgetbook.UseCase(
  name: 'Vertical',
  type: GrafitSeparator,
  path: 'Layout/Separator',
)
Widget separatorVertical(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.all(16.0),
    child: Row(
      children: [
        Text('Left content'),
        GrafitSeparator(horizontal: false),
        Text('Right content'),
      ],
    ),
  );
}

@widgetbook.UseCase(
  name: 'Custom Thickness',
  type: GrafitSeparator,
  path: 'Layout/Separator',
)
Widget separatorThickness(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.all(16.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Thin separator'),
        GrafitSeparator(thickness: 1),
        Text('Medium separator'),
        GrafitSeparator(thickness: 2),
        Text('Thick separator'),
        GrafitSeparator(thickness: 4),
      ],
    ),
  );
}

@widgetbook.UseCase(
  name: 'Custom Spacing',
  type: GrafitSeparator,
  path: 'Layout/Separator',
)
Widget separatorSpacing(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.all(16.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('No spacing'),
        GrafitSeparator(spacing: 0),
        Text('Small spacing'),
        GrafitSeparator(spacing: 4),
        Text('Large spacing'),
        GrafitSeparator(spacing: 24),
      ],
    ),
  );
}

@widgetbook.UseCase(
  name: 'Custom Color',
  type: GrafitSeparator,
  path: 'Layout/Separator',
)
Widget separatorColor(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text('Default color separator'),
        const GrafitSeparator(),
        const Text('Red separator'),
        GrafitSeparator(color: Colors.red),
        const Text('Blue separator'),
        GrafitSeparator(color: Colors.blue),
        const Text('Green separator'),
        GrafitSeparator(color: Colors.green),
      ],
    ),
  );
}

@widgetbook.UseCase(
  name: 'Multiple Separators',
  type: GrafitSeparator,
  path: 'Layout/Separator',
)
Widget separatorMultiple(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.all(16.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Section 1'),
        GrafitSeparator(),
        Text('Section 2'),
        GrafitSeparator(),
        Text('Section 3'),
        GrafitSeparator(),
        Text('Section 4'),
        GrafitSeparator(),
        Text('Section 5'),
      ],
    ),
  );
}

@widgetbook.UseCase(
  name: 'With Cards',
  type: GrafitSeparator,
  path: 'Layout/Separator',
)
Widget separatorWithCards(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text('Card 1 content'),
        ),
        GrafitSeparator(spacing: 16),
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text('Card 2 content'),
        ),
        GrafitSeparator(spacing: 16),
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text('Card 3 content'),
        ),
      ],
    ),
  );
}

@widgetbook.UseCase(
  name: 'Interactive',
  type: GrafitSeparator,
  path: 'Layout/Separator',
)
Widget separatorInteractive(BuildContext context) {
  // Widgetbook-only: ignore undefined_getter, undefined_method, invalid_annotation_value
  final horizontal = context.knobs.boolean(label: 'Horizontal', initialValue: true);
  // Widgetbook-only: ignore undefined_getter, undefined_method, invalid_annotation_value
  final thickness = context.knobs.double.slider(
    label: 'Thickness',
    initialValue: 1,
    min: 0.5,
    max: 8,
  );
  // Widgetbook-only: ignore undefined_getter, undefined_method, invalid_annotation_value
  final spacing = context.knobs.double.slider(
    label: 'Spacing',
    initialValue: 8,
    min: 0,
    max: 32,
  );
  // Widgetbook-only: ignore undefined_getter, undefined_method, invalid_annotation_value
  final useCustomColor = context.knobs.boolean(label: 'Custom Color', initialValue: false);
  // Widgetbook-only: ignore undefined_getter, undefined_method, invalid_annotation_value
  final colorValue = context.knobs.color.label(
    label: 'Color',
    initialValue: const Color(0xFFe5e7eb),
  );

  final color = useCustomColor ? colorValue : null;

  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: horizontal
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text('Content above separator'),
              GrafitSeparator(
                horizontal: horizontal,
                thickness: thickness,
                spacing: spacing,
                color: color,
              ),
              const Text('Content below separator'),
            ],
          )
        : Row(
            children: [
              const Text('Left content'),
              GrafitSeparator(
                horizontal: horizontal,
                thickness: thickness,
                spacing: spacing,
                color: color,
              ),
              const Text('Right content'),
            ],
          ),
  );
}
