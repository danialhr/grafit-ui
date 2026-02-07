import 'package:flutter/material.dart';
import '../../theme/theme.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

/// Text variants for Grafit UI
enum GrafitTextVariant {
  displayLarge,
  displayMedium,
  displaySmall,
  headlineLarge,
  headlineMedium,
  headlineSmall,
  titleLarge,
  titleMedium,
  titleSmall,
  bodyLarge,
  bodyMedium,
  bodySmall,
  labelLarge,
  labelMedium,
  labelSmall,
  lead,
  large,
  small,
  muted,
}

/// Typography component with semantic styles
class GrafitText extends StatelessWidget {
  final String text;
  final GrafitTextVariant variant;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final FontWeight? fontWeight;
  final FontStyle? fontStyle;
  final TextDecoration? decoration;
  final double? height;
  final double? letterSpacing;

  const GrafitText(
    this.text, {
    super.key,
    this.variant = GrafitTextVariant.bodyMedium,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.fontWeight,
    this.fontStyle,
    this.decoration,
    this.height,
    this.letterSpacing,
  });

  factory GrafitText.displayLarge(
    String text, {
    Key? key,
    Color? color,
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
  }) {
    return GrafitText(
      text,
      key: key,
      variant: GrafitTextVariant.displayLarge,
      color: color,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }

  factory GrafitText.displayMedium(
    String text, {
    Key? key,
    Color? color,
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
  }) {
    return GrafitText(
      text,
      key: key,
      variant: GrafitTextVariant.displayMedium,
      color: color,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }

  factory GrafitText.displaySmall(
    String text, {
    Key? key,
    Color? color,
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
  }) {
    return GrafitText(
      text,
      key: key,
      variant: GrafitTextVariant.displaySmall,
      color: color,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }

  factory GrafitText.headlineLarge(
    String text, {
    Key? key,
    Color? color,
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
  }) {
    return GrafitText(
      text,
      key: key,
      variant: GrafitTextVariant.headlineLarge,
      color: color,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }

  factory GrafitText.headlineMedium(
    String text, {
    Key? key,
    Color? color,
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
  }) {
    return GrafitText(
      text,
      key: key,
      variant: GrafitTextVariant.headlineMedium,
      color: color,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }

  factory GrafitText.headlineSmall(
    String text, {
    Key? key,
    Color? color,
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
  }) {
    return GrafitText(
      text,
      key: key,
      variant: GrafitTextVariant.headlineSmall,
      color: color,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }

  factory GrafitText.titleLarge(
    String text, {
    Key? key,
    Color? color,
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
  }) {
    return GrafitText(
      text,
      key: key,
      variant: GrafitTextVariant.titleLarge,
      color: color,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }

  factory GrafitText.titleMedium(
    String text, {
    Key? key,
    Color? color,
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
  }) {
    return GrafitText(
      text,
      key: key,
      variant: GrafitTextVariant.titleMedium,
      color: color,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }

  factory GrafitText.titleSmall(
    String text, {
    Key? key,
    Color? color,
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
  }) {
    return GrafitText(
      text,
      key: key,
      variant: GrafitTextVariant.titleSmall,
      color: color,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }

  factory GrafitText.bodyLarge(
    String text, {
    Key? key,
    Color? color,
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
  }) {
    return GrafitText(
      text,
      key: key,
      variant: GrafitTextVariant.bodyLarge,
      color: color,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }

  factory GrafitText.bodyMedium(
    String text, {
    Key? key,
    Color? color,
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
  }) {
    return GrafitText(
      text,
      key: key,
      variant: GrafitTextVariant.bodyMedium,
      color: color,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }

  factory GrafitText.bodySmall(
    String text, {
    Key? key,
    Color? color,
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
  }) {
    return GrafitText(
      text,
      key: key,
      variant: GrafitTextVariant.bodySmall,
      color: color,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }

  factory GrafitText.labelLarge(
    String text, {
    Key? key,
    Color? color,
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
  }) {
    return GrafitText(
      text,
      key: key,
      variant: GrafitTextVariant.labelLarge,
      color: color,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }

  factory GrafitText.labelMedium(
    String text, {
    Key? key,
    Color? color,
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
  }) {
    return GrafitText(
      text,
      key: key,
      variant: GrafitTextVariant.labelMedium,
      color: color,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }

  factory GrafitText.labelSmall(
    String text, {
    Key? key,
    Color? color,
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
  }) {
    return GrafitText(
      text,
      key: key,
      variant: GrafitTextVariant.labelSmall,
      color: color,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }

  factory GrafitText.lead(
    String text, {
    Key? key,
    Color? color,
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
  }) {
    return GrafitText(
      text,
      key: key,
      variant: GrafitTextVariant.lead,
      color: color,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }

  factory GrafitText.large(
    String text, {
    Key? key,
    Color? color,
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
  }) {
    return GrafitText(
      text,
      key: key,
      variant: GrafitTextVariant.large,
      color: color,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }

  factory GrafitText.small(
    String text, {
    Key? key,
    Color? color,
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
  }) {
    return GrafitText(
      text,
      key: key,
      variant: GrafitTextVariant.small,
      color: color,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }

  factory GrafitText.muted(
    String text, {
    Key? key,
    Color? color,
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
  }) {
    return GrafitText(
      text,
      key: key,
      variant: GrafitTextVariant.muted,
      color: color,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<GrafitTheme>()!;
    final colors = theme.colors;

    final textStyle = _getTextStyle(theme);
    final effectiveColor = color ?? _getDefaultColor(colors);

    return Text(
      text,
      style: textStyle.copyWith(
        color: effectiveColor,
        fontWeight: fontWeight,
        fontStyle: fontStyle,
        decoration: decoration,
        height: height,
        letterSpacing: letterSpacing,
      ),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }

  TextStyle _getTextStyle(GrafitTheme theme) {
    return switch (variant) {
      GrafitTextVariant.displayLarge => theme.text.displayLarge,
      GrafitTextVariant.displayMedium => theme.text.displayMedium,
      GrafitTextVariant.displaySmall => theme.text.displaySmall,
      GrafitTextVariant.headlineLarge => theme.text.headlineLarge,
      GrafitTextVariant.headlineMedium => theme.text.headlineMedium,
      GrafitTextVariant.headlineSmall => theme.text.headlineSmall,
      GrafitTextVariant.titleLarge => theme.text.titleLarge,
      GrafitTextVariant.titleMedium => theme.text.titleMedium,
      GrafitTextVariant.titleSmall => theme.text.titleSmall,
      GrafitTextVariant.bodyLarge => theme.text.bodyLarge,
      GrafitTextVariant.bodyMedium => theme.text.bodyMedium,
      GrafitTextVariant.bodySmall => theme.text.bodySmall,
      GrafitTextVariant.labelLarge => theme.text.labelLarge,
      GrafitTextVariant.labelMedium => theme.text.labelMedium,
      GrafitTextVariant.labelSmall => theme.text.labelSmall,
      GrafitTextVariant.lead => theme.text.bodyLarge.copyWith(
          fontSize: 18,
          fontWeight: FontWeight.w400,
          height: 1.5,
        ),
      GrafitTextVariant.large => theme.text.bodyMedium.copyWith(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      GrafitTextVariant.small => theme.text.bodySmall.copyWith(
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      GrafitTextVariant.muted => theme.text.bodyMedium.copyWith(
          fontSize: 14,
          color: theme.colors.mutedForeground,
        ),
    };
  }

  Color? _getDefaultColor(GrafitColorScheme colors) {
    return switch (variant) {
      GrafitTextVariant.muted => colors.mutedForeground,
      _ => null,
    };
  }
}

/// Heading component (semantic wrapper)
class GrafitHeading extends StatelessWidget {
  final String text;
  final int level;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  const GrafitHeading(
    this.text, {
    super.key,
    this.level = 1,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<GrafitTheme>()!;
    final colors = theme.colors;
    final effectiveColor = color ?? colors.foreground;

    final textStyle = switch (level) {
      1 => theme.text.headlineLarge,
      2 => theme.text.headlineMedium,
      3 => theme.text.headlineSmall,
      4 => theme.text.titleLarge,
      5 => theme.text.titleMedium,
      6 => theme.text.titleSmall,
      _ => theme.text.headlineSmall,
    };

    return Text(
      text,
      style: textStyle.copyWith(color: effectiveColor),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}

// Widgetbook use cases
@widgetbook.UseCase(
  name: 'All Variants',
  type: GrafitText,
  path: 'Typography/Text',
)
Widget textAllVariants(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.all(24.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GrafitText('Display Large', variant: GrafitTextVariant.displayLarge),
        GrafitText('Display Medium', variant: GrafitTextVariant.displayMedium),
        GrafitText('Display Small', variant: GrafitTextVariant.displaySmall),
        SizedBox(height: 16),
        GrafitText('Headline Large', variant: GrafitTextVariant.headlineLarge),
        GrafitText('Headline Medium', variant: GrafitTextVariant.headlineMedium),
        GrafitText('Headline Small', variant: GrafitTextVariant.headlineSmall),
        SizedBox(height: 16),
        GrafitText('Title Large', variant: GrafitTextVariant.titleLarge),
        GrafitText('Title Medium', variant: GrafitTextVariant.titleMedium),
        GrafitText('Title Small', variant: GrafitTextVariant.titleSmall),
        SizedBox(height: 16),
        GrafitText('Body Large', variant: GrafitTextVariant.bodyLarge),
        GrafitText('Body Medium', variant: GrafitTextVariant.bodyMedium),
        GrafitText('Body Small', variant: GrafitTextVariant.bodySmall),
        SizedBox(height: 16),
        GrafitText('Label Large', variant: GrafitTextVariant.labelLarge),
        GrafitText('Label Medium', variant: GrafitTextVariant.labelMedium),
        GrafitText('Label Small', variant: GrafitTextVariant.labelSmall),
      ],
    ),
  );
}

@widgetbook.UseCase(
  name: 'Special Variants',
  type: GrafitText,
  path: 'Typography/Text',
)
Widget textSpecialVariants(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.all(24.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GrafitText('Lead text for introductions', variant: GrafitTextVariant.lead),
        SizedBox(height: 16),
        GrafitText('Large emphasized text', variant: GrafitTextVariant.large),
        SizedBox(height: 16),
        GrafitText('Small subtle text', variant: GrafitTextVariant.small),
        SizedBox(height: 16),
        GrafitText('Muted descriptive text', variant: GrafitTextVariant.muted),
      ],
    ),
  );
}

@widgetbook.UseCase(
  name: 'Factory Constructors',
  type: GrafitText,
  path: 'Typography/Text',
)
Widget textFactoryConstructors(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.all(24.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GrafitText.displayLarge('Display Large via factory'),
        GrafitText.headlineMedium('Headline Medium via factory'),
        GrafitText.titleLarge('Title Large via factory'),
        GrafitText.bodyMedium('Body Medium via factory'),
        GrafitText.labelSmall('Label Small via factory'),
        GrafitText.lead('Lead text via factory'),
        GrafitText.large('Large text via factory'),
        GrafitText.small('Small text via factory'),
        GrafitText.muted('Muted text via factory'),
      ],
    ),
  );
}

@widgetbook.UseCase(
  name: 'With Custom Styles',
  type: GrafitText,
  path: 'Typography/Text',
)
Widget textCustomStyles(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.all(24.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GrafitText(
          'Bold Text',
          variant: GrafitTextVariant.bodyMedium,
          fontWeight: FontWeight.bold,
        ),
        GrafitText(
          'Italic Text',
          variant: GrafitTextVariant.bodyMedium,
          fontStyle: FontStyle.italic,
        ),
        GrafitText(
          'Underlined Text',
          variant: GrafitTextVariant.bodyMedium,
          decoration: TextDecoration.underline,
        ),
        GrafitText(
          'Strikethrough Text',
          variant: GrafitTextVariant.bodyMedium,
          decoration: TextDecoration.lineThrough,
        ),
        GrafitText(
          'Custom Color',
          variant: GrafitTextVariant.bodyMedium,
          color: Colors.blue,
        ),
        GrafitText(
          'Custom Letter Spacing',
          variant: GrafitTextVariant.bodyMedium,
          letterSpacing: 2.0,
        ),
        GrafitText(
          'Custom Line Height',
          variant: GrafitTextVariant.bodyMedium,
          height: 2.0,
        ),
      ],
    ),
  );
}

@widgetbook.UseCase(
  name: 'With Alignment',
  type: GrafitText,
  path: 'Typography/Text',
)
Widget textAlignment(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.all(24.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GrafitText(
          'Left aligned text',
          variant: GrafitTextVariant.bodyMedium,
          textAlign: TextAlign.left,
        ),
        SizedBox(height: 8),
        GrafitText(
          'Center aligned text that spans multiple lines to show the effect',
          variant: GrafitTextVariant.bodyMedium,
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 8),
        GrafitText(
          'Right aligned text',
          variant: GrafitTextVariant.bodyMedium,
          textAlign: TextAlign.right,
        ),
      ],
    ),
  );
}

@widgetbook.UseCase(
  name: 'With Overflow',
  type: GrafitText,
  path: 'Typography/Text',
)
Widget textOverflow(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.all(24.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GrafitText(
          'Clipped text that is too long and will be clipped at the edge',
          variant: GrafitTextVariant.bodyMedium,
          maxLines: 1,
          overflow: TextOverflow.clip,
        ),
        SizedBox(height: 8),
        GrafitText(
          'Ellipsis text that is too long and will show ellipsis...',
          variant: GrafitTextVariant.bodyMedium,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: 8),
        GrafitText(
          'Fading text that is too long and will fade at the edge',
          variant: GrafitTextVariant.bodyMedium,
          maxLines: 1,
          overflow: TextOverflow.fade,
        ),
      ],
    ),
  );
}

@widgetbook.UseCase(
  name: 'Interactive',
  type: GrafitText,
  path: 'Typography/Text',
)
Widget textInteractive(BuildContext context) {
  // Widgetbook-only: ignore undefined_getter, undefined_method, invalid_annotation_value
  final variant = context.knobs.list(
    label: 'Variant',
    options: GrafitTextVariant.values,
    initialOption: GrafitTextVariant.bodyMedium,
  );

  // Widgetbook-only: ignore undefined_getter, undefined_method, invalid_annotation_value
  final text = context.knobs.string(
    label: 'Text',
    initialValue: 'Interactive text example',
  );

  // Widgetbook-only: ignore undefined_getter, undefined_method, invalid_annotation_value
  final color = context.knobs.colorOrNull(
    label: 'Color',
    initialValue: null,
  );

  // Widgetbook-only: ignore undefined_getter, undefined_method, invalid_annotation_value
  final maxLines = context.knobs.int.slider(
    label: 'Max Lines',
    initialValue: 10,
    min: 1,
    max: 10,
  );

  // Widgetbook-only: ignore undefined_getter, undefined_method, invalid_annotation_value
  final textAlign = context.knobs.list(
    label: 'Text Align',
    options: [
      TextAlign.left,
      TextAlign.center,
      TextAlign.right,
      TextAlign.justify,
    ],
    initialOption: TextAlign.left,
  );

  return Padding(
    padding: const EdgeInsets.all(24.0),
    child: GrafitText(
      text * 3,
      variant: variant,
      color: color,
      maxLines: maxLines,
      textAlign: textAlign,
    ),
  );
}

@widgetbook.UseCase(
  name: 'Heading Levels',
  type: GrafitHeading,
  path: 'Typography/Text',
)
Widget textHeadingLevels(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.all(24.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GrafitHeading('Heading Level 1', level: 1),
        SizedBox(height: 8),
        GrafitHeading('Heading Level 2', level: 2),
        SizedBox(height: 8),
        GrafitHeading('Heading Level 3', level: 3),
        SizedBox(height: 8),
        GrafitHeading('Heading Level 4', level: 4),
        SizedBox(height: 8),
        GrafitHeading('Heading Level 5', level: 5),
        SizedBox(height: 8),
        GrafitHeading('Heading Level 6', level: 6),
      ],
    ),
  );
}
