import 'package:flutter/material.dart';
import '../../theme/theme.dart';
import '../../theme/theme_data.dart';
import '../layout/separator.dart';

// Export GrafitLabel from label.dart for convenience
export 'label.dart';

/// Field orientation options
enum GrafitFieldOrientation {
  vertical,
  horizontal,
  responsive,
}

/// Field error data type for validation
class GrafitFieldErrorData {
  final String? message;

  const GrafitFieldErrorData({this.message});
}

/// Field context for sharing state within field components
class _GrafitFieldContext {
  final String? fieldName;
  final bool invalid;
  final bool disabled;

  _GrafitFieldContext({
    this.fieldName,
    this.invalid = false,
    this.disabled = false,
  });
}

/// Inherited widget to share field state
class _GrafitFieldInherited extends InheritedWidget {
  final _GrafitFieldContext context;

  const _GrafitFieldInherited({
    required this.context,
    required super.child,
  });

  static _GrafitFieldInherited? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_GrafitFieldInherited>();
  }

  @override
  bool updateShouldNotify(_GrafitFieldInherited oldWidget) {
    return context != oldWidget.context;
  }
}

/// FieldSet - Container for grouping related form fields
class GrafitFieldSet extends StatelessWidget {
  final Widget child;
  final String? semanticLabel;
  final EdgeInsetsGeometry? padding;

  const GrafitFieldSet({
    super.key,
    required this.child,
    this.semanticLabel,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<GrafitTheme>()!;
    final colors = theme.colors;

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        border: Border.all(
          color: colors.border,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(colors.radius * 8),
      ),
      child: child,
    );
  }
}

/// FieldLegend - Legend element for a FieldSet
class GrafitFieldLegend extends StatelessWidget {
  final String text;
  final bool variantAsLabel;
  final Widget? child;

  const GrafitFieldLegend({
    super.key,
    required this.text,
    this.variantAsLabel = false,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<GrafitTheme>()!;
    final colors = theme.colors;
    final textStyles = theme.text;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: child ??
          Text(
            text,
            style: variantAsLabel
                ? textStyles.labelMedium?.copyWith(
                    color: colors.foreground,
                    fontWeight: FontWeight.w500,
                  )
                : textStyles.titleSmall?.copyWith(
                    color: colors.foreground,
                    fontWeight: FontWeight.w600,
                  ),
          ),
    );
  }
}

/// FieldGroup - Layout wrapper for stacking Field components
class GrafitFieldGroup extends StatelessWidget {
  final List<Widget> children;
  final double spacing;
  final bool enableResponsive;

  const GrafitFieldGroup({
    super.key,
    required this.children,
    this.spacing = 16,
    this.enableResponsive = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: _buildChildren(),
    );
  }

  List<Widget> _buildChildren() {
    final List<Widget> result = [];
    for (int i = 0; i < children.length; i++) {
      result.add(children[i]);
      if (i < children.length - 1) {
        result.add(SizedBox(height: spacing));
      }
    }
    return result;
  }
}

/// Field - Core wrapper for a single form field
class GrafitField extends StatefulWidget {
  final Widget child;
  final GrafitFieldOrientation orientation;
  final bool invalid;
  final bool disabled;
  final String? fieldName;
  final EdgeInsetsGeometry? padding;

  const GrafitField({
    super.key,
    required this.child,
    this.orientation = GrafitFieldOrientation.vertical,
    this.invalid = false,
    this.disabled = false,
    this.fieldName,
    this.padding,
  });

  @override
  State<GrafitField> createState() => _GrafitFieldState();
}

class _GrafitFieldState extends State<GrafitField> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<GrafitTheme>()!;
    final colors = theme.colors;

    final fieldContext = _GrafitFieldContext(
      fieldName: widget.fieldName,
      invalid: widget.invalid,
      disabled: widget.disabled,
    );

    Widget content = _buildContent(context, colors);

    if (widget.padding != null) {
      content = Padding(
        padding: widget.padding!,
        child: content,
      );
    }

    return Opacity(
      opacity: widget.disabled ? 0.5 : 1.0,
      child: _GrafitFieldInherited(
        context: fieldContext,
        child: Semantics(
          container: true,
          enabled: !widget.disabled,
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 200),
            opacity: widget.disabled ? 0.5 : 1.0,
            child: content,
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, GrafitColorScheme colors) {
    switch (widget.orientation) {
      case GrafitFieldOrientation.horizontal:
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 120,
              child: _buildLabelSection(context, colors),
            ),
            const SizedBox(width: 12),
            Expanded(child: widget.child),
          ],
        );
      case GrafitFieldOrientation.responsive:
        return LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth > 600) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 120,
                    child: _buildLabelSection(context, colors),
                  ),
                  const SizedBox(width: 12),
                  Expanded(child: widget.child),
                ],
              );
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildLabelSection(context, colors),
                const SizedBox(height: 6),
                widget.child,
              ],
            );
          },
        );
      case GrafitFieldOrientation.vertical:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildLabelSection(context, colors),
            const SizedBox(height: 6),
            widget.child,
          ],
        );
    }
  }

  Widget _buildLabelSection(BuildContext context, GrafitColorScheme colors) {
    return Builder(
      builder: (context) {
        final labelChild = widget.child;
        return GrafitFieldLabelContainer(
          child: labelChild,
        );
      },
    );
  }
}

