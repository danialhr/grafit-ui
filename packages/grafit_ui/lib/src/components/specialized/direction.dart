import 'package:flutter/material.dart';
import '../../theme/theme.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

/// Direction values for text layout
enum GrafitTextDirection {
  /// Left-to-right text direction (default for English and many languages)
  ltr,

  /// Right-to-left text direction (for Arabic, Hebrew, etc.)
  rtl,
}

/// Extension to convert GrafitTextDirection to Flutter's TextDirection
extension GrafitTextDirectionX on GrafitTextDirection {
  TextDirection get toFlutter {
    switch (this) {
      case GrafitTextDirection.ltr:
        return TextDirection.ltr;
      case GrafitTextDirection.rtl:
        return TextDirection.rtl;
    }
  }

  /// Get the opposite direction
  GrafitTextDirection get flip {
    switch (this) {
      case GrafitTextDirection.ltr:
        return GrafitTextDirection.rtl;
      case GrafitTextDirection.rtl:
        return GrafitTextDirection.ltr;
    }
  }
}

/// Extension to convert Flutter's TextDirection to GrafitTextDirection
extension TextDirectionX on TextDirection {
  GrafitTextDirection get toGrafit {
    switch (this) {
      case TextDirection.ltr:
        return GrafitTextDirection.ltr;
      case TextDirection.rtl:
        return GrafitTextDirection.rtl;
    }
  }
}

/// Inherited widget that provides text direction to its descendants
///
/// This is the Flutter equivalent of Radix UI's DirectionProvider.
/// It wraps Flutter's Directionality widget and provides additional
/// utilities for direction-aware components.
class GrafitDirection extends InheritedTheme {
  /// The text direction for this subtree
  final GrafitTextDirection direction;

  /// Creates a direction provider for the widget subtree
  const GrafitDirection({
    super.key,
    required this.direction,
    required Widget child,
  }) : super(child: child);

  /// Creates a GrafitDirection from a Flutter TextDirection
  factory GrafitDirection.fromTextDirection({
    Key? key,
    required TextDirection textDirection,
    required Widget child,
  }) {
    return GrafitDirection(
      key: key,
      direction: textDirection.toGrafit,
      child: child,
    );
  }

  /// Creates a LTR (left-to-right) direction
  factory GrafitDirection.ltr({
    Key? key,
    required Widget child,
  }) {
    return GrafitDirection(
      key: key,
      direction: GrafitTextDirection.ltr,
      child: child,
    );
  }

  /// Creates a RTL (right-to-left) direction
  factory GrafitDirection.rtl({
    Key? key,
    required Widget child,
  }) {
    return GrafitDirection(
      key: key,
      direction: GrafitTextDirection.rtl,
      child: child,
    );
  }

  /// Get the direction from the closest GrafitDirection ancestor
  ///
  /// Throws if no GrafitDirection ancestor is found.
  static GrafitTextDirection of(BuildContext context) {
    final GrafitDirection? result =
        context.dependOnInheritedWidgetOfExactType<GrafitDirection>();
    if (result == null) {
      // Fall back to Flutter's Directionality
      return Directionality.of(context).toGrafit;
    }
    return result.direction;
  }

  /// Get the direction from the closest GrafitDirection ancestor
  ///
  /// Returns null if no GrafitDirection ancestor is found.
  static GrafitTextDirection? maybeOf(BuildContext context) {
    final GrafitDirection? result =
        context.dependOnInheritedWidgetOfExactType<GrafitDirection>();
    return result?.direction;
  }

  /// Get the Flutter TextDirection from the closest ancestor
  static TextDirection textDirectionOf(BuildContext context) {
    return GrafitDirection.of(context).toFlutter;
  }

  @override
  bool updateShouldNotify(GrafitDirection oldWidget) {
    return direction != oldWidget.direction;
  }

  @override
  Widget wrap(BuildContext context, Widget child) {
    return Directionality(
      textDirection: direction.toFlutter,
      child: child,
    );
  }
}

