import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import '../../theme/theme.dart';
import '../../theme/theme_data.dart';
import '../../primitives/clickable.dart';

/// Toggle variants
enum GrafitToggleVariant {
  primary,
  outline,
}

/// Toggle sizes
enum GrafitToggleSize {
  sm,
  md,
  lg,
}

/// Toggle button component - a button that can be pressed in/out
/// Based on shadcn-ui/ui toggle component
class GrafitToggle extends StatefulWidget {
  /// Whether the toggle is currently pressed/on
  final bool pressed;

  /// Callback when toggle state changes
  final ValueChanged<bool>? onPressed;

  /// The variant style to use
  final GrafitToggleVariant variant;

  /// The size of the toggle
  final GrafitToggleSize size;

  /// Whether the toggle is disabled
  final bool disabled;

  /// Child widget (typically an icon)
  final Widget child;

  /// Tooltip text
  final String? tooltip;

  const GrafitToggle({
    super.key,
    required this.pressed,
    required this.child,
    this.onPressed,
    this.variant = GrafitToggleVariant.primary,
    this.size = GrafitToggleSize.md,
    this.disabled = false,
    this.tooltip,
  });

  @override
  State<GrafitToggle> createState() => _GrafitToggleState();
}

class _GrafitToggleState extends State<GrafitToggle> {
  late bool _pressed;

  @override
  void initState() {
    super.initState();
    _pressed = widget.pressed;
  }

  @override
  void didUpdateWidget(GrafitToggle oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.pressed != oldWidget.pressed) {
      _pressed = widget.pressed;
    }
  }

  void _handleTap() {
    final newPressed = !_pressed;
    setState(() {
      _pressed = newPressed;
    });
    widget.onPressed?.call(newPressed);
  }

  @override
  Widget build(BuildContext context) {
    final toggleWidget = _GrafitToggleButton(
      pressed: _pressed,
      onPressed: widget.disabled ? null : _handleTap,
      variant: widget.variant,
      size: widget.size,
      disabled: widget.disabled,
      child: widget.child,
    );

    if (widget.tooltip != null) {
      return Tooltip(
        message: widget.tooltip!,
        child: toggleWidget,
      );
    }

    return toggleWidget;
  }
}

/// Internal toggle button widget that handles styling
class _GrafitToggleButton extends StatelessWidget {
  final bool pressed;
  final VoidCallback? onPressed;
  final GrafitToggleVariant variant;
  final GrafitToggleSize size;
  final bool disabled;
  final Widget child;

  const _GrafitToggleButton({
    required this.pressed,
    required this.onPressed,
    required this.variant,
    required this.size,
    required this.disabled,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<GrafitTheme>()!;
    final colors = theme.colors;
    final effectiveEnabled = !disabled && onPressed != null;
    final sizeConfig = _getSizeConfig();

    return GrafitClickable(
      enabled: effectiveEnabled,
      onTap: onPressed,
      child: Builder(
        builder: (innerContext) {
          final isHovered = innerContext.isClickableHovered;
          final isPressedState = innerContext.isClickablePressed;
          final isFocused = innerContext.isClickableFocused;

          final style =
              _getToggleStyle(colors, isHovered, isPressedState, isFocused);

          return AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            curve: Curves.easeInOut,
            width: sizeConfig.width,
            height: sizeConfig.height,
            padding: sizeConfig.padding,
            decoration: BoxDecoration(
              color: style.backgroundColor,
              border: style.border != null
                  ? Border.all(color: style.border!, width: 1)
                  : null,
              borderRadius: BorderRadius.circular(colors.radius * 6),
              boxShadow: style.boxShadow,
            ),
            child: Center(
              child: IconTheme(
                data: IconThemeData(
                  color: style.foregroundColor,
                  size: sizeConfig.iconSize,
                ),
                child: child,
              ),
            ),
          );
        },
      ),
    );
  }

