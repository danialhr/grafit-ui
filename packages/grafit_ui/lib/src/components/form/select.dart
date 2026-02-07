import 'package:flutter/material.dart';
import '../../theme/theme.dart';
import '../../primitives/clickable.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

/// Select component size variant
enum GrafitSelectSize {
  sm,
  md,
}

/// Select component - dropdown selection from a list of options
class GrafitSelect<T> extends StatefulWidget {
  /// Currently selected value
  final T? value;

  /// Callback when selection changes
  final ValueChanged<T>? onChanged;

  /// Options to display in the dropdown
  final List<GrafitSelectItemData<T>> items;

  /// Optional grouped items
  final List<GrafitSelectGroupData<T>>? groups;

  /// Placeholder text when no value is selected
  final String? placeholder;

  /// Whether the select is enabled
  final bool enabled;

  /// Size variant for the select trigger
  final GrafitSelectSize size;

  /// Optional label for the select
  final String? label;

  /// Optional error text
  final String? errorText;

  /// Whether to show search/filter functionality
  final bool searchable;

  /// Search placeholder text
  final String? searchPlaceholder;

  /// Width of the dropdown menu
  final double? menuWidth;

  /// Max height of the dropdown menu
  final double? menuMaxHeight;

  /// Alignment of the dropdown menu
  final AlignmentDirectional? menuAlignment;

  const GrafitSelect({
    super.key,
    required this.items,
    this.value,
    this.onChanged,
    this.placeholder,
    this.enabled = true,
    this.size = GrafitSelectSize.md,
    this.label,
    this.errorText,
    this.searchable = false,
    this.searchPlaceholder,
    this.menuWidth,
    this.menuMaxHeight,
    this.menuAlignment,
  }) : assert(
          items.isEmpty || groups == null,
          'Cannot specify both items and groups',
        );

  /// Constructor for grouped options
  const GrafitSelect.grouped({
    super.key,
    required this.groups,
    this.value,
    this.onChanged,
    this.placeholder,
    this.enabled = true,
    this.size = GrafitSelectSize.md,
    this.label,
    this.errorText,
    this.searchable = false,
    this.searchPlaceholder,
    this.menuWidth,
    this.menuMaxHeight,
    this.menuAlignment,
  })  : items = const [],
        assert(groups != null, 'Groups must be provided');

  @override
  State<GrafitSelect<T>> createState() => _GrafitSelectState<T>();
}

class _GrafitSelectState<T> extends State<GrafitSelect<T>> {
  final LayerLink _layerLink = LayerLink();
  final GlobalKey _triggerKey = GlobalKey();
  OverlayEntry? _overlayEntry;
  bool _isOpen = false;
  String _searchQuery = '';

  @override
  void dispose() {
    _overlayEntry?.remove();
    super.dispose();
  }

  void _toggle() {
    setState(() {
      _isOpen = !_isOpen;
      if (_isOpen) {
        _showDropdown();
      } else {
        _hideDropdown();
      }
    });
  }

  void _showDropdown() {
    setState(() {
      _overlayEntry = OverlayEntry(
        builder: (context) => _GrafitSelectDropdown<T>(
          layerLink: _layerLink,
          triggerKey: _triggerKey,
          items: widget.groups != null
              ? _buildFlattenedItems()
              : widget.items,
          value: widget.value,
          onChanged: (value) {
            widget.onChanged?.call(value);
            _hideDropdown();
          },
          enabled: widget.enabled,
          searchable: widget.searchable,
          searchPlaceholder: widget.searchPlaceholder,
          menuWidth: widget.menuWidth,
          menuMaxHeight: widget.menuMaxHeight,
          menuAlignment: widget.menuAlignment,
          onDismiss: _toggle,
          searchQuery: _searchQuery,
          onSearchChanged: (query) {
            setState(() {
              _searchQuery = query;
            });
          },
          groups: widget.groups,
        ),
      );
      Overlay.of(context).insert(_overlayEntry!);
    });
  }

