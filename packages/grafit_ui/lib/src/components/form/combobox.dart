import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import '../../theme/theme.dart';
import '../../theme/theme_data.dart';
import '../../primitives/clickable.dart';

/// Combobox component size variant
enum GrafitComboboxSize {
  sm,
  md,
}

/// Combobox component - autocomplete input with dropdown suggestions
///
/// A combobox combines a text input with a dropdown list, allowing users to
/// either select from predefined options or enter custom values.
class GrafitCombobox<T> extends StatefulWidget {
  /// Currently selected value(s)
  final T? value;
  final List<T>? values;

  /// Callback when selection changes
  final ValueChanged<T>? onChanged;
  final ValueChanged<List<T>>? onMultipleChanged;

  /// Options to display in the dropdown
  final List<GrafitComboboxItemData<T>> items;

  /// Optional grouped items
  final List<GrafitComboboxGroupData<T>>? groups;

  /// Placeholder text when no value is selected
  final String? placeholder;

  /// Placeholder text for the search input
  final String? searchPlaceholder;

  /// Whether the combobox is enabled
  final bool enabled;

  /// Size variant for the combobox
  final GrafitComboboxSize size;

  /// Optional label for the combobox
  final String? label;

  /// Optional error text
  final String? errorText;

  /// Optional helper text
  final String? helperText;

  /// Whether to allow creating new items not in the list
  final bool allowCreation;

  /// Callback when user wants to create a new item
  final ValueChanged<String>? onCreate;

  /// Label for the create new option
  final String? createLabel;

  /// Whether to show the clear button
  final bool showClear;

  /// Whether to show the trigger button
  final bool showTrigger;

  /// Width of the dropdown menu
  final double? menuWidth;

  /// Max height of the dropdown menu
  final double? menuMaxHeight;

  /// Focus node for the input
  final FocusNode? focusNode;

  GrafitCombobox({
    super.key,
    required this.items,
    this.value,
    this.onChanged,
    this.placeholder,
    this.searchPlaceholder,
    this.enabled = true,
    this.size = GrafitComboboxSize.md,
    this.label,
    this.errorText,
    this.helperText,
    this.allowCreation = false,
    this.onCreate,
    this.createLabel,
    this.showClear = false,
    this.showTrigger = true,
    this.menuWidth,
    this.menuMaxHeight,
    this.focusNode,
    List<GrafitComboboxGroupData<T>>? groups,
  })  : values = null,
        onMultipleChanged = null,
        groups = groups {
    assert(
      items.isEmpty || groups == null,
      'Cannot specify both items and groups',
    );
  }

  /// Constructor for multi-select combobox
  const GrafitCombobox.multiple({
    super.key,
    required this.items,
    this.values,
    this.onMultipleChanged,
    this.placeholder,
    this.searchPlaceholder,
    this.enabled = true,
    this.size = GrafitComboboxSize.md,
    this.label,
    this.errorText,
    this.helperText,
    this.allowCreation = false,
    this.onCreate,
    this.createLabel,
    this.showClear = false,
    this.showTrigger = true,
    this.menuWidth,
    this.menuMaxHeight,
    this.focusNode,
  })  : value = null,
        onChanged = null,
        groups = null;

  /// Constructor for grouped options
  const GrafitCombobox.grouped({
    super.key,
    required this.groups,
    this.value,
    this.onChanged,
    this.placeholder,
    this.searchPlaceholder,
    this.enabled = true,
    this.size = GrafitComboboxSize.md,
    this.label,
    this.errorText,
    this.helperText,
    this.allowCreation = false,
    this.onCreate,
    this.createLabel,
    this.showClear = false,
    this.showTrigger = true,
    this.menuWidth,
    this.menuMaxHeight,
    this.focusNode,
  })  : items = const [],
        values = null,
        onMultipleChanged = null;

  @override
  State<GrafitCombobox<T>> createState() => _GrafitComboboxState<T>();
}

