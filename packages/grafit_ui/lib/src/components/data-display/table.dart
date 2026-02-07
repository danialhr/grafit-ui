import 'package:flutter/material.dart';
import '../../theme/theme.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

/// Alignment options for table cells and headers
enum GrafitTableAlignment {
  left,
  center,
  right,
}

/// Interface for table rows that can be converted to TableRow
abstract class GrafitTableRowLike {
  TableRow toTableRow(BuildContext context);
}

/// Table component - A container for tabular data with horizontal scrolling
///
/// The main table component that wraps a Table widget with overflow handling
/// and theming support. Provides a container with horizontal scroll capability.
class GrafitTable extends StatelessWidget {
  /// Table caption text (displayed above the table)
  final String? caption;

  /// Whether to show the caption at the bottom instead of top
  final bool captionBottom;

  /// Border width for the table
  final double? borderWidth;

  /// Whether to show borders between rows
  final bool showRowBorders;

  /// Whether to show horizontal borders
  final bool showHorizontalBorders;

  /// Whether to show vertical borders
  final bool showVerticalBorders;

  /// Header rows as widgets (should contain TableRow children)
  final List<Widget>? header;

  /// Data rows as widgets (should contain TableRow children)
  final List<Widget> rows;

  /// Footer row
  final Widget? footer;

  /// Column configuration
  final int columnCount;

  /// Optional horizontal margin
  final EdgeInsetsGeometry? padding;

  /// Background color for the table container
  final Color? backgroundColor;

  const GrafitTable({
    super.key,
    this.caption,
    this.captionBottom = false,
    this.borderWidth,
    this.showRowBorders = true,
    this.showHorizontalBorders = true,
    this.showVerticalBorders = false,
    this.header,
    required this.rows,
    this.footer,
    required this.columnCount,
    this.padding,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<GrafitTheme>()!;
    final colors = theme.colors;

    final border = TableBorder(
      horizontalInside: showHorizontalBorders
          ? BorderSide(
              color: colors.border,
              width: borderWidth ?? 1.0,
            )
          : BorderSide.none,
      verticalInside: showVerticalBorders
          ? BorderSide(
              color: colors.border,
              width: borderWidth ?? 1.0,
            )
          : BorderSide.none,
      bottom: showRowBorder && rows.isNotEmpty
          ? BorderSide(
              color: colors.border,
              width: borderWidth ?? 1.0,
            )
          : BorderSide.none,
      top: BorderSide.none,
      left: BorderSide.none,
      right: BorderSide.none,
    );

    final table = Table(
      border: border,
      columnWidths: _buildColumnWidths(),
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: _buildTableRows(context),
    );

    final tableContent = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (caption != null && !captionBottom)
          GrafitTableCaption(
            text: caption!,
          ),
        Flexible(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const AlwaysScrollableScrollPhysics(),
            child: Container(
              padding: padding,
              color: backgroundColor,
              child: table,
            ),
          ),
        ),
        if (caption != null && captionBottom)
          GrafitTableCaption(
            text: caption!,
          ),
      ],
    );

    return tableContent;
  }

  bool get showRowBorder => showRowBorders;

  List<TableRow> _buildTableRows(BuildContext context) {
    final List<TableRow> tableRows = [];

    if (header != null) {
      for (final w in header!) {
        tableRows.add(_asTableRow(w, context));
      }
    }

    for (final w in rows) {
      tableRows.add(_asTableRow(w, context));
    }

    if (footer != null) {
      tableRows.add(_asTableRow(footer!, context));
    }

    return tableRows;
  }

  TableRow _asTableRow(Widget widget, BuildContext context) {
    if (widget is TableRow) return widget as TableRow;
    if (widget is GrafitTableRowLike) {
      final row = widget as GrafitTableRowLike;
      return row.toTableRow(context);
    }
    return TableRow(children: [widget]);
  }

  Map<int, TableColumnWidth> _buildColumnWidths() {
    final Map<int, TableColumnWidth> widths = {};
    for (int i = 0; i < columnCount; i++) {
      widths[i] = const FlexColumnWidth();
    }
    return widths;
  }
}

