import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../theme/theme.dart';
import '../../theme/theme_data.dart';
import '../../primitives/focusable.dart';
import 'label.dart';

/// Native select size variant
enum GrafitNativeSelectSize {
  sm,
  md,
}

/// Native select option data
class GrafitNativeSelectOption<T> {
  final T value;
  final String label;
  final String? description;

  const GrafitNativeSelectOption({
    required this.value,
    required this.label,
    this.description,
  });
}

/// Native select option group
class GrafitNativeSelectOptionGroup<T> {
  final String label;
  final List<GrafitNativeSelectOption<T>> options;

  const GrafitNativeSelectOptionGroup({
    required this.label,
    required this.options,
  });
}

/// Native select component - uses platform-native dropdown
///
/// This component provides a native platform dropdown (Android Picker, iOS Picker)
/// with full Grafit theming support. Unlike GrafitSelect which uses a custom
/// dropdown UI, this uses the platform's native selection widget.
class GrafitNativeSelect<T> extends StatefulWidget {
  /// Currently selected value
  final T? value;

  /// Callback when selection changes
  final ValueChanged<T?>? onChanged;

  /// Placeholder text when no value is selected
  final String? placeholder;

  /// Whether the select is enabled
  final bool enabled;

  /// Size variant
  final GrafitNativeSelectSize size;

  /// Optional label for the select
  final String? label;

  /// Optional error text
  final String? errorText;

  /// Optional helper text
  final String? helperText;

  /// Focus node for programmatic focus control
  final FocusNode? focusNode;

  /// Whether to auto-focus on mount
  final bool autofocus;

  /// Options to display in the dropdown
  final List<GrafitNativeSelectOption<T>> options;

  /// Optional grouped options
  final List<GrafitNativeSelectOptionGroup<T>>? optionGroups;

  const GrafitNativeSelect({
    super.key,
    required this.options,
    this.value,
    this.onChanged,
    this.placeholder,
    this.enabled = true,
    this.size = GrafitNativeSelectSize.md,
    this.label,
    this.errorText,
    this.helperText,
    this.focusNode,
    this.autofocus = false,
  }) : assert(
          options.isEmpty || optionGroups == null,
          'Cannot specify both options and optionGroups',
        );

  /// Constructor for grouped options
  const GrafitNativeSelect.grouped({
    super.key,
    required this.optionGroups,
    this.value,
    this.onChanged,
    this.placeholder,
    this.enabled = true,
    this.size = GrafitNativeSelectSize.md,
    this.label,
    this.errorText,
    this.helperText,
    this.focusNode,
    this.autofocus = false,
  })  : options = const [],
        assert(optionGroups != null, 'Option groups must be provided');

  @override
  State<GrafitNativeSelect<T>> createState() => _GrafitNativeSelectState<T>();
}