  _ToggleStyle _getToggleStyle(
    GrafitColorScheme colors,
    bool isHovered,
    bool isPressedState,
    bool isFocused,
  ) {
    return switch (variant) {
      GrafitToggleVariant.primary =>
        _primaryStyle(colors, isHovered, isPressedState, isFocused),
      GrafitToggleVariant.outline =>
        _outlineStyle(colors, isHovered, isPressedState, isFocused),
    };
  }

  _ToggleStyle _primaryStyle(
    GrafitColorScheme colors,
    bool isHovered,
    bool isPressedState,
    bool isFocused,
  ) {
    final backgroundColor = disabled
        ? colors.transparent
        : this.pressed
            ? colors.accent
            : isPressedState
                ? colors.muted.withOpacity(0.5)
                : isHovered
                    ? colors.muted.withOpacity(0.3)
                    : colors.transparent;

    final foregroundColor = disabled
        ? colors.mutedForeground
        : this.pressed
            ? colors.accentForeground
            : colors.foreground;

    final boxShadow = isFocused
        ? [
            BoxShadow(
              color: colors.ring.withOpacity(0.5),
              blurRadius: 4,
              spreadRadius: 1,
            ),
          ]
        : null;

    return _ToggleStyle(
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      border: null,
      boxShadow: boxShadow,
    );
  }

  _ToggleStyle _outlineStyle(
    GrafitColorScheme colors,
    bool isHovered,
    bool isPressedState,
    bool isFocused,
  ) {
    final backgroundColor = disabled
        ? colors.transparent
        : this.pressed
            ? colors.accent
            : isPressedState
                ? colors.muted.withOpacity(0.2)
                : colors.transparent;

    final foregroundColor = disabled
        ? colors.mutedForeground
        : this.pressed
            ? colors.accentForeground
            : colors.foreground;

    final borderColor = disabled
        ? colors.border
        : this.pressed
            ? colors.accent
            : colors.input;

    final boxShadow = isFocused
        ? [
            BoxShadow(
              color: colors.ring.withOpacity(0.5),
              blurRadius: 4,
              spreadRadius: 1,
            ),
          ]
        : null;

    return _ToggleStyle(
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      border: borderColor,
      boxShadow: boxShadow,
    );
  }

  _SizeConfig _getSizeConfig() {
    return switch (size) {
      GrafitToggleSize.sm => _SizeConfig(
          width: 32,
          height: 32,
          padding: const EdgeInsets.all(4),
          iconSize: 16,
        ),
      GrafitToggleSize.md => _SizeConfig(
          width: 36,
          height: 36,
          padding: const EdgeInsets.all(6),
          iconSize: 18,
        ),
      GrafitToggleSize.lg => _SizeConfig(
          width: 40,
          height: 40,
          padding: const EdgeInsets.all(8),
          iconSize: 20,
        ),
    };
  }
}

/// Internal style data class
class _ToggleStyle {
  final Color backgroundColor;
  final Color foregroundColor;
  final Color? border;
  final List<BoxShadow>? boxShadow;

  const _ToggleStyle({
    required this.backgroundColor,
    required this.foregroundColor,
    this.border,
    this.boxShadow,
  });
}

/// Size configuration class
class _SizeConfig {
  final double width;
  final double height;
  final EdgeInsets padding;
  final double iconSize;

  const _SizeConfig({
    required this.width,
    required this.height,
    required this.padding,
    required this.iconSize,
  });
}

// ============================================================
// WIDGETBOOK USE CASES
// ============================================================

@widgetbook.UseCase(
  name: 'Default',
  type: GrafitToggle,
  path: 'Form/Toggle',
)
Widget toggleDefault(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.all(24.0),
    child: GrafitToggle(
      pressed: true,
      child: Icon(Icons.format_bold),
    ),
  );
}

@widgetbook.UseCase(
  name: 'Unpressed',
  type: GrafitToggle,
  path: 'Form/Toggle',
)
Widget toggleUnpressed(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.all(24.0),
    child: GrafitToggle(
      pressed: false,
      child: Icon(Icons.format_italic),
    ),
  );
}

