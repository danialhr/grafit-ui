import 'package:flutter/material.dart';
import '../../theme/theme.dart';

/// Scroll area component
class GrafitScrollArea extends StatelessWidget {
  final Widget child;
  final Axis? scrollDirection;
  final bool? primary;
  final ScrollController? controller;
  final EdgeInsets? padding;

  const GrafitScrollArea({
    super.key,
    required this.child,
    this.scrollDirection,
    this.primary,
    this.controller,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<GrafitTheme>()!;
    final colors = theme.colors;

    return Scrollbar(
      thumbVisibility: true,
      thickness: 8,
      radius: Radius.circular(colors.radius * 4),
      child: SingleChildScrollView(
        scrollDirection: scrollDirection ?? Axis.vertical,
        primary: primary,
        controller: controller,
        padding: padding,
        child: child,
      ),
    );
  }
}
