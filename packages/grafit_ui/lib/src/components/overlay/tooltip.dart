import 'package:flutter/material.dart';
import '../../theme/theme.dart';

/// Tooltip component
class GrafitTooltip extends StatelessWidget {
  final String message;
  final Widget child;
  final int delayDuration;
  final int? skipDelayDuration;

  const GrafitTooltip({
    super.key,
    required this.message,
    required this.child,
    this.delayDuration = 500,
    this.skipDelayDuration,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<GrafitTheme>()!;
    final colors = theme.colors;

    return Tooltip(
      message: message,
      waitDuration: Duration(milliseconds: delayDuration),
      showDuration: skipDelayDuration != null
          ? Duration(milliseconds: skipDelayDuration!)
          : null,
      decoration: BoxDecoration(
        color: colors.foreground,
        borderRadius: BorderRadius.circular(colors.radius * 6),
      ),
      textStyle: TextStyle(
        color: colors.background,
        fontSize: 13,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: child,
    );
  }
}
