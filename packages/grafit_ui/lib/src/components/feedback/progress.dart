import 'package:flutter/material.dart';
import '../../theme/theme.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

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

// Widgetbook use cases
@widgetbook.UseCase(
  name: 'Default',
  type: GrafitProgress,
  path: 'Feedback/Progress',
)
Widget progressDefault(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.all(16.0),
    child: SizedBox(
      width: 300,
      child: GrafitProgress(value: 0.5),
    ),
  );
}

@widgetbook.UseCase(
  name: 'Zero',
  type: GrafitProgress,
  path: 'Feedback/Progress',
)
Widget progressZero(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.all(16.0),
    child: SizedBox(
      width: 300,
      child: GrafitProgress(value: 0.0),
    ),
  );
}

@widgetbook.UseCase(
  name: 'Quarter',
  type: GrafitProgress,
  path: 'Feedback/Progress',
)
Widget progressQuarter(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.all(16.0),
    child: SizedBox(
      width: 300,
      child: GrafitProgress(value: 0.25),
    ),
  );
}

@widgetbook.UseCase(
  name: 'Half',
  type: GrafitProgress,
  path: 'Feedback/Progress',
)
Widget progressHalf(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.all(16.0),
    child: SizedBox(
      width: 300,
      child: GrafitProgress(value: 0.5),
    ),
  );
}

@widgetbook.UseCase(
  name: 'Three Quarters',
  type: GrafitProgress,
  path: 'Feedback/Progress',
)
Widget progressThreeQuarters(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.all(16.0),
    child: SizedBox(
      width: 300,
      child: GrafitProgress(value: 0.75),
    ),
  );
}

@widgetbook.UseCase(
  name: 'Full',
  type: GrafitProgress,
  path: 'Feedback/Progress',
)
Widget progressFull(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.all(16.0),
    child: SizedBox(
      width: 300,
      child: GrafitProgress(value: 1.0),
    ),
  );
}

@widgetbook.UseCase(
  name: 'Indeterminate',
  type: GrafitProgressIndeterminate,
  path: 'Feedback/Progress',
)
Widget progressIndeterminate(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.all(16.0),
    child: SizedBox(
      width: 300,
      child: GrafitProgressIndeterminate(),
    ),
  );
}

@widgetbook.UseCase(
  name: 'Custom Height',
  type: GrafitProgress,
  path: 'Feedback/Progress',
)
Widget progressCustomHeight(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.all(16.0),
    child: Column(
      children: [
        SizedBox(
          width: 300,
          child: GrafitProgress(value: 0.5, height: 4),
        ),
        SizedBox(height: 16),
        SizedBox(
          width: 300,
          child: GrafitProgress(value: 0.5, height: 8),
        ),
        SizedBox(height: 16),
        SizedBox(
          width: 300,
          child: GrafitProgress(value: 0.5, height: 16),
        ),
      ],
    ),
  );
}

@widgetbook.UseCase(
  name: 'Custom Colors',
  type: GrafitProgress,
  path: 'Feedback/Progress',
)
Widget progressCustomColors(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.all(16.0),
    child: Column(
      children: [
        SizedBox(
          width: 300,
          child: GrafitProgress(
            value: 0.5,
            progressColor: Colors.blue,
          ),
        ),
        SizedBox(height: 16),
        SizedBox(
          width: 300,
          child: GrafitProgress(
            value: 0.7,
            progressColor: Colors.green,
          ),
        ),
        SizedBox(height: 16),
        SizedBox(
          width: 300,
          child: GrafitProgress(
            value: 0.3,
            progressColor: Colors.orange,
          ),
        ),
      ],
    ),
  );
}

@widgetbook.UseCase(
  name: 'All States',
  type: GrafitProgress,
  path: 'Feedback/Progress',
)
Widget progressAllStates(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.all(16.0),
    child: SizedBox(
      width: 300,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Loading...', style: TextStyle(fontSize: 14)),
          SizedBox(height: 8),
          GrafitProgressIndeterminate(height: 4),
          SizedBox(height: 24),
          Text('25% Complete', style: TextStyle(fontSize: 14)),
          SizedBox(height: 8),
          GrafitProgress(value: 0.25),
          SizedBox(height: 24),
          Text('50% Complete', style: TextStyle(fontSize: 14)),
          SizedBox(height: 8),
          GrafitProgress(value: 0.5),
          SizedBox(height: 24),
          Text('100% Complete', style: TextStyle(fontSize: 14)),
          SizedBox(height: 8),
          GrafitProgress(value: 1.0),
        ],
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'Interactive',
  type: GrafitProgress,
  path: 'Feedback/Progress',
)
Widget progressInteractive(BuildContext context) {
  // Widgetbook-only: ignore undefined_getter, undefined_method, invalid_annotation_value
  final value = context.knobs.double.slider(
    label: 'Progress Value',
    initialValue: 0.5,
    min: 0.0,
    max: 1.0,
  );
  // Widgetbook-only: ignore undefined_getter, undefined_method, invalid_annotation_value
  final height = context.knobs.double.slider(
    label: 'Height',
    initialValue: 8.0,
    min: 2.0,
    max: 24.0,
  );
  // Widgetbook-only: ignore undefined_getter, undefined_method, invalid_annotation_value
  final isIndeterminate = context.knobs.boolean(
    label: 'Indeterminate',
    initialValue: false,
  );

  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: SizedBox(
      width: 300,
      child: isIndeterminate
          ? GrafitProgressIndeterminate(height: height)
          : GrafitProgress(value: value, height: height),
    ),
  );
}
