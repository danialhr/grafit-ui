import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import '../../theme/theme.dart';

/// Context menu item variant
enum GrafitContextMenuItemVariant {
  default,
  destructive,
}

/// Main Context Menu component - displays on right-click
class GrafitContextMenu extends StatefulWidget {
  final Widget child;
  final List<Widget> items;
  final bool disabled;

  const GrafitContextMenu({
    super.key,
    required this.child,
    required this.items,
    this.disabled = false,
  });

  @override
  State<GrafitContextMenu> createState() => _GrafitContextMenuState();
}

class _GrafitContextMenuState extends State<GrafitContextMenu>
    with SingleTickerProviderStateMixin {
  OverlayEntry? _overlayEntry;
  bool _isOpen = false;
  final GlobalKey _childKey = GlobalKey();
  final LayerLink _layerLink = LayerLink();
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  Offset? _tapPosition;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.95, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  void _showContextMenu(TapDownDetails details) {
    if (widget.disabled) return;

    // Get the render box of the child to calculate position
    final childContext = _childKey.currentContext;
    if (childContext == null) return;

    final renderBox = childContext.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    // Store tap position relative to the screen
    setState(() {
      _tapPosition = details.globalPosition;
      _isOpen = true;
    });

    _controller.forward();
    setState(() {
      _overlayEntry = OverlayEntry(
        builder: (context) => _buildContextMenuContent(),
      );
      Overlay.of(context).insert(_overlayEntry!);
    });
  }

  void _hideContextMenu() {
    _controller.reverse().then((_) {
      _overlayEntry?.remove();
      setState(() {
        _overlayEntry = null;
        _isOpen = false;
        _tapPosition = null;
      });
    });
  }

  @override
  void dispose() {
    _overlayEntry?.remove();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: GestureDetector(
        onSecondaryTapDown: widget.disabled ? null : _showContextMenu,
        onLongPressStart: widget.disabled ? null : (details) => _showContextMenu(
          TapDownDetails(
            globalPosition: details.globalPosition,
            localPosition: details.localPosition,
          ),
        ),
        child: GlobalKeyed(
          key: _childKey,
          child: widget.child,
        ),
      ),
    );
  }

  Widget _buildContextMenuContent() {
    final theme = Theme.of(context).extension<GrafitTheme>()!;
    final colors = theme.colors;

    return _GrafitContextMenuContent(
      layerLink: _layerLink,
      tapPosition: _tapPosition ?? Offset.zero,
      colors: colors,
      theme: theme,
      items: widget.items,
      onDismiss: _hideContextMenu,
      scaleAnimation: _scaleAnimation,
      fadeAnimation: _fadeAnimation,
    );
  }
}

/// Internal context menu content widget
class _GrafitContextMenuContent extends StatefulWidget {
  final LayerLink layerLink;
  final Offset tapPosition;
  final GrafitColorScheme colors;
  final GrafitTheme theme;
  final List<Widget> items;
  final VoidCallback onDismiss;
  final Animation<double> scaleAnimation;
  final Animation<double> fadeAnimation;

  const _GrafitContextMenuContent({
    required this.layerLink,
    required this.tapPosition,
    required this.colors,
    required this.theme,
    required this.items,
    required this.onDismiss,
    required this.scaleAnimation,
    required this.fadeAnimation,
  });

  @override
  State<_GrafitContextMenuContent> createState() =>
      _GrafitContextMenuContentState();
}

class _GrafitContextMenuContentState extends State<_GrafitContextMenuContent> {
  int _focusedIndex = -1;
  final ScrollController _scrollController = ScrollController();
  final List<GlobalKey> _itemKeys = [];

