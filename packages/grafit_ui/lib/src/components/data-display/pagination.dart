import 'package:flutter/material.dart';
import '../../theme/theme.dart';
import '../../theme/theme_data.dart';
import '../../primitives/clickable.dart';
import '../form/button.dart';

/// Pagination link size
enum GrafitPaginationLinkSize {
  sm,
  icon,
  md,
}

/// Main Pagination navigation widget
///
/// Container for pagination controls with semantic markup for accessibility.
/// Wraps pagination content with proper ARIA labels and centering.
class GrafitPagination extends StatelessWidget {
  final Widget child;
  final MainAxisAlignment alignment;
  final EdgeInsets? padding;

  const GrafitPagination({
    super.key,
    required this.child,
    this.alignment = MainAxisAlignment.center,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'pagination',
      container: true,
      child: Container(
        padding: padding,
        alignment: Alignment.center,
        child: child,
      ),
    );
  }
}

/// Pagination content container
///
/// Flex container that holds all pagination items in a row.
/// Equivalent to the ul element in the original React component.
class GrafitPaginationContent extends StatelessWidget {
  final List<Widget> children;
  final CrossAxisAlignment crossAxisAlignment;
  final double? gap;

  const GrafitPaginationContent({
    super.key,
    required this.children,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.gap,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveGap = gap ?? 4.0;

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: crossAxisAlignment,
      children: _buildChildrenWithSpacing(effectiveGap),
    );
  }

  List<Widget> _buildChildrenWithSpacing(double gap) {
    if (children.isEmpty) return [];

    final result = <Widget>[];
    for (int i = 0; i < children.length; i++) {
      result.add(children[i]);
      if (i < children.length - 1) {
        result.add(SizedBox(width: gap));
      }
    }
    return result;
  }
}

/// Pagination item wrapper
///
/// Individual pagination item container.
/// Equivalent to the li element in the original React component.
class GrafitPaginationItem extends StatelessWidget {
  final Widget child;

  const GrafitPaginationItem({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return child;
  }
}

/// Pagination link button
///
/// Clickable page number or navigation link with active state support.
/// Uses button variants to match the design system.
class GrafitPaginationLink extends StatelessWidget {
  final String? label;
  final Widget? child;
  final VoidCallback? onPressed;
  final bool isActive;
  final GrafitPaginationLinkSize size;
  final bool disabled;

  const GrafitPaginationLink({
    super.key,
    this.label,
    this.child,
    this.onPressed,
    this.isActive = false,
    this.size = GrafitPaginationLinkSize.icon,
    this.disabled = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<GrafitTheme>()!;
    final colors = theme.colors;
    final effectiveDisabled = disabled || onPressed == null;

    final effectiveSize = switch (size) {
      GrafitPaginationLinkSize.sm => GrafitButtonSize.sm,
      GrafitPaginationLinkSize.icon => GrafitButtonSize.icon,
      GrafitPaginationLinkSize.md => GrafitButtonSize.md,
    };

    return Semantics(
      selected: isActive,
      button: true,
      enabled: !effectiveDisabled,
      label: label ?? (isActive ? 'Current page' : 'Go to page'),
      child: GrafitClickable(
        enabled: !effectiveDisabled,
        onTap: onPressed,
        child: _buildContent(context, colors, effectiveSize, effectiveDisabled),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    GrafitColorScheme colors,
    GrafitButtonSize buttonSize,
    bool isDisabled,
  ) {
    final foreground = isDisabled
        ? colors.mutedForeground
        : (isActive ? colors.foreground : colors.foreground);

    final background = isDisabled
        ? colors.muted
        : (isActive
            ? colors.muted.withValues(alpha: 0.5)
            : colors.transparent);

    final decoration = BoxDecoration(
      color: background,
      border: isActive
          ? Border.all(color: colors.input)
          : null,
      borderRadius: BorderRadius.circular(colors.radius * 6),
    );

    final padding = switch (size) {
      GrafitPaginationLinkSize.sm => const EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 4,
        ),
      GrafitPaginationLinkSize.icon => const EdgeInsets.all(8),
      GrafitPaginationLinkSize.md => const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 8,
        ),
    };

    final minWidth = switch (size) {
      GrafitPaginationLinkSize.sm => 32.0,
      GrafitPaginationLinkSize.icon => 36.0,
      GrafitPaginationLinkSize.md => 40.0,
    };

    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      padding: padding,
      constraints: BoxConstraints(
        minWidth: minWidth,
        minHeight: minWidth,
      ),
      decoration: decoration,
      child: DefaultTextStyle(
        style: TextStyle(
          color: foreground,
          fontSize: switch (size) {
            GrafitPaginationLinkSize.sm => 13,
            GrafitPaginationLinkSize.icon => 14,
            GrafitPaginationLinkSize.md => 14,
          },
          fontWeight: isActive ? FontWeight.w500 : FontWeight.w400,
        ),
        child: Center(
          child: child ??
              (label != null
                  ? Text(label!)
                  : const SizedBox.shrink()),
        ),
      ),
    );
  }
}

/// Previous page button
///
/// Navigation button to go to the previous page.
/// Includes icon and optional "Previous" label (hidden on small screens).
class GrafitPaginationPrevious extends StatelessWidget {
  final VoidCallback? onPressed;
  final String? label;
  final bool disabled;
  final bool showLabel;