  void _hideDropdown() {
    _overlayEntry?.remove();
    setState(() {
      _overlayEntry = null;
      _isOpen = false;
      _searchQuery = '';
    });
  }

  List<GrafitSelectItemData<T>> _buildFlattenedItems() {
    if (widget.groups == null) return [];

    final flattened = <GrafitSelectItemData<T>>[];
    for (final group in widget.groups!) {
      for (final item in group.items) {
        flattened.add(item);
      }
    }
    return flattened;
  }

  String _getSelectedLabel() {
    if (widget.value == null) return '';

    final allItems = widget.groups != null
        ? _buildFlattenedItems()
        : widget.items;

    for (final item in allItems) {
      if (item.value == widget.value) {
        return item.label;
      }
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<GrafitTheme>()!;
    final colors = theme.colors;
    final effectiveEnabled = widget.enabled && widget.onChanged != null;

    Widget content = GrafitSelectTrigger<T>(
      key: _triggerKey,
      layerLink: _layerLink,
      placeholder: widget.placeholder,
      selectedLabel: _getSelectedLabel(),
      size: widget.size,
      enabled: effectiveEnabled,
      isOpen: _isOpen,
      hasError: widget.errorText != null,
      onTap: effectiveEnabled ? _toggle : null,
    );

    if (widget.label != null) {
      content = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          GrafitSelectLabel(
            label: widget.label!,
            enabled: effectiveEnabled,
          ),
          const SizedBox(height: 6),
          content,
        ],
      );
    }

    if (widget.errorText != null) {
      content = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          content,
          const SizedBox(height: 4),
          GrafitSelectErrorText(
            errorText: widget.errorText!,
          ),
        ],
      );
    }

    return content;
  }
}

/// Select trigger button widget
class GrafitSelectTrigger<T> extends StatelessWidget {
  final LayerLink layerLink;
  final String? placeholder;
  final String selectedLabel;
  final GrafitSelectSize size;
  final bool enabled;
  final bool isOpen;
  final bool hasError;
  final VoidCallback? onTap;

