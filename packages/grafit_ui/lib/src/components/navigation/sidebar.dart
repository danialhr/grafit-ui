import 'package:flutter/material.dart';
import '../../theme/theme.dart';
import '../../theme/theme_data.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

/// Sidebar side - left or right positioning
enum GrafitSidebarSide {
  left,
  right,
}

/// Sidebar variant - different visual styles
enum GrafitSidebarVariant {
  /// Standard sidebar
  sidebar,
  /// Floating sidebar with shadow
  floating,
  /// Inset sidebar with reduced padding
  inset,
}

/// Sidebar collapsible mode
enum GrafitSidebarCollapsible {
  /// Sidebar slides off canvas when collapsed
  offcanvas,
  /// Sidebar collapses to icons only
  icon,
  /// Non-collapsible sidebar
  none,
}

/// Sidebar state - expanded or collapsed
enum GrafitSidebarState {
  expanded,
  collapsed,
}

/// SidebarProvider - Handles collapsible state for sidebar
///
/// This widget should be placed at the root of your application
/// to provide sidebar context to all sidebar components.
class GrafitSidebarProvider extends StatefulWidget {
  final Widget child;
  final bool defaultOpen;
  final bool? open;
  final ValueChanged<bool>? onOpenChange;
  final double? width;
  final double? widthMobile;
  final bool isMobile;

  const GrafitSidebarProvider({
    super.key,
    required this.child,
    this.defaultOpen = true,
    this.open,
    this.onOpenChange,
    this.width,
    this.widthMobile,
    this.isMobile = false,
  });

  @override
  State<GrafitSidebarProvider> createState() => _GrafitSidebarProviderState();

  /// Access sidebar state from context
  static _GrafitSidebarProviderScope of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<_GrafitSidebarProviderScope>();
    if (scope == null) {
      throw Exception('GrafitSidebarProvider not found in context');
    }
    return scope;
  }
}

class _GrafitSidebarProviderState extends State<GrafitSidebarProvider> {
  late bool _open;
  late bool _openMobile;
  final GlobalKey _sidebarKey = GlobalKey();

  // Default widths
  static const double _defaultWidth = 256; // 16rem
  static const double _defaultWidthMobile = 288; // 18rem

  @override
  void initState() {
    super.initState();
    _open = widget.open ?? widget.defaultOpen;
    _openMobile = false;
  }

  @override
  void didUpdateWidget(GrafitSidebarProvider oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.open != null && widget.open != oldWidget.open) {
      setState(() {
        _open = widget.open!;
      });
    }
  }

  bool get isOpen => widget.isMobile ? _openMobile : _open;

  GrafitSidebarState get state {
    if (widget.isMobile) {
      return _openMobile ? GrafitSidebarState.expanded : GrafitSidebarState.collapsed;
    }
    return _open ? GrafitSidebarState.expanded : GrafitSidebarState.collapsed;
  }

  void setOpen(bool value) {
    if (widget.isMobile) {
      setState(() {
        _openMobile = value;
      });
    } else {
      if (widget.onOpenChange != null) {
        widget.onOpenChange!(value);
      } else {
        setState(() {
          _open = value;
        });
      }
    }
  }

  void setOpenMobile(bool value) {
    setState(() {
      _openMobile = value;
    });
  }

  void toggleSidebar() {
    if (widget.isMobile) {
      setOpenMobile(!_openMobile);
    } else {
      setOpen(!_open);
    }
  }

  double get width {
    if (widget.isMobile) {
      return widget.widthMobile ?? _defaultWidthMobile;
    }
    return widget.width ?? _defaultWidth;
  }

  @override
  Widget build(BuildContext context) {
    return _GrafitSidebarProviderScope(
      open: isOpen,
      state: state,
      setOpen: setOpen,
      openMobile: _openMobile,
      setOpenMobile: setOpenMobile,
      isMobile: widget.isMobile,
      toggleSidebar: toggleSidebar,
      sidebarKey: _sidebarKey,
      width: width,
      child: widget.child,
    );
  }
}

/// Inherited scope for sidebar state
class _GrafitSidebarProviderScope extends InheritedWidget {
  final bool open;
  final GrafitSidebarState state;
  final ValueChanged<bool> setOpen;
  final bool openMobile;
  final ValueChanged<bool> setOpenMobile;
  final bool isMobile;
  final VoidCallback toggleSidebar;
  final GlobalKey sidebarKey;
  final double width;

  const _GrafitSidebarProviderScope({
    required this.open,
    required this.state,
    required this.setOpen,
    required this.openMobile,
    required this.setOpenMobile,
    required this.isMobile,
    required this.toggleSidebar,
    required this.sidebarKey,
    required this.width,
    required super.child,
  });

  @override
  bool updateShouldNotify(_GrafitSidebarProviderScope oldWidget) {
    return open != oldWidget.open ||
        state != oldWidget.state ||
        openMobile != oldWidget.openMobile;
  }
}