/// Table header row component
///
/// Creates a styled header row with border bottom
class GrafitTableHeader implements GrafitTableRowLike {
  /// The cells in this header row
  final List<Widget> children;

  /// Background color for the header
  final Color? backgroundColor;

  /// Text style for header cells
  final TextStyle? textStyle;

  const GrafitTableHeader({
    required this.children,
    this.backgroundColor,
    this.textStyle,
  });

  @override
  TableRow toTableRow(BuildContext context) {
    final theme = Theme.of(context).extension<GrafitTheme>()!;
    final colors = theme.colors;

    return TableRow(
      decoration: BoxDecoration(
        color: backgroundColor ?? colors.muted.withValues(alpha: 0.3),
        border: Border(
          bottom: BorderSide(
            color: colors.border,
            width: 1.0,
          ),
        ),
      ),
      children: children,
    );
  }
}

/// Table body component
///
/// Container for data rows with special styling for the last row
class GrafitTableBody extends StatelessWidget {
  /// The rows in the body
  final List<Widget> children;

  const GrafitTableBody({
    super.key,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: children,
    );
  }
}

/// Table footer component
///
/// Creates a styled footer with background and top border
class GrafitTableFooter implements GrafitTableRowLike {
  /// The cells in this footer row
  final List<Widget> children;

  /// Background color for the footer
  final Color? backgroundColor;

  const GrafitTableFooter({
    required this.children,
    this.backgroundColor,
  });

  @override
  TableRow toTableRow(BuildContext context) {
    final theme = Theme.of(context).extension<GrafitTheme>()!;
    final colors = theme.colors;

    return TableRow(
      decoration: BoxDecoration(
        color: backgroundColor ?? colors.muted.withValues(alpha: 0.5),
        border: Border(
          top: BorderSide(
            color: colors.border,
            width: 1.0,
          ),
        ),
      ),
      children: children,
    );
  }
}

/// Table row component
///
/// Creates a styled row with hover effect and border bottom
class GrafitTableRow implements GrafitTableRowLike {
  /// The cells in this row
  final List<Widget> children;

  /// Whether this row is selected
  final bool selected;

  /// Custom hover color
  final Color? hoverColor;

  /// Border bottom color
  final Color? borderColor;

  /// Callback when row is tapped
  final VoidCallback? onTap;

  const GrafitTableRow({
    required this.children,
    this.selected = false,
    this.hoverColor,
    this.borderColor,
    this.onTap,
  });

  @override
  TableRow toTableRow(BuildContext context) {
    final theme = Theme.of(context).extension<GrafitTheme>()!;
    final colors = theme.colors;

    return TableRow(
      decoration: BoxDecoration(
        color: selected
            ? colors.muted.withValues(alpha: 0.5)
            : null,
        border: Border(
          bottom: BorderSide(
            color: borderColor ?? colors.border,
            width: 1.0,
          ),
        ),
      ),
      children: children,
    );
  }
}

/// Table head cell component
///
/// Creates a styled header cell with text alignment and padding
class GrafitTableHead extends StatelessWidget {
  /// The content of the header cell
  final Widget child;

  /// Text alignment
  final GrafitTableAlignment alignment;

  /// Custom padding
  final EdgeInsetsGeometry? padding;

  /// Text style
  final TextStyle? textStyle;

  const GrafitTableHead({
    super.key,
    required this.child,
    this.alignment = GrafitTableAlignment.left,
    this.padding,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<GrafitTheme>()!;
    final colors = theme.colors;

    final defaultTextStyle = TextStyle(
      color: colors.foreground,
      fontSize: 14,
      fontWeight: FontWeight.w500,
    );

    final alignedChild = child;

    return Container(
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      alignment: _getAlignment(),
      child: DefaultTextStyle(
        style: defaultTextStyle.merge(textStyle),
        child: alignedChild,
      ),
    );
  }

  Alignment _getAlignment() {
    return switch (alignment) {
      GrafitTableAlignment.left => Alignment.centerLeft,
      GrafitTableAlignment.center => Alignment.center,
      GrafitTableAlignment.right => Alignment.centerRight,
    };
  }
}

/// Table cell component
///
/// Creates a styled data cell with text alignment and padding
class GrafitTableCell extends StatelessWidget {
  /// The content of the cell
  final Widget child;

