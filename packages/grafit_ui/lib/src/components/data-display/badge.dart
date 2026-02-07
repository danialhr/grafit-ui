import 'package:flutter/material.dart';
import '../../theme/theme.dart';
import '../../theme/theme_data.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

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

// Widgetbook use cases
@widgetbook.UseCase(
  name: 'Default',
  type: GrafitBadge,
  path: 'DataDisplay/Badge',
)
Widget badgeDefault(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.all(16.0),
    child: GrafitBadge(
      label: 'Badge',
    ),
  );
}

@widgetbook.UseCase(
  name: 'Primary',
  type: GrafitBadge,
  path: 'DataDisplay/Badge',
)
Widget badgePrimary(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.all(16.0),
    child: GrafitBadge(
      label: 'Primary',
      variant: GrafitBadgeVariant.primary,
    ),
  );
}

@widgetbook.UseCase(
  name: 'Secondary',
  type: GrafitBadge,
  path: 'DataDisplay/Badge',
)
Widget badgeSecondary(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.all(16.0),
    child: GrafitBadge(
      label: 'Secondary',
      variant: GrafitBadgeVariant.secondary,
    ),
  );
}

@widgetbook.UseCase(
  name: 'Destructive',
  type: GrafitBadge,
  path: 'DataDisplay/Badge',
)
Widget badgeDestructive(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.all(16.0),
    child: GrafitBadge(
      label: 'Error',
      variant: GrafitBadgeVariant.destructive,
    ),
  );
}

@widgetbook.UseCase(
  name: 'Outline',
  type: GrafitBadge,
  path: 'DataDisplay/Badge',
)
Widget badgeOutline(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.all(16.0),
    child: GrafitBadge(
      label: 'Outline',
      variant: GrafitBadgeVariant.outline,
    ),
  );
}

@widgetbook.UseCase(
  name: 'Ghost',
  type: GrafitBadge,
  path: 'DataDisplay/Badge',
)
Widget badgeGhost(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.all(16.0),
    child: GrafitBadge(
      label: 'Ghost',
      variant: GrafitBadgeVariant.ghost,
    ),
  );
}

@widgetbook.UseCase(
  name: 'All Variants',
  type: GrafitBadge,
  path: 'DataDisplay/Badge',
)
Widget badgeAllVariants(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.all(16.0),
    child: Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        GrafitBadge(label: 'Default', variant: GrafitBadgeVariant.value),
        GrafitBadge(label: 'Primary', variant: GrafitBadgeVariant.primary),
        GrafitBadge(label: 'Secondary', variant: GrafitBadgeVariant.secondary),
        GrafitBadge(label: 'Destructive', variant: GrafitBadgeVariant.destructive),
        GrafitBadge(label: 'Outline', variant: GrafitBadgeVariant.outline),
        GrafitBadge(label: 'Ghost', variant: GrafitBadgeVariant.ghost),
      ],
    ),
  );
}

@widgetbook.UseCase(
  name: 'Status Badges',
  type: GrafitBadge,
  path: 'DataDisplay/Badge',
)
Widget badgeStatus(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.all(16.0),
    child: Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            GrafitBadge(label: 'Active', variant: GrafitBadgeVariant.primary),
            SizedBox(width: 4),
            Text('Active', style: TextStyle(fontSize: 14)),
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            GrafitBadge(label: 'Draft', variant: GrafitBadgeVariant.secondary),
            SizedBox(width: 4),
            Text('Draft', style: TextStyle(fontSize: 14)),
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            GrafitBadge(label: 'Failed', variant: GrafitBadgeVariant.destructive),
            SizedBox(width: 4),
            Text('Failed', style: TextStyle(fontSize: 14)),
          ],
        ),
      ],
    ),
  );
}

@widgetbook.UseCase(
  name: 'Interactive',
  type: GrafitBadge,
  path: 'DataDisplay/Badge',
)
Widget badgeInteractive(BuildContext context) {
  // Widgetbook-only: ignore undefined_getter, undefined_method, invalid_annotation_value
  final label = context.knobs.string(label: 'Label', initialValue: 'Badge');
  // Widgetbook-only: ignore undefined_getter, undefined_method, invalid_annotation_value
  final variant = context.knobs.list(
    label: 'Variant',
    initialOption: GrafitBadgeVariant.value,
    options: [
      GrafitBadgeVariant.value,
      GrafitBadgeVariant.primary,
      GrafitBadgeVariant.secondary,
      GrafitBadgeVariant.destructive,
      GrafitBadgeVariant.outline,
      GrafitBadgeVariant.ghost,
    ],
  );

  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: GrafitBadge(
      label: label.isNotEmpty ? label : 'Badge',
      variant: variant,
    ),
  );
}
