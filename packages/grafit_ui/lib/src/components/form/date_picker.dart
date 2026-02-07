import 'package:flutter/material.dart';
import '../../theme/theme.dart';
import '../../primitives/clickable.dart';
import '../specialized/calendar.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

/// Date picker mode
enum GrafitDatePickerMode {
  /// Single date selection
  single,
  /// Date range selection
  range,
}

/// Date format options
enum GrafitDatePickerDateFormat {
  /// MM/DD/YYYY
  mdyy,
  /// YYYY-MM-DD (ISO)
  iso,
  /// DD/MM/YYYY
  dmyy,
  /// Custom format
  custom,
}

/// Date picker component with calendar popover
///
/// Port of shadcn-ui/ui date-picker component
/// Source: https://github.com/shadcn-ui/ui
class GrafitDatePicker extends StatefulWidget {
  /// Initially selected date
  final DateTime? initialDate;

  /// Initially selected date range
  final DateTimeRange? initialRange;

  /// Selection mode
  final GrafitDatePickerMode mode;

  /// Callback when selection changes
  final ValueChanged<DateTime?>? onDateChanged;
  final ValueChanged<DateTimeRange?>? onRangeChanged;

  /// Minimum selectable date
  final DateTime? firstDate;

  /// Maximum selectable date
  final DateTime? lastDate;

  /// List of disabled dates
  final List<DateTime>? disabledDates;

  /// Function to determine if a date is disabled
  final bool Function(DateTime)? isDateDisabled;

  /// Date format for display
  final GrafitDatePickerDateFormat dateFormat;

  /// Custom date format function
  final String Function(DateTime)? customDateFormat;

  /// Custom date range format function
  final String Function(DateTime, DateTime)? customDateRangeFormat;

  /// Placeholder text when no date is selected
  final String placeholder;

  /// Optional label for the date picker
  final String? label;

  /// Optional error text
  final String? errorText;

  /// Optional helper text
  final String? helperText;

  /// Whether the date picker is enabled
  final bool enabled;

  /// Whether to show the calendar icon
  final bool showCalendarIcon;

  /// Whether to show the clear button
  final bool showClear;

  /// Calendar props to pass through
  final bool showOutsideDays;

  /// Week day to start the calendar (0 = Sunday, 1 = Monday, etc.)
  final int firstDayOfWeek;

  /// Custom weekday labels
  final List<String>? weekdayLabels;

  /// Custom month labels
  final List<String>? monthLabels;

  /// Whether to show week numbers
  final bool showWeekNumbers;

  const GrafitDatePicker({
    super.key,
    this.initialDate,
    this.initialRange,
    this.mode = GrafitDatePickerMode.single,
    this.onDateChanged,
    this.onRangeChanged,
    this.firstDate,
    this.lastDate,
    this.disabledDates,
    this.isDateDisabled,
    this.dateFormat = GrafitDatePickerDateFormat.mdyy,
    this.customDateFormat,
    this.customDateRangeFormat,
    this.placeholder = 'Pick a date',
    this.label,
    this.errorText,
    this.helperText,
    this.enabled = true,
    this.showCalendarIcon = true,
    this.showClear = true,
    this.showOutsideDays = true,
    this.firstDayOfWeek = 0,
    this.weekdayLabels,
    this.monthLabels,
    this.showWeekNumbers = false,
  });

  @override
  State<GrafitDatePicker> createState() => _GrafitDatePickerState();
}