class _GrafitNativeSelectState<T> extends State<GrafitNativeSelect<T>> {
  late FocusNode _focusNode;
  bool _isFocused = false;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_handleFocusChange);
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _focusNode.removeListener(_handleFocusChange);
      _focusNode.dispose();
    }
    super.dispose();
  }

  void _handleFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
  }

  List<GrafitNativeSelectOption<T>> get _allOptions {
    if (widget.optionGroups != null) {
      final all = <GrafitNativeSelectOption<T>>[];
      for (final group in widget.optionGroups!) {
        all.addAll(group.options);
      }
      return all;
    }
    return widget.options;
  }

  String _getSelectedLabel() {
    if (widget.value == null) return '';
    for (final option in _allOptions) {
      if (option.value == widget.value) {
        return option.label;
      }
    }
    return '';
  }

  void _handleTap() {
    if (!widget.enabled) return;

    final allOptions = _allOptions;
    if (allOptions.isEmpty) return;

    // Show platform-native dropdown
    _showNativeDropdown(allOptions);
  }

  void _showNativeDropdown(List<GrafitNativeSelectOption<T>> options) {
    showModalBottomSheet<T>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _NativeSelectBottomSheet<T>(
        options: options,
        optionGroups: widget.optionGroups,
        value: widget.value,
        onChanged: widget.onChanged,
        placeholder: widget.placeholder,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<GrafitTheme>()!;
    final colors = theme.colors;
    final effectiveEnabled = widget.enabled && widget.onChanged != null;
    final hasError = widget.errorText != null;

    Widget content = MouseRegion(
      cursor: effectiveEnabled ? SystemMouseCursors.click : MouseCursor.defer,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GrafitFocusable(
        focusNode: _focusNode,
        autofocus: widget.autofocus,
        child: GestureDetector(
          onTap: effectiveEnabled ? _handleTap : null,
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 150),
            opacity: effectiveEnabled ? 1.0 : 0.5,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              decoration: _buildDecoration(colors, hasError),
              child: Container(
                constraints: BoxConstraints(
                  minWidth: size == GrafitNativeSelectSize.sm ? 120 : 160,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: _getPadding(),
                        child: Text(
                          _getSelectedLabel().isNotEmpty
                              ? _getSelectedLabel()
                              : (widget.placeholder ?? 'Select...'),
                          style: TextStyle(
                            color: _getSelectedLabel().isNotEmpty
                                ? (effectiveEnabled
                                    ? colors.foreground
                                    : colors.mutedForeground)
                                : colors.mutedForeground,
                            fontSize: _getFontSize(),
                            overflow: TextOverflow.ellipsis,
                          ),
                          maxLines: 1,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Icon(
                        Icons.expand_more,
                        size: 16,
                        color: colors.mutedForeground.withOpacity(0.5),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );

    // Wrap with label if provided
    if (widget.label != null) {
      content = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          GrafitLabel(
            text: widget.label!,
            disabled: !effectiveEnabled,
          ),
          const SizedBox(height: 6),
          content,
        ],
      );
    }

    // Wrap with error/helper text if provided
    if (widget.errorText != null || widget.helperText != null) {
      content = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          content,
          const SizedBox(height: 4),
          if (widget.errorText != null)
            Text(
              widget.errorText!,
              style: theme.text.labelSmall?.copyWith(
                color: colors.destructive,
              ),
            )
          else if (widget.helperText != null)
            Text(
              widget.helperText!,
              style: theme.text.labelSmall?.copyWith(
                color: colors.mutedForeground,
              ),
            ),
        ],
      );
    }

    return content;
  }

  BoxDecoration _buildDecoration(GrafitColorScheme colors, bool hasError) {
    final borderColor = hasError
        ? colors.destructive
        : _isFocused
            ? colors.ring
            : _isHovered && widget.enabled
                ? colors.input
                : colors.border;

    return BoxDecoration(
      color: widget.enabled ? colors.background : colors.muted,
      border: Border.all(
        color: borderColor,
        width: _isFocused ? 2.0 : 1.0,
      ),
      borderRadius: BorderRadius.circular(colors.radius * 8),
      boxShadow: _isFocused && widget.enabled
          ? [
              BoxShadow(
                color: colors.ring.withOpacity(0.2),
                blurRadius: 4,
                spreadRadius: 0,
              ),
            ]
          : null,
    );
  }

  EdgeInsets _getPadding() {
    return switch (widget.size) {
      GrafitNativeSelectSize.sm => const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 6,
        ),
      GrafitNativeSelectSize.md => const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 8,
        ),
    };
  }

  double _getFontSize() {
    return switch (widget.size) {
      GrafitNativeSelectSize.sm => 13.0,
      GrafitNativeSelectSize.md => 14.0,
    };
  }
}

/// Native select bottom sheet for mobile platforms
class _NativeSelectBottomSheet<T> extends StatelessWidget {
  final List<GrafitNativeSelectOption<T>> options;
  final List<GrafitNativeSelectOptionGroup<T>>? optionGroups;
  final T? value;
  final ValueChanged<T?>? onChanged;
  final String? placeholder;

