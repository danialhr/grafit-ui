import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../theme/theme.dart';

/// Sheet side - direction from which the sheet slides in
enum GrafitSheetSide {
  top,
  right,
  bottom,
  left,
}

/// Sheet component - slide-in panel from any direction
///
/// A sheet is a dialog-like panel that slides in from the edge of the screen.
/// It can be triggered by a widget and provides a modal overlay with backdrop.
class GrafitSheet extends StatefulWidget {
  /// The content to display inside the sheet
  final Widget child;

  /// Direction from which the sheet slides in
  final GrafitSheetSide side;

  /// Optional trigger widget that opens the sheet when tapped
  final Widget? trigger;

  /// Allow closing by tapping the backdrop
  final bool dismissible;

  /// Programmatically control the open state
  final bool open;

  /// Callback when the sheet open state changes
  final ValueChanged<bool>? onOpenChange;

  /// Show close button in the top-right corner
  final bool showCloseButton;

  /// Custom width for side sheets (left/right)
  final double? width;

  /// Custom height for top/bottom sheets
  final double? height;

  const GrafitSheet({
    super.key,
    required this.child,
    this.side = GrafitSheetSide.right,
    this.trigger,
    this.dismissible = true,
    this.open = false,
    this.onOpenChange,
    this.showCloseButton = true,
    this.width,
    this.height,
  });

  @override
  State<GrafitSheet> createState() => _GrafitSheetState();
}

class _GrafitSheetState extends State<GrafitSheet>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late Animation<double> _fadeAnimation;
  bool _isOpen = false;
  final LayerLink _layerLink = LayerLink();
  final GlobalKey _triggerKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _isOpen = widget.open;
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
    );
    if (_isOpen) {
      _controller.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(GrafitSheet oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.open != oldWidget.open) {
      setState(() {
        _isOpen = widget.open;
        if (_isOpen) {
          _controller.forward();
        } else {
          _controller.reverse();
        }
      });
    }
  }

  void _toggle() {
    final newState = !_isOpen;
    setState(() {
      _isOpen = newState;
      if (_isOpen) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
    widget.onOpenChange?.call(_isOpen);
  }

  void _close() {
    setState(() {
      _isOpen = false;
      _controller.reverse();
    });
    widget.onOpenChange?.call(false);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.trigger != null && !_isOpen) {
      return GestureDetector(
        key: _triggerKey,
        onTap: _toggle,
        child: widget.trigger,
      );
    }

    if (!_isOpen) {
      return const SizedBox.shrink();
    }

    return GrafitSheetOverlay(
      animation: _fadeAnimation,
      onDismiss: widget.dismissible ? _close : null,
      child: GrafitSheetContent(
        side: widget.side,
        animation: _animation,
        colors: Theme.of(context).extension<GrafitTheme>()!.colors,
        theme: Theme.of(context).extension<GrafitTheme>()!,
        child: widget.child,
        onClose: _close,
        showCloseButton: widget.showCloseButton,
        width: widget.width,
        height: widget.height,
      ),
    );
  }
}

/// Sheet overlay - backdrop overlay for the sheet
class GrafitSheetOverlay extends StatelessWidget {
  final Widget child;
  final VoidCallback? onDismiss;
  final Animation<double> animation;

  const GrafitSheetOverlay({
    super.key,
    required this.child,
    this.onDismiss,
    required this.animation,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, _) {
        return GestureDetector(
          onTap: onDismiss,
          child: Container(
            color: Colors.black.withOpacity(0.5 * animation.value),
            child: child,
          ),
        );
      },
    );
  }
}

/// Sheet content - the actual sliding panel
class GrafitSheetContent extends StatelessWidget {
  final GrafitSheetSide side;
  final Animation<double> animation;
  final GrafitColorScheme colors;
  final GrafitTheme theme;
  final Widget child;
  final VoidCallback onClose;
  final bool showCloseButton;
  final double? width;
  final double? height;

