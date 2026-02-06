import 'package:flutter/material.dart';
import '../theme_data.dart';

/// Dark color scheme for Grafit UI
class GrafitColorSchemeDark {
  static GrafitColorScheme zinc() {
    return const GrafitColorScheme(
      // Background
      background: Color(0xFF09090B),
      foreground: Color(0xFFFAFAFA),
      card: Color(0xFF09090B),
      'card-foreground': Color(0xFFFAFAFA),
      popover: Color(0xFF09090B),
      'popover-foreground': Color(0xFFFAFAFA),

      // Primary (Zinc 50)
      primary: Color(0xFFFAFAFA),
      'primary-foreground': Color(0xFF18181B),

      // Secondary (Zinc 800)
      secondary: Color(0xFF27272A),
      'secondary-foreground': Color(0xFFFAFAFA),

      // Muted (Zinc 800)
      muted: Color(0xFF27272A),
      'muted-foreground': Color(0xFFA1A1AA),

      // Accent (Zinc 800)
      accent: Color(0xFF27272A),
      'accent-foreground': Color(0xFFFAFAFA),

      // Destructive (Red 500)
      destructive: Color(0xFFEF4444),
      'destructive-foreground': Color(0xFFFFFFFF),

      // Borders
      border: Color(0xFF27272A),
      input: Color(0xFF27272A),
      ring: Color(0xFFD4D4D8),

      // Misc
      radius: 0.5,
    );
  }

  static GrafitColorScheme slate() {
    return const GrafitColorScheme(
      background: Color(0xFF020817),
      foreground: Color(0xFFF8FAFC),
      card: Color(0xFF020817),
      'card-foreground': Color(0xFFF8FAFC),
      popover: Color(0xFF020817),
      'popover-foreground': Color(0xFFF8FAFC),
      primary: Color(0xFFF8FAFC),
      'primary-foreground': Color(0xFF0F172A),
      secondary: Color(0xFF1E293B),
      'secondary-foreground': Color(0xFFF8FAFC),
      muted: Color(0xFF1E293B),
      'muted-foreground': Color(0xFF94A3B8),
      accent: Color(0xFF1E293B),
      'accent-foreground': Color(0xFFF8FAFC),
      destructive: Color(0xFFEF4444),
      'destructive-foreground': Color(0xFFFFFFFF),
      border: Color(0xFF1E293B),
      input: Color(0xFF1E293B),
      ring: Color(0xFFCBD5E1),
      radius: 0.5,
    );
  }

  static GrafitColorScheme neutral() {
    return const GrafitColorScheme(
      background: Color(0xFF171717),
      foreground: Color(0xFFFAFAFA),
      card: Color(0xFF171717),
      'card-foreground': Color(0xFFFAFAFA),
      popover: Color(0xFF171717),
      'popover-foreground': Color(0xFFFAFAFA),
      primary: Color(0xFFFAFAFA),
      'primary-foreground': Color(0xFF171717),
      secondary: Color(0xFF262626),
      'secondary-foreground': Color(0xFFFAFAFA),
      muted: Color(0xFF262626),
      'muted-foreground': Color(0xFFA3A3A3),
      accent: Color(0xFF262626),
      'accent-foreground': Color(0xFFFAFAFA),
      destructive: Color(0xFFEF4444),
      'destructive-foreground': Color(0xFFFFFFFF),
      border: Color(0xFF262626),
      input: Color(0xFF262626),
      ring: Color(0xFFD4D4D4),
      radius: 0.5,
    );
  }

  static GrafitColorScheme stone() {
    return const GrafitColorScheme(
      background: Color(0xFF0C0A09),
      foreground: Color(0xFFFAFAF9),
      card: Color(0xFF0C0A09),
      'card-foreground': Color(0xFFFAFAF9),
      popover: Color(0xFF0C0A09),
      'popover-foreground': Color(0xFFFAFAF9),
      primary: Color(0xFFFAFAF9),
      'primary-foreground': Color(0xFF1C1917),
      secondary: Color(0xFF292524),
      'secondary-foreground': Color(0xFFFAFAF9),
      muted: Color(0xFF292524),
      'muted-foreground': Color(0xFFA8A29E),
      accent: Color(0xFF292524),
      'accent-foreground': Color(0xFFFAFAF9),
      destructive: Color(0xFFEF4444),
      'destructive-foreground': Color(0xFFFFFFFF),
      border: Color(0xFF292524),
      input: Color(0xFF292524),
      ring: Color(0xFFD6D3D1),
      radius: 0.5,
    );
  }
}
