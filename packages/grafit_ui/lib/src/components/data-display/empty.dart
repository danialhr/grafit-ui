import 'package:flutter/material.dart';
import '../../theme/theme.dart';
import '../../theme/theme_data.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

/// Empty media variant
enum GrafitEmptyMediaVariant {
  /// Default transparent background
  defaultVariant,

  /// Icon style with muted background
  icon,
}

/// Main Empty widget for displaying empty states
///
/// GrafitEmpty is a flexible component for displaying empty states with
/// customizable content including icons, images, titles, descriptions,
/// and action buttons.
class GrafitEmpty extends StatelessWidget {
  /// Header section containing title, description, and media
  final Widget? header;

  /// Main content section
  final Widget? content;

  /// Footer section for action buttons
  final Widget? footer;

  /// Custom padding
  final EdgeInsetsGeometry? padding;

  /// Custom background color
  final Color? backgroundColor;

  /// Border customization
  final BoxBorder? border;

  /// Border radius
  final BorderRadius? borderRadius;

  /// Gap between children
  final double gap;

  /// Main axis size
  final MainAxisSize mainAxisSize;

  const GrafitEmpty({
    super.key,
    this.header,
    this.content,
    this.footer,
    this.padding,
    this.backgroundColor,
    this.border,
    this.borderRadius,
    this.gap = 24,
    this.mainAxisSize = MainAxisSize.max,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<GrafitTheme>()!;
    final colors = theme.colors;

    return Container(
      padding: padding ??
          const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 48,
          ),
      decoration: BoxDecoration(
        color: backgroundColor ?? colors.background,
        border: border ??
            Border.all(
              color: colors.border,
              width: 1,
              style: BorderStyle.solid,
            ),
        borderRadius: borderRadius ?? BorderRadius.circular(colors.radius * 6),
      ),
      child: Column(
        mainAxisSize: mainAxisSize,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (header != null) header!,
          if (content != null)
            Padding(
              padding: header != null ? const EdgeInsets.only(top: 16) : EdgeInsets.zero,
              child: content!,
            ),
          if (footer != null)
            Padding(
              padding: (header != null || content != null)
                  ? const EdgeInsets.only(top: 16)
                  : EdgeInsets.zero,
              child: footer!,
            ),
        ],
      ),
    );
  }
}

/// EmptyHeader subcomponent
///
/// Container for the main empty state content including media, title, and description.
/// Provides centered layout with constrained max width for better readability.
class EmptyHeader extends StatelessWidget {
  /// The header content
  final Widget child;

  /// Custom padding
  final EdgeInsetsGeometry? padding;

  /// Maximum width constraint
  final double? maxWidth;

  /// Alignment of children
  final CrossAxisAlignment crossAxisAlignment;

  /// Gap between children
  final double gap;

  const EmptyHeader({
    super.key,
    required this.child,
    this.padding,
    this.maxWidth = 400,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.gap = 8,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: maxWidth != null
          ? BoxConstraints(maxWidth: maxWidth!)
          : null,
      padding: padding ?? EdgeInsets.zero,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: crossAxisAlignment,
        children: [child],
      ),
    );
  }
}

/// EmptyMedia subcomponent
///
/// Displays an icon or image for the empty state. Supports different variants
/// for styling (default transparent or icon with background).
class EmptyMedia extends StatelessWidget {
  /// The media content (icon or image widget)
  final Widget child;

  /// Variant styling
  final GrafitEmptyMediaVariant variant;

  /// Custom padding
  final EdgeInsetsGeometry? padding;

  /// Custom background color (overrides variant default)
  final Color? backgroundColor;

  /// Custom size for icon variant
  final double? iconSize;

  /// Custom border radius for icon variant
  final BorderRadius? borderRadius;

