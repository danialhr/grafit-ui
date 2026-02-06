import 'package:flutter/material.dart';
import '../../theme/theme.dart';

/// Separator component
class GrafitSeparator extends StatelessWidget {
  final bool horizontal;
  final double? thickness;
  final Color? color;
  final double? spacing;
  final bool decorative;

  const GrafitSeparator({
    super.key,
    this.horizontal = true,
    this.thickness,
    this.color,
    this.spacing,
    this.decorative = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<GrafitTheme>()!;
    final colors = theme.colors;

    final separator = horizontal
        ? Container(
            height: thickness ?? 1,
            margin: EdgeInsets.symmetric(vertical: spacing ?? 8),
            decoration: BoxDecoration(
              color: color ?? colors.border,
            ),
          )
        : Container(
            width: thickness ?? 1,
            margin: EdgeInsets.symmetric(horizontal: spacing ?? 8),
            decoration: BoxDecoration(
              color: color ?? colors.border,
            ),
          );

    // Use Semantics for accessibility when decorative=false
    if (decorative) {
      return Semantics(
        container: true,
        child: separator,
      );
    }

    return ExcludeSemantics(
      child: separator,
    );
  }
}
