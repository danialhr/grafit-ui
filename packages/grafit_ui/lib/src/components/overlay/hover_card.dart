import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import '../../theme/theme.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import '../form/button.dart';

/// Hover card alignment options
enum GrafitHoverCardAlignment {
  top,
  bottom,
  left,
  right,
  topLeft,
  topRight,
  bottomLeft,
  bottomRight,
}

/// Hover Card component - displays content on hover with delay
class GrafitHoverCard extends StatefulWidget {
  final Widget trigger;
  final Widget content;
  final GrafitHoverCardAlignment? alignment;
  final double? offset;
  final Duration openDelay;
  final Duration closeDelay;
  final double? width;
  final bool closeOnTap;

  const GrafitHoverCard({
    super.key,
    required this.trigger,
    required this.content,
    this.alignment,
    this.offset,
    this.openDelay = const Duration(milliseconds: 400),
    this.closeDelay = const Duration(milliseconds: 200),
    this.width,
    this.closeOnTap = true,
  });

  @override
  State<GrafitHoverCard> createState() => _GrafitHoverCardState();
}

class _GrafitHoverCardState extends State<GrafitHoverCard>
    with SingleTickerProviderStateMixin {
  OverlayEntry? _overlayEntry;
  bool _isOpen = false;
  final LayerLink _layerLink = LayerLink();
  final GlobalKey _triggerKey = GlobalKey();
  Timer? _openTimer;
  Timer? _closeTimer;

  @override
  void dispose() {
    _openTimer?.cancel();
    _closeTimer?.cancel();
    _overlayEntry?.remove();
    super.dispose();
  }

  void _scheduleOpen() {
    _closeTimer?.cancel();
    _openTimer ??= Timer(widget.openDelay, () {
      if (mounted && !_isOpen) {
        setState(() {
          _isOpen = true;
          _showHoverCard();
        });
      }
      _openTimer = null;
    });
  }

  void _scheduleClose() {
    _openTimer?.cancel();
    _closeTimer ??= Timer(widget.closeDelay, () {
      if (mounted && _isOpen) {
        setState(() {
          _isOpen = false;
          _hideHoverCard();
        });
      }
      _closeTimer = null;
    });
  }

  void _cancelClose() {
    _closeTimer?.cancel();
    _closeTimer = null;
  }

  void _cancelOpen() {
    _openTimer?.cancel();
    _openTimer = null;
  }

  void _showHoverCard() {
    _overlayEntry = OverlayEntry(
      builder: (context) => _buildHoverCardContent(),
    );
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _hideHoverCard() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: MouseRegion(
        onEnter: (_) => _scheduleOpen(),
        onExit: (_) => _scheduleClose(),
        child: GestureDetector(
          onTap: widget.closeOnTap && _isOpen ? _scheduleClose : null,
          child: KeyedSubtree(
            key: _triggerKey,
            child: widget.trigger,
          ),
        ),
      ),
    );
  }

  Widget _buildHoverCardContent() {
    final theme = Theme.of(context).extension<GrafitTheme>()!;
    final colors = theme.colors;

    final triggerContext = _triggerKey.currentContext;
    if (triggerContext == null) {
      return const SizedBox.shrink();
    }

    final renderBox = triggerContext.findRenderObject() as RenderBox?;
    if (renderBox == null) {
      return const SizedBox.shrink();
    }

    final position = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;

    return _GrafitHoverCardContent(
      layerLink: _layerLink,
      targetSize: size,
      targetPosition: position,
      alignment: widget.alignment ?? GrafitHoverCardAlignment.bottom,
      offset: widget.offset ?? 4,
      colors: colors,
      theme: theme,
      content: widget.content,
      width: widget.width ?? 256,
      onEnter: _cancelClose,
      onExit: _scheduleClose,
    );
  }
}

/// Internal hover card content widget
class _GrafitHoverCardContent extends StatefulWidget {
  final LayerLink layerLink;
  final Size targetSize;
  final Offset targetPosition;
  final GrafitHoverCardAlignment alignment;
  final double offset;
  final GrafitColorScheme colors;
  final GrafitTheme theme;
  final Widget content;
  final double width;
  final VoidCallback onEnter;
  final VoidCallback onExit;

