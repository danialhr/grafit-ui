import 'package:flutter/material.dart';
import '../../theme/theme.dart';
import '../../theme/theme_data.dart';

/// Sort direction for table columns
enum GrafitTableSortDirection {
  ascending,
  descending,
  none,
}

/// Column definition for data table
class GrafitTableColumn<T> {
  final String id;
  final String label;
  final Widget Function(BuildContext context, T item) cellBuilder;
  final Widget? header;
  final bool sortable;
  final bool numeric;
  final double? width;
  final FlexWidth? flexWidth;
  final TextAlign? align;
  final bool selectable;

  const GrafitTableColumn({
    required this.id,
    required this.label,
    required this.cellBuilder,
    this.header,
    this.sortable = true,
    this.numeric = false,
    this.width,
    this.flexWidth,
    this.align,
    this.selectable = true,
  });

  /// Get text alignment for column
  TextAlign get alignment {
    if (align != null) return align!;
    return numeric ? TextAlign.end : TextAlign.start;
  }
}

/// Flex width specification for responsive columns
class FlexWidth {
  final int flex;
  final double? min;
  final double? max;

  const FlexWidth({
    this.flex = 1,
    this.min,
    this.max,
  });
}

/// Row selection mode
enum GrafitTableSelectionMode {
  none,
  single,
  multiple,
}

/// Data table configuration
class GrafitDataTableConfig<T> {
  final List<GrafitTableColumn<T>> columns;
  final GrafitTableSelectionMode selectionMode;
  final bool showCheckboxColumn;
  final bool stripeRows;
  final bool showBorders;
  final bool hoverHighlight;
  final EdgeInsets cellPadding;
  final double rowHeight;
  final double headerHeight;
  final bool sortable;
  final Widget? emptyState;
  final Widget? loadingIndicator;
  final bool shrinkWrap;

  const GrafitDataTableConfig({
    required this.columns,
    this.selectionMode = GrafitTableSelectionMode.none,
    this.showCheckboxColumn = true,
    this.stripeRows = true,
    this.showBorders = true,
    this.hoverHighlight = true,
    this.cellPadding = const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    this.rowHeight = kMinInteractiveDimension,
    this.headerHeight = 56,
    this.sortable = true,
    this.emptyState,
    this.loadingIndicator,
    this.shrinkWrap = false,
  });
}

/// Main Data Table widget with full feature parity to shadcn-ui Table
class GrafitDataTable<T> extends StatefulWidget {
  final List<T> data;
  final GrafitDataTableConfig<T> config;
  final Widget Function(BuildContext context, T item)? rowBuilder;
  final Widget? header;
  final Widget? footer;
  final String? caption;
  final void Function(Set<T> selected)? onSelectionChanged;
  final void Function(GrafitTableColumn<T> column, GrafitTableSortDirection direction)?
      onSort;
  final GrafitTableColumn<T>? initialSortColumn;
  final GrafitTableSortDirection initialSortDirection;
  final bool isLoading;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;
  final Color? stripeColor;
  final BorderRadius? borderRadius;
  final BoxBorder? border;
  final List<BoxShadow>? boxShadow;
  final ScrollController? scrollController;
  final bool horizontalScroll;

  const GrafitDataTable({
    super.key,
    required this.data,
    required this.config,
    this.rowBuilder,
    this.header,
    this.footer,
    this.caption,
    this.onSelectionChanged,
    this.onSort,
    this.initialSortColumn,
    this.initialSortDirection = GrafitTableSortDirection.ascending,
    this.isLoading = false,
    this.padding,
    this.backgroundColor,
    this.stripeColor,
    this.borderRadius,
    this.border,
    this.boxShadow,
    this.scrollController,
    this.horizontalScroll = true,
  });

  @override
  State<GrafitDataTable<T>> createState() => _GrafitDataTableState<T>();
}