  /// Text alignment
  final GrafitTableAlignment alignment;

  /// Custom padding
  final EdgeInsetsGeometry? padding;

  /// Text style
  final TextStyle? textStyle;

  /// Whether to prevent text wrapping
  final bool nowrap;

  const GrafitTableCell({
    super.key,
    required this.child,
    this.alignment = GrafitTableAlignment.left,
    this.padding,
    this.textStyle,
    this.nowrap = false,
  });

  @override
  Widget build(BuildContext context) {
    final alignedChild = DefaultTextStyle(
      style: textStyle ?? const TextStyle(),
      child: child,
    );

    return Container(
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      alignment: _getAlignment(),
      child: nowrap
          ? FittedBox(child: alignedChild)
          : alignedChild,
    );
  }

  Alignment _getAlignment() {
    return switch (alignment) {
      GrafitTableAlignment.left => Alignment.centerLeft,
      GrafitTableAlignment.center => Alignment.center,
      GrafitTableAlignment.right => Alignment.centerRight,
    };
  }
}

/// Table caption component
///
/// Creates a styled caption for the table
class GrafitTableCaption extends StatelessWidget {
  /// The caption text
  final String text;

  /// Whether to position at bottom
  final bool isBottom;

  /// Text style
  final TextStyle? textStyle;

  /// Alignment
  final TextAlign textAlign;

  const GrafitTableCaption({
    super.key,
    required this.text,
    this.isBottom = false,
    this.textStyle,
    this.textAlign = TextAlign.left,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<GrafitTheme>()!;
    final colors = theme.colors;

    final defaultTextStyle = TextStyle(
      color: colors.mutedForeground,
      fontSize: 12,
    );

    return Padding(
      padding: isBottom
          ? const EdgeInsets.only(top: 16)
          : const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: defaultTextStyle.merge(textStyle),
        textAlign: textAlign,
      ),
    );
  }
}

/// Builder class for creating table rows with hover state
class GrafitTableRowBuilder {
  final List<Widget> cells;
  final bool selected;
  final Color? hoverColor;
  final Color? borderColor;
  final VoidCallback? onTap;

  GrafitTableRowBuilder({
    required this.cells,
    this.selected = false,
    this.hoverColor,
    this.borderColor,
    this.onTap,
  });

