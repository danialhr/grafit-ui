import 'package:flutter/material.dart';
import '../../theme/theme.dart';
import '../form/button.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

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

// Widgetbook use cases
@widgetbook.UseCase(
  name: 'Default',
  type: GrafitCollapsible,
  path: 'Specialized/Collapsible',
)
Widget collapsibleDefault(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.all(24.0),
    child: SizedBox(
      width: 300,
      child: GrafitCollapsible(
        trigger: GrafitCollapsibleTrigger(label: 'Click to expand'),
        content: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text('This is the collapsible content that can be shown or hidden.'),
        ),
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'Initially Open',
  type: GrafitCollapsible,
  path: 'Specialized/Collapsible',
)
Widget collapsibleInitiallyOpen(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.all(24.0),
    child: SizedBox(
      width: 300,
      child: GrafitCollapsible(
        initiallyOpen: true,
        trigger: GrafitCollapsibleTrigger(label: 'Section'),
        content: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text('This content is visible by default.'),
        ),
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'No Animation',
  type: GrafitCollapsible,
  path: 'Specialized/Collapsible',
)
Widget collapsibleNoAnimation(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.all(24.0),
    child: SizedBox(
      width: 300,
      child: GrafitCollapsible(
        animated: false,
        trigger: GrafitCollapsibleTrigger(label: 'No Animation'),
        content: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text('This content appears without animation.'),
        ),
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'Rich Content',
  type: GrafitCollapsible,
  path: 'Specialized/Collapsible',
)
Widget collapsibleRichContent(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.all(24.0),
    child: SizedBox(
      width: 350,
      child: GrafitCollapsible(
        trigger: GrafitCollapsibleTrigger(label: 'FAQ: What is this?'),
        content: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('This is a collapsible component with rich content.',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text('You can put any widgets inside the content area, including text, images, buttons, and more.'),
              SizedBox(height: 12),
              Text('Features:', style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 4),
              Text('Animated expansion/collapse'),
              Text('Customizable trigger'),
              Text('Flexible content'),
            ],
          ),
        ),
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'Multiple Sections',
  type: GrafitCollapsible,
  path: 'Specialized/Collapsible',
)
Widget collapsibleMultipleSections(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.all(24.0),
    child: SizedBox(
      width: 350,
      child: Column(
        children: [
          GrafitCollapsible(
            trigger: GrafitCollapsibleTrigger(label: 'Section 1'),
            content: Padding(
              padding: EdgeInsets.all(16.0),
              child: Text('Content for section 1'),
            ),
          ),
          SizedBox(height: 8),
          GrafitCollapsible(
            trigger: GrafitCollapsibleTrigger(label: 'Section 2'),
            content: Padding(
              padding: EdgeInsets.all(16.0),
              child: Text('Content for section 2'),
            ),
          ),
          SizedBox(height: 8),
          GrafitCollapsible(
            trigger: GrafitCollapsibleTrigger(label: 'Section 3'),
            content: Padding(
              padding: EdgeInsets.all(16.0),
              child: Text('Content for section 3'),
            ),
          ),
        ],
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'Interactive',
  type: GrafitCollapsible,
  path: 'Specialized/Collapsible',
)
Widget collapsibleInteractive(BuildContext context) {
  final animated = context.knobs.boolean(
    label: 'Animated',
    initialValue: true,
  );

  final initiallyOpen = context.knobs.boolean(
    label: 'Initially Open',
    initialValue: false,
  );

  return Padding(
    padding: const EdgeInsets.all(24.0),
    child: SizedBox(
      width: 300,
      child: GrafitCollapsible(
        animated: animated,
        initiallyOpen: initiallyOpen,
        trigger: const GrafitCollapsibleTrigger(label: 'Interactive'),
        content: const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text('Use the knobs to customize this collapsible.'),
        ),
      ),
    ),
  );
}
