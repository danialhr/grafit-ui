import 'package:flutter/material.dart';
import '../../theme/theme.dart';

/// Accordion type - controls how many items can be open at once
enum GrafitAccordionType {
  /// Only one item can be open at a time
  single,
  /// Multiple items can be open at the same time
  multiple,
}

/// Accordion component - A vertically stacked set of interactive headings
/// that each reveal a section of content.
///
/// Based on shadcn-ui/ui Accordion component:
/// https://ui.shadcn.com/docs/components/accordion
class GrafitAccordion extends StatefulWidget {
  /// The accordion items to display
  final List<GrafitAccordionItem> items;

  /// Type of accordion - single (only one open) or multiple (many open)
  final GrafitAccordionType type;

  /// Initial index of the item to be open (for single type)
  final int? initialIndex;

  /// Initial set of open indices (for multiple type)
  final Set<int>? initialOpenIndices;

  /// Optional padding around the accordion
  final EdgeInsets? padding;

  /// Optional border around the entire accordion
  final bool bordered;

  /// Optional background color
  final Color? backgroundColor;

  /// Callback when an item's open state changes
  final ValueChanged<int>? onOpenChange;

  const GrafitAccordion({
    super.key,
    required this.items,
    this.type = GrafitAccordionType.single,
    this.initialIndex,
    this.initialOpenIndices,
    this.padding,
    this.bordered = false,
    this.backgroundColor,
    this.onOpenChange,
  });

  @override
  State<GrafitAccordion> createState() => _GrafitAccordionState();
}

class _GrafitAccordionState extends State<GrafitAccordion> {
  late Set<int> _openIndices;

  @override
  void initState() {
    super.initState();
    if (widget.type == GrafitAccordionType.single) {
      _openIndices = widget.initialIndex != null
          ? {widget.initialIndex!}
          : <int>{};
    } else {
      _openIndices = widget.initialOpenIndices ?? <int>{};
    }
  }

  void _toggleItem(int index) {
    setState(() {
      if (widget.type == GrafitAccordionType.single) {
        // Single mode: close all others, toggle this one
        if (_openIndices.contains(index)) {
          _openIndices.clear();
        } else {
          _openIndices = {index};
        }
      } else {
        // Multiple mode: toggle this item independently
        if (_openIndices.contains(index)) {
          _openIndices.remove(index);
        } else {
          _openIndices.add(index);
        }
      }
      widget.onOpenChange?.call(index);
    });
  }

  bool _isOpen(int index) {
    return _openIndices.contains(index);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<GrafitTheme>()!;
    final colors = theme.colors;

    return Container(
      padding: widget.padding,
      decoration: BoxDecoration(
        color: widget.backgroundColor ?? colors.background,
        border: widget.bordered
            ? Border.all(color: colors.border)
            : null,
        borderRadius: BorderRadius.circular(colors.radius * 8),
      ),
      child: Column(
        children: [
          for (int i = 0; i < widget.items.length; i++) ...[
            _buildItem(context, i, widget.items[i], colors),
            if (i < widget.items.length - 1)
              Divider(
                height: 1,
                color: colors.border,
              ),
          ],
        ],
      ),
    );
  }

  Widget _buildItem(
    BuildContext context,
    int index,
    GrafitAccordionItem item,
    dynamic colors,
  ) {
    return GrafitAccordionItemWidget(
      item: item,
      isOpen: _isOpen(index),
      onToggle: () => _toggleItem(index),
    );
  }
}

/// Accordion item data class
class GrafitAccordionItem {
  /// The unique identifier for this item
  final String? id;

  /// The value to pass to callbacks
  final String? value;

  /// The trigger widget (typically a GrafitAccordionTrigger)
  final Widget trigger;

  /// The content widget
  final Widget content;

  /// Whether this item is disabled
  final bool disabled;

  const GrafitAccordionItem({
    this.id,
    this.value,
    required this.trigger,
    required this.content,
    this.disabled = false,
  });
}

/// Internal widget for rendering a single accordion item
class GrafitAccordionItemWidget extends StatefulWidget {
  final GrafitAccordionItem item;
  final bool isOpen;
  final VoidCallback onToggle;

  const GrafitAccordionItemWidget({
    super.key,
    required this.item,
    required this.isOpen,
    required this.onToggle,
  });

  @override
  State<GrafitAccordionItemWidget> createState() =>
      _GrafitAccordionItemWidgetState();
}

