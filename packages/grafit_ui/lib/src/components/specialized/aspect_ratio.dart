import 'package:flutter/material.dart';
import '../../theme/theme.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

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

// Widgetbook use cases
@widgetbook.UseCase(
  name: 'Square (1:1)',
  type: GrafitAspectRatio,
  path: 'Specialized/AspectRatio',
)
Widget aspectRatioSquare(BuildContext context) {
  return const SizedBox(
    width: 200,
    child: GrafitAspectRatio(
      ratio: GrafitAspectRatio.ratio1_1,
      child: _AspectRatioContainer(
        label: '1:1',
        color: Colors.blue,
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: '16:9 Widescreen',
  type: GrafitAspectRatio,
  path: 'Specialized/AspectRatio',
)
Widget aspectRatio169(BuildContext context) {
  return const SizedBox(
    width: 320,
    child: GrafitAspectRatio(
      ratio: GrafitAspectRatio.ratio16_9,
      child: _AspectRatioContainer(
        label: '16:9',
        color: Colors.green,
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: '4:3 Standard',
  type: GrafitAspectRatio,
  path: 'Specialized/AspectRatio',
)
Widget aspectRatio43(BuildContext context) {
  return const SizedBox(
    width: 320,
    child: GrafitAspectRatio(
      ratio: GrafitAspectRatio.ratio4_3,
      child: _AspectRatioContainer(
        label: '4:3',
        color: Colors.orange,
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: '21:9 Ultrawide',
  type: GrafitAspectRatio,
  path: 'Specialized/AspectRatio',
)
Widget aspectRatio219(BuildContext context) {
  return const SizedBox(
    width: 420,
    child: GrafitAspectRatio(
      ratio: GrafitAspectRatio.ratio21_9,
      child: _AspectRatioContainer(
        label: '21:9',
        color: Colors.purple,
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'Portrait (2:3)',
  type: GrafitAspectRatio,
  path: 'Specialized/AspectRatio',
)
Widget aspectRatioPortrait(BuildContext context) {
  return const SizedBox(
    width: 150,
    child: GrafitAspectRatio(
      ratio: GrafitAspectRatio.ratio2_3,
      child: _AspectRatioContainer(
        label: '2:3\nPortrait',
        color: Colors.red,
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'Comparison',
  type: GrafitAspectRatio,
  path: 'Specialized/AspectRatio',
)
Widget aspectRatioComparison(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.all(24.0),
    child: Wrap(
      spacing: 16,
      runSpacing: 16,
      children: [
        SizedBox(
          width: 150,
          child: GrafitAspectRatio(
            ratio: GrafitAspectRatio.ratio1_1,
            child: _AspectRatioContainer(label: '1:1', color: Colors.blue),
          ),
        ),
        SizedBox(
          width: 200,
          child: GrafitAspectRatio(
            ratio: GrafitAspectRatio.ratio16_9,
            child: _AspectRatioContainer(label: '16:9', color: Colors.green),
          ),
        ),
        SizedBox(
          width: 200,
          child: GrafitAspectRatio(
            ratio: GrafitAspectRatio.ratio4_3,
            child: _AspectRatioContainer(label: '4:3', color: Colors.orange),
          ),
        ),
        SizedBox(
          width: 200,
          child: GrafitAspectRatio(
            ratio: GrafitAspectRatio.ratio3_2,
            child: _AspectRatioContainer(label: '3:2', color: Colors.purple),
          ),
        ),
      ],
    ),
  );
}

@widgetbook.UseCase(
  name: 'Interactive',
  type: GrafitAspectRatio,
  path: 'Specialized/AspectRatio',
)
Widget aspectRatioInteractive(BuildContext context) {
  final ratio = context.knobs.double.slider(
    label: 'Aspect Ratio',
    initialValue: 1.0,
    min: 0.3,
    max: 3.0,
  );

  final alignment = context.knobs.list(
    label: 'Alignment',
    options: [
      Alignment.center,
      Alignment.topLeft,
      Alignment.topCenter,
      Alignment.topRight,
      Alignment.bottomLeft,
      Alignment.bottomCenter,
      Alignment.bottomRight,
    ],
    initialOption: Alignment.center,
  );

  return SizedBox(
    width: 300,
    child: GrafitAspectRatio(
      ratio: ratio,
      alignment: alignment,
      child: _AspectRatioContainer(
        label: 'Ratio: ${ratio.toStringAsFixed(2)}',
        color: Colors.teal,
      ),
    ),
  );
}

// Helper widget for displaying aspect ratio containers
class _AspectRatioContainer extends StatelessWidget {
  final String label;
  final Color color;

  const _AspectRatioContainer({
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color.withOpacity(0.3),
      child: Center(
        child: Text(
          label,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