class _GrafitComboboxState<T> extends State<GrafitCombobox<T>> {
  final LayerLink _layerLink = LayerLink();
  final GlobalKey _triggerKey = GlobalKey();
  final TextEditingController _textController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  OverlayEntry? _overlayEntry;
  bool _isOpen = false;
  String _searchQuery = '';
  int _highlightedIndex = 0;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_handleFocusChange);
  }

  @override
  void dispose() {
    _overlayEntry?.remove();
    _textController.dispose();
    _focusNode.removeListener(_handleFocusChange);
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  void _handleFocusChange() {
    setState(() {
      if (_focusNode.hasFocus && !_isOpen) {
        _openDropdown();
      }
    });
  }

  KeyEventResult _handleKeyEvent(FocusNode node, RawKeyEvent event) {
    if (event is RawKeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.escape) {
        _closeDropdown();
        return KeyEventResult.handled;
      } else if (event.logicalKey == LogicalKeyboardKey.arrowDown && _isOpen) {
        final filteredItems = _getFilteredItems();
        if (filteredItems.isNotEmpty) {
          setState(() {
            _highlightedIndex = (_highlightedIndex + 1) % filteredItems.length;
          });
        }
        return KeyEventResult.handled;
      } else if (event.logicalKey == LogicalKeyboardKey.arrowUp && _isOpen) {
        final filteredItems = _getFilteredItems();
        if (filteredItems.isNotEmpty) {
          setState(() {
            _highlightedIndex = (_highlightedIndex - 1 + filteredItems.length) % filteredItems.length;
          });
        }
        return KeyEventResult.handled;
      } else if (event.logicalKey == LogicalKeyboardKey.enter && _isOpen) {
        final filteredItems = _getFilteredItems();
        if (filteredItems.isNotEmpty && _highlightedIndex < filteredItems.length) {
          _selectItem(filteredItems[_highlightedIndex].value);
        }
        return KeyEventResult.handled;
      }
    }
    return KeyEventResult.ignored;
  }

  void _openDropdown() {
    if (_isOpen) return;
    setState(() {
      _isOpen = true;
      _highlightedIndex = 0;
    });
    _showDropdown();
  }

  void _closeDropdown() {
    if (!_isOpen) return;
    _overlayEntry?.remove();
    setState(() {
      _overlayEntry = null;
      _isOpen = false;
      _searchQuery = '';
      _highlightedIndex = 0;
    });
  }

  void _toggleDropdown() {
    if (_isOpen) {
      _closeDropdown();
    } else {
      _openDropdown();
    }
  }

  void _showDropdown() {
    setState(() {
      _overlayEntry = OverlayEntry(
        builder: (context) => _GrafitComboboxDropdown<T>(
          layerLink: _layerLink,
          triggerKey: _triggerKey,
          items: widget.groups != null ? _buildFlattenedItems() : widget.items,
          groups: widget.groups,
          value: widget.value,
          values: widget.values,
          searchQuery: _searchQuery,
          highlightedIndex: _highlightedIndex,
          onSearchChanged: (query) {
            setState(() {
              _searchQuery = query;
              _highlightedIndex = 0;
            });
          },
          onHighlightChanged: (index) {
            setState(() {
              _highlightedIndex = index;
            });
          },
          onItemSelected: (value) {
            _selectItem(value);
          },
          enabled: widget.enabled,
          allowCreation: widget.allowCreation,
          createLabel: widget.createLabel,
          onCreate: widget.onCreate,
          menuWidth: widget.menuWidth,
          menuMaxHeight: widget.menuMaxHeight,
          onDismiss: _closeDropdown,
        ),
      );
      Overlay.of(context).insert(_overlayEntry!);
    });
  }

  void _selectItem(T value) {
    if (widget.onChanged != null) {
      widget.onChanged!(value);
      _textController.text = _getItemLabel(value);
      _closeDropdown();
    }
  }

  void _clearValue() {
    if (widget.onChanged != null) {
      widget.onChanged!(null as T);
      _textController.clear();
    }
  }

  String _getItemLabel(T value) {
    final allItems = widget.groups != null
        ? _buildFlattenedItems()
        : widget.items;

    for (final item in allItems) {
      if (item.value == value) {
        return item.label;
      }
    }
    return value.toString();
  }

  List<GrafitComboboxItemData<T>> _buildFlattenedItems() {
    if (widget.groups == null) return [];

    final flattened = <GrafitComboboxItemData<T>>[];
    for (final group in widget.groups!) {
      for (final item in group.items) {
        flattened.add(item);
      }
    }
    return flattened;
  }

  List<GrafitComboboxItemData<T>> _getFilteredItems() {
    final allItems = widget.groups != null
        ? _buildFlattenedItems()
        : widget.items;

    if (_searchQuery.isEmpty) return allItems;

    return allItems
        .where((item) =>
            item.label.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            (item.description?.toLowerCase().contains(_searchQuery.toLowerCase()) ?? false))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final effectiveEnabled = widget.enabled &&
        (widget.onChanged != null || widget.onMultipleChanged != null);

    Widget content = GrafitComboboxInput<T>(
      key: _triggerKey,
      layerLink: _layerLink,
      controller: _textController,
      focusNode: _focusNode,
      placeholder: widget.placeholder,
      size: widget.size,
      enabled: effectiveEnabled,
      isOpen: _isOpen,
      hasError: widget.errorText != null,
      showTrigger: widget.showTrigger,
      showClear: widget.showClear && (widget.value != null || (widget.values?.isNotEmpty ?? false)),
      onTap: effectiveEnabled ? () => _focusNode.requestFocus() : null,
      onTriggerTap: effectiveEnabled ? _toggleDropdown : null,
      onClear: effectiveEnabled ? _clearValue : null,
      onKeyEvent: (node, event) => _handleKeyEvent(node, event),
      displayValue: widget.value != null
          ? _getItemLabel(widget.value as T)
          : null,
    );

    if (widget.label != null) {
      content = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          GrafitComboboxLabelField(
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
          GrafitComboboxHelperText(
            helperText: widget.helperText,
            errorText: widget.errorText,
          ),
        ],
      );
    }

    return content;
  }
}

