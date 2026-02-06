import 'package:flutter/material.dart';
import '../../theme/theme.dart';
import '../../theme/theme_data.dart';

/// KBD size variant
enum GrafitKbdSize {
  small,
  medium,
  large,
}

/// Keyboard key (KBD) component for displaying keyboard shortcuts
/// and key combinations in a consistent, styled format.
///
/// This component is the Flutter port of shadcn-ui/ui KBD component.
/// It displays individual keys or key combinations with proper styling.
class GrafitKbd extends StatelessWidget {
  /// The key label or content to display
  final Widget? child;
  final String? text;

  /// Size variant for the KBD component
  final GrafitKbdSize size;

  /// Custom background color (overrides theme default)
  final Color? backgroundColor;

  /// Custom foreground/text color (overrides theme default)
  final Color? foregroundColor;

  /// Custom border color (overrides theme default)
  final Color? borderColor;

  /// Whether the KBD is displayed inside a tooltip
  /// (applies special styling for tooltip context)
  final bool inTooltip;

  /// Gap between children when using KbdGroup
  final double? gap;

  const GrafitKbd({
    super.key,
    this.child,
    this.text,
    this.size = GrafitKbdSize.medium,
    this.backgroundColor,
    this.foregroundColor,
    this.borderColor,
    this.inTooltip = false,
    this.gap,
  });

  /// Create a small KBD for compact displays
  const GrafitKbd.small({
    super.key,
    this.child,
    this.text,
    this.backgroundColor,
    this.foregroundColor,
    this.borderColor,
    this.inTooltip = false,
    this.gap,
  }) : size = GrafitKbdSize.small;

  /// Create a large KBD for emphasis
  const GrafitKbd.large({
    super.key,
    this.child,
    this.text,
    this.backgroundColor,
    this.foregroundColor,
    this.borderColor,
    this.inTooltip = false,
    this.gap,
  }) : size = GrafitKbdSize.large;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<GrafitTheme>()!;
    final colors = theme.colors;

    final kbdStyle = _getKbdStyle(colors);

    return Container(
      constraints: BoxConstraints(
        minWidth: _getMinWidth(),
      ),
      height: _getHeight(),
      padding: _getPadding(),
      decoration: BoxDecoration(
        color: backgroundColor ?? kbdStyle.backgroundColor,
        border: Border.all(
          color: borderColor ?? kbdStyle.borderColor,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(colors.radius * 2), // rounded-sm equivalent
      ),
      child: DefaultTextStyle(
        style: TextStyle(
          color: foregroundColor ?? kbdStyle.foregroundColor,
          fontSize: _getFontSize(),
          fontWeight: FontWeight.w500,
          fontFamily: 'sans-serif',
          height: 1.0,
        ),
        child: Center(
          widthFactor: 1.0,
          child: child ??
              Text(
                text ?? '',
                textAlign: TextAlign.center,
              ),
        ),
      ),
    );
  }

  double _getHeight() {
    return switch (size) {
      GrafitKbdSize.small => 16.0, // h-4
      GrafitKbdSize.medium => 20.0, // h-5
      GrafitKbdSize.large => 24.0, // h-6
    };
  }

  double _getMinWidth() {
    return switch (size) {
      GrafitKbdSize.small => 16.0, // min-w-4
      GrafitKbdSize.medium => 20.0, // min-w-5
      GrafitKbdSize.large => 24.0, // min-w-6
    };
  }

  EdgeInsets _getPadding() {
    return switch (size) {
      GrafitKbdSize.small => const EdgeInsets.symmetric(horizontal: 3),
      GrafitKbdSize.medium => const EdgeInsets.symmetric(horizontal: 4),
      GrafitKbdSize.large => const EdgeInsets.symmetric(horizontal: 6),
    };
  }

  double _getFontSize() {
    return switch (size) {
      GrafitKbdSize.small => 10.0,
      GrafitKbdSize.medium => 12.0, // text-xs
      GrafitKbdSize.large => 14.0,
    };
  }

  _KbdStyle _getKbdStyle(GrafitColorScheme colors) {
    if (inTooltip) {
      // Special styling for tooltip context
      // [[data-slot=tooltip-content]_&]:bg-background/20
      return _KbdStyle(
        backgroundColor: colors.card.withValues(alpha: 0.2),
        foregroundColor: colors.cardForeground,
        borderColor: Colors.transparent,
      );
    }

    return _KbdStyle(
      backgroundColor: colors.muted,
      foregroundColor: colors.mutedForeground,
      borderColor: colors.border,
    );
  }
}

/// Group of keyboard keys displayed together
///
/// Use this to display key combinations like "Cmd + K" or "Ctrl + Shift + F"
class GrafitKbdGroup extends StatelessWidget {
  /// The list of keys or widgets to display as a group
  final List<Widget> children;

  /// Gap between keys
  final double? gap;

  /// Whether to show plus signs between keys
  final bool showPlus;

  /// Custom widget for separator (defaults to " + " text)
  final Widget? separator;

  const GrafitKbdGroup({
    super.key,
    required this.children,
    this.gap,
    this.showPlus = true,
    this.separator,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<GrafitTheme>()!;
    final colors = theme.colors;

    final effectiveGap = gap ?? 4.0;

    if (!showPlus) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: _buildChildren(effectiveGap, null),
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: _buildChildrenWithSeparator(effectiveGap, colors),
    );
  }

  List<Widget> _buildChildren(double gap, Widget? customSeparator) {
    final result = <Widget>[];

    for (int i = 0; i < children.length; i++) {
      result.add(children[i]);
      if (i < children.length - 1) {
        result.add(SizedBox(width: gap));
      }
    }

    return result;
  }

  List<Widget> _buildChildrenWithSeparator(double gap, GrafitColorScheme colors) {
    final result = <Widget>[];

    for (int i = 0; i < children.length; i++) {
      result.add(children[i]);
      if (i < children.length - 1) {
        result.add(SizedBox(width: gap));
        result.add(
          separator ??
              Text(
                ' + ',
                style: TextStyle(
                  color: colors.mutedForeground,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              ),
        );
        result.add(SizedBox(width: gap));
      }
    }

    return result;
  }
}

/// Internal class to hold KBD styling
class _KbdStyle {
  final Color backgroundColor;
  final Color foregroundColor;
  final Color borderColor;

  const _KbdStyle({
    required this.backgroundColor,
    required this.foregroundColor,
    required this.borderColor,
  });
}
