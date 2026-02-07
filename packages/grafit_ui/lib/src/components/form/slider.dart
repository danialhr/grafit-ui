import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../theme/theme.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

/// Slider orientation
enum GrafitSliderOrientation {
  horizontal,
  vertical,
}

/// Slider component - supports both single value and multi-thumb (range) modes
class GrafitSlider extends StatefulWidget {
  /// Single value mode
  final double value;
  /// Multi-thumb mode (range slider)
  final List<double>? values;
  final ValueChanged<double>? onChanged;
  final ValueChanged<List<double>>? onRangeChanged;
  final double min;
  final double max;
  final int? divisions;
  final String? label;
  final bool enabled;
  final GrafitSliderOrientation orientation;

  const GrafitSlider({
    super.key,
    required this.value,
    this.values,
    this.onChanged,
    this.onRangeChanged,
    this.min = 0.0,
    this.max = 1.0,
    this.divisions,
    this.label,
    this.enabled = true,
    this.orientation = GrafitSliderOrientation.horizontal,
  });

  @override
  State<GrafitSlider> createState() => _GrafitSliderState();
}

class _GrafitSliderState extends State<GrafitSlider> {
  late double _currentValue;
  late List<double> _currentValues;
  int? _activeThumbIndex;
  double? _dragStartValue;

  @override
  void initState() {
    super.initState();
    _currentValue = widget.value;
    _currentValues = widget.values ?? [widget.value];
    _activeThumbIndex = null;
  }

  @override
  void didUpdateWidget(GrafitSlider oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value && widget.values == null) {
      _currentValue = widget.value;
    }
    if (widget.values != null && widget.values != oldWidget.values) {
      _currentValues = List.from(widget.values!);
    }
  }

  bool get isMultiThumb => widget.values != null && widget.onRangeChanged != null;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<GrafitTheme>()!;
    final colors = theme.colors;

    if (isMultiThumb) {
      return _buildMultiThumbSlider(colors, theme);
    }

    return _buildSingleThumbSlider(colors, theme);
  }

  Widget _buildSingleThumbSlider(GrafitColorScheme colors, GrafitTheme theme) {
    final sliderWidget = SliderTheme(
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
    );

    if (widget.orientation == GrafitSliderOrientation.vertical) {
      return SizedBox(
        height: 200,
        child: RotatedBox(
          quarterTurns: 1,
          child: sliderWidget,
        ),
      );
    }

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
        sliderWidget,
      ],
    );
  }

  Widget _buildMultiThumbSlider(GrafitColorScheme colors, GrafitTheme theme) {
    return _GrafitMultiThumbSlider(
      values: _currentValues,
      min: widget.min,
      max: widget.max,
      divisions: widget.divisions,
      enabled: widget.enabled,
      orientation: widget.orientation,
      colors: colors,
      theme: theme,
      label: widget.label,
      onChanged: widget.enabled
          ? (newValues, changedIndex) {
              setState(() {
                _currentValues = newValues;
              });
              widget.onRangeChanged?.call(newValues);
            }
          : null,
    );
  }
}

/// Multi-thumb slider widget
class _GrafitMultiThumbSlider extends StatefulWidget {
  final List<double> values;
  final double min;
  final double max;
  final int? divisions;
  final bool enabled;
  final GrafitSliderOrientation orientation;
  final GrafitColorScheme colors;
  final GrafitTheme theme;
  final String? label;
  final ValueChanged<List<double>>? onChanged;

  const _GrafitMultiThumbSlider({
    required this.values,
    required this.min,
    required this.max,
    this.divisions,
    required this.enabled,
    required this.orientation,
    required this.colors,
    required this.theme,
    this.label,
    this.onChanged,
  });

  @override
  State<_GrafitMultiThumbSlider> createState() => _GrafitMultiThumbSliderState();
}