class _GrafitDatePickerState extends State<GrafitDatePicker> {
  DateTime? _selectedDate;
  DateTimeRange? _selectedRange;
  final LayerLink _layerLink = LayerLink();
  final GlobalKey _triggerKey = GlobalKey();
  OverlayEntry? _overlayEntry;
  bool _isOpen = false;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate;
    _selectedRange = widget.initialRange;
  }

  @override
  void dispose() {
    _overlayEntry?.remove();
    super.dispose();
  }

  void _toggle() {
    if (!widget.enabled) return;
    setState(() {
      _isOpen = !_isOpen;
      if (_isOpen) {
        _showPopover();
      } else {
        _hidePopover();
      }
    });
  }

  void _showPopover() {
    setState(() {
      _overlayEntry = OverlayEntry(
        builder: (context) => _GrafitDatePickerPopover(
          layerLink: _layerLink,
          triggerKey: _triggerKey,
          selectedDate: _selectedDate,
          selectedRange: _selectedRange,
          mode: widget.mode,
          firstDate: widget.firstDate,
          lastDate: widget.lastDate,
          disabledDates: widget.disabledDates,
          isDateDisabled: widget.isDateDisabled,
          showOutsideDays: widget.showOutsideDays,
          firstDayOfWeek: widget.firstDayOfWeek,
          weekdayLabels: widget.weekdayLabels,
          monthLabels: widget.monthLabels,
          showWeekNumbers: widget.showWeekNumbers,
          onDateSelected: (date) {
            setState(() {
              if (widget.mode == GrafitDatePickerMode.single) {
                _selectedDate = date;
                widget.onDateChanged?.call(date);
              } else {
                if (_selectedRange == null) {
                  _selectedRange = DateTimeRange(start: date, end: date);
                } else {
                  final start = _normalizeDate(_selectedRange!.start);
                  final normalized = _normalizeDate(date);
                  if (normalized.isBefore(start)) {
                    _selectedRange = DateTimeRange(start: normalized, end: start);
                  } else if (normalized.isAfter(start)) {
                    _selectedRange = DateTimeRange(start: start, end: normalized);
                  } else {
                    _selectedRange = null;
                  }
                }
                widget.onRangeChanged?.call(_selectedRange);
              }
            });
            // Auto-close on single selection
            if (widget.mode == GrafitDatePickerMode.single) {
              _hidePopover();
              setState(() {
                _isOpen = false;
              });
            }
          },
          onDismiss: _toggle,
        ),
      );
      Overlay.of(context).insert(_overlayEntry!);
    });
  }

  void _hidePopover() {
    _overlayEntry?.remove();
    setState(() {
      _overlayEntry = null;
      _isOpen = false;
    });
  }

  void _clear() {
    setState(() {
      _selectedDate = null;
      _selectedRange = null;
      widget.onDateChanged?.call(null);
      widget.onRangeChanged?.call(null);
    });
  }

  DateTime _normalizeDate(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  String _formatDate(DateTime date) {
    if (widget.customDateFormat != null) {
      return widget.customDateFormat!(date);
    }

    switch (widget.dateFormat) {
      case GrafitDatePickerDateFormat.mdyy:
        return '${_twoDigit(date.month)}/${_twoDigit(date.day)}/${date.year}';
      case GrafitDatePickerDateFormat.iso:
        return '${date.year}-${_twoDigit(date.month)}-${_twoDigit(date.day)}';
      case GrafitDatePickerDateFormat.dmyy:
        return '${_twoDigit(date.day)}/${_twoDigit(date.month)}/${date.year}';
      case GrafitDatePickerDateFormat.custom:
        return widget.customDateFormat?.call(date) ?? date.toString();
    }
  }

  String _formatDateRange(DateTimeRange range) {
    if (widget.customDateRangeFormat != null) {
      return widget.customDateRangeFormat!(range.start, range.end);
    }
    return '${_formatDate(range.start)} - ${_formatDate(range.end)}';
  }

  String _twoDigit(int value) {
    return value.toString().padLeft(2, '0');
  }

  String _getDisplayText() {
    if (widget.mode == GrafitDatePickerMode.single) {
      return _selectedDate != null ? _formatDate(_selectedDate!) : '';
    } else {
      return _selectedRange != null ? _formatDateRange(_selectedRange!) : '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final effectiveEnabled = widget.enabled;
    final hasError = widget.errorText != null;

    Widget content = GrafitClickable(
      enabled: effectiveEnabled,
      onTap: _toggle,
      child: CompositedTransformTarget(
        link: _layerLink,
        key: _triggerKey,
        child: _GrafitDatePickerTrigger(
          displayText: _getDisplayText(),
          placeholder: widget.placeholder,
          enabled: effectiveEnabled,
          isOpen: _isOpen,
          hasError: hasError,
          showCalendarIcon: widget.showCalendarIcon,
          showClear: widget.showClear && _getDisplayText().isNotEmpty,
          onClear: _clear,
        ),
      ),
    );

    if (widget.label != null) {
      content = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _GrafitDatePickerLabel(
            label: widget.label!,
            enabled: effectiveEnabled,
          ),
          const SizedBox(height: 6),
          content,
        ],
      );
    }

    if (widget.errorText != null || widget.helperText != null) {
      content = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          content,
          const SizedBox(height: 4),
          _GrafitDatePickerHelperText(
            errorText: widget.errorText,
            helperText: widget.helperText,
            hasError: hasError,
          ),
        ],
      );
    }

    return content;
  }
}

