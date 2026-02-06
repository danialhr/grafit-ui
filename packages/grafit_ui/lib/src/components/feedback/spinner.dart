import 'package:flutter/material.dart';
import '../../theme/theme.dart';

/// Spinner size variants
enum GrafitSpinnerSize {
  xs,
  sm,
  md,
  lg,
  xl,
}

/// Spinner component - A rotating circle loading indicator
///
/// Based on shadcn-ui/ui Spinner component:
/// https://github.com/shadcn-ui/ui/tree/main/apps/v4/registry/new-york-v4/ui/spinner.tsx
///
/// Features:
/// - Animated rotating circle using AnimationController
/// - Multiple size variants (xs, sm, md, lg, xl)
/// - Custom color support via GrafitTheme
/// - Configurable stroke width
/// - Optional label/text support
/// - Speed control (animation duration)
class GrafitSpinner extends StatefulWidget {
  /// Size of the spinner
  final GrafitSpinnerSize size;

  /// Custom color for the spinner (overrides theme)
  final Color? color;

  /// Stroke width of the spinner circle
  final double? strokeWidth;

  /// Optional label to display below the spinner
  final String? label;

  /// Animation duration in milliseconds
  final int? durationMs;

  /// Custom size in pixels (overrides size variant)
  final double? customSize;

  const GrafitSpinner({
    super.key,
    this.size = GrafitSpinnerSize.md,
    this.color,
    this.strokeWidth,
    this.label,
    this.durationMs,
    this.customSize,
  });

  @override
  State<GrafitSpinner> createState() => _GrafitSpinnerState();
}

class _GrafitSpinnerState extends State<GrafitSpinner>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: widget.durationMs ?? 1000),
    )..repeat();
  }

  @override
  void didUpdateWidget(GrafitSpinner oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.durationMs != oldWidget.durationMs) {
      _controller.duration = Duration(
        milliseconds: widget.durationMs ?? 1000,
      );
    }
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

    final spinnerColor = widget.color ?? colors.primary;
    final size = widget.customSize ?? _getSizeValue();
    final strokeWidth = widget.strokeWidth ?? size / 8;

    final spinner = SizedBox(
      width: size,
      height: size,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.rotate(
            angle: _controller.value * 2 * 3.14159265359,
            child: CustomPaint(
              painter: _SpinnerPainter(
                color: spinnerColor,
                strokeWidth: strokeWidth,
              ),
              size: Size(size, size),
            ),
          );
        },
      ),
    );

    if (widget.label != null) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          spinner,
          const SizedBox(height: 8),
          Text(
            widget.label!,
            style: TextStyle(
              color: colors.mutedForeground,
              fontSize: 12,
            ),
          ),
        ],
      );
    }

    return spinner;
  }

  double _getSizeValue() {
    return switch (widget.size) {
      GrafitSpinnerSize.xs => 12.0,
      GrafitSpinnerSize.sm => 16.0,
      GrafitSpinnerSize.md => 24.0,
      GrafitSpinnerSize.lg => 32.0,
      GrafitSpinnerSize.xl => 48.0,
    };
  }
}

/// Custom painter for drawing the spinner arc
class _SpinnerPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;

  const _SpinnerPainter({
    required this.color,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    final rect = Rect.fromCircle(center: center, radius: radius);

    // Background track (optional, subtle)
    final trackPaint = Paint()
      ..color = color.withValues(alpha: 0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, trackPaint);

    // Rotating arc
    final arcPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    const startAngle = -0.5 * 3.14159265359; // Start from top
    const sweepAngle = 1.5 * 3.14159265359; // 3/4 circle

    canvas.drawArc(rect, startAngle, sweepAngle, false, arcPaint);
  }

  @override
  bool shouldRepaint(covariant _SpinnerPainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.strokeWidth != strokeWidth;
  }
}

/// Inline spinner for use in buttons and inline contexts
///
/// This is a smaller variant designed to be used inline with text,
/// such as in button loading states.
class GrafitSpinnerInline extends StatelessWidget {
  /// Color of the spinner
  final Color? color;

  /// Size of the spinner (default: sm)
  final GrafitSpinnerSize size;

  const GrafitSpinnerInline({
    super.key,
    this.color,
    this.size = GrafitSpinnerSize.sm,
  });

  @override
  Widget build(BuildContext context) {
    return GrafitSpinner(
      size: size,
      color: color,
    );
  }
}

/// Spinner with label - A convenience widget for labeled loading states
class GrafitSpinnerLabeled extends StatelessWidget {
  /// Text label to display with the spinner
  final String label;

