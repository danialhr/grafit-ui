import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import '../../theme/theme.dart';
import '../../theme/theme_data.dart';
import '../../primitives/clickable.dart';

/// Toggle group variants
enum GrafitToggleGroupVariant {
  plain,
  outline,
}

/// Toggle group sizes
enum GrafitToggleGroupSize {
  sm,
  md,
  lg,
}

/// Toggle group type - single or multiple selection
enum GrafitToggleGroupType {
  single,
  multiple,
}

/// Toggle Group component
/// A set of two-state buttons that can be toggled on or off.
/// Supports single selection (radio-like) or multiple selection (checkbox-like).
///
/// Example:
/// ```dart
/// GrafitToggleGroup(
///   type: GrafitToggleGroupType.single,
///   value: selectedValue,
///   onChanged: (value) => setState(() => selectedValue = value),
///   children: [
///     GrafitToggleGroupItem(value: 'bold', child: Icon(Icons.format_bold)),
///     GrafitToggleGroupItem(value: 'italic', child: Icon(Icons.format_italic)),
///     GrafitToggleGroupItem(value: 'underline', child: Icon(Icons.format_underlined)),
///   ],
/// )
/// ```
class GrafitToggleGroup extends StatefulWidget {
  /// Currently selected value(s). For single mode, use String. For multiple, use Set<String>.
  final dynamic value;

  /// Callback when selection changes
  final ValueChanged<dynamic>? onChanged;

  /// Whether multiple items can be selected
  final GrafitToggleGroupType type;

  /// Visual variant of the toggle group
  final GrafitToggleGroupVariant variant;

  /// Size of the toggle items
  final GrafitToggleGroupSize size;

  /// Spacing between items (0 = connected, >0 = separated)
  final double spacing;

  /// Whether the entire group is disabled
  final bool enabled;

  /// The toggle items to display
  final List<Widget> children;

  /// Main axis alignment
  final MainAxisAlignment alignment;

  const GrafitToggleGroup({
    super.key,
    required this.children,
    this.value,
    this.onChanged,
    this.type = GrafitToggleGroupType.single,
    this.variant = GrafitToggleGroupVariant.plain,
    this.size = GrafitToggleGroupSize.md,
    this.spacing = 0,
    this.enabled = true,
    this.alignment = MainAxisAlignment.start,
  });

  @override
  State<GrafitToggleGroup> createState() => _GrafitToggleGroupState();
}

class _GrafitToggleGroupState extends State<GrafitToggleGroup> {
  @override
  Widget build(BuildContext context) {
    // Wrap children with position tracking for proper styling
    final positionedChildren = _wrapWithPosition(widget.children);

    return _GrafitToggleGroupInherited(
      value: widget.value,
      onChanged: widget.onChanged,
      type: widget.type,
      variant: widget.variant,
      size: widget.size,
      spacing: widget.spacing,
      enabled: widget.enabled,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: widget.alignment,
        children: positionedChildren,
      ),
    );
  }

  /// Wrap children with position tracking for connected styling
  List<Widget> _wrapWithPosition(List<Widget> children) {
    if (children.isEmpty) return children;

    return List<Widget>.generate(
      children.length,
      (index) => _GrafitToggleGroupItemPosition(
        isFirst: index == 0,
        isLast: index == children.length - 1,
        child: children[index],
      ),
    );
  }
}

/// Inherited widget to share toggle group state with items
class _GrafitToggleGroupInherited extends InheritedWidget {
  final dynamic value;
  final ValueChanged<dynamic>? onChanged;
  final GrafitToggleGroupType type;
  final GrafitToggleGroupVariant variant;
  final GrafitToggleGroupSize size;
  final double spacing;
  final bool enabled;

  const _GrafitToggleGroupInherited({
    required this.value,
    required this.onChanged,
    required this.type,
    required this.variant,
    required this.size,
    required this.spacing,
    required this.enabled,
    required super.child,
  });

