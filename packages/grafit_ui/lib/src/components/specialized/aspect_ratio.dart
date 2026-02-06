import 'package:flutter/material.dart';
import '../../theme/theme.dart';

/// Aspect Ratio component
///
/// Constrains its child to a specific aspect ratio.
/// This is useful for maintaining consistent proportions for images,
/// videos, and other media content.
class GrafitAspectRatio extends StatelessWidget {
  /// The widget below this widget in the tree.
  final Widget child;

  /// The aspect ratio to apply to the child.
  /// The aspect ratio is expressed as a ratio of width to height.
  /// For example, a 16:9 aspect ratio would be 16 / 9.
  ///
  /// Common ratios:
  /// - 16 / 9 for widescreen video
  /// - 4 / 3 for standard video
  /// - 1 / 1 for square
  /// - 21 / 9 for ultrawide
  /// - 3 / 2 for classic film
  /// - 2 / 3 for portrait
  final double ratio;

  /// Optional alignment of the child within the aspect ratio bounds.
  final AlignmentGeometry alignment;

  const GrafitAspectRatio({
    super.key,
    required this.child,
    this.ratio = 1.0,
    this.alignment = Alignment.center,
  });

  /// 16:9 aspect ratio (widescreen video)
  static const double ratio16_9 = 16 / 9;

  /// 4:3 aspect ratio (standard video)
  static const double ratio4_3 = 4 / 3;

  /// 1:1 aspect ratio (square)
  static const double ratio1_1 = 1;

  /// 21:9 aspect ratio (ultrawide)
  static const double ratio21_9 = 21 / 9;

  /// 3:2 aspect ratio (classic film)
  static const double ratio3_2 = 3 / 2;

  /// 2:3 aspect ratio (portrait)
  static const double ratio2_3 = 2 / 3;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<GrafitTheme>()!;
    final colors = theme.colors;

    return AspectRatio(
      aspectRatio: ratio,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(colors.radius * 4),
        child: Align(
          alignment: alignment,
          child: child,
        ),
      ),
    );
  }
}