  const EmptyMedia({
    super.key,
    required this.child,
    this.variant = GrafitEmptyMediaVariant.defaultVariant,
    this.padding,
    this.backgroundColor,
    this.iconSize,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<GrafitTheme>()!;
    final colors = theme.colors;

    final defaultBgColor = variant == GrafitEmptyMediaVariant.icon
        ? colors.muted
        : Colors.transparent;

    final defaultRadius = variant == GrafitEmptyMediaVariant.icon
        ? BorderRadius.circular(colors.radius * 6)
        : null;

    final defaultPadding = variant == GrafitEmptyMediaVariant.icon
        ? const EdgeInsets.all(16)
        : const EdgeInsets.only(bottom: 8);

    return Container(
      padding: padding ?? defaultPadding,
      decoration: BoxDecoration(
        color: backgroundColor ?? defaultBgColor,
        borderRadius: borderRadius ?? defaultRadius,
      ),
      constraints: variant == GrafitEmptyMediaVariant.icon
          ? const BoxConstraints(
              minWidth: 40,
              minHeight: 40,
            )
          : null,
      child: IconTheme(
        data: IconThemeData(
          size: iconSize ?? 24,
          color: colors.foreground,
        ),
        child: child,
      ),
    );
  }
}

/// EmptyTitle subcomponent
///
/// Displays the main title text for the empty state with appropriate styling.
class EmptyTitle extends StatelessWidget {
  /// The title text or widget
  final Widget child;

  /// Custom text style
  final TextStyle? style;

  /// Custom alignment
  final TextAlign textAlign;

  /// Custom padding
  final EdgeInsetsGeometry? padding;

  const EmptyTitle({
    super.key,
    required this.child,
    this.style,
    this.textAlign = TextAlign.center,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<GrafitTheme>()!;

    final defaultStyle = TextStyle(
      color: theme.colors.foreground,
      fontSize: 18,
      fontWeight: FontWeight.w500,
      height: 1.4,
      letterSpacing: -0.01,
    );

    return Padding(
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 8),
      child: DefaultTextStyle(
        style: defaultStyle.merge(style),
        textAlign: textAlign,
        child: child,
      ),
    );
  }
}

/// EmptyDescription subcomponent
///
/// Displays the description text for the empty state with muted styling.
/// Supports inline links with hover effects.
class EmptyDescription extends StatelessWidget {
  /// The description text or widget
  final Widget child;

  /// Custom text style
  final TextStyle? style;

  /// Custom alignment
  final TextAlign textAlign;

  /// Custom padding
  final EdgeInsetsGeometry? padding;

  const EmptyDescription({
    super.key,
    required this.child,
    this.style,
    this.textAlign = TextAlign.center,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<GrafitTheme>()!;

    final defaultStyle = TextStyle(
      color: theme.colors.mutedForeground,
      fontSize: 14,
      height: 1.5,
      letterSpacing: 0,
    );

    return Padding(
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 8),
      child: DefaultTextStyle(
        style: defaultStyle.merge(style),
        textAlign: textAlign,
        child: child,
      ),
    );
  }
}

/// EmptyContent subcomponent
///
/// Container for additional content below the header section.
/// Provides centered layout with constrained max width.
class EmptyContent extends StatelessWidget {
  /// The content widget
  final Widget child;

  /// Custom padding
  final EdgeInsetsGeometry? padding;

  /// Maximum width constraint
  final double? maxWidth;

  /// Gap between children if child is a Column/Row
  final double? gap;

  const EmptyContent({
    super.key,
    required this.child,
    this.padding,
    this.maxWidth = 400,
    this.gap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: maxWidth != null
          ? BoxConstraints(maxWidth: maxWidth!)
          : null,
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 8),
      width: double.infinity,
      child: child,
    );
  }
}

/// EmptyFooter subcomponent
///
/// Container for action buttons at the bottom of the empty state.
/// Provides horizontal layout with gap between buttons.
class EmptyFooter extends StatelessWidget {
  /// The footer content (typically action buttons)
  final Widget child;

  /// Custom padding
  final EdgeInsetsGeometry? padding;

  /// Alignment of children
  final MainAxisAlignment mainAxisAlignment;

  /// Gap between children
  final double gap;

  const EmptyFooter({
    super.key,
    required this.child,
    this.padding,
    this.mainAxisAlignment = MainAxisAlignment.center,
    this.gap = 8,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.only(top: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: mainAxisAlignment,
        children: [Expanded(child: child)],
      ),
    );
  }
}