class _GrafitDataTableState<T> extends State<GrafitDataTable<T>> {
  late Set<T> _selectedItems;
  GrafitTableColumn<T>? _sortColumn;
  GrafitTableSortDirection _sortDirection = GrafitTableSortDirection.none;

  @override
  void initState() {
    super.initState();
    _selectedItems = {};
    _sortColumn = widget.initialSortColumn;
    _sortDirection = widget.initialSortDirection;
  }

  @override
  void didUpdateWidget(GrafitDataTable<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Remove selected items that are no longer in data
    if (oldWidget.data != widget.data) {
      _selectedItems = _selectedItems.where(widget.data.contains).toSet();
    }
  }

  void _handleRowSelection(T item, bool? selected) {
    setState(() {
      switch (widget.config.selectionMode) {
        case GrafitTableSelectionMode.none:
          break;
        case GrafitTableSelectionMode.single:
          _selectedItems = selected == true ? {item} : {};
          break;
        case GrafitTableSelectionMode.multiple:
          if (selected == true) {
            _selectedItems.add(item);
          } else {
            _selectedItems.remove(item);
          }
          break;
      }
    });
    widget.onSelectionChanged?.call(_selectedItems);
  }

  void _handleSelectAll(bool? selected) {
    setState(() {
      if (selected == true) {
        _selectedItems = widget.data.toSet();
      } else {
        _selectedItems.clear();
      }
    });
    widget.onSelectionChanged?.call(_selectedItems);
  }

  void _handleSort(GrafitTableColumn<T> column) {
    if (!widget.config.sortable || !column.sortable) return;

    setState(() {
      if (_sortColumn == column) {
        _sortDirection = switch (_sortDirection) {
          GrafitTableSortDirection.ascending => GrafitTableSortDirection.descending,
          GrafitTableSortDirection.descending => GrafitTableSortDirection.none,
          GrafitTableSortDirection.none => GrafitTableSortDirection.ascending,
        };
        if (_sortDirection == GrafitTableSortDirection.none) {
          _sortColumn = null;
        }
      } else {
        _sortColumn = column;
        _sortDirection = GrafitTableSortDirection.ascending;
      }
    });
    widget.onSort?.call(column, _sortDirection);
  }

  bool _isSelected(T item) => _selectedItems.contains(item);

  bool get _showCheckboxColumn =>
      widget.config.showCheckboxColumn &&
      widget.config.selectionMode != GrafitTableSelectionMode.none;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<GrafitTheme>()!;
    final colors = theme.colors;

    final tableContent = Column(
      mainAxisSize: widget.config.shrinkWrap ? MainAxisSize.min : MainAxisSize.max,
      children: [
        if (widget.header != null) widget.header!,
        _buildTable(context, theme),
        if (widget.footer != null) widget.footer!,
      ],
    );

    final container = Container(
      padding: widget.padding,
      decoration: BoxDecoration(
        color: widget.backgroundColor ?? colors.card,
        borderRadius: widget.borderRadius,
        border: widget.border,
        boxShadow: widget.boxShadow,
      ),
      child: tableContent,
    );

