import 'package:flutter/material.dart';
import '../../theme/theme.dart';

/// Progress component
class GrafitProgress extends StatelessWidget {
  final double value;
  final double? height;
  final Color? backgroundColor;
  final Color? progressColor;

  const GrafitProgress({
    super.key,
    required this.value,
    this.height,
    this.backgroundColor,
    this.progressColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<GrafitTheme>()!;
    final colors = theme.colors;

    final progressHeight = height ?? 8.0;
    final bg = backgroundColor ?? colors.primary.withOpacity(0.2);
    final progress = progressColor ?? colors.primary;

    return Container(
      width: double.infinity,
      height: progressHeight,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(progressHeight / 2),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(progressHeight / 2),
        child: Stack(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              width: double.infinity,
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: value.clamp(0.0, 1.0),
                child: Container(
                  color: progress,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Indeterminate progress indicator
class GrafitProgressIndeterminate extends StatefulWidget {
  final double? height;
  final Color? backgroundColor;
  final Color? progressColor;

  const GrafitProgressIndeterminate({
    super.key,
    this.height,
    this.backgroundColor,
    this.progressColor,
  });

  @override
  State<GrafitProgressIndeterminate> createState() =>
      _GrafitProgressIndeterminateState();
}

class _GrafitProgressIndeterminateState
    extends State<GrafitProgressIndeterminate>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();

    _animation = Tween<double>(begin: -1.0, end: 1.0).animate(
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

    final progressHeight = widget.height ?? 8.0;
    final bg = widget.backgroundColor ?? colors.primary.withOpacity(0.2);
    final progress = widget.progressColor ?? colors.primary;

    return Container(
      width: double.infinity,
      height: progressHeight,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(progressHeight / 2),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(progressHeight / 2),
        child: AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: 0.3,
              child: Transform.translate(
                offset: Offset(_animation.value * 3, 0),
                child: Container(
                  color: progress,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
