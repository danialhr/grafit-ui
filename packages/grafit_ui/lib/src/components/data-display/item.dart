import 'package:flutter/material.dart';
import '../../theme/theme.dart';
import '../../theme/theme_data.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

/// Item variant
enum GrafitItemVariant {
  default_,
  outline,
  muted,
}

/// Item size
enum GrafitItemSize {
  default_,
  sm,
  lg,
}

/// Item media variant
enum GrafitItemMediaVariant {
  default_,
  icon,
  image,
}

/// Main Item component - A flexible list item component for data display
class GrafitItem extends StatefulWidget {
  final Widget child;
  final GrafitItemVariant variant;
  final GrafitItemSize size;
  final bool disabled;
  final bool selected;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final Color? borderColor;
  final BorderRadius? borderRadius;
  final bool showFocusBorder;

  const GrafitItem({
    super.key,
    required this.child,
    this.variant = GrafitItemVariant.default_,
    this.size = GrafitItemSize.default_,
    this.disabled = false,
    this.selected = false,
    this.onTap,
    this.backgroundColor,
    this.borderColor,
    this.borderRadius,
    this.showFocusBorder = true,
  });

  @override
  State<GrafitItem> createState() => _GrafitItemState();
}

class _GrafitItemState extends State<GrafitItem> {
  bool _isHovered = false;
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<GrafitTheme>()!;
    final colors = theme.colors;

    final itemColors = _getItemColors(colors);

    return MouseRegion(
      onEnter: (_) => !widget.disabled ? setState(() => _isHovered = true) : null,
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.disabled ? null : widget.onTap,
        onTapDown: (_) => !widget.disabled ? setState(() => _isPressed = true) : null,
        onTapUp: (_) => setState(() => _isPressed = false),
        onTapCancel: () => setState(() => _isPressed = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeInOut,
          decoration: BoxDecoration(
            color: widget.disabled
                ? colors.muted.withValues(alpha: 0.3)
                : widget.backgroundColor ?? itemColors.backgroundColor,
            border: Border.all(
              color: widget.borderColor ??
                  (widget.selected
                      ? colors.primary
                      : _isPressed || widget.selected
                          ? colors.ring
                          : itemColors.borderColor),
              width: widget.selected ? 2 : 1,
            ),
            borderRadius: widget.borderRadius ?? BorderRadius.circular(colors.radius * 6),
            boxShadow: widget.selected && widget.showFocusBorder
                ? [
                    BoxShadow(
                      color: colors.ring.withValues(alpha: 0.3),
                      blurRadius: 6,
                      spreadRadius: 0,
                    ),
                  ]
                : null,
          ),
          child: Container(
            padding: _getPadding(),
            child: Opacity(
              opacity: widget.disabled ? 0.5 : 1.0,
              child: widget.child,
            ),
          ),
        ),
      ),
    );
  }

  EdgeInsets _getPadding() {
    return switch (widget.size) {
      GrafitItemSize.sm => const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      GrafitItemSize.lg => const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      GrafitItemSize.default_ => const EdgeInsets.all(16),
    };
  }

  _ItemColors _getItemColors(GrafitColorScheme colors) {
    final backgroundColor = switch (widget.variant) {
      GrafitItemVariant.outline => Colors.transparent,
      GrafitItemVariant.muted => colors.muted.withValues(alpha: 0.5),
      GrafitItemVariant.default_ => Colors.transparent,
    };

    final borderColor = switch (widget.variant) {
      GrafitItemVariant.outline => colors.border,
      GrafitItemVariant.muted => Colors.transparent,
      GrafitItemVariant.default_ => Colors.transparent,
    };

    final hoverColor = switch (widget.variant) {
      GrafitItemVariant.outline => colors.accent.withValues(alpha: 0.3),
      GrafitItemVariant.muted => colors.muted.withValues(alpha: 0.7),
      GrafitItemVariant.default_ => colors.accent.withValues(alpha: 0.5),
    };

    return _ItemColors(
      backgroundColor: _isHovered && !widget.disabled && widget.onTap != null
          ? hoverColor
          : backgroundColor,
      borderColor: borderColor,
    );
  }
}

/// ItemGroup - Container for multiple items
class GrafitItemGroup extends StatelessWidget {
  final List<Widget> children;
  final CrossAxisAlignment crossAxisAlignment;
  final double? spacing;
  final MainAxisSize mainAxisSize;

