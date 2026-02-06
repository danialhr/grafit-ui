import 'package:flutter/material.dart';
import '../../theme/theme.dart';
import '../form/button.dart';

/// Calendar selection mode
enum GrafitCalendarMode {
  /// Single date selection
  single,
  /// Multiple date selection
  multiple,
  /// Range selection
  range,
}

/// Calendar caption layout
enum GrafitCalendarCaptionLayout {
  /// Show label only
  label,
  /// Show dropdown for month/year
  dropdown,
}

/// Calendar component with full feature parity
///
/// Port of shadcn-ui/ui calendar component
/// Source: https://github.com/shadcn-ui/ui
class GrafitCalendar extends StatefulWidget {
  /// Initially selected date(s)
  final DateTime? initialDate;
  final List<DateTime>? initialDates;
  final DateTimeRange? initialRange;

  /// Selection mode
  final GrafitCalendarMode mode;

  /// Callback when selection changes
  final ValueChanged<DateTime?>? onDateChanged;
  final ValueChanged<List<DateTime>>? onDatesChanged;
  final ValueChanged<DateTimeRange?>? onRangeChanged;

  /// Minimum selectable date
  final DateTime? firstDate;
  /// Maximum selectable date
  final DateTime? lastDate;

  /// Initially displayed month
  final DateTime? initialMonth;

  /// Whether to show days from outside the current month
  final bool showOutsideDays;

  /// Caption layout style
  final GrafitCalendarCaptionLayout captionLayout;

  /// Week day to start the calendar (0 = Sunday, 1 = Monday, etc.)
  final int firstDayOfWeek;

  /// List of disabled dates
  final List<DateTime>? disabledDates;

  /// Function to determine if a date is disabled
  final bool Function(DateTime)? isDateDisabled;

  /// Function to determine custom styles for a date
  final GrafitCalendarDayStyle? Function(DateTime)? getDayStyle;

  /// Custom weekday labels (null for default)
  final List<String>? weekdayLabels;

  /// Custom month labels (null for default)
  final List<String>? monthLabels;

  /// Whether to show week numbers
  final bool showWeekNumbers;

  /// Custom button variant for navigation
  final GrafitButtonVariant navButtonVariant;

  /// Padding around the calendar
  final EdgeInsetsGeometry? padding;

  const GrafitCalendar({
    super.key,
    this.initialDate,
    this.initialDates,
    this.initialRange,
    this.mode = GrafitCalendarMode.single,
    this.onDateChanged,
    this.onDatesChanged,
    this.onRangeChanged,
    this.firstDate,
    this.lastDate,
    this.initialMonth,
    this.showOutsideDays = true,
    this.captionLayout = GrafitCalendarCaptionLayout.label,
    this.firstDayOfWeek = 0,
    this.disabledDates,
    this.isDateDisabled,
    this.getDayStyle,
    this.weekdayLabels,
    this.monthLabels,
    this.showWeekNumbers = false,
    this.navButtonVariant = GrafitButtonVariant.ghost,
    this.padding,
  });

  @override
  State<GrafitCalendar> createState() => _GrafitCalendarState();
}

class _GrafitCalendarState extends State<GrafitCalendar> {
  late DateTime _displayedMonth;
  DateTime? _selectedDate;
  List<DateTime> _selectedDates = [];
  DateTimeRange? _selectedRange;

  @override
  void initState() {
    super.initState();
    _displayedMonth = widget.initialMonth ?? _normalizeDate(DateTime.now());
    _initializeSelection();
  }

  void _initializeSelection() {
    switch (widget.mode) {
      case GrafitCalendarMode.single:
        _selectedDate = widget.initialDate != null
            ? _normalizeDate(widget.initialDate!)
            : null;
        break;
      case GrafitCalendarMode.multiple:
        _selectedDates = widget.initialDates?.map(_normalizeDate).toList() ?? [];
        break;
      case GrafitCalendarMode.range:
        _selectedRange = widget.initialRange;
        break;
    }
  }