/// Internal container for extracting label from child
class GrafitFieldLabelContainer extends StatelessWidget {
  final Widget child;

  const GrafitFieldLabelContainer({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return child;
  }
}

/// FieldContent - Flex column for grouping control and descriptions
class GrafitFieldContent extends StatelessWidget {
  final List<Widget> children;
  final double spacing;

  const GrafitFieldContent({
    super.key,
    required this.children,
    this.spacing = 4,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: _buildChildren(),
    );
  }

  List<Widget> _buildChildren() {
    final List<Widget> result = [];
    for (int i = 0; i < children.length; i++) {
      result.add(children[i]);
      if (i < children.length - 1) {
        result.add(SizedBox(height: spacing));
      }
    }
    return result;
  }
}

/// FieldLabel - Label styled for form fields
class GrafitFieldLabel extends StatelessWidget {
  final String text;
  final bool required;
  final Widget? child;
  final String? semanticId;

  const GrafitFieldLabel({
    super.key,
    required this.text,
    this.required = false,
    this.child,
    this.semanticId,
  });

  @override
  Widget build(BuildContext context) {
    final inheritedContext = _GrafitFieldInherited.of(context);
    final isInvalid = inheritedContext?.context.invalid ?? false;
    final isDisabled = inheritedContext?.context.disabled ?? false;

    final theme = Theme.of(context).extension<GrafitTheme>()!;
    final colors = theme.colors;

    final labelColor = isInvalid
        ? colors.destructive
        : isDisabled
            ? colors.mutedForeground
            : colors.foreground;

    return Semantics(
      label: text,
      header: true,
      child: child ??
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Text(
                  text,
                  style: TextStyle(
                    color: labelColor,
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
          ),
    );
  }
}

/// FieldTitle - Renders a title with label styling
class GrafitFieldTitle extends StatelessWidget {
  final String text;
  final Widget? child;