  static _GrafitToggleGroupInherited of(BuildContext context) {
    final result = context.dependOnInheritedWidgetOfExactType<_GrafitToggleGroupInherited>();
    assert(result != null, 'No _GrafitToggleGroupInherited found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(_GrafitToggleGroupInherited oldWidget) {
    return value != oldWidget.value ||
        type != oldWidget.type ||
        variant != oldWidget.variant ||
        size != oldWidget.size ||
        spacing != oldWidget.spacing ||
        enabled != oldWidget.enabled;
  }
}

/// Toggle Group Item component
/// Individual toggle button within a toggle group.
class GrafitToggleGroupItem extends StatefulWidget {
  /// Unique identifier for this item
  final String value;

  /// Widget to display inside the item
  final Widget child;

  /// Override the group's disabled state
  final bool? enabled;

  /// Tooltip text to show on long press
  final String? tooltip;

  const GrafitToggleGroupItem({
    super.key,
    required this.value,
    required this.child,
    this.enabled,
    this.tooltip,
  });

  @override
  State<GrafitToggleGroupItem> createState() => _GrafitToggleGroupItemState();
}

class _GrafitToggleGroupItemState extends State<GrafitToggleGroupItem> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final group = _GrafitToggleGroupInherited.of(context);
    final theme = Theme.of(context).extension<GrafitTheme>()!;
    final colors = theme.colors;
    final effectiveEnabled = (widget.enabled ?? group.enabled) && group.onChanged != null;

    // Determine if this item is selected
    final isSelected = _isSelected(group);

    // Calculate styling based on variant, size, and state
    final itemStyle = _getItemStyle(
      colors: colors,
      variant: group.variant,
      size: group.size,
      isSelected: isSelected,
      isEnabled: effectiveEnabled,
      isPressed: _isPressed,
      spacing: group.spacing,
      isFirst: _isFirst(context),
      isLast: _isLast(context),
    );

