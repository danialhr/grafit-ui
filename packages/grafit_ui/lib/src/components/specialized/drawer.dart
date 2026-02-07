import 'package:flutter/material.dart';
import '../../theme/theme.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import '../form/button.dart';

/// Drawer direction
enum GrafitDrawerDirection {
  top,
  bottom,
  left,
  right,
}

/// Drawer component - slide-in panel from edges
class GrafitDrawer extends StatefulWidget {
  final Widget child;
  final GrafitDrawerDirection direction;
  final Widget? trigger;
  final bool dismissible;
  final bool open;

  const GrafitDrawer({
    super.key,
    required this.child,
    this.direction = GrafitDrawerDirection.right,
    this.trigger,
    this.dismissible = true,
    this.open = false,
  });

  @override
  State<GrafitDrawer> createState() => _GrafitDrawerState();
}

class _GrafitDrawerState extends State<GrafitDrawer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isOpen = false;
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
    if (_isOpen) {
      _controller.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(GrafitDrawer oldWidget) {
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
    setState(() {
      _isOpen = !_isOpen;
      if (_isOpen) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  void _close() {
    setState(() {
      _isOpen = false;
      _controller.reverse();
    });
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

    return _GrafitDrawerOverlay(
      onDismiss: widget.dismissible ? _toggle : null,
      child: _GrafitDrawerContent(
        direction: widget.direction,
        animation: _animation,
        colors: Theme.of(context).extension<GrafitTheme>()!.colors,
        theme: Theme.of(context).extension<GrafitTheme>()!,
        child: widget.child,
        onClose: _close,
      ),
    );
  }
}

/// Internal drawer overlay
class _GrafitDrawerOverlay extends StatelessWidget {
  final Widget child;
  final VoidCallback? onDismiss;

  const _GrafitDrawerOverlay({
    required this.child,
    this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onDismiss,
      child: Container(
        color: Colors.black.withOpacity(0.5),
        child: child,
      ),
    );
  }
}

/// Internal drawer content
class _GrafitDrawerContent extends StatelessWidget {
  final GrafitDrawerDirection direction;
  final Animation<double> animation;
  final GrafitColorScheme colors;
  final GrafitTheme theme;
  final Widget child;
  final VoidCallback onClose;

  const _GrafitDrawerContent({
    required this.direction,
    required this.animation,
    required this.colors,
    required this.theme,
    required this.child,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final drawerWidth = MediaQuery.of(context).size.width * 0.75;
    final maxDrawerWidth = 384.0;
    final finalWidth = drawerWidth < maxDrawerWidth ? drawerWidth : maxDrawerWidth;

    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Stack(
          children: [
            // Drawer content
            _buildDrawer(finalWidth, colors),
          ],
        );
      },
    );
  }

  Widget _buildDrawer(double width, GrafitColorScheme colors) {
    switch (direction) {
      case GrafitDrawerDirection.top:
        return Positioned(
          top: -300 * (1 - animation.value),
          left: 0,
          right: 0,
          child: Container(
            height: 300,
            width: double.infinity,
            decoration: BoxDecoration(
              color: colors.background,
              border: Border(
                bottom: BorderSide(color: colors.border),
              ),
              boxShadow: [
                BoxShadow(
                  color: colors.shadow.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Handle indicator
                Center(
                  child: Container(
                    margin: const EdgeInsets.only(top: 12),
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: colors.mutedForeground,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                Expanded(child: child),
              ],
            ),
          ),
        );

      case GrafitDrawerDirection.bottom:
        return Positioned(
          bottom: -300 * (1 - animation.value),
          left: 0,
          right: 0,
          child: Container(
            height: 300,
            width: double.infinity,
            decoration: BoxDecoration(
              color: colors.background,
              border: Border(
                top: BorderSide(color: colors.border),
              ),
              boxShadow: [
                BoxShadow(
                  color: colors.shadow.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(child: child),
                // Handle indicator
                Center(
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: colors.mutedForeground,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );

      case GrafitDrawerDirection.left:
        return Positioned(
          left: -width * (1 - animation.value),
          top: 0,
          bottom: 0,
          width: width,
          child: Container(
            decoration: BoxDecoration(
              color: colors.background,
              border: Border(
                right: BorderSide(color: colors.border),
              ),
              boxShadow: [
                BoxShadow(
                  color: colors.shadow.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(4, 0),
                ),
              ],
            ),
            child: child,
          ),
        );

      case GrafitDrawerDirection.right:
      default:
        return Positioned(
          right: -width * (1 - animation.value),
          top: 0,
          bottom: 0,
          width: width,
          child: Container(
            decoration: BoxDecoration(
              color: colors.background,
              border: Border(
                left: BorderSide(color: colors.border),
              ),
              boxShadow: [
                BoxShadow(
                  color: colors.shadow.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(-4, 0),
                ),
              ],
            ),
            child: child,
          ),
        );
    }
  }
}

/// DrawerHeader - header section for drawer
class GrafitDrawerHeader extends StatelessWidget {
  final String? title;
  final String? description;
  final Widget? child;
  final Widget? trailing;

  const GrafitDrawerHeader({
    super.key,
    this.title,
    this.description,
    this.child,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<GrafitTheme>()!;
    final colors = theme.colors;

    final headerChild = child ??
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (title != null)
              Text(
                title!,
                style: TextStyle(
                  color: colors.foreground,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            if (description != null)
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Text(
                  description!,
                  style: TextStyle(
                    color: colors.mutedForeground,
                    fontSize: 12,
                  ),
                ),
              ),
          ],
        );

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: colors.border),
        ),
      ),
      child: Row(
        children: [
          Expanded(child: headerChild),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}

/// DrawerFooter - footer section for drawer
class GrafitDrawerFooter extends StatelessWidget {
  final List<Widget> actions;

  const GrafitDrawerFooter({
    super.key,
    required this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Theme.of(context).extension<GrafitTheme>()!.colors.border),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: actions,
      ),
    );
  }
}

/// DrawerTitle - title text for drawer header
class GrafitDrawerTitle extends StatelessWidget {
  final String title;

  const GrafitDrawerTitle({
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
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

/// DrawerDescription - description text for drawer
class GrafitDrawerDescription extends StatelessWidget {
  final String description;

  const GrafitDrawerDescription({
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

/// DrawerCloseButton - close button for drawer
class GrafitDrawerCloseButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const GrafitDrawerCloseButton({
    super.key,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<GrafitTheme>()!;
    final colors = theme.colors;

    return GestureDetector(
      onTap: onPressed ?? () => Navigator.of(context).pop(),
      child: Container(
        padding: const EdgeInsets.all(8),
        child: Icon(
          Icons.close,
          color: colors.mutedForeground,
          size: 20,
        ),
      ),
    );
  }
}

// Widgetbook use cases
@widgetbook.UseCase(
  name: 'Right Drawer',
  type: GrafitDrawer,
  path: 'Specialized/Drawer',
)
Widget drawerRight(BuildContext context) {
  return GrafitDrawer(
    open: true,
    direction: GrafitDrawerDirection.right,
    child: const Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GrafitDrawerHeader(
          title: 'Settings',
          description: 'Manage your preferences',
        ),
        Text('Drawer content goes here...'),
      ],
    ),
  );
}

@widgetbook.UseCase(
  name: 'Left Drawer',
  type: GrafitDrawer,
  path: 'Specialized/Drawer',
)
Widget drawerLeft(BuildContext context) {
  return GrafitDrawer(
    open: true,
    direction: GrafitDrawerDirection.left,
    child: const Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GrafitDrawerHeader(
          title: 'Navigation',
          description: 'Quick links',
        ),
        Text('Navigation items...'),
      ],
    ),
  );
}

@widgetbook.UseCase(
  name: 'Top Drawer',
  type: GrafitDrawer,
  path: 'Specialized/Drawer',
)
Widget drawerTop(BuildContext context) {
  return GrafitDrawer(
    open: true,
    direction: GrafitDrawerDirection.top,
    child: const Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('Top drawer content...'),
      ],
    ),
  );
}

@widgetbook.UseCase(
  name: 'Bottom Drawer',
  type: GrafitDrawer,
  path: 'Specialized/Drawer',
)
Widget drawerBottom(BuildContext context) {
  return GrafitDrawer(
    open: true,
    direction: GrafitDrawerDirection.bottom,
    child: const Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('Bottom drawer content...'),
      ],
    ),
  );
}

@widgetbook.UseCase(
  name: 'With Trigger',
  type: GrafitDrawer,
  path: 'Specialized/Drawer',
)
Widget drawerWithTrigger(BuildContext context) {
  return GrafitDrawer(
    direction: GrafitDrawerDirection.right,
    trigger: const GrafitButton(label: 'Open Drawer'),
    child: const Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GrafitDrawerHeader(
          title: 'Menu',
          description: 'Click trigger to open',
        ),
        Text('Menu items go here...'),
      ],
    ),
  );
}

@widgetbook.UseCase(
  name: 'With Header and Footer',
  type: GrafitDrawer,
  path: 'Specialized/Drawer',
)
Widget drawerWithHeaderFooter(BuildContext context) {
  return GrafitDrawer(
    open: true,
    direction: GrafitDrawerDirection.right,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const GrafitDrawerHeader(
          title: 'Account',
          description: 'Manage your account',
          trailing: Icon(Icons.settings),
        ),
        const Expanded(
          child: Text('Account settings content...'),
        ),
        GrafitDrawerFooter(
          actions: [
            GrafitButton(
              label: 'Cancel',
              variant: GrafitButtonVariant.outline,
              onPressed: null,
            ),
            SizedBox(width: 8),
            GrafitButton(
              label: 'Save',
              onPressed: null,
            ),
          ],
        ),
      ],
    ),
  );
}

@widgetbook.UseCase(
  name: 'With Close Button',
  type: GrafitDrawer,
  path: 'Specialized/Drawer',
)
Widget drawerWithCloseButton(BuildContext context) {
  return GrafitDrawer(
    open: true,
    direction: GrafitDrawerDirection.right,
    child: const Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GrafitDrawerHeader(
          title: 'Drawer',
          description: 'With close button',
          trailing: GrafitDrawerCloseButton(),
        ),
        Text('Content here...'),
      ],
    ),
  );
}

