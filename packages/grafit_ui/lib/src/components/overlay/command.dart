import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../theme/theme.dart';

/// Command palette component - a dropdown menu for commands
class GrafitCommand extends StatefulWidget {
  final List<GrafitCommandGroup> groups;
  final String? placeholder;
  final ValueChanged<String>? onSearch;
  final bool autofocus;
  final Widget? emptyState;
  final double? maxHeight;
  final EdgeInsets? padding;
  final GrafitCommandController? controller;

  const GrafitCommand({
    super.key,
    required this.groups,
    this.placeholder,
    this.onSearch,
    this.autofocus = true,
    this.emptyState,
    this.maxHeight,
    this.padding,
    this.controller,
  });

  @override
  State<GrafitCommand> createState() => _GrafitCommandState();
}

class _GrafitCommandState extends State<GrafitCommand> {
  late TextEditingController _searchController;
  late FocusNode _focusNode;
  String _searchQuery = '';
  int _selectedIndex = 0;
  ScrollController? _scrollController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _focusNode = FocusNode();
    _scrollController = ScrollController();
    _searchController.addListener(_onSearchChanged);
    if (widget.autofocus) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _focusNode.requestFocus();
      });
    }
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _focusNode.dispose();
    _scrollController?.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text.toLowerCase();
      _selectedIndex = 0;
    });
    widget.onSearch?.call(_searchController.text);
  }

  List<GrafitCommandItem> _getFilteredItems() {
    final items = <GrafitCommandItem>[];
    for (final group in widget.groups) {
      for (final item in group.items) {
        if (_searchQuery.isEmpty ||
            item.label.toLowerCase().contains(_searchQuery) ||
            (item.keywords?.any((k) => k.toLowerCase().contains(_searchQuery)) ?? false)) {
          items.add(item);
        }
      }
    }
    return items;
  }

  void _handleKeyDown(KeyEvent event) {
    if (event is! KeyDownEvent) return;

    final filteredItems = _getFilteredItems();
    if (filteredItems.isEmpty) return;

    switch (event.logicalKey) {
      case LogicalKeyboardKey.arrowDown:
        setState(() {
          _selectedIndex = (_selectedIndex + 1) % filteredItems.length;
        });
        _scrollToSelected();
        break;
      case LogicalKeyboardKey.arrowUp:
        setState(() {
          _selectedIndex = (_selectedIndex - 1 + filteredItems.length) % filteredItems.length;
        });
        _scrollToSelected();
        break;
      case LogicalKeyboardKey.enter:
        final item = filteredItems[_selectedIndex];
        item.onPressed?.call();
        break;
      case LogicalKeyboardKey.escape:
        _searchController.clear();
        _focusNode.unfocus();
        Navigator.of(context).maybePop();
        break;
    }
  }

  void _scrollToSelected() {
    // Scroll to make selected item visible
    // This is a simplified implementation
    _scrollController?.animateTo(
      _selectedIndex * 48.0,
      duration: const Duration(milliseconds: 150),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<GrafitTheme>()!;
    final colors = theme.colors;
    final filteredItems = _getFilteredItems();

    return KeyboardListener(
      focusNode: FocusNode()..requestFocus(),
      onKeyEvent: _handleKeyDown,
      child: Container(
        constraints: BoxConstraints(
          maxHeight: widget.maxHeight ?? 400,
        ),
        decoration: BoxDecoration(
          color: colors.popover,
          borderRadius: BorderRadius.circular(colors.radius * 8),
          border: Border.all(color: colors.border),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GrafitCommandInput(
              controller: _searchController,
              focusNode: _focusNode,
              placeholder: widget.placeholder,
            ),
            Flexible(
              child: GrafitCommandList(
                items: filteredItems,
                selectedIndex: _selectedIndex,
                scrollController: _scrollController,
                emptyState: widget.emptyState,
                groups: widget.groups,
                searchQuery: _searchQuery,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Command input widget
class GrafitCommandInput extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final String? placeholder;

  const GrafitCommandInput({
    super.key,
    required this.controller,
    required this.focusNode,
    this.placeholder,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<GrafitTheme>()!;
    final colors = theme.colors;

    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: colors.border,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.search,
            size: 18,
            color: colors.mutedForeground,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: controller,
              focusNode: focusNode,
              decoration: InputDecoration(
                hintText: placeholder ?? 'Search...',
                hintStyle: TextStyle(
                  color: colors.mutedForeground,
                  fontSize: 14,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
                isDense: true,
              ),
              style: TextStyle(
                color: colors.foreground,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Command list widget
class GrafitCommandList extends StatelessWidget {
  final List<GrafitCommandItem> items;
  final int selectedIndex;
  final ScrollController? scrollController;
  final Widget? emptyState;
  final List<GrafitCommandGroup> groups;
  final String searchQuery;

  const GrafitCommandList({
    super.key,
    required this.items,
    required this.selectedIndex,
    this.scrollController,
    this.emptyState,
    required this.groups,
    required this.searchQuery,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<GrafitTheme>()!;
    final colors = theme.colors;

    if (items.isEmpty) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: emptyState ??
          Center(
            child: Text(
              'No results found.',
              style: TextStyle(
                color: colors.mutedForeground,
                fontSize: 14,
              ),
            ),
          ),
      );
    }

    // Group items by their original groups
    final groupedItems = <_GroupedItems>[];
    for (final group in groups) {
      final groupItems = group.items
          .where((item) =>
              searchQuery.isEmpty ||
              item.label.toLowerCase().contains(searchQuery) ||
              (item.keywords?.any((k) => k.toLowerCase().contains(searchQuery)) ?? false))
          .toList();

      if (groupItems.isNotEmpty) {
        groupedItems.add(_GroupedItems(
          group: group,
          items: groupItems,
        ));
      }
    }

    return ListView.separated(
      controller: scrollController,
      padding: const EdgeInsets.symmetric(vertical: 8),
      shrinkWrap: true,
      itemCount: groupedItems.length,
      separatorBuilder: (context, index) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: GrafitCommandSeparator(),
      ),
      itemBuilder: (context, groupIndex) {
        final grouped = groupedItems[groupIndex];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (grouped.group.label != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
                child: Text(
                  grouped.group.label!,
                  style: TextStyle(
                    color: colors.mutedForeground,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ...grouped.items.asMap().entries.map((entry) {
              final item = entry.value;
              // Find global index
              final globalIndex = items.indexOf(item);
              final isSelected = globalIndex == selectedIndex;
              return GrafitCommandItemWidget(
                item: item,
                isSelected: isSelected,
                onPressed: item.onPressed,
              );
            }),
          ],
        );
      },
    );
  }
}

class _GroupedItems {
  final GrafitCommandGroup group;
  final List<GrafitCommandItem> items;

  _GroupedItems({
    required this.group,
    required this.items,
  });
}

/// Command item widget
class GrafitCommandItemWidget extends StatelessWidget {
  final GrafitCommandItem item;
  final bool isSelected;
  final VoidCallback? onPressed;

  const GrafitCommandItemWidget({
    super.key,
    required this.item,
    required this.isSelected,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<GrafitTheme>()!;
    final colors = theme.colors;

    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? colors.accent : colors.transparent,
        ),
        child: Row(
          children: [
            if (item.icon != null) ...[
              Icon(
                item.icon,
                size: 16,
                color: isSelected ? colors.accentForeground : colors.mutedForeground,
              ),
              const SizedBox(width: 8),
            ],
            Expanded(
              child: Text(
                item.label,
                style: TextStyle(
                  color: isSelected ? colors.accentForeground : colors.foreground,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            if (item.shortcut != null)
              GrafitCommandShortcut(shortcut: item.shortcut!),
          ],
        ),
      ),
    );
  }
}

/// Command shortcut widget
class GrafitCommandShortcut extends StatelessWidget {
  final String shortcut;

  const GrafitCommandShortcut({
    super.key,
    required this.shortcut,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<GrafitTheme>()!;
    final colors = theme.colors;

    return Text(
      shortcut,
      style: TextStyle(
        color: colors.mutedForeground,
        fontSize: 11,
        letterSpacing: 1.2,
      ),
    );
  }
}

/// Command separator widget
class GrafitCommandSeparator extends StatelessWidget {
  const GrafitCommandSeparator({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<GrafitTheme>()!;
    final colors = theme.colors;

    return Container(
      height: 1,
      color: colors.border,
    );
  }
}

/// Command empty state widget
class GrafitCommandEmpty extends StatelessWidget {
  final String? title;
  final String? description;
  final Widget? icon;

  const GrafitCommandEmpty({
    super.key,
    this.title,
    this.description,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<GrafitTheme>()!;
    final colors = theme.colors;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null)
              IconTheme(
                data: IconThemeData(
                  color: colors.mutedForeground,
                  size: 32,
                ),
                child: icon!,
              ),
            if (title != null) ...[
              const SizedBox(height: 8),
              Text(
                title!,
                style: TextStyle(
                  color: colors.foreground,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
            if (description != null) ...[
              const SizedBox(height: 4),
              Text(
                description!,
                style: TextStyle(
                  color: colors.mutedForeground,
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Command group data class
class GrafitCommandGroup {
  final String? label;
  final List<GrafitCommandItem> items;

  const GrafitCommandGroup({
    this.label,
    required this.items,
  });
}

/// Command item data class
class GrafitCommandItem {
  final String label;
  final IconData? icon;
  final String? shortcut;
  final VoidCallback? onPressed;
  final bool disabled;
  final List<String>? keywords;

  const GrafitCommandItem({
    required this.label,
    this.icon,
    this.shortcut,
    this.onPressed,
    this.disabled = false,
    this.keywords,
  });
}

/// Command controller for programmatic control
class GrafitCommandController extends ChangeNotifier {
  String _searchQuery = '';
  bool _isOpen = false;

  String get searchQuery => _searchQuery;
  bool get isOpen => _isOpen;

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void open() {
    _isOpen = true;
    notifyListeners();
  }

  void close() {
    _isOpen = false;
    notifyListeners();
  }

  void toggle() {
    _isOpen = !_isOpen;
    notifyListeners();
  }
}

/// Command dialog - a modal dialog wrapper for command palette
class GrafitCommandDialog extends StatefulWidget {
  final String? title;
  final String? description;
  final List<GrafitCommandGroup> groups;
  final String? placeholder;
  final ValueChanged<String>? onSearch;
  final Widget? emptyState;
  final bool showCloseButton;
  final VoidCallback? onOpen;
  final VoidCallback? onClose;

  const GrafitCommandDialog({
    super.key,
    this.title = 'Command Palette',
    this.description = 'Search for a command to run...',
    required this.groups,
    this.placeholder,
    this.onSearch,
    this.emptyState,
    this.showCloseButton = true,
    this.onOpen,
    this.onClose,
  });

  @override
  State<GrafitCommandDialog> createState() => _GrafitCommandDialogState();

  /// Show command dialog
  static Future<void> show(
    BuildContext context, {
    String? title,
    String? description,
    required List<GrafitCommandGroup> groups,
    String? placeholder,
    ValueChanged<String>? onSearch,
    Widget? emptyState,
    bool showCloseButton = true,
    VoidCallback? onOpen,
    VoidCallback? onClose,
  }) {
    return showDialog<void>(
      context: context,
      builder: (context) => GrafitCommandDialog(
        title: title,
        description: description,
        groups: groups,
        placeholder: placeholder,
        onSearch: onSearch,
        emptyState: emptyState,
        showCloseButton: showCloseButton,
        onOpen: onOpen,
        onClose: onClose,
      ),
    );
  }
}

class _GrafitCommandDialogState extends State<GrafitCommandDialog> {
  @override
  void initState() {
    super.initState();
    widget.onOpen?.call();
  }

  @override
  void dispose() {
    widget.onClose?.call();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<GrafitTheme>()!;
    final colors = theme.colors;

    return Dialog(
      backgroundColor: colors.transparent,
      elevation: 0,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Screen reader-only title/description
            Visibility(
              visible: false,
              maintainSize: false,
              maintainAnimation: true,
              maintainState: true,
              child: Column(
                children: [
                  if (widget.title != null)
                    Text(widget.title!),
                  if (widget.description != null)
                    Text(widget.description!),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: colors.background,
                borderRadius: BorderRadius.circular(colors.radius * 8),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x1A000000),
                    blurRadius: 16,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              child: GrafitCommand(
                groups: widget.groups,
                placeholder: widget.placeholder,
                onSearch: widget.onSearch,
                emptyState: widget.emptyState,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Command list widget (standalone for use outside dialog)
class GrafitCommandListWrapper extends StatelessWidget {
  final List<GrafitCommandGroup> groups;
  final String searchQuery;

  const GrafitCommandListWrapper({
    super.key,
    required this.groups,
    required this.searchQuery,
  });

  @override
  Widget build(BuildContext context) {
    final filteredItems = <GrafitCommandItem>[];
    for (final group in groups) {
      for (final item in group.items) {
        if (searchQuery.isEmpty ||
            item.label.toLowerCase().contains(searchQuery) ||
            (item.keywords?.any((k) => k.toLowerCase().contains(searchQuery)) ?? false)) {
          filteredItems.add(item);
        }
      }
    }

    return GrafitCommandList(
      items: filteredItems,
      selectedIndex: 0,
      groups: groups,
      searchQuery: searchQuery,
    );
  }
}