  DateTime _normalizeDate(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  bool _isDateSelected(DateTime date) {
    final normalized = _normalizeDate(date);
    switch (widget.mode) {
      case GrafitCalendarMode.single:
        return _selectedDate != null && _isSameDay(normalized, _selectedDate!);
      case GrafitCalendarMode.multiple:
        return _selectedDates.any((d) => _isSameDay(normalized, d));
      case GrafitCalendarMode.range:
        if (_selectedRange == null) return false;
        final start = _normalizeDate(_selectedRange!.start);
        final end = _normalizeDate(_selectedRange!.end);
        return !normalized.isBefore(start) && !normalized.isAfter(end);
    }
  }

  bool _isRangeStart(DateTime date) {
    if (_selectedRange == null) return false;
    return _isSameDay(_normalizeDate(date), _normalizeDate(_selectedRange!.start));
  }

  bool _isRangeEnd(DateTime date) {
    if (_selectedRange == null) return false;
    return _isSameDay(_normalizeDate(date), _normalizeDate(_selectedRange!.end));
  }

  bool _isRangeMiddle(DateTime date) {
    if (_selectedRange == null) return false;
    final normalized = _normalizeDate(date);
    final start = _normalizeDate(_selectedRange!.start);
    final end = _normalizeDate(_selectedRange!.end);
    return normalized.isAfter(start) && normalized.isBefore(end);
  }

  bool _isToday(DateTime date) {
    final today = _normalizeDate(DateTime.now());
    return _isSameDay(date, today);
  }

  bool _isDisabled(DateTime date) {
    if (widget.isDateDisabled != null && widget.isDateDisabled!(date)) {
      return true;
    }
    if (widget.disabledDates != null) {
      final normalized = _normalizeDate(date);
      if (widget.disabledDates!.any((d) => _isSameDay(normalized, _normalizeDate(d)))) {
        return true;
      }
    }
    if (widget.firstDate != null && date.isBefore(_normalizeDate(widget.firstDate!))) {
      return true;
    }
    if (widget.lastDate != null && date.isAfter(_normalizeDate(widget.lastDate!))) {
      return true;
    }
    return false;
  }

  bool _isOutsideMonth(DateTime date) {
    return date.month != _displayedMonth.month || date.year != _displayedMonth.year;
  }

  void _handleDateTap(DateTime date) {
    if (_isDisabled(date)) return;

    final normalized = _normalizeDate(date);

    switch (widget.mode) {
      case GrafitCalendarMode.single:
        setState(() {
          _selectedDate = normalized;
        });
        widget.onDateChanged?.call(normalized);
        break;

      case GrafitCalendarMode.multiple:
        setState(() {
          if (_selectedDates.any((d) => _isSameDay(d, normalized))) {
            _selectedDates.removeWhere((d) => _isSameDay(d, normalized));
          } else {
            _selectedDates.add(normalized);
          }
          _selectedDates.sort();
        });
        widget.onDatesChanged?.call(_selectedDates);
        break;

      case GrafitCalendarMode.range:
        setState(() {
          if (_selectedRange == null) {
            _selectedRange = DateTimeRange(start: normalized, end: normalized);
          } else {
            final start = _normalizeDate(_selectedRange!.start);
            if (normalized.isBefore(start)) {
              _selectedRange = DateTimeRange(start: normalized, end: start);
            } else if (normalized.isAfter(start)) {
              _selectedRange = DateTimeRange(start: start, end: normalized);
            } else {
              _selectedRange = null;
            }
          }
        });
        widget.onRangeChanged?.call(_selectedRange);
        break;
    }
  }

  void _previousMonth() {
    setState(() {
      if (_displayedMonth.month == 1) {
        _displayedMonth = DateTime(_displayedMonth.year - 1, 12, 1);
      } else {
        _displayedMonth = DateTime(_displayedMonth.year, _displayedMonth.month - 1, 1);
      }
    });
  }

  void _nextMonth() {
    setState(() {
      if (_displayedMonth.month == 12) {
        _displayedMonth = DateTime(_displayedMonth.year + 1, 1, 1);
      } else {
        _displayedMonth = DateTime(_displayedMonth.year, _displayedMonth.month + 1, 1);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<GrafitTheme>()!;
    final colors = theme.colors;

    return Container(
      padding: widget.padding ?? const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.background,
        borderRadius: BorderRadius.circular(colors.radius * 8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _CalendarHeader(
            displayedMonth: _displayedMonth,
            monthLabels: widget.monthLabels,
            captionLayout: widget.captionLayout,
            onPreviousMonth: _previousMonth,
            onNextMonth: _nextMonth,
            navButtonVariant: widget.navButtonVariant,
          ),
          const SizedBox(height: 8),
          _CalendarGrid(
            displayedMonth: _displayedMonth,
            firstDayOfWeek: widget.firstDayOfWeek,
            weekdayLabels: widget.weekdayLabels,
            showWeekNumbers: widget.showWeekNumbers,
            showOutsideDays: widget.showOutsideDays,
            isDateSelected: _isDateSelected,
            isRangeStart: _isRangeStart,
            isRangeEnd: _isRangeEnd,
            isRangeMiddle: _isRangeMiddle,
            isToday: _isToday,
            isDisabled: _isDisabled,
            isOutsideMonth: _isOutsideMonth,
            onDateTap: _handleDateTap,
            getDayStyle: widget.getDayStyle,
          ),
        ],
      ),
    );
  }
}

/// Calendar header with navigation
class _CalendarHeader extends StatelessWidget {
  final DateTime displayedMonth;
  final List<String>? monthLabels;
  final GrafitCalendarCaptionLayout captionLayout;
  final VoidCallback onPreviousMonth;
  final VoidCallback onNextMonth;
  final GrafitButtonVariant navButtonVariant;

  const _CalendarHeader({
    required this.displayedMonth,
    this.monthLabels,
    required this.captionLayout,
    required this.onPreviousMonth,
    required this.onNextMonth,
    required this.navButtonVariant,
  });

  String _getMonthLabel(int month) {
    if (monthLabels != null && month!.isNotEmpty && month > 0 && month <= monthLabels!.length) {
      return monthLabels![month - 1];
    }
    const defaultMonths = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return defaultMonths[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<GrafitTheme>()!;
    final colors = theme.colors;

    return SizedBox(
      height: 32,
      child: Row(
        children: [
          GrafitButton(
            variant: navButtonVariant,
            size: GrafitButtonSize.icon,
            icon: Icons.chevron_left,
            onPressed: onPreviousMonth,
          ),
          Expanded(
            child: Center(
              child: Text(
                '${_getMonthLabel(displayedMonth.month)} ${displayedMonth.year}',
                style: TextStyle(
                  color: colors.foreground,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          GrafitButton(
            variant: navButtonVariant,
            size: GrafitButtonSize.icon,
            icon: Icons.chevron_right,
            onPressed: onNextMonth,
          ),
        ],
      ),
    );
  }
}

/// Calendar grid with weekdays and days
class _CalendarGrid extends StatelessWidget {
  final DateTime displayedMonth;
  final int firstDayOfWeek;
  final List<String>? weekdayLabels;
  final bool showWeekNumbers;
  final bool showOutsideDays;
  final bool Function(DateTime) isDateSelected;
  final bool Function(DateTime) isRangeStart;
  final bool Function(DateTime) isRangeEnd;
  final bool Function(DateTime) isRangeMiddle;
  final bool Function(DateTime) isToday;
  final bool Function(DateTime) isDisabled;
  final bool Function(DateTime) isOutsideMonth;
  final ValueChanged<DateTime> onDateTap;
  final GrafitCalendarDayStyle? Function(DateTime)? getDayStyle;

  const _CalendarGrid({
    required this.displayedMonth,
    required this.firstDayOfWeek,
    this.weekdayLabels,
    required this.showWeekNumbers,
    required this.showOutsideDays,
    required this.isDateSelected,
    required this.isRangeStart,
    required this.isRangeEnd,
    required this.isRangeMiddle,
    required this.isToday,
    required this.isDisabled,
    required this.isOutsideMonth,
    required this.onDateTap,
    this.getDayStyle,
  });

  List<String> _getWeekdayLabels() {
    if (weekdayLabels != null && weekdayLabels!.length == 7) {
      return weekdayLabels!;
    }
    const defaultWeekdays = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];
    // Rotate based on firstDayOfWeek
    final result = List<String>.from(defaultWeekdays);
    for (int i = 0; i < firstDayOfWeek; i++) {
      result.add(result.removeAt(0));
    }
    return result;
  }

  List<List<DateTime?>> _getWeeksInMonth() {
    final firstDayOfMonth = DateTime(displayedMonth.year, displayedMonth.month, 1);
    final lastDayOfMonth = DateTime(displayedMonth.year, displayedMonth.month + 1, 0);

    final firstWeekday = firstDayOfMonth.weekday % 7; // 0 = Sunday
    final adjustedFirstWeekday = (firstWeekday - firstDayOfWeek + 7) % 7;

    final daysInMonth = lastDayOfMonth.day;
    final totalDays = adjustedFirstWeekday + daysInMonth;
    final weeks = ((totalDays + 6) ~/ 7);

    final result = <List<DateTime?>>[];
    int dayCounter = 1;

    for (int week = 0; week < weeks; week++) {
      final weekDays = <DateTime?>[];
      for (int day = 0; day < 7; day++) {
        final dayIndex = week * 7 + day;
        if (dayIndex < adjustedFirstWeekday) {
          // Days before the first day of the month
          if (showOutsideDays) {
            final prevMonthLastDay = DateTime(displayedMonth.year, displayedMonth.month, 0).day;
            final prevMonthDay = prevMonthLastDay - adjustedFirstWeekday + dayIndex + 1;
            weekDays.add(DateTime(displayedMonth.year, displayedMonth.month - 1, prevMonthDay));
          } else {
            weekDays.add(null);
          }
        } else if (dayCounter <= daysInMonth) {
          weekDays.add(DateTime(displayedMonth.year, displayedMonth.month, dayCounter));
          dayCounter++;
        } else {
          // Days after the last day of the month
          if (showOutsideDays) {
            final nextMonthDay = dayCounter - daysInMonth;
            weekDays.add(DateTime(displayedMonth.year, displayedMonth.month + 1, nextMonthDay));
            dayCounter++;
          } else {
            weekDays.add(null);
          }
        }
      }
      result.add(weekDays);
    }

    return result;
  }

  int? _getWeekNumber(List<DateTime?> week) {
    if (week.isEmpty) return null;
    final firstDay = week.firstWhere((d) => d != null);
    if (firstDay == null) return null;
    return _getWeekOfYear(firstDay);
  }

  int _getWeekOfYear(DateTime date) {
    final dayOfYear = int.parse(DateFormat('D').format(date));
    final weekNumber = ((dayOfYear - date.weekday + 10) / 7).floor();
    return weekNumber;
  }

  @override
  Widget build(BuildContext context) {
    final weeks = _getWeeksInMonth();
    final weekdayLabels = _getWeekdayLabels();

    return Column(
      children: [
        // Weekday headers
        if (showWeekNumbers)
          const SizedBox(height: 24)
        else
          const SizedBox.shrink(),
        Row(
          children: [
            if (showWeekNumbers)
              SizedBox(
                width: 32,
                height: 24,
                child: Center(
                  child: Text(
                    '#',
                    style: TextStyle(
                      fontSize: 11,
                      color: Theme.of(context).extension<GrafitTheme>()!.colors.mutedForeground,
                    ),
                  ),
                ),
              ),
            ...weekdayLabels.map((label) => Expanded(
              child: SizedBox(
                height: 24,
                child: Center(
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: 11,
                      color: Theme.of(context).extension<GrafitTheme>()!.colors.mutedForeground,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
              ),
            )),
          ],
        ),
        const SizedBox(height: 4),
        // Calendar days
        ...weeks.map((week) {
          final weekNumber = showWeekNumbers ? _getWeekNumber(week) : null;
          return Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Row(
              children: [
                if (showWeekNumbers)
                  SizedBox(
                    width: 32,
                    height: 32,
                    child: Center(
                      child: Text(
                        weekNumber?.toString() ?? '',
                        style: TextStyle(
                          fontSize: 11,
                          color: Theme.of(context).extension<GrafitTheme>()!.colors.mutedForeground,
                        ),
                      ),
                    ),
                  ),
                ...week.map((date) {
                  return Expanded(
                    child: _CalendarDay(
                      date: date,
                      isDateSelected: isDateSelected,
                      isRangeStart: isRangeStart,
                      isRangeEnd: isRangeEnd,
                      isRangeMiddle: isRangeMiddle,
                      isToday: isToday,
                      isDisabled: isDisabled,
                      isOutsideMonth: isOutsideMonth,
                      onDateTap: onDateTap,
                      getDayStyle: getDayStyle,
                    ),
                  );
                }),
              ],
            ),
          );
        }),
      ],
    );
  }
}

/// Single calendar day cell
class _CalendarDay extends StatefulWidget {
  final DateTime? date;
  final bool Function(DateTime) isDateSelected;
  final bool Function(DateTime) isRangeStart;
  final bool Function(DateTime) isRangeEnd;
  final bool Function(DateTime) isRangeMiddle;
  final bool Function(DateTime) isToday;
  final bool Function(DateTime) isDisabled;
  final bool Function(DateTime) isOutsideMonth;
  final ValueChanged<DateTime> onDateTap;
  final GrafitCalendarDayStyle? Function(DateTime)? getDayStyle;

  const _CalendarDay({
    required this.date,
    required this.isDateSelected,
    required this.isRangeStart,
    required this.isRangeEnd,
    required this.isRangeMiddle,
    required this.isToday,
    required this.isDisabled,
    required this.isOutsideMonth,
    required this.onDateTap,
    this.getDayStyle,
  });

  @override
  State<_CalendarDay> createState() => _CalendarDayState();
}

class _CalendarDayState extends State<_CalendarDay> {
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    if (widget.date == null) {
      return const SizedBox(height: 32);
    }

    final date = widget.date!;
    final theme = Theme.of(context).extension<GrafitTheme>()!;
    final colors = theme.colors;

    final isSelected = widget.isDateSelected(date);
    final isRangeStart = widget.isRangeStart(date);
    final isRangeEnd = widget.isRangeEnd(date);
    final isRangeMiddle = widget.isRangeMiddle(date);
    final isToday = widget.isToday(date);
    final isDisabled = widget.isDisabled(date);
    final isOutsideMonth = widget.isOutsideMonth(date);

    // Check for custom day style
    final customStyle = widget.getDayStyle?.call(date);

    Color? backgroundColor;
    Color? foregroundColor;
    BorderRadius? borderRadius;
    Border? border;
    List<BoxShadow>? boxShadow;

    if (customStyle != null) {
      backgroundColor = customStyle.backgroundColor;
      foregroundColor = customStyle.foregroundColor;
      borderRadius = customStyle.borderRadius;
      border = customStyle.border;
      boxShadow = customStyle.boxShadow;
    } else {
      // Default styling logic
      if (isSelected && !isRangeStart && !isRangeEnd && !isRangeMiddle) {
        // Single selected
        backgroundColor = colors.primary;
        foregroundColor = colors.primaryForeground;
      } else if (isRangeMiddle) {
        backgroundColor = colors.accent;
        foregroundColor = colors.accentForeground;
      } else if (isRangeStart || isRangeEnd) {
        backgroundColor = colors.primary;
        foregroundColor = colors.primaryForeground;
      } else if (isToday) {
        backgroundColor = colors.accent;
        foregroundColor = colors.accentForeground;
      }

      if (isOutsideMonth) {
        foregroundColor ??= colors.mutedForeground;
      }

      if (isDisabled) {
        foregroundColor ??= colors.mutedForeground.withOpacity(0.5);
      }

      if (_isFocused) {
        boxShadow = [
          BoxShadow(
            color: colors.ring.withOpacity(0.5),
            blurRadius: 4,
            spreadRadius: 1,
          ),
        ];
      }
    }

    final effectiveForeground = foregroundColor ?? colors.foreground;
    final effectiveBackground = backgroundColor ?? Colors.transparent;

    return GestureDetector(
      onTap: isDisabled ? null : () => widget.onDateTap(date),
      child: FocusableActionDetector(
        onShowFocusHighlight: (value) {
          setState(() {
            _isFocused = value;
          });
        },
        child: Container(
          height: 32,
          margin: const EdgeInsets.symmetric(horizontal: 1),
          decoration: BoxDecoration(
            color: effectiveBackground,
            borderRadius: borderRadius ?? BorderRadius.circular(colors.radius * 4),
            border: border,
            boxShadow: boxShadow,
          ),
          child: Center(
            child: Text(
              '${date.day}',
              style: TextStyle(
                color: effectiveForeground,
                fontSize: 13,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Custom day style for calendar
class GrafitCalendarDayStyle {
  final Color? backgroundColor;
  final Color? foregroundColor;
  final BorderRadius? borderRadius;
  final Border? border;
  final List<BoxShadow>? boxShadow;

  const GrafitCalendarDayStyle({
    this.backgroundColor,
    this.foregroundColor,
    this.borderRadius,
    this.border,
    this.boxShadow,
  });
}

/// Helper class for date formatting (to avoid intl package dependency)
class DateFormat {
  final String pattern;

  const DateFormat(this.pattern);

  String format(DateTime date) {
    if (pattern == 'D') {
      // Day of year
      final startOfYear = DateTime(date.year, 1, 1);
      final difference = date.difference(startOfYear);
      return (difference.inDays + 1).toString();
    }
    return date.toString();
  }
}

/// Calendar previous button
class GrafitCalendarPrevButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final GrafitButtonVariant variant;

  const GrafitCalendarPrevButton({
    super.key,
    this.onPressed,
    this.variant = GrafitButtonVariant.ghost,
  });

  @override
  Widget build(BuildContext context) {
    return GrafitButton(
      variant: variant,
      size: GrafitButtonSize.icon,
      icon: Icons.chevron_left,
      onPressed: onPressed,
    );
  }
}

/// Calendar next button
class GrafitCalendarNextButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final GrafitButtonVariant variant;

  const GrafitCalendarNextButton({
    super.key,
    this.onPressed,
    this.variant = GrafitButtonVariant.ghost,
  });

  @override
  Widget build(BuildContext context) {
    return GrafitButton(
      variant: variant,
      size: GrafitButtonSize.icon,
      icon: Icons.chevron_right,
      onPressed: onPressed,
    );
  }
}
