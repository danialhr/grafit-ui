import 'package:flutter/material.dart';
import '../../theme/theme.dart';

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
