import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import '../../theme/theme.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

/// Menubar menu item variant
enum GrafitMenubarMenuItemVariant {
  default,
  destructive,
}

/// Main MenuBar component
///
/// A horizontally oriented menu bar that displays dropdown menus from each item.
/// Provides keyboard navigation and follows the shadcn-ui design system.
class GrafitMenubar extends StatefulWidget {
  final List<GrafitMenubarMenu> children;

  const GrafitMenubar({
    super.key,
    required this.children,
  });

  @override
  State<GrafitMenubar> createState() => _GrafitMenubarState();
}

class _GrafitMenubarState extends State<GrafitMenubar> {
  int? _openMenuIndex;
  final List<GlobalKey> _menuKeys = [];
  final List<GlobalKey> _triggerKeys = [];

  @override
  void initState() {
    super.initState();
    _menuKeys.addAll(List.generate(widget.children.length, (_) => GlobalKey()));
    _triggerKeys.addAll(List.generate(widget.children.length, (_) => GlobalKey()));
  }

  void _openMenu(int index) {
    setState(() {
      if (_openMenuIndex == index) {
        _openMenuIndex = null;
      } else {
        _openMenuIndex = index;
      }
    });
  }

  void _closeMenu() {
    setState(() {
      _openMenuIndex = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<GrafitTheme>()!;
    final colors = theme.colors;

    return Container(
      height: 36,
      decoration: BoxDecoration(
        color: colors.background,
        borderRadius: BorderRadius.circular(colors.radius * 6),
        border: Border.all(color: colors.border),
        boxShadow: [
          BoxShadow(
            color: colors.shadow.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(widget.children.length, (index) {
          return _MenubarMenuItem(
            key: _triggerKeys[index],
            menu: widget.children[index],
            isOpen: _openMenuIndex == index,
            onPressed: () => _openMenu(index),
            onClose: _closeMenu,
            triggerKey: _triggerKeys[index],
            menuKey: _menuKeys[index],
          );
        }),
      ),
    );
  }
}

/// Internal menu item widget
class _MenubarMenuItem extends StatefulWidget {
  final GrafitMenubarMenu menu;
  final bool isOpen;
  final VoidCallback onPressed;
  final VoidCallback onClose;
  final GlobalKey triggerKey;
  final GlobalKey menuKey;

  const _MenubarMenuItem({
    super.key,
    required this.menu,
    required this.isOpen,
    required this.onPressed,
    required this.onClose,
    required this.triggerKey,
    required this.menuKey,
  });

  @override
  State<_MenubarMenuItem> createState() => _MenubarMenuItemState();
}

class _MenubarMenuItemState extends State<_MenubarMenuItem>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  OverlayEntry? _overlayEntry;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  final LayerLink _layerLink = LayerLink();

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
  }

  @override
  void didUpdateWidget(_MenubarMenuItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isOpen != oldWidget.isOpen) {
      if (widget.isOpen) {
        _showDropdown();
      } else {
        _hideDropdown();
      }
    }
  }

  void _showDropdown() {
    if (_overlayEntry != null) return;

    setState(() {
      _overlayEntry = OverlayEntry(
        builder: (context) => _GrafitMenubarContent(
          layerLink: _layerLink,
          menu: widget.menu,
          colors: Theme.of(context).extension<GrafitTheme>()!.colors,
          onDismiss: widget.onClose,
          scaleAnimation: _scaleAnimation,
          fadeAnimation: _fadeAnimation,
        ),
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
    final theme = Theme.of(context).extension<GrafitTheme>()!;
    final colors = theme.colors;

    final backgroundColor = widget.isOpen || _isHovered
        ? colors.accent
        : Colors.transparent;
    final foregroundColor = widget.isOpen || _isHovered
        ? colors.accentForeground
        : colors.foreground;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: CompositedTransformTarget(
        link: _layerLink,
        child: GestureDetector(
          onTap: widget.onPressed,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(colors.radius * 4),
            ),
            child: DefaultTextStyle(
              style: TextStyle(
                color: foregroundColor,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              child: widget.menu.trigger,
            ),
          ),
        ),
      ),
    );
  }
}

/// Internal menubar content dropdown
class _GrafitMenubarContent extends StatefulWidget {
  final LayerLink layerLink;
  final GrafitMenubarMenu menu;
  final GrafitColorScheme colors;
  final VoidCallback onDismiss;
  final Animation<double> scaleAnimation;
  final Animation<double> fadeAnimation;

  const _GrafitMenubarContent({
    required this.layerLink,
    required this.menu,
    required this.colors,
    required this.onDismiss,
    required this.scaleAnimation,
    required this.fadeAnimation,
  });

  @override
  State<_GrafitMenubarContent> createState() => _GrafitMenubarContentState();
}

class _GrafitMenubarContentState extends State<_GrafitMenubarContent> {
  int _focusedIndex = -1;
  final ScrollController _scrollController = ScrollController();
  late final List<GlobalKey> _itemKeys;

  @override
  void initState() {
    super.initState();
    _itemKeys = List.generate(widget.menu.children.length, (_) => GlobalKey());
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _handleKeyDown(KeyEvent event) {
    if (event is! KeyDownEvent) return;

    final itemCount = widget.menu.children.length;
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
        case LogicalKeyboardKey.arrowLeft:
          widget.onDismiss();
          break;
      }
    });

    _scrollToFocusedItem();
  }

