import 'package:flutter/material.dart';
import '../../theme/theme.dart';
import '../../theme/theme_data.dart';

/// Alert variant
enum GrafitAlertVariant {
  value,
  destructive,
  warning,
}

/// Alert component
class GrafitAlert extends StatelessWidget {
  final String title;
  final String? description;
  final GrafitAlertVariant variant;
  final IconData? icon;
  final VoidCallback? onClose;

  const GrafitAlert({
    super.key,
    required this.title,
    this.description,
    this.variant = GrafitAlertVariant.value,
    this.icon,
    this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<GrafitTheme>()!;
    final colors = theme.colors;

    final alertColors = _getAlertColors(colors);
    final alertIcon = icon ?? _getDefaultIcon();

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: alertColors.background,
        border: Border.all(color: alertColors.border),
        borderRadius: BorderRadius.circular(colors.radius * 8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            alertIcon,
            color: alertColors.foreground,
            size: 18,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: alertColors.foreground,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (description != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    description!,
                    style: TextStyle(
                      color: alertColors.foreground.withOpacity(0.9),
                      fontSize: 13,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (onClose != null)
            GestureDetector(
              onTap: onClose,
              child: Icon(
                Icons.close,
                color: alertColors.foreground,
                size: 16,
              ),
            ),
        ],
      ),
    );
  }

  _AlertColors _getAlertColors(GrafitColorScheme colors) {
    return switch (variant) {
      GrafitAlertVariant.destructive => _AlertColors(
          background: colors.destructive.withOpacity(0.1),
          foreground: colors.destructive,
          border: colors.destructive.withOpacity(0.2),
        ),
      GrafitAlertVariant.warning => _AlertColors(
          background: const Color(0xFFFFA500).withOpacity(0.1),
          foreground: const Color(0xFFFFA500),
          border: const Color(0xFFFFA500).withOpacity(0.2),
        ),
      GrafitAlertVariant.value => _AlertColors(
          background: colors.background,
          foreground: colors.foreground,
          border: colors.border,
        ),
    };
  }

  IconData _getDefaultIcon() {
    return switch (variant) {
      GrafitAlertVariant.destructive => Icons.error_outline,
      GrafitAlertVariant.warning => Icons.warning_amber_outlined,
      GrafitAlertVariant.value => Icons.info_outline,
    };
  }
}

class _AlertColors {
  final Color background;
  final Color foreground;
  final Color border;

  const _AlertColors({
    required this.background,
    required this.foreground,
    required this.border,
  });
}
