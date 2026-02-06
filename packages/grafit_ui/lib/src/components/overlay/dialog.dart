import 'package:flutter/material.dart';
import '../../theme/theme.dart';
import '../form/button.dart';

/// Dialog component
class GrafitDialog extends StatelessWidget {
  final String? title;
  final String? description;
  final Widget? content;
  final List<Widget>? actions;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;
  final String confirmText;
  final String cancelText;
  final bool showCancel;

  const GrafitDialog({
    super.key,
    this.title,
    this.description,
    this.content,
    this.actions,
    this.onConfirm,
    this.onCancel,
    this.confirmText = 'Confirm',
    this.cancelText = 'Cancel',
    this.showCancel = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<GrafitTheme>()!;
    final colors = theme.colors;

    return AlertDialog(
      backgroundColor: colors.background,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(colors.radius * 8),
      ),
      title: title != null
          ? Text(
              title!,
              style: TextStyle(
                color: colors.foreground,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            )
          : null,
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (description != null)
              Text(
                description!,
                style: TextStyle(
                  color: colors.mutedForeground,
                  fontSize: 14,
                ),
              ),
            if (content != null) ...[
              const SizedBox(height: 16),
              content!,
            ],
          ],
        ),
      ),
      actions: actions ??
          [
            if (showCancel)
              GrafitButton(
                label: cancelText,
                variant: GrafitButtonVariant.ghost,
                onPressed: () {
                  onCancel?.call();
                  Navigator.of(context).pop();
                },
              ),
            GrafitButton(
              label: confirmText,
              variant: GrafitButtonVariant.primary,
              onPressed: () {
                onConfirm?.call();
                Navigator.of(context).pop();
              },
            ),
          ],
    );
  }

  /// Show dialog
  static Future<bool?> show(
    BuildContext context, {
    String? title,
    String? description,
    Widget? content,
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
    bool showCancel = true,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (context) => GrafitDialog(
        title: title,
        description: description,
        content: content,
        onConfirm: onConfirm,
        onCancel: onCancel,
        confirmText: confirmText,
        cancelText: cancelText,
        showCancel: showCancel,
      ),
    );
  }
}
