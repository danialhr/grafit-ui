import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import '../../theme/theme.dart';
import '../../primitives/clickable.dart';

/// Radio group size variant
enum GrafitRadioSize {
  sm,
  md,
  lg,
}

/// Radio group component for single selection from a set of options
class GrafitRadioGroup<T> extends StatelessWidget {
  /// Currently selected value
  final T? value;

  /// Callback when selection changes
  final ValueChanged<T>? onChanged;

  /// Radio items to display
  final List<GrafitRadioItemData<T>> items;

  /// Whether the entire group is disabled
  final bool enabled;

  /// Size variant for radio buttons
  final GrafitRadioSize size;

  /// Direction of the radio group layout
  final Axis direction;

  /// Main axis spacing between items
  final double spacing;

  /// Optional label for the group
  final String? label;

  const GrafitRadioGroup({
    super.key,
    required this.value,
    required this.items,
    this.onChanged,
    this.enabled = true,
    this.size = GrafitRadioSize.md,
    this.direction = Axis.vertical,
    this.spacing = 8.0,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<GrafitTheme>()!;
    final colors = theme.colors;
    final effectiveEnabled = enabled && onChanged != null;

    final itemsWidget = Flex(
      direction: direction,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: direction == Axis.vertical
          ? CrossAxisAlignment.start
          : CrossAxisAlignment.center,
      children: [
        for (int i = 0; i < items.length; i++) ...[
          if (i > 0) SizedBox(width: direction == Axis.horizontal ? spacing : 0, height: direction == Axis.vertical ? spacing : 0),
          _buildRadioItem(context, items[i], effectiveEnabled, colors),
        ],
      ],
    );

    if (label != null) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label!,
            style: TextStyle(
              color: effectiveEnabled ? colors.foreground : colors.mutedForeground,
              fontSize: _getLabelFontSize(),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          itemsWidget,
        ],
      );
    }

    return itemsWidget;
  }

  Widget _buildRadioItem(
    BuildContext context,
    GrafitRadioItemData<T> item,
    bool effectiveEnabled,
    dynamic colors,
  ) {
    final isSelected = value != null && value == item.value;
    final itemEnabled = effectiveEnabled && (item.enabled ?? true);

    return GrafitClickable(
      enabled: itemEnabled,
      onTap: () => onChanged?.call(item.value),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _RadioIndicator(
            isSelected: isSelected,
            enabled: itemEnabled,
            size: size,
          ),
          if (item.label != null) ...[
            const SizedBox(width: 8),
            Text(
              item.label!,
              style: TextStyle(
                color: itemEnabled
                    ? colors.foreground
                    : colors.mutedForeground,
                fontSize: _getLabelFontSize(),
              ),
            ),
          ],
          if (item.description != null) ...[
            const SizedBox(width: 8),
            Text(
              item.description!,
              style: TextStyle(
                color: colors.mutedForeground,
                fontSize: _getDescriptionFontSize(),
              ),
            ),
          ],
        ],
      ),
    );
  }

  double _getLabelFontSize() {
    return switch (size) {
      GrafitRadioSize.sm => 13.0,
      GrafitRadioSize.md => 14.0,
      GrafitRadioSize.lg => 15.0,
    };
  }

  double _getDescriptionFontSize() {
    return switch (size) {
      GrafitRadioSize.sm => 11.0,
      GrafitRadioSize.md => 12.0,
      GrafitRadioSize.lg => 13.0,
    };
  }
}

/// Data class for radio item
class GrafitRadioItemData<T> {
  /// Value for this item
  final T value;

  /// Label text
  final String? label;

  /// Optional description text
  final String? description;

  /// Whether this specific item is enabled
  final bool? enabled;

  const GrafitRadioItemData({
    required this.value,
    this.label,
    this.description,
    this.enabled,
  });
}

/// Individual radio button indicator widget
class _RadioIndicator extends StatelessWidget {
  final bool isSelected;
  final bool enabled;
  final GrafitRadioSize size;