    Widget content = GrafitClickable(
      enabled: effectiveEnabled,
      onTap: effectiveEnabled ? () => _handleTap(group) : null,
      onTapDown: effectiveEnabled
          ? (_) {
              setState(() {
                _isPressed = true;
              });
            }
          : null,
      onTapUp: effectiveEnabled
          ? (_) {
              setState(() {
                _isPressed = false;
              });
            }
          : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeInOut,
        padding: itemStyle.padding,
        decoration: itemStyle.decoration,
        child: DefaultTextStyle(
          style: itemStyle.textStyle,
          child: IconTheme(
            data: IconThemeData(
              color: itemStyle.foreground,
              size: itemStyle.iconSize,
            ),
            child: widget.child,
          ),
        ),
      ),
    );

    // Add spacing if not connected
    if (group.spacing > 0) {
      content = Padding(
        padding: EdgeInsets.only(right: group.spacing),
        child: content,
      );
    }

    // Add tooltip if provided
    if (widget.tooltip != null) {
      content = Tooltip(
        message: widget.tooltip!,
        child: content,
      );
    }

    return content;
  }

  bool _isSelected(_GrafitToggleGroupInherited group) {
    if (group.type == GrafitToggleGroupType.single) {
      return group.value == widget.value;
    } else {
      // Multiple mode - value should be a Set<String>
      if (group.value is Set) {
        return (group.value as Set<String>).contains(widget.value);
      }
      return false;
    }
  }

  void _handleTap(_GrafitToggleGroupInherited group) {
    if (group.type == GrafitToggleGroupType.single) {
      // Single mode - if already selected, deselect. Otherwise, select.
      final newValue = group.value == widget.value ? null : widget.value;
      group.onChanged?.call(newValue);
    } else {
      // Multiple mode
      Set<String> currentValues =
          group.value is Set ? Set<String>.from(group.value as Set) : <String>{};

      if (currentValues.contains(widget.value)) {
        currentValues.remove(widget.value);
      } else {
        currentValues.add(widget.value);
      }

      group.onChanged?.call(currentValues);
    }
  }

  bool _isFirst(BuildContext context) {
    return _GrafitToggleGroupItemPosition.of(context)?.isFirst ?? true;
  }

  bool _isLast(BuildContext context) {
    return _GrafitToggleGroupItemPosition.of(context)?.isLast ?? true;
  }

  _ItemStyleData _getItemStyle({
    required GrafitColorScheme colors,
    required GrafitToggleGroupVariant variant,
    required GrafitToggleGroupSize size,
    required bool isSelected,
    required bool isEnabled,
    required bool isPressed,
    required double spacing,
    required bool isFirst,
    required bool isLast,
  }) {
    // Base size dimensions
    final sizeData = _getSizeData(size);

    // Calculate colors based on state
    final foreground = _getForeground(
      colors: colors,
      variant: variant,
      isSelected: isSelected,
      isEnabled: isEnabled,
    );

    final background = _getBackground(
      colors: colors,
      variant: variant,
      isSelected: isSelected,
      isEnabled: isEnabled,
      isPressed: isPressed,
    );

    final borderColor = _getBorderColor(
      colors: colors,
      variant: variant,
      isSelected: isSelected,
      isEnabled: isEnabled,
    );

    // Border radius - connected items have special radius
    BorderRadius borderRadius;
    if (spacing == 0) {
      // Connected mode
      borderRadius = BorderRadius.only(
        topLeft: Radius.circular(isFirst ? colors.radius * 6 : 0),
        topRight: Radius.circular(isLast ? colors.radius * 6 : 0),
        bottomLeft: Radius.circular(isFirst ? colors.radius * 6 : 0),
        bottomRight: Radius.circular(isLast ? colors.radius * 6 : 0),
      );
    } else {
      // Separated mode
      borderRadius = BorderRadius.circular(colors.radius * 6);
    }

    // Border
    BoxBorder? border;
    if (variant == GrafitToggleGroupVariant.outline) {
      border = Border.all(
        color: borderColor,
        width: 1,
      );

      // Hide left border for non-first items in connected outline mode
      if (spacing == 0 && !isFirst) {
        border = Border(
          top: BorderSide(color: borderColor, width: 1),
          right: BorderSide(color: borderColor, width: 1),
          bottom: BorderSide(color: borderColor, width: 1),
          left: BorderSide.none,
        );
      }
    }

    return _ItemStyleData(
      foreground: foreground,
      background: background,
      padding: sizeData.padding,
      textStyle: TextStyle(
        fontSize: sizeData.fontSize,
        fontWeight: FontWeight.w500,
        color: foreground,
      ),
      decoration: BoxDecoration(
        color: background,
        border: border,
        borderRadius: borderRadius,
      ),
      iconSize: sizeData.iconSize,
    );
  }

  Color _getForeground({
    required GrafitColorScheme colors,
    required GrafitToggleGroupVariant variant,
    required bool isSelected,
    required bool isEnabled,
  }) {
    if (!isEnabled) {
      return colors.mutedForeground;
    }

    if (isSelected) {
      return colors.accentForeground;
    }

    return colors.foreground;
  }

  Color _getBackground({
    required GrafitColorScheme colors,
    required GrafitToggleGroupVariant variant,
    required bool isSelected,
    required bool isEnabled,
    required bool isPressed,
  }) {
    if (!isEnabled) {
      return colors.transparent;
    }

    if (isSelected) {
      return colors.accent;
    }

    if (isPressed) {
      return colors.muted.withValues(alpha: 0.5);
    }

    if (variant == GrafitToggleGroupVariant.outline) {
      return colors.transparent;
    }

    return colors.transparent;
  }

  Color _getBorderColor({
    required GrafitColorScheme colors,
    required GrafitToggleGroupVariant variant,
    required bool isSelected,
    required bool isEnabled,
  }) {
    if (!isEnabled) {
      return colors.border;
    }

    if (variant == GrafitToggleGroupVariant.outline) {
      return colors.input;
    }

    return colors.transparent;
  }

  _SizeData _getSizeData(GrafitToggleGroupSize size) {
    return switch (size) {
      GrafitToggleGroupSize.sm => _SizeData(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          fontSize: 12.0,
          iconSize: 14.0,
          minHeight: 28.0,
        ),
      GrafitToggleGroupSize.md => _SizeData(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          fontSize: 13.0,
          iconSize: 16.0,
          minHeight: 36.0,
        ),
      GrafitToggleGroupSize.lg => _SizeData(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          fontSize: 14.0,
          iconSize: 18.0,
          minHeight: 42.0,
        ),
    };
  }
}