@widgetbook.UseCase(
  name: 'Non Dismissible',
  type: GrafitDrawer,
  path: 'Specialized/Drawer',
)
Widget drawerNonDismissible(BuildContext context) {
  return GrafitDrawer(
    open: true,
    direction: GrafitDrawerDirection.right,
    dismissible: false,
    child: const Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GrafitDrawerHeader(
          title: 'Important',
          description: 'Must be closed with close button',
          trailing: GrafitDrawerCloseButton(),
        ),
        Text('Cannot dismiss by clicking outside...'),
      ],
    ),
  );
}

@widgetbook.UseCase(
  name: 'All Directions',
  type: GrafitDrawer,
  path: 'Specialized/Drawer',
)
Widget drawerAllDirections(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.all(100.0),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 16,
      children: [
        GrafitButton(
          label: 'Top Drawer',
          onPressed: null,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 16,
          children: [
            GrafitButton(
              label: 'Left Drawer',
              onPressed: null,
            ),
            GrafitButton(
              label: 'Right Drawer',
              onPressed: null,
            ),
          ],
        ),
        GrafitButton(
          label: 'Bottom Drawer',
          onPressed: null,
        ),
      ],
    ),
  );
}

@widgetbook.UseCase(
  name: 'Interactive',
  type: GrafitDrawer,
  path: 'Specialized/Drawer',
)
Widget drawerInteractive(BuildContext context) {
  final title = context.knobs.string(label: 'Title', initialValue: 'Drawer');
  final description = context.knobs.string(label: 'Description', initialValue: 'Drawer description');
  final direction = context.knobs.list(
    label: 'Direction',
    initialOption: GrafitDrawerDirection.right,
    options: [
      GrafitDrawerDirection.top,
      GrafitDrawerDirection.bottom,
      GrafitDrawerDirection.left,
      GrafitDrawerDirection.right,
    ],
  );
  final dismissible = context.knobs.boolean(label: 'Dismissible', initialValue: true);
  final showCloseButton = context.knobs.boolean(label: 'Show Close Button', initialValue: false);

  return GrafitDrawer(
    open: true,
    direction: direction,
    dismissible: dismissible,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GrafitDrawerHeader(
          title: title.isNotEmpty ? title : null,
          description: description.isNotEmpty ? description : null,
          trailing: showCloseButton ? const GrafitDrawerCloseButton() : null,
        ),
        const Text('Drawer content goes here...'),
      ],
    ),
  );
}