  const GrafitSelectTrigger({
    super.key,
    required this.layerLink,
    this.placeholder,
    required this.selectedLabel,
    this.size = GrafitSelectSize.md,
    this.enabled = true,
    this.isOpen = false,
    this.hasError = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<GrafitTheme>()!;
    final colors = theme.colors;

    return CompositedTransformTarget(
      link: layerLink,
      child: GrafitClickable(
        enabled: enabled,
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          decoration: _buildDecoration(colors, context),
          child: Container(
            constraints: BoxConstraints(
              minWidth: size == GrafitSelectSize.sm ? 120 : 160,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: Padding(
                    padding: _getPadding(),
                    child: Text(
                      selectedLabel.isNotEmpty ? selectedLabel : (placeholder ?? 'Select...'),
                      style: TextStyle(
                        color: selectedLabel.isNotEmpty
                            ? (enabled ? colors.foreground : colors.mutedForeground)
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
                  child: AnimatedRotation(
                    duration: const Duration(milliseconds: 150),
                    turns: isOpen ? 0.5 : 0,
                    child: Icon(
                      Icons.expand_more,
                      size: 16,
                      color: colors.mutedForeground,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  BoxDecoration _buildDecoration(GrafitColorScheme colors, BuildContext context) {
    final borderColor = hasError
        ? colors.destructive
        : context.isClickableFocused
            ? colors.ring
            : context.isClickableHovered && enabled
                ? colors.input
                : colors.border;

    return BoxDecoration(
      color: enabled ? colors.background : colors.muted,
      border: Border.all(
        color: borderColor,
        width: context.isClickableFocused ? 2.0 : 1.0,
      ),
      borderRadius: BorderRadius.circular(colors.radius * 6),
      boxShadow: context.isClickableFocused && enabled
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
    return switch (size) {
      GrafitSelectSize.sm => const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 6,
        ),
      GrafitSelectSize.md => const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 8,
        ),
    };
  }

  double _getFontSize() {
    return switch (size) {
      GrafitSelectSize.sm => 13.0,
      GrafitSelectSize.md => 14.0,
    };
  }
}

/// Select dropdown content widget
class _GrafitSelectDropdown<T> extends StatefulWidget {
  final LayerLink layerLink;
  final GlobalKey triggerKey;
  final List<GrafitSelectItemData<T>> items;
  final T? value;
  final ValueChanged<T>? onChanged;
  final bool enabled;
  final bool searchable;
  final String? searchPlaceholder;
  final double? menuWidth;
  final double? menuMaxHeight;
  final AlignmentDirectional? menuAlignment;
  final VoidCallback onDismiss;
  final String searchQuery;
  final ValueChanged<String> onSearchChanged;
  final List<GrafitSelectGroupData<T>>? groups;

  const _GrafitSelectDropdown({
    required this.layerLink,
    required this.triggerKey,
    required this.items,
    required this.value,
    required this.onChanged,
    required this.enabled,
    required this.searchable,
    required this.onDismiss,
    required this.searchQuery,
    required this.onSearchChanged,
    this.searchPlaceholder,
    this.menuWidth,
    this.menuMaxHeight,
    this.menuAlignment,
    this.groups,
  });

  @override
  State<_GrafitSelectDropdown<T>> createState() => _GrafitSelectDropdownState<T>();
}

class _GrafitSelectDropdownState<T> extends State<_GrafitSelectDropdown<T>>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  final ScrollController _scrollController = ScrollController();
  final FocusNode _searchFocusNode = FocusNode();

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

    if (widget.searchable) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _searchFocusNode.requestFocus();
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  List<GrafitSelectItemData<T>> _getFilteredItems() {
    if (widget.searchQuery.isEmpty) return widget.items;

    return widget.items
        .where((item) =>
            item.label.toLowerCase().contains(widget.searchQuery.toLowerCase()) ||
            (item.description?.toLowerCase().contains(widget.searchQuery.toLowerCase()) ?? false))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<GrafitTheme>()!;
    final colors = theme.colors;

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
          delegate: _GrafitSelectDelegate(
            layerLink: widget.layerLink,
            targetSize: size,
            targetPosition: position,
            menuWidth: widget.menuWidth ?? size.width,
            menuMaxHeight: widget.menuMaxHeight ?? 300,
            alignment: widget.menuAlignment,
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
            child: GrafitSelectContent<T>(
              items: widget.groups != null ? null : _getFilteredItems(),
              groups: widget.groups,
              value: widget.value,
              onChanged: widget.onChanged,
              enabled: widget.enabled,
              searchable: widget.searchable,
              searchPlaceholder: widget.searchPlaceholder,
              searchQuery: widget.searchQuery,
              onSearchChanged: widget.onSearchChanged,
              scrollController: _scrollController,
              searchFocusNode: _searchFocusNode,
            ),
          ),
        ),
      ),
    );
  }
}

/// Select content container
class GrafitSelectContent<T> extends StatelessWidget {
  final List<GrafitSelectItemData<T>>? items;
  final List<GrafitSelectGroupData<T>>? groups;
  final T? value;
  final ValueChanged<T>? onChanged;
  final bool enabled;
  final bool searchable;
  final String? searchPlaceholder;
  final String searchQuery;
  final ValueChanged<String> onSearchChanged;
  final ScrollController? scrollController;
  final FocusNode? searchFocusNode;

  const GrafitSelectContent({
    super.key,
    this.items,
    this.groups,
    this.value,
    this.onChanged,
    required this.enabled,
    required this.searchable,
    this.searchPlaceholder,
    required this.searchQuery,
    required this.onSearchChanged,
    this.scrollController,
    this.searchFocusNode,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<GrafitTheme>()!;
    final colors = theme.colors;

    final effectiveItems = groups != null ? null : items;

    return Container(
      decoration: BoxDecoration(
        color: colors.popover,
        borderRadius: BorderRadius.circular(colors.radius * 6),
        border: Border.all(color: colors.border),
        boxShadow: [
          BoxShadow(
            color: colors.shadow.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (searchable)
            GrafitSelectSearchInput(
              placeholder: searchPlaceholder,
              query: searchQuery,
              onChanged: onSearchChanged,
              focusNode: searchFocusNode,
            ),
          Flexible(
            child: SingleChildScrollView(
              controller: scrollController,
              child: groups != null
                  ? _buildGroups(context, colors)
                  : _buildItems(context, colors, effectiveItems ?? []),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGroups(BuildContext context, GrafitColorScheme colors) {
    if (groups == null) return const SizedBox.shrink();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (int i = 0; i < groups!.length; i++) ...[
          if (i > 0) GrafitSelectSeparator(),
          GrafitSelectGroup(
            label: groups![i].label,
            items: groups![i].items,
            value: value,
            onChanged: onChanged,
            enabled: enabled,
            searchQuery: searchQuery,
          ),
        ],
      ],
    );
  }

  Widget _buildItems(BuildContext context, GrafitColorScheme colors, List<GrafitSelectItemData<T>> items) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final item in items)
          GrafitSelectItem<T>(
            label: item.label,
            description: item.description,
            value: item.value,
            groupValue: value,
            onChanged: onChanged,
            enabled: enabled && (item.enabled ?? true),
          ),
      ],
    );
  }
}

/// Select group widget
class GrafitSelectGroup<T> extends StatelessWidget {
  final String label;
  final List<GrafitSelectItemData<T>> items;
  final T? value;
  final ValueChanged<T>? onChanged;
  final bool enabled;
  final String searchQuery;

  const GrafitSelectGroup({
    super.key,
    required this.label,
    required this.items,
    this.value,
    this.onChanged,
    this.enabled = true,
    this.searchQuery = '',
  });

  List<GrafitSelectItemData<T>> get _filteredItems {
    if (searchQuery.isEmpty) return items;

    return items
        .where((item) =>
            item.label.toLowerCase().contains(searchQuery.toLowerCase()) ||
            (item.description?.toLowerCase().contains(searchQuery.toLowerCase()) ?? false))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    if (_filteredItems.isEmpty) return const SizedBox.shrink();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GrafitSelectLabel(label: label),
        for (final item in _filteredItems)
          GrafitSelectItem<T>(
            label: item.label,
            description: item.description,
            value: item.value,
            groupValue: value,
            onChanged: onChanged,
            enabled: enabled && (item.enabled ?? true),
          ),
      ],
    );
  }
}

/// Select item widget
class GrafitSelectItem<T> extends StatelessWidget {
  final String label;
  final String? description;
  final T value;
  final T? groupValue;
  final ValueChanged<T>? onChanged;
  final bool enabled;

  const GrafitSelectItem({
    super.key,
    required this.label,
    this.description,
    required this.value,
    this.groupValue,
    this.onChanged,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<GrafitTheme>()!;
    final colors = theme.colors;
    final isSelected = groupValue != null && groupValue == value;

    return GrafitClickable(
      enabled: enabled,
      onTap: () => onChanged?.call(value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? colors.accent.withOpacity(0.5)
              : (context.isClickableHovered && enabled
                  ? colors.muted
                  : null),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      color: enabled
                          ? colors.foreground
                          : colors.mutedForeground,
                      fontSize: 14,
                    ),
                  ),
                  if (description != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      description!,
                      style: TextStyle(
                        color: colors.mutedForeground,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check,
                size: 16,
                color: colors.primary,
              ),
          ],
        ),
      ),
    );
  }
}

/// Select label widget for groups
class GrafitSelectLabel extends StatelessWidget {
  final String label;

  const GrafitSelectLabel({
    super.key,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<GrafitTheme>()!;
    final colors = theme.colors;

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
      child: Text(
        label,
        style: TextStyle(
          color: colors.mutedForeground,
          fontSize: 11,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

/// Select label widget for form field
class GrafitSelectLabelField extends StatelessWidget {
  final String label;
  final bool enabled;

  const GrafitSelectLabelField({
    super.key,
    required this.label,
    this.enabled = true,
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

/// Select separator widget
class GrafitSelectSeparator extends StatelessWidget {
  const GrafitSelectSeparator({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<GrafitTheme>()!;
    final colors = theme.colors;

    return Container(
      height: 1,
      color: colors.border,
      margin: const EdgeInsets.symmetric(vertical: 4),
    );
  }
}

/// Select search input widget
class GrafitSelectSearchInput extends StatefulWidget {
  final String? placeholder;
  final String query;
  final ValueChanged<String> onChanged;
  final FocusNode? focusNode;

  const GrafitSelectSearchInput({
    super.key,
    this.placeholder,
    required this.query,
    required this.onChanged,
    this.focusNode,
  });

  @override
  State<GrafitSelectSearchInput> createState() => _GrafitSelectSearchInputState();
}

class _GrafitSelectSearchInputState extends State<GrafitSelectSearchInput> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.query);
  }

  @override
  void didUpdateWidget(GrafitSelectSearchInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.query != _controller.text) {
      _controller.text = widget.query;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<GrafitTheme>()!;
    final colors = theme.colors;

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: colors.border),
        ),
      ),
      child: TextField(
        controller: _controller,
        focusNode: widget.focusNode,
        decoration: InputDecoration(
          hintText: widget.placeholder ?? 'Search...',
          hintStyle: TextStyle(
            color: colors.mutedForeground,
            fontSize: 14,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 8,
          ),
          isDense: true,
        ),
        style: TextStyle(
          color: colors.foreground,
          fontSize: 14,
        ),
        onChanged: widget.onChanged,
      ),
    );
  }
}

/// Select value display widget
class GrafitSelectValue<T> extends StatelessWidget {
  final T? value;
  final String placeholder;
  final Widget Function(BuildContext, T) displayBuilder;

  const GrafitSelectValue({
    super.key,
    required this.value,
    this.placeholder = 'Select...',
    required this.displayBuilder,
  });

  @override
  Widget build(BuildContext context) {
    if (value == null) {
      return Text(
        placeholder,
        style: TextStyle(
          color: Theme.of(context)
              .extension<GrafitTheme>()!
              .colors
              .mutedForeground,
        ),
      );
    }

    return displayBuilder(context, value as T);
  }
}

/// Select error text widget
class GrafitSelectErrorText extends StatelessWidget {
  final String errorText;

  const GrafitSelectErrorText({
    super.key,
    required this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<GrafitTheme>()!;
    final colors = theme.colors;

    return Text(
      errorText,
      style: TextStyle(
        color: colors.destructive,
        fontSize: 12,
      ),
    );
  }
}

/// Data class for select item
class GrafitSelectItemData<T> {
  /// Value for this item
  final T value;

  /// Label text
  final String label;

  /// Optional description text
  final String? description;

  /// Whether this specific item is enabled
  final bool? enabled;

  const GrafitSelectItemData({
    required this.value,
    required this.label,
    this.description,
    this.enabled,
  });
}

/// Data class for select group
class GrafitSelectGroupData<T> {
  /// Group label
  final String label;

  /// Items in this group
  final List<GrafitSelectItemData<T>> items;

  const GrafitSelectGroupData({
    required this.label,
    required this.items,
  });
}

/// Custom layout delegate for positioning select dropdown
class _GrafitSelectDelegate extends SingleChildLayoutDelegate {
  final LayerLink layerLink;
  final Size targetSize;
  final Offset targetPosition;
  final double menuWidth;
  final double menuMaxHeight;
  final AlignmentDirectional? alignment;

  _GrafitSelectDelegate({
    required this.layerLink,
    required this.targetSize,
    required this.targetPosition,
    required this.menuWidth,
    required this.menuMaxHeight,
    this.alignment,
  });

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    return BoxConstraints(
      minWidth: menuWidth,
      maxWidth: menuWidth,
      maxHeight: menuMaxHeight,
    );
  }

  @override
  Offset getPositionForChild(Size size) {
    final link = layerLink.leaderOf(context);
    if (link == null) {
      return Offset.zero;
    }

    final targetBox = link.bounds;
    if (targetBox == null) {
      return Offset.zero;
    }

    double x = targetBox.left;
    double y = targetBox.top + targetSize.height + 4;

    // Ensure dropdown doesn't go off screen
    if (x + menuWidth > size.width) {
      x = size.width - menuWidth - 8;
    }
    if (y + menuMaxHeight > size.height) {
      y = targetBox.top - menuMaxHeight - 4;
      if (y < 0) {
        y = 8;
      }
    }

    return Offset(x, y);
  }

  @override
  bool shouldRelayout(_GrafitSelectDelegate oldDelegate) {
    return true;
  }
}

// Widgetbook use cases
@widgetbook.UseCase(
  name: 'Default',
  type: GrafitSelect,
  path: 'Form/Select',
)
Widget selectDefault(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.all(16.0),
    child: GrafitSelect<String>(
      placeholder: 'Select an option',
      items: [
        GrafitSelectItemData(value: 'apple', label: 'Apple'),
        GrafitSelectItemData(value: 'banana', label: 'Banana'),
        GrafitSelectItemData(value: 'orange', label: 'Orange'),
        GrafitSelectItemData(value: 'grape', label: 'Grape'),
      ],
    ),
  );
}

@widgetbook.UseCase(
  name: 'With Label',
  type: GrafitSelect,
  path: 'Form/Select',
)
Widget selectWithLabel(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.all(16.0),
    child: GrafitSelect<String>(
      label: 'Favorite Fruit',
      placeholder: 'Select an option',
      items: [
        GrafitSelectItemData(value: 'apple', label: 'Apple'),
        GrafitSelectItemData(value: 'banana', label: 'Banana'),
        GrafitSelectItemData(value: 'orange', label: 'Orange'),
      ],
    ),
  );
}

@widgetbook.UseCase(
  name: 'With Search',
  type: GrafitSelect,
  path: 'Form/Select',
)
Widget selectWithSearch(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.all(16.0),
    child: GrafitSelect<String>(
      label: 'Select Country',
      placeholder: 'Search countries...',
      searchable: true,
      searchPlaceholder: 'Type to search...',
      items: [
        GrafitSelectItemData(value: 'us', label: 'United States'),
        GrafitSelectItemData(value: 'uk', label: 'United Kingdom'),
        GrafitSelectItemData(value: 'ca', label: 'Canada'),
        GrafitSelectItemData(value: 'au', label: 'Australia'),
        GrafitSelectItemData(value: 'de', label: 'Germany'),
        GrafitSelectItemData(value: 'fr', label: 'France'),
        GrafitSelectItemData(value: 'jp', label: 'Japan'),
        GrafitSelectItemData(value: 'cn', label: 'China'),
      ],
    ),
  );
}

@widgetbook.UseCase(
  name: 'With Groups',
  type: GrafitSelect,
  path: 'Form/Select',
)
Widget selectWithGroups(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.all(16.0),
    child: GrafitSelect<String>.grouped(
      label: 'Select Food',
      placeholder: 'Choose a food item',
      groups: [
        GrafitSelectGroupData(
          label: 'Fruits',
          items: [
            GrafitSelectItemData(value: 'apple', label: 'Apple'),
            GrafitSelectItemData(value: 'banana', label: 'Banana'),
            GrafitSelectItemData(value: 'orange', label: 'Orange'),
          ],
        ),
        GrafitSelectGroupData(
          label: 'Vegetables',
          items: [
            GrafitSelectItemData(value: 'carrot', label: 'Carrot'),
            GrafitSelectItemData(value: 'broccoli', label: 'Broccoli'),
            GrafitSelectItemData(value: 'spinach', label: 'Spinach'),
          ],
        ),
      ],
    ),
  );
}

@widgetbook.UseCase(
  name: 'Small Size',
  type: GrafitSelect,
  path: 'Form/Select',
)
Widget selectSmall(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.all(16.0),
    child: GrafitSelect<String>(
      placeholder: 'Select...',
      size: GrafitSelectSize.sm,
      items: [
        GrafitSelectItemData(value: 'opt1', label: 'Option 1'),
        GrafitSelectItemData(value: 'opt2', label: 'Option 2'),
      ],
    ),
  );
}

@widgetbook.UseCase(
  name: 'Disabled',
  type: GrafitSelect,
  path: 'Form/Select',
)
Widget selectDisabled(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.all(16.0),
    child: GrafitSelect<String>(
      label: 'Disabled Select',
      placeholder: 'Cannot select',
      enabled: false,
      items: [
        GrafitSelectItemData(value: 'opt1', label: 'Option 1'),
        GrafitSelectItemData(value: 'opt2', label: 'Option 2'),
      ],
    ),
  );
}