/// Hook-like access to sidebar state
class GrafitSidebarUse {
  final bool open;
  final GrafitSidebarState state;
  final ValueChanged<bool> setOpen;
  final bool openMobile;
  final ValueChanged<bool> setOpenMobile;
  final bool isMobile;
  final VoidCallback toggleSidebar;

  const GrafitSidebarUse({
    required this.open,
    required this.state,
    required this.setOpen,
    required this.openMobile,
    required this.setOpenMobile,
    required this.isMobile,
    required this.toggleSidebar,
  });

  /// Access sidebar state from context
  static GrafitSidebarUse of(BuildContext context) {
    final scope = GrafitSidebarProvider.of(context);
    return GrafitSidebarUse(
      open: scope.open,
      state: scope.state,
      setOpen: scope.setOpen,
      openMobile: scope.openMobile,
      setOpenMobile: scope.setOpenMobile,
      isMobile: scope.isMobile,
      toggleSidebar: scope.toggleSidebar,
    );
  }
}

/// Main Sidebar component
///
/// A collapsible sidebar that can be positioned on the left or right side.
/// Supports different variants and collapsible modes.
class GrafitSidebar extends StatefulWidget {
  final Widget child;
  final GrafitSidebarSide side;
  final GrafitSidebarVariant variant;
  final GrafitSidebarCollapsible collapsible;
  final bool? open;
  final ValueChanged<bool>? onOpenChange;

  const GrafitSidebar({
    super.key,
    required this.child,
    this.side = GrafitSidebarSide.left,
    this.variant = GrafitSidebarVariant.sidebar,
    this.collapsible = GrafitSidebarCollapsible.icon,
    this.open,
    this.onOpenChange,
  });

  @override
  State<GrafitSidebar> createState() => _GrafitSidebarState();
}

class _GrafitSidebarState extends State<GrafitSidebar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

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
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final scope = GrafitSidebarProvider.of(context);
    if (scope.open) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scope = GrafitSidebarProvider.of(context);
    final theme = Theme.of(context).extension<GrafitTheme>()!;
    final colors = theme.colors;

    final isCollapsed = scope.state == GrafitSidebarState.collapsed;
    final isIconMode = widget.collapsible == GrafitSidebarCollapsible.icon;
    final showIconsOnly = isCollapsed && isIconMode;

    double sidebarWidth;
    if (showIconsOnly) {
      sidebarWidth = 64; // Icon-only width
    } else if (widget.collapsible == GrafitSidebarCollapsible.offcanvas && !scope.open) {
      sidebarWidth = 0;
    } else {
      sidebarWidth = scope.width;
    }

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, _) {
        return _GrafitSidebarContainer(
          side: widget.side,
          variant: widget.variant,
          collapsible: widget.collapsible,
          width: sidebarWidth,
          colors: colors,
          theme: theme,
          isCollapsed: isCollapsed,
          showIconsOnly: showIconsOnly,
          animation: _animation,
          child: widget.child,
        );
      },
    );
  }
}

/// Internal sidebar container
class _GrafitSidebarContainer extends StatelessWidget {
  final GrafitSidebarSide side;
  final GrafitSidebarVariant variant;
  final GrafitSidebarCollapsible collapsible;
  final double width;
  final GrafitColorScheme colors;
  final GrafitTheme theme;
  final bool isCollapsed;
  final bool showIconsOnly;
  final Animation<double> animation;
  final Widget child;

  const _GrafitSidebarContainer({
    required this.side,
    required this.variant,
    required this.collapsible,
    required this.width,
    required this.colors,
    required this.theme,
    required this.isCollapsed,
    required this.showIconsOnly,
    required this.animation,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      decoration: _buildDecoration(),
      child: Column(
        children: [
          Expanded(
            child: _GrafitSidebarScope(
              isCollapsed: isCollapsed,
              showIconsOnly: showIconsOnly,
              side: side,
              variant: variant,
              collapsible: collapsible,
              child: child,
            ),
          ),
        ],
      ),
    );
  }

  BoxDecoration _buildDecoration() {
    BoxDecoration baseDecoration() {
      return BoxDecoration(
        color: colors.muted,
        border: Border(
          right: BorderSide(color: colors.border, width: 1),
        ),
      );
    }

    switch (variant) {
      case GrafitSidebarVariant.floating:
        return baseDecoration().copyWith(
          boxShadow: theme.shadows.md,
          borderRadius: BorderRadius.circular(colors.radius * 6),
        );

      case GrafitSidebarVariant.inset:
        return baseDecoration().copyWith(
          border: Border.all(color: colors.border.withValues(alpha: 0.5)),
        );

      case GrafitSidebarVariant.sidebar:
        return baseDecoration();
    }
  }
}