  void _activateItem(int index) {
    final key = _itemKeys[index];
    final context = key.currentContext;
    if (context != null) {
      final GrafitMenubarItem? item =
          context.findAncestorWidgetOfExactType<GrafitMenubarItem>();
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
        child: GestureDetector(
          onTap: widget.onDismiss,
          behavior: HitTestBehavior.translucent,
          child: CustomSingleChildLayout(
            delegate: _MenubarLayoutDelegate(
              layerLink: widget.layerLink,
            ),
            child: AnimatedBuilder(
              animation: Listenable.merge([widget.scaleAnimation, widget.fadeAnimation]),
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
                constraints: const BoxConstraints(
                  minWidth: 192,
                  maxWidth: 320,
                  maxHeight: 400,
                ),
                margin: const EdgeInsets.only(top: 4),
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
                      children: List.generate(widget.menu.children.length, (index) {
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
                            child: widget.menu.children[index],
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

/// Layout delegate for menubar positioning
class _MenubarLayoutDelegate extends SingleChildLayoutDelegate {
  final LayerLink layerLink;

  _MenubarLayoutDelegate({
    required this.layerLink,
  });

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    return const BoxConstraints(
      minWidth: 192,
      maxWidth: 320,
    );
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    final link = layerLink.leaderOf(context);
    if (link == null || link.bounds == null) {
      return Offset.zero;
    }

    final targetBox = link.bounds!;
    return Offset(
      targetBox.left,
      targetBox.bottom + 4,
    );
  }

  @override
  bool shouldRelayout(_MenubarLayoutDelegate oldDelegate) {
    return true;
  }
}

/// Menubar Menu
///
/// Represents a single menu in the menubar with its trigger and content items.
class GrafitMenubarMenu {
  final Widget trigger;
  final List<Widget> children;

  const GrafitMenubarMenu({
    required this.trigger,
    required this.children,
  });
}

/// Menubar Trigger
///
/// The trigger button for a menu item.
class GrafitMenubarTrigger extends StatelessWidget {
  final Widget child;

  const GrafitMenubarTrigger({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return child;
  }
}

/// Menubar Content
///
/// Wrapper for menu items within a menu.
class GrafitMenubarContent extends StatelessWidget {
  final List<Widget> children;

  const GrafitMenubarContent({
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

/// Menubar Group
///
/// Groups related menu items together.
class GrafitMenubarGroup extends StatelessWidget {
  final List<Widget> children;

  const GrafitMenubarGroup({
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

/// Menubar Item
///
/// A selectable menu item with optional leading/trailing icons and shortcut text.
class GrafitMenubarItem extends StatefulWidget {
  final Widget? leading;
  final Widget? trailing;
  final String? label;
  final Widget? child;
  final VoidCallback? onSelected;
  final bool enabled;
  final GrafitMenubarMenuItemVariant variant;
  final bool inset;
  final String? shortcut;

  const GrafitMenubarItem({
    super.key,
    this.leading,
    this.trailing,
    this.label,
    this.child,
    this.onSelected,
    this.enabled = true,
    this.variant = GrafitMenubarMenuItemVariant.default,
    this.inset = false,
    this.shortcut,
  });

  @override
  State<GrafitMenubarItem> createState() => _GrafitMenubarItemState();
}

class _GrafitMenubarItemState extends State<GrafitMenubarItem> {
  bool _isHovered = false;
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<GrafitTheme>()!;
    final colors = theme.colors;

    final isDestructive = widget.variant == GrafitMenubarMenuItemVariant.destructive;
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
      foregroundColor = colors.foreground;
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
                GrafitMenuBarShortcut(label: widget.shortcut!),
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

/// Menubar Checkbox Item
///
/// A menu item with a checkbox that can be toggled.
class GrafitMenubarCheckboxItem extends StatefulWidget {
  final Widget? leading;
  final String? label;
  final Widget? child;
  final bool checked;
  final ValueChanged<bool>? onChecked;
  final bool enabled;

  const GrafitMenubarCheckboxItem({
    super.key,
    this.leading,
    this.label,
    this.child,
    this.checked = false,
    this.onChecked,
    this.enabled = true,
  });

  @override
  State<GrafitMenubarCheckboxItem> createState() =>
      _GrafitMenubarCheckboxItemState();
}

class _GrafitMenubarCheckboxItemState
    extends State<GrafitMenubarCheckboxItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<GrafitTheme>()!;
    final colors = theme.colors;

    final foregroundColor = widget.enabled
        ? colors.foreground
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
          padding: const EdgeInsets.only(left: 32, right: 8, top: 6, bottom: 6),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(colors.radius * 4),
          ),
          child: Row(
            children: [
              SizedBox(
                width: 14,
                height: 14,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                        color: widget.checked ? colors.primary : Colors.transparent,
                        border: Border.all(
                          color: widget.checked ? colors.primary : colors.border,
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.circular(colors.radius * 2),
                      ),
                    ),
                    if (widget.checked)
                      Icon(
                        Icons.check,
                        size: 10,
                        color: colors.primaryForeground,
                      ),
                  ],
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

/// Menubar Radio Group
///
/// A group of mutually exclusive radio items.
class GrafitMenubarRadioGroup<T> extends StatefulWidget {
  final List<GrafitMenubarRadioItem<T>> items;
  final T? value;
  final ValueChanged<T>? onValueChanged;
  final bool enabled;

  const GrafitMenubarRadioGroup({
    super.key,
    required this.items,
    this.value,
    this.onValueChanged,
    this.enabled = true,
  });

  @override
  State<GrafitMenubarRadioGroup<T>> createState() =>
      _GrafitMenubarRadioGroupState<T>();
}

class _GrafitMenubarRadioGroupState<T>
    extends State<GrafitMenubarRadioGroup<T>> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: widget.items.map((item) {
        return GrafitMenubarRadioItem<T>(
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

/// Menubar Radio Item
///
/// A single radio item within a radio group.
class GrafitMenubarRadioItem<T> extends StatefulWidget {
  final T value;
  final String? label;
  final Widget? child;
  final T? groupValue;
  final ValueChanged<T>? onChanged;
  final bool enabled;

  const GrafitMenubarRadioItem({
    super.key,
    required this.value,
    this.label,
    this.child,
    this.groupValue,
    this.onChanged,
    this.enabled = true,
  });

  @override
  State<GrafitMenubarRadioItem<T>> createState() =>
      _GrafitMenubarRadioItemState<T>();
}

class _GrafitMenubarRadioItemState<T>
    extends State<GrafitMenubarRadioItem<T>> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<GrafitTheme>()!;
    final colors = theme.colors;
    final isSelected = widget.value == widget.groupValue;

    final foregroundColor = widget.enabled
        ? colors.foreground
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
          padding: const EdgeInsets.only(left: 32, right: 8, top: 6, bottom: 6),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(colors.radius * 4),
          ),
          child: Row(
            children: [
              SizedBox(
                width: 14,
                height: 14,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                        color: colors.background,
                        border: Border.all(
                          color: isSelected ? colors.primary : colors.border,
                          width: 1.5,
                        ),
                        shape: BoxShape.circle,
                      ),
                    ),
                    if (isSelected)
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: colors.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                  ],
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

/// Menubar Label
///
/// A non-interactive label within a menu.
class GrafitMenubarLabel extends StatelessWidget {
  final String? label;
  final Widget? child;
  final bool inset;

  const GrafitMenubarLabel({
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

/// Menubar Separator
///
/// A horizontal line separator between menu items.
class GrafitMenubarSeparator extends StatelessWidget {
  const GrafitMenubarSeparator({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<GrafitTheme>()!;
    final colors = theme.colors;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      child: Container(
        height: 1,
        color: colors.border,
      ),
    );
  }
}

/// Menubar Shortcut
///
/// Displays keyboard shortcut text in a menu item.
class GrafitMenuBarShortcut extends StatelessWidget {
  final String label;

  const GrafitMenuBarShortcut({
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

/// Menubar Sub
///
/// A nested submenu with its own trigger and content.
class GrafitMenubarSub extends StatefulWidget {
  final Widget trigger;
  final List<Widget> children;

  const GrafitMenubarSub({
    super.key,
    required this.trigger,
    required this.children,
  });

  @override
  State<GrafitMenubarSub> createState() => _GrafitMenubarSubState();
}

class _GrafitMenubarSubState extends State<GrafitMenubarSub> {
  bool _isOpen = false;

  void _toggle() {
    setState(() => _isOpen = !_isOpen);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<GrafitTheme>()!;
    final colors = theme.colors;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: _toggle,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              decoration: BoxDecoration(
                color: _isOpen ? colors.accent : Colors.transparent,
                borderRadius: BorderRadius.circular(colors.radius * 4),
              ),
              child: Row(
                children: [
                  Expanded(child: widget.trigger),
                  Icon(
                    Icons.chevron_right,
                    size: 16,
                    color: _isOpen ? colors.accentForeground : colors.mutedForeground,
                  ),
                ],
              ),
            ),
          ),
        ),
        if (_isOpen)
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Container(
              decoration: BoxDecoration(
                color: colors.popover,
                border: Border.all(color: colors.border),
                borderRadius: BorderRadius.circular(colors.radius * 6),
              ),
              padding: const EdgeInsets.all(4),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: widget.children,
              ),
            ),
          ),
      ],
    );
  }
}

/// Menubar Sub Trigger
///
/// The trigger button for a submenu.
class GrafitMenubarSubTrigger extends StatelessWidget {
  final Widget? leading;
  final String? label;
  final Widget? child;
  final bool inset;

  const GrafitMenubarSubTrigger({
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

/// Menubar Sub Content
///
/// Content wrapper for submenu items.
class GrafitMenubarSubContent extends StatelessWidget {
  final List<Widget> children;

  const GrafitMenubarSubContent({
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
  type: GrafitMenubar,
  path: 'Navigation/Menubar',
)
Widget menubarDefault(BuildContext context) {
  return GrafitMenubar(
    children: [
      GrafitMenubarMenu(
        trigger: GrafitMenubarTrigger(child: Text('File')),
        children: const [
          GrafitMenubarItem(
            label: 'New Tab',
            leading: Icon(Icons.add, size: 16),
          ),
          GrafitMenubarItem(
            label: 'New Window',
            leading: Icon(Icons.open_in_new, size: 16),
          ),
          GrafitMenubarSeparator(),
          GrafitMenubarItem(
            label: 'Save',
            leading: Icon(Icons.save, size: 16),
            shortcut: '⌘S',
          ),
          GrafitMenubarItem(
            label: 'Print',
            leading: Icon(Icons.print, size: 16),
            shortcut: '⌘P',
          ),
        ],
      ),
      GrafitMenubarMenu(
        trigger: GrafitMenubarTrigger(child: Text('Edit')),
        children: const [
          GrafitMenubarItem(
            label: 'Undo',
            leading: Icon(Icons.undo, size: 16),
            shortcut: '⌘Z',
          ),
          GrafitMenubarItem(
            label: 'Redo',
            leading: Icon(Icons.redo, size: 16),
            shortcut: '⌘⇧Z',
          ),
          GrafitMenubarSeparator(),
          GrafitMenubarItem(
            label: 'Cut',
            leading: Icon(Icons.content_cut, size: 16),
            shortcut: '⌘X',
          ),
          GrafitMenubarItem(
            label: 'Copy',
            leading: Icon(Icons.content_copy, size: 16),
            shortcut: '⌘C',
          ),
        ],
      ),
      GrafitMenubarMenu(
        trigger: GrafitMenubarTrigger(child: Text('View')),
        children: const [
          GrafitMenubarItem(
            label: 'Zoom In',
            leading: Icon(Icons.zoom_in, size: 16),
            shortcut: '⌘+',
          ),
          GrafitMenubarItem(
            label: 'Zoom Out',
            leading: Icon(Icons.zoom_out, size: 16),
            shortcut: '⌘-',
          ),
        ],
      ),
    ],
  );
}

@widgetbook.UseCase(
  name: 'With Destructive',
  type: GrafitMenubar,
  path: 'Navigation/Menubar',
)
Widget menubarDestructive(BuildContext context) {
  return GrafitMenubar(
    children: [
      GrafitMenubarMenu(
        trigger: GrafitMenubarTrigger(child: Text('Actions')),
        children: const [
          GrafitMenubarItem(
            label: 'Duplicate',
            leading: Icon(Icons.copy, size: 16),
          ),
          GrafitMenubarItem(
            label: 'Share',
            leading: Icon(Icons.share, size: 16),
          ),
          GrafitMenubarSeparator(),
          GrafitMenubarItem(
            label: 'Delete',
            leading: Icon(Icons.delete, size: 16),
            variant: GrafitMenubarMenuItemVariant.destructive,
          ),
        ],
      ),
    ],
  );
}

@widgetbook.UseCase(
  name: 'With Checkbox Items',
  type: GrafitMenubar,
  path: 'Navigation/Menubar',
)
Widget menubarCheckboxItems(BuildContext context) {
  return GrafitMenubar(
    children: [
      GrafitMenubarMenu(
        trigger: GrafitMenubarTrigger(child: Text('View')),
        children: const [
          GrafitMenubarCheckboxItem(
            label: 'Show Sidebar',
            checked: true,
          ),
          GrafitMenubarCheckboxItem(
            label: 'Show Toolbar',
            checked: true,
          ),
          GrafitMenubarCheckboxItem(
            label: 'Show Status Bar',
            checked: false,
          ),
          GrafitMenubarSeparator(),
          GrafitMenubarItem(
            label: 'Customize...',
            leading: Icon(Icons.tune, size: 16),
          ),
        ],
      ),
    ],
  );
}

@widgetbook.UseCase(
  name: 'With Radio Group',
  type: GrafitMenubar,
  path: 'Navigation/Menubar',
)
Widget menubarRadioGroup(BuildContext context) {
  return GrafitMenubar(
    children: [
      GrafitMenubarMenu(
        trigger: GrafitMenubarTrigger(child: Text('Appearance')),
        children: [
          GrafitMenubarRadioGroup<String>(
            value: 'system',
            onValueChanged: (value) {},
            items: const [
              GrafitMenubarRadioItem(
                value: 'light',
                label: 'Light',
              ),
              GrafitMenubarRadioItem(
                value: 'dark',
                label: 'Dark',
              ),
              GrafitMenubarRadioItem(
                value: 'system',
                label: 'System',
              ),
            ],
          ),
        ],
      ),
    ],
  );
}

@widgetbook.UseCase(
  name: 'With Submenu',
  type: GrafitMenubar,
  path: 'Navigation/Menubar',
)
Widget menubarSubmenu(BuildContext context) {
  return GrafitMenubar(
    children: [
      GrafitMenubarMenu(
        trigger: GrafitMenubarTrigger(child: Text('File')),
        children: [
          GrafitMenubarItem(
            label: 'New',
            leading: Icon(Icons.add, size: 16),
          ),
          GrafitMenubarSub(
            trigger: GrafitMenubarSubTrigger(
              leading: Icon(Icons.open_in_new, size: 16),
              label: 'Open Recent',
            ),
            children: const [
              GrafitMenubarItem(
                label: 'project1.dart',
                inset: true,
              ),
              GrafitMenubarItem(
                label: 'project2.dart',
                inset: true,
              ),
              GrafitMenubarSeparator(),
              GrafitMenubarItem(
                label: 'Clear Recent',
                inset: true,
              ),
            ],
          ),
        ],
      ),
    ],
  );
}

@widgetbook.UseCase(
  name: 'With Labels',
  type: GrafitMenubar,
  path: 'Navigation/Menubar',
)
Widget menubarLabels(BuildContext context) {
  return GrafitMenubar(
    children: [
      GrafitMenubarMenu(
        trigger: GrafitMenubarTrigger(child: Text('Bookmarks')),
        children: const [
          GrafitMenubarLabel(label: 'Recently Bookmarked'),
          GrafitMenubarItem(
            label: 'Home Page',
            leading: Icon(Icons.home, size: 16),
          ),
          GrafitMenubarItem(
            label: 'Documentation',
            leading: Icon(Icons.book, size: 16),
          ),
          GrafitMenubarSeparator(),
          GrafitMenubarLabel(label: 'Folders'),
          GrafitMenubarItem(
            label: 'Work',
            leading: Icon(Icons.folder, size: 16),
          ),
          GrafitMenubarItem(
            label: 'Personal',
            leading: Icon(Icons.folder, size: 16),
          ),
        ],
      ),
    ],
  );
}

@widgetbook.UseCase(
  name: 'Disabled Items',
  type: GrafitMenubar,
  path: 'Navigation/Menubar',
)
Widget menubarDisabledItems(BuildContext context) {
  return GrafitMenubar(
    children: [
      GrafitMenubarMenu(
        trigger: GrafitMenubarTrigger(child: Text('Edit')),
        children: const [
          GrafitMenubarItem(
            label: 'Undo',
            leading: Icon(Icons.undo, size: 16),
            shortcut: '⌘Z',
            enabled: false,
          ),
          GrafitMenubarItem(
            label: 'Redo',
            leading: Icon(Icons.redo, size: 16),
            shortcut: '⌘⇧Z',
            enabled: false,
          ),
          GrafitMenubarSeparator(),
          GrafitMenubarItem(
            label: 'Cut',
            leading: Icon(Icons.content_cut, size: 16),
            shortcut: '⌘X',
          ),
          GrafitMenubarItem(
            label: 'Copy',
            leading: Icon(Icons.content_copy, size: 16),
            shortcut: '⌘C',
          ),
        ],
      ),
    ],
  );
}

@widgetbook.UseCase(
  name: 'Multiple Menus',
  type: GrafitMenubar,
  path: 'Navigation/Menubar',
)
Widget menubarMultiple(BuildContext context) {
  return GrafitMenubar(
    children: [
      GrafitMenubarMenu(
        trigger: GrafitMenubarTrigger(child: Text('File')),
        children: const [
          GrafitMenubarItem(label: 'New', leading: Icon(Icons.add, size: 16)),
          GrafitMenubarItem(label: 'Open', leading: Icon(Icons.folder_open, size: 16)),
          GrafitMenubarSeparator(),
          GrafitMenubarItem(label: 'Save', leading: Icon(Icons.save, size: 16), shortcut: '⌘S'),
        ],
      ),
      GrafitMenubarMenu(
        trigger: GrafitMenubarTrigger(child: Text('Edit')),
        children: const [
          GrafitMenubarItem(label: 'Undo', leading: Icon(Icons.undo, size: 16), shortcut: '⌘Z'),
          GrafitMenubarItem(label: 'Redo', leading: Icon(Icons.redo, size: 16), shortcut: '⌘⇧Z'),
        ],
      ),
      GrafitMenubarMenu(
        trigger: GrafitMenubarTrigger(child: Text('View')),
        children: const [
          GrafitMenubarItem(label: 'Fullscreen', leading: Icon(Icons.fullscreen, size: 16)),
          GrafitMenubarItem(label: 'Zoom In', leading: Icon(Icons.zoom_in, size: 16)),
        ],
      ),
      GrafitMenubarMenu(
        trigger: GrafitMenubarTrigger(child: Text('Help')),
        children: const [
          GrafitMenubarItem(label: 'Documentation', leading: Icon(Icons.book, size: 16)),
          GrafitMenubarItem(label: 'About', leading: Icon(Icons.info, size: 16)),
        ],
      ),
    ],
  );
}

@widgetbook.UseCase(
  name: 'Interactive',
  type: GrafitMenubar,
  path: 'Navigation/Menubar',
)
Widget menubarInteractive(BuildContext context) {
  final menuCount = context.knobs.int.slider(
    label: 'Menus',
    initialValue: 4,
    min: 1,
    max: 6,
  );
  final itemsPerMenu = context.knobs.int.slider(
    label: 'Items per Menu',
    initialValue: 3,
    min: 1,
    max: 6,
  );
  final showShortcuts = context.knobs.boolean(label: 'Show Shortcuts', initialValue: true);
  final showIcons = context.knobs.boolean(label: 'Show Icons', initialValue: true);
  final hasSeparators = context.knobs.boolean(label: 'Has Separators', initialValue: true);
  final hasDisabled = context.knobs.boolean(label: 'Has Disabled Items', initialValue: false);

  final menuLabels = ['File', 'Edit', 'View', 'Insert', 'Format', 'Tools'];
  final itemLabels = ['Option 1', 'Option 2', 'Option 3', 'Option 4', 'Option 5', 'Option 6'];
  final shortcuts = ['⌘A', '⌘B', '⌘C', '⌘D', '⌘E', '⌘F'];
  final icons = [
    Icons.abc, Icons.access_time, Icons.account_circle,
    Icons.add_circle, Icons.apps, Icons.arrow_forward
  ];

  return GrafitMenubar(
    children: List.generate(menuCount, (menuIndex) {
      final items = <Widget>[];
      for (int i = 0; i < itemsPerMenu; i++) {
        items.add(GrafitMenubarItem(
          label: itemLabels[i],
          leading: showIcons ? Icon(icons[i], size: 16) : null,
          shortcut: showShortcuts ? shortcuts[i] : null,
          enabled: hasDisabled && i == 1 ? false : true,
        ));
        if (hasSeparators && i == 1 && i < itemsPerMenu - 1) {
          items.add(const GrafitMenubarSeparator());
        }
      }

      return GrafitMenubarMenu(
        trigger: GrafitMenubarTrigger(child: Text(menuLabels[menuIndex])),
        children: items,
      );
    }),
  );
}
