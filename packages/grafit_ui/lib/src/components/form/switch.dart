import 'package:flutter/material.dart';
import '../../theme/theme.dart';
import '../../primitives/clickable.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

/// Switch size variant
enum GrafitSwitchSize {
  sm,
  value,
}

/// Switch/toggle component
class GrafitSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;
  final String? label;
  final bool enabled;
  final GrafitSwitchSize size;

  const GrafitSwitch({
    super.key,
    required this.value,
    this.onChanged,
    this.label,
    this.enabled = true,
    this.size = GrafitSwitchSize.value,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<GrafitTheme>()!;
    final colors = theme.colors;
    final effectiveEnabled = enabled && onChanged != null;

    // Size dimensions based on shadcn-ui: sm=56x14, default=32x18 (roughly)
    final switchWidth = size == GrafitSwitchSize.sm ? 32.0 : 44.0;
    final switchHeight = size == GrafitSwitchSize.sm ? 18.0 : 24.0;
    final thumbSize = size == GrafitSwitchSize.sm ? 14.0 : 20.0;
    final borderRadius = switchHeight / 2;

    Widget switchWidget = GrafitClickable(
      enabled: effectiveEnabled,
      onTap: () => onChanged?.call(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: switchWidth,
        height: switchHeight,
        decoration: BoxDecoration(
          color: value
              ? colors.primary
              : (context.isClickableHovered && effectiveEnabled)
                  ? colors.muted
                  : colors.input,
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(
            color: context.isClickableFocused ? colors.ring : colors.transparent,
            width: context.isClickableFocused ? 2 : 0,
          ),
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 150),
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          padding: EdgeInsets.all(2),
          child: Container(
            width: thumbSize,
            height: thumbSize,
            decoration: BoxDecoration(
              color: colors.background,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );

    if (label != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          switchWidget,
          const SizedBox(width: 12),
          GestureDetector(
            onTap: effectiveEnabled ? () => onChanged?.call(!value) : null,
            child: Text(
              label!,
              style: TextStyle(
                color: effectiveEnabled ? colors.foreground : colors.mutedForeground,
                fontSize: 14,
              ),
            ),
          ),
        ],
      );
    }

    return switchWidget;
  }
}

// Widgetbook use cases
@widgetbook.UseCase(
  name: 'Default',
  type: GrafitSwitch,
  path: 'Form/Switch',
)
Widget switchDefault(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.all(16.0),
    child: GrafitSwitch(
      value: false,
      label: 'Dark mode',
    ),
  );
}

@widgetbook.UseCase(
  name: 'Checked',
  type: GrafitSwitch,
  path: 'Form/Switch',
)
Widget switchChecked(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.all(16.0),
    child: GrafitSwitch(
      value: true,
      label: 'Dark mode',
    ),
  );
}

@widgetbook.UseCase(
  name: 'Without Label',
  type: GrafitSwitch,
  path: 'Form/Switch',
)
Widget switchWithoutLabel(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.all(16.0),
    child: Row(
      children: [
        GrafitSwitch(value: false),
        SizedBox(width: 16),
        GrafitSwitch(value: true),
      ],
    ),
  );
}

@widgetbook.UseCase(
  name: 'Small Size',
  type: GrafitSwitch,
  path: 'Form/Switch',
)
Widget switchSmall(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.all(16.0),
    child: GrafitSwitch(
      value: true,
      label: 'Small switch',
      size: GrafitSwitchSize.sm,
    ),
  );
}

@widgetbook.UseCase(
  name: 'Disabled',
  type: GrafitSwitch,
  path: 'Form/Switch',
)
Widget switchDisabled(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.all(16.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GrafitSwitch(
          value: false,
          label: 'Disabled off',
          enabled: false,
        ),
        SizedBox(height: 12),
        GrafitSwitch(
          value: true,
          label: 'Disabled on',
          enabled: false,
        ),
      ],
    ),
  );
}

@widgetbook.UseCase(
  name: 'Multiple Switches',
  type: GrafitSwitch,
  path: 'Form/Switch',
)
Widget switchMultiple(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.all(16.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GrafitSwitch(
          value: true,
          label: 'Notifications',
        ),
        SizedBox(height: 12),
        GrafitSwitch(
          value: false,
          label: 'Email updates',
        ),
        SizedBox(height: 12),
        GrafitSwitch(
          value: true,
          label: 'Auto-save',
        ),
      ],
    ),
  );
}

@widgetbook.UseCase(
  name: 'Interactive',
  type: GrafitSwitch,
  path: 'Form/Switch',
)
Widget switchInteractive(BuildContext context) {
  final label = context.knobs.string(label: 'Label', initialValue: 'Enable feature');
  final checked = context.knobs.boolean(label: 'Checked', initialValue: false);
  final enabled = context.knobs.boolean(label: 'Enabled', initialValue: true);
  final size = context.knobs.list(
    label: 'Size',
    initialOption: GrafitSwitchSize.value,
    options: [GrafitSwitchSize.sm, GrafitSwitchSize.value],
  );

  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: GrafitSwitch(
      value: checked,
      label: label.isNotEmpty ? label : null,
      enabled: enabled,
      size: size,
    ),
  );
}