/// Internal inherited scope for sidebar state within the sidebar
class _GrafitSidebarScope extends InheritedWidget {
  final bool isCollapsed;
  final bool showIconsOnly;
  final GrafitSidebarSide side;
  final GrafitSidebarVariant variant;
  final GrafitSidebarCollapsible collapsible;

  const _GrafitSidebarScope({
    required this.isCollapsed,
    required this.showIconsOnly,
    required this.side,
    required this.variant,
    required this.collapsible,
    required super.child,
  });

  static _GrafitSidebarScope of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<_GrafitSidebarScope>();
    if (scope == null) {
      throw Exception('_GrafitSidebarScope not found in context');
    }
    return scope;
  }

  @override
  bool updateShouldNotify(_GrafitSidebarScope oldWidget) {
    return isCollapsed != oldWidget.isCollapsed ||
        showIconsOnly != oldWidget.showIconsOnly;
  }
}

/// SidebarHeader - Sticky header at the top of the sidebar
class GrafitSidebarHeader extends StatelessWidget {
  final Widget child;

  const GrafitSidebarHeader({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<GrafitTheme>()!.colors;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: colors.border, width: 1),
        ),
      ),
      child: child,
    );
  }
}

/// SidebarFooter - Sticky footer at the bottom of the sidebar
class GrafitSidebarFooter extends StatelessWidget {
  final Widget child;

  const GrafitSidebarFooter({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<GrafitTheme>()!.colors;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: colors.border, width: 1),
        ),
      ),
      child: child,
    );
  }
}

/// SidebarContent - Scrollable content area of the sidebar
class GrafitSidebarContent extends StatelessWidget {
  final Widget child;

  const GrafitSidebarContent({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final scope = _GrafitSidebarScope.of(context);

    return Expanded(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: AnimatedOpacity(
          opacity: scope.showIconsOnly ? 0.0 : 1.0,
          duration: const Duration(milliseconds: 200),
          child: scope.showIconsOnly
              ? const SizedBox.shrink()
              : child,
        ),
      ),
    );
  }
}

/// SidebarGroup - A section within the sidebar content
class GrafitSidebarGroup extends StatelessWidget {
  final Widget? label;
  final Widget? action;
  final Widget? content;
  final List<Widget>? children;

  const GrafitSidebarGroup({
    super.key,
    this.label,
    this.action,
    this.content,
    this.children,
  });

  @override
  Widget build(BuildContext context) {
    final scope = _GrafitSidebarScope.of(context);

    // Hide content when in icon-only mode (unless explicitly styled otherwise)
    if (scope.showIconsOnly) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (label != null || action != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                children: [
                  if (label != null)
                    Expanded(child: label!),
                  if (action != null) action!,
                ],
              ),
            ),
          if (content != null) content!,
          if (children != null) ...children!,
        ],
      ),
    );
  }
}

/// SidebarGroupLabel - Label for a sidebar group
class GrafitSidebarGroupLabel extends StatelessWidget {
  final String? text;
  final Widget? child;
  final bool asChild;
  final Widget? childWidget;

  const GrafitSidebarGroupLabel({
    super.key,
    this.text,
    this.child,
    this.asChild = false,
    this.childWidget,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<GrafitTheme>()!.colors;
    final scope = _GrafitSidebarScope.of(context);

    if (scope.showIconsOnly) {
      return const SizedBox.shrink();
    }

    final labelChild = child ??
        childWidget ??
        (text != null
            ? Text(
                text!,
                style: TextStyle(
                  color: colors.mutedForeground,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              )
            : null);

    if (asChild && childWidget != null) {
      return childWidget!;
    }

    return labelChild ?? const SizedBox.shrink();
  }
}

/// SidebarGroupAction - Action button for a sidebar group
class GrafitSidebarGroupAction extends StatelessWidget {
  final Widget child;
  final String? tooltip;

  const GrafitSidebarGroupAction({
    super.key,
    required this.child,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<GrafitTheme>()!.colors;
    final scope = _GrafitSidebarScope.of(context);

    if (scope.showIconsOnly) {
      return const SizedBox.shrink();
    }

    return GestureDetector(
      onTap: () {},
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: colors.secondary,
            borderRadius: BorderRadius.circular(colors.radius),
          ),
          child: IconTheme(
            data: IconThemeData(
              color: colors.mutedForeground,
              size: 14,
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}

/// SidebarGroupContent - Content area for a sidebar group
class GrafitSidebarGroupContent extends StatelessWidget {
  final Widget child;

  const GrafitSidebarGroupContent({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final scope = _GrafitSidebarScope.of(context);

    if (scope.showIconsOnly) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: child,
    );
  }
}

/// SidebarMenu - Menu container within a sidebar group
class GrafitSidebarMenu extends StatelessWidget {
  final List<Widget> children;

  const GrafitSidebarMenu({
    super.key,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: children,
    );
  }
}

/// SidebarMenuItem - Individual menu item
class GrafitSidebarMenuItem extends StatefulWidget {
  final Widget? button;
  final Widget? action;
  final Widget? sub;
  final Widget? badge;
  final List<Widget>? children;

  const GrafitSidebarMenuItem({
    super.key,
    this.button,
    this.action,
    this.sub,
    this.badge,
    this.children,
  });

  @override
  State<GrafitSidebarMenuItem> createState() => _GrafitSidebarMenuItemState();
}

class _GrafitSidebarMenuItemState extends State<GrafitSidebarMenuItem> {
  @override
  Widget build(BuildContext context) {
    final scope = _GrafitSidebarScope.of(context);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.button != null) widget.button!,
                if (widget.sub != null) ...[
                  const SizedBox(height: 2),
                  widget.sub!,
                ],
              ],
            ),
          ),
          if (widget.action != null && !scope.showIconsOnly) widget.action!,
          if (widget.badge != null) widget.badge!,
        ],
      ),
    );
  }
}