/// Date picker trigger/input widget
class _GrafitDatePickerTrigger extends StatelessWidget {
  final String displayText;
  final String placeholder;
  final bool enabled;
  final bool isOpen;
  final bool hasError;
  final bool showCalendarIcon;
  final bool showClear;
  final VoidCallback onClear;

  const _GrafitDatePickerTrigger({
    required this.displayText,
    required this.placeholder,
    required this.enabled,
    required this.isOpen,
    required this.hasError,
    required this.showCalendarIcon,
    required this.showClear,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<GrafitTheme>()!;
    final colors = theme.colors;

    final borderColor = hasError
        ? colors.destructive
        : context.isClickableFocused
            ? colors.ring
            : context.isClickableHovered && enabled
                ? colors.input
                : colors.border;

    return Container(
      constraints: const BoxConstraints(
        minWidth: 200,
        minHeight: 36,
      ),
      decoration: BoxDecoration(
        color: enabled ? colors.background : colors.muted,
        border: Border.all(
          color: borderColor,
          width: context.isClickableFocused ? 2.0 : 1.0,
        ),
        borderRadius: BorderRadius.circular(colors.radius * 8),
        boxShadow: context.isClickableFocused && enabled
            ? [
                BoxShadow(
                  color: colors.ring.withValues(alpha: 0.2),
                  blurRadius: 4,
                  spreadRadius: 0,
                ),
              ]
            : null,
      ),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Text(
                displayText.isNotEmpty ? displayText : placeholder,
                style: TextStyle(
                  color: displayText.isNotEmpty
                      ? (enabled ? colors.foreground : colors.mutedForeground)
                      : colors.mutedForeground,
                  fontSize: 14,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          if (showClear && displayText.isNotEmpty)
            GrafitClickable(
              enabled: enabled,
              onTap: onClear,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Icon(
                  Icons.close,
                  size: 16,
                  color: colors.mutedForeground,
                ),
              ),
            ),
          if (showCalendarIcon)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Icon(
                Icons.calendar_month,
                size: 16,
                color: colors.mutedForeground,
              ),
            ),
        ],
      ),
    );
  }
}

/// Date picker label widget
class _GrafitDatePickerLabel extends StatelessWidget {
  final String label;
  final bool enabled;