    if (widget.horizontalScroll) {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        controller: widget.scrollController,
        child: container,
      );
    }

    return container;
  }

  Widget _buildTable(BuildContext context, GrafitTheme theme) {
    if (widget.isLoading && widget.config.loadingIndicator != null) {
      return SizedBox(
        height: 200,
        child: Center(child: widget.config.loadingIndicator),
      );
    }

    if (widget.data.isEmpty && widget.config.emptyState != null) {
      return SizedBox(
        height: 200,
        child: Center(child: widget.config.emptyState),
      );
    }

    final columns = widget.config.columns;

    return Table(
      columnWidths: _buildColumnWidths(columns),
      border: widget.config.showBorders
          ? TableBorder.symmetric(
              inside: BorderSide(color: theme.colors.border, width: 1),
              outside: BorderSide.none,
            )
          : TableBorder(
              verticalInside: BorderSide.none,
              horizontalInside: BorderSide.none,
              top: BorderSide.none,
              bottom: BorderSide.none,
              left: BorderSide.none,
              right: BorderSide.none,
            ),
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: [
        _buildHeader(context, theme, columns),
        ..._buildBody(context, theme, columns),
      ],
    );
  }

  Map<int, TableColumnWidth> _buildColumnWidths(List<GrafitTableColumn<T>> columns) {
    final Map<int, TableColumnWidth> widthMap = {};

    for (int i = 0; i < columns.length; i++) {
      final column = columns[i];
      if (column.width != null) {
        widthMap[i] = FixedColumnWidth(column.width!);
      } else if (column.flexWidth != null) {
        widthMap[i] = FlexColumnWidth(column.flexWidth!.flex.toDouble());
      }
    }

    return widthMap;
  }

  TableRow _buildHeader(BuildContext context, GrafitTheme theme, List<GrafitTableColumn<T>> columns) {
    return TableRow(
      decoration: BoxDecoration(
        color: theme.colors.muted.withOpacity(0.3),
      ),
      children: [
        if (_showCheckboxColumn)
          DataTableHead(
            padding: widget.config.cellPadding,
            height: widget.config.headerHeight,
            child: Checkbox(
              value: widget.data.isNotEmpty && _selectedItems.length == widget.data.length,
              tristate: true,
              onChanged: _handleSelectAll,
            ),
          ),
        ...columns.map((column) => DataTableHead(
          padding: widget.config.cellPadding,
          height: widget.config.headerHeight,
          align: column.alignment,
          child: _buildHeaderContent(context, column, theme),
        )),
      ],
    );
  }

  Widget _buildHeaderContent(BuildContext context, GrafitTableColumn<T> column, GrafitTheme theme) {
    if (column.header != null) {
      return column.header!;
    }

    if (!widget.config.sortable || !column.sortable) {
      return Text(
        column.label,
        style: TextStyle(
          color: theme.colors.foreground,
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
      );
    }

    final isSorted = _sortColumn == column;
    final sortIcon = switch (_sortDirection) {
      GrafitTableSortDirection.ascending => Icons.arrow_upward,
      GrafitTableSortDirection.descending => Icons.arrow_downward,
      GrafitTableSortDirection.none => Icons.unfold_more,
    };

    return InkWell(
      onTap: () => _handleSort(column),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            column.label,
            style: TextStyle(
              color: theme.colors.foreground,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
          const SizedBox(width: 8),
          Icon(
            sortIcon,
            size: 16,
            color: isSorted ? theme.colors.primary : theme.colors.mutedForeground,
          ),
        ],
      ),
    );
  }

  List<TableRow> _buildBody(BuildContext context, GrafitTheme theme, List<GrafitTableColumn<T>> columns) {
    return widget.data.asMap().entries.map((entry) {
      final index = entry.key;
      final item = entry.value;
      final isSelected = _isSelected(item);

      return TableRow(
        decoration: BoxDecoration(
          color: isSelected
              ? theme.colors.primary.withOpacity(0.1)
              : (widget.config.stripeRows && index % 2 == 1
                  ? (widget.stripeColor ?? theme.colors.muted.withOpacity(0.2))
                  : null),
        ),
        children: [
          if (_showCheckboxColumn)
            DataTableCell(
              padding: widget.config.cellPadding,
              height: widget.config.rowHeight,
              child: Checkbox(
                value: isSelected,
                onChanged: (value) => _handleRowSelection(item, value),
              ),
            ),
          ...columns.map((column) => DataTableCell(
            padding: widget.config.cellPadding,
            height: widget.config.rowHeight,
            align: column.alignment,
            child: column.cellBuilder(context, item),
          )),
        ],
      );
    }).toList();
  }
}

