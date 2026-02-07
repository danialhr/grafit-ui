import 'package:flutter/material.dart';
import '../../theme/theme.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

/// Skeleton component
class GrafitSkeleton extends StatefulWidget {
  final double? width;
  final double? height;
  final double? borderRadius;
  final Color? baseColor;
  final Color? highlightColor;

  const GrafitSkeleton({
    super.key,
    this.width,
    this.height,
    this.borderRadius,
    this.baseColor,
    this.highlightColor,
  });

  @override
  State<GrafitSkeleton> createState() => _GrafitSkeletonState();
}

class _GrafitSkeletonState extends State<GrafitSkeleton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0.3, end: 0.7).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<GrafitTheme>()!;
    final colors = theme.colors;

    final defaultHeight = widget.height ?? 20.0;
    final defaultRadius = widget.borderRadius ?? colors.radius * 4;
    final base = widget.baseColor ?? colors.muted;
    final highlight = widget.highlightColor ?? colors.mutedForeground.withOpacity(0.1);

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: defaultHeight,
          decoration: BoxDecoration(
            color: Color.lerp(
              base,
              highlight,
              _animation.value,
            )!,
            borderRadius: BorderRadius.circular(defaultRadius),
          ),
        );
      },
    );
  }
}

/// Skeleton text line (simulates text)
class GrafitSkeletonText extends StatelessWidget {
  final double? width;
  final String? sampleText;

  const GrafitSkeleton({
    super.key,
    this.width,
    this.sampleText,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<GrafitTheme>()!;
    final colors = theme.colors;

    final textStyle = TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
    );

    // Calculate approximate width from sample text or use default
    final textPainter = TextPainter(
      text: TextSpan(text: sampleText ?? 'Sample Text', style: textStyle),
      textDirection: TextDirection.ltr,
    )..layout();

    final calculatedWidth = width ?? textPainter.width;

    return GrafitSkeleton(
      width: calculatedWidth,
      height: textStyle.fontSize! * 1.2,
      borderRadius: colors.radius * 2,
    );
  }
}

/// Skeleton avatar circle
class GrafitSkeletonAvatar extends StatelessWidget {
  final double size;

  const GrafitSkeleton({
    super.key,
    this.size = 40,
  });

  @override
  Widget build(BuildContext context) {
    return GrafitSkeleton(
      width: size,
      height: size,
      borderRadius: size / 2,
    );
  }
}

/// Skeleton card (rectangular block)
class GrafitSkeletonCard extends StatelessWidget {
  final double? width;
  final double? height;
  final int? lines;

  const GrafitSkeletonCard({
    super.key,
    this.width,
    this.height,
    this.lines,
  });

  @override
  Widget build(BuildContext context) {
    final defaultHeight = height ?? 120.0;

    if (lines != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          GrafitSkeletonAvatar(size: 32),
          const SizedBox(height: 12),
          GrafitSkeleton(width: double.infinity * 0.7),
          const SizedBox(height: 8),
          ...List.generate(
            lines!,
            (index) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: GrafitSkeleton(
                width: index == lines! - 1
                    ? double.infinity * 0.5
                    : double.infinity,
              ),
            ),
          ),
        ],
      );
    }

    return GrafitSkeleton(
      width: width,
      height: defaultHeight,
    );
  }
}

// Widgetbook use cases
@widgetbook.UseCase(
  name: 'Default',
  type: GrafitSkeleton,
  path: 'Feedback/Skeleton',
)
Widget skeletonDefault(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.all(16.0),
    child: GrafitSkeleton(
      width: 200,
      height: 20,
    ),
  );
}

@widgetbook.UseCase(
  name: 'Avatar',
  type: GrafitSkeletonAvatar,
  path: 'Feedback/Skeleton',
)
Widget skeletonAvatar(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.all(16.0),
    child: Row(
      children: [
        GrafitSkeletonAvatar(size: 32),
        SizedBox(width: 8),
        GrafitSkeletonAvatar(size: 40),
        SizedBox(width: 8),
        GrafitSkeletonAvatar(size: 48),
        SizedBox(width: 8),
        GrafitSkeletonAvatar(size: 64),
      ],
    ),
  );
}

