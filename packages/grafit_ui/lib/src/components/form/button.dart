import 'package:flutter/material.dart';
import '../../theme/theme.dart';
import '../../theme/theme_data.dart';
import '../../primitives/clickable.dart';

/// Button variants
enum GrafitButtonVariant {
  primary,
  secondary,
  ghost,
  link,
  destructive,
  outline,
}

/// Button sizes
enum GrafitButtonSize {
  sm,
  md,
  lg,
  icon,
}

/// Button component with variants and sizes
class GrafitButton extends StatelessWidget {
  final String? label;
  final Widget? child;
  final VoidCallback? onPressed;
  final GrafitButtonVariant variant;
  final GrafitButtonSize size;
  final bool fullWidth;
  final bool disabled;
  final IconData? icon;
  final Widget? leading;
  final Widget? trailing;
  final bool loading;

  const GrafitButton({
    super.key,
    this.label,
    this.child,
    this.onPressed,
    this.variant = GrafitButtonVariant.primary,
    this.size = GrafitButtonSize.md,
    this.fullWidth = false,
    this.disabled = false,
    this.icon,
    this.leading,
    this.trailing,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<GrafitTheme>()!;
    final colors = theme.colors;
    final effectiveDisabled = disabled || onPressed == null || loading;

    return _GrafitButtonStyle(
      variant: variant,
      size: size,
      fullWidth: fullWidth,
      disabled: effectiveDisabled,
      colors: colors,
      child: GrafitClickable(
        enabled: !effectiveDisabled,
        onTap: loading ? null : onPressed,
        child: _buildContent(context),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    final content = child ??
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (loading) ...[
              SizedBox(
                width: _getIconSize(),
                height: _getIconSize(),
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    // Will be set by IconTheme in parent
                    Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 8),
            ] else if (icon != null) ...[
              Icon(icon, size: _getIconSize()),
              const SizedBox(width: 8),
            ] else if (leading != null) ...[
              leading!,
              const SizedBox(width: 8),
            ],
            if (label != null)
              Text(
                label!,
                style: _getTextStyle(),
              ),
            if (trailing != null && !loading) ...[
              const SizedBox(width: 8),
              trailing!,
            ],
          ],
        );

    return content;
  }

  double _getIconSize() {
    return switch (size) {
      GrafitButtonSize.sm => 16.0,
      GrafitButtonSize.md => 18.0,
      GrafitButtonSize.lg => 20.0,
      GrafitButtonSize.icon => 20.0,
    };
  }

  TextStyle? _getTextStyle() {
    return switch (size) {
      GrafitButtonSize.sm => const TextStyle(fontSize: 13),
      GrafitButtonSize.md => const TextStyle(fontSize: 14),
      GrafitButtonSize.lg => const TextStyle(fontSize: 15),
      GrafitButtonSize.icon => const TextStyle(fontSize: 14),
    };
  }
}

/// Internal button style widget
class _GrafitButtonStyle extends StatelessWidget {
  final GrafitButtonVariant variant;
  final GrafitButtonSize size;
  final bool fullWidth;
  final bool disabled;
  final GrafitColorScheme colors;
  final Widget child;

  const _GrafitButtonStyle({
    required this.variant,
    required this.size,
    required this.fullWidth,
    required this.disabled,
    required this.colors,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final isHovered = context.isClickableHovered;
    final isPressed = context.isClickablePressed;
    final isFocused = context.isClickableFocused;
    final style = _getButtonStyle(isHovered, isPressed, isFocused);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      curve: Curves.easeInOut,
      decoration: style.decoration,
      padding: style.padding,
      constraints: BoxConstraints(
        minWidth: size == GrafitButtonSize.icon ? 40 : 0,
      ),
      child: Center(
        child: DefaultTextStyle(
          style: style.textStyle,
          child: IconTheme(
            data: IconThemeData(color: style.foreground, size: style.iconSize),
            child: child,
          ),
        ),
      ),
    );
  }

