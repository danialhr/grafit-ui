import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import '../../theme/theme.dart';

/// Navigation Menu viewport mode
enum GrafitNavigationMenuViewportMode {
  /// Content appears in a shared viewport below the menu
  viewport,
  /// Content appears directly below each trigger (popover-style)
  popover,
}

/// Main Navigation Menu component
/// A horizontal navigation menu with dropdown support
class GrafitNavigationMenu extends StatefulWidget {
  final List<Widget> children;
  final GrafitNavigationMenuViewportMode viewportMode;
  final ValueChanged<int>? onValueChange;
  final int? initialValue;

  const GrafitNavigationMenu({
    super.key,
    required this.children,
    this.viewportMode = GrafitNavigationMenuViewportMode.viewport,
    this.onValueChange,
    this.initialValue,
  });

  @override
  State<GrafitNavigationMenu> createState() => _GrafitNavigationMenuState();
}

class _GrafitNavigationMenuState extends State<GrafitNavigationMenu> {
  int? _activeIndex;
  final Map<int, OverlayEntry> _overlayEntries = {};
  final Map<int, GlobalKey> _triggerKeys = {};
  final Map<int, LayerLink> _layerLinks = {};
  int _focusedIndex = -1;

  @override
  void initState() {
    super.initState();
    _activeIndex = widget.initialValue;
  }

  @override
  void dispose() {
    for (var entry in _overlayEntries.values) {
      entry.remove();
    }
    super.dispose();
  }

  void _setActiveIndex(int? index) {
    setState(() {
      // Close all overlays except the new active one
      for (var entry in _overlayEntries.entries) {
        if (entry.key != index) {
          entry.value.remove();
        }
      }
      if (index != null && !_overlayEntries.containsKey(index)) {
        _activeIndex = index;
      } else if (index == null) {
        _activeIndex = null;
      }
    });
    widget.onValueChange?.call(index ?? -1);
  }

  void _registerTrigger(int index, GlobalKey key, LayerLink layerLink) {
    _triggerKeys[index] = key;
    _layerLinks[index] = layerLink;
  }

  void _showContent(int index, Widget content) {
    if (_overlayEntries.containsKey(index)) {
      _overlayEntries[index]!.remove();
      _overlayEntries.remove(index);
      _activeIndex = null;
      return;
    }

    final triggerKey = _triggerKeys[index];
    final layerLink = _layerLinks[index];

    if (triggerKey == null || layerLink == null) return;

    final overlayEntry = OverlayEntry(
      builder: (context) => _GrafitNavigationMenuViewport(
        triggerKey: triggerKey,
        layerLink: layerLink,
        content: content,
        colors: Theme.of(context).extension<GrafitTheme>()!.colors,
        onDismiss: () => _setActiveIndex(null),
      ),
    );

    _overlayEntries[index] = overlayEntry;
    Overlay.of(context).insert(overlayEntry);
    _activeIndex = index;
  }

  void _handleKeyDown(KeyEvent event) {
    if (event is! KeyDownEvent) return;

    final itemCount = widget.children.length;
    if (itemCount == 0) return;

    setState(() {
      switch (event.logicalKey) {
        case LogicalKeyboardKey.arrowRight:
          _focusedIndex = (_focusedIndex + 1) % itemCount;
          break;
        case LogicalKeyboardKey.arrowLeft:
          _focusedIndex = (_focusedIndex - 1 + itemCount) % itemCount;
          break;
        case LogicalKeyboardKey.arrowDown:
          if (_focusedIndex >= 0) {
            _setActiveIndex(_focusedIndex);
          }
          break;
        case LogicalKeyboardKey.enter:
        case LogicalKeyboardKey.space:
          if (_focusedIndex >= 0) {
            _setActiveIndex(_focusedIndex);
          }
          break;
        case LogicalKeyboardKey.escape:
          _setActiveIndex(null);
          break;
        case LogicalKeyboardKey.home:
          _focusedIndex = 0;
          break;
        case LogicalKeyboardKey.end:
          _focusedIndex = itemCount - 1;
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<GrafitTheme>()!;
    final colors = theme.colors;

    return Focus(
      onKeyEvent: (_, event) {
        _handleKeyDown(event);
        return KeyEventResult.handled;
      },
      child: _GrafitNavigationMenuScope(
        activeIndex: _activeIndex,
        focusedIndex: _focusedIndex,
        setActiveIndex: _setActiveIndex,
        showContent: _showContent,
        registerTrigger: _registerTrigger,
        updateFocusedIndex: (index) => setState(() => _focusedIndex = index),
        child: Container(
          alignment: Alignment.center,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: widget.children,
          ),
        ),
      ),
    );
  }
}

/// Inherited widget for navigation menu scope
class _GrafitNavigationMenuScope extends InheritedWidget {
  final int? activeIndex;
  final int focusedIndex;
  final ValueChanged<int?> setActiveIndex;
  final Function(int, Widget) showContent;
  final Function(int, GlobalKey, LayerLink) registerTrigger;
  final ValueChanged<int> updateFocusedIndex;

  const _GrafitNavigationMenuScope({
    required this.activeIndex,
    required this.focusedIndex,
    required this.setActiveIndex,
    required this.showContent,
    required this.registerTrigger,
    required this.updateFocusedIndex,
    required super.child,
  });

  static _GrafitNavigationMenuScope of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<_GrafitNavigationMenuScope>();
    if (scope == null) {
      throw Exception('_GrafitNavigationMenuScope not found in context');
    }
    return scope;
  }

  @override
  bool updateShouldNotify(_GrafitNavigationMenuScope oldWidget) {
    return activeIndex != oldWidget.activeIndex ||
        focusedIndex != oldWidget.focusedIndex;
  }
}

/// Navigation Menu List
/// Container for navigation menu items
class GrafitNavigationMenuList extends StatelessWidget {
  final List<Widget> children;