  const GrafitPaginationPrevious({
    super.key,
    required this.onPressed,
    this.label,
    this.disabled = false,
    this.showLabel = true,
  });

  @override
  Widget build(BuildContext context) {
    return GrafitPaginationItem(
      child: GrafitPaginationLink(
        label: label ?? 'Previous',
        onPressed: onPressed,
        disabled: disabled,
        size: GrafitPaginationLinkSize.md,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.chevron_left,
              size: 16,
            ),
            if (showLabel) ...[
              const SizedBox(width: 4),
              const Text('Previous'),
            ],
          ],
        ),
      ),
    );
  }
}

/// Next page button
///
/// Navigation button to go to the next page.
/// Includes icon and optional "Next" label (hidden on small screens).
class GrafitPaginationNext extends StatelessWidget {
  final VoidCallback? onPressed;
  final String? label;
  final bool disabled;
  final bool showLabel;

  const GrafitPaginationNext({
    super.key,
    required this.onPressed,
    this.label,
    this.disabled = false,
    this.showLabel = true,
  });

  @override
  Widget build(BuildContext context) {
    return GrafitPaginationItem(
      child: GrafitPaginationLink(
        label: label ?? 'Next',
        onPressed: onPressed,
        disabled: disabled,
        size: GrafitPaginationLinkSize.md,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (showLabel) ...[
              const Text('Next'),
              const SizedBox(width: 4),
            ],
            Icon(
              Icons.chevron_right,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}

/// Ellipsis indicator for hidden pages
///
/// Visual indicator that there are more pages between displayed page numbers.
/// Uses a more horizontal icon to represent omitted pages.
class GrafitPaginationEllipsis extends StatelessWidget {
  final String? label;

  const GrafitPaginationEllipsis({
    super.key,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    return GrafitPaginationItem(
      child: Semantics(
        label: label ?? 'More pages',
        child: Container(
          width: 36,
          height: 36,
          alignment: Alignment.center,
          child: const Icon(
            Icons.more_horiz,
            size: 16,
          ),
        ),
      ),
    );
  }
}

/// Complete pagination widget with page state management
///
/// A high-level widget that manages pagination state and renders
/// the appropriate pagination controls including page numbers,
/// navigation buttons, and ellipsis for large page ranges.
class GrafitPaginationWidget extends StatefulWidget {
  final int currentPage;
  final int totalPages;
  final ValueChanged<int>? onPageChanged;
  final bool showFirstLast;
  final bool showPreviousNext;
  final int maxVisiblePages;
  final bool compact;

  const GrafitPaginationWidget({
    super.key,
    required this.currentPage,
    required this.totalPages,
    this.onPageChanged,
    this.showFirstLast = false,
    this.showPreviousNext = true,
    this.maxVisiblePages = 7,
    this.compact = false,
  });

  @override
  State<GrafitPaginationWidget> createState() =>
      _GrafitPaginationWidgetState();
}

class _GrafitPaginationWidgetState extends State<GrafitPaginationWidget> {
  late int _currentPage;

  @override
  void initState() {
    super.initState();
    _currentPage = widget.currentPage;
  }

  @override
  void didUpdateWidget(GrafitPaginationWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.currentPage != oldWidget.currentPage) {
      _currentPage = widget.currentPage;
    }
  }

  void _handlePageChange(int page) {
    if (page >= 0 && page < widget.totalPages && page != _currentPage) {
      setState(() {
        _currentPage = page;
      });
      widget.onPageChanged?.call(page);
    }
  }

  List<int> _getVisiblePages() {
    if (widget.totalPages <= widget.maxVisiblePages) {
      return List.generate(widget.totalPages, (i) => i);
    }

    final pages = <int>[];
    final currentPage = _currentPage;
    final maxVisible = widget.maxVisiblePages;
    final totalPages = widget.totalPages;

    // Always show first page
    pages.add(0);

    // Calculate range around current page
    final start = (currentPage - (maxVisible - 3) ~/ 2).clamp(1, totalPages - maxVisible + 2);
    final end = start + maxVisible - 3;

    // Add ellipsis if needed before range
    if (start > 1) {
      pages.add(-1); // -1 represents ellipsis
    }

    // Add pages in range
    for (int i = start; i <= end && i < totalPages - 1; i++) {
      pages.add(i);
    }

    // Add ellipsis if needed after range
    if (end < totalPages - 2) {
      pages.add(-1); // -1 represents ellipsis
    }

    // Always show last page
    pages.add(totalPages - 1);

    return pages;
  }

  @override
  Widget build(BuildContext context) {
    final pages = _getVisiblePages();

    return GrafitPagination(
      child: GrafitPaginationContent(
        children: [
          // First page button
          if (widget.showFirstLast)
            GrafitPaginationPrevious(
              onPressed: _currentPage > 0 ? () => _handlePageChange(0) : null,
              disabled: _currentPage == 0,
              showLabel: !widget.compact,
            ),

          // Previous page button
          if (widget.showPreviousNext)
            GrafitPaginationPrevious(
              onPressed:
                  _currentPage > 0 ? () => _handlePageChange(_currentPage - 1) : null,
              disabled: _currentPage == 0,
              showLabel: !widget.compact,
            ),

          // Page numbers
          ...pages.map((page) {
            if (page == -1) {
              return const GrafitPaginationEllipsis();
            }
            return GrafitPaginationItem(
              child: GrafitPaginationLink(
                label: '${page + 1}',
                onPressed: () => _handlePageChange(page),
                isActive: page == _currentPage,
                disabled: page == _currentPage,
                size: GrafitPaginationLinkSize.icon,
              ),
            );
          }),

          // Next page button
          if (widget.showPreviousNext)
            GrafitPaginationNext(
              onPressed: _currentPage < widget.totalPages - 1
                  ? () => _handlePageChange(_currentPage + 1)
                  : null,
              disabled: _currentPage == widget.totalPages - 1,
              showLabel: !widget.compact,
            ),

          // Last page button
          if (widget.showFirstLast)
            GrafitPaginationNext(
              onPressed: _currentPage < widget.totalPages - 1
                  ? () => _handlePageChange(widget.totalPages - 1)
                  : null,
              disabled: _currentPage == widget.totalPages - 1,
              showLabel: !widget.compact,
            ),
        ],
      ),
    );
  }
}