/// EmptyActions subcomponent
///
/// Convenience wrapper for action buttons in the footer.
/// Provides consistent spacing and alignment for multiple buttons.
class EmptyActions extends StatelessWidget {
  /// List of action buttons/widgets
  final List<Widget> actions;

  /// Custom spacing between actions
  final double spacing;

  /// Alignment of actions
  final MainAxisAlignment mainAxisAlignment;

  const EmptyActions({
    super.key,
    required this.actions,
    this.spacing = 8,
    this.mainAxisAlignment = MainAxisAlignment.center,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: mainAxisAlignment,
      children: List.generate(
        actions.length * 2 - 1,
        (index) {
          if (index.isEven) {
            return actions[index ~/ 2];
          }
          return SizedBox(width: spacing);
        },
      ),
    );
  }
}

/// EmptyImage subcomponent
///
/// Convenience widget for displaying an image in the empty state.
/// Supports network images, asset images, and custom image providers.
class EmptyImage extends StatelessWidget {
  /// Image to display
  final Widget image;

  /// Custom width
  final double? width;

  /// Custom height
  final double? height;

  /// Fit mode
  final BoxFit fit;

  /// Custom padding
  final EdgeInsetsGeometry? padding;

  const EmptyImage({
    super.key,
    required this.image,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
    this.padding,
  });

  /// Factory constructor for network image
  factory EmptyImage.network(
    String src, {
    double? width,
    double? height,
    BoxFit fit = BoxFit.contain,
    EdgeInsetsGeometry? padding,
    Key? key,
  }) {
    return EmptyImage(
      key: key,
      image: Image.network(
        src,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) {
          final theme = Theme.of(context).extension<GrafitTheme>()!;
          return Icon(
            Icons.broken_image,
            size: width ?? height ?? 48,
            color: theme.colors.mutedForeground,
          );
        },
      ),
      width: width,
      height: height,
      fit: fit,
      padding: padding,
    );
  }

  /// Factory constructor for asset image
  factory EmptyImage.asset(
    String assetPath, {
    double? width,
    double? height,
    BoxFit fit = BoxFit.contain,
    EdgeInsetsGeometry? padding,
    Key? key,
  }) {
    return EmptyImage(
      key: key,
      image: Image.asset(
        assetPath,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) {
          final theme = Theme.of(context).extension<GrafitTheme>()!;
          return Icon(
            Icons.broken_image,
            size: width ?? height ?? 48,
            color: theme.colors.mutedForeground,
          );
        },
      ),
      width: width,
      height: height,
      fit: fit,
      padding: padding,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.only(bottom: 8),
      child: SizedBox(
        width: width,
        height: height,
        child: image,
      ),
    );
  }
}