  const GrafitNavigationMenuList({
    super.key,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<GrafitTheme>()!;
    final colors = theme.colors;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: children,
    );
  }
}

/// Navigation Menu Item
/// Wrapper for individual navigation items
class GrafitNavigationMenuItem extends StatefulWidget {
  final Widget child;

  const GrafitNavigationMenuItem({
    super.key,
    required this.child,
  });

  @override
  State<GrafitNavigationMenuItem> createState() => _GrafitNavigationMenuItemState();
}

class _GrafitNavigationMenuItemState extends State<GrafitNavigationMenuItem> {
  final GlobalKey _triggerKey = GlobalKey();
  final LayerLink _layerLink = LayerLink();
  int? _index;

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      final scope = _GrafitNavigationMenuScope.of(context);
      // Find index from the parent menu
      final menuState = context.findAncestorStateOfType<_GrafitNavigationMenuState>();
      if (menuState != null) {
        // Register with parent
        menuState._registerTrigger(0, _triggerKey, _layerLink);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: GlobalKeyed(
        key: _triggerKey,
        child: widget.child,
      ),
    );
  }
}

/// Navigation Menu Trigger
/// Button that opens/closes the navigation menu content
class GrafitNavigationMenuTrigger extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;

  const GrafitNavigationMenuTrigger({
    super.key,
    required this.child,
    this.onTap,
  });

  @override
  State<GrafitNavigationMenuTrigger> createState() => _GrafitNavigationMenuTriggerState();
}

class _GrafitNavigationMenuTriggerState extends State<GrafitNavigationMenuTrigger> {
  bool _isHovered = false;
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<GrafitTheme>()!;
    final colors = theme.colors;
    final scope = _GrafitNavigationMenuScope.of(context);

    final isActive = scope.activeIndex != null;
    final isFocused = scope.focusedIndex != -1;

