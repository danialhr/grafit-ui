import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import '../../theme/theme.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import '../form/button.dart';

/// Popover alignment options
enum GrafitPopoverAlignment {
  top,
  bottom,
  left,
  right,
  topLeft,
  topRight,
  bottomLeft,
  bottomRight,
}

/// Popover component - floating content container
class GrafitPopover extends StatefulWidget {
  final Widget trigger;
  final Widget content;
  final GrafitPopoverAlignment? alignment;
  final double? offset;
  final bool dismissible;
  final bool useLegacy;

  const GrafitPopover({
    super.key,
    required this.trigger,
    required this.content,
    this.alignment,
    this.offset,
    this.dismissible = true,
    this.useLegacy = false,
  });

  @override
  State<GrafitPopover> createState() => _GrafitPopoverState();
}

class _GrafitPopoverState extends State<GrafitPopover>
    with SingleTickerProviderStateMixin {
  OverlayEntry? _overlayEntry;
  bool _isOpen = false;
  final LayerLink _layerLink = LayerLink();
  final GlobalKey _triggerKey = GlobalKey();

  @override
  void initState() {
    super.initState();
  }

  void _toggle() {
    setState(() {
      _isOpen = !_isOpen;
      if (_isOpen) {
        _showPopover();
      } else {
        _hidePopover();
      }
    });
  }

  void _showPopover() {
    setState(() {
      _overlayEntry = OverlayEntry(
        builder: (context) => _buildPopoverContent(),
      );
      Overlay.of(context).insert(_overlayEntry!);
    });
  }

  void _hidePopover() {
    _overlayEntry?.remove();
    setState(() {
      _overlayEntry = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransform(
      transform: Matrix4.identity(),
      alignment: Alignment.center,
      child: GestureDetector(
        onTap: _toggle,
        child: GlobalKeyed(
          key: _triggerKey,
          child: widget.trigger,
        ),
      ),
    );
  }

  Widget _buildPopoverContent() {
    final theme = Theme.of(context).extension<GrafitTheme>()!;
    final colors = theme.colors;

    final triggerContext = _triggerKey.currentContext;
    if (triggerContext == null) {
      return const SizedBox.shrink();
    }

    final renderBox = triggerContext!.findRenderObject() as RenderBox?;
    if (renderBox == null) {
      return const SizedBox.shrink();
    }

    final position = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;

    return _GrafitPopoverContent(
      layerLink: _layerLink,
      targetSize: size,
      targetPosition: position,
      alignment: widget.alignment ?? GrafitPopoverAlignment.bottom,
      offset: widget.offset ?? 4,
      colors: colors,
      theme: theme,
      content: widget.content,
      onDismiss: widget.dismissible ? () => _toggle() : null,
    );
  }
}

/// Internal popover content widget
class _GrafitPopoverContent extends StatefulWidget {
  final LayerLink layerLink;
  final Size targetSize;
  final Offset targetPosition;
  final GrafitPopoverAlignment alignment;
  final double offset;
  final GrafitColorScheme colors;
  final GrafitTheme theme;
  final Widget content;
  final VoidCallback? onDismiss;

  const _GrafitPopoverContent({
    required this.layerLink,
    required this.targetSize,
    required this.targetPosition,
    required this.alignment,
    required this.offset,
    required this.colors,
    required this.theme,
    required this.content,
    this.onDismiss,
  });

  @override
  State<_GrafitPopoverContent> createState() => _GrafitPopoverContentState();
}

class _GrafitPopoverContentState extends State<_GrafitPopoverContent>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  bool _isDisposed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.95, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _controller.forward();

    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (!_isDisposed && mounted) {
        // Trigger layout after the overlay is inserted
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _isDisposed = true;
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: GestureDetector(
        onTap: widget.onDismiss,
        behavior: HitTestBehavior.translucent,
        child: CustomSingleChildLayout(
          delegate: _PopoverDelegate(
            layerLink: widget.layerLink,
            targetSize: widget.targetSize,
            targetPosition: widget.targetPosition,
            alignment: widget.alignment,
            offset: widget.offset,
            popoverSize: const Size(288, 150),
          ),
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Opacity(
                opacity: _fadeAnimation.value,
                child: Transform.scale(
                  scale: _scaleAnimation.value,
                  alignment: Alignment.topLeft,
                  child: child,
                ),
              );
            },
            child: Container(
              width: 288,
              decoration: BoxDecoration(
                color: widget.colors.background,
                borderRadius: BorderRadius.circular(widget.colors.radius * 6),
                border: Border.all(color: widget.colors.border),
                boxShadow: [
                  BoxShadow(
                    color: widget.colors.shadow.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(16),
              child: widget.content,
            ),
          ),
        ),
      ),
    );
  }
}

/// Custom layout delegate for positioning popover
class _PopoverDelegate extends SingleChildLayoutDelegate {
  final LayerLink layerLink;
  final Size targetSize;
  final Offset targetPosition;
  final GrafitPopoverAlignment alignment;
  final double offset;
  final Size popoverSize;

  _PopoverDelegate({
    required this.layerLink,
    required this.targetSize,
    required this.targetPosition,
    required this.alignment,
    required this.offset,
    required this.popoverSize,
  });

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    return BoxConstraints(
      minWidth: popoverSize.width,
      maxWidth: popoverSize.width,
      minHeight: popoverSize.height,
      maxHeight: popoverSize.height,
    );
  }

  @override
  Offset getPositionForChild(Size size) {
    final link = layerLink.leaderOf(context);
    if (link == null) {
      return Offset.zero;
    }

    final targetBox = link.bounds;
    if (targetBox == null) {
      return Offset.zero;
    }

    double x = targetBox.left;
    double y = targetBox.top;

    // Calculate position based on alignment
    switch (alignment) {
      case GrafitPopoverAlignment.top:
        x += (targetSize.width - popoverSize.width) / 2;
        y -= popoverSize.height + offset;
        break;
      case GrafitPopoverAlignment.bottom:
        x += (targetSize.width - popoverSize.width) / 2;
        y += targetSize.height + offset;
        break;
      case GrafitPopoverAlignment.left:
        x -= popoverSize.width + offset;
        y += (targetSize.height - popoverSize.height) / 2;
        break;
      case GrafitPopoverAlignment.right:
        x += targetSize.width + offset;
        y += (targetSize.height - popoverSize.height) / 2;
        break;
      case GrafitPopoverAlignment.topLeft:
        x -= popoverSize.width;
        y -= popoverSize.height;
        break;
      case GrafitPopoverAlignment.topRight:
        x += targetSize.width;
        y -= popoverSize.height;
        break;
      case GrafitPopoverAlignment.bottomLeft:
        x -= popoverSize.width;
        y += targetSize.height;
        break;
      case GrafitPopoverAlignment.bottomRight:
        x += targetSize.width;
        y += targetSize.height;
        break;
    }

    return Offset(x, y);
  }

  @override
  bool shouldRelayout(_PopoverDelegate oldDelegate) {
    return true;
  }
}