  /// Position of the label relative to the spinner
  final GrafitSpinnerLabelPosition labelPosition;

  /// Size of the spinner
  final GrafitSpinnerSize size;

  /// Color of the spinner
  final Color? color;

  /// Animation duration in milliseconds
  final int? durationMs;

  const GrafitSpinnerLabeled({
    super.key,
    required this.label,
    this.labelPosition = GrafitSpinnerLabelPosition.bottom,
    this.size = GrafitSpinnerSize.md,
    this.color,
    this.durationMs,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<GrafitTheme>()!;
    final colors = theme.colors;

    final spinner = GrafitSpinner(
      size: size,
      color: color,
      durationMs: durationMs,
    );

    final labelWidget = Text(
      label,
      style: TextStyle(
        color: colors.mutedForeground,
        fontSize: 14,
      ),
    );

    return switch (labelPosition) {
      GrafitSpinnerLabelPosition.bottom => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            spinner,
            const SizedBox(height: 8),
            labelWidget,
          ],
        ),
      GrafitSpinnerLabelPosition.top => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            labelWidget,
            const SizedBox(height: 8),
            spinner,
          ],
        ),
      GrafitSpinnerLabelPosition.left => Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            spinner,
            const SizedBox(width: 8),
            labelWidget,
          ],
        ),
      GrafitSpinnerLabelPosition.right => Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            labelWidget,
            const SizedBox(width: 8),
            spinner,
          ],
        ),
    };
  }
}

/// Label position for labeled spinner
enum GrafitSpinnerLabelPosition {
  bottom,
  top,
  left,
  right,
}

/// Dots spinner - Alternative loading animation with bouncing dots
///
/// Provides a different loading animation style from the rotating spinner,
/// useful for variety in loading states.
class GrafitSpinnerDots extends StatefulWidget {
  /// Number of dots (default: 3)
  final int dotCount;

  /// Size of each dot
  final double? dotSize;

  /// Color of the dots
  final Color? color;

  /// Spacing between dots
  final double? spacing;

  const GrafitSpinnerDots({
    super.key,
    this.dotCount = 3,
    this.dotSize,
    this.color,
    this.spacing,
  });

  @override
  State<GrafitSpinnerDots> createState() => _GrafitSpinnerDotsState();
}

class _GrafitSpinnerDotsState extends State<GrafitSpinnerDots>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
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

    final dotColor = widget.color ?? colors.primary;
    final dotSize = widget.dotSize ?? 8.0;
    final spacing = widget.spacing ?? 4.0;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(widget.dotCount, (index) {
        return AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            // Calculate animation value for this dot
            final delay = index * 0.2;
            final animationValue = (_controller.value - delay).clamp(0.0, 1.0);
            final scale = 0.5 + 0.5 * (1 - (animationValue - 0.5).abs() * 2).clamp(0.0, 1.0);

            return Transform.scale(
              scale: scale,
              child: Container(
                width: dotSize,
                height: dotSize,
                margin: EdgeInsets.symmetric(horizontal: spacing / 2),
                decoration: BoxDecoration(
                  color: dotColor,
                  shape: BoxShape.circle,
                ),
              ),
            );
          },
        );
      }),
    );
  }
}

/// Pulse spinner - Alternative loading animation with pulsing effect
///
/// Provides a pulsing circle animation, useful for variety in loading states.
class GrafitSpinnerPulse extends StatefulWidget {
  /// Size of the pulse
  final double? size;

  /// Color of the pulse
  final Color? color;

  const GrafitSpinnerPulse({
    super.key,
    this.size,
    this.color,
  });

  @override
  State<GrafitSpinnerPulse> createState() => _GrafitSpinnerPulseState();
}

class _GrafitSpinnerPulseState extends State<GrafitSpinnerPulse>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.5).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _opacityAnimation = Tween<double>(begin: 0.8, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
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

    final pulseColor = widget.color ?? colors.primary;
    final size = widget.size ?? 24.0;

    return SizedBox(
      width: size,
      height: size,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Stack(
            alignment: Alignment.center,
            children: [
              // Pulsing outer circle
              Transform.scale(
                scale: _scaleAnimation.value,
                child: Opacity(
                  opacity: _opacityAnimation.value,
                  child: Container(
                    width: size,
                    height: size,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: pulseColor,
                    ),
                  ),
                ),
              ),
              // Center circle
              Container(
                width: size * 0.6,
                height: size * 0.6,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: pulseColor,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