/// Table Header subcomponent
class DataTableHeader extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final double? height;
  final Color? backgroundColor;
  final BoxBorder? border;

  const DataTableHeader({
    super.key,
    required this.child,
    this.padding,
    this.height,
    this.backgroundColor,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<GrafitTheme>()!;

    return Container(
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      height: height,
      decoration: BoxDecoration(
        color: backgroundColor ?? theme.colors.muted.withOpacity(0.3),
        border: border,
      ),
      child: child,
    );
  }
}

/// Table Body subcomponent
class DataTableBody extends StatelessWidget {
  final List<TableRow> children;
  final EdgeInsets? padding;
  final bool stripeRows;
  final Color? stripeColor;

  const DataTableBody({
    super.key,
    required this.children,
    this.padding,
    this.stripeRows = true,
    this.stripeColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<GrafitTheme>()!;

    return Column(
      children: children.asMap().entries.map((entry) {
        final index = entry.key;
        final row = entry.value;

        return Container(
          color: stripeRows && index % 2 == 1
              ? (stripeColor ?? theme.colors.muted.withOpacity(0.2))
              : null,
          child: row,
        );
      }).toList(),
    );
  }
}

/// Table Footer subcomponent
class DataTableFooter extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final double? height;
  final Color? backgroundColor;
  final BoxBorder? border;

  const DataTableFooter({
    super.key,
    required this.child,
    this.padding,
    this.height,
    this.backgroundColor,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<GrafitTheme>()!;

    return Container(
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      height: height,
      decoration: BoxDecoration(
        color: backgroundColor ?? theme.colors.muted.withOpacity(0.3),
        border: border ?? Border(top: BorderSide(color: theme.colors.border)),
      ),
      child: DefaultTextStyle(
        style: TextStyle(
          color: theme.colors.foreground,
          fontWeight: FontWeight.w500,
          fontSize: 14,
        ),
        child: child,
      ),
    );
  }
}

/// Table Row subcomponent
class DataTableRow extends StatelessWidget {
  final List<Widget> children;
  final VoidCallback? onTap;
  final bool selected;
  final bool hover;
  final EdgeInsets? padding;
  final double? height;
  final Color? selectedColor;
  final Color? hoverColor;
  final BoxBorder? border;

  const DataTableRow({
    super.key,
    required this.children,
    this.onTap,
    this.selected = false,
    this.hover = false,
    this.padding,
    this.height,
    this.selectedColor,
    this.hoverColor,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<GrafitTheme>()!;

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: padding,
        height: height,
        decoration: BoxDecoration(
          color: selected
              ? (selectedColor ?? theme.colors.primary.withOpacity(0.1))
              : (hover ? (hoverColor ?? theme.colors.muted.withOpacity(0.3)) : null),
          border: border ?? Border(bottom: BorderSide(color: theme.colors.border)),
        ),
        child: Row(
          children: children,
        ),
      ),
    );
  }
}

/// Table Head subcomponent
class DataTableHead extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  final double height;
  final TextAlign? align;

  const DataTableHead({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    this.height = 56,
    this.align,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<GrafitTheme>()!;

    return Container(
      padding: padding,
      height: height,
      alignment: align == TextAlign.end
          ? Alignment.centerRight
          : (align == TextAlign.center ? Alignment.center : Alignment.centerLeft),
      child: DefaultTextStyle(
        style: TextStyle(
          color: theme.colors.foreground,
          fontWeight: FontWeight.w600,
          fontSize: 14,
          height: 1.5,
        ),
        child: child,
      ),
    );
  }
}

/// Table Cell subcomponent
class DataTableCell extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  final double height;
  final TextAlign? align;

  const DataTableCell({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    this.height = kMinInteractiveDimension,
    this.align,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<GrafitTheme>()!;

    return Container(
      padding: padding,
      height: height,
      alignment: align == TextAlign.end
          ? Alignment.centerRight
          : (align == TextAlign.center ? Alignment.center : Alignment.centerLeft),
      child: DefaultTextStyle(
        style: TextStyle(
          color: theme.colors.foreground,
          fontSize: 14,
          height: 1.5,
        ),
        child: child,
      ),
    );
  }
}

