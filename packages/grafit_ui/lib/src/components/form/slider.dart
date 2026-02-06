import 'package:flutter/material.dart';
import '../../theme/theme.dart';

/// Slider component
class GrafitSlider extends StatefulWidget {
  final double value;
  final ValueChanged<double>? onChanged;
  final double min;
  final double max;
  final int? divisions;
  final String? label;
  final bool enabled;

  const GrafitSlider({
    super.key,
    required this.value,
    this.onChanged,
    this.min = 0.0,
    this.max = 1.0,
    this.divisions,
    this.label,
    this.enabled = true,
  });

  @override
  State<GrafitSlider> createState() => _GrafitSliderState();
}

class _GrafitSliderState extends State<GrafitSlider> {
  late double _currentValue;

  @override
  void initState() {
    super.initState();
    _currentValue = widget.value;
  }

  @override
  void didUpdateWidget(GrafitSlider oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      _currentValue = widget.value;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<GrafitTheme>()!;
    final colors = theme.colors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.label != null) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.label!,
                style: TextStyle(
                  color: colors.foreground,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                _currentValue.toStringAsFixed(0),
                style: TextStyle(
                  color: colors.mutedForeground,
                  fontSize: 13,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
        ],
        SliderTheme(
          data: SliderThemeData(
            activeTrackColor: colors.primary,
            inactiveTrackColor: colors.input,
            thumbColor: colors.background,
            overlayColor: colors.primary.withOpacity(0.1),
            valueIndicatorColor: colors.primary,
            trackHeight: 4,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 16),
          ),
          child: Slider(
            value: _currentValue,
            min: widget.min,
            max: widget.max,
            divisions: widget.divisions,
            label: _currentValue.toStringAsFixed(0),
            onChanged: widget.enabled
                ? (value) {
                    setState(() {
                      _currentValue = value;
                    });
                    widget.onChanged?.call(value);
                  }
                : null,
          ),
        ),
      ],
    );
  }
}
