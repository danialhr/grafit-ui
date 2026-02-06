import 'package:flutter/material.dart';
import '../../theme/theme.dart';
import '../form/button.dart';

/// Collapsible component
class GrafitCollapsible extends StatefulWidget {
  final Widget trigger;
  final Widget content;
  final bool initiallyOpen;
  final bool animated;
  final ValueChanged<bool>? onOpenChange;

  const GrafitCollapsible({
    super.key,
    required this.trigger,
    required this.content,
    this.initiallyOpen = false,
    this.animated = true,
    this.onOpenChange,
  });

  @override
  State<GrafitCollapsible> createState() => _GrafitCollapsibleState();
}

class _GrafitCollapsibleState extends State<GrafitCollapsible>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isOpen = false;

  @override
  void initState() {
    super.initState();
    _isOpen = widget.initiallyOpen;
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    if (_isOpen) {
      _controller.value = 1.0;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() {
      _isOpen = !_isOpen;
      if (_isOpen) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
      widget.onOpenChange?.call(_isOpen);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: _toggle,
          child: widget.trigger,
        ),
        ClipRect(
          child: widget.animated
              ? SizeTransition(
                  sizeFactor: _animation,
                  axis: Axis.vertical,
                  axisAlignment: -1,
                  child: widget.content,
                )
              : _isOpen
                  ? widget.content
                  : const SizedBox.shrink(),
        ),
      ],
    );
  }
}

/// Collapsible trigger with chevron icon
class GrafitCollapsibleTrigger extends StatelessWidget {
  final String label;
  final Widget? child;
  final bool isOpen;

  const GrafitCollapsibleTrigger({
    super.key,
    required this.label,
    this.child,
    this.isOpen = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<GrafitTheme>()!;
    final colors = theme.colors;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: colors.muted,
        border: Border.all(color: colors.border),
        borderRadius: BorderRadius.circular(colors.radius * 6),
      ),
      child: Row(
        children: [
          Expanded(
            child: child ??
                Text(
                  label,
                  style: TextStyle(
                    color: colors.foreground,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
          ),
          RotationTransition(
            turns: AlwaysStoppedAnimation(isOpen ? 0.5 : 0),
            duration: const Duration(milliseconds: 200),
            child: Icon(
              Icons.chevron_down,
              color: colors.mutedForeground,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }
}