  const _NativeSelectBottomSheet({
    required this.options,
    this.optionGroups,
    this.value,
    this.onChanged,
    this.placeholder,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<GrafitTheme>()!;
    final colors = theme.colors;

    return Container(
      decoration: BoxDecoration(
        color: colors.popover,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
        boxShadow: [
          BoxShadow(
            color: colors.shadow.withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 32,
              height: 4,
              decoration: BoxDecoration(
                color: colors.mutedForeground.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            // Title/placeholder
            if (placeholder != null)
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  placeholder!,
                  style: TextStyle(
                    color: colors.foreground,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            const Divider(height: 1),
            // Options list
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 300),
              child: optionGroups != null
                  ? _buildGroupedOptions(context, colors)
                  : _buildOptions(context, colors, options),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptions(
    BuildContext context,
    GrafitColorScheme colors,
    List<GrafitNativeSelectOption<T>> options,
  ) {
    return ListView.separated(
      shrinkWrap: true,
      itemCount: options.length,
      separatorBuilder: (context, index) => Divider(
        height: 1,
        color: colors.border,
      ),
      itemBuilder: (context, index) {
        final option = options[index];
        final isSelected = option.value == value;

        return InkWell(
          onTap: () {
            onChanged?.call(option.value);
            Navigator.of(context).pop(option.value);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: isSelected ? colors.accent.withOpacity(0.2) : null,
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        option.label,
                        style: TextStyle(
                          color: isSelected
                              ? colors.primary
                              : colors.foreground,
                          fontSize: 16,
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.normal,
                        ),
                      ),
                      if (option.description != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          option.description!,
                          style: TextStyle(
                            color: colors.mutedForeground,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                if (isSelected)
                  Icon(
                    Icons.check,
                    size: 20,
                    color: colors.primary,
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildGroupedOptions(BuildContext context, GrafitColorScheme colors) {
    if (optionGroups == null) return const SizedBox.shrink();

    return ListView.separated(
      shrinkWrap: true,
      itemCount: optionGroups!.length,
      separatorBuilder: (context, index) => Divider(
        height: 1,
        color: colors.border,
        thickness: 8,
      ),
      itemBuilder: (context, groupIndex) {
        final group = optionGroups![groupIndex];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Group header
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Text(
                group.label,
                style: TextStyle(
                  color: colors.mutedForeground,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
            ),
            // Group options
            ...group.options.map((option) {
              final isSelected = option.value == value;
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  InkWell(
                    onTap: () {
                      onChanged?.call(option.value);
                      Navigator.of(context).pop(option.value);
                    },
                    child: Container(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      color: isSelected ? colors.accent.withOpacity(0.2) : null,
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  option.label,
                                  style: TextStyle(
                                    color: isSelected
                                        ? colors.primary
                                        : colors.foreground,
                                    fontSize: 16,
                                    fontWeight: isSelected
                                        ? FontWeight.w600
                                        : FontWeight.normal,
                                  ),
                                ),
                                if (option.description != null) ...[
                                  const SizedBox(height: 2),
                                  Text(
                                    option.description!,
                                    style: TextStyle(
                                      color: colors.mutedForeground,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                          if (isSelected)
                            Icon(
                              Icons.check,
                              size: 20,
                              color: colors.primary,
                            ),
                        ],
                      ),
                    ),
                  ),
                  if (option != group.options.last)
                    Divider(
                      height: 1,
                      color: colors.border,
                      indent: 16,
                    ),
                ],
              );
            }),
          ],
        );
      },
    );
  }
}

/// Native select optgroup for grouped options
///
/// This is a convenience class for creating option groups.
/// Use with GrafitNativeSelect.grouped() constructor.
class GrafitNativeSelectOptGroup<T> extends GrafitNativeSelectOptionGroup<T> {
  const GrafitNativeSelectOptGroup({
    required super.label,
    required super.options,
  });

  /// Convert from regular option group
  factory GrafitNativeSelectOptGroup.fromGroup(
    GrafitNativeSelectOptionGroup<T> group,
  ) {
    return GrafitNativeSelectOptGroup(
      label: group.label,
      options: group.options,
    );
  }
}

/// Native select option
///
/// This is a convenience class for creating options.
class GrafitNativeSelectOptionItem<T> extends GrafitNativeSelectOption<T> {
  const GrafitNativeSelectOptionItem({
    required super.value,
    required super.label,
    super.description,
  });

  /// Convert from regular option
  factory GrafitNativeSelectOptionItem.fromOption(
    GrafitNativeSelectOption<T> option,
  ) {
    return GrafitNativeSelectOptionItem(
      value: option.value,
      label: option.label,
      description: option.description,
    );
  }
}