/// Size data class
class _SizeData {
  final EdgeInsets padding;
  final double fontSize;
  final double iconSize;
  final double minHeight;

  const _SizeData({
    required this.padding,
    required this.fontSize,
    required this.iconSize,
    required this.minHeight,
  });
}

/// Item style data class
class _ItemStyleData {
  final Color foreground;
  final Color background;
  final EdgeInsets padding;
  final TextStyle textStyle;
  final Decoration decoration;
  final double iconSize;

  const _ItemStyleData({
    required this.foreground,
    required this.background,
    required this.padding,
    required this.textStyle,
    required this.decoration,
    required this.iconSize,
  });
}

/// Helper widget to track item position in the group
class _GrafitToggleGroupItemPosition extends InheritedWidget {
  final bool isFirst;
  final bool isLast;

  const _GrafitToggleGroupItemPosition({
    required this.isFirst,
    required this.isLast,
    required super.child,
  });

  static _GrafitToggleGroupItemPosition? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_GrafitToggleGroupItemPosition>();
  }

  @override
  bool updateShouldNotify(_GrafitToggleGroupItemPosition oldWidget) {
    return isFirst != oldWidget.isFirst || isLast != oldWidget.isLast;
  }
}

// ============================================================
// WIDGETBOOK USE CASES
// ============================================================

@widgetbook.UseCase(
  name: 'Default',
  type: GrafitToggleGroup,
  path: 'Form/ToggleGroup',
)
Widget toggleGroupDefault(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.all(24.0),
    child: GrafitToggleGroup(
      type: GrafitToggleGroupType.single,
      value: 'bold',
      children: [
        GrafitToggleGroupItem(value: 'bold', child: Icon(Icons.format_bold)),
        GrafitToggleGroupItem(value: 'italic', child: Icon(Icons.format_italic)),
        GrafitToggleGroupItem(value: 'underline', child: Icon(Icons.format_underlined)),
      ],
    ),
  );
}

@widgetbook.UseCase(
  name: 'Multiple',
  type: GrafitToggleGroup,
  path: 'Form/ToggleGroup',
)
Widget toggleGroupMultiple(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.all(24.0),
    child: GrafitToggleGroup(
      type: GrafitToggleGroupType.multiple,
      values: {'bold', 'italic'},
      children: [
        GrafitToggleGroupItem(value: 'bold', child: Icon(Icons.format_bold)),
        GrafitToggleGroupItem(value: 'italic', child: Icon(Icons.format_italic)),
        GrafitToggleGroupItem(value: 'underline', child: Icon(Icons.format_underlined)),
      ],
    ),
  );
}

@widgetbook.UseCase(
  name: 'Outline Variant',
  type: GrafitToggleGroup,
  path: 'Form/ToggleGroup',
)
Widget toggleGroupOutline(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.all(24.0),
    child: GrafitToggleGroup(
      type: GrafitToggleGroupType.single,
      variant: GrafitToggleGroupVariant.outline,
      value: 'left',
      children: [
        GrafitToggleGroupItem(value: 'left', child: Icon(Icons.align_horizontal_left)),
        GrafitToggleGroupItem(value: 'center', child: Icon(Icons.align_horizontal_center)),
        GrafitToggleGroupItem(value: 'right', child: Icon(Icons.align_horizontal_right)),
      ],
    ),
  );
}

@widgetbook.UseCase(
  name: 'Small Size',
  type: GrafitToggleGroup,
  path: 'Form/ToggleGroup',
)
Widget toggleGroupSmall(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.all(24.0),
    child: GrafitToggleGroup(
      type: GrafitToggleGroupType.single,
      size: GrafitToggleGroupSize.sm,
      value: 'day',
      children: [
        GrafitToggleGroupItem(value: 'day', child: Text('Day')),
        GrafitToggleGroupItem(value: 'week', child: Text('Week')),
        GrafitToggleGroupItem(value: 'month', child: Text('Month')),
      ],
    ),
  );
}

