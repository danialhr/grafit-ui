import 'package:flutter/material.dart';
import '../../theme/theme.dart';
import '../../theme/theme_data.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

/// KBD size variant
enum GrafitKbdSize {
  small,
  medium,
  large,
}

/// Keyboard key (KBD) component for displaying keyboard shortcuts
/// and key combinations in a consistent, styled format.
///
/// This component is the Flutter port of shadcn-ui/ui KBD component.
/// It displays individual keys or key combinations with proper styling.
class GrafitKbd extends StatelessWidget {
  /// The key label or content to display
  final Widget? child;
  final String? text;

  /// Size variant for the KBD component
  final GrafitKbdSize size;

  /// Custom background color (overrides theme default)
  final Color? backgroundColor;

  /// Custom foreground/text color (overrides theme default)
  final Color? foregroundColor;

  /// Custom border color (overrides theme default)
  final Color? borderColor;

  /// Whether the KBD is displayed inside a tooltip
  /// (applies special styling for tooltip context)
  final bool inTooltip;

  /// Gap between children when using KbdGroup
  final double? gap;

  const GrafitKbd({
    super.key,
    this.child,
    this.text,
    this.size = GrafitKbdSize.medium,
    this.backgroundColor,
    this.foregroundColor,
    this.borderColor,
    this.inTooltip = false,
    this.gap,
  });

  /// Create a small KBD for compact displays
  const GrafitKbd.small({
    super.key,
    this.child,
    this.text,
    this.backgroundColor,
    this.foregroundColor,
    this.borderColor,
    this.inTooltip = false,
    this.gap,
  }) : size = GrafitKbdSize.small;

  /// Create a large KBD for emphasis
  const GrafitKbd.large({
    super.key,
    this.child,
    this.text,
    this.backgroundColor,
    this.foregroundColor,
    this.borderColor,
    this.inTooltip = false,
    this.gap,
  }) : size = GrafitKbdSize.large;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<GrafitTheme>()!;
    final colors = theme.colors;

    final kbdStyle = _getKbdStyle(colors);

    return Container(
      constraints: BoxConstraints(
        minWidth: _getMinWidth(),
      ),
      height: _getHeight(),
      padding: _getPadding(),
      decoration: BoxDecoration(
        color: backgroundColor ?? kbdStyle.backgroundColor,
        border: Border.all(
          color: borderColor ?? kbdStyle.borderColor,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(colors.radius * 2), // rounded-sm equivalent
      ),
      child: DefaultTextStyle(
        style: TextStyle(
          color: foregroundColor ?? kbdStyle.foregroundColor,
          fontSize: _getFontSize(),
          fontWeight: FontWeight.w500,
          fontFamily: 'sans-serif',
          height: 1.0,
        ),
        child: Center(
          widthFactor: 1.0,
          child: child ??
              Text(
                text ?? '',
                textAlign: TextAlign.center,
              ),
        ),
      ),
    );
  }

  double _getHeight() {
    return switch (size) {
      GrafitKbdSize.small => 16.0, // h-4
      GrafitKbdSize.medium => 20.0, // h-5
      GrafitKbdSize.large => 24.0, // h-6
    };
  }

  double _getMinWidth() {
    return switch (size) {
      GrafitKbdSize.small => 16.0, // min-w-4
      GrafitKbdSize.medium => 20.0, // min-w-5
      GrafitKbdSize.large => 24.0, // min-w-6
    };
  }

  EdgeInsets _getPadding() {
    return switch (size) {
      GrafitKbdSize.small => const EdgeInsets.symmetric(horizontal: 3),
      GrafitKbdSize.medium => const EdgeInsets.symmetric(horizontal: 4),
      GrafitKbdSize.large => const EdgeInsets.symmetric(horizontal: 6),
    };
  }

  double _getFontSize() {
    return switch (size) {
      GrafitKbdSize.small => 10.0,
      GrafitKbdSize.medium => 12.0, // text-xs
      GrafitKbdSize.large => 14.0,
    };
  }

