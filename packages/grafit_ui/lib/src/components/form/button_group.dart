import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import '../../theme/theme.dart';
import '../../theme/theme_data.dart';
import '../../primitives/clickable.dart';
import 'button.dart';

/// Orientation for button group layout
enum GrafitButtonGroupOrientation {
  horizontal,
  vertical,
}

/// Button Group container component
/// Groups buttons with connected styling (no gaps between borders)
class GrafitButtonGroup extends StatelessWidget {
  final List<Widget> children;
  final GrafitButtonGroupOrientation orientation;
  final MainAxisSize mainAxisSize;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisAlignment mainAxisAlignment;

  const GrafitButtonGroup({
    super.key,
    required this.children,
    this.orientation = GrafitButtonGroupOrientation.horizontal,
    this.mainAxisSize = MainAxisSize.min,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.mainAxisAlignment = MainAxisAlignment.start,
  });

  @override
  Widget build(BuildContext context) {
    if (children.isEmpty) {
      return const SizedBox.shrink();
    }

    final theme = Theme.of(context).extension<GrafitTheme>()!;
    final colors = theme.colors;

    return _ButtonGroupLayout(
      orientation: orientation,
      mainAxisSize: mainAxisSize,
      crossAxisAlignment: crossAxisAlignment,
      mainAxisAlignment: mainAxisAlignment,
      colors: colors,
      children: children,
    );
  }
}

/// Internal layout widget that handles position-aware styling
class _ButtonGroupLayout extends StatelessWidget {
  final List<Widget> children;
  final GrafitButtonGroupOrientation orientation;
  final MainAxisSize mainAxisSize;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisAlignment mainAxisAlignment;
  final GrafitColorScheme colors;

  const _ButtonGroupLayout({
    required this.children,
    required this.orientation,
    required this.mainAxisSize,
    required this.crossAxisAlignment,
    required this.mainAxisAlignment,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveChildren = _wrapChildren(context);

    final child = orientation == GrafitButtonGroupOrientation.horizontal
        ? Row(
            mainAxisSize: mainAxisSize,
            crossAxisAlignment: crossAxisAlignment,
            mainAxisAlignment: mainAxisAlignment,
            children: effectiveChildren,
          )
        : Column(
            mainAxisSize: mainAxisSize,
            crossAxisAlignment: crossAxisAlignment,
            mainAxisAlignment: mainAxisAlignment,
            children: effectiveChildren,
          );

    return Semantics(
      container: true,
      child: child,
    );
  }

  List<Widget> _wrapChildren(BuildContext context) {
    final List<Widget> wrapped = [];
    final count = children.length;

    for (int i = 0; i < count; i++) {
      final child = children[i];
      final isFirst = i == 0;
      final isLast = i == count - 1;

      // Check if child is a nested button group
      if (child is GrafitButtonGroup) {
        // Add gap between nested groups
        if (i > 0 && orientation == GrafitButtonGroupOrientation.horizontal) {
          wrapped.add(const SizedBox(width: 2));
        } else if (i > 0 && orientation == GrafitButtonGroupOrientation.vertical) {
          wrapped.add(const SizedBox(height: 2));
        }
        wrapped.add(child);
      } else if (child is GrafitButtonGroupSeparator) {
        wrapped.add(child);
      } else {
        // Wrap individual buttons or other widgets
        wrapped.add(
          _ButtonGroupItemWrapper(
            isFirst: isFirst,
            isLast: isLast,
            orientation: orientation,
            colors: colors,
            child: child,
          ),
        );
      }
    }

    return wrapped;
  }
}

/// Wrapper for individual items in a button group
/// Handles position-aware border radius and borders
class _ButtonGroupItemWrapper extends StatelessWidget {
  final bool isFirst;
  final bool isLast;
  final GrafitButtonGroupOrientation orientation;
  final GrafitColorScheme colors;
  final Widget child;

  const _ButtonGroupItemWrapper({
    required this.isFirst,
    required this.isLast,
    required this.orientation,
    required this.colors,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return _ButtonGroupBorder(
      isFirst: isFirst,
      isLast: isLast,
      orientation: orientation,
      colors: colors,
      child: child,
    );
  }
}

/// Border styling for button group items
class _ButtonGroupBorder extends StatelessWidget {
  final bool isFirst;
  final bool isLast;
  final GrafitButtonGroupOrientation orientation;
  final GrafitColorScheme colors;
  final Widget child;