@widgetbook.UseCase(
  name: 'Text Lines',
  type: GrafitSkeletonText,
  path: 'Feedback/Skeleton',
)
Widget skeletonTextLines(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.all(16.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GrafitSkeletonText(width: 200),
        SizedBox(height: 8),
        GrafitSkeletonText(width: 180),
        SizedBox(height: 8),
        GrafitSkeletonText(width: 150),
      ],
    ),
  );
}

@widgetbook.UseCase(
  name: 'Card',
  type: GrafitSkeletonCard,
  path: 'Feedback/Skeleton',
)
Widget skeletonCard(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.all(16.0),
    child: SizedBox(
      width: 300,
      child: GrafitSkeletonCard(
        width: 300,
        height: 120,
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'Card with Lines',
  type: GrafitSkeletonCard,
  path: 'Feedback/Skeleton',
)
Widget skeletonCardWithLines(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.all(16.0),
    child: SizedBox(
      width: 300,
      child: GrafitSkeletonCard(
        width: 300,
        lines: 3,
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'List Item',
  type: GrafitSkeleton,
  path: 'Feedback/Skeleton',
)
Widget skeletonListItem(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: Column(
      children: List.generate(
        5,
        (index) => const Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            children: [
              GrafitSkeletonAvatar(size: 40),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GrafitSkeletonText(width: double.infinity),
                    SizedBox(height: 8),
                    GrafitSkeletonText(width: 200),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'Profile Card',
  type: GrafitSkeleton,
  path: 'Feedback/Skeleton',
)
Widget skeletonProfileCard(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.all(16.0),
    child: Column(
      children: [
        GrafitSkeletonAvatar(size: 80),
        SizedBox(height: 16),
        GrafitSkeleton(width: 200, height: 24),
        SizedBox(height: 8),
        GrafitSkeleton(width: 150, height: 16),
        SizedBox(height: 16),
        GrafitSkeleton(width: double.infinity, height: 60),
      ],
    ),
  );
}

@widgetbook.UseCase(
  name: 'Multiple Sizes',
  type: GrafitSkeleton,
  path: 'Feedback/Skeleton',
)
Widget skeletonMultipleSizes(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.all(16.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GrafitSkeleton(width: 100, height: 8),
        SizedBox(height: 8),
        GrafitSkeleton(width: 150, height: 12),
        SizedBox(height: 8),
        GrafitSkeleton(width: 200, height: 16),
        SizedBox(height: 8),
        GrafitSkeleton(width: 250, height: 20),
        SizedBox(height: 8),
        GrafitSkeleton(width: 300, height: 24),
      ],
    ),
  );
}

@widgetbook.UseCase(
  name: 'Interactive',
  type: GrafitSkeleton,
  path: 'Feedback/Skeleton',
)
Widget skeletonInteractive(BuildContext context) {
  // Widgetbook-only: ignore undefined_getter, undefined_method, invalid_annotation_value
  final width = context.knobs.double.slider(
    label: 'Width',
    initialValue: 200,
    min: 50,
    max: 400,
  );
  // Widgetbook-only: ignore undefined_getter, undefined_method, invalid_annotation_value
  final height = context.knobs.double.slider(
    label: 'Height',
    initialValue: 20,
    min: 8,
    max: 100,
  );
  // Widgetbook-only: ignore undefined_getter, undefined_method, invalid_annotation_value
  final borderRadius = context.knobs.double.slider(
    label: 'Border Radius',
    initialValue: 4,
    min: 0,
    max: 50,
  );

  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: GrafitSkeleton(
      width: width,
      height: height,
      borderRadius: borderRadius,
    ),
  );
}