  _ButtonStyleData _getButtonStyle(bool isHovered, bool isPressed, bool isFocused) {
    return switch (variant) {
      GrafitButtonVariant.primary => _primaryStyle(isHovered, isPressed, isFocused),
      GrafitButtonVariant.secondary => _secondaryStyle(isHovered, isPressed, isFocused),
      GrafitButtonVariant.ghost => _ghostStyle(isHovered, isPressed, isFocused),
      GrafitButtonVariant.link => _linkStyle(isHovered, isPressed, isFocused),
      GrafitButtonVariant.destructive => _destructiveStyle(isHovered, isPressed, isFocused),
      GrafitButtonVariant.outline => _outlineStyle(isHovered, isPressed, isFocused),
    };
  }

  _ButtonStyleData _primaryStyle(bool isHovered, bool isPressed, bool isFocused) {
    final foreground = disabled
        ? colors.mutedForeground
        : colors.primaryForeground;
    final background = disabled
        ? colors.muted
        : isPressed
            ? colors.primary.withOpacity(0.9)
            : isHovered
                ? colors.primary.withOpacity(0.95)
                : colors.primary;
    final border = colors.border;

    return _ButtonStyleData(
      foreground: foreground,
      background: background,
      border: border,
      textStyle: _getTextStyle().copyWith(
        color: foreground,
        fontWeight: FontWeight.w500,
      ),
      padding: _getPadding(),
      decoration: BoxDecoration(
        color: background,
        border: Border.all(color: border),
        borderRadius: BorderRadius.circular(colors.radius * 8),
        boxShadow: isFocused
            ? [
                BoxShadow(
                  color: colors.ring.withOpacity(0.5),
                  blurRadius: 4,
                  spreadRadius: 1,
                ),
              ]
            : null,
      ),
      iconSize: _getIconSize(),
    );
  }

  _ButtonStyleData _secondaryStyle(bool isHovered, bool isPressed, bool isFocused) {
    final foreground = disabled
        ? colors.mutedForeground
        : colors.secondaryForeground;
    final background = disabled
        ? colors.muted
        : isPressed
            ? colors.secondary.withOpacity(0.8)
            : colors.secondary;
    final border = colors.border;

    return _ButtonStyleData(
      foreground: foreground,
      background: background,
      border: border,
      textStyle: _getTextStyle().copyWith(
        color: foreground,
        fontWeight: FontWeight.w500,
      ),
      padding: _getPadding(),
      decoration: BoxDecoration(
        color: background,
        border: Border.all(color: border),
        borderRadius: BorderRadius.circular(colors.radius * 8),
        boxShadow: isFocused
            ? [
                BoxShadow(
                  color: colors.ring.withOpacity(0.5),
                  blurRadius: 4,
                  spreadRadius: 1,
                ),
              ]
            : null,
      ),
      iconSize: _getIconSize(),
    );
  }

  _ButtonStyleData _ghostStyle(bool isHovered, bool isPressed, bool isFocused) {
    final foreground = disabled
        ? colors.mutedForeground
        : colors.foreground;
    final background = disabled
        ? Colors.transparent
        : isPressed
            ? colors.muted.withOpacity(0.5)
            : isHovered
                ? colors.muted.withOpacity(0.3)
                : Colors.transparent;

    return _ButtonStyleData(
      foreground: foreground,
      background: background,
      border: Colors.transparent,
      textStyle: _getTextStyle().copyWith(
        color: foreground,
        fontWeight: FontWeight.w500,
      ),
      padding: _getPadding(),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(colors.radius * 8),
        boxShadow: isFocused
            ? [
                BoxShadow(
                  color: colors.ring.withOpacity(0.5),
                  blurRadius: 4,
                  spreadRadius: 1,
                ),
              ]
            : null,
      ),
      iconSize: _getIconSize(),
    );
  }