  const GrafitFieldTitle({
    super.key,
    required this.text,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<GrafitTheme>()!;
    final colors = theme.colors;

    return child ??
        Text(
          text,
          style: TextStyle(
            color: colors.foreground,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        );
  }
}

/// FieldDescription - Helper text for the field
class GrafitFieldDescription extends StatelessWidget {
  final String text;
  final Widget? child;

  const GrafitFieldDescription({
    super.key,
    required this.text,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    final inheritedContext = _GrafitFieldInherited.of(context);
    final isInvalid = inheritedContext?.context.invalid ?? false;

    final theme = Theme.of(context).extension<GrafitTheme>()!;
    final colors = theme.colors;

    final descriptionColor = isInvalid
        ? colors.destructive
        : colors.mutedForeground;

    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: child ??
          Text(
            text,
            style: theme.text.labelSmall?.copyWith(
              color: descriptionColor,
            ),
          ),
    );
  }
}

/// FieldSeparator - Visual divider between field sections
class GrafitFieldSeparator extends StatelessWidget {
  final String? text;
  final Widget? child;

  const GrafitFieldSeparator({
    super.key,
    this.text,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<GrafitTheme>()!;
    final colors = theme.colors;

    if (text != null || child != null) {
      return Row(
        children: [
          Expanded(
            child: GrafitSeparator(
              color: colors.border,
            ),
          ),
          if (text != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                text!,
                style: theme.text.labelSmall?.copyWith(
                  color: colors.mutedForeground,
                ),
              ),
            )
          else if (child != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: child,
            ),
          Expanded(
            child: GrafitSeparator(
              color: colors.border,
            ),
          ),
        ],
      );
    }

    return GrafitSeparator(
      color: colors.border,
    );
  }
}

/// FieldError - Accessible error container for validation messages
class GrafitFieldError extends StatelessWidget {
  final List<GrafitFieldErrorData>? errors;
  final List<String>? errorMessages;
  final Widget? child;

  const GrafitFieldError({
    super.key,
    this.errors,
    this.errorMessages,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<GrafitTheme>()!;
    final colors = theme.colors;

    if (child != null) {
      return Padding(
        padding: const EdgeInsets.only(top: 4),
        child: DefaultTextStyle(
          style: theme.text.labelSmall?.copyWith(
            color: colors.destructive,
          ) ?? TextStyle(
            color: colors.destructive,
            fontSize: 12,
          ),
          child: child!,
        ),
      );
    }

    final content = _buildContent();
    if (content == null) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: DefaultTextStyle(
        style: theme.text.labelSmall?.copyWith(
          color: colors.destructive,
        ) ?? TextStyle(
          color: colors.destructive,
          fontSize: 12,
        ),
        child: content,
      ),
    );
  }

  Widget? _buildContent() {
    if (errors != null && errors!.isNotEmpty) {
      // Deduplicate errors by message
      final uniqueErrors = <String>[];
      final seenMessages = <String>{};
      for (final error in errors!) {
        if (error.message != null && !seenMessages.contains(error.message)) {
          uniqueErrors.add(error.message!);
          seenMessages.add(error.message!);
        }
      }

      if (uniqueErrors.isEmpty) {
        return null;
      }

      if (uniqueErrors.length == 1) {
        return Text(uniqueErrors.first);
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: uniqueErrors
            .map((error) => Padding(
                  padding: const EdgeInsets.only(bottom: 2),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('• ', style: TextStyle(fontSize: 12)),
                      Expanded(child: Text(error, style: const TextStyle(fontSize: 12))),
                    ],
                  ),
                ))
            .toList(),
      );
    }

    if (errorMessages != null && errorMessages!.isNotEmpty) {
      final uniqueMessages = errorMessages!.toSet().toList();
      if (uniqueMessages.isEmpty) {
        return null;
      }

      if (uniqueMessages.length == 1) {
        return Text(uniqueMessages.first);
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: uniqueMessages
            .map((error) => Padding(
                  padding: const EdgeInsets.only(bottom: 2),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('• ', style: TextStyle(fontSize: 12)),
                      Expanded(child: Text(error, style: const TextStyle(fontSize: 12))),
                    ],
                  ),
                ))
            .toList(),
      );
    }

    return null;
  }
}

/// FieldInput - Wrapper for input widgets with proper semantics
class GrafitFieldInput extends StatelessWidget {
  final Widget child;
  final bool invalid;

  const GrafitFieldInput({
    super.key,
    required this.child,
    this.invalid = false,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      child: child,
    );
  }
}

/// FieldMessage - Generic message component (can be description or error)
class GrafitFieldMessage extends StatelessWidget {
  final String text;
  final bool isError;

  const GrafitFieldMessage({
    super.key,
    required this.text,
    this.isError = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<GrafitTheme>()!;
    final colors = theme.colors;

    final messageColor = isError
        ? colors.destructive
        : colors.mutedForeground;

    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Text(
        text,
        style: theme.text.labelSmall?.copyWith(
          color: messageColor,
        ),
      ),
    );
  }
}

/// Convenience widget for creating a complete field with label, input, and error
class GrafitFormFieldWrapper extends StatelessWidget {
  final String label;
  final Widget input;
  final String? description;
  final String? errorText;
  final bool required;
  final bool disabled;
  final GrafitFieldOrientation orientation;

  const GrafitFormFieldWrapper({
    super.key,
    required this.label,
    required this.input,
    this.description,
    this.errorText,
    this.required = false,
    this.disabled = false,
    this.orientation = GrafitFieldOrientation.vertical,
  });

  @override
  Widget build(BuildContext context) {
    return GrafitField(
      orientation: orientation,
      invalid: errorText != null,
      disabled: disabled,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          GrafitFieldLabel(
            text: label,
            required: required,
          ),
          if (orientation != GrafitFieldOrientation.horizontal)
            const SizedBox(height: 6),
          GrafitFieldInput(invalid: errorText != null, child: input),
          if (description != null && errorText == null)
            GrafitFieldDescription(text: description!),
          if (errorText != null)
            GrafitFieldError(
              errorMessages: [errorText!],
            ),
        ],
      ),
    );
  }
}