  const GrafitItemGroup({
    super.key,
    required this.children,
    this.crossAxisAlignment = CrossAxisAlignment.stretch,
    this.spacing,
    this.mainAxisSize = MainAxisSize.min,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveSpacing = spacing ?? 0.0;

    return Column(
      crossAxisAlignment: crossAxisAlignment,
      mainAxisSize: mainAxisSize,
      children: _buildChildren(effectiveSpacing),
    );
  }

  List<Widget> _buildChildren(double spacing) {
    if (children.isEmpty) return [];

    final List<Widget> result = [];
    for (int i = 0; i < children.length; i++) {
      result.add(children[i]);
      if (i < children.length - 1 && spacing > 0) {
        result.add(SizedBox(height: spacing));
      }
    }
    return result;
  }
}

/// ItemMedia - Left side media (icon, image, avatar, etc.)
class GrafitItemMedia extends StatelessWidget {
  final Widget child;
  final GrafitItemMediaVariant variant;
  final double? size;
  final Color? backgroundColor;
  final EdgeInsets? padding;

  const GrafitItemMedia({
    super.key,
    required this.child,
    this.variant = GrafitItemMediaVariant.default_,
    this.size,
    this.backgroundColor,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<GrafitTheme>()!;
    final colors = theme.colors;

    final mediaSize = size ?? _getDefaultSize();
    final mediaPadding = padding ?? _getDefaultPadding();

    Widget mediaChild = child;

    // Apply variant-specific styling
    if (variant == GrafitItemMediaVariant.icon) {
      mediaChild = Container(
        width: mediaSize,
        height: mediaSize,
        padding: mediaPadding,
        decoration: BoxDecoration(
          color: backgroundColor ?? colors.muted,
          borderRadius: BorderRadius.circular(colors.radius * 4),
          border: Border.all(color: colors.border),
        ),
        child: Center(child: child),
      );
    } else if (variant == GrafitItemMediaVariant.image) {
      mediaChild = ClipRRect(
        borderRadius: BorderRadius.circular(colors.radius * 4),
        child: SizedBox(
          width: mediaSize,
          height: mediaSize,
          child: child,
        ),
      );
    } else {
      mediaChild = Padding(
        padding: mediaPadding,
        child: child,
      );
    }

    return Align(
      alignment: Alignment.topCenter,
      child: mediaChild,
    );
  }

  double _getDefaultSize() {
    return switch (variant) {
      GrafitItemMediaVariant.icon => 32,
      GrafitItemMediaVariant.image => 40,
      GrafitItemMediaVariant.default_ => 24,
    };
  }

  EdgeInsets _getDefaultPadding() {
    return switch (variant) {
      GrafitItemMediaVariant.icon => const EdgeInsets.all(6),
      _ => EdgeInsets.zero,
    };
  }
}

/// ItemContent - Main content area with title and description
class GrafitItemContent extends StatelessWidget {
  final Widget child;
  final bool expand;

  const GrafitItemContent({
    super.key,
    required this.child,
    this.expand = true,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: expand ? 1 : 0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          child,
        ],
      ),
    );
  }
}

/// ItemTitle - Title text for the item
class GrafitItemTitle extends StatelessWidget {
  final String title;
  final TextStyle? style;
  final Color? color;
  final int? maxLines;
  final TextOverflow? overflow;
  final Widget? _richChild;

  const GrafitItemTitle({
    super.key,
    required this.title,
    this.style,
    this.color,
    this.maxLines,
    this.overflow,
  }) : _richChild = null;

  /// Constructor for rich content with custom widget
  const GrafitItemTitle.rich({
    super.key,
    required Widget child,
  })  : title = '',
        style = null,
        color = null,
        maxLines = null,
        overflow = null,
        _richChild = child;

  @override
  Widget build(BuildContext context) {
    if (_richChild != null) {
      return DefaultTextStyle.merge(
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        child: _richChild,
      );
    }

    final theme = Theme.of(context).extension<GrafitTheme>()!;
    final colors = theme.colors;

    return Text(
      title,
      style: (style ?? theme.text.bodyMedium).copyWith(
        color: color ?? colors.foreground,
        fontWeight: FontWeight.w500,
        fontSize: 14,
      ),
      maxLines: maxLines ?? 2,
      overflow: overflow ?? TextOverflow.ellipsis,
    );
  }
}

