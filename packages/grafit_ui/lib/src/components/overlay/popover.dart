import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import '../../theme/theme.dart';

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
