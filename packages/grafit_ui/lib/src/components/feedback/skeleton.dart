import 'package:flutter/material.dart';
import '../../theme/theme.dart';

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
