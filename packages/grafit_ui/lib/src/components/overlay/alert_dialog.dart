import 'package:flutter/material.dart';
import '../../theme/theme.dart';
import '../form/button.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

/// AlertDialog size variant
enum GrafitAlertDialogSize {
  sm,
  value,
}

/// AlertDialog component - modal for important actions requiring confirmation
class GrafitAlertDialog extends StatefulWidget {
  final Widget? title;
  final String? titleText;
  final Widget? description;
  final String? descriptionText;
  final Widget? content;
  final List<Widget>? actions;
  final Widget? trigger;
  final GrafitAlertDialogSize size;
  final Widget? media;
  final bool dismissible;

  const GrafitAlertDialog({
    super.key,
    this.title,
    this.titleText,
    this.description,
    this.descriptionText,
    this.content,
    this.actions,
    this.trigger,
    this.size = GrafitAlertDialogSize.value,
    this.media,
    this.dismissible = true,
  });

  @override
  State<GrafitAlertDialog> createState() => _GrafitAlertDialogState();
}

class _GrafitAlertDialogState extends State<GrafitAlertDialog> {
  bool _isOpen = false;

  void _show() {
    setState(() => _isOpen = true);
  }

  void _hide() {
    setState(() => _isOpen = false);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final trigger = widget.trigger ??
        GrafitButton(
          label: 'Open',
          onPressed: _show,
        );

    if (widget.trigger != null && !_isOpen) {
      return trigger;
    }

    if (!_isOpen) {
      return const SizedBox.shrink();
    }

    return _GrafitAlertDialogOverlay(
      onDismiss: widget.dismissible ? _hide : null,
      child: _GrafitAlertDialogContent(
        size: widget.size,
        title: widget.title ?? (widget.titleText != null ? Text(widget.titleText!) : null),
        description: widget.description ?? (widget.descriptionText != null ? Text(widget.descriptionText!) : null),
        content: widget.content,
        actions: widget.actions,
        media: widget.media,
        onDismiss: _hide,
      ),
    );
  }
}

/// Internal overlay for backdrop
class _GrafitAlertDialogOverlay extends StatelessWidget {
  final Widget child;
  final VoidCallback? onDismiss;

  const _GrafitAlertDialogOverlay({
    required this.child,
    this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<GrafitTheme>()!;

    return GestureDetector(
      onTap: onDismiss,
      child: Container(
        color: Colors.black.withOpacity(0.5),
        child: child,
      ),
    );
  }
}

/// Internal content widget
class _GrafitAlertDialogContent extends StatelessWidget {
  final GrafitAlertDialogSize size;
  final Widget? title;
  final Widget? description;
  final Widget? content;
  final List<Widget>? actions;
  final Widget? media;
  final VoidCallback onDismiss;

