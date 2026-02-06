import 'package:flutter/material.dart';
import 'color_schemes/light.dart';
import 'color_schemes/dark.dart';
import 'text_styles/text_styles.dart';

/// Color scheme data class for Grafit UI
class GrafitColorScheme {
  final Color background;
  final Color foreground;
  final Color card;
  final Color cardForeground;
  final Color popover;
  final Color popoverForeground;
  final Color primary;
  final Color primaryForeground;
  final Color secondary;
  final Color secondaryForeground;
  final Color muted;
  final Color mutedForeground;
  final Color accent;
  final Color accentForeground;
  final Color destructive;
  final Color destructiveForeground;
  final Color border;
  final Color input;
  final Color ring;
  final Color transparent;
  final double radius;

  const GrafitColorScheme({
    required this.background,
    required this.foreground,
    required this.card,
    required this.cardForeground,
    required this.popover,
    required this.popoverForeground,
    required this.primary,
    required this.primaryForeground,
    required this.secondary,
    required this.secondaryForeground,
    required this.muted,
    required this.mutedForeground,
    required this.accent,
    required this.accentForeground,
    required this.destructive,
    required this.destructiveForeground,
    required this.border,
    required this.input,
    required this.ring,
    this.transparent = Colors.transparent,
    this.radius = 0.5,
  });

  /// Create from map (for JSON deserialization)
  factory GrafitColorScheme.fromMap(Map<String, dynamic> map) {
    return GrafitColorScheme(
      background: _parseColor(map['background']),
      foreground: _parseColor(map['foreground']),
      card: _parseColor(map['card']),
      cardForeground: _parseColor(map['card-foreground']),
      popover: _parseColor(map['popover']),
      popoverForeground: _parseColor(map['popover-foreground']),
      primary: _parseColor(map['primary']),
      primaryForeground: _parseColor(map['primary-foreground']),
      secondary: _parseColor(map['secondary']),
      secondaryForeground: _parseColor(map['secondary-foreground']),
      muted: _parseColor(map['muted']),
      mutedForeground: _parseColor(map['muted-foreground']),
      accent: _parseColor(map['accent']),
      accentForeground: _parseColor(map['accent-foreground']),
      destructive: _parseColor(map['destructive']),
      destructiveForeground: _parseColor(map['destructive-foreground']),
      border: _parseColor(map['border']),
      input: _parseColor(map['input']),
      ring: _parseColor(map['ring']),
      transparent: _parseColor(map['transparent']) ?? Colors.transparent,
      radius: (map['radius'] as num?)?.toDouble() ?? 0.5,
    };
  }

  static Color _parseColor(dynamic value) {
    if (value is Color) return value;
    if (value is int) return Color(value);
    if (value is String && value.startsWith('0xFF')) {
      return Color(int.parse(value));
    }
    return Colors.black;
  }

  /// Convert to map (for JSON serialization)
  Map<String, dynamic> toMap() {
    return {
      'background': background.value,
      'foreground': foreground.value,
      'card': card.value,
      'card-foreground': cardForeground.value,
      'popover': popover.value,
      'popover-foreground': popoverForeground.value,
      'primary': primary.value,
      'primary-foreground': primaryForeground.value,
      'secondary': secondary.value,
      'secondary-foreground': secondaryForeground.value,
      'muted': muted.value,
      'muted-foreground': mutedForeground.value,
      'accent': accent.value,
      'accent-foreground': accentForeground.value,
      'destructive': destructive.value,
      'destructive-foreground': destructiveForeground.value,
      'border': border.value,
      'input': input.value,
      'ring': ring.value,
      'transparent': transparent.value,
      'radius': radius,
    };
  }

  /// Get color by key
  Color? getColor(String key) {
    switch (key) {
      case 'background':
        return background;
      case 'foreground':
        return foreground;
      case 'card':
        return card;
      case 'card-foreground':
        return cardForeground;
      case 'popover':
        return popover;
      case 'popover-foreground':
        return popoverForeground;
      case 'primary':
        return primary;
      case 'primary-foreground':
        return primaryForeground;
      case 'secondary':
        return secondary;
      case 'secondary-foreground':
        return secondaryForeground;
      case 'muted':
        return muted;
      case 'muted-foreground':
        return mutedForeground;
      case 'accent':
        return accent;
      case 'accent-foreground':
        return accentForeground;
      case 'destructive':
        return destructive;
      case 'destructive-foreground':
        return destructiveForeground;
      case 'border':
        return border;
      case 'input':
        return input;
      case 'ring':
        return ring;
      case 'transparent':
        return transparent;
      default:
        return null;
    }
  }
}

/// Border radius theme
class GrafitBorderTheme {
  final double radius;
  final double sm;
  final double md;
  final double lg;
  final double xl;

  const GrafitBorderTheme({
    this.radius = 0.5,
    this.sm = 0.25,
    this.md = 0.5,
    this.lg = 0.75,
    this.xl = 1.0,
  });
}

/// Shadow theme
class GrafitShadowTheme {
  final List<BoxShadow> sm;
  final List<BoxShadow> md;
  final List<BoxShadow> lg;
  final List<BoxShadow> xl;

  const GrafitShadowTheme({
    this.sm = const [
      BoxShadow(
        color: Color(0x0A000000),
        offset: Offset(0, 1),
        blurRadius: 2,
      ),
    ],
    this.md = const [
      BoxShadow(
        color: Color(0x0A000000),
        offset: Offset(0, 4),
        blurRadius: 6,
      ),
    ],
    this.lg = const [
      BoxShadow(
        color: Color(0x0F000000),
        offset: Offset(0, 10),
        blurRadius: 15,
      ),
    ],
    this.xl = const [
      BoxShadow(
        color: Color(0x14000000),
        offset: Offset(0, 20),
        blurRadius: 25,
      ),
    ],
  );
}
