import 'package:flutter/material.dart';
import '../../theme/theme.dart';
import '../../theme/theme_data.dart';

/// Label component
class GrafitLabel extends StatelessWidget {
  final String text;
  final Widget? child;
  final bool required;
  final bool disabled;

  const GrafitLabel({
    super.key,
    required this.text,
    this.child,
    this.required = false,
    this.disabled = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<GrafitTheme>()!;
    final colors = theme.colors;

    final labelChild = child ??
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Text(
                text,
                style: TextStyle(
                  color: disabled
                      ? colors.mutedForeground
                      : colors.foreground,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            if (required)
              Text(
                ' *',
                style: TextStyle(
                  color: colors.destructive,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
          ],
        );

    return Opacity(
      opacity: disabled ? 0.5 : 1.0,
      child: labelChild,
    );
  }
}
