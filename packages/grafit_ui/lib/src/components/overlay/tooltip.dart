import 'package:flutter/material.dart';
import '../../theme/theme.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

/// Tooltip component
class GrafitTooltip extends StatelessWidget {
  final String message;
  final Widget child;
  final int delayDuration;
  final int? skipDelayDuration;

  const GrafitTooltip({
    super.key,
    required this.message,
    required this.child,
    this.delayDuration = 500,
    this.skipDelayDuration,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<GrafitTheme>()!;
    final colors = theme.colors;

    return Tooltip(
      message: message,
      waitDuration: Duration(milliseconds: delayDuration),
      showDuration: skipDelayDuration != null
          ? Duration(milliseconds: skipDelayDuration!)
          : null,
      decoration: BoxDecoration(
        color: colors.foreground,
        borderRadius: BorderRadius.circular(colors.radius * 6),
      ),
      textStyle: TextStyle(
        color: colors.background,
        fontSize: 13,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: child,
    );
  }
}

// Widgetbook use cases
@widgetbook.UseCase(
  name: 'Default',
  type: GrafitTooltip,
  path: 'Overlay/Tooltip',
)
Widget tooltipDefault(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.all(16.0),
    child: Center(
      child: GrafitTooltip(
        message: 'This is a helpful tooltip',
        child: Text('Hover over me'),
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'On Button',
  type: GrafitTooltip,
  path: 'Overlay/Tooltip',
)
Widget tooltipOnButton(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.all(16.0),
    child: Center(
      child: GrafitTooltip(
        message: 'Click to save your changes',
        child: ElevatedButton(
          onPressed: null,
          child: Text('Save'),
        ),
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'Long Text',
  type: GrafitTooltip,
  path: 'Overlay/Tooltip',
)
Widget tooltipLongText(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.all(16.0),
    child: Center(
      child: GrafitTooltip(
        message: 'This is a much longer tooltip message that contains more information about the element',
        child: Icon(Icons.info_outline),
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'Custom Delay',
  type: GrafitTooltip,
  path: 'Overlay/Tooltip',
)
Widget tooltipCustomDelay(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.all(16.0),
    child: Center(
      child: GrafitTooltip(
        message: 'Appears after 2 seconds',
        delayDuration: 2000,
        child: Text('Long hover delay'),
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'Multiple Tooltips',
  type: GrafitTooltip,
  path: 'Overlay/Tooltip',
)
Widget tooltipMultiple(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.all(16.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GrafitTooltip(
          message: 'First tooltip',
          child: Icon(Icons.home),
        ),
        SizedBox(width: 16),
        GrafitTooltip(
          message: 'Second tooltip',
          child: Icon(Icons.search),
        ),
        SizedBox(width: 16),
        GrafitTooltip(
          message: 'Third tooltip',
          child: Icon(Icons.settings),
        ),
      ],
    ),
  );
}

@widgetbook.UseCase(
  name: 'On Icon Buttons',
  type: GrafitTooltip,
  path: 'Overlay/Tooltip',
)
Widget tooltipIconButtons(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.all(16.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GrafitTooltip(
          message: 'Copy to clipboard',
          child: IconButton(
            icon: Icon(Icons.copy),
            onPressed: null,
          ),
        ),
        GrafitTooltip(
          message: 'Download file',
          child: IconButton(
            icon: Icon(Icons.download),
            onPressed: null,
          ),
        ),
        GrafitTooltip(
          message: 'Delete item',
          child: IconButton(
            icon: Icon(Icons.delete),
            onPressed: null,
          ),
        ),
      ],
    ),
  );
}

@widgetbook.UseCase(
  name: 'Interactive',
  type: GrafitTooltip,
  path: 'Overlay/Tooltip',
)
Widget tooltipInteractive(BuildContext context) {
  // Widgetbook-only: ignore undefined_getter, undefined_method, invalid_annotation_value
  final message = context.knobs.string(
    label: 'Message',
    initialValue: 'This is a tooltip',
  );
  // Widgetbook-only: ignore undefined_getter, undefined_method, invalid_annotation_value
  final delay = context.knobs.int.slider(
    label: 'Delay (ms)',
    initialValue: 500,
    min: 0,
    max: 2000,
  );
  // Widgetbook-only: ignore undefined_getter, undefined_method, invalid_annotation_value
  final childType = context.knobs.list(
    label: 'Child Type',
    initialOption: 'Text',
    options: ['Text', 'Button', 'Icon'],
  );

  Widget child;
  switch (childType) {
    case 'Button':
      child = const ElevatedButton(
        onPressed: null,
        child: Text('Button'),
      );
    case 'Icon':
      child = const Icon(Icons.info);
    default:
      child = const Text('Hover me');
  }

  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: Center(
      child: GrafitTooltip(
        message: message.isNotEmpty ? message : 'Tooltip',
        delayDuration: delay,
        child: child,
      ),
    ),
  );
}
