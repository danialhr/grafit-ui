import 'package:flutter/material.dart';
import 'theme_data.dart';
import 'color_schemes/light.dart';
import 'color_schemes/dark.dart';
import 'text_styles/text_styles.dart';

/// Main theme extension for Grafit UI
class GrafitTheme extends ThemeExtension<GrafitTheme> {
  final ColorScheme base;
  final GrafitColorScheme colors;
  final GrafitTextTheme text;
  final GrafitBorderTheme borders;
  final GrafitShadowTheme shadows;

  const GrafitTheme({
    required this.base,
    required this.colors,
    required this.text,
    required this.borders,
    required this.shadows,
  });

  /// Light theme factory
  static GrafitTheme light({String baseColor = 'zinc'}) {
    final colorScheme = switch (baseColor.toLowerCase()) {
      'slate' => GrafitColorSchemeLight.slate(),
      'neutral' => GrafitColorSchemeLight.neutral(),
      'stone' => GrafitColorSchemeLight.stone(),
      _ => GrafitColorSchemeLight.zinc(),
    };

    return GrafitTheme(
      base: ColorScheme.light(
        primary: colorScheme.primary,
        onPrimary: colorScheme.primaryForeground,
        secondary: colorScheme.secondary,
        onSecondary: colorScheme.secondaryForeground,
        error: colorScheme.destructive,
        onError: colorScheme.destructiveForeground,
        surface: colorScheme.card,
        onSurface: colorScheme.cardForeground,
      ),
      colors: colorScheme,
      text: GrafitTextTheme.light(ThemeData.light().textTheme),
      borders: const GrafitBorderTheme(),
      shadows: const GrafitShadowTheme(),
    );
  }

  /// Dark theme factory
  static GrafitTheme dark({String baseColor = 'zinc'}) {
    final colorScheme = switch (baseColor.toLowerCase()) {
      'slate' => GrafitColorSchemeDark.slate(),
      'neutral' => GrafitColorSchemeDark.neutral(),
      'stone' => GrafitColorSchemeDark.stone(),
      _ => GrafitColorSchemeDark.zinc(),
    };

    return GrafitTheme(
      base: ColorScheme.dark(
        primary: colorScheme.primary,
        onPrimary: colorScheme.primaryForeground,
        secondary: colorScheme.secondary,
        onSecondary: colorScheme.secondaryForeground,
        error: colorScheme.destructive,
        onError: colorScheme.destructiveForeground,
        surface: colorScheme.card,
        onSurface: colorScheme.cardForeground,
      ),
      colors: colorScheme,
      text: GrafitTextTheme.dark(ThemeData.dark().textTheme),
      borders: const GrafitBorderTheme(),
      shadows: const GrafitShadowTheme(),
    );
  }

  @override
  GrafitTheme copyWith({
    ColorScheme? base,
    GrafitColorScheme? colors,
    GrafitTextTheme? text,
    GrafitBorderTheme? borders,
    GrafitShadowTheme? shadows,
  }) {
    return GrafitTheme(
      base: base ?? this.base,
      colors: colors ?? this.colors,
      text: text ?? this.text,
      borders: borders ?? this.borders,
      shadows: shadows ?? this.shadows,
    );
  }

  @override
  GrafitTheme lerp(covariant ThemeExtension<GrafitTheme> other, double t) {
    if (other is! GrafitTheme) {
      return this;
    }

    return GrafitTheme(
      base: ColorScheme.lerp(base, other.base, t)!,
      colors: other.colors, // Simplified lerp
      text: text, // Simplified lerp
      borders: borders, // Simplified lerp
      shadows: shadows, // Simplified lerp
    );
  }

  /// Get border radius from value
  double getBorderRadius([double multiplier = 1.0]) {
    return colors.radius * 8 * multiplier;
  }

  /// Get color by key
  Color? getColor(String key) {
    return colors.getColor(key);
  }
}

/// Extension to easily access GrafitTheme from context
extension GrafitThemeExtension on BuildContext {
  GrafitTheme get pikpoTheme {
    final theme = Theme.of(this).extension<GrafitTheme>();
    if (theme == null) {
      throw Exception('GrafitTheme not found. Make sure to add GrafitTheme to your ThemeData.extensions');
    }
    return theme;
  }
}