  GrafitTableRow build() {
    return GrafitTableRow(
      children: cells,
      selected: selected,
      hoverColor: hoverColor,
      borderColor: borderColor,
      onTap: onTap,
    );
  }
}

/// Extension for easy creation of table cells
extension GrafitTableCellExtension on Widget {
  GrafitTableCell toTableCell({
    GrafitTableAlignment alignment = GrafitTableAlignment.left,
    EdgeInsetsGeometry? padding,
    TextStyle? textStyle,
    bool nowrap = false,
  }) {
    return GrafitTableCell(
      child: this,
      alignment: alignment,
      padding: padding,
      textStyle: textStyle,
      nowrap: nowrap,
    );
  }
}

/// Extension for easy creation of table head cells
extension GrafitTableHeadExtension on Widget {
  GrafitTableHead toTableHead({
    GrafitTableAlignment alignment = GrafitTableAlignment.left,
    EdgeInsetsGeometry? padding,
    TextStyle? textStyle,
  }) {
    return GrafitTableHead(
      child: this,
      alignment: alignment,
      padding: padding,
      textStyle: textStyle,
    );
  }
}

// Widgetbook use cases
@widgetbook.UseCase(
  name: 'Basic Table',
  type: GrafitTable,
  path: 'DataDisplay/Table',
)
Widget tableBasic(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.all(16.0),
    child: SizedBox(
      width: 600,
      child: GrafitTable(
        columnCount: 3,
        rows: [
          TableRow(
            children: [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('John Doe'),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('john@example.com'),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Active'),
              ),
            ],
          ),
          TableRow(
            children: [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Jane Smith'),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('jane@example.com'),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Inactive'),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'With Header',
  type: GrafitTable,
  path: 'DataDisplay/Table',
)
Widget tableWithHeader(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: SizedBox(
      width: 600,
      child: GrafitTable(
        columnCount: 4,
        header: [
          GrafitTableHeader(
            children: [
              GrafitTableHead(child: Text('Name')),
              GrafitTableHead(child: Text('Email')),
              GrafitTableHead(child: Text('Status')),
              GrafitTableHead(alignment: GrafitTableAlignment.right, child: Text('Actions')),
            ],
          ),
        ],
        rows: [
          GrafitTableRow(
            children: [
              GrafitTableCell(child: Text('John Doe')),
              GrafitTableCell(child: Text('john@example.com')),
              GrafitTableCell(child: Text('Active')),
              GrafitTableCell(
                alignment: GrafitTableAlignment.right,
                child: Text('Edit'),
              ),
            ],
          ),
          GrafitTableRow(
            children: [
              GrafitTableCell(child: Text('Jane Smith')),
              GrafitTableCell(child: Text('jane@example.com')),
              GrafitTableCell(child: Text('Inactive')),
              GrafitTableCell(
                alignment: GrafitTableAlignment.right,
                child: Text('Edit'),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'With Caption',
  type: GrafitTable,
  path: 'DataDisplay/Table',
)
Widget tableWithCaption(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: SizedBox(
      width: 600,
      child: GrafitTable(
        caption: 'User Accounts',
        columnCount: 4,
        header: [
          GrafitTableHeader(
            children: [
              GrafitTableHead(child: Text('Name')),
              GrafitTableHead(child: Text('Email')),
              GrafitTableHead(child: Text('Role')),
              GrafitTableHead(child: Text('Status')),
            ],
          ),
        ],
        rows: [
          GrafitTableRow(
            children: [
              GrafitTableCell(child: Text('John Doe')),
              GrafitTableCell(child: Text('john@example.com')),
              GrafitTableCell(child: Text('Admin')),
              GrafitTableCell(child: Text('Active')),
            ],
          ),
        ],
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'With Footer',
  type: GrafitTable,
  path: 'DataDisplay/Table',
)
Widget tableWithFooter(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: SizedBox(
      width: 600,
      child: GrafitTable(
        columnCount: 3,
        header: [
          GrafitTableHeader(
            children: [
              GrafitTableHead(child: Text('Product')),
              GrafitTableHead(child: Text('Price')),
              GrafitTableHead(child: Text('Qty')),
            ],
          ),
        ],
        rows: [
          GrafitTableRow(
            children: [
              GrafitTableCell(child: Text('Widget A')),
              GrafitTableCell(child: Text('\$10.00')),
              GrafitTableCell(child: Text('5')),
            ],
          ),
          GrafitTableRow(
            children: [
              GrafitTableCell(child: Text('Widget B')),
              GrafitTableCell(child: Text('\$15.00')),
              GrafitTableCell(child: Text('3')),
            ],
          ),
        ],
        footer: GrafitTableFooter(
          children: [
            GrafitTableCell(child: Text('Total')),
            GrafitTableCell(child: Text('\$95.00')),
            GrafitTableCell(child: Text('8')),
          ],
        ),
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'Borders',
  type: GrafitTable,
  path: 'DataDisplay/Table',
)
Widget tableBorders(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: Column(
      children: [
        const Text('Horizontal Only'),
        const SizedBox(height: 8),
        SizedBox(
          width: 400,
          child: GrafitTable(
            columnCount: 2,
            showHorizontalBorders: true,
            showVerticalBorders: false,
            rows: const [
              TableRow(
                children: [
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('Cell 1'),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('Cell 2'),
                  ),
                ],
              ),
              TableRow(
                children: [
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('Cell 3'),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('Cell 4'),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        const Text('Both Horizontal and Vertical'),
        const SizedBox(height: 8),
        SizedBox(
          width: 400,
          child: GrafitTable(
            columnCount: 2,
            showHorizontalBorders: true,
            showVerticalBorders: true,
            rows: const [
              TableRow(
                children: [
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('Cell 1'),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('Cell 2'),
                  ),
                ],
              ),
              TableRow(
                children: [
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('Cell 3'),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('Cell 4'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

@widgetbook.UseCase(
  name: 'Selected Row',
  type: GrafitTable,
  path: 'DataDisplay/Table',
)
Widget tableSelectedRow(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: SizedBox(
      width: 500,
      child: GrafitTable(
        columnCount: 3,
        header: [
          GrafitTableHeader(
            children: [
              GrafitTableHead(child: Text('Name')),
              GrafitTableHead(child: Text('Email')),
              GrafitTableHead(child: Text('Status')),
            ],
          ),
        ],
        rows: [
          GrafitTableRow(
            children: [
              GrafitTableCell(child: Text('John Doe')),
              GrafitTableCell(child: Text('john@example.com')),
              GrafitTableCell(child: Text('Active')),
            ],
          ),
          GrafitTableRow(
            selected: true,
            children: [
              GrafitTableCell(child: Text('Jane Smith')),
              GrafitTableCell(child: Text('jane@example.com')),
              GrafitTableCell(child: Text('Active')),
            ],
          ),
          GrafitTableRow(
            children: [
              GrafitTableCell(child: Text('Bob Johnson')),
              GrafitTableCell(child: Text('bob@example.com')),
              GrafitTableCell(child: Text('Inactive')),
            ],
          ),
        ],
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'Cell Alignment',
  type: GrafitTable,
  path: 'DataDisplay/Table',
)
Widget tableCellAlignment(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: SizedBox(
      width: 500,
      child: GrafitTable(
        columnCount: 3,
        header: [
          GrafitTableHeader(
            children: [
              GrafitTableHead(child: Text('Left')),
              GrafitTableHead(alignment: GrafitTableAlignment.center, child: Text('Center')),
              GrafitTableHead(alignment: GrafitTableAlignment.right, child: Text('Right')),
            ],
          ),
        ],
        rows: [
          GrafitTableRow(
            children: [
              GrafitTableCell(alignment: GrafitTableAlignment.left, child: Text('Left')),
              GrafitTableCell(alignment: GrafitTableAlignment.center, child: Text('Center')),
              GrafitTableCell(alignment: GrafitTableAlignment.right, child: Text('Right')),
            ],
          ),
        ],
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'Interactive',
  type: GrafitTable,
  path: 'DataDisplay/Table',
)
Widget tableInteractive(BuildContext context) {
  // Widgetbook-only: ignore undefined_getter, undefined_method, invalid_annotation_value
  final showBorders = context.knobs.boolean(
    label: 'Show Borders',
    initialValue: true,
  );
  // Widgetbook-only: ignore undefined_getter, undefined_method, invalid_annotation_value
  final showVertical = context.knobs.boolean(
    label: 'Show Vertical Borders',
    initialValue: false,
  );
  // Widgetbook-only: ignore undefined_getter, undefined_method, invalid_annotation_value
  final hasCaption = context.knobs.boolean(
    label: 'Show Caption',
    initialValue: false,
  );
  // Widgetbook-only: ignore undefined_getter, undefined_method, invalid_annotation_value
  final caption = context.knobs.string(
    label: 'Caption Text',
    initialValue: 'Data Table',
  );

  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: SizedBox(
      width: 500,
      child: GrafitTable(
        caption: hasCaption ? caption : null,
        columnCount: 3,
        showHorizontalBorders: showBorders,
        showVerticalBorders: showVertical,
        header: [
          GrafitTableHeader(
            children: [
              GrafitTableHead(child: Text('Name')),
              GrafitTableHead(child: Text('Email')),
              GrafitTableHead(child: Text('Status')),
            ],
          ),
        ],
        rows: [
          GrafitTableRow(
            children: [
              GrafitTableCell(child: Text('John Doe')),
              GrafitTableCell(child: Text('john@example.com')),
              GrafitTableCell(child: Text('Active')),
            ],
          ),
          GrafitTableRow(
            selected: true,
            children: [
              GrafitTableCell(child: Text('Jane Smith')),
              GrafitTableCell(child: Text('jane@example.com')),
              GrafitTableCell(child: Text('Active')),
            ],
          ),
        ],
      ),
    ),
  );
}