  _ButtonStyleData _linkStyle(bool isHovered, bool isPressed, bool isFocused) {
    final foreground = disabled
        ? colors.mutedForeground
        : isPressed
            ? colors.primary.withOpacity(0.7)
            : isHovered
                ? colors.primary
                : colors.primary;

    return _ButtonStyleData(
      foreground: foreground,
      background: Colors.transparent,
      border: Colors.transparent,
      textStyle: _getTextStyle().copyWith(
        color: foreground,
        fontWeight: FontWeight.w500,
        decoration: TextDecoration.underline,
      ),
      padding: size == GrafitButtonSize.icon
          ? const EdgeInsets.all(8)
          : const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(colors.radius * 8),
        boxShadow: isFocused
            ? [
                BoxShadow(
                  color: colors.ring.withOpacity(0.5),
                  blurRadius: 4,
                  spreadRadius: 1,
                ),
              ]
            : null,
      ),
      iconSize: _getIconSize(),
    );
  }

  _ButtonStyleData _destructiveStyle(bool isHovered, bool isPressed, bool isFocused) {
    final foreground = disabled
        ? colors.mutedForeground
        : colors.destructiveForeground;
    final background = disabled
        ? colors.muted
        : isPressed
            ? colors.destructive.withOpacity(0.9)
            : isHovered
                ? colors.destructive.withOpacity(0.95)
                : colors.destructive;
    final border = colors.border;

    return _ButtonStyleData(
      foreground: foreground,
      background: background,
      border: border,
      textStyle: _getTextStyle().copyWith(
        color: foreground,
        fontWeight: FontWeight.w500,
      ),
      padding: _getPadding(),
      decoration: BoxDecoration(
        color: background,
        border: Border.all(color: border),
        borderRadius: BorderRadius.circular(colors.radius * 8),
        boxShadow: isFocused
            ? [
                BoxShadow(
                  color: colors.ring.withOpacity(0.5),
                  blurRadius: 4,
                  spreadRadius: 1,
                ),
              ]
            : null,
      ),
      iconSize: _getIconSize(),
    );
  }

  _ButtonStyleData _outlineStyle(bool isHovered, bool isPressed, bool isFocused) {
    final foreground = disabled
        ? colors.mutedForeground
        : colors.foreground;
    final background = disabled
        ? Colors.transparent
        : isPressed
            ? colors.muted.withOpacity(0.2)
            : Colors.transparent;
    final border = disabled
        ? colors.border
        : colors.input;

    return _ButtonStyleData(
      foreground: foreground,
      background: background,
      border: border,
      textStyle: _getTextStyle().copyWith(
        color: foreground,
        fontWeight: FontWeight.w500,
      ),
      padding: _getPadding(),
      decoration: BoxDecoration(
        color: background,
        border: Border.all(color: border),
        borderRadius: BorderRadius.circular(colors.radius * 8),
        boxShadow: isFocused
            ? [
                BoxShadow(
                  color: colors.ring.withOpacity(0.5),
                  blurRadius: 4,
                  spreadRadius: 1,
                ),
              ]
            : null,
      ),
      iconSize: _getIconSize(),
    );
  }

  TextStyle _getTextStyle() {
    return switch (size) {
      GrafitButtonSize.sm => const TextStyle(fontSize: 13),
      GrafitButtonSize.md => const TextStyle(fontSize: 14),
      GrafitButtonSize.lg => const TextStyle(fontSize: 15),
      GrafitButtonSize.icon => const TextStyle(fontSize: 14),
    };
  }

  EdgeInsets _getPadding() {
    return switch (size) {
      GrafitButtonSize.sm => const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      GrafitButtonSize.md => const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      GrafitButtonSize.lg => const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      GrafitButtonSize.icon => const EdgeInsets.all(8),
    };
  }

  double _getIconSize() {
    return switch (size) {
      GrafitButtonSize.sm => 16.0,
      GrafitButtonSize.md => 18.0,
      GrafitButtonSize.lg => 20.0,
      GrafitButtonSize.icon => 20.0,
    };
  }
}

/// Internal style data class
class _ButtonStyleData {
  final Color foreground;
  final Color background;
  final Color border;
  final TextStyle textStyle;
  final EdgeInsets padding;
  final Decoration decoration;
  final double iconSize;

  const _ButtonStyleData({
    required this.foreground,
    required this.background,
    required this.border,
    required this.textStyle,
    required this.padding,
    required this.decoration,
    required this.iconSize,
  });
}