/// ItemDescription - Supporting description text
class GrafitItemDescription extends StatelessWidget {
  final String text;
  final Color? color;
  final int? maxLines;
  final TextOverflow? overflow;
  final Widget? _richChild;

  const GrafitItemDescription({
    super.key,
    required this.text,
    this.color,
    this.maxLines = 2,
    this.overflow,
  }) : _richChild = null;

  /// Constructor for rich content with custom widget
  const GrafitItemDescription.rich({
    super.key,
    required Widget child,
  })  : text = '',
        color = null,
        maxLines = null,
        overflow = null,
        _richChild = child;

  @override
  Widget build(BuildContext context) {
    if (_richChild != null) {
      return Padding(
        padding: const EdgeInsets.only(top: 4),
        child: DefaultTextStyle.merge(
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.normal,
          ),
          child: _richChild,
        ),
      );
    }

    final theme = Theme.of(context).extension<GrafitTheme>()!;
    final colors = theme.colors;

    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Text(
        text,
        style: TextStyle(
          color: color ?? colors.mutedForeground,
          fontSize: 13,
          fontWeight: FontWeight.normal,
        ),
        maxLines: maxLines,
        overflow: overflow ?? TextOverflow.ellipsis,
      ),
    );
  }
}

/// ItemActions - Right side action buttons
class GrafitItemActions extends StatelessWidget {
  final List<Widget> children;
  final double spacing;

  const GrafitItemActions({
    super.key,
    required this.children,
    this.spacing = 8,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: _buildChildren(),
    );
  }

  List<Widget> _buildChildren() {
    final List<Widget> result = [];
    for (int i = 0; i < children.length; i++) {
      result.add(children[i]);
      if (i < children.length - 1) {
        result.add(SizedBox(width: spacing));
      }
    }
    return result;
  }
}

/// ItemHeader - Header section spanning full width
class GrafitItemHeader extends StatelessWidget {
  final Widget child;

  const GrafitItemHeader({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: child,
    );
  }
}

/// ItemFooter - Footer section spanning full width
class GrafitItemFooter extends StatelessWidget {
  final Widget child;

  const GrafitItemFooter({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<GrafitTheme>()!;
    final colors = theme.colors;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 12),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: colors.border, width: 1),
        ),
      ),
      child: child,
    );
  }
}

/// ItemDivider - Divider between items in a group
class GrafitItemDivider extends StatelessWidget {
  final double? thickness;
  final Color? color;
  final double? height;
  final double? indent;
  final double? endIndent;

  const GrafitItemDivider({
    super.key,
    this.thickness,
    this.color,
    this.height,
    this.indent,
    this.endIndent,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<GrafitTheme>()!;
    final colors = theme.colors;

    return Divider(
      thickness: thickness ?? 1,
      color: color ?? colors.border,
      height: height ?? 1,
      indent: indent,
      endIndent: endIndent,
    );
  }
}

/// Helper class for item colors
class _ItemColors {
  final Color backgroundColor;
  final Color borderColor;

  const _ItemColors({
    required this.backgroundColor,
    required this.borderColor,
  });
}

/// Helper widget for creating item with media, content, and actions
class GrafitItemBuilder extends StatelessWidget {
  final GrafitItemVariant variant;
  final GrafitItemSize size;
  final bool disabled;
  final bool selected;
  final VoidCallback? onTap;
  final Widget? media;
  final Widget title;
  final String? description;
  final List<Widget>? actions;
  final Widget? footer;
  final Color? backgroundColor;
  final Color? borderColor;

  const GrafitItemBuilder({
    super.key,
    this.variant = GrafitItemVariant.default_,
    this.size = GrafitItemSize.default_,
    this.disabled = false,
    this.selected = false,
    this.onTap,
    this.media,
    required this.title,
    this.description,
    this.actions,
    this.footer,
    this.backgroundColor,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return GrafitItem(
      variant: variant,
      size: size,
      disabled: disabled,
      selected: selected,
      onTap: onTap,
      backgroundColor: backgroundColor,
      borderColor: borderColor,
      child: Row(
        children: [
          if (media != null) ...[
            media!,
            const SizedBox(width: 16),
          ],
          GrafitItemContent(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                title,
                if (description != null)
                  GrafitItemDescription(text: description!),
              ],
            ),
          ),
          if (actions != null && actions!.isNotEmpty) ...[
            const SizedBox(width: 16),
            GrafitItemActions(children: actions!),
          ],
        ],
      ),
    );
  }
}

