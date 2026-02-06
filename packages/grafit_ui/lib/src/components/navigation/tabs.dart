import 'package:flutter/material.dart';
import '../../theme/theme.dart';

/// Tabs variant
enum GrafitTabsVariant {
  value,
  line,
}

/// Tabs orientation
enum GrafitTabsOrientation {
  horizontal,
  vertical,
}

/// Tabs component
class GrafitTabs extends StatefulWidget {
  final List<GrafitTab> tabs;
  final int initialIndex;
  final ValueChanged<int>? onChanged;
  final GrafitTabsVariant variant;
  final GrafitTabsOrientation orientation;

  const GrafitTabs({
    super.key,
    required this.tabs,
    this.initialIndex = 0,
    this.onChanged,
    this.variant = GrafitTabsVariant.value,
    this.orientation = GrafitTabsOrientation.horizontal,
  });

  @override
  State<GrafitTabs> createState() => _GrafitTabsState();
}

class _GrafitTabsState extends State<GrafitTabs> with SingleTickerProviderStateMixin {
  late TabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TabController(
      length: widget.tabs.length,
      vsync: this,
      initialIndex: widget.initialIndex,
    );
    _controller.addListener(_handleTabChange);
  }

  @override
  void dispose() {
    _controller.removeListener(_handleTabChange);
    _controller.dispose();
    super.dispose();
  }

  void _handleTabChange() {
    if (_controller.indexIsChanging) {
      widget.onChanged?.call(_controller.index);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<GrafitTheme>()!;
    final colors = theme.colors;

    if (widget.orientation == GrafitTabsOrientation.vertical) {
      return _buildVerticalTabs(colors, theme);
    }

    return Column(
      children: [
        _buildTabBar(colors, theme),
        Expanded(
          child: TabBarView(
            controller: _controller,
            children: widget.tabs.map((tab) => tab.content).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildVerticalTabs(GrafitColorScheme colors, GrafitTheme theme) {
    return Row(
      children: [
        _buildVerticalTabBar(colors, theme),
        Expanded(
          child: TabBarView(
            controller: _controller,
            children: widget.tabs.map((tab) => tab.content).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildVerticalTabBar(GrafitColorScheme colors, GrafitTheme theme) {
    final tabWidth = 200.0;

    return Container(
      width: tabWidth,
      decoration: BoxDecoration(
        color: widget.variant == GrafitTabsVariant.value
            ? colors.muted
            : colors.background,
        border: Border(
          right: BorderSide(color: colors.border),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (int i = 0; i < widget.tabs.length; i++) ...[
            _buildVerticalTabTrigger(i, colors, theme),
            if (i < widget.tabs.length - 1 && widget.variant == GrafitTabsVariant.line)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Divider(height: 1, color: colors.border),
              ),
          ],
        ],
      ),
    );
  }

  Widget _buildVerticalTabTrigger(int index, GrafitColorScheme colors, GrafitTheme theme) {
    final isSelected = _controller.index == index;

    Widget trigger = GestureDetector(
      onTap: () {
        _controller.animateTo(index);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected && widget.variant == GrafitTabsVariant.value
              ? colors.background
              : Colors.transparent,
          border: widget.variant == GrafitTabsVariant.line && isSelected
              ? Border(
                  left: BorderSide(
                    color: colors.primary,
                    width: 2,
                  ),
                )
              : null,
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                widget.tabs[index].label,
                style: TextStyle(
                  color: isSelected
                      ? colors.foreground
                      : colors.mutedForeground,
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
                ),
              ),
            ),
          ],
        ),
      ),
    );

    // Add hover effect wrapper
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: _GrafitTabHover(
        isSelected: isSelected,
        colors: colors,
        child: trigger,
      ),
    );
  }

  Widget _buildTabBar(GrafitColorScheme colors, GrafitTheme theme) {
    if (widget.variant == GrafitTabsVariant.line) {
      // Line variant - minimal styling with underline indicator
      return TabBar(
        controller: _controller,
        tabs: widget.tabs.map((tab) => Tab(text: tab.label)).toList(),
        labelColor: colors.foreground,
        unselectedLabelColor: colors.mutedForeground,
        indicatorColor: colors.foreground,
        indicatorSize: TabBarIndicatorSize.label,
        indicatorWeight: 2,
        dividerColor: Colors.transparent,
        labelPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      );
    }

    // Default variant - container with background
    return Container(
      decoration: BoxDecoration(
        color: colors.muted,
        borderRadius: BorderRadius.circular(colors.radius * 8),
        border: Border.all(color: colors.border),
      ),
      padding: const EdgeInsets.all(4),
      child: TabBar(
        controller: _controller,
        tabs: widget.tabs.map((tab) => Tab(text: tab.label)).toList(),
        labelColor: colors.foreground,
        unselectedLabelColor: colors.mutedForeground,
        indicatorColor: Colors.transparent,
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        labelStyle: const TextStyle(fontWeight: FontWeight.w500),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal),
        indicator: BoxDecoration(
          color: colors.background,
          borderRadius: BorderRadius.circular(colors.radius * 6),
          boxShadow: [
            BoxShadow(
              color: colors.shadow.withOpacity(0.1),
              blurRadius: 4,
            ),
          ],
        ),
      ),
    );
  }
}

/// Hover effect wrapper for tab triggers
class _GrafitTabHover extends StatefulWidget {
  final bool isSelected;
  final GrafitColorScheme colors;
  final Widget child;

  const _GrafitTabHover({
    required this.isSelected,
    required this.colors,
    required this.child,
  });

  @override
  State<_GrafitTabHover> createState() => _GrafitTabHoverState();
}

class _GrafitTabHoverState extends State<_GrafitTabHover> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Container(
        decoration: _isHovered && !widget.isSelected
            ? BoxDecoration(
                color: widget.colors.muted.withOpacity(0.5),
              )
            : null,
        child: widget.child,
      ),
    );
  }
}

class GrafitTab {
  final String label;
  final Widget content;

  const GrafitTab({
    required this.label,
    required this.content,
  });
}