  const _GrafitHoverCardContent({
    required this.layerLink,
    required this.targetSize,
    required this.targetPosition,
    required this.alignment,
    required this.offset,
    required this.colors,
    required this.theme,
    required this.content,
    required this.width,
    required this.onEnter,
    required this.onExit,
  });

  @override
  State<_GrafitHoverCardContent> createState() =>
      _GrafitHoverCardContentState();
}

class _GrafitHoverCardContentState extends State<_GrafitHoverCardContent>
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
      child: MouseRegion(
        onEnter: (_) => widget.onEnter(),
        onExit: (_) => widget.onExit(),
        child: CustomSingleChildLayout(
          delegate: _HoverCardDelegate(
            layerLink: widget.layerLink,
            targetSize: widget.targetSize,
            targetPosition: widget.targetPosition,
            alignment: widget.alignment,
            offset: widget.offset,
            hoverCardSize: Size(widget.width, 150),
          ),
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Opacity(
                opacity: _fadeAnimation.value,
                child: Transform.scale(
                  scale: _scaleAnimation.value,
                  alignment: _getAlignment(),
                  child: child,
                ),
              );
            },
            child: Container(
              width: widget.width,
              decoration: BoxDecoration(
                color: widget.colors.popover,
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

  Alignment _getAlignment() {
    switch (widget.alignment) {
      case GrafitHoverCardAlignment.top:
        return Alignment.bottomCenter;
      case GrafitHoverCardAlignment.bottom:
        return Alignment.topCenter;
      case GrafitHoverCardAlignment.left:
        return Alignment.centerRight;
      case GrafitHoverCardAlignment.right:
        return Alignment.centerLeft;
      case GrafitHoverCardAlignment.topLeft:
        return Alignment.bottomRight;
      case GrafitHoverCardAlignment.topRight:
        return Alignment.bottomLeft;
      case GrafitHoverCardAlignment.bottomLeft:
        return Alignment.topRight;
      case GrafitHoverCardAlignment.bottomRight:
        return Alignment.topLeft;
    }
  }
}

/// Custom layout delegate for positioning hover card
class _HoverCardDelegate extends SingleChildLayoutDelegate {
  final LayerLink layerLink;
  final Size targetSize;
  final Offset targetPosition;
  final GrafitHoverCardAlignment alignment;
  final double offset;
  final Size hoverCardSize;

  _HoverCardDelegate({
    required this.layerLink,
    required this.targetSize,
    required this.targetPosition,
    required this.alignment,
    required this.offset,
    required this.hoverCardSize,
  });

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    return BoxConstraints(
      minWidth: hoverCardSize.width,
      maxWidth: hoverCardSize.width,
      minHeight: 0,
      maxHeight: constraints.maxHeight,
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
      case GrafitHoverCardAlignment.top:
        x += (targetSize.width - hoverCardSize.width) / 2;
        y -= hoverCardSize.height + offset;
        break;
      case GrafitHoverCardAlignment.bottom:
        x += (targetSize.width - hoverCardSize.width) / 2;
        y += targetSize.height + offset;
        break;
      case GrafitHoverCardAlignment.left:
        x -= hoverCardSize.width + offset;
        y += (targetSize.height - hoverCardSize.height) / 2;
        break;
      case GrafitHoverCardAlignment.right:
        x += targetSize.width + offset;
        y += (targetSize.height - hoverCardSize.height) / 2;
        break;
      case GrafitHoverCardAlignment.topLeft:
        x -= hoverCardSize.width;
        y -= hoverCardSize.height;
        break;
      case GrafitHoverCardAlignment.topRight:
        x += targetSize.width;
        y -= hoverCardSize.height;
        break;
      case GrafitHoverCardAlignment.bottomLeft:
        x -= hoverCardSize.width;
        y += targetSize.height;
        break;
      case GrafitHoverCardAlignment.bottomRight:
        x += targetSize.width;
        y += targetSize.height;
        break;
    }

    return Offset(x, y);
  }

  @override
  bool shouldRelayout(_HoverCardDelegate oldDelegate) {
    return true;
  }
}

/// HoverCardTrigger - the widget that triggers the hover card
class GrafitHoverCardTrigger extends StatelessWidget {
  final Widget child;

  const GrafitHoverCardTrigger({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return child;
  }
}

/// HoverCardContent - content wrapper for hover card
class GrafitHoverCardContent extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;

  const GrafitHoverCardContent({
    super.key,
    required this.child,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<GrafitTheme>()!;
    final colors = theme.colors;

    return Container(
      padding: padding ?? EdgeInsets.zero,
      child: DefaultTextStyle(
        style: TextStyle(
          color: colors.popoverForeground,
          fontSize: 14,
        ),
        child: child,
      ),
    );
  }
}

/// HoverCardHeader - header section for hover card
class GrafitHoverCardHeader extends StatelessWidget {
  final String? title;
  final String? description;
  final Widget? child;

  const GrafitHoverCardHeader({
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
              color: colors.popoverForeground,
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

/// HoverCardTitle - title text for hover card header
class GrafitHoverCardTitle extends StatelessWidget {
  final String title;

  const GrafitHoverCardTitle({
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
        color: colors.popoverForeground,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}

/// HoverCardDescription - description text for hover card
class GrafitHoverCardDescription extends StatelessWidget {
  final String description;

  const GrafitHoverCardDescription({
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
  type: GrafitHoverCard,
  path: 'Overlay/HoverCard',
)
Widget hoverCardDefault(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.all(100.0),
    child: GrafitHoverCard(
      trigger: GrafitButton(label: 'Hover Me'),
      content: GrafitHoverCardHeader(
        title: 'Hover Card Title',
        description: 'This is a hover card with some information',
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'Top Alignment',
  type: GrafitHoverCard,
  path: 'Overlay/HoverCard',
)
Widget hoverCardTop(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.all(100.0),
    child: GrafitHoverCard(
      trigger: GrafitButton(label: 'Hover for Top'),
      alignment: GrafitHoverCardAlignment.top,
      content: GrafitHoverCardHeader(
        title: 'Above',
        description: 'Hover card appears above the trigger',
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'Left Alignment',
  type: GrafitHoverCard,
  path: 'Overlay/HoverCard',
)
Widget hoverCardLeft(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.all(100.0),
    child: GrafitHoverCard(
      trigger: GrafitButton(label: 'Hover for Left'),
      alignment: GrafitHoverCardAlignment.left,
      content: GrafitHoverCardHeader(
        title: 'Left Side',
        description: 'Hover card appears to the left',
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'Right Alignment',
  type: GrafitHoverCard,
  path: 'Overlay/HoverCard',
)
Widget hoverCardRight(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.all(100.0),
    child: GrafitHoverCard(
      trigger: GrafitButton(label: 'Hover for Right'),
      alignment: GrafitHoverCardAlignment.right,
      content: GrafitHoverCardHeader(
        title: 'Right Side',
        description: 'Hover card appears to the right',
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'Rich Content',
  type: GrafitHoverCard,
  path: 'Overlay/HoverCard',
)
Widget hoverCardRichContent(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.all(100.0),
    child: GrafitHoverCard(
      trigger: GrafitButton(label: 'User Profile'),
      width: 300,
      content: GrafitHoverCardContent(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GrafitHoverCardHeader(
              title: 'John Doe',
              description: 'Software Engineer',
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.email, size: 14, color: Colors.grey),
                SizedBox(width: 8),
                Text('john@example.com', style: TextStyle(fontSize: 12)),
              ],
            ),
            SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.phone, size: 14, color: Colors.grey),
                SizedBox(width: 8),
                Text('+1 234 567 890', style: TextStyle(fontSize: 12)),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'Custom Width',
  type: GrafitHoverCard,
  path: 'Overlay/HoverCard',
)
Widget hoverCardCustomWidth(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.all(100.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 16,
      children: [
        GrafitHoverCard(
          trigger: GrafitButton(label: 'Small (200px)'),
          width: 200,
          content: GrafitHoverCardHeader(
            title: 'Small Card',
            description: '200px width',
          ),
        ),
        GrafitHoverCard(
          trigger: GrafitButton(label: 'Large (400px)'),
          width: 400,
          content: GrafitHoverCardHeader(
            title: 'Large Card',
            description: '400px width with more space for content',
          ),
        ),
      ],
    ),
  );
}

@widgetbook.UseCase(
  name: 'Custom Delays',
  type: GrafitHoverCard,
  path: 'Overlay/HoverCard',
)
Widget hoverCardDelays(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.all(100.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 16,
      children: [
        GrafitHoverCard(
          trigger: GrafitButton(label: 'Fast Open'),
          openDelay: Duration(milliseconds: 100),
          closeDelay: Duration(milliseconds: 100),
          content: GrafitHoverCardHeader(
            title: 'Fast',
            description: 'Opens quickly (100ms)',
          ),
        ),
        GrafitHoverCard(
          trigger: GrafitButton(label: 'Slow Open'),
          openDelay: Duration(milliseconds: 800),
          closeDelay: Duration(milliseconds: 400),
          content: GrafitHoverCardHeader(
            title: 'Slow',
            description: 'Opens slowly (800ms)',
          ),
        ),
      ],
    ),
  );
}

@widgetbook.UseCase(
  name: 'All Alignments',
  type: GrafitHoverCard,
  path: 'Overlay/HoverCard',
)
Widget hoverCardAllAlignments(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.all(100.0),
    child: Wrap(
      spacing: 24,
      runSpacing: 24,
      children: [
        GrafitHoverCard(
          trigger: GrafitButton(label: 'Top'),
          alignment: GrafitHoverCardAlignment.top,
          content: GrafitHoverCardHeader(title: 'Top'),
        ),
        GrafitHoverCard(
          trigger: GrafitButton(label: 'Bottom'),
          alignment: GrafitHoverCardAlignment.bottom,
          content: GrafitHoverCardHeader(title: 'Bottom'),
        ),
        GrafitHoverCard(
          trigger: GrafitButton(label: 'Left'),
          alignment: GrafitHoverCardAlignment.left,
          content: GrafitHoverCardHeader(title: 'Left'),
        ),
        GrafitHoverCard(
          trigger: GrafitButton(label: 'Right'),
          alignment: GrafitHoverCardAlignment.right,
          content: GrafitHoverCardHeader(title: 'Right'),
        ),
      ],
    ),
  );
}

@widgetbook.UseCase(
  name: 'Non Dismissible on Tap',
  type: GrafitHoverCard,
  path: 'Overlay/HoverCard',
)
Widget hoverCardNonDismissible(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.all(100.0),
    child: GrafitHoverCard(
      trigger: GrafitButton(label: 'Hover (Tap to close)'),
      closeOnTap: false,
      content: GrafitHoverCardHeader(
        title: 'Cannot Close on Tap',
        description: 'This hover card can only be closed by moving the mouse away',
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'Interactive',
  type: GrafitHoverCard,
  path: 'Overlay/HoverCard',
)
Widget hoverCardInteractive(BuildContext context) {
  final title = context.knobs.string(label: 'Title', initialValue: 'Hover Card');
  final description = context.knobs.string(label: 'Description', initialValue: 'Move your mouse over the button');
  final alignment = context.knobs.list(
    label: 'Alignment',
    initialOption: GrafitHoverCardAlignment.bottom,
    options: [
      GrafitHoverCardAlignment.top,
      GrafitHoverCardAlignment.bottom,
      GrafitHoverCardAlignment.left,
      GrafitHoverCardAlignment.right,
      GrafitHoverCardAlignment.topLeft,
      GrafitHoverCardAlignment.topRight,
      GrafitHoverCardAlignment.bottomLeft,
      GrafitHoverCardAlignment.bottomRight,
    ],
  );
  final width = context.knobs.double.slider(label: 'Width', initialValue: 256, min: 150, max: 500);
  final openDelay = context.knobs.int.slider(label: 'Open Delay (ms)', initialValue: 400, min: 0, max: 1000);
  final closeOnTap = context.knobs.boolean(label: 'Close on Tap', initialValue: true);

  return Padding(
    padding: const EdgeInsets.all(100.0),
    child: GrafitHoverCard(
      trigger: const GrafitButton(label: 'Hover Me'),
      alignment: alignment,
      width: width,
      openDelay: Duration(milliseconds: openDelay),
      closeOnTap: closeOnTap,
      content: GrafitHoverCardHeader(
        title: title.isNotEmpty ? title : null,
        description: description.isNotEmpty ? description : null,
      ),
    ),
  );
}