class _GrafitMultiThumbSliderState extends State<_GrafitMultiThumbSlider> {
  int? _activeThumbIndex;
  Offset? _dragStartPosition;

  @override
  Widget build(BuildContext context) {
    final isVertical = widget.orientation == GrafitSliderOrientation.vertical;

    Widget sliderWidget = LayoutBuilder(
      builder: (context, constraints) {
        final trackLength = isVertical
            ? constraints.maxHeight
            : constraints.maxWidth;
        final trackThickness = 4.0;
        final thumbRadius = 6.0;
        final overlayRadius = 16.0;

        return SizedBox(
          width: isVertical ? trackThickness + overlayRadius * 2 : trackLength,
          height: isVertical ? trackLength : trackThickness + overlayRadius * 2,
          child: Stack(
            children: [
              // Track background
              _buildTrack(trackLength, trackThickness, isVertical),
              // Active track between thumbs
              ..._buildActiveTracks(trackLength, trackThickness, isVertical),
              // Thumbs
              ..._buildThumbs(trackLength, thumbRadius, overlayRadius, isVertical),
            ],
          ),
        );
      },
    );

    if (isVertical) {
      return SizedBox(
        height: 200,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildVerticalLabels(),
            const SizedBox(width: 8),
            sliderWidget,
          ],
        ),
      );
    }

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
                  color: widget.colors.foreground,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                widget.values.map((v) => v.toStringAsFixed(0)).join(' - '),
                style: TextStyle(
                  color: widget.colors.mutedForeground,
                  fontSize: 13,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
        ],
        sliderWidget,
      ],
    );
  }

  Widget _buildVerticalLabels() {
    if (widget.label == null) return const SizedBox.shrink();

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          widget.values.last.toStringAsFixed(0),
          style: TextStyle(
            color: widget.colors.mutedForeground,
            fontSize: 13,
          ),
        ),
        if (widget.label != null)
          Text(
            widget.label!,
            style: TextStyle(
              color: widget.colors.foreground,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        Text(
          widget.values.first.toStringAsFixed(0),
          style: TextStyle(
            color: widget.colors.mutedForeground,
            fontSize: 13,
          ),
        ),
      ],
    );
  }

  Widget _buildTrack(double length, double thickness, bool isVertical) {
    return Positioned(
      left: isVertical ? (thickness + 16) / 2 - thickness / 2 : 0,
      top: isVertical ? 0 : 16,
      child: Container(
        width: isVertical ? thickness : length,
        height: isVertical ? length : thickness,
        decoration: BoxDecoration(
          color: widget.colors.input,
          borderRadius: BorderRadius.circular(thickness / 2),
        ),
      ),
    );
  }

  List<Widget> _buildActiveTracks(double length, double thickness, bool isVertical) {
    final tracks = <Widget>[];
    final sortedValues = List.from(widget.values)..sort();

    for (int i = 0; i < sortedValues.length - 1; i++) {
      final startValue = sortedValues[i];
      final endValue = sortedValues[i + 1];

      final start = _valueToPixels(startValue, length, isVertical);
      final end = _valueToPixels(endValue, length, isVertical);

      if (isVertical) {
        tracks.add(Positioned(
          left: (thickness + 32) / 2 - thickness / 2,
          top: math.min(start, end),
          child: Container(
            width: thickness,
            height: (end - start).abs(),
            decoration: BoxDecoration(
              color: widget.colors.primary,
              borderRadius: BorderRadius.circular(thickness / 2),
            ),
          ),
        ));
      } else {
        tracks.add(Positioned(
          left: math.min(start, end) + 16,
          top: 0,
          child: Container(
            width: (end - start).abs(),
            height: thickness,
            decoration: BoxDecoration(
              color: widget.colors.primary,
              borderRadius: BorderRadius.circular(thickness / 2),
            ),
          ),
        ));
      }
    }

    return tracks;
  }

  List<Widget> _buildThumbs(double length, double thumbRadius, double overlayRadius, bool isVertical) {
    final thumbs = <Widget>[];

    for (int i = 0; i < widget.values.length; i++) {
      final value = widget.values[i];
      final position = _valueToPixels(value, length, isVertical);
      final isActive = _activeThumbIndex == i;

      final thumb = GestureDetector(
        onPanStart: widget.enabled
            ? (details) {
                setState(() {
                  _activeThumbIndex = i;
                  _dragStartPosition = details.localPosition;
                });
              }
            : null,
        onPanUpdate: widget.enabled
            ? (details) {
                if (_activeThumbIndex == i) {
                  _updateThumbPosition(i, details.delta, length, isVertical);
                }
              }
            : null,
        onPanEnd: widget.enabled
            ? (details) {
                setState(() {
                  _activeThumbIndex = null;
                  _dragStartPosition = null;
                });
              }
            : null,
        child: MouseRegion(
          cursor: isVertical
              ? SystemMouseCursors.resizeUpDown
              : SystemMouseCursors.resizeLeftRight,
          child: Container(
            width: isVertical ? thumbRadius * 2 + overlayRadius * 2 : thumbRadius * 2,
            height: isVertical ? thumbRadius * 2 : thumbRadius * 2 + overlayRadius * 2,
            decoration: BoxDecoration(
              color: isActive
                  ? widget.colors.primary.withOpacity(0.1)
                  : Colors.transparent,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Container(
                width: thumbRadius * 2,
                height: thumbRadius * 2,
                decoration: BoxDecoration(
                  color: widget.colors.background,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: widget.colors.primary,
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: widget.colors.shadow.withOpacity(0.2),
                      blurRadius: 4,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );

      if (isVertical) {
        thumbs.add(Positioned(
          left: 0,
          top: position - thumbRadius,
          child: thumb,
        ));
      } else {
        thumbs.add(Positioned(
          left: position - thumbRadius + 16,
          top: 0,
          child: thumb,
        ));
      }
    }

    return thumbs;
  }

  double _valueToPixels(double value, double length, bool isVertical) {
    final range = widget.max - widget.min;
    final normalizedValue = (value - widget.min) / range;
    return normalizedValue * length;
  }

  double _pixelsToValue(double pixels, double length) {
    final range = widget.max - widget.min;
    final normalizedValue = (pixels / length).clamp(0.0, 1.0);
    double value = widget.min + normalizedValue * range;

    if (widget.divisions != null) {
      final step = range / widget.divisions!;
      value = (value / step).round() * step;
    }

    return value.clamp(widget.min, widget.max);
  }

  void _updateThumbPosition(int thumbIndex, Offset delta, double length, bool isVertical) {
    final pixelDelta = isVertical ? delta.dy : delta.dx;
    final currentValue = widget.values[thumbIndex];
    final currentPixels = _valueToPixels(currentValue, length, isVertical);
    final newPixels = currentPixels + pixelDelta;
    final newValue = _pixelsToValue(newPixels, length);

    // Apply constraints
    final sortedValues = List.from(widget.values)..sort();
    final valueIndexInSorted = sortedValues.indexOf(currentValue);

    double constrainedValue = newValue;

    if (valueIndexInSorted > 0) {
      constrainedValue = constrainedValue.clamp(
        sortedValues[valueIndexInSorted - 1],
        double.infinity,
      );
    }
    if (valueIndexInSorted < sortedValues.length - 1) {
      constrainedValue = constrainedValue.clamp(
        double.negativeInfinity,
        sortedValues[valueIndexInSorted + 1],
      );
    }

    final newValues = List<double>.from(widget.values);
    newValues[thumbIndex] = constrainedValue;
    widget.onChanged?.call(newValues, thumbIndex);
  }
}

// Widgetbook use cases
@widgetbook.UseCase(
  name: 'Default',
  type: GrafitSlider,
  path: 'Form/Slider',
)
Widget sliderDefault(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.all(16.0),
    child: GrafitSlider(
      value: 0.5,
      label: 'Volume',
    ),
  );
}

@widgetbook.UseCase(
  name: 'Without Label',
  type: GrafitSlider,
  path: 'Form/Slider',
)
Widget sliderWithoutLabel(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.all(16.0),
    child: GrafitSlider(
      value: 0.3,
    ),
  );
}

@widgetbook.UseCase(
  name: 'With Divisions',
  type: GrafitSlider,
  path: 'Form/Slider',
)
Widget sliderWithDivisions(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.all(16.0),
    child: GrafitSlider(
      value: 0.5,
      label: 'Brightness',
      divisions: 10,
      min: 0,
      max: 100,
    ),
  );
}

@widgetbook.UseCase(
  name: 'Disabled',
  type: GrafitSlider,
  path: 'Form/Slider',
)
Widget sliderDisabled(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.all(16.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GrafitSlider(
          value: 0.3,
          label: 'Disabled slider',
          enabled: false,
        ),
      ],
    ),
  );
}

