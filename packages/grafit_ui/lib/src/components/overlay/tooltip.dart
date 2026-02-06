import 'package:flutter/material.dart';
import '../../theme/theme.dart';

/// Tooltip component
class GrafitTooltip extends StatelessWidget {
  final String message;
  final Widget child;
  final bool wait;

  const GrafitTooltip({
    super.key,
    required this.message,
    required this.child,
    this.wait = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<GrafitTheme>()!;
    final colors = theme.colors;

    return Tooltip(
      message: message,
      waitDuration: Duration(milliseconds: wait ? 500 : 0),
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