  const _ButtonGroupBorder({
    required this.isFirst,
    required this.isLast,
    required this.orientation,
    required this.colors,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: _getBorderRadius(),
      ),
      clipBehavior: Clip.antiAlias,
      child: child,
    );
  }

  BorderRadius _getBorderRadius() {
    final baseRadius = colors.radius * 8;

    if (orientation == GrafitButtonGroupOrientation.horizontal) {
      return BorderRadius.only(
        topLeft: isFirst ? Radius.circular(baseRadius) : Radius.zero,
        bottomLeft: isFirst ? Radius.circular(baseRadius) : Radius.zero,
        topRight: isLast ? Radius.circular(baseRadius) : Radius.zero,
        bottomRight: isLast ? Radius.circular(baseRadius) : Radius.zero,
      );
    } else {
      return BorderRadius.only(
        topLeft: isFirst ? Radius.circular(baseRadius) : Radius.zero,
        topRight: isFirst ? Radius.circular(baseRadius) : Radius.zero,
        bottomLeft: isLast ? Radius.circular(baseRadius) : Radius.zero,
        bottomRight: isLast ? Radius.circular(baseRadius) : Radius.zero,
      );
    }
  }
}

/// Button Group Item - A pre-styled button for use in button groups
/// Extends GrafitButton with group-aware styling
class GrafitButtonGroupItem extends StatelessWidget {
  final String? label;
  final Widget? child;
  final VoidCallback? onPressed;
  final GrafitButtonVariant variant;
  final GrafitButtonSize size;
  final bool disabled;
  final IconData? icon;
  final Widget? leading;
  final Widget? trailing;

  const GrafitButtonGroupItem({
    super.key,
    this.label,
    this.child,
    this.onPressed,
    this.variant = GrafitButtonVariant.outline,
    this.size = GrafitButtonSize.md,
    this.disabled = false,
    this.icon,
    this.leading,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<GrafitTheme>()!;
    final colors = theme.colors;
    final effectiveDisabled = disabled || onPressed == null;

    return GrafitClickable(
      enabled: !effectiveDisabled,
      onTap: onPressed,
      child: _ButtonGroupItemStyle(
        variant: variant,
        size: size,
        disabled: effectiveDisabled,
        colors: colors,
        child: child ?? _buildDefaultContent(),
      ),
    );
  }

  Widget _buildDefaultContent() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (icon != null) ...[
          Icon(icon, size: _getIconSize()),
          const SizedBox(width: 8),
        ] else if (leading != null) ...[
          leading!,
          const SizedBox(width: 8),
        ],
        if (label != null)
          Text(
            label!,
            style: TextStyle(fontSize: _getFontSize()),
          ),
        if (trailing != null) ...[
          const SizedBox(width: 8),
          trailing!,
        ],
      ],
    );
  }

  double _getIconSize() {
    return switch (size) {
      GrafitButtonSize.sm => 16.0,
      GrafitButtonSize.md => 18.0,
      GrafitButtonSize.lg => 20.0,
      GrafitButtonSize.icon => 20.0,
    };
  }

  double _getFontSize() {
    return switch (size) {
      GrafitButtonSize.sm => 13.0,
      GrafitButtonSize.md => 14.0,
      GrafitButtonSize.lg => 15.0,
      GrafitButtonSize.icon => 14.0,
    };
  }
}

/// Internal style widget for button group items
class _ButtonGroupItemStyle extends StatelessWidget {
  final GrafitButtonVariant variant;
  final GrafitButtonSize size;
  final bool disabled;
  final GrafitColorScheme colors;
  final Widget child;