  @override
  void initState() {
    super.initState();
    _itemKeys.addAll(List.generate(widget.items.length, (_) => GlobalKey()));
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _handleKeyDown(KeyEvent event) {
    if (event is! KeyDownEvent) return;

    final itemCount = widget.items.length;
    if (itemCount == 0) return;

    setState(() {
      switch (event.logicalKey) {
        case LogicalKeyboardKey.arrowDown:
          _focusedIndex = (_focusedIndex + 1) % itemCount;
          break;
        case LogicalKeyboardKey.arrowUp:
          _focusedIndex = (_focusedIndex - 1 + itemCount) % itemCount;
          break;
        case LogicalKeyboardKey.enter:
        case LogicalKeyboardKey.space:
          if (_focusedIndex >= 0) {
            _activateItem(_focusedIndex);
          }
          break;
        case LogicalKeyboardKey.escape:
          widget.onDismiss();
          break;
        case LogicalKeyboardKey.home:
          _focusedIndex = 0;
          break;
        case LogicalKeyboardKey.end:
          _focusedIndex = itemCount - 1;
          break;
      }
    });

    _scrollToFocusedItem();
  }

  void _activateItem(int index) {
    final key = _itemKeys[index];
    final context = key.currentContext;
    if (context != null) {
      final GrafitContextMenuItem? item =
          context.findAncestorWidgetOfExactType<GrafitContextMenuItem>();
      item?.onSelected?.call();
    }
    widget.onDismiss();
  }

  void _scrollToFocusedItem() {
    if (_focusedIndex < 0 || _focusedIndex >= _itemKeys.length) return;

    final key = _itemKeys[_focusedIndex];
    final context = key.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        alignment: 0.5,
        duration: const Duration(milliseconds: 100),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Focus(
        onKeyEvent: (_, event) {
          _handleKeyDown(event);
          return KeyEventResult.handled;
        },
        autofocus: true,
        child: GestureDetector(
          onTap: widget.onDismiss,
          behavior: HitTestBehavior.translucent,
          child: CustomSingleChildLayout(
            delegate: _ContextMenuLayoutDelegate(
              tapPosition: widget.tapPosition,
            ),
            child: AnimatedBuilder(
              animation: Listenable.merge(
                  [widget.scaleAnimation, widget.fadeAnimation]),
              builder: (context, child) {
                return Opacity(
                  opacity: widget.fadeAnimation.value,
                  child: Transform.scale(
                    scale: widget.scaleAnimation.value,
                    alignment: Alignment.topLeft,
                    child: child,
                  ),
                );
              },
              child: Container(
                constraints: BoxConstraints(
                  minWidth: 128,
                  maxWidth: 256,
                  maxHeight: MediaQuery.of(context).size.height * 0.5,
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
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(widget.colors.radius * 6),
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(4),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: List.generate(widget.items.length, (index) {
                        return Focus(
                          canRequestFocus: true,
                          onFocusChange: (hasFocus) {
                            if (hasFocus) {
                              setState(() => _focusedIndex = index);
                            } else if (_focusedIndex == index) {
                              setState(() => _focusedIndex = -1);
                            }
                          },
                          child: GlobalKeyed(
                            key: _itemKeys[index],
                            child: widget.items[index],
                          ),
                        );
                      }),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Custom layout delegate for positioning context menu at tap position
class _ContextMenuLayoutDelegate extends SingleChildLayoutDelegate {
  final Offset tapPosition;

  _ContextMenuLayoutDelegate({
    required this.tapPosition,
  });

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    return BoxConstraints(
      minWidth: 128,
      maxWidth: 256,
    );
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    double x = tapPosition.dx;
    double y = tapPosition.dy;

    // Adjust position if menu would go off screen
    if (x + childSize.width > size.width) {
      x = size.width - childSize.width - 8;
    }
    if (y + childSize.height > size.height) {
      y = size.height - childSize.height - 8;
    }

    // Ensure menu doesn't go off left or top edge
    if (x < 8) x = 8;
    if (y < 8) y = 8;

    return Offset(x, y);
  }

  @override
  bool shouldRelayout(_ContextMenuLayoutDelegate oldDelegate) {
    return tapPosition != oldDelegate.tapPosition;
  }
}

/// Context Menu Trigger - wrapper for the child widget
class GrafitContextMenuTrigger extends StatelessWidget {
  final Widget child;

  const GrafitContextMenuTrigger({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return child;
  }
}

/// Context Menu Content - wrapper for menu items
class GrafitContextMenuContent extends StatelessWidget {
  final List<Widget> children;

  const GrafitContextMenuContent({
    super.key,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: children,
    );
  }
}

/// Context Menu Group - groups related items
class GrafitContextMenuGroup extends StatelessWidget {
  final List<Widget> children;

  const GrafitContextMenuGroup({
    super.key,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: children,
    );
  }
}

/// Context Menu Item
class GrafitContextMenuItem extends StatefulWidget {
  final Widget? leading;
  final Widget? trailing;
  final String? label;
  final Widget? child;
  final VoidCallback? onSelected;
  final bool enabled;
  final GrafitContextMenuItemVariant variant;
  final bool inset;
  final String? shortcut;

  const GrafitContextMenuItem({
    super.key,
    this.leading,
    this.trailing,
    this.label,
    this.child,
    this.onSelected,
    this.enabled = true,
    this.variant = GrafitContextMenuItemVariant.default,
    this.inset = false,
    this.shortcut,
  });

  @override
  State<GrafitContextMenuItem> createState() => _GrafitContextMenuItemState();
}

class _GrafitContextMenuItemState extends State<GrafitContextMenuItem> {
  bool _isHovered = false;
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<GrafitTheme>()!;
    final colors = theme.colors;

    final isDestructive = widget.variant == GrafitContextMenuItemVariant.destructive;
    final effectiveEnabled = widget.enabled;

    Color foregroundColor;
    Color backgroundColor;

    if (!effectiveEnabled) {
      foregroundColor = colors.mutedForeground.withOpacity(0.5);
      backgroundColor = Colors.transparent;
    } else if (isDestructive) {
      foregroundColor = colors.destructive;
      backgroundColor = _isHovered
          ? colors.destructive.withOpacity(0.1)
          : (_isPressed ? colors.destructive.withOpacity(0.15) : Colors.transparent);
    } else {
      foregroundColor = _isHovered || _isPressed
          ? colors.accentForeground
          : colors.foreground;
      backgroundColor = _isHovered || _isPressed
          ? colors.accent
          : Colors.transparent;
    }

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: effectiveEnabled ? SystemMouseCursors.click : MouseCursor.deferred,
      child: GestureDetector(
        onTap: effectiveEnabled ? widget.onSelected : null,
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) => setState(() => _isPressed = false),
        onTapCancel: () => setState(() => _isPressed = false),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: widget.inset ? 32 : 8,
            vertical: 6,
          ),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(colors.radius * 4),
          ),
          child: Row(
            children: [
              if (widget.leading != null) ...[
                IconTheme(
                  data: IconThemeData(
                    color: isDestructive
                        ? colors.destructive
                        : (_isHovered || _isPressed
                            ? colors.accentForeground
                            : colors.mutedForeground),
                    size: 16,
                  ),
                  child: widget.leading!,
                ),
                const SizedBox(width: 8),
              ],
              Expanded(
                child: DefaultTextStyle(
                  style: TextStyle(
                    color: foregroundColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                  child: widget.child ??
                      (widget.label != null
                          ? Text(widget.label!)
                          : const SizedBox.shrink()),
                ),
              ),
              if (widget.shortcut != null) ...[
                const SizedBox(width: 8),
                GrafitContextMenuShortcut(label: widget.shortcut!),
              ],
              if (widget.trailing != null) ...[
                const SizedBox(width: 8),
                IconTheme(
                  data: IconThemeData(
                    color: foregroundColor.withOpacity(0.6),
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

/// Context Menu Checkbox Item
class GrafitContextMenuCheckboxItem extends StatefulWidget {
  final Widget? leading;
  final String? label;
  final Widget? child;
  final bool checked;
  final ValueChanged<bool>? onChecked;
  final bool enabled;

  const GrafitContextMenuCheckboxItem({
    super.key,
    this.leading,
    this.label,
    this.child,
    this.checked = false,
    this.onChecked,
    this.enabled = true,
  });

  @override
  State<GrafitContextMenuCheckboxItem> createState() =>
      _GrafitContextMenuCheckboxItemState();
}

class _GrafitContextMenuCheckboxItemState
    extends State<GrafitContextMenuCheckboxItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<GrafitTheme>()!;
    final colors = theme.colors;

    final foregroundColor = widget.enabled
        ? (_isHovered ? colors.accentForeground : colors.foreground)
        : colors.mutedForeground.withOpacity(0.5);
    final backgroundColor =
        widget.enabled && _isHovered ? colors.accent : Colors.transparent;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: widget.enabled ? SystemMouseCursors.click : MouseCursor.deferred,
      child: GestureDetector(
        onTap: widget.enabled
            ? () => widget.onChecked?.call(!widget.checked)
            : null,
        child: Container(
          padding: const EdgeInsets.only(left: 8, right: 8, top: 6, bottom: 6),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(colors.radius * 4),
          ),
          child: Row(
            children: [
              SizedBox(
                width: 16,
                height: 16,
                child: Transform.translate(
                  offset: const Offset(-8, 0),
                  child: Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color: widget.checked ? colors.primary : colors.background,
                      border: Border.all(
                        color: widget.checked ? colors.primary : colors.border,
                        width: 1.5,
                      ),
                      borderRadius: BorderRadius.circular(colors.radius * 2),
                    ),
                    child: widget.checked
                        ? Center(
                            child: Icon(
                              Icons.check,
                              size: 12,
                              color: colors.primaryForeground,
                            ),
                          )
                        : null,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: DefaultTextStyle(
                  style: TextStyle(
                    color: foregroundColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                  child: widget.child ??
                      (widget.label != null
                          ? Text(widget.label!)
                          : const SizedBox.shrink()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Context Menu Radio Group
class GrafitContextMenuRadioGroup<T> extends StatefulWidget {
  final List<GrafitContextMenuRadioItem<T>> items;
  final T? value;
  final ValueChanged<T>? onValueChanged;
  final bool enabled;

  const GrafitContextMenuRadioGroup({
    super.key,
    required this.items,
    this.value,
    this.onValueChanged,
    this.enabled = true,
  });

  @override
  State<GrafitContextMenuRadioGroup<T>> createState() =>
      _GrafitContextMenuRadioGroupState<T>();
}

class _GrafitContextMenuRadioGroupState<T>
    extends State<GrafitContextMenuRadioGroup<T>> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: widget.items.map((item) {
        return GrafitContextMenuRadioItem<T>(
          value: item.value,
          label: item.label,
          child: item.child,
          groupValue: widget.value,
          onChanged: widget.enabled ? widget.onValueChanged : null,
          enabled: widget.enabled && item.enabled,
        );
      }).toList(),
    );
  }
}

/// Context Menu Radio Item
class GrafitContextMenuRadioItem<T> extends StatefulWidget {
  final T value;
  final String? label;
  final Widget? child;
  final T? groupValue;
  final ValueChanged<T>? onChanged;
  final bool enabled;

  const GrafitContextMenuRadioItem({
    super.key,
    required this.value,
    this.label,
    this.child,
    this.groupValue,
    this.onChanged,
    this.enabled = true,
  });

  @override
  State<GrafitContextMenuRadioItem<T>> createState() =>
      _GrafitContextMenuRadioItemState<T>();
}

class _GrafitContextMenuRadioItemState<T>
    extends State<GrafitContextMenuRadioItem<T>> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<GrafitTheme>()!;
    final colors = theme.colors;
    final isSelected = widget.value == widget.groupValue;

    final foregroundColor = widget.enabled
        ? (_isHovered ? colors.accentForeground : colors.foreground)
        : colors.mutedForeground.withOpacity(0.5);
    final backgroundColor =
        widget.enabled && _isHovered ? colors.accent : Colors.transparent;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: widget.enabled ? SystemMouseCursors.click : MouseCursor.deferred,
      child: GestureDetector(
        onTap: widget.enabled
            ? () => widget.onChanged?.call(widget.value)
            : null,
        child: Container(
          padding: const EdgeInsets.only(left: 8, right: 8, top: 6, bottom: 6),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(colors.radius * 4),
          ),
          child: Row(
            children: [
              SizedBox(
                width: 16,
                height: 16,
                child: Transform.translate(
                  offset: const Offset(-8, 0),
                  child: Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color: colors.background,
                      border: Border.all(
                        color: isSelected ? colors.primary : colors.border,
                        width: 1.5,
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: isSelected
                        ? Center(
                            child: Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: colors.primary,
                                shape: BoxShape.circle,
                              ),
                            ),
                          )
                        : null,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: DefaultTextStyle(
                  style: TextStyle(
                    color: foregroundColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                  child: widget.child ??
                      (widget.label != null
                          ? Text(widget.label!)
                          : const SizedBox.shrink()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Context Menu Label
class GrafitContextMenuLabel extends StatelessWidget {
  final String? label;
  final Widget? child;
  final bool inset;

  const GrafitContextMenuLabel({
    super.key,
    this.label,
    this.child,
    this.inset = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<GrafitTheme>()!;
    final colors = theme.colors;

    return Padding(
      padding: EdgeInsets.only(
        left: inset ? 32 : 8,
        right: 8,
        top: 4,
        bottom: 4,
      ),
      child: DefaultTextStyle(
        style: TextStyle(
          color: colors.foreground,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        child: child ??
            (label != null ? Text(label!) : const SizedBox.shrink()),
      ),
    );
  }
}

/// Context Menu Separator
class GrafitContextMenuSeparator extends StatelessWidget {
  const GrafitContextMenuSeparator({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<GrafitTheme>()!;
    final colors = theme.colors;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Divider(
        height: 8,
        thickness: 1,
        color: colors.border,
      ),
    );
  }
}

/// Context Menu Shortcut - displays keyboard shortcut text
class GrafitContextMenuShortcut extends StatelessWidget {
  final String label;

  const GrafitContextMenuShortcut({
    super.key,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<GrafitTheme>()!;
    final colors = theme.colors;

    return Text(
      label,
      style: TextStyle(
        color: colors.mutedForeground,
        fontSize: 11,
        letterSpacing: 0.5,
      ),
    );
  }
}

/// Context Menu Sub - nested submenu
class GrafitContextMenuSub extends StatefulWidget {
  final Widget trigger;
  final List<Widget> children;
  final bool inset;

  const GrafitContextMenuSub({
    super.key,
    required this.trigger,
    required this.children,
    this.inset = false,
  });

  @override
  State<GrafitContextMenuSub> createState() => _GrafitContextMenuSubState();
}

class _GrafitContextMenuSubState extends State<GrafitContextMenuSub> {
  bool _isOpen = false;

  void _toggle() {
    setState(() => _isOpen = !_isOpen);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<GrafitTheme>()!;
    final colors = theme.colors;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: _toggle,
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: widget.inset ? 32 : 8,
            vertical: 6,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(colors.radius * 4),
          ),
          child: Row(
            children: [
              Expanded(child: widget.trigger),
              Icon(
                Icons.chevron_right,
                size: 16,
                color: colors.mutedForeground,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Context Menu Sub Trigger
class GrafitContextMenuSubTrigger extends StatelessWidget {
  final Widget? leading;
  final String? label;
  final Widget? child;
  final bool inset;

  const GrafitContextMenuSubTrigger({
    super.key,
    this.leading,
    this.label,
    this.child,
    this.inset = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<GrafitTheme>()!;
    final colors = theme.colors;

    return Row(
      children: [
        if (leading != null) ...[
          IconTheme(
            data: IconThemeData(
              color: colors.mutedForeground,
              size: 16,
            ),
            child: leading!,
          ),
          const SizedBox(width: 8),
        ],
        Expanded(
          child: DefaultTextStyle(
            style: TextStyle(
              color: colors.foreground,
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
            child: child ??
                (label != null ? Text(label!) : const SizedBox.shrink()),
          ),
        ),
      ],
    );
  }
}

/// Context Menu Sub Content
class GrafitContextMenuSubContent extends StatelessWidget {
  final List<Widget> children;

  const GrafitContextMenuSubContent({
    super.key,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: children,
    );
  }
}

/// Context Menu Portal - wrapper for overlay portal (equivalent to Radix Portal)
class GrafitContextMenuPortal extends StatelessWidget {
  final Widget child;

  const GrafitContextMenuPortal({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return child;
  }
}
