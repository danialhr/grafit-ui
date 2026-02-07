import 'package:flutter/material.dart';
import '../../theme/theme.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

/// Scroll area component
class GrafitScrollArea extends StatelessWidget {
  final Widget child;
  final Axis? scrollDirection;
  final bool? primary;
  final ScrollController? controller;
  final EdgeInsets? padding;

  const GrafitScrollArea({
    super.key,
    required this.child,
    this.scrollDirection,
    this.primary,
    this.controller,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<GrafitTheme>()!;
    final colors = theme.colors;

    return Scrollbar(
      thumbVisibility: true,
      thickness: 8,
      radius: Radius.circular(colors.radius * 4),
      child: SingleChildScrollView(
        scrollDirection: scrollDirection ?? Axis.vertical,
        primary: primary,
        controller: controller,
        padding: padding,
        child: child,
      ),
    );
  }
}

// Widgetbook use cases
@widgetbook.UseCase(
  name: 'Default',
  type: GrafitScrollArea,
  path: 'Specialized/ScrollArea',
)
Widget scrollAreaDefault(BuildContext context) {
  return const SizedBox(
    height: 200,
    width: 300,
    child: GrafitScrollArea(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Scrollable Content', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('This is a scrollable area. You can scroll vertically to see more content.'),
            SizedBox(height: 16),
            _generateContent(),
          ],
        ),
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'Horizontal Scroll',
  type: GrafitScrollArea,
  path: 'Specialized/ScrollArea',
)
Widget scrollAreaHorizontal(BuildContext context) {
  return SizedBox(
    height: 150,
    child: GrafitScrollArea(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(
          10,
          (i) => Container(
            width: 100,
            margin: const EdgeInsets.all(8),
            color: Colors.primaries[i % Colors.primaries.length],
            child: Center(
              child: Text(
                'Item ${i + 1}',
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'With Padding',
  type: GrafitScrollArea,
  path: 'Specialized/ScrollArea',
)
Widget scrollAreaWithPadding(BuildContext context) {
  return const SizedBox(
    height: 200,
    width: 300,
    child: GrafitScrollArea(
      padding: EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Padded Content', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          SizedBox(height: 16),
          _generateContent(),
        ],
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'Long Content',
  type: GrafitScrollArea,
  path: 'Specialized/ScrollArea',
)
Widget scrollAreaLongContent(BuildContext context) {
  return const SizedBox(
    height: 250,
    width: 350,
    child: GrafitScrollArea(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Long Scrollable Document', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            SizedBox(height: 16),
            _LongContentWidget(),
          ],
        ),
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'Interactive',
  type: GrafitScrollArea,
  path: 'Specialized/ScrollArea',
)
Widget scrollAreaInteractive(BuildContext context) {
  final showPadding = context.knobs.boolean(
    label: 'Show Padding',
    initialValue: false,
  );

  final contentHeight = context.knobs.int.slider(
    label: 'Content Height',
    initialValue: 500,
    min: 200,
    max: 1000,
  );

  return SizedBox(
    height: 200,
    width: 300,
    child: GrafitScrollArea(
      padding: showPadding ? const EdgeInsets.all(24.0) : null,
      child: Container(
        height: contentHeight.toDouble(),
        color: Colors.grey.shade100,
        child: Center(
          child: Text('Content height: ${contentHeight}px'),
        ),
      ),
    ),
  );
}

// Helper widgets
Widget _generateContent() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: List.generate(
      15,
      (i) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Text('Line ${i + 1}: Some scrollable content goes here...'),
      ),
    ),
  );
}

class _LongContentWidget extends StatelessWidget {
  const _LongContentWidget();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (int i = 0; i < 30; i++) ...[
          Text(
            'Section ${i + 1}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text('Lorem ipsum dolor sit amet, consectetur adipiscing elit. '
              'Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.'),
          const SizedBox(height: 12),
        ],
      ],
    );
  }
}