/// SidebarMenuButton - Button for a menu item
class GrafitSidebarMenuButton extends StatefulWidget {
  final Widget? icon;
  final String? label;
  final Widget? child;
  final VoidCallback? onTap;
  final bool isActive;
  final bool asChild;
  final Widget? childWidget;

  const GrafitSidebarMenuButton({
    super.key,
    this.icon,
    this.label,
    this.child,
    this.onTap,
    this.isActive = false,
    this.asChild = false,
    this.childWidget,
  });

  @override
  State<GrafitSidebarMenuButton> createState() => _GrafitSidebarMenuButtonState();
}

class _GrafitSidebarMenuButtonState extends State<GrafitSidebarMenuButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<GrafitTheme>()!.colors;
    final scope = _GrafitSidebarScope.of(context);

    final backgroundColor = widget.isActive
        ? colors.accent.withValues(alpha: 0.2)
        : _isHovered
            ? colors.secondary
            : Colors.transparent;

    final content = widget.child ??
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.icon != null) ...[
              IconTheme(
                data: IconThemeData(
                  color: widget.isActive
                      ? colors.accentForeground
                      : colors.mutedForeground,
                  size: 18,
                ),
                child: widget.icon!,
              ),
              if (!scope.showIconsOnly && widget.label != null) ...[
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    widget.label!,
                    style: TextStyle(
                      color: widget.isActive
                          ? colors.foreground
                          : colors.foreground,
                      fontSize: 14,
                      fontWeight: widget.isActive ? FontWeight.w600 : FontWeight.w400,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ],
          ],
        );

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: scope.showIconsOnly ? 0 : 12,
            vertical: 8,
          ),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(colors.radius * 4),
          ),
          child: scope.showIconsOnly && widget.icon != null
              ? Padding(
                  padding: const EdgeInsets.all(8),
                  child: IconTheme(
                    data: IconThemeData(
                      color: widget.isActive
                          ? colors.accentForeground
                          : colors.mutedForeground,
                      size: 20,
                    ),
                    child: widget.icon!,
                  ),
                )
              : content,
        ),
      ),
    );
  }
}

/// SidebarMenuAction - Action button within a menu item
class GrafitSidebarMenuAction extends StatefulWidget {
  final Widget icon;
  final String? tooltip;
  final VoidCallback? onTap;

  const GrafitSidebarMenuAction({
    super.key,
    required this.icon,
    this.tooltip,
    this.onTap,
  });

  @override
  State<GrafitSidebarMenuAction> createState() => _GrafitSidebarMenuActionState();
}

class _GrafitSidebarMenuActionState extends State<GrafitSidebarMenuAction> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<GrafitTheme>()!.colors;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: _isHovered ? colors.secondary : Colors.transparent,
            borderRadius: BorderRadius.circular(colors.radius * 2),
          ),
          child: IconTheme(
            data: IconThemeData(
              color: colors.mutedForeground,
              size: 14,
            ),
            child: widget.icon,
          ),
        ),
      ),
    );
  }
}

/// SidebarMenuSub - Submenu within a menu item
class GrafitSidebarMenuSub extends StatelessWidget {
  final List<Widget> children;

  const GrafitSidebarMenuSub({
    super.key,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: children,
      ),
    );
  }
}

/// SidebarMenuSubItem - Item within a submenu
class GrafitSidebarMenuSubItem extends StatelessWidget {
  final Widget button;

  const GrafitSidebarMenuSubItem({
    super.key,
    required this.button,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 1),
      child: button,
    );
  }
}

/// SidebarMenuSubButton - Button for a submenu item
class GrafitSidebarMenuSubButton extends StatefulWidget {
  final Widget? icon;
  final String? label;
  final Widget? child;
  final VoidCallback? onTap;
  final bool isActive;

  const GrafitSidebarMenuSubButton({
    super.key,
    this.icon,
    this.label,
    this.child,
    this.onTap,
    this.isActive = false,
  });

  @override
  State<GrafitSidebarMenuSubButton> createState() => _GrafitSidebarMenuSubButtonState();
}