  const _GrafitDatePickerLabel({
    required this.label,
    required this.enabled,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<GrafitTheme>()!;
    final colors = theme.colors;

    return Text(
      label,
      style: TextStyle(
        color: enabled ? colors.foreground : colors.mutedForeground,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}

/// Date picker helper/error text widget
class _GrafitDatePickerHelperText extends StatelessWidget {
  final String? errorText;
  final String? helperText;
  final bool hasError;

  const _GrafitDatePickerHelperText({
    this.errorText,
    this.helperText,
    required this.hasError,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<GrafitTheme>()!;
    final colors = theme.colors;

    final text = hasError ? errorText! : helperText!;
    final textColor = hasError ? colors.destructive : colors.mutedForeground;

    return Text(
      text,
      style: TextStyle(
        color: textColor,
        fontSize: 12,
      ),
    );
  }
}

/// Date picker popover with calendar
class _GrafitDatePickerPopover extends StatefulWidget {
  final LayerLink layerLink;
  final GlobalKey triggerKey;
  final DateTime? selectedDate;
  final DateTimeRange? selectedRange;
  final GrafitDatePickerMode mode;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final List<DateTime>? disabledDates;
  final bool Function(DateTime)? isDateDisabled;
  final bool showOutsideDays;
  final int firstDayOfWeek;
  final List<String>? weekdayLabels;
  final List<String>? monthLabels;
  final bool showWeekNumbers;
  final ValueChanged<DateTime> onDateSelected;
  final VoidCallback onDismiss;

  const _GrafitDatePickerPopover({
    required this.layerLink,
    required this.triggerKey,
    required this.selectedDate,
    required this.selectedRange,
    required this.mode,
    this.firstDate,
    this.lastDate,
    this.disabledDates,
    this.isDateDisabled,
    required this.showOutsideDays,
    required this.firstDayOfWeek,
    this.weekdayLabels,
    this.monthLabels,
    required this.showWeekNumbers,
    required this.onDateSelected,
    required this.onDismiss,
  });

  @override
  State<_GrafitDatePickerPopover> createState() => _GrafitDatePickerPopoverState();
}

class _GrafitDatePickerPopoverState extends State<_GrafitDatePickerPopover>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.95, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final triggerContext = widget.triggerKey.currentContext;
    if (triggerContext == null) {
      return const SizedBox.shrink();
    }

    final renderBox = triggerContext.findRenderObject() as RenderBox?;
    if (renderBox == null) {
      return const SizedBox.shrink();
    }

    final position = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;

    return Positioned.fill(
      child: GestureDetector(
        onTap: widget.onDismiss,
        behavior: HitTestBehavior.translucent,
        child: CustomSingleChildLayout(
          delegate: _GrafitDatePickerDelegate(
            layerLink: widget.layerLink,
            targetSize: size,
            targetPosition: position,
          ),
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Opacity(
                opacity: _fadeAnimation.value,
                child: Transform.scale(
                  scale: _scaleAnimation.value,
                  alignment: Alignment.topLeft,
                  child: child,
                ),
              );
            },
            child: _GrafitDatePickerContent(
              selectedDate: widget.selectedDate,
              selectedRange: widget.selectedRange,
              mode: widget.mode,
              firstDate: widget.firstDate,
              lastDate: widget.lastDate,
              disabledDates: widget.disabledDates,
              isDateDisabled: widget.isDateDisabled,
              showOutsideDays: widget.showOutsideDays,
              firstDayOfWeek: widget.firstDayOfWeek,
              weekdayLabels: widget.weekdayLabels,
              monthLabels: widget.monthLabels,
              showWeekNumbers: widget.showWeekNumbers,
              onDateSelected: widget.onDateSelected,
            ),
          ),
        ),
      ),
    );
  }
}

/// Date picker content container with calendar
class _GrafitDatePickerContent extends StatelessWidget {
  final DateTime? selectedDate;
  final DateTimeRange? selectedRange;
  final GrafitDatePickerMode mode;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final List<DateTime>? disabledDates;
  final bool Function(DateTime)? isDateDisabled;
  final bool showOutsideDays;
  final int firstDayOfWeek;
  final List<String>? weekdayLabels;
  final List<String>? monthLabels;
  final bool showWeekNumbers;
  final ValueChanged<DateTime> onDateSelected;

