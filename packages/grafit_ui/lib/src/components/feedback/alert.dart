import 'package:flutter/material.dart';
import '../../theme/theme.dart';
import '../../theme/theme_data.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

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

// Widgetbook use cases
@widgetbook.UseCase(
  name: 'Default',
  type: GrafitAlert,
  path: 'Feedback/Alert',
)
Widget alertDefault(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.all(16.0),
    child: GrafitAlert(
      title: 'Information',
      description: 'This is an informational alert message.',
    ),
  );
}

@widgetbook.UseCase(
  name: 'Destructive',
  type: GrafitAlert,
  path: 'Feedback/Alert',
)
Widget alertDestructive(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.all(16.0),
    child: GrafitAlert(
      title: 'Error',
      description: 'Something went wrong. Please try again.',
      variant: GrafitAlertVariant.destructive,
    ),
  );
}

@widgetbook.UseCase(
  name: 'Warning',
  type: GrafitAlert,
  path: 'Feedback/Alert',
)
Widget alertWarning(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.all(16.0),
    child: GrafitAlert(
      title: 'Warning',
      description: 'Please review this important warning.',
      variant: GrafitAlertVariant.warning,
    ),
  );
}

@widgetbook.UseCase(
  name: 'Without Description',
  type: GrafitAlert,
  path: 'Feedback/Alert',
)
Widget alertWithoutDescription(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.all(16.0),
    child: Column(
      children: [
        GrafitAlert(
          title: 'Information',
          variant: GrafitAlertVariant.value,
        ),
        SizedBox(height: 8),
        GrafitAlert(
          title: 'Error',
          variant: GrafitAlertVariant.destructive,
        ),
        SizedBox(height: 8),
        GrafitAlert(
          title: 'Warning',
          variant: GrafitAlertVariant.warning,
        ),
      ],
    ),
  );
}

@widgetbook.UseCase(
  name: 'With Close Button',
  type: GrafitAlert,
  path: 'Feedback/Alert',
)
Widget alertWithClose(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.all(16.0),
    child: GrafitAlert(
      title: 'Dismissible Alert',
      description: 'You can dismiss this alert by clicking the X button.',
      onClose: null, // In real use, provide a callback
    ),
  );
}

@widgetbook.UseCase(
  name: 'All Variants',
  type: GrafitAlert,
  path: 'Feedback/Alert',
)
Widget alertAllVariants(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.all(16.0),
    child: Column(
      children: [
        GrafitAlert(
          title: 'Information',
          description: 'This is an informational message.',
          variant: GrafitAlertVariant.value,
        ),
        SizedBox(height: 8),
        GrafitAlert(
          title: 'Error',
          description: 'This is an error message.',
          variant: GrafitAlertVariant.destructive,
        ),
        SizedBox(height: 8),
        GrafitAlert(
          title: 'Warning',
          description: 'This is a warning message.',
          variant: GrafitAlertVariant.warning,
        ),
      ],
    ),
  );
}

@widgetbook.UseCase(
  name: 'Custom Icon',
  type: GrafitAlert,
  path: 'Feedback/Alert',
)
Widget alertCustomIcon(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.all(16.0),
    child: Column(
      children: [
        GrafitAlert(
          title: 'Success',
          description: 'Operation completed successfully!',
          icon: Icons.check_circle,
        ),
        SizedBox(height: 8),
        GrafitAlert(
          title: 'Info',
          description: 'Here is some additional information.',
          icon: Icons.info,
        ),
        SizedBox(height: 8),
        GrafitAlert(
          title: 'Tip',
          description: 'Pro tip: You can customize icons!',
          icon: Icons.lightbulb,
        ),
      ],
    ),
  );
}

@widgetbook.UseCase(
  name: 'Interactive',
  type: GrafitAlert,
  path: 'Feedback/Alert',
)
Widget alertInteractive(BuildContext context) {
  final title = context.knobs.string(
    label: 'Title',
    initialValue: 'Alert Title',
  );
  final description = context.knobs.string(
    label: 'Description',
    initialValue: 'This is the alert description text.',
  );
  final variant = context.knobs.list(
    label: 'Variant',
    initialOption: GrafitAlertVariant.value,
    options: [
      GrafitAlertVariant.value,
      GrafitAlertVariant.destructive,
      GrafitAlertVariant.warning,
    ],
  );
  final hasIcon = context.knobs.boolean(
    label: 'Show Custom Icon',
    initialValue: false,
  );
  final hasCloseButton = context.knobs.boolean(
    label: 'Show Close Button',
    initialValue: false,
  );

  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: GrafitAlert(
      title: title.isNotEmpty ? title : 'Alert Title',
      description: description.isNotEmpty ? description : null,
      variant: variant,
      icon: hasIcon ? Icons.notifications : null,
      onClose: hasCloseButton ? () {} : null,
    ),
  );
}
