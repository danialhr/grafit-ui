import 'package:flutter/material.dart';
import '../../theme/theme.dart';

/// BreadcrumbItem - individual breadcrumb item
class GrafitBreadcrumbItem {
  final Widget? child;
  final bool isPage;
  final bool isActive;

  const GrafitBreadcrumbItem({
    this.child,
    this.isPage = false,
    this.isActive = false,
  });
}

/// Breadcrumb - navigation breadcrumb trail
class GrafitBreadcrumb extends StatelessWidget {
  final List<GrafitBreadcrumbItem> items;
  final Widget? separator;
  final bool ellipsis;

  const GrafitBreadcrumb({
    super.key,
    required this.items,
    this.separator,
    this.ellipsis = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<GrafitTheme>()!;
    final colors = theme.colors;

    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: _buildItems(colors),
    );
  }

  List<Widget> _buildItems(GrafitColorScheme colors) {
    final widgets = <Widget>[];

    for (int i = 0; i < items.length; i++) {
      final item = items[i];

      // Add item
      if (item.child != null) {
        widgets.add(
          DefaultTextStyle(
            style: TextStyle(
              color: item.isPage || item.isActive
                  ? colors.foreground
                  : colors.mutedForeground,
              fontSize: 14,
              fontWeight: item.isPage ? FontWeight.normal : FontWeight.w500,
            ),
            child: item.child!,
          ),
        );
      }

      // Add separator (except for last item)
      if (i < items.length - 1) {
        if (separator != null) {
          widgets.add(
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: separator!,
            ),
          );
        } else {
          widgets.add(
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: Icon(
                Icons.chevron_right,
                size: 14,
                color: colors.mutedForeground,
              ),
            ),
          );
        }
      }
    }

    return widgets;
  }
}

/// BreadcrumbLink - clickable breadcrumb item
class GrafitBreadcrumbLink extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final bool isActive;

  const GrafitBreadcrumbLink({
    super.key,
    required this.label,
    this.onTap,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<GrafitTheme>()!;
    final colors = theme.colors;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(colors.radius * 2),
      hoverColor: colors.muted.withOpacity(0.3),
      onTap: () {
        if (onTap != null) {
          onTap!();
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        child: Text(
          label,
          style: TextStyle(
            color: isActive
                ? colors.foreground
                : colors.mutedForeground,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

/// BreadcrumbPage - current page breadcrumb (non-clickable)
class GrafitBreadcrumbPage extends StatelessWidget {
  final String label;
  final bool isActive;

  const GrafitBreadcrumbPage({
    super.key,
    required this.label,
    this.isActive = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<GrafitTheme>()!;
    final colors = theme.colors;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      child: Text(
        label,
        style: TextStyle(
          color: isActive ? colors.foreground : colors.mutedForeground,
          fontSize: 14,
          fontWeight: FontWeight.normal,
        ),
      ),
    );
  }
}

/// BreadcrumbEllipsis - collapsed breadcrumb indicator
class GrafitBreadcrumbEllipsis extends StatelessWidget {
  final VoidCallback? onTap;

  const GrafitBreadcrumbEllipsis({
    super.key,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<GrafitTheme>()!;
    final colors = theme.colors;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(colors.radius * 4),
      hoverColor: colors.muted.withOpacity(0.3),
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: colors.muted.withOpacity(0.5),
          borderRadius: BorderRadius.circular(colors.radius * 4),
        ),
        child: const Icon(
          Icons.more_horiz,
          size: 18,
          color: Colors.white54,
        ),
      ),
    );
  }
}

/// BreadcrumbSeparator - custom separator between items
class GrafitBreadcrumbSeparator extends StatelessWidget {
  final Widget? child;

  const GrafitBreadcrumbSeparator({
    super.key,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<GrafitTheme>()!;
    final colors = theme.colors;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: child ??
          Icon(
            Icons.chevron_right,
            size: 14,
            color: colors.mutedForeground,
          ),
    );
  }
}

/// Helper class to create breadcrumb items from routes
class GrafitBreadcrumbRoute {
  final String label;
  final String? path;
  final bool isCurrent;

  const GrafitBreadcrumbRoute({
    required this.label,
    this.path,
    this.isCurrent = false,
  });

  GrafitBreadcrumbRoute copyWith({String? label, String? path, bool? isCurrent}) {
    return GrafitBreadcrumbRoute(
      label: label ?? this.label,
      path: path ?? this.path,
      isCurrent: isCurrent ?? this.isCurrent,
    );
  }
}
