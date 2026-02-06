import 'package:flutter/material.dart';
import '../../theme/theme.dart';
import '../form/button.dart';

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