  const GrafitSheetContent({
    super.key,
    required this.side,
    required this.animation,
    required this.colors,
    required this.theme,
    required this.child,
    required this.onClose,
    this.showCloseButton = true,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Default sizing based on side
    final defaultWidth = screenWidth * 0.75;
    final maxWidth = 384.0;
    final finalWidth = width ?? (defaultWidth < maxWidth ? defaultWidth : maxWidth);
    final finalHeight = height ?? screenHeight * 0.5;

    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Stack(
          children: [
            _buildSheet(finalWidth, finalHeight),
          ],
        );
      },
    );
  }

  Widget _buildSheet(double sheetWidth, double sheetHeight) {
    final sheetContent = Container(
      decoration: BoxDecoration(
        color: colors.background,
        border: _getBorder(),
        boxShadow: [
          BoxShadow(
            color: colors.shadow.withOpacity(0.1),
            blurRadius: 8,
            offset: _getShadowOffset(),
          ),
        ],
      ),
      child: Stack(
        children: [
          Padding(
            padding: _getPadding(),
            child: child,
          ),
          if (showCloseButton)
            Positioned(
              top: 16,
              right: 16,
              child: GrafitSheetCloseButton(onPressed: onClose),
            ),
        ],
      ),
    );

    switch (side) {
      case GrafitSheetSide.top:
        return Positioned(
          top: -sheetHeight * (1 - animation.value),
          left: 0,
          right: 0,
          height: sheetHeight,
          child: sheetContent,
        );

      case GrafitSheetSide.bottom:
        return Positioned(
          bottom: -sheetHeight * (1 - animation.value),
          left: 0,
          right: 0,
          height: sheetHeight,
          child: sheetContent,
        );

      case GrafitSheetSide.left:
        return Positioned(
          left: -sheetWidth * (1 - animation.value),
          top: 0,
          bottom: 0,
          width: sheetWidth,
          child: sheetContent,
        );

      case GrafitSheetSide.right:
      default:
        return Positioned(
          right: -sheetWidth * (1 - animation.value),
          top: 0,
          bottom: 0,
          width: sheetWidth,
          child: sheetContent,
        );
    }
  }

  Border _getBorder() {
    switch (side) {
      case GrafitSheetSide.top:
        return Border(bottom: BorderSide(color: colors.border));
      case GrafitSheetSide.bottom:
        return Border(top: BorderSide(color: colors.border));
      case GrafitSheetSide.left:
        return Border(right: BorderSide(color: colors.border));
      case GrafitSheetSide.right:
      default:
        return Border(left: BorderSide(color: colors.border));
    }
  }

  Offset _getShadowOffset() {
    switch (side) {
      case GrafitSheetSide.top:
        return const Offset(0, 4);
      case GrafitSheetSide.bottom:
        return const Offset(0, -4);
      case GrafitSheetSide.left:
        return const Offset(4, 0);
      case GrafitSheetSide.right:
      default:
        return const Offset(-4, 0);
    }
  }

  EdgeInsets _getPadding() {
    // Default padding of 16px on all sides
    return const EdgeInsets.all(16);
  }
}

/// SheetTrigger - trigger widget for opening the sheet
///
/// This widget wraps any child widget and makes it tappable to open the sheet.
class SheetTrigger extends StatelessWidget {
  final Widget child;
  final VoidCallback onTap;

  const SheetTrigger({
    super.key,
    required this.child,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: child,
    );
  }
}

/// SheetClose - button to close the sheet
class GrafitSheetCloseButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const GrafitSheetCloseButton({
    super.key,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<GrafitTheme>()!.colors;

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: colors.secondary,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Icon(
          Icons.close,
          color: colors.mutedForeground,
          size: 16,
        ),
      ),
    );
  }
}

/// SheetClose - wrapper widget for close functionality
class SheetClose extends StatelessWidget {
  final Widget child;
  final VoidCallback? onPressed;

  const SheetClose({
    super.key,
    required this.child,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed ?? () => Navigator.of(context).pop(),
      child: child,
    );
  }
}

/// SheetHeader - header section for sheet
class SheetHeader extends StatelessWidget {
  final Widget? child;
  final String? title;
  final String? description;

  const SheetHeader({
    super.key,
    this.child,
    this.title,
    this.description,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<GrafitTheme>()!.colors;

    final headerChild = child ??
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (title != null) SheetTitle(title: title!),
            if (description != null) ...[
              const SizedBox(height: 4),
              SheetDescription(description: description!),
            ],
          ],
        );

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: headerChild,
    );
  }
}

/// SheetFooter - footer section for sheet
class SheetFooter extends StatelessWidget {
  final List<Widget> actions;

  const SheetFooter({
    super.key,
    required this.actions,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<GrafitTheme>()!.colors;

    return Container(
      margin: const EdgeInsets.only(top: 16),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: colors.border),
        ),
      ),
      padding: const EdgeInsets.only(top: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: actions,
      ),
    );
  }
}

/// SheetTitle - title text for sheet header
class SheetTitle extends StatelessWidget {
  final String title;