/// Hook-style extension to get direction from context
extension GrafitDirectionExtension on BuildContext {
  /// Get the current text direction
  GrafitTextDirection get textDirection => GrafitDirection.of(this);

  /// Get the Flutter TextDirection
  TextDirection get flutterTextDirection => GrafitDirection.textDirectionOf(this);

  /// Check if the current direction is RTL
  bool get isRtl => GrafitDirection.of(this) == GrafitTextDirection.rtl;

  /// Check if the current direction is LTR
  bool get isLtr => GrafitDirection.of(this) == GrafitTextDirection.ltr;

  /// Get the flipped direction (opposite of current)
  GrafitTextDirection get flippedDirection => GrafitDirection.of(this).flip;
}

/// Direction-aware builder widget
///
/// Builds different widgets based on the current text direction.
class GrafitDirectionBuilder extends StatelessWidget {
  final Widget Function(BuildContext context) ltr;
  final Widget Function(BuildContext context)? rtl;
  final Widget Function(BuildContext context, GrafitTextDirection direction)?
      builder;

  const GrafitDirectionBuilder({
    super.key,
    required this.ltr,
    this.rtl,
    this.builder,
  }) : assert(
          rtl != null || builder != null,
          'Either rtl or builder must be provided',
        );

  @override
  Widget build(BuildContext context) {
    final direction = GrafitDirection.of(context);

    if (builder != null) {
      return builder!(context, direction);
    }

    return direction == GrafitTextDirection.rtl && rtl != null
        ? rtl!(context)
        : ltr(context);
  }
}

/// Direction-aware padding
///
/// Automatically flips horizontal padding in RTL mode.
class GrafitDirectionalPadding extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;

  const GrafitDirectionalPadding({
    super.key,
    required this.child,
    required this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final direction = GrafitDirection.of(context);

    if (direction == GrafitTextDirection.rtl &&
        padding is EdgeInsetsDirectional) {
      // Flip start/end for RTL
      final directional = padding as EdgeInsetsDirectional;
      return Padding(
        padding: EdgeInsetsDirectional.only(
          start: directional.end,
          end: directional.start,
          top: directional.top,
          bottom: directional.bottom,
        ),
        child: child,
      );
    }

    return Padding(padding: padding, child: child);
  }
}

/// Direction-aware margin
///
/// Automatically flips horizontal margins in RTL mode.
class GrafitDirectionalMargin extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry margin;

  const GrafitDirectionalMargin({
    super.key,
    required this.child,
    required this.margin,
  });

  @override
  Widget build(BuildContext context) {
    final direction = GrafitDirection.of(context);

    if (direction == GrafitTextDirection.rtl &&
        margin is EdgeInsetsDirectional) {
      // Flip start/end for RTL
      final directional = margin as EdgeInsetsDirectional;
      return Container(
        margin: EdgeInsetsDirectional.only(
          start: directional.end,
          end: directional.start,
          top: directional.top,
          bottom: directional.bottom,
        ),
        child: child,
      );
    }

    return Container(margin: margin, child: child);
  }
}

/// Direction-aware alignment
///
/// Automatically flips alignment in RTL mode.
class GrafitDirectionalAlignment extends StatelessWidget {
  final Widget child;
  final AlignmentGeometry alignment;

  const GrafitDirectionalAlignment({
    super.key,
    required this.child,
    required this.alignment,
  });

  @override
  Widget build(BuildContext context) {
    return Align(alignment: alignment, child: child);
  }
}

/// Theme extension for default direction
///
/// Integrates with GrafitTheme to provide a default direction
/// for the entire application.
class GrafitDirectionTheme extends ThemeExtension<GrafitDirectionTheme> {
  /// The default text direction
  final GrafitTextDirection defaultDirection;

  const GrafitDirectionTheme({
    this.defaultDirection = GrafitTextDirection.ltr,
  });