/// PopoverHeader - header section for popover
class GrafitPopoverHeader extends StatelessWidget {
  final String? title;
  final String? description;
  final Widget? child;

  const GrafitPopoverHeader({
    super.key,
    this.title,
    this.description,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<GrafitTheme>()!;
    final colors = theme.colors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (title != null)
          Text(
            title!,
            style: TextStyle(
              color: colors.foreground,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        if (title != null && (description != null || child != null))
          const SizedBox(height: 4),
        if (description != null)
          Text(
            description!,
            style: TextStyle(
              color: colors.mutedForeground,
              fontSize: 12,
            ),
          ),
        if (child != null) child!,
      ],
    );
  }
}

/// PopoverTitle - title text for popover header
class GrafitPopoverTitle extends StatelessWidget {
  final String title;

  const GrafitPopoverTitle({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<GrafitTheme>()!;
    final colors = theme.colors;

    return Text(
      title,
      style: TextStyle(
        color: colors.foreground,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}

/// PopoverDescription - description text for popover
class GrafitPopoverDescription extends StatelessWidget {
  final String description;

  const GrafitPopoverDescription({
    super.key,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<GrafitTheme>()!;
    final colors = theme.colors;

    return Text(
      description,
      style: TextStyle(
        color: colors.mutedForeground,
        fontSize: 12,
      ),
    );
  }
}

// Widgetbook use cases
@widgetbook.UseCase(
  name: 'Default',
  type: GrafitPopover,
  path: 'Overlay/Popover',
)
Widget popoverDefault(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.all(100.0),
    child: GrafitPopover(
      trigger: GrafitButton(label: 'Open Popover'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GrafitPopoverTitle(title: 'Popover Title'),
          SizedBox(height: 8),
          GrafitPopoverDescription(description: 'This is a popover content.'),
        ],
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'With Header',
  type: GrafitPopover,
  path: 'Overlay/Popover',
)
Widget popoverWithHeader(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.all(100.0),
    child: GrafitPopover(
      trigger: GrafitButton(label: 'Open Popover'),
      content: GrafitPopoverHeader(
        title: 'Account Settings',
        description: 'Manage your account preferences',
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'Top Alignment',
  type: GrafitPopover,
  path: 'Overlay/Popover',
)
Widget popoverTopAlignment(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.all(100.0),
    child: GrafitPopover(
      trigger: GrafitButton(label: 'Show Above'),
      alignment: GrafitPopoverAlignment.top,
      content: GrafitPopoverHeader(
        title: 'Above',
        description: 'Popover appears above the trigger',
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'Left Alignment',
  type: GrafitPopover,
  path: 'Overlay/Popover',
)
Widget popoverLeftAlignment(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.all(100.0),
    child: GrafitPopover(
      trigger: GrafitButton(label: 'Show Left'),
      alignment: GrafitPopoverAlignment.left,
      content: GrafitPopoverHeader(
        title: 'Left Side',
        description: 'Popover appears to the left',
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'Right Alignment',
  type: GrafitPopover,
  path: 'Overlay/Popover',
)
Widget popoverRightAlignment(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.all(100.0),
    child: GrafitPopover(
      trigger: GrafitButton(label: 'Show Right'),
      alignment: GrafitPopoverAlignment.right,
      content: GrafitPopoverHeader(
        title: 'Right Side',
        description: 'Popover appears to the right',
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'All Alignments',
  type: GrafitPopover,
  path: 'Overlay/Popover',
)
Widget popoverAllAlignments(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.all(100.0),
    child: Wrap(
      spacing: 16,
      runSpacing: 16,
      children: [
        GrafitPopover(
          trigger: GrafitButton(label: 'Top'),
          alignment: GrafitPopoverAlignment.top,
          content: GrafitPopoverHeader(title: 'Top'),
        ),
        GrafitPopover(
          trigger: GrafitButton(label: 'Bottom'),
          alignment: GrafitPopoverAlignment.bottom,
          content: GrafitPopoverHeader(title: 'Bottom'),
        ),
        GrafitPopover(
          trigger: GrafitButton(label: 'Left'),
          alignment: GrafitPopoverAlignment.left,
          content: GrafitPopoverHeader(title: 'Left'),
        ),
        GrafitPopover(
          trigger: GrafitButton(label: 'Right'),
          alignment: GrafitPopoverAlignment.right,
          content: GrafitPopoverHeader(title: 'Right'),
        ),
      ],
    ),
  );
}

@widgetbook.UseCase(
  name: 'Rich Content',
  type: GrafitPopover,
  path: 'Overlay/Popover',
)
Widget popoverRichContent(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.all(100.0),
    child: GrafitPopover(
      trigger: GrafitButton(label: 'User Menu'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GrafitPopoverHeader(
            title: 'John Doe',
            description: 'john@example.com',
          ),
          SizedBox(height: 8),
          Text('Profile Settings', style: TextStyle(fontSize: 12)),
          SizedBox(height: 4),
          Text('Billing', style: TextStyle(fontSize: 12)),
          SizedBox(height: 4),
          Text('Logout', style: TextStyle(fontSize: 12)),
        ],
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'Non Dismissible',
  type: GrafitPopover,
  path: 'Overlay/Popover',
)
Widget popoverNonDismissible(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.all(100.0),
    child: GrafitPopover(
      trigger: GrafitButton(label: 'Open (Click to close)'),
      dismissible: false,
      content: GrafitPopoverHeader(
        title: 'Click trigger to close',
        description: 'This popover cannot be dismissed by clicking outside',
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'Custom Offset',
  type: GrafitPopover,
  path: 'Overlay/Popover',
)
Widget popoverCustomOffset(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.all(100.0),
    child: GrafitPopover(
      trigger: GrafitButton(label: 'With Offset'),
      offset: 16,
      content: GrafitPopoverHeader(
        title: 'Custom Offset',
        description: '16px offset from trigger',
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'Interactive',
  type: GrafitPopover,
  path: 'Overlay/Popover',
)
Widget popoverInteractive(BuildContext context) {
  // Widgetbook-only: ignore undefined_getter, undefined_method, invalid_annotation_value
  final title = context.knobs.string(label: 'Title', initialValue: 'Popover Title');
  // Widgetbook-only: ignore undefined_getter, undefined_method, invalid_annotation_value
  final description = context.knobs.string(label: 'Description', initialValue: 'This is a popover');
  // Widgetbook-only: ignore undefined_getter, undefined_method, invalid_annotation_value
  final alignment = context.knobs.list(
    label: 'Alignment',
    initialOption: GrafitPopoverAlignment.bottom,
    options: [
      GrafitPopoverAlignment.top,
      GrafitPopoverAlignment.bottom,
      GrafitPopoverAlignment.left,
      GrafitPopoverAlignment.right,
      GrafitPopoverAlignment.topLeft,
      GrafitPopoverAlignment.topRight,
      GrafitPopoverAlignment.bottomLeft,
      GrafitPopoverAlignment.bottomRight,
    ],
  );
  // Widgetbook-only: ignore undefined_getter, undefined_method, invalid_annotation_value
  final offset = context.knobs.double.slider(label: 'Offset', initialValue: 4, min: 0, max: 32);
  // Widgetbook-only: ignore undefined_getter, undefined_method, invalid_annotation_value
  final dismissible = context.knobs.boolean(label: 'Dismissible', initialValue: true);

  return Padding(
    padding: const EdgeInsets.all(100.0),
    child: GrafitPopover(
      trigger: const GrafitButton(label: 'Open Popover'),
      alignment: alignment,
      offset: offset,
      dismissible: dismissible,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (title.isNotEmpty) GrafitPopoverTitle(title: title),
          SizedBox(height: title.isNotEmpty && description.isNotEmpty ? 8 : 0),
          if (description.isNotEmpty) GrafitPopoverDescription(description: description),
        ],
      ),
    ),
  );
}
