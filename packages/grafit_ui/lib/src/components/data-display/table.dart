import 'package:flutter/material.dart';
import '../../theme/theme.dart';

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