  _KbdStyle _getKbdStyle(GrafitColorScheme colors) {
    if (inTooltip) {
      // Special styling for tooltip context
      // [[data-slot=tooltip-content]_&]:bg-background/20
      return _KbdStyle(
        backgroundColor: colors.card.withValues(alpha: 0.2),
        foregroundColor: colors.cardForeground,
        borderColor: Colors.transparent,
      );
    }

    return _KbdStyle(
      backgroundColor: colors.muted,
      foregroundColor: colors.mutedForeground,
      borderColor: colors.border,
    );
  }
}

/// Group of keyboard keys displayed together
///
/// Use this to display key combinations like "Cmd + K" or "Ctrl + Shift + F"
class GrafitKbdGroup extends StatelessWidget {
  /// The list of keys or widgets to display as a group
  final List<Widget> children;

  /// Gap between keys
  final double? gap;

  /// Whether to show plus signs between keys
  final bool showPlus;

  /// Custom widget for separator (defaults to " + " text)
  final Widget? separator;

  const GrafitKbdGroup({
    super.key,
    required this.children,
    this.gap,
    this.showPlus = true,
    this.separator,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<GrafitTheme>()!;
    final colors = theme.colors;

    final effectiveGap = gap ?? 4.0;

    if (!showPlus) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: _buildChildren(effectiveGap, null),
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: _buildChildrenWithSeparator(effectiveGap, colors),
    );
  }

  List<Widget> _buildChildren(double gap, Widget? customSeparator) {
    final result = <Widget>[];

    for (int i = 0; i < children.length; i++) {
      result.add(children[i]);
      if (i < children.length - 1) {
        result.add(SizedBox(width: gap));
      }
    }

    return result;
  }

  List<Widget> _buildChildrenWithSeparator(double gap, GrafitColorScheme colors) {
    final result = <Widget>[];

    for (int i = 0; i < children.length; i++) {
      result.add(children[i]);
      if (i < children.length - 1) {
        result.add(SizedBox(width: gap));
        result.add(
          separator ??
              Text(
                ' + ',
                style: TextStyle(
                  color: colors.mutedForeground,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              ),
        );
        result.add(SizedBox(width: gap));
      }
    }

    return result;
  }
}

/// Internal class to hold KBD styling
class _KbdStyle {
  final Color backgroundColor;
  final Color foregroundColor;
  final Color borderColor;

  const _KbdStyle({
    required this.backgroundColor,
    required this.foregroundColor,
    required this.borderColor,
  });
}

// Widgetbook use cases
@widgetbook.UseCase(
  name: 'Single Keys',
  type: GrafitKbd,
  path: 'Typography/Kbd',
)
Widget kbdSingleKeys(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.all(24.0),
    child: Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        GrafitKbd(text: 'A'),
        GrafitKbd(text: 'S'),
        GrafitKbd(text: 'D'),
        GrafitKbd(text: 'F'),
        GrafitKbd(text: 'Ctrl'),
        GrafitKbd(text: 'Shift'),
        GrafitKbd(text: 'Alt'),
        GrafitKbd(text: 'Cmd'),
        GrafitKbd(text: 'Esc'),
        GrafitKbd(text: 'Tab'),
        GrafitKbd(text: 'Enter'),
        GrafitKbd(text: 'Space'),
      ],
    ),
  );
}

@widgetbook.UseCase(
  name: 'Size Variants',
  type: GrafitKbd,
  path: 'Typography/Kbd',
)
Widget kbdSizeVariants(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.all(24.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Small:', style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        Wrap(
          spacing: 4,
          children: [
            GrafitKbd.small(text: 'Ctrl'),
            GrafitKbd.small(text: '+'),
            GrafitKbd.small(text: 'S'),
          ],
        ),
        SizedBox(height: 16),
        Text('Medium:', style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        Wrap(
          spacing: 4,
          children: [
            GrafitKbd(text: 'Ctrl'),
            GrafitKbd(text: '+'),
            GrafitKbd(text: 'S'),
          ],
        ),
        SizedBox(height: 16),
        Text('Large:', style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        Wrap(
          spacing: 4,
          children: [
            GrafitKbd.large(text: 'Ctrl'),
            GrafitKbd.large(text: '+'),
            GrafitKbd.large(text: 'S'),
          ],
        ),
      ],
    ),
  );
}

