import 'package:flutter/material.dart';
import '../../theme/theme.dart';

/// Card component
class GrafitCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final bool bordered;
  final bool shadow;
  final Color? backgroundColor;
  final CrossAxisAlignment? alignment;

  const GrafitCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.bordered = true,
    this.shadow = false,
    this.backgroundColor,
    this.alignment,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<GrafitTheme>()!;
    final colors = theme.colors;

    return Container(
      margin: margin,
      padding: padding ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor ?? colors.card,
        border: bordered
            ? Border.all(color: colors.border)
            : null,
        borderRadius: BorderRadius.circular(colors.radius * 8),
        boxShadow: shadow ? theme.shadows.sm : null,
      ),
      child: child,
    );
  }
}

/// Card header component
class GrafitCardHeader extends StatelessWidget {
  final String? title;
  final String? description;
  final Widget? action;
  final Widget? child;

  const GrafitCardHeader({
    super.key,
    this.title,
    this.description,
    this.action,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<GrafitTheme>()!;
    final colors = theme.colors;

    if (child != null) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
        child: child!,
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (title != null)
                  Text(
                    title!,
                    style: TextStyle(
                      color: colors.foreground,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                if (description != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    description!,
                    style: TextStyle(
                      color: colors.mutedForeground,
                      fontSize: 13,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (action != null) action!,
        ],
      ),
    );
  }
}

/// Card content component
class GrafitCardContent extends StatelessWidget {
  final Widget child;

  const GrafitCardContent({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: child,
    );
  }
}

/// Card footer component
class GrafitCardFooter extends StatelessWidget {
  final Widget child;

  const GrafitCardFooter({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<GrafitTheme>()!;
    final colors = theme.colors;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.muted,
        border: Border(
          top: BorderSide(color: colors.border),
        ),
      ),
      child: child,
    );
  }
}
