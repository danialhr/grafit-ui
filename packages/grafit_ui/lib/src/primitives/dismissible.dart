import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Dismissible primitive with swipe-to-dismiss and dismiss callbacks
class GrafitDismissible extends StatefulWidget {
  final Widget child;
  final VoidCallback? onDismissed;
  final DismissDirectionCallback? onConfirmDismiss;
  final VoidCallback? onUpdate;
  final Widget? background;
  final Widget? secondaryBackground;
  final DismissDirection direction;
  final double dismissThresholds;
  final Duration resizeDuration;
  const Duration movementDuration = const Duration(milliseconds: 200);
  final double crossAxisEndOffset;
  final bool resizeToCenter;

  const GrafitDismissible({
    super.key,
    required this.child,
    this.onDismissed,
    this.onConfirmDismiss,
    this.onUpdate,
    this.background,
    this.secondaryBackground,
    this.direction = DismissDirection.horizontal,
    this.dismissThresholds = 0.6,
    this.resizeDuration = const Duration(milliseconds: 300),
    this.crossAxisEndOffset = 0.0,
    this.resizeToCenter = true,
  });

  @override
  State<GrafitDismissible> createState() => _GrafitDismissibleState();
}

class _GrafitDismissibleState extends State<GrafitDismissible>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  double _dragExtent = 0.0;
  bool _dragUnderway = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: widget.movementDuration,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragStart: _handleDragStart,
      onHorizontalDragUpdate: _handleDragUpdate,
      onHorizontalDragEnd: _handleDragEnd,
      behavior: HitTestBehavior.opaque,
      child: Stack(
        fit: StackFit.passthrough,
        children: [
          if (widget.background != null && _dragExtent < 0)
            Positioned.fill(
              child: widget.background!,
            ),
          if (widget.secondaryBackground != null && _dragExtent > 0)
            Positioned.fill(
              child: widget.secondaryBackground!,
            ),
          AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return FractionalTranslation(
                translation: _getTranslation(),
                child: child,
              );
            },
            child: widget.child,
          ),
        ],
      ),
    );
  }

  void _handleDragStart(DragStartDetails details) {
    if (_dragUnderway) return;
    _dragUnderway = true;
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    if (!_dragUnderway) return;

    final delta = details.primaryDelta ?? 0;
    setState(() {
      _dragExtent += delta;

      // Limit drag extent based on direction
      if (widget.direction == DismissDirection.horizontal) {
        // Allow horizontal in both directions
      } else if (widget.direction == DismissDirection.endToStart) {
        _dragExtent = _dragExtent < 0 ? _dragExtent : 0;
      } else if (widget.direction == DismissDirection.startToEnd) {
        _dragExtent = _dragExtent > 0 ? _dragExtent : 0;
      }

      widget.onUpdate?.call();
    });
  }

  void _handleDragEnd(DragEndDetails details) {
    if (!_dragUnderway) return;
    _dragUnderway = false;

    final size = context.size?.width ?? 0;
    final threshold = size * widget.dismissThresholds;

    if (_dragExtent.abs() > threshold) {
      _confirmDismiss();
    } else {
      _cancelDismiss();
    }
  }

  void _confirmDismiss() async {
    final shouldDismiss = widget.onConfirmDismiss == null ||
        await widget.onConfirmDismiss!(_getDismissDirection());

    if (shouldDismiss && mounted) {
      await _animationController.forward();
      widget.onDismissed?.call();
    } else {
      _cancelDismiss();
    }
  }

  void _cancelDismiss() {
    setState(() {
      _dragExtent = 0.0;
    });
    _animationController.reverse();
  }

  DismissDirection _getDismissDirection() {
    if (_dragExtent < 0) return DismissDirection.endToStart;
    return DismissDirection.startToEnd;
  }

  Offset _getTranslation() {
    final size = context.size?.width ?? 0;
    final fraction = _dragExtent / size;
    final animationValue = _animationController.value;
    return Offset(fraction * animationValue, widget.crossAxisEndOffset);
  }
}

/// Callback type for confirm dismiss
typedef DismissDirectionCallback = Future<bool> Function(DismissDirection);

/// Dismissible wrapper that provides a simpler API
class GrafitDismissibleWrapper extends StatelessWidget {
  final Widget child;
  final VoidCallback onDismiss;
  final String? dismissLabel;
  final Color? dismissColor;

  const GrafitDismissibleWrapper({
    super.key,
    required this.child,
    required this.onDismiss,
    this.dismissLabel,
    this.dismissColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return GrafitDismissible(
      onDismissed: onDismiss,
      background: Container(
        color: dismissColor ?? colorScheme.error,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      secondaryBackground: Container(
        color: dismissColor ?? colorScheme.error,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      child: child,
    );
  }
}