@widgetbook.UseCase(
  name: 'Outline Variant',
  type: GrafitToggle,
  path: 'Form/Toggle',
)
Widget toggleOutline(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.all(24.0),
    child: Row(
      children: [
        GrafitToggle(
          pressed: true,
          variant: GrafitToggleVariant.outline,
          child: Icon(Icons.format_bold),
        ),
        SizedBox(width: 8),
        GrafitToggle(
          pressed: false,
          variant: GrafitToggleVariant.outline,
          child: Icon(Icons.format_italic),
        ),
      ],
    ),
  );
}

@widgetbook.UseCase(
  name: 'Small Size',
  type: GrafitToggle,
  path: 'Form/Toggle',
)
Widget toggleSmall(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.all(24.0),
    child: Row(
      children: [
        GrafitToggle(
          pressed: true,
          size: GrafitToggleSize.sm,
          child: Icon(Icons.format_bold),
        ),
        SizedBox(width: 8),
        GrafitToggle(
          pressed: false,
          size: GrafitToggleSize.sm,
          child: Icon(Icons.format_italic),
        ),
      ],
    ),
  );
}

@widgetbook.UseCase(
  name: 'Large Size',
  type: GrafitToggle,
  path: 'Form/Toggle',
)
Widget toggleLarge(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.all(24.0),
    child: Row(
      children: [
        GrafitToggle(
          pressed: true,
          size: GrafitToggleSize.lg,
          child: Icon(Icons.format_bold),
        ),
        SizedBox(width: 8),
        GrafitToggle(
          pressed: false,
          size: GrafitToggleSize.lg,
          child: Icon(Icons.format_italic),
        ),
      ],
    ),
  );
}

@widgetbook.UseCase(
  name: 'With Text',
  type: GrafitToggle,
  path: 'Form/Toggle',
)
Widget toggleWithText(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.all(24.0),
    child: Row(
      children: [
        GrafitToggle(
          pressed: true,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Text('Bold'),
          ),
        ),
        SizedBox(width: 8),
        GrafitToggle(
          pressed: false,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Text('Italic'),
          ),
        ),
      ],
    ),
  );
}

@widgetbook.UseCase(
  name: 'Disabled',
  type: GrafitToggle,
  path: 'Form/Toggle',
)
Widget toggleDisabled(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.all(24.0),
    child: Row(
      children: [
        GrafitToggle(
          pressed: true,
          disabled: true,
          child: Icon(Icons.format_bold),
        ),
        SizedBox(width: 8),
        GrafitToggle(
          pressed: false,
          disabled: true,
          child: Icon(Icons.format_italic),
        ),
      ],
    ),
  );
}

@widgetbook.UseCase(
  name: 'Interactive',
  type: GrafitToggle,
  path: 'Form/Toggle',
)
Widget toggleInteractive(BuildContext context) {
  // Widgetbook-only: ignore undefined_getter, undefined_method, invalid_annotation_value
  final pressed = context.knobs.boolean(label: 'Pressed', initialValue: false);
  // Widgetbook-only: ignore undefined_getter, undefined_method, invalid_annotation_value
  final variant = context.knobs.list(
    label: 'Variant',
    initialOption: GrafitToggleVariant.primary,
    options: const [GrafitToggleVariant.primary, GrafitToggleVariant.outline],
  );
  // Widgetbook-only: ignore undefined_getter, undefined_method, invalid_annotation_value
  final size = context.knobs.list(
    label: 'Size',
    initialOption: GrafitToggleSize.md,
    options: const [GrafitToggleSize.sm, GrafitToggleSize.md, GrafitToggleSize.lg],
  );
  // Widgetbook-only: ignore undefined_getter, undefined_method, invalid_annotation_value
  final disabled = context.knobs.boolean(label: 'Disabled', initialValue: false);

  return Padding(
    padding: const EdgeInsets.all(24.0),
    child: GrafitToggle(
      pressed: pressed,
      variant: variant,
      size: size,
      disabled: disabled,
      child: const Icon(Icons.format_bold),
    ),
  );
}

