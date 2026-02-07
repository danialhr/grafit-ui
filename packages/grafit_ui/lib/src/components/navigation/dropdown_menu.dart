import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import '../../theme/theme.dart';
import '../form/button.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

/// Dropdown menu alignment options
enum GrafitDropdownMenuAlignment {
  top,
  bottom,
  left,
  right,
  topLeft,
  topRight,
  bottomLeft,
  bottomRight,
}

/// Dropdown menu item variant
enum GrafitDropdownMenuItemVariant {
  default,
  destructive,
}

/// Main Dropdown Menu component
class GrafitDropdownMenu extends StatefulWidget {
  final Widget trigger;
  final List<Widget> children;
  final GrafitDropdownMenuAlignment? alignment;
  final double? sideOffset;
  final bool dismissible;
  final bool open;
  final ValueChanged<bool>? onOpenChange;

  const GrafitDropdownMenu({
    super.key,
    required this.trigger,
    required this.children,
    this.alignment,
    this.sideOffset,
    this.dismissible = true,
    this.open = false,
    this.onOpenChange,
  });

  @override
  State<GrafitDropdownMenu> createState() => _GrafitDropdownMenuState();
}

class _GrafitDropdownMenuState extends State<GrafitDropdownMenu>
    with SingleTickerProviderStateMixin {
  OverlayEntry? _overlayEntry;
  bool _isOpen = false;
  final GlobalKey _triggerKey = GlobalKey();
  final LayerLink _layerLink = LayerLink();
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _isOpen = widget.open;
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

    if (_isOpen) {
      _showDropdown();
    }
  }

  @override
  void didUpdateWidget(GrafitDropdownMenu oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.open != _isOpen) {
      setState(() {
        _isOpen = widget.open;
        if (_isOpen) {
          _showDropdown();
        } else {
          _hideDropdown();
        }
      });
    }
  }

  void _toggle() {
    setState(() {
      _isOpen = !_isOpen;
      widget.onOpenChange?.call(_isOpen);
      if (_isOpen) {
        _showDropdown();
      } else {
        _hideDropdown();
      }
    });
  }

  void _showDropdown() {
    if (_overlayEntry != null) return;

    setState(() {
      _overlayEntry = OverlayEntry(
        builder: (context) => _buildDropdownContent(),
      );
      Overlay.of(context).insert(_overlayEntry!);
      _controller.forward();
    });
  }

  void _hideDropdown() {
    _controller.reverse().then((_) {
      _overlayEntry?.remove();
      setState(() {
        _overlayEntry = null;
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
        onTap: _toggle,
        child: GlobalKeyed(
          key: _triggerKey,
          child: widget.trigger,
        ),
      ),
    );
  }

  Widget _buildDropdownContent() {
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

    return _GrafitDropdownMenuContent(
      layerLink: _layerLink,
      targetSize: size,
      targetPosition: position,
      alignment: widget.alignment ?? GrafitDropdownMenuAlignment.bottom,
      sideOffset: widget.sideOffset ?? 4,
      colors: colors,
      theme: theme,
      children: widget.children,
      onDismiss: widget.dismissible ? () => _toggle() : null,
      scaleAnimation: _scaleAnimation,
      fadeAnimation: _fadeAnimation,
    );
  }
}

/// Internal dropdown menu content widget
class _GrafitDropdownMenuContent extends StatefulWidget {
  final LayerLink layerLink;
  final Size targetSize;
  final Offset targetPosition;
  final GrafitDropdownMenuAlignment alignment;
  final double sideOffset;
  final GrafitColorScheme colors;
  final GrafitTheme theme;
  final List<Widget> children;
  final VoidCallback? onDismiss;
  final Animation<double> scaleAnimation;
  final Animation<double> fadeAnimation;

  const _GrafitDropdownMenuContent({
    required this.layerLink,
    required this.targetSize,
    required this.targetPosition,
    required this.alignment,
    required this.sideOffset,
    required this.colors,
    required this.theme,
    required this.children,
    this.onDismiss,
    required this.scaleAnimation,
    required this.fadeAnimation,
  });

  @override
  State<_GrafitDropdownMenuContent> createState() =>
      _GrafitDropdownMenuContentState();
}

class _GrafitDropdownMenuContentState extends State<_GrafitDropdownMenuContent> {
  int _focusedIndex = -1;
  final ScrollController _scrollController = ScrollController();
  final List<GlobalKey> _itemKeys = [];

  @override
  void initState() {
    super.initState();
    _itemKeys.addAll(List.generate(widget.children.length, (_) => GlobalKey()));
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _handleKeyDown(KeyEvent event) {
    if (event is! KeyDownEvent) return;

    final itemCount = widget.children.length;
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
          widget.onDismiss?.call();
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
      final GrafiDropdownMenuItem? item =
          context.findAncestorWidgetOfExactType<GrafiDropdownMenuItem>();
      item?.onSelected?.call();
    }
    widget.onDismiss?.call();
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
        child: GestureDetector(
          onTap: widget.onDismiss,
          behavior: HitTestBehavior.translucent,
          child: CustomSingleChildLayout(
            delegate: _DropdownMenuLayoutDelegate(
              layerLink: widget.layerLink,
              targetSize: widget.targetSize,
              targetPosition: widget.targetPosition,
              alignment: widget.alignment,
              sideOffset: widget.sideOffset,
            ),
            child: AnimatedBuilder(
              animation: Listenable.merge([widget.scaleAnimation, widget.fadeAnimation]),
              builder: (context, child) {
                return Opacity(
                  opacity: widget.fadeAnimation.value,
                  child: Transform.scale(
                    scale: widget.scaleAnimation.value,
                    alignment: _getScaleAlignment(),
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
                      children: List.generate(widget.children.length, (index) {
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
                            child: widget.children[index],
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

  Alignment _getScaleAlignment() {
    switch (widget.alignment) {
      case GrafitDropdownMenuAlignment.top:
      case GrafitDropdownMenuAlignment.topLeft:
      case GrafitDropdownMenuAlignment.topRight:
        return Alignment.bottomCenter;
      case GrafitDropdownMenuAlignment.bottom:
      case GrafitDropdownMenuAlignment.bottomLeft:
      case GrafitDropdownMenuAlignment.bottomRight:
        return Alignment.topCenter;
      case GrafitDropdownMenuAlignment.left:
        return Alignment.centerRight;
      case GrafitDropdownMenuAlignment.right:
        return Alignment.centerLeft;
    }
  }
}

/// Custom layout delegate for positioning dropdown menu
class _DropdownMenuLayoutDelegate extends SingleChildLayoutDelegate {
  final LayerLink layerLink;
  final Size targetSize;
  final Offset targetPosition;
  final GrafitDropdownMenuAlignment alignment;
  final double sideOffset;

  _DropdownMenuLayoutDelegate({
    required this.layerLink,
    required this.targetSize,
    required this.targetPosition,
    required this.alignment,
    required this.sideOffset,
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
    final link = layerLink.leaderOf(context);
    if (link == null || link.bounds == null) {
      return Offset.zero;
    }

    final targetBox = link.bounds!;
    double x = targetBox.left;
    double y = targetBox.top;

    switch (alignment) {
      case GrafitDropdownMenuAlignment.top:
        x += (targetSize.width - childSize.width) / 2;
        y -= childSize.height + sideOffset;
        break;
      case GrafitDropdownMenuAlignment.bottom:
        x += (targetSize.width - childSize.width) / 2;
        y += targetSize.height + sideOffset;
        break;
      case GrafitDropdownMenuAlignment.left:
        x -= childSize.width + sideOffset;
        y += (targetSize.height - childSize.height) / 2;
        break;
      case GrafitDropdownMenuAlignment.right:
        x += targetSize.width + sideOffset;
        y += (targetSize.height - childSize.height) / 2;
        break;
      case GrafitDropdownMenuAlignment.topLeft:
        x -= childSize.width;
        y -= childSize.height;
        break;
      case GrafitDropdownMenuAlignment.topRight:
        x += targetSize.width;
        y -= childSize.height;
        break;
      case GrafitDropdownMenuAlignment.bottomLeft:
        x -= childSize.width;
        y += targetSize.height;
        break;
      case GrafitDropdownMenuAlignment.bottomRight:
        x += targetSize.width;
        y += targetSize.height;
        break;
    }

    return Offset(x, y);
  }

  @override
  bool shouldRelayout(_DropdownMenuLayoutDelegate oldDelegate) {
    return true;
  }
}

/// Dropdown Menu Trigger button
class GrafitDropdownMenuTrigger extends StatelessWidget {
  final Widget child;

  const GrafitDropdownMenuTrigger({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return child;
  }
}

/// Dropdown Menu Content wrapper
class GrafitDropdownMenuContent extends StatelessWidget {
  final List<Widget> children;

  const GrafitDropdownMenuContent({
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

/// Dropdown Menu Group
class GrafitDropdownMenuGroup extends StatelessWidget {
  final List<Widget> children;

  const GrafitDropdownMenuGroup({
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

/// Dropdown Menu Item
class GrafiDropdownMenuItem extends StatefulWidget {
  final Widget? leading;
  final Widget? trailing;
  final String? label;
  final Widget? child;
  final VoidCallback? onSelected;
  final bool enabled;
  final GrafitDropdownMenuItemVariant variant;
  final bool inset;
  final String? shortcut;

  const GrafiDropdownMenuItem({
    super.key,
    this.leading,
    this.trailing,
    this.label,
    this.child,
    this.onSelected,
    this.enabled = true,
    this.variant = GrafitDropdownMenuItemVariant.default,
    this.inset = false,
    this.shortcut,
  });

  @override
  State<GrafiDropdownMenuItem> createState() => _GrafiDropdownMenuItemState();
}

class _GrafiDropdownMenuItemState extends State<GrafiDropdownMenuItem> {
  bool _isHovered = false;
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<GrafitTheme>()!;
    final colors = theme.colors;

    final isDestructive = widget.variant == GrafitDropdownMenuItemVariant.destructive;
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
                    color: foregroundColor,
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
                      (widget.label != null ? Text(widget.label!) : const SizedBox.shrink()),
                ),
              ),
              if (widget.shortcut != null) ...[
                const SizedBox(width: 8),
                GrafitDropdownMenuShortcut(label: widget.shortcut!),
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

/// Dropdown Menu Checkbox Item
class GrafitDropdownMenuCheckboxItem extends StatefulWidget {
  final Widget? leading;
  final String? label;
  final Widget? child;
  final bool checked;
  final ValueChanged<bool>? onChecked;
  final bool enabled;

  const GrafitDropdownMenuCheckboxItem({
    super.key,
    this.leading,
    this.label,
    this.child,
    this.checked = false,
    this.onChecked,
    this.enabled = true,
  });

  @override
  State<GrafitDropdownMenuCheckboxItem> createState() =>
      _GrafitDropdownMenuCheckboxItemState();
}

class _GrafitDropdownMenuCheckboxItemState
    extends State<GrafitDropdownMenuCheckboxItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<GrafitTheme>()!;
    final colors = theme.colors;

    final foregroundColor = widget.enabled
        ? (_isHovered ? colors.accentForeground : colors.foreground)
        : colors.mutedForeground.withOpacity(0.5);
    final backgroundColor = widget.enabled && _isHovered
        ? colors.accent
        : Colors.transparent;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: widget.enabled ? SystemMouseCursors.click : MouseCursor.deferred,
      child: GestureDetector(
        onTap: widget.enabled ? () => widget.onChecked?.call(!widget.checked) : null,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(colors.radius * 4),
          ),
          child: Row(
            children: [
              Container(
                width: 16,
                height: 16,
                margin: const EdgeInsets.only(left: 8, right: 8),
                decoration: BoxDecoration(
                  color: widget.checked ? colors.primary : colors.background,
                  border: Border.all(
                    color: widget.checked ? colors.primary : colors.border,
                    width: 1.5,
                  ),
                  borderRadius: BorderRadius.circular(colors.radius * 2),
                ),
                child: widget.checked
                    ? Icon(
                        Icons.check,
                        size: 12,
                        color: colors.primaryForeground,
                      )
                    : null,
              ),
              Expanded(
                child: DefaultTextStyle(
                  style: TextStyle(
                    color: foregroundColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                  child: widget.child ??
                      (widget.label != null ? Text(widget.label!) : const SizedBox.shrink()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Dropdown Menu Radio Group
class GrafitDropdownMenuRadioGroup<T> extends StatefulWidget {
  final List<GrafitDropdownMenuRadioItem<T>> items;
  final T? value;
  final ValueChanged<T>? onValueChanged;
  final bool enabled;

  const GrafitDropdownMenuRadioGroup({
    super.key,
    required this.items,
    this.value,
    this.onValueChanged,
    this.enabled = true,
  });

  @override
  State<GrafitDropdownMenuRadioGroup<T>> createState() =>
      _GrafitDropdownMenuRadioGroupState<T>();
}

class _GrafitDropdownMenuRadioGroupState<T>
    extends State<GrafitDropdownMenuRadioGroup<T>> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: widget.items.map((item) {
        return GrafitDropdownMenuRadioItem<T>(
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

/// Dropdown Menu Radio Item
class GrafitDropdownMenuRadioItem<T> extends StatefulWidget {
  final T value;
  final String? label;
  final Widget? child;
  final T? groupValue;
  final ValueChanged<T>? onChanged;
  final bool enabled;

  const GrafitDropdownMenuRadioItem({
    super.key,
    required this.value,
    this.label,
    this.child,
    this.groupValue,
    this.onChanged,
    this.enabled = true,
  });

  @override
  State<GrafitDropdownMenuRadioItem<T>> createState() =>
      _GrafitDropdownMenuRadioItemState<T>();
}

class _GrafitDropdownMenuRadioItemState<T>
    extends State<GrafitDropdownMenuRadioItem<T>> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<GrafitTheme>()!;
    final colors = theme.colors;
    final isSelected = widget.value == widget.groupValue;

    final foregroundColor = widget.enabled
        ? (_isHovered ? colors.accentForeground : colors.foreground)
        : colors.mutedForeground.withOpacity(0.5);
    final backgroundColor = widget.enabled && _isHovered
        ? colors.accent
        : Colors.transparent;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: widget.enabled ? SystemMouseCursors.click : MouseCursor.deferred,
      child: GestureDetector(
        onTap: widget.enabled ? () => widget.onChanged?.call(widget.value) : null,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(colors.radius * 4),
          ),
          child: Row(
            children: [
              Container(
                width: 16,
                height: 16,
                margin: const EdgeInsets.only(left: 8, right: 8),
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
              Expanded(
                child: DefaultTextStyle(
                  style: TextStyle(
                    color: foregroundColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                  child: widget.child ??
                      (widget.label != null ? Text(widget.label!) : const SizedBox.shrink()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Dropdown Menu Label
class GrafitDropdownMenuLabel extends StatelessWidget {
  final String? label;
  final Widget? child;
  final bool inset;

  const GrafitDropdownMenuLabel({
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
        child: child ?? (label != null ? Text(label!) : const SizedBox.shrink()),
      ),
    );
  }
}

/// Dropdown Menu Separator
class GrafitDropdownMenuSeparator extends StatelessWidget {
  const GrafitDropdownMenuSeparator({super.key});

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

/// Dropdown Menu Shortcut
class GrafitDropdownMenuShortcut extends StatelessWidget {
  final String label;

  const GrafitDropdownMenuShortcut({
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

/// Dropdown Menu Sub
class GrafitDropdownMenuSub extends StatefulWidget {
  final Widget trigger;
  final List<Widget> children;

  const GrafitDropdownMenuSub({
    super.key,
    required this.trigger,
    required this.children,
  });

  @override
  State<GrafitDropdownMenuSub> createState() => _GrafitDropdownMenuSubState();
}

class _GrafitDropdownMenuSubState extends State<GrafitDropdownMenuSub> {
  bool _isOpen = false;

  void _toggle() {
    setState(() => _isOpen = !_isOpen);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        GestureDetector(
          onTap: _toggle,
          child: Row(
            children: [
              Expanded(child: widget.trigger),
              Icon(
                _isOpen ? Icons.expand_more : Icons.chevron_right,
                size: 16,
              ),
            ],
          ),
        ),
        if (_isOpen)
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: widget.children,
            ),
          ),
      ],
    );
  }
}

/// Dropdown Menu Sub Trigger
class GrafitDropdownMenuSubTrigger extends StatelessWidget {
  final Widget? leading;
  final String? label;
  final Widget? child;
  final bool inset;

  const GrafitDropdownMenuSubTrigger({
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

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: inset ? 32 : 8,
        vertical: 6,
      ),
      child: Row(
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
              child: child ?? (label != null ? Text(label!) : const SizedBox.shrink()),
            ),
          ),
        ],
      ),
    );
  }
}

/// Dropdown Menu Sub Content
class GrafitDropdownMenuSubContent extends StatelessWidget {
  final List<Widget> children;

  const GrafitDropdownMenuSubContent({
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

// Widgetbook use cases
@widgetbook.UseCase(
  name: 'Default',
  type: GrafitDropdownMenu,
  path: 'Navigation/Dropdown Menu',
)
Widget dropdownMenuDefault(BuildContext context) {
  return Center(
    child: GrafitDropdownMenu(
      trigger: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: Color(0xFFe5e7eb)),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Options'),
            SizedBox(width: 8),
            Icon(Icons.arrow_drop_down, size: 20),
          ],
        ),
      ),
      children: const [
        GrafiDropdownMenuItem(
          label: 'Profile',
          leading: Icon(Icons.person_outlined, size: 16),
        ),
        GrafiDropdownMenuItem(
          label: 'Settings',
          leading: Icon(Icons.settings_outlined, size: 16),
        ),
        GrafiDropdownMenuItem(
          label: 'Logout',
          leading: Icon(Icons.logout, size: 16),
        ),
      ],
    ),
  );
}

@widgetbook.UseCase(
  name: 'With Shortcuts',
  type: GrafitDropdownMenu,
  path: 'Navigation/Dropdown Menu',
)
Widget dropdownMenuWithShortcuts(BuildContext context) {
  return Center(
    child: GrafitDropdownMenu(
      trigger: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: Color(0xFFe5e7eb)),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Edit'),
            SizedBox(width: 8),
            Icon(Icons.arrow_drop_down, size: 20),
          ],
        ),
      ),
      children: const [
        GrafiDropdownMenuItem(
          label: 'Cut',
          leading: Icon(Icons.content_cut, size: 16),
          shortcut: '⌘X',
        ),
        GrafiDropdownMenuItem(
          label: 'Copy',
          leading: Icon(Icons.content_copy, size: 16),
          shortcut: '⌘C',
        ),
        GrafiDropdownMenuItem(
          label: 'Paste',
          leading: Icon(Icons.content_paste, size: 16),
          shortcut: '⌘V',
        ),
        GrafitDropdownMenuSeparator(),
        GrafiDropdownMenuItem(
          label: 'Select All',
          leading: Icon(Icons.select_all, size: 16),
          shortcut: '⌘A',
        ),
      ],
    ),
  );
}

@widgetbook.UseCase(
  name: 'With Destructive',
  type: GrafitDropdownMenu,
  path: 'Navigation/Dropdown Menu',
)
Widget dropdownMenuWithDestructive(BuildContext context) {
  return Center(
    child: GrafitDropdownMenu(
      trigger: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: Color(0xFFe5e7eb)),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Actions'),
            SizedBox(width: 8),
            Icon(Icons.arrow_drop_down, size: 20),
          ],
        ),
      ),
      children: const [
        GrafiDropdownMenuItem(
          label: 'View',
          leading: Icon(Icons.visibility_outlined, size: 16),
        ),
        GrafiDropdownMenuItem(
          label: 'Edit',
          leading: Icon(Icons.edit_outlined, size: 16),
        ),
        GrafiDropdownMenuItem(
          label: 'Duplicate',
          leading: Icon(Icons.copy, size: 16),
        ),
        GrafitDropdownMenuSeparator(),
        GrafiDropdownMenuItem(
          label: 'Delete',
          leading: Icon(Icons.delete_outlined, size: 16),
          variant: GrafitDropdownMenuItemVariant.destructive,
        ),
      ],
    ),
  );
}

@widgetbook.UseCase(
  name: 'With Checkboxes',
  type: GrafitDropdownMenu,
  path: 'Navigation/Dropdown Menu',
)
Widget dropdownMenuWithCheckboxes(BuildContext context) {
  return Center(
    child: GrafitDropdownMenu(
      trigger: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: Color(0xFFe5e7eb)),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('View'),
            SizedBox(width: 8),
            Icon(Icons.arrow_drop_down, size: 20),
          ],
        ),
      ),
      children: const [
        GrafitDropdownMenuCheckboxItem(
          label: 'Show Status Bar',
          checked: true,
        ),
        GrafitDropdownMenuCheckboxItem(
          label: 'Show Toolbar',
          checked: true,
        ),
        GrafitDropdownMenuCheckboxItem(
          label: 'Show Sidebar',
          checked: false,
        ),
      ],
    ),
  );
}

@widgetbook.UseCase(
  name: 'With Radio Group',
  type: GrafitDropdownMenu,
  path: 'Navigation/Dropdown Menu',
)
Widget dropdownMenuWithRadioGroup(BuildContext context) {
  return Center(
    child: GrafitDropdownMenu(
      trigger: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: Color(0xFFe5e7eb)),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Theme'),
            SizedBox(width: 8),
            Icon(Icons.arrow_drop_down, size: 20),
          ],
        ),
      ),
      children: [
        GrafitDropdownMenuRadioGroup<String>(
          value: 'system',
          onValueChanged: (value) {},
          items: const [
            GrafitDropdownMenuRadioItem(
              value: 'light',
              label: 'Light',
            ),
            GrafitDropdownMenuRadioItem(
              value: 'dark',
              label: 'Dark',
            ),
            GrafitDropdownMenuRadioItem(
              value: 'system',
              label: 'System',
            ),
          ],
        ),
      ],
    ),
  );
}

@widgetbook.UseCase(
  name: 'With Labels',
  type: GrafitDropdownMenu,
  path: 'Navigation/Dropdown Menu',
)
Widget dropdownMenuWithLabels(BuildContext context) {
  return Center(
    child: GrafitDropdownMenu(
      trigger: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: Color(0xFFe5e7eb)),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Share'),
            SizedBox(width: 8),
            Icon(Icons.arrow_drop_down, size: 20),
          ],
        ),
      ),
      children: const [
        GrafitDropdownMenuLabel(label: 'Send to'),
        GrafiDropdownMenuItem(
          label: 'Email',
          leading: Icon(Icons.email_outlined, size: 16),
        ),
        GrafiDropdownMenuItem(
          label: 'Messages',
          leading: Icon(Icons.message_outlined, size: 16),
        ),
        GrafitDropdownMenuSeparator(),
        GrafitDropdownMenuLabel(label: 'Social'),
        GrafiDropdownMenuItem(
          label: 'Twitter',
          leading: Icon(Icons.alternate_email, size: 16),
        ),
        GrafiDropdownMenuItem(
          label: 'Facebook',
          leading: Icon(Icons.facebook, size: 16),
        ),
      ],
    ),
  );
}

@widgetbook.UseCase(
  name: 'Disabled Items',
  type: GrafitDropdownMenu,
  path: 'Navigation/Dropdown Menu',
)
Widget dropdownMenuDisabledItems(BuildContext context) {
  return Center(
    child: GrafitDropdownMenu(
      trigger: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: Color(0xFFe5e7eb)),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('File'),
            SizedBox(width: 8),
            Icon(Icons.arrow_drop_down, size: 20),
          ],
        ),
      ),
      children: const [
        GrafiDropdownMenuItem(
          label: 'New',
          leading: Icon(Icons.add, size: 16),
        ),
        GrafiDropdownMenuItem(
          label: 'Open',
          leading: Icon(Icons.folder_open, size: 16),
          enabled: false,
        ),
        GrafiDropdownMenuItem(
          label: 'Save',
          leading: Icon(Icons.save, size: 16),
          enabled: false,
        ),
        GrafitDropdownMenuSeparator(),
        GrafiDropdownMenuItem(
          label: 'Print',
          leading: Icon(Icons.print, size: 16),
        ),
      ],
    ),
  );
}

@widgetbook.UseCase(
  name: 'With Submenu',
  type: GrafitDropdownMenu,
  path: 'Navigation/Dropdown Menu',
)
Widget dropdownMenuWithSubmenu(BuildContext context) {
  return Center(
    child: GrafitDropdownMenu(
      trigger: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: Color(0xFFe5e7eb)),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Insert'),
            SizedBox(width: 8),
            Icon(Icons.arrow_drop_down, size: 20),
          ],
        ),
      ),
      children: [
        GrafiDropdownMenuItem(
          label: 'Image',
          leading: Icon(Icons.image_outlined, size: 16),
        ),
        GrafitDropdownMenuSub(
          trigger: GrafitDropdownMenuSubTrigger(
            leading: Icon(Icons.table_chart_outlined, size: 16),
            label: 'Table',
          ),
          children: const [
            GrafiDropdownMenuItem(
              label: '1x1',
              inset: true,
            ),
            GrafiDropdownMenuItem(
              label: '2x2',
              inset: true,
            ),
            GrafiDropdownMenuItem(
              label: '3x3',
              inset: true,
            ),
          ],
        ),
      ],
    ),
  );
}

