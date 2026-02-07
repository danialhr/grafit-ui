import 'package:flutter/material.dart';
import '../../theme/theme.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

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

// Widgetbook use cases
@widgetbook.UseCase(
  name: 'Two Panels Horizontal',
  type: GrafitResizable,
  path: 'Specialized/Resizable',
)
Widget resizableTwoPanelsHorizontal(BuildContext context) {
  return SizedBox(
    height: 200,
    child: GrafitResizable(
      panels: [
        GrafitResizablePanel(
          child: Container(
            color: Colors.blue.shade100,
            child: const Center(child: Text('Left Panel')),
          ),
        ),
        GrafitResizablePanel(
          child: Container(
            color: Colors.green.shade100,
            child: const Center(child: Text('Right Panel')),
          ),
        ),
      ],
      initialSizes: const [0.5, 0.5],
    ),
  );
}

@widgetbook.UseCase(
  name: 'Two Panels Vertical',
  type: GrafitResizable,
  path: 'Specialized/Resizable',
)
Widget resizableTwoPanelsVertical(BuildContext context) {
  return SizedBox(
    width: 300,
    child: GrafitResizable(
      direction: Axis.vertical,
      panels: [
        GrafitResizablePanel(
          child: Container(
            color: Colors.orange.shade100,
            child: const Center(child: Text('Top Panel')),
          ),
        ),
        GrafitResizablePanel(
          child: Container(
            color: Colors.purple.shade100,
            child: const Center(child: Text('Bottom Panel')),
          ),
        ),
      ],
      initialSizes: const [0.5, 0.5],
    ),
  );
}

@widgetbook.UseCase(
  name: 'Three Panels',
  type: GrafitResizable,
  path: 'Specialized/Resizable',
)
Widget resizableThreePanels(BuildContext context) {
  return SizedBox(
    height: 200,
    child: GrafitResizable(
      panels: [
        GrafitResizablePanel(
          child: Container(
            color: Colors.red.shade100,
            child: const Center(child: Text('Panel 1')),
          ),
        ),
        GrafitResizablePanel(
          child: Container(
            color: Colors.blue.shade100,
            child: const Center(child: Text('Panel 2')),
          ),
        ),
        GrafitResizablePanel(
          child: Container(
            color: Colors.green.shade100,
            child: const Center(child: Text('Panel 3')),
          ),
        ),
      ],
      initialSizes: const [0.33, 0.34, 0.33],
    ),
  );
}

@widgetbook.UseCase(
  name: 'With Collapsible Panels',
  type: GrafitResizable,
  path: 'Specialized/Resizable',
)
Widget resizableCollapsible(BuildContext context) {
  return SizedBox(
    height: 200,
    child: GrafitResizable(
      panels: [
        GrafitResizablePanel(
          collapsible: true,
          child: Container(
            color: Colors.teal.shade100,
            child: const Center(child: Text('Collapsible 1')),
          ),
        ),
        GrafitResizablePanel(
          collapsible: true,
          initiallyCollapsed: true,
          child: Container(
            color: Colors.cyan.shade100,
            child: const Center(child: Text('Collapsible 2')),
          ),
        ),
        GrafitResizablePanel(
          child: Container(
            color: Colors.indigo.shade100,
            child: const Center(child: Text('Main')),
          ),
        ),
      ],
      initialSizes: const [0.3, 0.3, 0.4],
    ),
  );
}

@widgetbook.UseCase(
  name: 'With Size Constraints',
  type: GrafitResizable,
  path: 'Specialized/Resizable',
)
Widget resizableWithConstraints(BuildContext context) {
  return SizedBox(
    height: 200,
    child: GrafitResizable(
      panels: [
        GrafitResizablePanel(
          minSize: 0.2,
          maxSize: 0.4,
          child: Container(
            color: Colors.amber.shade100,
            child: const Center(child: Text('Constrained\n(20%-40%)')),
          ),
        ),
        GrafitResizablePanel(
          child: Container(
            color: Colors.lime.shade100,
            child: const Center(child: Text('Flexible')),
          ),
        ),
      ],
      initialSizes: const [0.3, 0.7],
    ),
  );
}

@widgetbook.UseCase(
  name: 'Interactive',
  type: GrafitResizable,
  path: 'Specialized/Resizable',
)
Widget resizableInteractive(BuildContext context) {
  final direction = context.knobs.list(
    label: 'Direction',
    options: [Axis.horizontal, Axis.vertical],
    initialOption: Axis.horizontal,
  );

  final handleSize = context.knobs.double.slider(
    label: 'Handle Size',
    initialValue: 4.0,
    min: 2.0,
    max: 10.0,
  );

  final panelCount = context.knobs.int.slider(
    label: 'Panel Count',
    initialValue: 2,
    min: 2,
    max: 4,
  );

  final colors = [
    Colors.blue.shade100,
    Colors.green.shade100,
    Colors.orange.shade100,
    Colors.purple.shade100,
  ];

  final panels = List.generate(
    panelCount,
    (i) => GrafitResizablePanel(
      child: Container(
        color: colors[i],
        child: Center(child: Text('Panel ${i + 1}')),
      ),
    ),
  );

  final sizes = List.filled(panelCount, 1.0 / panelCount);

  if (direction == Axis.horizontal) {
    return SizedBox(
      height: 200,
      child: GrafitResizable(
        direction: direction,
        handleSize: handleSize,
        panels: panels,
        initialSizes: sizes,
      ),
    );
  } else {
    return SizedBox(
      width: 300,
      child: GrafitResizable(
        direction: direction,
        handleSize: handleSize,
        panels: panels,
        initialSizes: sizes,
      ),
    );
  }
}