@widgetbook.UseCase(
  name: 'Key Groups',
  type: GrafitKbdGroup,
  path: 'Typography/Kbd',
)
Widget kbdKeyGroups(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.all(24.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Shortcuts:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        SizedBox(height: 12),
        Wrap(
          spacing: 16,
          runSpacing: 8,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Save: ', style: TextStyle(fontWeight: FontWeight.w500)),
                GrafitKbdGroup(children: [
                  GrafitKbd(text: 'Ctrl'),
                  GrafitKbd(text: 'S'),
                ]),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Open: ', style: TextStyle(fontWeight: FontWeight.w500)),
                GrafitKbdGroup(children: [
                  GrafitKbd(text: 'Ctrl'),
                  GrafitKbd(text: 'O'),
                ]),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Find: ', style: TextStyle(fontWeight: FontWeight.w500)),
                GrafitKbdGroup(children: [
                  GrafitKbd(text: 'Ctrl'),
                  GrafitKbd(text: 'F'),
                ]),
              ],
            ),
          ],
        ),
        SizedBox(height: 20),
        Text('Common Combinations:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        SizedBox(height: 12),
        Wrap(
          spacing: 16,
          runSpacing: 8,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Select All: ', style: TextStyle(fontWeight: FontWeight.w500)),
                GrafitKbdGroup(children: [
                  GrafitKbd(text: 'Ctrl'),
                  GrafitKbd(text: 'A'),
                ]),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Copy: ', style: TextStyle(fontWeight: FontWeight.w500)),
                GrafitKbdGroup(children: [
                  GrafitKbd(text: 'Ctrl'),
                  GrafitKbd(text: 'C'),
                ]),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Paste: ', style: TextStyle(fontWeight: FontWeight.w500)),
                GrafitKbdGroup(children: [
                  GrafitKbd(text: 'Ctrl'),
                  GrafitKbd(text: 'V'),
                ]),
              ],
            ),
          ],
        ),
      ],
    ),
  );
}

@widgetbook.UseCase(
  name: 'Custom Colors',
  type: GrafitKbd,
  path: 'Typography/Kbd',
)
Widget kbdCustomColors(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.all(24.0),
    child: Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        GrafitKbd(
          text: 'Primary',
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          borderColor: Colors.blue,
        ),
        GrafitKbd(
          text: 'Success',
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
          borderColor: Colors.green,
        ),
        GrafitKbd(
          text: 'Warning',
          backgroundColor: Colors.orange,
          foregroundColor: Colors.white,
          borderColor: Colors.orange,
        ),
        GrafitKbd(
          text: 'Danger',
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
          borderColor: Colors.red,
        ),
      ],
    ),
  );
}

@widgetbook.UseCase(
  name: 'With Icons',
  type: GrafitKbd,
  path: 'Typography/Kbd',
)
Widget kbdWithIcons(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.all(24.0),
    child: Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        GrafitKbd(child: Icon(Icons.arrow_upward, size: 14)),
        GrafitKbd(child: Icon(Icons.arrow_downward, size: 14)),
        GrafitKbd(child: Icon(Icons.arrow_back, size: 14)),
        GrafitKbd(child: Icon(Icons.arrow_forward, size: 14)),
        GrafitKbd(child: Icon(Icons.keyboard_return, size: 14)),
      ],
    ),
  );
}