/// Combobox input widget with trigger and clear buttons
class GrafitComboboxInput<T> extends StatefulWidget {
  final LayerLink layerLink;
  final TextEditingController controller;
  final FocusNode focusNode;
  final String? placeholder;
  final GrafitComboboxSize size;
  final bool enabled;
  final bool isOpen;
  final bool hasError;
  final bool showTrigger;
  final bool showClear;
  final String? displayValue;
  final VoidCallback? onTap;
  final VoidCallback? onTriggerTap;
  final VoidCallback? onClear;
  final FocusOnKeyCallback? onKeyEvent;

  const GrafitComboboxInput({
    super.key,
    required this.layerLink,
    required this.controller,
    required this.focusNode,
    this.placeholder,
    this.size = GrafitComboboxSize.md,
    this.enabled = true,
    this.isOpen = false,
    this.hasError = false,
    this.showTrigger = true,
    this.showClear = false,
    this.displayValue,
    this.onTap,
    this.onTriggerTap,
    this.onClear,
    this.onKeyEvent,
  });

  @override
  State<GrafitComboboxInput<T>> createState() => _GrafitComboboxInputState<T>();
}

class _GrafitComboboxInputState<T> extends State<GrafitComboboxInput<T>> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<GrafitTheme>()!;
    final colors = theme.colors;

    return CompositedTransformTarget(
      link: widget.layerLink,
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            decoration: _buildDecoration(colors, context),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: Focus(
                    onKey: widget.onKeyEvent,
                    child: TextField(
                      controller: widget.controller,
                      focusNode: widget.focusNode,
                      enabled: widget.enabled,
                      decoration: InputDecoration(
                        hintText: widget.displayValue ?? widget.placeholder ?? 'Select...',
                        hintStyle: TextStyle(
                          color: colors.mutedForeground,
                          fontSize: _getFontSize(),
                        ),
                        border: InputBorder.none,
                        contentPadding: _getContentPadding(),
                        isDense: true,
                      ),
                      style: TextStyle(
                        color: widget.enabled ? colors.foreground : colors.mutedForeground,
                        fontSize: _getFontSize(),
                      ),
                    ),
                  ),
                ),
                if (widget.showClear)
                  GrafitComboboxClear(
                    enabled: widget.enabled,
                    onTap: widget.onClear,
                  ),
                if (widget.showTrigger)
                  GrafitComboboxTrigger(
                    isOpen: widget.isOpen,
                    enabled: widget.enabled,
                    onTap: widget.onTriggerTap,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  BoxDecoration _buildDecoration(GrafitColorScheme colors, BuildContext context) {
    final borderColor = widget.hasError
        ? colors.destructive
        : widget.focusNode.hasFocus
            ? colors.ring
            : _isHovered && widget.enabled
                ? colors.input
                : colors.border;

    return BoxDecoration(
      color: widget.enabled ? colors.background : colors.muted,
      border: Border.all(
        color: borderColor,
        width: widget.focusNode.hasFocus ? 2.0 : 1.0,
      ),
      borderRadius: BorderRadius.circular(colors.radius * 6),
      boxShadow: widget.focusNode.hasFocus && widget.enabled
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

  double _getFontSize() {
    return switch (widget.size) {
      GrafitComboboxSize.sm => 13.0,
      GrafitComboboxSize.md => 14.0,
    };
  }

  EdgeInsets _getContentPadding() {
    return switch (widget.size) {
      GrafitComboboxSize.sm => const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 6,
        ),
      GrafitComboboxSize.md => const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 8,
        ),
    };
  }
}