class _GrafitSidebarMenuSubButtonState extends State<GrafitSidebarMenuSubButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<GrafitTheme>()!.colors;

    final backgroundColor = widget.isActive
        ? colors.accent.withValues(alpha: 0.2)
        : _isHovered
            ? colors.secondary
            : Colors.transparent;

    final content = widget.child ??
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.icon != null) ...[
              IconTheme(
                data: IconThemeData(
                  color: widget.isActive
                      ? colors.accentForeground
                      : colors.mutedForeground,
                  size: 16,
                ),
                child: widget.icon!,
              ),
              const SizedBox(width: 8),
            ],
            if (widget.label != null)
              Expanded(
                child: Text(
                  widget.label!,
                  style: TextStyle(
                    color: widget.isActive
                        ? colors.foreground
                        : colors.foreground,
                    fontSize: 13,
                    fontWeight: widget.isActive ? FontWeight.w500 : FontWeight.w400,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
          ],
        );

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(colors.radius * 3),
          ),
          child: content,
        ),
      ),
    );
  }
}

/// SidebarMenuBadge - Badge indicator for a menu item
class GrafitSidebarMenuBadge extends StatelessWidget {
  final String text;
  final Widget? child;

  const GrafitSidebarMenuBadge({
    super.key,
    required this.text,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<GrafitTheme>()!.colors;

    final badge = Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: colors.accent,
        borderRadius: BorderRadius.circular(colors.radius * 2),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: colors.accentForeground,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );

    return child ?? badge;
  }
}

/// SidebarMenuSkeleton - Loading skeleton for menu items
class GrafitSidebarMenuSkeleton extends StatelessWidget {
  final bool showIcon;

  const GrafitSidebarMenuSkeleton({
    super.key,
    this.showIcon = true,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<GrafitTheme>()!.colors;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showIcon)
            Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                color: colors.muted.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(colors.radius),
              ),
            ),
          if (showIcon) const SizedBox(width: 12),
          Container(
            width: 80,
            height: 14,
            decoration: BoxDecoration(
              color: colors.muted.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(colors.radius),
            ),
          ),
        ],
      ),
    );
  }
}

/// SidebarSeparator - Separator line within the sidebar
class GrafitSidebarSeparator extends StatelessWidget {
  const GrafitSidebarSeparator({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<GrafitTheme>()!.colors;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: Container(
        height: 1,
        color: colors.border,
      ),
    );
  }
}

/// SidebarTrigger - Button to toggle the sidebar
class GrafitSidebarTrigger extends StatefulWidget {
  final Widget? child;

  const GrafitSidebarTrigger({
    super.key,
    this.child,
  });

  @override
  State<GrafitSidebarTrigger> createState() => _GrafitSidebarTriggerState();
}

class _GrafitSidebarTriggerState extends State<GrafitSidebarTrigger> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<GrafitTheme>()!.colors;
    final scope = GrafitSidebarProvider.of(context);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: scope.toggleSidebar,
        child: widget.child ??
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: _isHovered ? colors.secondary : Colors.transparent,
                borderRadius: BorderRadius.circular(colors.radius * 4),
              ),
              child: Icon(
                scope.open ? Icons.menu_open : Icons.menu,
                color: colors.foreground,
                size: 20,
              ),
            ),
      ),
    );
  }
}

/// SidebarRail - Interactive rail for toggling sidebar
class GrafitSidebarRail extends StatelessWidget {
  const GrafitSidebarRail({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<GrafitTheme>()!.colors;
    final scope = GrafitSidebarProvider.of(context);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: scope.toggleSidebar,
        child: Container(
          width: 4,
          decoration: BoxDecoration(
            color: scope.open ? colors.accent : Colors.transparent,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ),
    );
  }
}

/// SidebarInset - Main content wrapper when using inset variant
class GrafitSidebarInset extends StatelessWidget {
  final Widget child;