  const SheetTitle({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<GrafitTheme>()!.colors;

    return Text(
      title,
      style: TextStyle(
        color: colors.foreground,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

/// SheetDescription - description text for sheet
class SheetDescription extends StatelessWidget {
  final String description;

  const SheetDescription({
    super.key,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<GrafitTheme>()!.colors;

    return Text(
      description,
      style: TextStyle(
        color: colors.mutedForeground,
        fontSize: 14,
      ),
    );
  }
}

/// Convenience method to show a sheet from anywhere
///
/// Usage:
/// ```dart
/// GrafitSheet.show(
///   context,
///   side: GrafitSheetSide.right,
///   child: SheetContent(...),
/// );
/// ```
class GrafitSheetHelper {
  static OverlayEntry? _overlayEntry;
  static bool _isOpen = false;

  static void show(
    BuildContext context, {
    required Widget child,
    GrafitSheetSide side = GrafitSheetSide.right,
    bool dismissible = true,
    bool showCloseButton = true,
    double? width,
    double? height,
    VoidCallback? onClosed,
  }) {
    if (_isOpen) return;

    final overlay = Overlay.of(context);
    final colors = Theme.of(context).extension<GrafitTheme>()!;

    _overlayEntry = OverlayEntry(
      builder: (context) => _SheetModalOverlay(
        colors: colors,
        side: side,
        dismissible: dismissible,
        showCloseButton: showCloseButton,
        width: width,
        height: height,
        child: child,
        onClosed: () {
          _overlayEntry?.remove();
          _overlayEntry = null;
          _isOpen = false;
          onClosed?.call();
        },
      ),
    );

    _isOpen = true;
    overlay.insert(_overlayEntry!);
  }

  static void close() {
    if (_isOpen && _overlayEntry != null) {
      _overlayEntry?.remove();
      _overlayEntry = null;
      _isOpen = false;
    }
  }
}

/// Internal modal overlay for helper method
class _SheetModalOverlay extends StatefulWidget {
  final GrafitTheme colors;
  final GrafitSheetSide side;
  final bool dismissible;
  final bool showCloseButton;
  final double? width;
  final double? height;
  final Widget child;
  final VoidCallback onClosed;

  const _SheetModalOverlay({
    required this.colors,
    required this.side,
    required this.dismissible,
    required this.showCloseButton,
    this.width,
    this.height,
    required this.child,
    required this.onClosed,
  });

  @override
  State<_SheetModalOverlay> createState() => _SheetModalOverlayState();
}

class _SheetModalOverlayState extends State<_SheetModalOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
    );
    _controller.forward();

    // Register keyboard listener for Escape key
    RawKeyboard.instance.addListener(_handleKeyEvent);
  }

  @override
  void dispose() {
    RawKeyboard.instance.removeListener(_handleKeyEvent);
    _controller.dispose();
    super.dispose();
  }

  void _handleKeyEvent(RawKeyEvent event) {
    if (event is RawKeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.escape) {
        if (widget.dismissible) {
          widget.onClosed();
        }
      }
    }
  }

  void _close() {
    _controller.reverse().then((_) {
      widget.onClosed();
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final defaultWidth = screenWidth * 0.75;
    final maxWidth = 384.0;
    final finalWidth =
        widget.width ?? (defaultWidth < maxWidth ? defaultWidth : maxWidth);
    final finalHeight = widget.height ?? screenHeight * 0.5;

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, _) {
        return GestureDetector(
          onTap: widget.dismissible ? _close : null,
          child: Container(
            color: Colors.black.withOpacity(0.5 * _fadeAnimation.value),
            child: _buildSheet(finalWidth, finalHeight),
          ),
        );
      },
    );
  }

  Widget _buildSheet(double sheetWidth, double sheetHeight) {
    final colors = widget.colors.colors;
    final sheetContent = Container(
      decoration: BoxDecoration(
        color: colors.background,
        border: _getBorder(colors),
        boxShadow: [
          BoxShadow(
            color: colors.shadow.withOpacity(0.1),
            blurRadius: 8,
            offset: _getShadowOffset(),
          ),
        ],
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: widget.child,
          ),
          if (widget.showCloseButton)
            Positioned(
              top: 16,
              right: 16,
              child: GrafitSheetCloseButton(onPressed: _close),
            ),
        ],
      ),
    );

    switch (widget.side) {
      case GrafitSheetSide.top:
        return Positioned(
          top: -sheetHeight * (1 - _animation.value),
          left: 0,
          right: 0,
          height: sheetHeight,
          child: sheetContent,
        );

      case GrafitSheetSide.bottom:
        return Positioned(
          bottom: -sheetHeight * (1 - _animation.value),
          left: 0,
          right: 0,
          height: sheetHeight,
          child: sheetContent,
        );

      case GrafitSheetSide.left:
        return Positioned(
          left: -sheetWidth * (1 - _animation.value),
          top: 0,
          bottom: 0,
          width: sheetWidth,
          child: sheetContent,
        );

      case GrafitSheetSide.right:
      default:
        return Positioned(
          right: -sheetWidth * (1 - _animation.value),
          top: 0,
          bottom: 0,
          width: sheetWidth,
          child: sheetContent,
        );
    }
  }

  Border _getBorder(GrafitColorScheme colors) {
    switch (widget.side) {
      case GrafitSheetSide.top:
        return Border(bottom: BorderSide(color: colors.border));
      case GrafitSheetSide.bottom:
        return Border(top: BorderSide(color: colors.border));
      case GrafitSheetSide.left:
        return Border(right: BorderSide(color: colors.border));
      case GrafitSheetSide.right:
      default:
        return Border(left: BorderSide(color: colors.border));
    }
  }

  Offset _getShadowOffset() {
    switch (widget.side) {
      case GrafitSheetSide.top:
        return const Offset(0, 4);
      case GrafitSheetSide.bottom:
        return const Offset(0, -4);
      case GrafitSheetSide.left:
        return const Offset(4, 0);
      case GrafitSheetSide.right:
      default:
        return const Offset(-4, 0);
    }
  }
}