/// Combobox trigger button widget
class GrafitComboboxTrigger extends StatelessWidget {
  final bool isOpen;
  final bool enabled;
  final VoidCallback? onTap;

  const GrafitComboboxTrigger({
    super.key,
    this.isOpen = false,
    this.enabled = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<GrafitTheme>()!;
    final colors = theme.colors;

    return GrafitClickable(
      enabled: enabled,
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
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
    );
  }
}

/// Combobox clear button widget
class GrafitComboboxClear extends StatelessWidget {
  final bool enabled;
  final VoidCallback? onTap;

  const GrafitComboboxClear({
    super.key,
    this.enabled = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<GrafitTheme>()!;
    final colors = theme.colors;

    return GrafitClickable(
      enabled: enabled,
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        child: Icon(
          Icons.close,
          size: 14,
          color: colors.mutedForeground,
        ),
      ),
    );
  }
}

/// Combobox dropdown content widget
class _GrafitComboboxDropdown<T> extends StatefulWidget {
  final LayerLink layerLink;
  final GlobalKey triggerKey;
  final List<GrafitComboboxItemData<T>> items;
  final List<GrafitComboboxGroupData<T>>? groups;
  final T? value;
  final List<T>? values;
  final String searchQuery;
  final int highlightedIndex;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<int> onHighlightChanged;
  final ValueChanged<T> onItemSelected;
  final bool enabled;
  final bool allowCreation;
  final String? createLabel;
  final ValueChanged<String>? onCreate;
  final double? menuWidth;
  final double? menuMaxHeight;
  final VoidCallback onDismiss;

  const _GrafitComboboxDropdown({
    required this.layerLink,
    required this.triggerKey,
    required this.items,
    required this.groups,
    required this.value,
    required this.values,
    required this.searchQuery,
    required this.highlightedIndex,
    required this.onSearchChanged,
    required this.onHighlightChanged,
    required this.onItemSelected,
    required this.enabled,
    required this.onDismiss,
    this.allowCreation = false,
    this.createLabel,
    this.onCreate,
    this.menuWidth,
    this.menuMaxHeight,
  });

  @override
  State<_GrafitComboboxDropdown<T>> createState() => _GrafitComboboxDropdownState<T>();
}

class _GrafitComboboxDropdownState<T> extends State<_GrafitComboboxDropdown<T>>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

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
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  List<GrafitComboboxItemData<T>> _getFilteredItems() {
    if (widget.searchQuery.isEmpty) return widget.items;

    return widget.items
        .where((item) =>
            item.label.toLowerCase().contains(widget.searchQuery.toLowerCase()) ||
            (item.description?.toLowerCase().contains(widget.searchQuery.toLowerCase()) ?? false))
        .toList();
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

    final filteredItems = _getFilteredItems();
    final isEmpty = filteredItems.isEmpty;

    return Positioned.fill(
      child: GestureDetector(
        onTap: widget.onDismiss,
        behavior: HitTestBehavior.translucent,
        child: CustomSingleChildLayout(
          delegate: _GrafitComboboxDelegate(
            layerLink: widget.layerLink,
            targetSize: size,
            targetPosition: position,
            menuWidth: widget.menuWidth ?? size.width,
            menuMaxHeight: widget.menuMaxHeight ?? 300,
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
            child: GrafitComboboxContent<T>(
              items: widget.groups != null ? null : filteredItems,
              groups: widget.groups,
              value: widget.value,
              values: widget.values,
              searchQuery: widget.searchQuery,
              highlightedIndex: widget.highlightedIndex,
              onSearchChanged: widget.onSearchChanged,
              onItemSelected: widget.onItemSelected,
              onHighlightChanged: widget.onHighlightChanged,
              enabled: widget.enabled,
              allowCreation: widget.allowCreation,
              createLabel: widget.createLabel,
              onCreate: widget.onCreate,
              scrollController: _scrollController,
              searchController: _searchController,
              isEmpty: isEmpty && !widget.allowCreation,
            ),
          ),
        ),
      ),
    );
  }
}