  const _GrafitDatePickerContent({
    required this.selectedDate,
    required this.selectedRange,
    required this.mode,
    this.firstDate,
    this.lastDate,
    this.disabledDates,
    this.isDateDisabled,
    required this.showOutsideDays,
    required this.firstDayOfWeek,
    this.weekdayLabels,
    this.monthLabels,
    required this.showWeekNumbers,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<GrafitTheme>()!;
    final colors = theme.colors;

    return Container(
      decoration: BoxDecoration(
        color: colors.popover,
        borderRadius: BorderRadius.circular(colors.radius * 6),
        border: Border.all(color: colors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(4),
      child: GrafitCalendar(
        mode: mode == GrafitDatePickerMode.single
            ? GrafitCalendarMode.single
            : GrafitCalendarMode.range,
        initialDate: selectedDate,
        initialRange: selectedRange,
        firstDate: firstDate,
        lastDate: lastDate,
        disabledDates: disabledDates,
        isDateDisabled: isDateDisabled,
        showOutsideDays: showOutsideDays,
        firstDayOfWeek: firstDayOfWeek,
        weekdayLabels: weekdayLabels,
        monthLabels: monthLabels,
        showWeekNumbers: showWeekNumbers,
        onDateChanged: mode == GrafitDatePickerMode.single ? (date) => onDateSelected(date!) : null,
        onRangeChanged: mode == GrafitDatePickerMode.range
            ? (range) {
                // Range selection is handled internally
              }
            : null,
        padding: const EdgeInsets.all(8),
      ),
    );
  }
}

/// Custom layout delegate for positioning date picker popover
class _GrafitDatePickerDelegate extends SingleChildLayoutDelegate {
  final LayerLink layerLink;
  final Size targetSize;
  final Offset targetPosition;

  _GrafitDatePickerDelegate({
    required this.layerLink,
    required this.targetSize,
    required this.targetPosition,
  });

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    return BoxConstraints(
      minWidth: 300,
      maxWidth: 400,
    );
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    double x = targetPosition.dx;
    double y = targetPosition.dy + targetSize.height + 4;

    // Ensure popover doesn't go off screen
    final popoverWidth = 320.0;
    if (x + popoverWidth > size.width) {
      x = size.width - popoverWidth - 8;
    }
    if (x < 8) {
      x = 8;
    }

    final popoverHeight = 350.0;
    if (y + popoverHeight > size.height) {
      y = targetPosition.dy - popoverHeight - 4;
      if (y < 8) {
        y = 8;
      }
    }

    return Offset(x, y);
  }

  @override
  bool shouldRelayout(_GrafitDatePickerDelegate oldDelegate) {
    return true;
  }
}

/// Preset date range picker shortcuts
class GrafitDatePickerPreset extends StatelessWidget {
  final String label;
  final DateTimeRange range;

  const GrafitDatePickerPreset({
    super.key,
    required this.label,
    required this.range,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<GrafitTheme>()!;
    final colors = theme.colors;

    return GrafitClickable(
      onTap: () {
        // Return the preset range
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: context.isClickableHovered ? colors.muted : null,
          borderRadius: BorderRadius.circular(colors.radius * 4),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: colors.foreground,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}

/// Date picker with presets
class GrafitDatePickerWithPresets extends StatefulWidget {
  final DateTime? initialDate;
  final DateTimeRange? initialRange;
  final GrafitDatePickerMode mode;
  final ValueChanged<DateTime?>? onDateChanged;
  final ValueChanged<DateTimeRange?>? onRangeChanged;
  final String placeholder;
  final String? label;
  final List<GrafitDatePickerPresetData>? presets;
  final bool enabled;

  const GrafitDatePickerWithPresets({
    super.key,
    this.initialDate,
    this.initialRange,
    this.mode = GrafitDatePickerMode.range,
    this.onDateChanged,
    this.onRangeChanged,
    this.placeholder = 'Pick a date',
    this.label,
    this.presets,
    this.enabled = true,
  });

  @override
  State<GrafitDatePickerWithPresets> createState() => _GrafitDatePickerWithPresetsState();
}

class _GrafitDatePickerWithPresetsState extends State<GrafitDatePickerWithPresets> {
  @override
  Widget build(BuildContext context) {
    // For now, just return the regular date picker
    // In a full implementation, this would include presets section
    return GrafitDatePicker(
      initialDate: widget.initialDate,
      initialRange: widget.initialRange,
      mode: widget.mode,
      onDateChanged: widget.onDateChanged,
      onRangeChanged: widget.onRangeChanged,
      placeholder: widget.placeholder,
      label: widget.label,
      enabled: widget.enabled,
    );
  }
}

/// Preset date range data
class GrafitDatePickerPresetData {
  final String label;
  final DateTimeRange range;

  const GrafitDatePickerPresetData({
    required this.label,
    required this.range,
  });
}

// Widgetbook use cases
@widgetbook.UseCase(
  name: 'Default',
  type: GrafitDatePicker,
  path: 'Form/DatePicker',
)
Widget datePickerDefault(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.all(16.0),
    child: GrafitDatePicker(
      placeholder: 'Pick a date',
    ),
  );
}

@widgetbook.UseCase(
  name: 'With Label',
  type: GrafitDatePicker,
  path: 'Form/DatePicker',
)
Widget datePickerWithLabel(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.all(16.0),
    child: GrafitDatePicker(
      label: 'Date of Birth',
      placeholder: 'Select your date of birth',
    ),
  );
}

@widgetbook.UseCase(
  name: 'With Preselected Date',
  type: GrafitDatePicker,
  path: 'Form/DatePicker',
)
Widget datePickerWithDate(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: GrafitDatePicker(
      label: 'Appointment Date',
      placeholder: 'Select appointment date',
      initialDate: DateTime.now().add(const Duration(days: 7)),
    ),
  );
}

@widgetbook.UseCase(
  name: 'Range Mode',
  type: GrafitDatePicker,
  path: 'Form/DatePicker',
)
Widget datePickerRange(BuildContext context) {
  final now = DateTime.now();
  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: GrafitDatePicker(
      label: 'Date Range',
      placeholder: 'Select date range',
      mode: GrafitDatePickerMode.range,
      initialRange: DateTimeRange(
        start: now,
        end: now.add(const Duration(days: 7)),
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'Error State',
  type: GrafitDatePicker,
  path: 'Form/DatePicker',
)
Widget datePickerError(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.all(16.0),
    child: GrafitDatePicker(
      label: 'Due Date',
      placeholder: 'Select a date',
      errorText: 'Please select a valid future date',
    ),
  );
}

@widgetbook.UseCase(
  name: 'Disabled',
  type: GrafitDatePicker,
  path: 'Form/DatePicker',
)
Widget datePickerDisabled(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.all(16.0),
    child: GrafitDatePicker(
      label: 'Disabled Date Picker',
      placeholder: 'Cannot select date',
      enabled: false,
    ),
  );
}

@widgetbook.UseCase(
  name: 'With Helper Text',
  type: GrafitDatePicker,
  path: 'Form/DatePicker',
)
Widget datePickerWithHelper(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.all(16.0),
    child: GrafitDatePicker(
      label: 'Start Date',
      placeholder: 'Choose start date',
      helperText: 'Select the first day of your event',
    ),
  );
}

@widgetbook.UseCase(
  name: 'Interactive',
  type: GrafitDatePicker,
  path: 'Form/DatePicker',
)
Widget datePickerInteractive(BuildContext context) {
  final placeholder = context.knobs.string(label: 'Placeholder', initialValue: 'Pick a date');
  final label = context.knobs.string(label: 'Label', initialValue: 'Date');
  final enabled = context.knobs.boolean(label: 'Enabled', initialValue: true);
  final hasError = context.knobs.boolean(label: 'Has Error', initialValue: false);
  final hasHelper = context.knobs.boolean(label: 'Has Helper', initialValue: false);
  final isRange = context.knobs.boolean(label: 'Range Mode', initialValue: false);
  final showCalendarIcon = context.knobs.boolean(label: 'Show Icon', initialValue: true);
  final showClear = context.knobs.boolean(label: 'Show Clear', initialValue: true);

  final now = DateTime.now();

  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: GrafitDatePicker(
      label: label.isNotEmpty ? label : null,
      placeholder: placeholder.isNotEmpty ? placeholder : null,
      enabled: enabled,
      errorText: hasError ? 'This field is required' : null,
      helperText: hasHelper ? 'Select a valid date' : null,
      mode: isRange ? GrafitDatePickerMode.range : GrafitDatePickerMode.single,
      showCalendarIcon: showCalendarIcon,
      showClear: showClear,
      initialDate: now.add(const Duration(days: 3)),
      initialRange: isRange
          ? DateTimeRange(
              start: now,
              end: now.add(const Duration(days: 7)),
            )
          : null,
    ),
  );
}
