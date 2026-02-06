import 'package:flutter/material.dart';

/// Text theme for Grafit UI
class GrafitTextTheme {
  final TextStyle displayLarge;
  final TextStyle displayMedium;
  final TextStyle displaySmall;
  final TextStyle headlineLarge;
  final TextStyle headlineMedium;
  final TextStyle headlineSmall;
  final TextStyle titleLarge;
  final TextStyle titleMedium;
  final TextStyle titleSmall;
  final TextStyle bodyLarge;
  final TextStyle bodyMedium;
  final TextStyle bodySmall;
  final TextStyle labelLarge;
  final TextStyle labelMedium;
  final TextStyle labelSmall;

  const GrafitTextTheme({
    required this.displayLarge,
    required this.displayMedium,
    required this.displaySmall,
    required this.headlineLarge,
    required this.headlineMedium,
    required this.headlineSmall,
    required this.titleLarge,
    required this.titleMedium,
    required this.titleSmall,
    required this.bodyLarge,
    required this.bodyMedium,
    required this.bodySmall,
    required this.labelLarge,
    required this.labelMedium,
    required this.labelSmall,
  });

  /// Create light text theme
  factory GrafitTextTheme.light(TextTheme base) {
    return GrafitTextTheme(
      displayLarge: base.displayLarge?.copyWith(
            fontWeight: FontWeight.w700,
            letterSpacing: -0.5,
          ) ??
          const TextStyle(
            fontSize: 57,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.5,
          ),
      displayMedium: base.displayMedium?.copyWith(
            fontWeight: FontWeight.w700,
            letterSpacing: -0.25,
          ) ??
          const TextStyle(
            fontSize: 45,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.25,
          ),
      displaySmall: base.displaySmall?.copyWith(
            fontWeight: FontWeight.w700,
          ) ??
          const TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.w700,
          ),
      headlineLarge: base.headlineLarge?.copyWith(
            fontWeight: FontWeight.w600,
            letterSpacing: -0.25,
          ) ??
          const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.25,
          ),
      headlineMedium: base.headlineMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ) ??
          const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w600,
          ),
      headlineSmall: base.headlineSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ) ??
          const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
      titleLarge: base.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ) ??
          const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
          ),
      titleMedium: base.titleMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ) ??
          const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
      titleSmall: base.titleSmall?.copyWith(
            fontWeight: FontWeight.w500,
          ) ??
          const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
      bodyLarge: base.bodyLarge?.copyWith(
            fontWeight: FontWeight.w400,
          ) ??
          const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
      bodyMedium: base.bodyMedium?.copyWith(
            fontWeight: FontWeight.w400,
          ) ??
          const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
      bodySmall: base.bodySmall?.copyWith(
            fontWeight: FontWeight.w400,
          ) ??
          const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
      labelLarge: base.labelLarge?.copyWith(
            fontWeight: FontWeight.w500,
          ) ??
          const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
      labelMedium: base.labelMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ) ??
          const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
      labelSmall: base.labelSmall?.copyWith(
            fontWeight: FontWeight.w500,
          ) ??
          const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
    );
  }

  /// Create dark text theme
  factory GrafitTextTheme.dark(TextTheme base) {
    return GrafitTextTheme(
      displayLarge: base.displayLarge?.copyWith(
            fontWeight: FontWeight.w700,
            letterSpacing: -0.5,
          ) ??
          const TextStyle(
            fontSize: 57,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.5,
          ),
      displayMedium: base.displayMedium?.copyWith(
            fontWeight: FontWeight.w700,
            letterSpacing: -0.25,
          ) ??
          const TextStyle(
            fontSize: 45,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.25,
          ),
      displaySmall: base.displaySmall?.copyWith(
            fontWeight: FontWeight.w700,
          ) ??
          const TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.w700,
          ),
      headlineLarge: base.headlineLarge?.copyWith(
            fontWeight: FontWeight.w600,
            letterSpacing: -0.25,
          ) ??
          const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.25,
          ),
      headlineMedium: base.headlineMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ) ??
          const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w600,
          ),
      headlineSmall: base.headlineSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ) ??
          const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
      titleLarge: base.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ) ??
          const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
          ),
      titleMedium: base.titleMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ) ??
          const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
      titleSmall: base.titleSmall?.copyWith(
            fontWeight: FontWeight.w500,
          ) ??
          const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
      bodyLarge: base.bodyLarge?.copyWith(
            fontWeight: FontWeight.w400,
          ) ??
          const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
      bodyMedium: base.bodyMedium?.copyWith(
            fontWeight: FontWeight.w400,
          ) ??
          const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
      bodySmall: base.bodySmall?.copyWith(
            fontWeight: FontWeight.w400,
          ) ??
          const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
      labelLarge: base.labelLarge?.copyWith(
            fontWeight: FontWeight.w500,
          ) ??
          const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
      labelMedium: base.labelMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ) ??
          const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
      labelSmall: base.labelSmall?.copyWith(
            fontWeight: FontWeight.w500,
          ) ??
          const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
    );
  }

  /// Convert to Flutter TextTheme
  TextTheme toTextTheme() {
    return TextTheme(
      displayLarge: displayLarge,
      displayMedium: displayMedium,
      displaySmall: displaySmall,
      headlineLarge: headlineLarge,
      headlineMedium: headlineMedium,
      headlineSmall: headlineSmall,
      titleLarge: titleLarge,
      titleMedium: titleMedium,
      titleSmall: titleSmall,
      bodyLarge: bodyLarge,
      bodyMedium: bodyMedium,
      bodySmall: bodySmall,
      labelLarge: labelLarge,
      labelMedium: labelMedium,
      labelSmall: labelSmall,
    );
  }
}