  const _RadioIndicator({
    required this.isSelected,
    required this.enabled,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<GrafitTheme>()!;
    final colors = theme.colors;

    final indicatorSize = _getIndicatorSize();
    final borderWidth = context.isClickableFocused ? 2.0 : 1.0;
    final dotSize = _getDotSize();

    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      width: indicatorSize,
      height: indicatorSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: enabled && context.isClickableHovered && !isSelected
            ? colors.muted
            : colors.background,
        border: Border.all(
          color: isSelected
              ? colors.primary
              : (context.isClickableFocused && enabled)
                  ? colors.ring
                  : colors.border,
          width: borderWidth,
        ),
        boxShadow: [
          if (enabled && context.isClickableFocused)
            BoxShadow(
              color: colors.ring.withValues(alpha: 0.2),
              blurRadius: 4,
              spreadRadius: 0,
            ),
        ],
      ),
      child: Center(
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 150),
          opacity: isSelected ? 1.0 : 0.0,
          child: Container(
            width: dotSize,
            height: dotSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: colors.primary,
            ),
          ),
        ),
      ),
    );
  }

  double _getIndicatorSize() {
    return switch (size) {
      GrafitRadioSize.sm => 16.0,
      GrafitRadioSize.md => 18.0,
      GrafitRadioSize.lg => 20.0,
    };
  }

  double _getDotSize() {
    return switch (size) {
      GrafitRadioSize.sm => 8.0,
      GrafitRadioSize.md => 10.0,
      GrafitRadioSize.lg => 12.0,
    };
  }
}

/// Individual radio item widget for custom layouts
class GrafitRadioItem<T> extends StatelessWidget {
  /// Value for this item
  final T value;

  /// Currently selected group value
  final T? groupValue;

  /// Label text
  final String? label;

  /// Optional description text
  final String? description;

  /// Callback when this item is selected
  final ValueChanged<T>? onChanged;

  /// Whether this item is enabled
  final bool enabled;

  /// Size variant
  final GrafitRadioSize size;

  const GrafitRadioItem({
    super.key,
    required this.value,
    required this.groupValue,
    this.label,
    this.description,
    this.onChanged,
    this.enabled = true,
    this.size = GrafitRadioSize.md,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<GrafitTheme>()!;
    final colors = theme.colors;
    final effectiveEnabled = enabled && onChanged != null;
    final isSelected = groupValue != null && groupValue == value;

    return GrafitClickable(
      enabled: effectiveEnabled,
      onTap: () => onChanged?.call(value),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _RadioIndicator(
            isSelected: isSelected,
            enabled: effectiveEnabled,
            size: size,
          ),
          if (label != null) ...[
            const SizedBox(width: 8),
            Text(
              label!,
              style: TextStyle(
                color: effectiveEnabled
                    ? colors.foreground
                    : colors.mutedForeground,
                fontSize: _getLabelFontSize(),
              ),
            ),
          ],
          if (description != null) ...[
            const SizedBox(width: 8),
            Text(
              description!,
              style: TextStyle(
                color: colors.mutedForeground,
                fontSize: _getDescriptionFontSize(),
              ),
            ),
          ],
        ],
      ),
    );
  }

  double _getLabelFontSize() {
    return switch (size) {
      GrafitRadioSize.sm => 13.0,
      GrafitRadioSize.md => 14.0,
      GrafitRadioSize.lg => 15.0,
    };
  }

  double _getDescriptionFontSize() {
    return switch (size) {
      GrafitRadioSize.sm => 11.0,
      GrafitRadioSize.md => 12.0,
      GrafitRadioSize.lg => 13.0,
    };
  }
}

// ============================================================
// WIDGETBOOK USE CASES
// ============================================================

@widgetbook.UseCase(
  name: 'Default',
  type: GrafitRadioGroup,
  path: 'Form/RadioGroup',
)
Widget radioGroupDefault(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.all(24.0),
    child: GrafitRadioGroup<String>(
      items: [
        GrafitRadioItemData(value: 'option1', label: 'Option 1'),
        GrafitRadioItemData(value: 'option2', label: 'Option 2'),
        GrafitRadioItemData(value: 'option3', label: 'Option 3'),
      ],
      value: 'option1',
    ),
  );
}

@widgetbook.UseCase(
  name: 'With Label',
  type: GrafitRadioGroup,
  path: 'Form/RadioGroup',
)
Widget radioGroupWithLabel(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.all(24.0),
    child: GrafitRadioGroup<String>(
      label: 'Notification Preference',
      items: [
        GrafitRadioItemData(value: 'all', label: 'All notifications'),
        GrafitRadioItemData(value: 'mentions', label: 'Mentions only'),
        GrafitRadioItemData(value: 'none', label: 'None'),
      ],
      value: 'all',
    ),
  );
}