// Widgetbook use cases
@widgetbook.UseCase(
  name: 'Default',
  type: GrafitItem,
  path: 'DataDisplay/Item',
)
Widget itemDefault(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.all(16.0),
    child: SizedBox(
      width: 400,
      child: GrafitItem(
        child: Row(
          children: [
            GrafitItemMedia(
              child: Icon(Icons.person),
            ),
            SizedBox(width: 16),
            GrafitItemContent(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GrafitItemTitle(title: 'John Doe'),
                  GrafitItemDescription(text: 'john@example.com'),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'Outline Variant',
  type: GrafitItem,
  path: 'DataDisplay/Item',
)
Widget itemOutline(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.all(16.0),
    child: Column(
      children: [
        SizedBox(
          width: 400,
          child: GrafitItem(
            variant: GrafitItemVariant.outline,
            child: Row(
              children: [
                GrafitItemMedia(child: Icon(Icons.folder)),
                SizedBox(width: 16),
                GrafitItemContent(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GrafitItemTitle(title: 'Project Folder'),
                      GrafitItemDescription(text: 'Contains important documents'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

@widgetbook.UseCase(
  name: 'Muted Variant',
  type: GrafitItem,
  path: 'DataDisplay/Item',
)
Widget itemMuted(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.all(16.0),
    child: SizedBox(
      width: 400,
      child: GrafitItem(
        variant: GrafitItemVariant.muted,
        child: Row(
          children: [
            GrafitItemMedia(child: Icon(Icons.archive)),
            SizedBox(width: 16),
            GrafitItemContent(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GrafitItemTitle(title: 'Archived Items'),
                  GrafitItemDescription(text: 'Older content moved to archive'),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'Selected',
  type: GrafitItem,
  path: 'DataDisplay/Item',
)
Widget itemSelected(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.all(16.0),
    child: Column(
      children: [
        SizedBox(
          width: 400,
          child: GrafitItem(
            child: Row(
              children: [
                GrafitItemMedia(child: Icon(Icons.radio_button_unchecked)),
                SizedBox(width: 16),
                GrafitItemContent(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GrafitItemTitle(title: 'Option 1'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 8),
        SizedBox(
          width: 400,
          child: GrafitItem(
            selected: true,
            child: Row(
              children: [
                GrafitItemMedia(child: Icon(Icons.radio_button_checked)),
                SizedBox(width: 16),
                GrafitItemContent(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GrafitItemTitle(title: 'Option 2'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

@widgetbook.UseCase(
  name: 'With Actions',
  type: GrafitItem,
  path: 'DataDisplay/Item',
)
Widget itemWithActions(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.all(16.0),
    child: SizedBox(
      width: 400,
      child: GrafitItem(
        child: Row(
          children: [
            GrafitItemMedia(child: Icon(Icons.image)),
            SizedBox(width: 16),
            Expanded(
              child: GrafitItemContent(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GrafitItemTitle(title: 'Photo 1'),
                    GrafitItemDescription(text: 'Added on Jan 15, 2024'),
                  ],
                ),
              ),
            ),
            GrafitItemActions(
              actions: [
                Icon(Icons.edit, size: 18),
                Icon(Icons.delete, size: 18),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'Item Sizes',
  type: GrafitItem,
  path: 'DataDisplay/Item',
)
Widget itemSizes(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.all(16.0),
    child: Column(
      children: [
        SizedBox(
          width: 400,
          child: GrafitItem(
            size: GrafitItemSize.sm,
            child: Row(
              children: [
                GrafitItemMedia(child: Icon(Icons.person, size: 16)),
                SizedBox(width: 12),
                GrafitItemContent(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GrafitItemTitle(title: 'Small Item'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 8),
        SizedBox(
          width: 400,
          child: GrafitItem(
            size: GrafitItemSize.default_,
            child: Row(
              children: [
                GrafitItemMedia(child: Icon(Icons.person, size: 24)),
                SizedBox(width: 16),
                GrafitItemContent(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GrafitItemTitle(title: 'Default Item'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 8),
        SizedBox(
          width: 400,
          child: GrafitItem(
            size: GrafitItemSize.lg,
            child: Row(
              children: [
                GrafitItemMedia(child: Icon(Icons.person, size: 32)),
                SizedBox(width: 20),
                GrafitItemContent(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GrafitItemTitle(title: 'Large Item'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

@widgetbook.UseCase(
  name: 'Item List',
  type: GrafitItemGroup,
  path: 'DataDisplay/Item',
)
Widget itemList(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.all(16.0),
    child: SizedBox(
      width: 400,
      child: GrafitItemGroup(
        spacing: 0,
        children: [
          GrafitItem(
            child: Row(
              children: [
                GrafitItemMedia(child: Icon(Icons.mail)),
                SizedBox(width: 16),
                GrafitItemContent(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GrafitItemTitle(title: 'Email from John'),
                      GrafitItemDescription(text: 'Hey, how are you doing?'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 56, right: 16),
            child: GrafitItemDivider(),
          ),
          GrafitItem(
            child: Row(
              children: [
                GrafitItemMedia(child: Icon(Icons.mail)),
                SizedBox(width: 16),
                GrafitItemContent(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GrafitItemTitle(title: 'Email from Jane'),
                      GrafitItemDescription(text: 'Meeting at 3pm tomorrow'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 56, right: 16),
            child: GrafitItemDivider(),
          ),
          GrafitItem(
            child: Row(
              children: [
                GrafitItemMedia(child: Icon(Icons.mail)),
                SizedBox(width: 16),
                GrafitItemContent(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GrafitItemTitle(title: 'Email from Bob'),
                      GrafitItemDescription(text: 'Project update attached'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'Disabled',
  type: GrafitItem,
  path: 'DataDisplay/Item',
)
Widget itemDisabled(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.all(16.0),
    child: Column(
      children: [
        SizedBox(
          width: 400,
          child: GrafitItem(
            child: Row(
              children: [
                GrafitItemMedia(child: Icon(Icons.check_circle)),
                SizedBox(width: 16),
                GrafitItemContent(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GrafitItemTitle(title: 'Available Item'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 8),
        SizedBox(
          width: 400,
          child: GrafitItem(
            disabled: true,
            child: Row(
              children: [
                GrafitItemMedia(child: Icon(Icons.block)),
                SizedBox(width: 16),
                GrafitItemContent(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GrafitItemTitle(title: 'Disabled Item'),
                      GrafitItemDescription(text: 'This item is not available'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

@widgetbook.UseCase(
  name: 'Interactive',
  type: GrafitItem,
  path: 'DataDisplay/Item',
)
Widget itemInteractive(BuildContext context) {
  // Widgetbook-only: ignore undefined_getter, undefined_method, invalid_annotation_value
  final variant = context.knobs.list(
    label: 'Variant',
    initialOption: GrafitItemVariant.default_,
    options: [
      GrafitItemVariant.default_,
      GrafitItemVariant.outline,
      GrafitItemVariant.muted,
    ],
  );
  // Widgetbook-only: ignore undefined_getter, undefined_method, invalid_annotation_value
  final size = context.knobs.list(
    label: 'Size',
    initialOption: GrafitItemSize.default_,
    options: [
      GrafitItemSize.sm,
      GrafitItemSize.default_,
      GrafitItemSize.lg,
    ],
  );
  // Widgetbook-only: ignore undefined_getter, undefined_method, invalid_annotation_value
  final selected = context.knobs.boolean(
    label: 'Selected',
    initialValue: false,
  );
  // Widgetbook-only: ignore undefined_getter, undefined_method, invalid_annotation_value
  final disabled = context.knobs.boolean(
    label: 'Disabled',
    initialValue: false,
  );

  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: SizedBox(
      width: 400,
      child: GrafitItem(
        variant: variant,
        size: size,
        selected: selected,
        disabled: disabled,
        child: Row(
          children: [
            GrafitItemMedia(child: Icon(Icons.person)),
            SizedBox(width: 16),
            GrafitItemContent(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GrafitItemTitle(title: 'John Doe'),
                  GrafitItemDescription(text: 'john@example.com'),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