  /// Light theme factory
  static const GrafitDirectionTheme light = GrafitDirectionTheme(
    defaultDirection: GrafitTextDirection.ltr,
  );

  /// Dark theme factory
  static const GrafitDirectionTheme dark = GrafitDirectionTheme(
    defaultDirection: GrafitTextDirection.ltr,
  );

  /// RTL theme factory
  static const GrafitDirectionTheme rtl = GrafitDirectionTheme(
    defaultDirection: GrafitTextDirection.rtl,
  );

  @override
  GrafitDirectionTheme copyWith({GrafitTextDirection? defaultDirection}) {
    return GrafitDirectionTheme(
      defaultDirection: defaultDirection ?? this.defaultDirection,
    );
  }

  @override
  GrafitDirectionTheme lerp(
      covariant ThemeExtension<GrafitDirectionTheme> other, double t) {
    if (other is! GrafitDirectionTheme) {
      return this;
    }
    // Direction doesn't lerp, just switch at 0.5
    return GrafitDirectionTheme(
      defaultDirection: t < 0.5 ? defaultDirection : other.defaultDirection,
    );
  }
}

/// Extension to get direction theme from context
extension GrafitDirectionThemeExtension on BuildContext {
  /// Get the default direction from theme
  GrafitTextDirection get defaultDirection {
    final theme =
        Theme.of(this).extension<GrafitDirectionTheme>()?.defaultDirection;
    return theme ?? GrafitTextDirection.ltr;
  }

  /// Get the effective direction (theme or inherited)
  GrafitTextDirection get effectiveDirection {
    return GrafitDirection.maybeOf(this) ?? defaultDirection;
  }
}

/// Direction-aware icon widget
///
/// Automatically mirrors icons in RTL mode if specified.
class GrafitDirectionalIcon extends StatelessWidget {
  final IconData icon;
  final double size;
  final Color? color;
  final bool mirrorInRtl;

  const GrafitDirectionalIcon({
    super.key,
    required this.icon,
    this.size = 24.0,
    this.color,
    this.mirrorInRtl = true,
  });

  @override
  Widget build(BuildContext context) {
    final isRtl = context.isRtl;

    if (isRtl && mirrorInRtl) {
      return Transform(
        transform: Matrix4.rotationY(3.14159), // 180 degrees around Y axis
        alignment: Alignment.center,
        child: Icon(
          icon,
          size: size,
          color: color,
        ),
      );
    }

    return Icon(
      icon,
      size: size,
      color: color,
    );
  }
}

// Widgetbook use cases
@widgetbook.UseCase(
  name: 'LTR Direction',
  type: GrafitDirection,
  path: 'Specialized/Direction',
)
Widget directionLTR(BuildContext context) {
  return GrafitDirection.ltr(
    child: Container(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Left-to-Right (LTR)',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Icon(Icons.arrow_back),
              const SizedBox(width: 8),
              const Text('Back'),
              const SizedBox(width: 32),
              const Text('Content'),
              const SizedBox(width: 32),
              const Icon(Icons.arrow_forward),
              const SizedBox(width: 8),
              const Text('Next'),
            ],
          ),
        ],
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'RTL Direction',
  type: GrafitDirection,
  path: 'Specialized/Direction',
)
Widget directionRTL(BuildContext context) {
  return GrafitDirection.rtl(
    child: Container(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Right-to-Left (RTL)',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Icon(Icons.arrow_back),
              const SizedBox(width: 8),
              const Text('Back'),
              const SizedBox(width: 32),
              const Text('محتوى'), // Content in Arabic
              const SizedBox(width: 32),
              const Icon(Icons.arrow_forward),
              const SizedBox(width: 8),
              const Text('Next'),
            ],
          ),
        ],
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'Direction Builder',
  type: GrafitDirectionBuilder,
  path: 'Specialized/Direction',
)
Widget directionBuilder(BuildContext context) {
  return GrafitDirection.ltr(
    child: Column(
      children: [
        const GrafitDirection(
          direction: GrafitTextDirection.ltr,
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('LTR Layout: Text flows from left to right'),
          ),
        ),
        const SizedBox(height: 16),
        const GrafitDirection(
          direction: GrafitTextDirection.rtl,
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('RTL Layout: النص يتدفق من اليمين إلى اليسار'),
          ),
        ),
      ],
    ),
  );
}

