import 'package:flutter/material.dart';
import '../../theme/theme.dart';

/// Resizable panel component
class GrafitResizable extends StatefulWidget {
  final List<Widget> children;
  final List<double> initialSizes;
  final Axis direction;
  final double handleSize;

  const GrafitResizable({
    super.key,
    required this.children,
    required this.initialSizes,
    this.direction = Axis.horizontal,
    this.handleSize = 4,
  });

  @override
  State<GrafitResizable> createState() => _GrafitResizableState();
}

class _GrafitResizableState extends State<GrafitResizable> {
  late List<double> _sizes;
  int? _draggingHandle;

  @override
  void initState() {
    super.initState();
    _sizes = widget.initialSizes;
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

    for (int i = 0; i < widget.children.length; i++) {
      final size = _sizes[i] * totalSize;

      // Panel
      if (widget.direction == Axis.horizontal) {
        panels.add(
          Positioned(
            left: currentOffset,
            top: 0,
            bottom: 0,
            width: size,
            child: SizedBox(
              width: size,
              child: widget.children[i],
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
              height: size,
              child: widget.children[i],
            ),
          ),
        );
      }

      currentOffset += size;

      // Handle (except for last panel)
      if (i < widget.children.length - 1) {
        final handleIndex = i;
        panels.add(
          _buildResizeHandle(handleIndex, currentOffset, theme),
        );
        currentOffset += widget.handleSize;
      }
    }

    return panels;
  }

  Widget _buildResizeHandle(int index, double offset, GrafitTheme theme) {
    return GestureDetector(
      onHorizontalDragUpdate: widget.direction == Axis.horizontal
          ? (details) => _updateSizes(index, details.delta.dx)
          : null,
      onVerticalDragUpdate: widget.direction == Axis.vertical
          ? (details) => _updateSizes(index, details.delta.dy)
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
                color: theme.colors.mutedForeground,
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

      // Distribute the size change between adjacent panels
      _sizes[handleIndex] = (_sizes[handleIndex] + sizeDelta).clamp(0.1, 0.9);
      _sizes[handleIndex + 1] =
          (_sizes[handleIndex + 1] - sizeDelta).clamp(0.1, 0.9);
    });
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
