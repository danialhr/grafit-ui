import 'package:flutter/material.dart';
import '../../theme/theme.dart';
import '../../theme/theme_data.dart';

/// Badge variant
enum GrafitBadgeVariant {
  value,
  primary,
  secondary,
  destructive,
  outline,
  ghost,
}

/// Badge component
class GrafitBadge extends StatelessWidget {
  final String label;
  final GrafitBadgeVariant variant;
  final Widget? child;
  final Color? backgroundColor;
  final Color? foregroundColor;

  const GrafitBadge({
    super.key,
    required this.label,
    this.variant = GrafitBadgeVariant.value,
    this.child,
    this.backgroundColor,
    this.foregroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<GrafitTheme>()!;
    final colors = theme.colors;

    final badgeColors = _getBadgeColors(colors);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor ?? badgeColors.background,
        border: badgeColors.border != null
            ? Border.all(color: badgeColors.border!)
            : null,
        borderRadius: BorderRadius.circular(colors.radius * 6),
      ),
      child: child ??
          Text(
            label,
            style: TextStyle(
              color: foregroundColor ?? badgeColors.foreground,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
    );
  }

  _BadgeColors _getBadgeColors(GrafitColorScheme colors) {
    return switch (variant) {
      GrafitBadgeVariant.primary => _BadgeColors(
          background: colors.primary.withOpacity(0.1),
          foreground: colors.primary,
        ),
      GrafitBadgeVariant.secondary => _BadgeColors(
          background: colors.secondary,
          foreground: colors.secondaryForeground,
        ),
      GrafitBadgeVariant.destructive => _BadgeColors(
          background: colors.destructive.withOpacity(0.1),
          foreground: colors.destructive,
        ),
      GrafitBadgeVariant.outline => _BadgeColors(
          background: Colors.transparent,
          foreground: colors.foreground,
          border: colors.border,
        ),
      GrafitBadgeVariant.ghost => _BadgeColors(
          background: colors.muted,
          foreground: colors.mutedForeground,
        ),
      GrafitBadgeVariant.value => _BadgeColors(
          background: colors.primary,
          foreground: colors.primaryForeground,
        ),
    };
  }
}

class _BadgeColors {
  final Color background;
  final Color foreground;
  final Color? border;

  const _BadgeColors({
    required this.background,
    required this.foreground,
    this.border,
  });
}