@widgetbook.UseCase(
  name: 'Large Size',
  type: GrafitToggleGroup,
  path: 'Form/ToggleGroup',
)
Widget toggleGroupLarge(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.all(24.0),
    child: GrafitToggleGroup(
      type: GrafitToggleGroupType.single,
      size: GrafitToggleGroupSize.lg,
      value: 'list',
      children: [
        GrafitToggleGroupItem(value: 'list', child: Icon(Icons.view_list)),
        GrafitToggleGroupItem(value: 'grid', child: Icon(Icons.grid_view)),
      ],
    ),
  );
}

@widgetbook.UseCase(
  name: 'Separated',
  type: GrafitToggleGroup,
  path: 'Form/ToggleGroup',
)
Widget toggleGroupSeparated(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.all(24.0),
    child: GrafitToggleGroup(
      type: GrafitToggleGroupType.single,
      spacing: 8,
      value: 'all',
      children: [
        GrafitToggleGroupItem(value: 'all', child: Text('All')),
        GrafitToggleGroupItem(value: 'active', child: Text('Active')),
        GrafitToggleGroupItem(value: 'completed', child: Text('Completed')),
      ],
    ),
  );
}

@widgetbook.UseCase(
  name: 'Disabled',
  type: GrafitToggleGroup,
  path: 'Form/ToggleGroup',
)
Widget toggleGroupDisabled(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.all(24.0),
    child: GrafitToggleGroup(
      type: GrafitToggleGroupType.single,
      enabled: false,
      value: 'bold',
      children: [
        GrafitToggleGroupItem(value: 'bold', child: Icon(Icons.format_bold)),
        GrafitToggleGroupItem(value: 'italic', child: Icon(Icons.format_italic)),
      ],
    ),
  );
}

@widgetbook.UseCase(
  name: 'With Tooltips',
  type: GrafitToggleGroup,
  path: 'Form/ToggleGroup',
)
Widget toggleGroupWithTooltips(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.all(24.0),
    child: GrafitToggleGroup(
      type: GrafitToggleGroupType.single,
      children: [
        GrafitToggleGroupItem(value: 'bold', tooltip: 'Bold', child: Icon(Icons.format_bold)),
        GrafitToggleGroupItem(value: 'italic', tooltip: 'Italic', child: Icon(Icons.format_italic)),
        GrafitToggleGroupItem(value: 'underline', tooltip: 'Underline', child: Icon(Icons.format_underlined)),
      ],
    ),
  );
}

@widgetbook.UseCase(
  name: 'Interactive',
  type: GrafitToggleGroup,
  path: 'Form/ToggleGroup',
)
Widget toggleGroupInteractive(BuildContext context) {
  final type = context.knobs.list(
    label: 'Type',
    initialOption: GrafitToggleGroupType.single,
    options: const [GrafitToggleGroupType.single, GrafitToggleGroupType.multiple],
  );
  final variant = context.knobs.list(
    label: 'Variant',
    initialOption: GrafitToggleGroupVariant.plain,
    options: const [GrafitToggleGroupVariant.plain, GrafitToggleGroupVariant.outline],
  );
  final size = context.knobs.list(
    label: 'Size',
    initialOption: GrafitToggleGroupSize.md,
    options: const [GrafitToggleGroupSize.sm, GrafitToggleGroupSize.md, GrafitToggleGroupSize.lg],
  );
  final spacing = context.knobs.double(label: 'Spacing', initialValue: 0);
  final enabled = context.knobs.boolean(label: 'Enabled', initialValue: true);

  return Padding(
    padding: const EdgeInsets.all(24.0),
    child: GrafitToggleGroup(
      type: type,
      variant: variant,
      size: size,
      spacing: spacing,
      enabled: enabled,
      value: 'option1',
      children: const [
        GrafitToggleGroupItem(value: 'option1', child: Text('Option 1')),
        GrafitToggleGroupItem(value: 'option2', child: Text('Option 2')),
        GrafitToggleGroupItem(value: 'option3', child: Text('Option 3')),
      ],
    ),
  );
}

