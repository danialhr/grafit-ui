import 'package:flutter/material.dart';
import '../../theme/theme.dart';

/// Tabs component
class GrafitTabs extends StatefulWidget {
  final List<GrafitTab> tabs;
  final int initialIndex;
  final ValueChanged<int>? onChanged;

  const GrafitTabs({
    super.key,
    required this.tabs,
    this.initialIndex = 0,
    this.onChanged,
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

    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: colors.border),
            ),
          ),
          child: TabBar(
            controller: _controller,
            tabs: widget.tabs.map((tab) => Tab(text: tab.label)).toList(),
            labelColor: colors.foreground,
            unselectedLabelColor: colors.mutedForeground,
            indicatorColor: colors.primary,
            indicatorSize: TabBarIndicatorSize.tab,
            dividerColor: Colors.transparent,
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _controller,
            children: widget.tabs.map((tab) => tab.content).toList(),
          ),
        ),
      ],
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