    Color backgroundColor = Colors.transparent;
    if (isActive) {
      backgroundColor = colors.accent.withOpacity(0.5);
    } else if (_isHovered) {
      backgroundColor = colors.accent;
    }

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          // Find the parent item index
          final menuItem = context.findAncestorWidgetOfExactType<GrafitNavigationMenuItem>();
          if (menuItem != null) {
            scope.setActiveIndex(isActive ? null : 0);
          }
          widget.onTap?.call();
        },
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) => setState(() => _isPressed = false),
        onTapCancel: () => setState(() => _isPressed = false),
        child: Focus(
          onFocusChange: (hasFocus) {
            final scope = _GrafitNavigationMenuScope.of(context);
            if (hasFocus) {
              // Update focused index
            }
          },
          child: Container(
            height: 36,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(colors.radius * 6),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                DefaultTextStyle(
                  style: TextStyle(
                    color: isActive || _isHovered
                        ? colors.accentForeground
                        : colors.foreground,
                    fontSize: 14,
                    fontWeight: isActive ? FontWeight.w500 : FontWeight.w400,
                  ),
                  child: widget.child,
                ),
                AnimatedRotation(
                  turns: isActive ? 0.5 : 0.0,
                  duration: const Duration(milliseconds: 300),
                  child: Icon(
                    Icons.keyboard_arrow_down,
                    size: 16,
                    color: isActive || _isHovered
                        ? colors.accentForeground
                        : colors.mutedForeground,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Navigation Menu Content
/// Content panel that appears below the trigger
class GrafitNavigationMenuContent extends StatelessWidget {
  final Widget child;

  const GrafitNavigationMenuContent({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return child;
  }
}

/// Navigation Menu Link
/// Clickable link item within navigation content
class GrafitNavigationMenuLink extends StatefulWidget {
  final Widget? leading;
  final Widget? trailing;
  final String? title;
  final String? description;
  final Widget? child;
  final VoidCallback? onSelect;
  final bool selected;
  final bool active;

  const GrafitNavigationMenuLink({
    super.key,
    this.leading,
    this.trailing,
    this.title,
    this.description,
    this.child,
    this.onSelect,
    this.selected = false,
    this.active = false,
  });

  @override
  State<GrafitNavigationMenuLink> createState() => _GrafitNavigationMenuLinkState();
}

class _GrafitNavigationMenuLinkState extends State<GrafitNavigationMenuLink> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<GrafitTheme>()!;
    final colors = theme.colors;

    final isActive = widget.active || widget.selected;
    final backgroundColor = isActive || _isHovered
        ? colors.accent.withOpacity(0.5)
        : Colors.transparent;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onSelect,
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(colors.radius * 4),
          ),
          child: Row(
            children: [
              if (widget.leading != null) ...[
                IconTheme(
                  data: IconThemeData(
                    color: colors.mutedForeground,
                    size: 16,
                  ),
                  child: widget.leading!,
                ),
                const SizedBox(width: 8),
              ],
              Expanded(
                child: widget.child ??
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (widget.title != null)
                          Text(
                            widget.title!,
                            style: TextStyle(
                              color: colors.foreground,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        if (widget.description != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            widget.description!,
                            style: TextStyle(
                              color: colors.mutedForeground,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ],
                    ),
              ],
              if (widget.trailing != null) ...[
                const SizedBox(width: 8),
                IconTheme(
                  data: IconThemeData(
                    color: colors.mutedForeground,
                    size: 16,
                  ),
                  child: widget.trailing!,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Navigation Menu Indicator
/// Visual indicator showing which item is active
class GrafitNavigationMenuIndicator extends StatelessWidget {
  final Widget? child;

  const GrafitNavigationMenuIndicator({
    super.key,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<GrafitTheme>()!;
    final colors = theme.colors;

    return child ??
        Container(
          height: 6,
          width: 6,
          decoration: BoxDecoration(
            color: colors.border,
            borderRadius: BorderRadius.circular(colors.radius),
          ),
        );
  }
}

/// Navigation Menu Viewport
/// Internal widget for rendering the viewport overlay
class _GrafitNavigationMenuViewport extends StatefulWidget {
  final GlobalKey triggerKey;
  final LayerLink layerLink;
  final Widget content;
  final GrafitColorScheme colors;
  final VoidCallback onDismiss;

  const _GrafitNavigationMenuViewport({
    required this.triggerKey,
    required this.layerLink,
    required this.content,
    required this.colors,
    required this.onDismiss,
  });

  @override
  State<_GrafitNavigationMenuViewport> createState() => _GrafitNavigationMenuViewportState();
}

class _GrafitNavigationMenuViewportState extends State<_GrafitNavigationMenuViewport>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

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
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final triggerContext = widget.triggerKey.currentContext;
    if (triggerContext == null) {
      return const SizedBox.shrink();
    }

    final renderBox = triggerContext.findRenderObject() as RenderBox?;
    if (renderBox == null) {
      return const SizedBox.shrink();
    }

    final position = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;

    return Positioned.fill(
      child: GestureDetector(
        onTap: widget.onDismiss,
        behavior: HitTestBehavior.translucent,
        child: CustomSingleChildLayout(
          delegate: _NavigationMenuViewportDelegate(
            layerLink: widget.layerLink,
            targetSize: size,
            targetPosition: position,
          ),
          child: AnimatedBuilder(
            animation: Listenable.merge([_scaleAnimation, _fadeAnimation]),
            builder: (context, child) {
              return Opacity(
                opacity: _fadeAnimation.value,
                child: Transform.scale(
                  scale: _scaleAnimation.value,
                  alignment: Alignment.topCenter,
                  child: child,
                ),
              );
            },
            child: Container(
              margin: const EdgeInsets.only(top: 6),
              constraints: const BoxConstraints(
                minWidth: 200,
                maxWidth: 400,
              ),
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
              padding: const EdgeInsets.all(8),
              child: widget.content,
            ),
          ),
        ),
      ),
    );
  }
}

/// Custom layout delegate for positioning navigation menu viewport
class _NavigationMenuViewportDelegate extends SingleChildLayoutDelegate {
  final LayerLink layerLink;
  final Size targetSize;
  final Offset targetPosition;

  _NavigationMenuViewportDelegate({
    required this.layerLink,
    required this.targetSize,
    required this.targetPosition,
  });

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    return BoxConstraints(
      minWidth: 200,
      maxWidth: 400,
    );
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    final link = layerLink.leaderOf(context);
    if (link == null || link.bounds == null) {
      return Offset.zero;
    }

    final targetBox = link.bounds!;
    double x = targetBox.left;
    double y = targetBox.top + targetSize.height + 6;

    // Center horizontally
    x += (targetSize.width - childSize.width) / 2;

    return Offset(x, y);
  }

  @override
  bool shouldRelayout(_NavigationMenuViewportDelegate oldDelegate) {
    return true;
  }
}

/// Helper function to create navigation menu trigger style
BoxDecoration navigationMenuTriggerStyle({
  required bool isOpen,
  required GrafitColorScheme colors,
}) {
  return BoxDecoration(
    color: isOpen ? colors.accent.withOpacity(0.5) : Colors.transparent,
    borderRadius: BorderRadius.circular(colors.radius * 6),
  );
}