  const GrafitSidebarInset({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final scope = GrafitSidebarProvider.of(context);

    return Padding(
      padding: EdgeInsets.only(
        left: scope.width + 16,
        right: 16,
        top: 16,
        bottom: 16,
      ),
      child: child,
    );
  }
}

// Widgetbook use cases
@widgetbook.UseCase(
  name: 'Default',
  type: GrafitSidebar,
  path: 'Navigation/Sidebar',
)
Widget sidebarDefault(BuildContext context) {
  return GrafitSidebarProvider(
    defaultOpen: true,
    child: Scaffold(
      body: Row(
        children: [
          GrafitSidebar(
            collapsible: GrafitSidebarCollapsible.icon,
            child: Column(
              children: [
                GrafitSidebarHeader(
                  child: Row(
                    children: [
                      Icon(Icons.dashboard, size: 24),
                      SizedBox(width: 12),
                      Text('Dashboard', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                GrafitSidebarContent(
                  child: GrafitSidebarMenu(
                    children: [
                      GrafitSidebarMenuItem(
                        button: GrafitSidebarMenuButton(
                          icon: Icon(Icons.home_outlined),
                          label: 'Home',
                          onTap: () {},
                        ),
                      ),
                      GrafitSidebarMenuItem(
                        button: GrafitSidebarMenuButton(
                          icon: Icon(Icons.folder_outlined),
                          label: 'Projects',
                          onTap: () {},
                        ),
                      ),
                      GrafitSidebarMenuItem(
                        button: GrafitSidebarMenuButton(
                          icon: Icon(Icons.settings_outlined),
                          label: 'Settings',
                          isActive: true,
                          onTap: () {},
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              color: Color(0xFFf5f5f5),
              child: Center(child: Text('Main Content Area')),
            ),
          ),
        ],
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'Collapsed',
  type: GrafitSidebar,
  path: 'Navigation/Sidebar',
)
Widget sidebarCollapsed(BuildContext context) {
  return GrafitSidebarProvider(
    defaultOpen: false,
    child: Scaffold(
      body: Row(
        children: [
          GrafitSidebar(
            collapsible: GrafitSidebarCollapsible.icon,
            child: Column(
              children: [
                GrafitSidebarHeader(
                  child: Icon(Icons.dashboard, size: 24),
                ),
                GrafitSidebarContent(
                  child: GrafitSidebarMenu(
                    children: [
                      GrafitSidebarMenuItem(
                        button: GrafitSidebarMenuButton(
                          icon: Icon(Icons.home_outlined),
                          label: 'Home',
                          onTap: () {},
                        ),
                      ),
                      GrafitSidebarMenuItem(
                        button: GrafitSidebarMenuButton(
                          icon: Icon(Icons.folder_outlined),
                          label: 'Projects',
                          onTap: () {},
                        ),
                      ),
                      GrafitSidebarMenuItem(
                        button: GrafitSidebarMenuButton(
                          icon: Icon(Icons.settings_outlined),
                          label: 'Settings',
                          isActive: true,
                          onTap: () {},
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              color: Color(0xFFf5f5f5),
              child: Center(child: Text('Main Content Area')),
            ),
          ),
        ],
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'Right Side',
  type: GrafitSidebar,
  path: 'Navigation/Sidebar',
)
Widget sidebarRight(BuildContext context) {
  return GrafitSidebarProvider(
    defaultOpen: true,
    child: Scaffold(
      body: Row(
        children: [
          Expanded(
            child: Container(
              color: Color(0xFFf5f5f5),
              child: Center(child: Text('Main Content Area')),
            ),
          ),
          GrafitSidebar(
            side: GrafitSidebarSide.right,
            collapsible: GrafitSidebarCollapsible.icon,
            child: Column(
              children: [
                GrafitSidebarHeader(
                  child: Row(
                    children: [
                      Icon(Icons.dashboard, size: 24),
                      SizedBox(width: 12),
                      Text('Dashboard', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                GrafitSidebarContent(
                  child: GrafitSidebarMenu(
                    children: [
                      GrafitSidebarMenuItem(
                        button: GrafitSidebarMenuButton(
                          icon: Icon(Icons.home_outlined),
                          label: 'Home',
                          onTap: () {},
                        ),
                      ),
                      GrafitSidebarMenuItem(
                        button: GrafitSidebarMenuButton(
                          icon: Icon(Icons.folder_outlined),
                          label: 'Projects',
                          onTap: () {},
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'With Groups',
  type: GrafitSidebar,
  path: 'Navigation/Sidebar',
)
Widget sidebarWithGroups(BuildContext context) {
  return GrafitSidebarProvider(
    defaultOpen: true,
    child: Scaffold(
      body: Row(
        children: [
          GrafitSidebar(
            collapsible: GrafitSidebarCollapsible.icon,
            child: Column(
              children: [
                GrafitSidebarHeader(
                  child: Row(
                    children: [
                      Icon(Icons.dashboard, size: 24),
                      SizedBox(width: 12),
                      Text('App', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                GrafitSidebarContent(
                  child: Column(
                    children: [
                      GrafitSidebarGroup(
                        label: GrafitSidebarGroupLabel(text: 'Overview'),
                        children: [
                          GrafitSidebarMenuItem(
                            button: GrafitSidebarMenuButton(
                              icon: Icon(Icons.home_outlined),
                              label: 'Home',
                              isActive: true,
                              onTap: () {},
                            ),
                          ),
                          GrafitSidebarMenuItem(
                            button: GrafitSidebarMenuButton(
                              icon: Icon(Icons.analytics_outlined),
                              label: 'Analytics',
                              onTap: () {},
                            ),
                          ),
                        ],
                      ),
                      GrafitSidebarSeparator(),
                      GrafitSidebarGroup(
                        label: GrafitSidebarGroupLabel(text: 'Management'),
                        children: [
                          GrafitSidebarMenuItem(
                            button: GrafitSidebarMenuButton(
                              icon: Icon(Icons.folder_outlined),
                              label: 'Projects',
                              onTap: () {},
                            ),
                          ),
                          GrafitSidebarMenuItem(
                            button: GrafitSidebarMenuButton(
                              icon: Icon(Icons.people_outlined),
                              label: 'Team',
                              onTap: () {},
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              color: Color(0xFFf5f5f5),
              child: Center(child: Text('Main Content Area')),
            ),
          ),
        ],
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'With Submenus',
  type: GrafitSidebar,
  path: 'Navigation/Sidebar',
)
Widget sidebarWithSubmenus(BuildContext context) {
  return GrafitSidebarProvider(
    defaultOpen: true,
    child: Scaffold(
      body: Row(
        children: [
          GrafitSidebar(
            collapsible: GrafitSidebarCollapsible.icon,
            child: Column(
              children: [
                GrafitSidebarHeader(
                  child: Row(
                    children: [
                      Icon(Icons.dashboard, size: 24),
                      SizedBox(width: 12),
                      Text('App', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                GrafitSidebarContent(
                  child: GrafitSidebarMenu(
                    children: [
                      GrafitSidebarMenuItem(
                        button: GrafitSidebarMenuButton(
                          icon: Icon(Icons.home_outlined),
                          label: 'Home',
                          isActive: true,
                          onTap: () {},
                        ),
                      ),
                      GrafitSidebarMenuItem(
                        button: GrafitSidebarMenuButton(
                          icon: Icon(Icons.folder_outlined),
                          label: 'Projects',
                          onTap: () {},
                        ),
                        sub: GrafitSidebarMenuSub(
                          children: [
                            GrafitSidebarMenuSubItem(
                              button: GrafitSidebarMenuSubButton(
                                icon: Icon(Icons.list),
                                label: 'All Projects',
                                onTap: () {},
                              ),
                            ),
                            GrafitSidebarMenuSubItem(
                              button: GrafitSidebarMenuSubButton(
                                icon: Icon(Icons.star_border),
                                label: 'Favorites',
                                onTap: () {},
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              color: Color(0xFFf5f5f5),
              child: Center(child: Text('Main Content Area')),
            ),
          ),
        ],
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'Floating Variant',
  type: GrafitSidebar,
  path: 'Navigation/Sidebar',
)
Widget sidebarFloating(BuildContext context) {
  return GrafitSidebarProvider(
    defaultOpen: true,
    child: Scaffold(
      body: Container(
        color: Color(0xFFf5f5f5),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              GrafitSidebar(
                variant: GrafitSidebarVariant.floating,
                collapsible: GrafitSidebarCollapsible.icon,
                child: Column(
                  children: [
                    GrafitSidebarHeader(
                      child: Icon(Icons.dashboard, size: 24),
                    ),
                    GrafitSidebarContent(
                      child: GrafitSidebarMenu(
                        children: [
                          GrafitSidebarMenuItem(
                            button: GrafitSidebarMenuButton(
                              icon: Icon(Icons.home_outlined),
                              label: 'Home',
                              isActive: true,
                              onTap: () {},
                            ),
                          ),
                          GrafitSidebarMenuItem(
                            button: GrafitSidebarMenuButton(
                              icon: Icon(Icons.folder_outlined),
                              label: 'Projects',
                              onTap: () {},
                            ),
                          ),
                          GrafitSidebarMenuItem(
                            button: GrafitSidebarMenuButton(
                              icon: Icon(Icons.settings_outlined),
                              label: 'Settings',
                              onTap: () {},
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(child: Text('Main Content Area')),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'With Badges',
  type: GrafitSidebar,
  path: 'Navigation/Sidebar',
)
Widget sidebarWithBadges(BuildContext context) {
  return GrafitSidebarProvider(
    defaultOpen: true,
    child: Scaffold(
      body: Row(
        children: [
          GrafitSidebar(
            collapsible: GrafitSidebarCollapsible.icon,
            child: Column(
              children: [
                GrafitSidebarHeader(
                  child: Row(
                    children: [
                      Icon(Icons.dashboard, size: 24),
                      SizedBox(width: 12),
                      Text('App', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                GrafitSidebarContent(
                  child: GrafitSidebarMenu(
                    children: [
                      GrafitSidebarMenuItem(
                        button: GrafitSidebarMenuButton(
                          icon: Icon(Icons.home_outlined),
                          label: 'Home',
                          onTap: () {},
                        ),
                      ),
                      GrafitSidebarMenuItem(
                        button: GrafitSidebarMenuButton(
                          icon: Icon(Icons.mail_outlined),
                          label: 'Messages',
                          onTap: () {},
                        ),
                        badge: GrafitSidebarMenuBadge(text: '5'),
                      ),
                      GrafitSidebarMenuItem(
                        button: GrafitSidebarMenuButton(
                          icon: Icon(Icons.notifications_outlined),
                          label: 'Notifications',
                          onTap: () {},
                        ),
                        badge: GrafitSidebarMenuBadge(text: '12'),
                      ),
                      GrafitSidebarMenuItem(
                        button: GrafitSidebarMenuButton(
                          icon: Icon(Icons.settings_outlined),
                          label: 'Settings',
                          onTap: () {},
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              color: Color(0xFFf5f5f5),
              child: Center(child: Text('Main Content Area')),
            ),
          ),
        ],
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'Interactive',
  type: GrafitSidebar,
  path: 'Navigation/Sidebar',
)
Widget sidebarInteractive(BuildContext context) {
  final isOpen = context.knobs.boolean(label: 'Open', initialValue: true);
  final sideIndex = context.knobs.list(
    label: 'Side',
    options: ['left', 'right'],
    initialOption: 'left',
  );
  final variantIndex = context.knobs.list(
    label: 'Variant',
    options: ['sidebar', 'floating', 'inset'],
    initialOption: 'sidebar',
  );
  final collapsibleIndex = context.knobs.list(
    label: 'Collapsible',
    options: ['offcanvas', 'icon', 'none'],
    initialOption: 'icon',
  );
  final showGroups = context.knobs.boolean(label: 'Show Groups', initialValue: true);
  final showBadges = context.knobs.boolean(label: 'Show Badges', initialValue: false);

  final side = GrafitSidebarSide.values[sideIndex == 'left' ? 0 : 1];
  final variant = GrafitSidebarVariant.values[variantIndex == 'sidebar' ? 0 : variantIndex == 'floating' ? 1 : 2];
  final collapsible = GrafitSidebarCollapsible.values[collapsibleIndex == 'offcanvas' ? 0 : collapsibleIndex == 'icon' ? 1 : 2];

  return GrafitSidebarProvider(
    defaultOpen: isOpen,
    child: Scaffold(
      body: Row(
        children: [
          if (side == GrafitSidebarSide.left) ...[
            GrafitSidebar(
              side: side,
              variant: variant,
              collapsible: collapsible,
              child: _buildSidebarContent(showGroups, showBadges),
            ),
            Expanded(child: Container(color: Color(0xFFf5f5f5), child: Center(child: Text('Main Content Area')))),
          ] else ...[
            Expanded(child: Container(color: Color(0xFFf5f5f5), child: Center(child: Text('Main Content Area')))),
            GrafitSidebar(
              side: side,
              variant: variant,
              collapsible: collapsible,
              child: _buildSidebarContent(showGroups, showBadges),
            ),
          ],
        ],
      ),
    ),
  );
}

Widget _buildSidebarContent(bool showGroups, bool showBadges) {
  return Column(
    children: [
      GrafitSidebarHeader(
        child: Row(
          children: [
            Icon(Icons.dashboard, size: 24),
            SizedBox(width: 12),
            Text('App', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
      if (showGroups) ...[
        GrafitSidebarContent(
          child: Column(
            children: [
              GrafitSidebarGroup(
                label: GrafitSidebarGroupLabel(text: 'Menu'),
                children: [
                  GrafitSidebarMenuItem(
                    button: GrafitSidebarMenuButton(
                      icon: Icon(Icons.home_outlined),
                      label: 'Home',
                      isActive: true,
                      onTap: () {},
                    ),
                    badge: showBadges ? GrafitSidebarMenuBadge(text: '3') : null,
                  ),
                  GrafitSidebarMenuItem(
                    button: GrafitSidebarMenuButton(
                      icon: Icon(Icons.folder_outlined),
                      label: 'Projects',
                      onTap: () {},
                    ),
                  ),
                ],
              ),
              GrafitSidebarSeparator(),
              GrafitSidebarGroup(
                label: GrafitSidebarGroupLabel(text: 'Settings'),
                children: [
                  GrafitSidebarMenuItem(
                    button: GrafitSidebarMenuButton(
                      icon: Icon(Icons.settings_outlined),
                      label: 'Settings',
                      onTap: () {},
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ] else ...[
        GrafitSidebarContent(
          child: GrafitSidebarMenu(
            children: [
              GrafitSidebarMenuItem(
                button: GrafitSidebarMenuButton(
                  icon: Icon(Icons.home_outlined),
                  label: 'Home',
                  isActive: true,
                  onTap: () {},
                ),
                badge: showBadges ? GrafitSidebarMenuBadge(text: '3') : null,
              ),
              GrafitSidebarMenuItem(
                button: GrafitSidebarMenuButton(
                  icon: Icon(Icons.folder_outlined),
                  label: 'Projects',
                  onTap: () {},
                ),
              ),
              GrafitSidebarMenuItem(
                button: GrafitSidebarMenuButton(
                  icon: Icon(Icons.settings_outlined),
                  label: 'Settings',
                  onTap: () {},
                ),
              ),
            ],
          ),
        ),
      ],
    ],
  );
}