/// Combobox content container
class GrafitComboboxContent<T> extends StatelessWidget {
  final List<GrafitComboboxItemData<T>>? items;
  final List<GrafitComboboxGroupData<T>>? groups;
  final T? value;
  final List<T>? values;
  final String searchQuery;
  final int highlightedIndex;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<T> onItemSelected;
  final ValueChanged<int> onHighlightChanged;
  final bool enabled;
  final bool allowCreation;
  final String? createLabel;
  final ValueChanged<String>? onCreate;
  final ScrollController? scrollController;
  final TextEditingController? searchController;
  final bool isEmpty;

  const GrafitComboboxContent({
    super.key,
    this.items,
    this.groups,
    this.value,
    this.values,
    required this.searchQuery,
    required this.highlightedIndex,
    required this.onSearchChanged,
    required this.onItemSelected,
    required this.onHighlightChanged,
    required this.enabled,
    this.allowCreation = false,
    this.createLabel,
    this.onCreate,
    this.scrollController,
    this.searchController,
    this.isEmpty = false,
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
            color: Color(0x0A000000),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GrafitComboboxSearchInput(
            controller: searchController,
            query: searchQuery,
            onChanged: onSearchChanged,
          ),
          if (isEmpty)
            GrafitComboboxEmpty()
          else
            Flexible(
              child: SingleChildScrollView(
                controller: scrollController,
                child: groups != null
                    ? _buildGroups(context, colors)
                    : _buildItems(context, colors, items ?? []),
              ),
            ),
          if (allowCreation && searchQuery.isNotEmpty)
            GrafitComboboxCreateItem(
              label: createLabel ?? 'Create "{}"',
              searchQuery: searchQuery,
              onCreate: onCreate,
              enabled: enabled,
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
          if (i > 0) GrafitComboboxSeparator(),
          GrafitComboboxGroup(
            label: groups![i].label,
            items: groups![i].items,
            value: value,
            values: values,
            searchQuery: searchQuery,
            highlightedIndex: highlightedIndex,
            onItemSelected: onItemSelected,
            onHighlightChanged: onHighlightChanged,
            enabled: enabled,
            startIndex: i == 0 ? 0 : _getPreviousGroupItemCount(i),
          ),
        ],
      ],
    );
  }

  int _getPreviousGroupItemCount(int groupIndex) {
    if (groups == null || groupIndex == 0) return 0;
    int count = 0;
    for (int i = 0; i < groupIndex; i++) {
      count += groups![i].items.length;
    }
    return count;
  }

  Widget _buildItems(BuildContext context, GrafitColorScheme colors, List<GrafitComboboxItemData<T>> items) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (int i = 0; i < items.length; i++)
          GrafitComboboxItem<T>(
            label: items[i].label,
            description: items[i].description,
            value: items[i].value,
            groupValue: value,
            groupValues: values,
            onChanged: onItemSelected,
            enabled: enabled && (items[i].enabled ?? true),
            isHighlighted: highlightedIndex == i,
            onTap: () => onItemSelected(items[i].value),
            onHover: (isHovered) {
              if (isHovered) {
                onHighlightChanged(i);
              }
            },
          ),
      ],
    );
  }
}

/// Combobox search input widget
class GrafitComboboxSearchInput extends StatefulWidget {
  final TextEditingController? controller;
  final String query;
  final ValueChanged<String> onChanged;

  const GrafitComboboxSearchInput({
    super.key,
    this.controller,
    required this.query,
    required this.onChanged,
  });

  @override
  State<GrafitComboboxSearchInput> createState() => _GrafitComboboxSearchInputState();
}