  const _ButtonGroupItemStyle({
    required this.variant,
    required this.size,
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

  _ButtonGroupItemStyleData _getButtonStyle(
    bool isHovered,
    bool isPressed,
    bool isFocused,
  ) {
    return switch (variant) {
      GrafitButtonVariant.primary => _primaryStyle(isHovered, isPressed, isFocused),
      GrafitButtonVariant.secondary => _secondaryStyle(isHovered, isPressed, isFocused),
      GrafitButtonVariant.ghost => _ghostStyle(isHovered, isPressed, isFocused),
      GrafitButtonVariant.link => _linkStyle(isHovered, isPressed, isFocused),
      GrafitButtonVariant.destructive => _destructiveStyle(isHovered, isPressed, isFocused),
      GrafitButtonVariant.outline => _outlineStyle(isHovered, isPressed, isFocused),
    };
  }

  _ButtonGroupItemStyleData _primaryStyle(bool isHovered, bool isPressed, bool isFocused) {
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

    return _ButtonGroupItemStyleData(
      foreground: foreground,
      background: background,
      border: border,
      textStyle: TextStyle(
        color: foreground,
        fontWeight: FontWeight.w500,
        fontSize: _getFontSize(),
      ),
      padding: _getPadding(),
      decoration: BoxDecoration(
        color: background,
        border: Border.all(color: border),
        borderRadius: BorderRadius.zero, // No radius for items
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

  _ButtonGroupItemStyleData _secondaryStyle(bool isHovered, bool isPressed, bool isFocused) {
    final foreground = disabled
        ? colors.mutedForeground
        : colors.secondaryForeground;
    final background = disabled
        ? colors.muted
        : isPressed
            ? colors.secondary.withOpacity(0.8)
            : colors.secondary;
    final border = colors.border;

    return _ButtonGroupItemStyleData(
      foreground: foreground,
      background: background,
      border: border,
      textStyle: TextStyle(
        color: foreground,
        fontWeight: FontWeight.w500,
        fontSize: _getFontSize(),
      ),
      padding: _getPadding(),
      decoration: BoxDecoration(
        color: background,
        border: Border.all(color: border),
        borderRadius: BorderRadius.zero,
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

  _ButtonGroupItemStyleData _ghostStyle(bool isHovered, bool isPressed, bool isFocused) {
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

    return _ButtonGroupItemStyleData(
      foreground: foreground,
      background: background,
      border: Colors.transparent,
      textStyle: TextStyle(
        color: foreground,
        fontWeight: FontWeight.w500,
        fontSize: _getFontSize(),
      ),
      padding: _getPadding(),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.zero,
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

  _ButtonGroupItemStyleData _linkStyle(bool isHovered, bool isPressed, bool isFocused) {
    final foreground = disabled
        ? colors.mutedForeground
        : isPressed
            ? colors.primary.withOpacity(0.7)
            : isHovered
                ? colors.primary
                : colors.primary;

    return _ButtonGroupItemStyleData(
      foreground: foreground,
      background: Colors.transparent,
      border: Colors.transparent,
      textStyle: TextStyle(
        color: foreground,
        fontWeight: FontWeight.w500,
        fontSize: _getFontSize(),
        decoration: TextDecoration.underline,
      ),
      padding: size == GrafitButtonSize.icon
          ? const EdgeInsets.all(8)
          : const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.zero,
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

  _ButtonGroupItemStyleData _destructiveStyle(bool isHovered, bool isPressed, bool isFocused) {
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

    return _ButtonGroupItemStyleData(
      foreground: foreground,
      background: background,
      border: border,
      textStyle: TextStyle(
        color: foreground,
        fontWeight: FontWeight.w500,
        fontSize: _getFontSize(),
      ),
      padding: _getPadding(),
      decoration: BoxDecoration(
        color: background,
        border: Border.all(color: border),
        borderRadius: BorderRadius.zero,
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

  _ButtonGroupItemStyleData _outlineStyle(bool isHovered, bool isPressed, bool isFocused) {
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

    return _ButtonGroupItemStyleData(
      foreground: foreground,
      background: background,
      border: border,
      textStyle: TextStyle(
        color: foreground,
        fontWeight: FontWeight.w500,
        fontSize: _getFontSize(),
      ),
      padding: _getPadding(),
      decoration: BoxDecoration(
        color: background,
        border: Border.all(color: border),
        borderRadius: BorderRadius.zero,
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

  double _getFontSize() {
    return switch (size) {
      GrafitButtonSize.sm => 13.0,
      GrafitButtonSize.md => 14.0,
      GrafitButtonSize.lg => 15.0,
      GrafitButtonSize.icon => 14.0,
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

/// Internal style data class for button group items
class _ButtonGroupItemStyleData {
  final Color foreground;
  final Color background;
  final Color border;
  final TextStyle textStyle;
  final EdgeInsets padding;
  final Decoration decoration;
  final double iconSize;

  const _ButtonGroupItemStyleData({
    required this.foreground,
    required this.background,
    required this.border,
    required this.textStyle,
    required this.padding,
    required this.decoration,
    required this.iconSize,
  });
}

/// Separator component specifically for button groups
/// Displays a visual separator between button group items
class GrafitButtonGroupSeparator extends StatelessWidget {
  final GrafitButtonGroupOrientation orientation;
  final Color? color;
  final double? thickness;

  const GrafitButtonGroupSeparator({
    super.key,
    this.orientation = GrafitButtonGroupOrientation.vertical,
    this.color,
    this.thickness,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<GrafitTheme>()!;
    final colors = theme.colors;

    final separatorColor = color ?? colors.input;
    final separatorThickness = thickness ?? 1.0;

    if (orientation == GrafitButtonGroupOrientation.horizontal) {
      // Vertical separator (for horizontal groups)
      return Container(
        width: separatorThickness,
        margin: const EdgeInsets.symmetric(horizontal: 1),
        color: separatorColor,
      );
    } else {
      // Horizontal separator (for vertical groups)
      return Container(
        height: separatorThickness,
        margin: const EdgeInsets.symmetric(vertical: 1),
        color: separatorColor,
      );
    }
  }
}

/// Text element component for button groups
/// Displays text content within a button group
class GrafitButtonGroupText extends StatelessWidget {
  final String text;
  final IconData? icon;

  const GrafitButtonGroupText(
    this.text, {
    super.key,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<GrafitTheme>()!;
    final colors = theme.colors;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: colors.muted,
        borderRadius: BorderRadius.circular(colors.radius * 6),
        border: Border.all(color: colors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: 16,
              color: colors.mutedForeground,
            ),
            const SizedBox(width: 8),
          ],
          Text(
            text,
            style: TextStyle(
              color: colors.mutedForeground,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// WIDGETBOOK USE CASES
// ============================================================

@widgetbook.UseCase(
  name: 'Default',
  type: GrafitButtonGroup,
  path: 'Form/ButtonGroup',
)
Widget buttonGroupDefault(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.all(24.0),
    child: GrafitButtonGroup(
      children: [
        GrafitButtonGroupItem(
          label: 'Button 1',
          onPressed: () {},
        ),
        GrafitButtonGroupItem(
          label: 'Button 2',
          onPressed: () {},
        ),
        GrafitButtonGroupItem(
          label: 'Button 3',
          onPressed: () {},
        ),
      ],
    ),
  );
}

@widgetbook.UseCase(
  name: 'Vertical',
  type: GrafitButtonGroup,
  path: 'Form/ButtonGroup',
)
Widget buttonGroupVertical(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.all(24.0),
    child: GrafitButtonGroup(
      orientation: GrafitButtonGroupOrientation.vertical,
      children: [
        GrafitButtonGroupItem(
          label: 'Top',
          onPressed: () {},
        ),
        GrafitButtonGroupItem(
          label: 'Middle',
          onPressed: () {},
        ),
        GrafitButtonGroupItem(
          label: 'Bottom',
          onPressed: () {},
        ),
      ],
    ),
  );
}

@widgetbook.UseCase(
  name: 'With Icons',
  type: GrafitButtonGroup,
  path: 'Form/ButtonGroup',
)
Widget buttonGroupWithIcons(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.all(24.0),
    child: GrafitButtonGroup(
      children: [
        GrafitButtonGroupItem(
          icon: Icons.format_align_left,
          onPressed: () {},
        ),
        GrafitButtonGroupItem(
          icon: Icons.format_align_center,
          onPressed: () {},
        ),
        GrafitButtonGroupItem(
          icon: Icons.format_align_right,
          onPressed: () {},
        ),
      ],
    ),
  );
}

@widgetbook.UseCase(
  name: 'Interactive',
  type: GrafitButtonGroup,
  path: 'Form/ButtonGroup',
)
Widget buttonGroupInteractive(BuildContext context) {
  final orientation = context.knobs.list(
    label: 'Orientation',
    initialOption: GrafitButtonGroupOrientation.horizontal,
    options: const [
      GrafitButtonGroupOrientation.horizontal,
      GrafitButtonGroupOrientation.vertical,
    ],
  );
  final size = context.knobs.list(
    label: 'Size',
    initialOption: GrafitButtonSize.md,
    options: const [GrafitButtonSize.sm, GrafitButtonSize.md, GrafitButtonSize.lg],
  );
  final disabled = context.knobs.boolean(label: 'Disabled', initialValue: false);

  return Padding(
    padding: const EdgeInsets.all(24.0),
    child: GrafitButtonGroup(
      orientation: orientation,
      children: [
        GrafitButtonGroupItem(
          label: 'Option 1',
          size: size,
          disabled: disabled,
          onPressed: disabled ? null : () {},
        ),
        GrafitButtonGroupItem(
          label: 'Option 2',
          size: size,
          disabled: disabled,
          onPressed: disabled ? null : () {},
        ),
        GrafitButtonGroupItem(
          label: 'Option 3',
          size: size,
          disabled: disabled,
          onPressed: disabled ? null : () {},
        ),
      ],
    ),
  );
}