@widgetbook.UseCase(
  name: 'Interactive',
  type: GrafitDropdownMenu,
  path: 'Navigation/Dropdown Menu',
)
Widget dropdownMenuInteractive(BuildContext context) {
  // Widgetbook-only: ignore undefined_getter, undefined_method, invalid_annotation_value
  final alignmentIndex = context.knobs.list(
    label: 'Alignment',
    options: ['bottom', 'top', 'left', 'right', 'topLeft', 'topRight', 'bottomLeft', 'bottomRight'],
    initialOption: 'bottom',
  );
  // Widgetbook-only: ignore undefined_getter, undefined_method, invalid_annotation_value
  final showShortcuts = context.knobs.boolean(label: 'Show Shortcuts', initialValue: true);
  // Widgetbook-only: ignore undefined_getter, undefined_method, invalid_annotation_value
  final showIcons = context.knobs.boolean(label: 'Show Icons', initialValue: true);
  // Widgetbook-only: ignore undefined_getter, undefined_method, invalid_annotation_value
  final showSeparators = context.knobs.boolean(label: 'Show Separators', initialValue: true);
  // Widgetbook-only: ignore undefined_getter, undefined_method, invalid_annotation_value
  final itemCount = context.knobs.int.slider(
    label: 'Items',
    initialValue: 4,
    min: 2,
    max: 8,
  );
  // Widgetbook-only: ignore undefined_getter, undefined_method, invalid_annotation_value
  final hasDisabled = context.knobs.boolean(label: 'Has Disabled Items', initialValue: true);

  final alignment = GrafitDropdownMenuAlignment.values[
      alignmentIndex == 'bottom' ? 0 :
      alignmentIndex == 'top' ? 1 :
      alignmentIndex == 'left' ? 2 :
      alignmentIndex == 'right' ? 3 :
      alignmentIndex == 'topLeft' ? 4 :
      alignmentIndex == 'topRight' ? 5 :
      alignmentIndex == 'bottomLeft' ? 6 : 7];

  final items = List.generate(itemCount, (index) {
    final labels = ['New', 'Open', 'Save', 'Export', 'Print', 'Share', 'Settings', 'Help'];
    final icons = [
      Icons.add, Icons.folder_open, Icons.save, Icons.file_download,
      Icons.print, Icons.share, Icons.settings, Icons.help_outline
    ];
    final shortcuts = ['⌘N', '⌘O', '⌘S', '⌘E', '⌘P', null, '⌘,', '?'];

    return GrafiDropdownMenuItem(
      label: labels[index],
      leading: showIcons ? Icon(icons[index], size: 16) : null,
      shortcut: showShortcuts ? shortcuts[index] : null,
      enabled: hasDisabled && index == 1 ? false : true,
    );
  });

  final childrenWithSeparators = <Widget>[];
  for (int i = 0; i < items.length; i++) {
    childrenWithSeparators.add(items[i]);
    if (showSeparators && i == 1 && i < items.length - 1) {
      childrenWithSeparators.add(const GrafitDropdownMenuSeparator());
    }
  }

  return Center(
    child: GrafitDropdownMenu(
      alignment: alignment,
      trigger: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: Color(0xFFe5e7eb)),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Menu'),
            SizedBox(width: 8),
            Icon(Icons.arrow_drop_down, size: 20),
          ],
        ),
      ),
      children: childrenWithSeparators,
    ),
  );
}