@widgetbook.UseCase(
  name: 'Range Slider',
  type: GrafitSlider,
  path: 'Form/Slider',
)
Widget sliderRange(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.all(16.0),
    child: GrafitSlider(
      value: 0.5,
      values: [0.2, 0.8],
      label: 'Price Range',
      min: 0,
      max: 1000,
      onRangeChanged: null,
    ),
  );
}

@widgetbook.UseCase(
  name: 'Vertical',
  type: GrafitSlider,
  path: 'Form/Slider',
)
Widget sliderVertical(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.all(16.0),
    child: GrafitSlider(
      value: 0.6,
      label: 'Vertical',
      orientation: GrafitSliderOrientation.vertical,
    ),
  );
}

@widgetbook.UseCase(
  name: 'Multiple Sliders',
  type: GrafitSlider,
  path: 'Form/Slider',
)
Widget sliderMultiple(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.all(16.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GrafitSlider(
          value: 0.5,
          label: 'Volume',
        ),
        SizedBox(height: 24),
        GrafitSlider(
          value: 0.7,
          label: 'Brightness',
        ),
        SizedBox(height: 24),
        GrafitSlider(
          value: 0.3,
          label: 'Contrast',
        ),
      ],
    ),
  );
}

@widgetbook.UseCase(
  name: 'Interactive',
  type: GrafitSlider,
  path: 'Form/Slider',
)
Widget sliderInteractive(BuildContext context) {
  // Widgetbook-only: ignore undefined_getter, undefined_method, invalid_annotation_value
  final label = context.knobs.string(label: 'Label', initialValue: 'Value');
  // Widgetbook-only: ignore undefined_getter, undefined_method, invalid_annotation_value
  final value = context.knobs.double.slider(label: 'Value', initialValue: 0.5, min: 0, max: 1);
  // Widgetbook-only: ignore undefined_getter, undefined_method, invalid_annotation_value
  final enabled = context.knobs.boolean(label: 'Enabled', initialValue: true);
  // Widgetbook-only: ignore undefined_getter, undefined_method, invalid_annotation_value
  final divisions = context.knobs.nullable.int.input(label: 'Divisions', initialValue: null);
  // Widgetbook-only: ignore undefined_getter, undefined_method, invalid_annotation_value
  final isRange = context.knobs.boolean(label: 'Range Slider', initialValue: false);
  // Widgetbook-only: ignore undefined_getter, undefined_method, invalid_annotation_value
  final isVertical = context.knobs.boolean(label: 'Vertical', initialValue: false);

  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: GrafitSlider(
      value: value,
      values: isRange ? [0.2, value] : null,
      label: label.isNotEmpty ? label : null,
      enabled: enabled,
      divisions: divisions,
      orientation: isVertical ? GrafitSliderOrientation.vertical : GrafitSliderOrientation.horizontal,
    ),
  );
}