  const _GrafitAlertDialogContent({
    required this.size,
    this.title,
    this.description,
    this.content,
    this.actions,
    this.media,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<GrafitTheme>()!;
    final colors = theme.colors;

    final maxWidth = size == GrafitAlertDialogSize.sm ? 280.0 : 512.0;

    return Dialog(
      backgroundColor: colors.background,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(colors.radius * 8),
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: maxWidth,
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (title != null || media != null) ...[
                Row(
                  children: [
                    if (title != null)
                      Expanded(
                        child: DefaultTextStyle(
                          style: TextStyle(
                            color: colors.foreground,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                          child: title!,
                        ),
                      ),
                    if (media != null && title != null) const SizedBox(width: 16),
                    if (media != null) media!,
                  ],
                ),
                const SizedBox(height: 16),
              ],
              if (description != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: DefaultTextStyle(
                    style: TextStyle(
                      color: colors.mutedForeground,
                      fontSize: 14,
                    ),
                    child: description!,
                  ),
                ),
              if (content != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: content!,
                ),
              if (actions != null && actions!.isNotEmpty)
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: actions!,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// AlertDialogHeader - contains title and optional media
class GrafitAlertDialogHeader extends StatelessWidget {
  final Widget? title;
  final Widget? media;

  const GrafitAlertDialogHeader({
    super.key,
    this.title,
    this.media,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (title != null) Expanded(child: title!),
        if (media != null && title != null) const SizedBox(width: 16),
        if (media != null) media!,
      ],
    );
  }
}

/// AlertDialogFooter - action buttons container
class GrafitAlertDialogFooter extends StatelessWidget {
  final List<Widget> actions;

  const GrafitAlertDialogFooter({
    super.key,
    required this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: actions,
    );
  }
}

/// AlertDialogTitle - dialog title widget
class GrafitAlertDialogTitle extends StatelessWidget {
  final String title;

  const GrafitAlertDialogTitle({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<GrafitTheme>()!;
    final colors = theme.colors;

    return Text(
      title,
      style: TextStyle(
        color: colors.foreground,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

/// AlertDialogDescription - dialog description widget
class GrafitAlertDialogDescription extends StatelessWidget {
  final String description;

  const GrafitAlertDialogDescription({
    super.key,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<GrafitTheme>()!;
    final colors = theme.colors;

    return Text(
      description,
      style: TextStyle(
        color: colors.mutedForeground,
        fontSize: 14,
      ),
    );
  }
}

/// AlertDialogAction - button action for AlertDialog
class GrafitAlertDialogAction extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final GrafitButtonVariant variant;
  final bool destructive;

  const GrafitAlertDialogAction({
    super.key,
    required this.label,
    this.onPressed,
    this.variant = GrafitButtonVariant.primary,
    this.destructive = false,
  });

  @override
  Widget build(BuildContext context) {
    return GrafitButton(
      label: label,
      onPressed: onPressed,
      variant: destructive ? GrafitButtonVariant.destructive : variant,
    );
  }
}

/// AlertDialogCancel - cancel button (outline variant by default)
class GrafitAlertDialogCancel extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;

  const GrafitAlertDialogCancel({
    super.key,
    required this.label,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GrafitButton(
      label: label,
      onPressed: onPressed ?? () => Navigator.of(context).pop(),
      variant: GrafitButtonVariant.outline,
    );
  }
}

/// AlertDialogMedia - media/icon display in alert dialog
class GrafitAlertDialogMedia extends StatelessWidget {
  final Widget? child;
  final Color? backgroundColor;

  const GrafitAlertDialogMedia({
    super.key,
    this.child,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<GrafitTheme>()!;
    final colors = theme.colors;

    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        color: backgroundColor ?? colors.muted,
        borderRadius: BorderRadius.circular(colors.radius * 6),
      ),
      child: child ?? const Icon(Icons.warning_amber_outlined),
    );
  }
}

// Widgetbook use cases
@widgetbook.UseCase(
  name: 'Default',
  type: GrafitAlertDialog,
  path: 'Overlay/AlertDialog',
)
Widget alertDialogDefault(BuildContext context) {
  return GrafitAlertDialog(
    open: true,
    titleText: 'Are you sure?',
    descriptionText: 'This action cannot be undone. This will permanently delete your account and remove your data from our servers.',
    actions: [
      GrafitAlertDialogCancel(label: 'Cancel'),
      const SizedBox(width: 8),
      GrafitAlertDialogAction(label: 'Delete Account', destructive: true),
    ],
  );
}

@widgetbook.UseCase(
  name: 'With Media',
  type: GrafitAlertDialog,
  path: 'Overlay/AlertDialog',
)
Widget alertDialogWithMedia(BuildContext context) {
  return GrafitAlertDialog(
    open: true,
    titleText: 'Success',
    descriptionText: 'Your changes have been saved successfully.',
    media: GrafitAlertDialogMedia(
      backgroundColor: Colors.green.shade100,
      child: Icon(Icons.check_circle, color: Colors.green.shade700),
    ),
    actions: [
      GrafitAlertDialogAction(label: 'Continue'),
    ],
  );
}

@widgetbook.UseCase(
  name: 'Small Size',
  type: GrafitAlertDialog,
  path: 'Overlay/AlertDialog',
)
Widget alertDialogSmall(BuildContext context) {
  return GrafitAlertDialog(
    open: true,
    size: GrafitAlertDialogSize.sm,
    titleText: 'Delete Item',
    descriptionText: 'Are you sure you want to delete this item?',
    actions: [
      GrafitAlertDialogCancel(label: 'Cancel'),
      const SizedBox(width: 8),
      GrafitAlertDialogAction(label: 'Delete', destructive: true),
    ],
  );
}

@widgetbook.UseCase(
  name: 'Warning Dialog',
  type: GrafitAlertDialog,
  path: 'Overlay/AlertDialog',
)
Widget alertDialogWarning(BuildContext context) {
  return GrafitAlertDialog(
    open: true,
    titleText: 'Warning',
    descriptionText: 'You are about to perform a potentially dangerous action. Please review carefully.',
    media: const GrafitAlertDialogMedia(
      child: Icon(Icons.warning_amber_outlined, color: Colors.orange, size: 32),
    ),
    actions: [
      GrafitAlertDialogCancel(label: 'Go Back'),
      const SizedBox(width: 8),
      GrafitAlertDialogAction(label: 'Proceed'),
    ],
  );
}

@widgetbook.UseCase(
  name: 'Confirm Dialog',
  type: GrafitAlertDialog,
  path: 'Overlay/AlertDialog',
)
Widget alertDialogConfirm(BuildContext context) {
  return GrafitAlertDialog(
    open: true,
    titleText: 'Confirm Subscription',
    descriptionText: 'By clicking confirm, you agree to subscribe to our premium plan at \$9.99/month.',
    actions: [
      GrafitAlertDialogCancel(label: 'Maybe Later'),
      const SizedBox(width: 8),
      GrafitAlertDialogAction(label: 'Confirm Subscription'),
    ],
  );
}

@widgetbook.UseCase(
  name: 'Info Dialog',
  type: GrafitAlertDialog,
  path: 'Overlay/AlertDialog',
)
Widget alertDialogInfo(BuildContext context) {
  return GrafitAlertDialog(
    open: true,
    titleText: 'Information',
    descriptionText: 'Your session will expire in 5 minutes. Please save your work to avoid losing any changes.',
    media: const GrafitAlertDialogMedia(
      child: Icon(Icons.info_outline, color: Colors.blue, size: 32),
    ),
    actions: [
      GrafitAlertDialogAction(label: 'Got it'),
    ],
  );
}

@widgetbook.UseCase(
  name: 'Non Dismissible',
  type: GrafitAlertDialog,
  path: 'Overlay/AlertDialog',
)
Widget alertDialogNonDismissible(BuildContext context) {
  return GrafitAlertDialog(
    open: true,
    dismissible: false,
    titleText: 'Attention Required',
    descriptionText: 'You must complete this action before proceeding. This dialog cannot be dismissed.',
    actions: [
      GrafitAlertDialogAction(label: 'I Understand'),
    ],
  );
}

@widgetbook.UseCase(
  name: 'With Custom Content',
  type: GrafitAlertDialog,
  path: 'Overlay/AlertDialog',
)
Widget alertDialogCustomContent(BuildContext context) {
  return GrafitAlertDialog(
    open: true,
    titleText: 'Select Option',
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        RadioListTile(
          title: Text('Option 1'),
          value: '1',
          groupValue: '1',
          onChanged: (_) {},
        ),
        RadioListTile(
          title: Text('Option 2'),
          value: '2',
          groupValue: '1',
          onChanged: (_) {},
        ),
        RadioListTile(
          title: Text('Option 3'),
          value: '3',
          groupValue: '1',
          onChanged: (_) {},
        ),
      ],
    ),
    actions: [
      GrafitAlertDialogCancel(label: 'Cancel'),
      const SizedBox(width: 8),
      GrafitAlertDialogAction(label: 'Confirm'),
    ],
  );
}

@widgetbook.UseCase(
  name: 'Interactive',
  type: GrafitAlertDialog,
  path: 'Overlay/AlertDialog',
)
Widget alertDialogInteractive(BuildContext context) {
  // Widgetbook-only: ignore undefined_getter, undefined_method, invalid_annotation_value
  final title = context.knobs.string(label: 'Title', initialValue: 'Confirm Action');
  // Widgetbook-only: ignore undefined_getter, undefined_method, invalid_annotation_value
  final description = context.knobs.string(
    label: 'Description',
    initialValue: 'Are you sure you want to proceed?',
  );
  // Widgetbook-only: ignore undefined_getter, undefined_method, invalid_annotation_value
  final size = context.knobs.list(
    label: 'Size',
    initialOption: GrafitAlertDialogSize.value,
    options: [GrafitAlertDialogSize.sm, GrafitAlertDialogSize.value],
  );
  // Widgetbook-only: ignore undefined_getter, undefined_method, invalid_annotation_value
  final dismissible = context.knobs.boolean(label: 'Dismissible', initialValue: true);
  // Widgetbook-only: ignore undefined_getter, undefined_method, invalid_annotation_value
  final showMedia = context.knobs.boolean(label: 'Show Media', initialValue: false);
  // Widgetbook-only: ignore undefined_getter, undefined_method, invalid_annotation_value
  final showCancel = context.knobs.boolean(label: 'Show Cancel Button', initialValue: true);

  return GrafitAlertDialog(
    open: true,
    size: size,
    dismissible: dismissible,
    titleText: title.isNotEmpty ? title : null,
    descriptionText: description.isNotEmpty ? description : null,
    media: showMedia ? const GrafitAlertDialogMedia() : null,
    actions: [
      if (showCancel) GrafitAlertDialogCancel(label: 'Cancel'),
      if (showCancel && showCancel) const SizedBox(width: 8),
      GrafitAlertDialogAction(label: 'Confirm'),
    ],
  );
}