// Widgetbook use cases
@widgetbook.UseCase(
  name: 'Basic',
  type: GrafitEmpty,
  path: 'DataDisplay/Empty',
)
Widget emptyBasic(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.all(16.0),
    child: SizedBox(
      width: 400,
      child: GrafitEmpty(
        header: EmptyHeader(
          child: Column(
            children: [
              EmptyMedia(
                child: Icon(Icons.inbox, size: 48),
              ),
              EmptyTitle(child: Text('No data found')),
              EmptyDescription(child: Text('Try adjusting your filters or search query')),
            ],
          ),
        ),
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'With Icon Background',
  type: GrafitEmpty,
  path: 'DataDisplay/Empty',
)
Widget emptyWithIconBg(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.all(16.0),
    child: SizedBox(
      width: 400,
      child: GrafitEmpty(
        header: EmptyHeader(
          child: Column(
            children: [
              EmptyMedia(
                variant: GrafitEmptyMediaVariant.icon,
                child: Icon(Icons.search, size: 24),
              ),
              EmptyTitle(child: Text('No results found')),
              EmptyDescription(child: Text('We couldn\'t find anything matching your search')),
            ],
          ),
        ),
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'With Action',
  type: GrafitEmpty,
  path: 'DataDisplay/Empty',
)
Widget emptyWithAction(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: SizedBox(
      width: 400,
      child: GrafitEmpty(
        header: const EmptyHeader(
          child: Column(
            children: [
              EmptyMedia(
                child: Icon(Icons.folder_open, size: 48),
              ),
              EmptyTitle(child: Text('No projects yet')),
              EmptyDescription(child: Text('Create your first project to get started')),
            ],
          ),
        ),
        footer: const EmptyFooter(
          child: EmptyActions(
            actions: [
              ElevatedButton(child: Text('Create Project'), onPressed: null),
            ],
          ),
        ),
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'Multiple Actions',
  type: GrafitEmpty,
  path: 'DataDisplay/Empty',
)
Widget emptyMultipleActions(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: SizedBox(
      width: 400,
      child: GrafitEmpty(
        header: const EmptyHeader(
          child: Column(
            children: [
              EmptyMedia(
                child: Icon(Icons.error_outline, size: 48),
              ),
              EmptyTitle(child: Text('Something went wrong')),
              EmptyDescription(child: Text('We encountered an error while loading your data')),
            ],
          ),
        ),
        footer: EmptyFooter(
          child: EmptyActions(
            actions: [
              OutlinedButton(
                child: const Text('Retry'),
                onPressed: () {},
              ),
              ElevatedButton(
                child: const Text('Contact Support'),
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'With Content',
  type: GrafitEmpty,
  path: 'DataDisplay/Empty',
)
Widget emptyWithContent(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.all(16.0),
    child: SizedBox(
      width: 400,
      child: GrafitEmpty(
        header: EmptyHeader(
          child: Column(
            children: [
              EmptyTitle(child: Text('Your cart is empty')),
              EmptyDescription(child: Text('Add items to get started')),
            ],
          ),
        ),
        content: EmptyContent(
          child: Column(
            children: [
              ListTile(
                leading: Icon(Icons.local_offer),
                title: Text('Free shipping on orders over \$50'),
                subtitle: Text('Use code: FREESHIP'),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'Variants',
  type: GrafitEmpty,
  path: 'DataDisplay/Empty',
)
Widget emptyVariants(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: Column(
      children: [
        const SizedBox(
          width: 350,
          child: GrafitEmpty(
            header: EmptyHeader(
              child: Column(
                children: [
                  EmptyMedia(child: Icon(Icons.inbox, size: 32)),
                  EmptyTitle(child: Text('No Items')),
                  EmptyDescription(child: Text('Simple empty state')),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),
        const SizedBox(
          width: 350,
          child: GrafitEmpty(
            header: EmptyHeader(
              child: Column(
                children: [
                  EmptyMedia(
                    variant: GrafitEmptyMediaVariant.icon,
                    child: Icon(Icons.search_off, size: 20),
                  ),
                  EmptyTitle(child: Text('No Results')),
                  EmptyDescription(child: Text('With icon background variant')),
                ],
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

@widgetbook.UseCase(
  name: 'Interactive',
  type: GrafitEmpty,
  path: 'DataDisplay/Empty',
)
Widget emptyInteractive(BuildContext context) {
  final title = context.knobs.string(
    label: 'Title',
    initialValue: 'No data found',
  );
  final description = context.knobs.string(
    label: 'Description',
    initialValue: 'Try adjusting your search or filters',
  );
  final showIcon = context.knobs.boolean(
    label: 'Show Icon',
    initialValue: true,
  );
  final showAction = context.knobs.boolean(
    label: 'Show Action',
    initialValue: false,
  );
  final iconBackground = context.knobs.boolean(
    label: 'Icon Background',
    initialValue: false,
  );

  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: SizedBox(
      width: 400,
      child: GrafitEmpty(
        header: EmptyHeader(
          child: Column(
            children: [
              if (showIcon)
                EmptyMedia(
                  variant: iconBackground
                      ? GrafitEmptyMediaVariant.icon
                      : GrafitEmptyMediaVariant.defaultVariant,
                  child: const Icon(Icons.inbox, size: 48),
                ),
              EmptyTitle(child: Text(title.isNotEmpty ? title : 'Title')),
              if (description.isNotEmpty)
                EmptyDescription(child: Text(description)),
            ],
          ),
        ),
        footer: showAction
            ? const EmptyFooter(
                child: EmptyActions(
                  actions: [
                    ElevatedButton(child: Text('Action'), onPressed: null),
                  ],
                ),
              )
            : null,
      ),
    ),
  );
}