@widgetbook.UseCase(
  name: 'Interactive',
  type: GrafitKbd,
  path: 'Typography/Kbd',
)
Widget kbdInteractive(BuildContext context) {
  // Widgetbook-only: ignore undefined_getter, undefined_method, invalid_annotation_value
  final size = context.knobs.list(
    label: 'Size',
    options: GrafitKbdSize.values,
    initialOption: GrafitKbdSize.medium,
  );

  // Widgetbook-only: ignore undefined_getter, undefined_method, invalid_annotation_value
  final showGroup = context.knobs.boolean(
    label: 'Show as Group',
    initialValue: true,
  );

  // Widgetbook-only: ignore undefined_getter, undefined_method, invalid_annotation_value
  final key1 = context.knobs.string(
    label: 'Key 1',
    initialValue: 'Ctrl',
  );

  // Widgetbook-only: ignore undefined_getter, undefined_method, invalid_annotation_value
  final key2 = context.knobs.string(
    label: 'Key 2',
    initialValue: 'K',
  );

  // Widgetbook-only: ignore undefined_getter, undefined_method, invalid_annotation_value
  final showPlus = context.knobs.boolean(
    label: 'Show Plus Separator',
    initialValue: true,
  );

  // Widgetbook-only: ignore undefined_getter, undefined_method, invalid_annotation_value
  final customBg = context.knobs.colorOrNull(
    label: 'Background Color',
    initialValue: null,
  );

  // Widgetbook-only: ignore undefined_getter, undefined_method, invalid_annotation_value
  final customFg = context.knobs.colorOrNull(
    label: 'Foreground Color',
    initialValue: null,
  );

  return Padding(
    padding: const EdgeInsets.all(24.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showGroup)
          GrafitKbdGroup(
            showPlus: showPlus,
            children: [
              GrafitKbd(
                text: key1,
                size: size,
                backgroundColor: customBg,
                foregroundColor: customFg,
              ),
              GrafitKbd(
                text: key2,
                size: size,
                backgroundColor: customBg,
                foregroundColor: customFg,
              ),
            ],
          )
        else
          Wrap(
            spacing: 4,
            children: [
              GrafitKbd(
                text: key1,
                size: size,
                backgroundColor: customBg,
                foregroundColor: customFg,
              ),
              GrafitKbd(
                text: key2,
                size: size,
                backgroundColor: customBg,
                foregroundColor: customFg,
              ),
            ],
          ),
      ],
    ),
  );
}

@widgetbook.UseCase(
  name: 'Real World Examples',
  type: GrafitKbd,
  path: 'Typography/Kbd',
)
Widget kbdRealWorld(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.all(24.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Command Palette', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        Row(
          children: [
            GrafitKbdGroup(children: [
              GrafitKbd(text: 'Ctrl'),
              GrafitKbd(text: 'K'),
            ]),
            SizedBox(width: 16),
            Text('to open command palette'),
          ],
        ),
        SizedBox(height: 24),
        Text('Keyboard Navigation', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Navigate:', style: TextStyle(fontWeight: FontWeight.w500)),
                SizedBox(width: 8),
                GrafitKbd(child: Icon(Icons.arrow_upward, size: 14)),
                GrafitKbd(child: Icon(Icons.arrow_downward, size: 14)),
                GrafitKbd(child: Icon(Icons.arrow_back, size: 14)),
                GrafitKbd(child: Icon(Icons.arrow_forward, size: 14)),
              ],
            ),
          ],
        ),
        SizedBox(height: 16),
        Wrap(
          spacing: 8,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Select:', style: TextStyle(fontWeight: FontWeight.w500)),
                SizedBox(width: 8),
                GrafitKbd(text: 'Enter'),
              ],
            ),
            SizedBox(width: 16),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Dismiss:', style: TextStyle(fontWeight: FontWeight.w500)),
                SizedBox(width: 8),
                GrafitKbd(text: 'Esc'),
              ],
            ),
          ],
        ),
        SizedBox(height: 24),
        Text('File Operations', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        Wrap(
          runSpacing: 8,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('New:', style: TextStyle(fontWeight: FontWeight.w500)),
                SizedBox(width: 8),
                GrafitKbdGroup(children: [
                  GrafitKbd(text: 'Ctrl'),
                  GrafitKbd(text: 'N'),
                ]),
              ],
            ),
            SizedBox(width: 16),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Save:', style: TextStyle(fontWeight: FontWeight.w500)),
                SizedBox(width: 8),
                GrafitKbdGroup(children: [
                  GrafitKbd(text: 'Ctrl'),
                  GrafitKbd(text: 'S'),
                ]),
              ],
            ),
          ],
        ),
      ],
    ),
  );
}