@widgetbook.UseCase(
  name: 'Small Size',
  type: GrafitRadioGroup,
  path: 'Form/RadioGroup',
)
Widget radioGroupSmall(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.all(24.0),
    child: GrafitRadioGroup<String>(
      items: [
        GrafitRadioItemData(value: 'sm', label: 'Small'),
        GrafitRadioItemData(value: 'md', label: 'Medium'),
        GrafitRadioItemData(value: 'lg', label: 'Large'),
      ],
      value: 'sm',
      size: GrafitRadioSize.sm,
    ),
  );
}

@widgetbook.UseCase(
  name: 'Large Size',
  type: GrafitRadioGroup,
  path: 'Form/RadioGroup',
)
Widget radioGroupLarge(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.all(24.0),
    child: GrafitRadioGroup<String>(
      items: [
        GrafitRadioItemData(value: 'sm', label: 'Small'),
        GrafitRadioItemData(value: 'md', label: 'Medium'),
        GrafitRadioItemData(value: 'lg', label: 'Large'),
      ],
      value: 'lg',
      size: GrafitRadioSize.lg,
    ),
  );
}

@widgetbook.UseCase(
  name: 'Horizontal',
  type: GrafitRadioGroup,
  path: 'Form/RadioGroup',
)
Widget radioGroupHorizontal(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.all(24.0),
    child: GrafitRadioGroup<String>(
      items: [
        GrafitRadioItemData(value: 'left', label: 'Left'),
        GrafitRadioItemData(value: 'center', label: 'Center'),
        GrafitRadioItemData(value: 'right', label: 'Right'),
      ],
      value: 'left',
      direction: Axis.horizontal,
    ),
  );
}

@widgetbook.UseCase(
  name: 'With Descriptions',
  type: GrafitRadioGroup,
  path: 'Form/RadioGroup',
)
Widget radioGroupWithDescriptions(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.all(24.0),
    child: GrafitRadioGroup<String>(
      items: [
        GrafitRadioItemData(
          value: 'free',
          label: 'Free Plan',
          description: 'For individuals and small teams',
        ),
        GrafitRadioItemData(
          value: 'pro',
          label: 'Pro Plan',
          description: 'For growing businesses',
        ),
        GrafitRadioItemData(
          value: 'enterprise',
          label: 'Enterprise',
          description: 'For large organizations',
        ),
      ],
      value: 'free',
    ),
  );
}

@widgetbook.UseCase(
  name: 'Disabled',
  type: GrafitRadioGroup,
  path: 'Form/RadioGroup',
)
Widget radioGroupDisabled(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.all(24.0),
    child: GrafitRadioGroup<String>(
      items: [
        GrafitRadioItemData(value: 'yes', label: 'Yes'),
        GrafitRadioItemData(value: 'no', label: 'No'),
        GrafitRadioItemData(value: 'maybe', label: 'Maybe'),
      ],
      value: 'yes',
      enabled: false,
    ),
  );
}

@widgetbook.UseCase(
  name: 'With Disabled Item',
  type: GrafitRadioGroup,
  path: 'Form/RadioGroup',
)
Widget radioGroupWithDisabledItem(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.all(24.0),
    child: GrafitRadioGroup<String>(
      items: [
        GrafitRadioItemData(value: 'standard', label: 'Standard Shipping'),
        GrafitRadioItemData(value: 'express', label: 'Express Shipping'),
        GrafitRadioItemData(value: 'overnight', label: 'Overnight Shipping', enabled: false),
      ],
      value: 'standard',
    ),
  );
}

@widgetbook.UseCase(
  name: 'Interactive',
  type: GrafitRadioGroup,
  path: 'Form/RadioGroup',
)
Widget radioGroupInteractive(BuildContext context) {
  final label = context.knobs.string(label: 'Label', initialValue: 'Select an option');
  final size = context.knobs.list(
    label: 'Size',
    initialOption: GrafitRadioSize.md,
    options: const [GrafitRadioSize.sm, GrafitRadioSize.md, GrafitRadioSize.lg],
  );
  final direction = context.knobs.list(
    label: 'Direction',
    initialOption: Axis.vertical,
    options: const [Axis.vertical, Axis.horizontal],
  );
  final enabled = context.knobs.boolean(label: 'Enabled', initialValue: true);

  return Padding(
    padding: const EdgeInsets.all(24.0),
    child: GrafitRadioGroup<String>(
      label: label.isNotEmpty ? label : null,
      items: const [
        GrafitRadioItemData(value: 'option1', label: 'Option 1'),
        GrafitRadioItemData(value: 'option2', label: 'Option 2'),
        GrafitRadioItemData(value: 'option3', label: 'Option 3'),
      ],
      value: 'option1',
      size: size,
      direction: direction,
      enabled: enabled,
    ),
  );
}