class _GrafitComboboxSearchInputState extends State<GrafitComboboxSearchInput> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController(text: widget.query);
  }

  @override
  void didUpdateWidget(GrafitComboboxSearchInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.query != _controller.text) {
      _controller.text = widget.query;
    }
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
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
        decoration: InputDecoration(
          hintText: 'Search...',
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

/// Combobox empty state widget
class GrafitComboboxEmpty extends StatelessWidget {
  const GrafitComboboxEmpty({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<GrafitTheme>()!;
    final colors = theme.colors;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Text(
        'No results found',
        style: TextStyle(
          color: colors.mutedForeground,
          fontSize: 14,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

/// Combobox create item widget
class GrafitComboboxCreateItem extends StatelessWidget {
  final String label;
  final String searchQuery;
  final ValueChanged<String>? onCreate;
  final bool enabled;

  const GrafitComboboxCreateItem({
    super.key,
    required this.label,
    required this.searchQuery,
    this.onCreate,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<GrafitTheme>()!;
    final colors = theme.colors;

    final displayLabel = label.replaceAll('{}', searchQuery);

    return GrafitClickable(
      enabled: enabled && onCreate != null,
      onTap: () => onCreate?.call(searchQuery),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: colors.border),
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.add,
              size: 16,
              color: colors.primary,
            ),
            const SizedBox(width: 8),
            Text(
              displayLabel,
              style: TextStyle(
                color: enabled ? colors.primary : colors.mutedForeground,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Combobox group widget
class GrafitComboboxGroup<T> extends StatelessWidget {
  final String label;
  final List<GrafitComboboxItemData<T>> items;
  final T? value;
  final List<T>? values;
  final String searchQuery;
  final int highlightedIndex;
  final ValueChanged<T> onItemSelected;
  final ValueChanged<int> onHighlightChanged;
  final bool enabled;
  final int startIndex;

  const GrafitComboboxGroup({
    super.key,
    required this.label,
    required this.items,
    this.value,
    this.values,
    required this.searchQuery,
    required this.highlightedIndex,
    required this.onItemSelected,
    required this.onHighlightChanged,
    required this.enabled,
    required this.startIndex,
  });

  List<GrafitComboboxItemData<T>> get _filteredItems {
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
        GrafitComboboxLabel(label: label),
        for (int i = 0; i < _filteredItems.length; i++)
          GrafitComboboxItem<T>(
            label: _filteredItems[i].label,
            description: _filteredItems[i].description,
            value: _filteredItems[i].value,
            groupValue: value,
            groupValues: values,
            onChanged: onItemSelected,
            enabled: enabled && (_filteredItems[i].enabled ?? true),
            isHighlighted: highlightedIndex == startIndex + i,
            onTap: () => onItemSelected(_filteredItems[i].value),
            onHover: (isHovered) {
              if (isHovered) {
                onHighlightChanged(startIndex + i);
              }
            },
          ),
      ],
    );
  }
}

/// Combobox item widget
class GrafitComboboxItem<T> extends StatefulWidget {
  final String label;
  final String? description;
  final T value;
  final T? groupValue;
  final List<T>? groupValues;
  final ValueChanged<T>? onChanged;
  final bool enabled;
  final bool isHighlighted;
  final VoidCallback onTap;
  final ValueChanged<bool> onHover;

  const GrafitComboboxItem({
    super.key,
    required this.label,
    this.description,
    required this.value,
    this.groupValue,
    this.groupValues,
    this.onChanged,
    this.enabled = true,
    this.isHighlighted = false,
    required this.onTap,
    required this.onHover,
  });

  @override
  State<GrafitComboboxItem<T>> createState() => _GrafitComboboxItemState<T>();
}

class _GrafitComboboxItemState<T> extends State<GrafitComboboxItem<T>> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<GrafitTheme>()!;
    final colors = theme.colors;
    final isSelected = widget.groupValue != null && widget.groupValue == widget.value;
    final isMultiSelected = widget.groupValues?.contains(widget.value) ?? false;

    return MouseRegion(
      onEnter: (_) {
        setState(() => _isHovered = true);
        widget.onHover(true);
      },
      onExit: (_) {
        setState(() => _isHovered = false);
        widget.onHover(false);
      },
      child: GestureDetector(
        onTap: widget.enabled ? widget.onTap : null,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: widget.isHighlighted || _isHovered
                ? colors.accent.withOpacity(0.5)
                : (isSelected || isMultiSelected
                    ? colors.muted.withOpacity(0.3)
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
                      widget.label,
                      style: TextStyle(
                        color: widget.enabled
                            ? colors.foreground
                            : colors.mutedForeground,
                        fontSize: 14,
                      ),
                    ),
                    if (widget.description != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        widget.description!,
                        style: TextStyle(
                          color: colors.mutedForeground,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (isSelected || isMultiSelected)
                Icon(
                  Icons.check,
                  size: 16,
                  color: colors.primary,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Combobox label widget for groups
class GrafitComboboxLabel extends StatelessWidget {
  final String label;

  const GrafitComboboxLabel({
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

/// Combobox label widget for form field
class GrafitComboboxLabelField extends StatelessWidget {
  final String label;
  final bool enabled;

  const GrafitComboboxLabelField({
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

/// Combobox separator widget
class GrafitComboboxSeparator extends StatelessWidget {
  const GrafitComboboxSeparator({super.key});

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

/// Combobox helper text widget
class GrafitComboboxHelperText extends StatelessWidget {
  final String? helperText;
  final String? errorText;

  const GrafitComboboxHelperText({
    super.key,
    this.helperText,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<GrafitTheme>()!;
    final colors = theme.colors;

    final text = errorText ?? helperText;
    final textColor = errorText != null ? colors.destructive : colors.mutedForeground;

    if (text == null) return const SizedBox.shrink();

    return Text(
      text,
      style: TextStyle(
        color: textColor,
        fontSize: 12,
      ),
    );
  }
}

/// Data class for combobox item
class GrafitComboboxItemData<T> {
  /// Value for this item
  final T value;

  /// Label text
  final String label;

  /// Optional description text
  final String? description;

  /// Whether this specific item is enabled
  final bool? enabled;

  const GrafitComboboxItemData({
    required this.value,
    required this.label,
    this.description,
    this.enabled,
  });
}

/// Data class for combobox group
class GrafitComboboxGroupData<T> {
  /// Group label
  final String label;

  /// Items in this group
  final List<GrafitComboboxItemData<T>> items;

  const GrafitComboboxGroupData({
    required this.label,
    required this.items,
  });
}

/// Custom layout delegate for positioning combobox dropdown
class _GrafitComboboxDelegate extends SingleChildLayoutDelegate {
  final LayerLink layerLink;
  final Size targetSize;
  final Offset targetPosition;
  final double menuWidth;
  final double menuMaxHeight;

  _GrafitComboboxDelegate({
    required this.layerLink,
    required this.targetSize,
    required this.targetPosition,
    required this.menuWidth,
    required this.menuMaxHeight,
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
  Offset getPositionForChild(Size size, Size childSize) {
    double x = targetPosition.dx;
    double y = targetPosition.dy + targetSize.height + 4;

    // Ensure dropdown doesn't go off screen
    if (x + menuWidth > size.width) {
      x = size.width - menuWidth - 8;
    }
    if (y + menuMaxHeight > size.height) {
      y = targetPosition.dy - menuMaxHeight - 4;
      if (y < 0) {
        y = 8;
      }
    }

    return Offset(x, y);
  }

  @override
  bool shouldRelayout(_GrafitComboboxDelegate oldDelegate) {
    return true;
  }
}

// ============================================================
// WIDGETBOOK USE CASES
// ============================================================

@widgetbook.UseCase(
  name: 'Default',
  type: GrafitCombobox,
  path: 'Form/Combobox',
)
Widget comboboxDefault(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.all(24.0),
    child: SizedBox(
      width: 300,
      child: GrafitCombobox<String>(
        items: [
          GrafitComboboxItemData(value: 'apple', label: 'Apple'),
          GrafitComboboxItemData(value: 'banana', label: 'Banana'),
          GrafitComboboxItemData(value: 'orange', label: 'Orange'),
          GrafitComboboxItemData(value: 'grape', label: 'Grape'),
        ],
        placeholder: 'Select a fruit',
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'With Value',
  type: GrafitCombobox,
  path: 'Form/Combobox',
)
Widget comboboxWithValue(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.all(24.0),
    child: SizedBox(
      width: 300,
      child: GrafitCombobox<String>(
        items: [
          GrafitComboboxItemData(value: 'apple', label: 'Apple'),
          GrafitComboboxItemData(value: 'banana', label: 'Banana'),
          GrafitComboboxItemData(value: 'orange', label: 'Orange'),
        ],
        value: 'banana',
        placeholder: 'Select a fruit',
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'Small Size',
  type: GrafitCombobox,
  path: 'Form/Combobox',
)
Widget comboboxSmall(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.all(24.0),
    child: SizedBox(
      width: 280,
      child: GrafitCombobox<String>(
        items: [
          GrafitComboboxItemData(value: 'sm', label: 'Small'),
          GrafitComboboxItemData(value: 'md', label: 'Medium'),
          GrafitComboboxItemData(value: 'lg', label: 'Large'),
        ],
        size: GrafitComboboxSize.sm,
        placeholder: 'Select size',
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'With Label',
  type: GrafitCombobox,
  path: 'Form/Combobox',
)
Widget comboboxWithLabel(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.all(24.0),
    child: SizedBox(
      width: 300,
      child: GrafitCombobox<String>(
        items: [
          GrafitComboboxItemData(value: 'us', label: 'United States'),
          GrafitComboboxItemData(value: 'uk', label: 'United Kingdom'),
          GrafitComboboxItemData(value: 'ca', label: 'Canada'),
        ],
        label: 'Country',
        placeholder: 'Select your country',
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'With Error',
  type: GrafitCombobox,
  path: 'Form/Combobox',
)
Widget comboboxWithError(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.all(24.0),
    child: SizedBox(
      width: 300,
      child: GrafitCombobox<String>(
        items: [
          GrafitComboboxItemData(value: 'admin', label: 'Admin'),
          GrafitComboboxItemData(value: 'user', label: 'User'),
          GrafitComboboxItemData(value: 'guest', label: 'Guest'),
        ],
        label: 'Role',
        errorText: 'This field is required',
        placeholder: 'Select a role',
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'With Helper Text',
  type: GrafitCombobox,
  path: 'Form/Combobox',
)
Widget comboboxWithHelper(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.all(24.0),
    child: SizedBox(
      width: 300,
      child: GrafitCombobox<String>(
        items: [
          GrafitComboboxItemData(value: 'light', label: 'Light'),
          GrafitComboboxItemData(value: 'dark', label: 'Dark'),
          GrafitComboboxItemData(value: 'system', label: 'System'),
        ],
        label: 'Theme',
        helperText: 'Choose your preferred theme',
        placeholder: 'Select theme',
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'Disabled',
  type: GrafitCombobox,
  path: 'Form/Combobox',
)
Widget comboboxDisabled(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.all(24.0),
    child: SizedBox(
      width: 300,
      child: GrafitCombobox<String>(
        items: [
          GrafitComboboxItemData(value: 'option1', label: 'Option 1'),
          GrafitComboboxItemData(value: 'option2', label: 'Option 2'),
        ],
        enabled: false,
        placeholder: 'Disabled combobox',
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'With Create Option',
  type: GrafitCombobox,
  path: 'Form/Combobox',
)
Widget comboboxWithCreate(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.all(24.0),
    child: SizedBox(
      width: 300,
      child: GrafitCombobox<String>(
        items: [
          GrafitComboboxItemData(value: 'red', label: 'Red'),
          GrafitComboboxItemData(value: 'blue', label: 'Blue'),
          GrafitComboboxItemData(value: 'green', label: 'Green'),
        ],
        allowCreation: true,
        createLabel: 'Create "{}"',
        placeholder: 'Select or create a color',
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'Grouped Options',
  type: GrafitCombobox,
  path: 'Form/Combobox',
)
Widget comboboxGrouped(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.all(24.0),
    child: SizedBox(
      width: 300,
      child: GrafitCombobox<String>.grouped(
        groups: [
          GrafitComboboxGroupData(
            label: 'Fruits',
            items: [
              GrafitComboboxItemData(value: 'apple', label: 'Apple'),
              GrafitComboboxItemData(value: 'banana', label: 'Banana'),
            ],
          ),
          GrafitComboboxGroupData(
            label: 'Vegetables',
            items: [
              GrafitComboboxItemData(value: 'carrot', label: 'Carrot'),
              GrafitComboboxItemData(value: 'broccoli', label: 'Broccoli'),
            ],
          ),
        ],
        placeholder: 'Select a food',
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'Interactive',
  type: GrafitCombobox,
  path: 'Form/Combobox',
)
Widget comboboxInteractive(BuildContext context) {
  final placeholder = context.knobs.string(label: 'Placeholder', initialValue: 'Select an option');
  final enabled = context.knobs.boolean(label: 'Enabled', initialValue: true);
  final size = context.knobs.list(
    label: 'Size',
    initialOption: GrafitComboboxSize.md,
    options: const [GrafitComboboxSize.sm, GrafitComboboxSize.md],
  );
  final showClear = context.knobs.boolean(label: 'Show Clear', initialValue: false);
  final showTrigger = context.knobs.boolean(label: 'Show Trigger', initialValue: true);
  final hasError = context.knobs.boolean(label: 'Has Error', initialValue: false);

  return Padding(
    padding: const EdgeInsets.all(24.0),
    child: SizedBox(
      width: 300,
      child: GrafitCombobox<String>(
        items: const [
          GrafitComboboxItemData(value: 'option1', label: 'Option 1'),
          GrafitComboboxItemData(value: 'option2', label: 'Option 2'),
          GrafitComboboxItemData(value: 'option3', label: 'Option 3'),
        ],
        placeholder: placeholder.isNotEmpty ? placeholder : null,
        enabled: enabled,
        size: size,
        showClear: showClear,
        showTrigger: showTrigger,
        errorText: hasError ? 'This field has an error' : null,
      ),
    ),
  );
}