/// Table Caption subcomponent
class DataTableCaption extends StatelessWidget {
  final String text;
  final TextAlign? align;
  final EdgeInsets? padding;
  final Color? color;

  const DataTableCaption({
    super.key,
    required this.text,
    this.align,
    this.padding,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<GrafitTheme>()!;

    return Padding(
      padding: padding ?? const EdgeInsets.only(top: 16),
      child: Text(
        text,
        textAlign: align ?? TextAlign.start,
        style: TextStyle(
          color: color ?? theme.colors.mutedForeground,
          fontSize: 12,
        ),
      ),
    );
  }
}

/// Pagination widget for data table
class DataTablePagination extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final int? totalItems;
  final int itemsPerPage;
  final ValueChanged<int> onPageChanged;
  final bool showFirstLastButtons;
  final bool showItemsPerPageSelector;
  final List<int> itemsPerPageOptions;
  final ValueChanged<int>? onItemsPerPageChanged;

  const DataTablePagination({
    super.key,
    required this.currentPage,
    required this.totalPages,
    this.totalItems,
    required this.itemsPerPage,
    required this.onPageChanged,
    this.showFirstLastButtons = true,
    this.showItemsPerPageSelector = false,
    this.itemsPerPageOptions = const [10, 25, 50, 100],
    this.onItemsPerPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<GrafitTheme>()!;

    return DataTableFooter(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (totalItems != null)
            Text(
              'Showing ${_getRangeText()} of $totalItems items',
              style: TextStyle(
                color: theme.colors.mutedForeground,
                fontSize: 14,
              ),
            ),
          if (totalItems == null) const Spacer(),
          Row(
            children: [
              if (showItemsPerPageSelector && onItemsPerPageChanged != null) ...[
                Text(
                  'Rows per page:',
                  style: TextStyle(
                    color: theme.colors.foreground,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(width: 8),
                DropdownButton<int>(
                  value: itemsPerPage,
                  items: itemsPerPageOptions
                      .map((count) => DropdownMenuItem(
                            value: count,
                            child: Text('$count'),
                          ))
                      .toList(),
                  onChanged: (value) => onItemsPerPageChanged!(value!),
                  underline: const SizedBox.shrink(),
                ),
                const SizedBox(width: 16),
              ],
              if (showFirstLastButtons)
                _buildPageButton(
                  context,
                  icon: Icons.first_page,
                  enabled: currentPage > 0,
                  onPressed: () => onPageChanged(0),
                ),
              _buildPageButton(
                context,
                icon: Icons.chevron_left,
                enabled: currentPage > 0,
                onPressed: () => onPageChanged(currentPage - 1),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Page ${currentPage + 1} of $totalPages',
                  style: TextStyle(
                    color: theme.colors.foreground,
                    fontSize: 14,
                  ),
                ),
              ),
              _buildPageButton(
                context,
                icon: Icons.chevron_right,
                enabled: currentPage < totalPages - 1,
                onPressed: () => onPageChanged(currentPage + 1),
              ),
              if (showFirstLastButtons)
                _buildPageButton(
                  context,
                  icon: Icons.last_page,
                  enabled: currentPage < totalPages - 1,
                  onPressed: () => onPageChanged(totalPages - 1),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPageButton(
    BuildContext context, {
    required IconData icon,
    required bool enabled,
    required VoidCallback onPressed,
  }) {
    return IconButton(
      icon: Icon(icon, size: 20),
      onPressed: enabled ? onPressed : null,
      splashRadius: 20,
      padding: const EdgeInsets.all(4),
    );
  }

  String _getRangeText() {
    if (totalItems == null || totalItems == 0) return '0';
    final start = currentPage * itemsPerPage + 1;
    final end = (start + itemsPerPage - 1).clamp(0, totalItems!);
    return '$start-$end';
  }
}