@widgetbook.UseCase(
  name: 'Error State',
  type: GrafitSelect,
  path: 'Form/Select',
)
Widget selectError(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.all(16.0),
    child: GrafitSelect<String>(
      label: 'Select Option',
      placeholder: 'Choose an option',
      errorText: 'This field is required',
      items: [
        GrafitSelectItemData(value: 'opt1', label: 'Option 1'),
        GrafitSelectItemData(value: 'opt2', label: 'Option 2'),
      ],
    ),
  );
}

@widgetbook.UseCase(
  name: 'Interactive',
  type: GrafitSelect,
  path: 'Form/Select',
)
Widget selectInteractive(BuildContext context) {
  // Widgetbook-only: ignore undefined_getter, undefined_method, invalid_annotation_value
  final items = context.knobs.list(
    label: 'Items',
    initialOption: ['Apple', 'Banana', 'Orange', 'Grape'],
    options: [
      ['Apple', 'Banana', 'Orange'],
      ['Apple', 'Banana', 'Orange', 'Grape', 'Mango'],
      ['Option 1', 'Option 2', 'Option 3'],
    ],
  );

  // Widgetbook-only: ignore undefined_getter, undefined_method, invalid_annotation_value
  final label = context.knobs.string(label: 'Label', initialValue: 'Favorite Fruit');
  // Widgetbook-only: ignore undefined_getter, undefined_method, invalid_annotation_value
  final placeholder = context.knobs.string(label: 'Placeholder', initialValue: 'Select an option');
  // Widgetbook-only: ignore undefined_getter, undefined_method, invalid_annotation_value
  final searchable = context.knobs.boolean(label: 'Searchable', initialValue: false);
  // Widgetbook-only: ignore undefined_getter, undefined_method, invalid_annotation_value
  final enabled = context.knobs.boolean(label: 'Enabled', initialValue: true);
  // Widgetbook-only: ignore undefined_getter, undefined_method, invalid_annotation_value
  final hasError = context.knobs.boolean(label: 'Has Error', initialValue: false);

  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: GrafitSelect<String>(
      label: label.isNotEmpty ? label : null,
      placeholder: placeholder.isNotEmpty ? placeholder : 'Select...',
      searchable: searchable,
      enabled: enabled,
      errorText: hasError ? 'This field is required' : null,
      items: items.asMap().entries.map((entry) {
        return GrafitSelectItemData(
          value: entry.key.toString(),
          label: entry.value,
        );
      }).toList(),
    ),
  );
}