@widgetbook.UseCase(
  name: 'Directional Padding',
  type: GrafitDirectionalPadding,
  path: 'Specialized/Direction',
)
Widget directionPadding(BuildContext context) {
  return Row(
    children: [
      Expanded(
        child: GrafitDirection.ltr(
          child: const GrafitDirectionalPadding(
            padding: EdgeInsetsDirectional.only(start: 24),
            child: Text('LTR: Padding on the left'),
          ),
        ),
      ),
      const SizedBox(width: 32),
      Expanded(
        child: GrafitDirection.rtl(
          child: const GrafitDirectionalPadding(
            padding: EdgeInsetsDirectional.only(start: 24),
            child: Text('RTL: الحشو على اليمين'),
          ),
        ),
      ),
    ],
  );
}

@widgetbook.UseCase(
  name: 'Directional Icon',
  type: GrafitDirectionalIcon,
  path: 'Specialized/Direction',
)
Widget directionIcon(BuildContext context) {
  return Column(
    children: [
      GrafitDirection.ltr(
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('LTR: '),
            GrafitDirectionalIcon(icon: Icons.arrow_forward),
          ],
        ),
      ),
      const SizedBox(height: 32),
      GrafitDirection.rtl(
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('RTL: '),
            GrafitDirectionalIcon(icon: Icons.arrow_forward),
          ],
        ),
      ),
    ],
  );
}

@widgetbook.UseCase(
  name: 'Mixed Content',
  type: GrafitDirection,
  path: 'Specialized/Direction',
)
Widget directionMixed(BuildContext context) {
  return GrafitDirection.ltr(
    child: Container(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          const Text(
            'Mixed Direction Content',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          const GrafitDirection(
            direction: GrafitTextDirection.ltr,
            child: Card(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Icon(Icons.arrow_back),
                    Text('English content goes here'),
                    Icon(Icons.arrow_forward),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          const GrafitDirection(
            direction: GrafitTextDirection.rtl,
            child: Card(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Icon(Icons.arrow_back),
                    Text('المحتوى العربي هنا'),
                    Icon(Icons.arrow_forward),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'Interactive',
  type: GrafitDirection,
  path: 'Specialized/Direction',
)
Widget directionInteractive(BuildContext context) {
  // Widgetbook-only: ignore undefined_getter, undefined_method, invalid_annotation_value
  final direction = context.knobs.list(
    label: 'Text Direction',
    options: GrafitTextDirection.values,
    initialOption: GrafitTextDirection.ltr,
  );

  // Widgetbook-only: ignore undefined_getter, undefined_method, invalid_annotation_value
  final mirrorIcon = context.knobs.boolean(
    label: 'Mirror Icon in RTL',
    initialValue: true,
  );

  return GrafitDirection(
    direction: direction,
    child: Container(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Direction: ${direction.name.toUpperCase()}',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              GrafitDirectionalIcon(
                icon: Icons.arrow_back,
                mirrorInRtl: mirrorIcon,
              ),
              const SizedBox(width: 8),
              const Text('Back'),
              const SizedBox(width: 32),
              Expanded(
                child: Text(
                  direction == GrafitTextDirection.rtl
                      ? 'محتوى تفاعلي'
                      : 'Interactive Content',
                ),
              ),
              const SizedBox(width: 32),
              const Text('Next'),
              const SizedBox(width: 8),
              GrafitDirectionalIcon(
                icon: Icons.arrow_forward,
                mirrorInRtl: mirrorIcon,
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