class _GrafitAccordionItemWidgetState
    extends State<GrafitAccordionItemWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    if (widget.isOpen) {
      _controller.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(GrafitAccordionItemWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isOpen != oldWidget.isOpen) {
      if (widget.isOpen) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<GrafitTheme>()!;
    final colors = theme.colors;

    return Focus(
      canRequestFocus: !widget.item.disabled,
      child: Column(
        children: [
          // Header/Trigger
          MouseRegion(
            cursor: widget.item.disabled
                ? SystemMouseCursors.forbidden
                : SystemMouseCursors.click,
            child: GestureDetector(
              onTap: widget.item.disabled ? null : widget.onToggle,
              child: _wrapTrigger(
                context,
                widget.item.trigger,
                widget.isOpen,
                widget.item.disabled,
                colors,
              ),
            ),
          ),
          // Content
          ClipRect(
            child: SizeTransition(
              sizeFactor: _animation,
              axis: Axis.vertical,
              axisAlignment: -1,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: widget.item.content,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _wrapTrigger(
    BuildContext context,
    Widget trigger,
    bool isOpen,
    bool disabled,
    dynamic colors,
  ) {
    // If trigger is already a GrafitAccordionTrigger, update its state
    if (trigger is GrafitAccordionTrigger) {
      return GrafitAccordionTrigger(
        label: trigger.label,
        child: trigger.child,
        isOpen: isOpen,
        disabled: disabled,
        icon: trigger.icon,
        showIcon: trigger.showIcon,
      );
    }

    // Otherwise, wrap with focus effects
    return FocusScope(
      node: FocusScopeNode(),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(colors.radius * 6),
        ),
        child: trigger,
      ),
    );
  }
}

/// Accordion trigger - the clickable header for an accordion item
///
/// Based on shadcn-ui/ui AccordionTrigger component
class GrafitAccordionTrigger extends StatelessWidget {
  /// The label text for the trigger
  final String? label;

  /// Optional custom child widget (replaces label if provided)
  final Widget? child;

  /// Whether the trigger is currently open (for icon rotation)
  final bool isOpen;

  /// Whether the trigger is disabled
  final bool disabled;

  /// Custom icon to display (defaults to chevron down)
  final Widget? icon;

  /// Whether to show the icon (defaults to true)
  final bool showIcon;

  const GrafitAccordionTrigger({
    super.key,
    this.label,
    this.child,
    this.isOpen = false,
    this.disabled = false,
    this.icon,
    this.showIcon = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<GrafitTheme>()!;
    final colors = theme.colors;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: child ??
                Text(
                  label ?? '',
                  style: TextStyle(
                    color: disabled
                        ? colors.mutedForeground.withOpacity(0.5)
                        : colors.foreground,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    decoration: !disabled ? null : TextDecoration.none,
                  ),
                ),
          ),
          if (showIcon)
            AnimatedRotation(
              turns: isOpen ? 0.5 : 0,
              duration: const Duration(milliseconds: 200),
              child: icon ??
                  Icon(
                    Icons.expand_more,
                    color: disabled
                        ? colors.mutedForeground.withOpacity(0.5)
                        : colors.mutedForeground,
                    size: 16,
                  ),
            ),
        ],
      ),
    );
  }
}

/// Accordion content - the content shown when an item is expanded
///
/// Based on shadcn-ui/ui AccordionContent component
class GrafitAccordionContent extends StatelessWidget {
  /// The content widget
  final Widget child;

  /// Optional padding for the content
  final EdgeInsets? padding;

  const GrafitAccordionContent({
    super.key,
    required this.child,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<GrafitTheme>()!;
    final colors = theme.colors;

    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: DefaultTextStyle(
        style: TextStyle(
          color: colors.mutedForeground,
          fontSize: 14,
        ),
        child: child,
      ),
    );
  }
}

/// Helper function to create a simple accordion item with text content
GrafitAccordionItem createAccordionItem({
  String? id,
  String? value,
  required String title,
  required String content,
  bool disabled = false,
}) {
  return GrafitAccordionItem(
    id: id,
    value: value,
    trigger: GrafitAccordionTrigger(label: title),
    content: GrafitAccordionContent(
      child: Text(content),
    ),
    disabled: disabled,
  );
}

/// Helper function to create a simple accordion item with custom content
GrafitAccordionItem createAccordionItemWithContent({
  String? id,
  String? value,
  required String title,
  required Widget content,
  bool disabled = false,
}) {
  return GrafitAccordionItem(
    id: id,
    value: value,
    trigger: GrafitAccordionTrigger(label: title),
    content: GrafitAccordionContent(child: content),
    disabled: disabled,
  );
}
