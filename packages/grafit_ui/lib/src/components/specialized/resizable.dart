import 'package:flutter/material.dart';
import '../../theme/theme.dart';

/// Resizable panel configuration
class GrafitResizablePanel {
  final Widget child;
  final double? minSize;
  final double? maxSize;
  final bool collapsible;
  final bool initiallyCollapsed;

  const GrafitResizablePanel({
    required this.child,
    this.minSize,
    this.maxSize,
    this.collapsible = false,
    this.initiallyCollapsed = false,
  });
}

/// Resizable panel component
class GrafitResizable extends StatefulWidget {
  final List<GrafitResizablePanel> panels;
  final List<double> initialSizes;
  final Axis direction;
  final double handleSize;
  final double defaultMinSize;
  final double defaultMaxSize;

  const GrafitResizable({
    super.key,
    required this.panels,
    required this.initialSizes,
    this.direction = Axis.horizontal,
    this.handleSize = 4,
    this.defaultMinSize = 0.1,
    this.defaultMaxSize = 0.9,
  });

  @override
  State<GrafitResizable> createState() => _GrafitResizableState();
}

class _GrafitResizableState extends State<GrafitResizable> {
  late List<double> _sizes;
  late List<bool> _collapsed;
  int? _draggingHandle;

  @override
  void initState() {
    super.initState();
    _sizes = widget.initialSizes;
    _collapsed = widget.panels.map((p) => p.initiallyCollapsed).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<GrafitTheme>()!;

    return LayoutBuilder(
      builder: (context, constraints) {
        final totalSize = widget.direction == Axis.horizontal
            ? constraints.maxWidth
            : constraints.maxHeight;

        return Stack(
          children: _buildPanels(totalSize, theme),
        );
      },
    );
  }

  List<Widget> _buildPanels(double totalSize, GrafitTheme theme) {
    final List<Widget> panels = [];
    double currentOffset = 0;

    for (int i = 0; i < widget.panels.length; i++) {
      final panel = widget.panels[i];
      final size = _collapsed[i] ? widget.handleSize : _sizes[i] * totalSize;

      // Panel
      if (widget.direction == Axis.horizontal) {
        panels.add(
          Positioned(
            left: currentOffset,
            top: 0,
            bottom: 0,
            width: size,
            child: SizedBox(
              width: size > widget.handleSize ? size : widget.handleSize,
              child: _collapsed[i]
                  ? null
                  : panel.child,
            ),
          ),
        );
      } else {
        panels.add(
          Positioned(
            top: currentOffset,
            left: 0,
            right: 0,
            height: size,
            child: SizedBox(
              height: size > widget.handleSize ? size : widget.handleSize,
              child: _collapsed[i]
                  ? null
                  : panel.child,
            ),
          ),
        );
      }

      currentOffset += size;

      // Handle (except for last panel)
      if (i < widget.panels.length - 1) {
        final handleIndex = i;
        final nextPanelCollapsible = widget.panels[i + 1].collapsible;
        panels.add(
          _buildResizeHandle(handleIndex, currentOffset, theme, nextPanelCollapsible),
        );
        currentOffset += widget.handleSize;
      }
    }

    return panels;
  }

  Widget _buildResizeHandle(int index, double offset, GrafitTheme theme, bool canCollapseNext) {
    return GestureDetector(
      onHorizontalDragUpdate: widget.direction == Axis.horizontal
          ? (details) => _updateSizes(index, details.delta.dx)
          : null,
      onVerticalDragUpdate: widget.direction == Axis.vertical
          ? (details) => _updateSizes(index, details.delta.dy)
          : null,
      onTap: canCollapseNext
          ? () => _toggleCollapse(index + 1)
          : null,
      child: MouseRegion(
        cursor: widget.direction == Axis.horizontal
            ? SystemMouseCursors.resizeColumn
            : SystemMouseCursors.resizeRow,
        child: Container(
          width: widget.direction == Axis.horizontal ? widget.handleSize : null,
          height: widget.direction == Axis.vertical ? widget.handleSize : null,
          color: theme.colors.border,
          child: Center(
            child: Container(
              width: widget.direction == Axis.vertical ? 20 : widget.handleSize,
              height: widget.direction == Axis.horizontal ? 20 : widget.handleSize,
              decoration: BoxDecoration(
                color: canCollapseNext
                    ? theme.colors.primary
                    : theme.colors.mutedForeground,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _updateSizes(int handleIndex, double delta) {
    setState(() {
      final sizeDelta = delta / _totalSize();

      // Get min/max sizes for panels
      final minSize1 = widget.panels[handleIndex].minSize ?? widget.defaultMinSize;
      final maxSize1 = widget.panels[handleIndex].maxSize ?? widget.defaultMaxSize;
      final minSize2 = widget.panels[handleIndex + 1].minSize ?? widget.defaultMinSize;
      final maxSize2 = widget.panels[handleIndex + 1].maxSize ?? widget.defaultMaxSize;

      // Distribute the size change between adjacent panels
      _sizes[handleIndex] = (_sizes[handleIndex] + sizeDelta).clamp(minSize1, maxSize1);
      _sizes[handleIndex + 1] =
          (_sizes[handleIndex + 1] - sizeDelta).clamp(minSize2, maxSize2);
    });
  }

  void _toggleCollapse(int panelIndex) {
    if (widget.panels[panelIndex].collapsible) {
      setState(() {
        _collapsed[panelIndex] = !_collapsed[panelIndex];
      });
    }
  }

  double _totalSize() {
    final context = this.context;
    if (context is StatefulElement) {
      final renderBox = context.findRenderObject() as RenderBox?;
      if (renderBox != null) {
        final size = renderBox.size;
        return widget.direction == Axis.horizontal ? size.width : size.height;
      }
    }
    return 1000; // Fallback
  }
}
