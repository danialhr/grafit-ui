import 'package:flutter/material.dart';
import '../theme_data.dart';

/// Light color scheme for Grafit UI
class GrafitColorSchemeLight {
  static GrafitColorScheme zinc() {
    return const GrafitColorScheme(
      // Background
      background: Color(0xFFFFFFFF),
      foreground: Color(0xFF09090B),
      card: Color(0xFFFFFFFF),
      'card-foreground': Color(0xFF09090B),
      popover: Color(0xFFFFFFFF),
      'popover-foreground': Color(0xFF09090B),

      // Primary (Zinc 500)
      primary: Color(0xFF71717A),
      'primary-foreground': Color(0xFFFFFFFF),

      // Secondary (Zinc 100)
      secondary: Color(0xFFF4F4F5),
      'secondary-foreground': Color(0xFF18181B),

      // Muted (Zinc 100)
      muted: Color(0xFFF4F4F5),
      'muted-foreground': Color(0xFF71717A),

      // Accent (Zinc 100)
      accent: Color(0xFFF4F4F5),
      'accent-foreground': Color(0xFF18181B),

      // Destructive (Red 500)
      destructive: Color(0xFFEF4444),
      'destructive-foreground': Color(0xFFFFFFFF),

      // Borders
      border: Color(0xFFE4E4E7),
      input: Color(0xFFE4E4E7),
      ring: Color(0xFF71717A),

      // Misc
      radius: 0.5,
    );
  }

  static GrafitColorScheme slate() {
    return const GrafitColorScheme(
      background: Color(0xFFFFFFFF),
      foreground: Color(0xFF020817),
      card: Color(0xFFFFFFFF),
      'card-foreground': Color(0xFF020817),
      popover: Color(0xFFFFFFFF),
      'popover-foreground': Color(0xFF020817),
      primary: Color(0xFF64748B),
      'primary-foreground': Color(0xFFFFFFFF),
      secondary: Color(0xFFF1F5F9),
      'secondary-foreground': Color(0xFF0F172A),
      muted: Color(0xFFF1F5F9),
      'muted-foreground': Color(0xFF64748B),
      accent: Color(0xFFF1F5F9),
      'accent-foreground': Color(0xFF0F172A),
      destructive: Color(0xFFEF4444),
      'destructive-foreground': Color(0xFFFFFFFF),
      border: Color(0xFFE2E8F0),
      input: Color(0xFFE2E8F0),
      ring: Color(0xFF64748B),
      radius: 0.5,
    );
  }

  static GrafitColorScheme neutral() {
    return const GrafitColorScheme(
      background: Color(0xFFFFFFFF),
      foreground: Color(0xFF09090B),
      card: Color(0xFFFFFFFF),
      'card-foreground': Color(0xFF09090B),
      popover: Color(0xFFFFFFFF),
      'popover-foreground': Color(0xFF09090B),
      primary: Color(0xFF737373),
      'primary-foreground': Color(0xFFFFFFFF),
      secondary: Color(0xFFF5F5F5),
      'secondary-foreground': Color(0xFF171717),
      muted: Color(0xFFF5F5F5),
      'muted-foreground': Color(0xFF737373),
      accent: Color(0xFFF5F5F5),
      'accent-foreground': Color(0xFF171717),
      destructive: Color(0xFFEF4444),
      'destructive-foreground': Color(0xFFFFFFFF),
      border: Color(0xFFE5E5E5),
      input: Color(0xFFE5E5E5),
      ring: Color(0xFF737373),
      radius: 0.5,
    );
  }

  static GrafitColorScheme stone() {
    return const GrafitColorScheme(
      background: Color(0xFFFFFFFF),
      foreground: Color(0xFF0C0A09),
      card: Color(0xFFFFFFFF),
      'card-foreground': Color(0xFF0C0A09),
      popover: Color(0xFFFFFFFF),
      'popover-foreground': Color(0xFF0C0A09),
      primary: Color(0xFF78716C),
      'primary-foreground': Color(0xFFFFFFFF),
      secondary: Color(0xFFF5F5F4),
      'secondary-foreground': Color(0xFF1C1917),
      muted: Color(0xFFF5F5F4),
      'muted-foreground': Color(0xFF78716C),
      accent: Color(0xFFF5F5F4),
      'accent-foreground': Color(0xFF1C1917),
      destructive: Color(0xFFEF4444),
      'destructive-foreground': Color(0xFFFFFFFF),
      border: Color(0xFFE7E5E4),
      input: Color(0xFFE7E5E4),
      ring: Color(0xFF78716C),
      radius: 0.5,
    );
  }
}
