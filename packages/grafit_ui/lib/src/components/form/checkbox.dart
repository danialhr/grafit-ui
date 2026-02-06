import 'package:flutter/material.dart';
import '../../theme/theme.dart';
import '../../primitives/clickable.dart';

/// Checkbox component
class GrafitCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;
  final String? label;
  final bool enabled;
  final GrafitInputSizeX size;

  const GrafitCheckbox({
    super.key,
    required this.value,
    this.onChanged,
    this.label,
    this.enabled = true,
    this.size = GrafitInputSizeX.md,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<GrafitTheme>()!;
    final colors = theme.colors;
    final effectiveEnabled = enabled && onChanged != null;

    Widget checkbox = GrafitClickable(
      enabled: effectiveEnabled,
      onTap: () => onChanged?.call(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: _getCheckboxSize(),
        height: _getCheckboxSize(),
        decoration: BoxDecoration(
          color: value
              ? colors.primary
              : (context.isClickableHovered && effectiveEnabled)
                  ? colors.muted
                  : colors.background,
          border: Border.all(
            color: value
                ? colors.primary
                : (context.isClickableFocused)
                    ? colors.ring
                    : colors.border,
            width: context.isClickableFocused ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(colors.radius * 4),
        ),
        child: value
            ? Icon(
                Icons.check,
                color: colors.primaryForeground,
                size: _getIconSize(),
              )
            : null,
      ),
    );

    if (label != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          checkbox,
          const SizedBox(width: 8),
          GestureDetector(
            onTap: effectiveEnabled ? () => onChanged?.call(!value) : null,
            child: Text(
              label!,
              style: TextStyle(
                color: effectiveEnabled ? colors.foreground : colors.mutedForeground,
                fontSize: _getFontSize(),
              ),
            ),
          ),
        ],
      );
    }

    return checkbox;
  }

  double _getCheckboxSize() {
    return switch (size) {
      GrafitInputSizeX.sm => 16.0,
      GrafitInputSizeX.md => 18.0,
      GrafitInputSizeX.lg => 20.0,
    };
  }

  double _getIconSize() {
    return switch (size) {
      GrafitInputSizeX.sm => 12.0,
      GrafitInputSizeX.md => 14.0,
      GrafitInputSizeX.lg => 16.0,
    };
  }

  double _getFontSize() {
    return switch (size) {
      GrafitInputSizeX.sm => 13.0,
      GrafitInputSizeX.md => 14.0,
      GrafitInputSizeX.lg => 15.0,
    };
  }
}

enum GrafitInputSizeX { sm, md, lg }
