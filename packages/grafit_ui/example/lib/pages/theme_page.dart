import 'package:flutter/material.dart';
import 'package:pikpo_ui/pikpo_ui.dart';

class ThemePage extends StatefulWidget {
  const ThemePage({super.key});

  @override
  State<ThemePage> createState() => _ThemePageState();
}

class _ThemePageState extends State<ThemePage> {
  String _baseColor = 'zinc';
  ThemeMode _themeMode = ThemeMode.system;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<GrafitTheme>()!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.colors.background,
      appBar: AppBar(
        backgroundColor: theme.colors.background,
        title: GrafitText.titleLarge('Theme Settings'),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            // Theme mode
            _buildSection(
              context,
              theme,
              'Theme Mode',
              [
                _buildThemeModeOption(
                  context,
                  theme,
                  'Light',
                  ThemeMode.light,
                  Icons.light_mode,
                ),
                _buildThemeModeOption(
                  context,
                  theme,
                  'Dark',
                  ThemeMode.dark,
                  Icons.dark_mode,
                ),
                _buildThemeModeOption(
                  context,
                  theme,
                  'System',
                  ThemeMode.system,
                  Icons.brightness_auto,
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Base color
            _buildSection(
              context,
              theme,
              'Base Color',
              [
                _buildColorOption(context, theme, 'Zinc', 'zinc'),
                _buildColorOption(context, theme, 'Slate', 'slate'),
                _buildColorOption(context, theme, 'Neutral', 'neutral'),
                _buildColorOption(context, theme, 'Stone', 'stone'),
              ],
            ),
            const SizedBox(height: 32),

            // Preview
            _buildPreview(context, theme),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(
    BuildContext context,
    GrafitTheme theme,
    String title,
    List<Widget> children,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GrafitText.labelLarge(title),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.colors.card,
            border: Border.all(color: theme.colors.border),
            borderRadius: BorderRadius.circular(theme.colors.radius * 8),
          ),
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }

  Widget _buildThemeModeOption(
    BuildContext context,
    GrafitTheme theme,
    String label,
    ThemeMode mode,
    IconData icon,
  ) {
    final isSelected = _themeMode == mode;

    return InkWell(
      onTap: () {
        setState(() {
          _themeMode = mode;
        });
        _updateTheme(context);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? theme.colors.primary : theme.colors.mutedForeground,
            ),
            const SizedBox(width: 12),
            GrafitText.bodyMedium(label),
            const Spacer(),
            if (isSelected)
              Icon(
                Icons.check,
                color: theme.colors.primary,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildColorOption(
    BuildContext context,
    GrafitTheme theme,
    String label,
    String color,
  ) {
    final isSelected = _baseColor == color;

    return InkWell(
      onTap: () {
        setState(() {
          _baseColor = color;
        });
        _updateTheme(context);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: _getColorPreview(color),
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: theme.colors.border),
              ),
            ),
            const SizedBox(width: 12),
            GrafitText.bodyMedium(label),
            const Spacer(),
            if (isSelected)
              Icon(
                Icons.check,
                color: theme.colors.primary,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPreview(BuildContext context, GrafitTheme theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GrafitText.labelLarge('Preview'),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: theme.colors.card,
            border: Border.all(color: theme.colors.border),
            borderRadius: BorderRadius.circular(theme.colors.radius * 8),
          ),
          child: Column(
            children: [
              GrafitText.headlineSmall('Preview Text'),
              const SizedBox(height: 16),
              Wrap(
                spacing: 12,
                children: [
                  GrafitButton(label: 'Primary', variant: GrafitButtonVariant.primary, onPressed: () {}),
                  GrafitButton(label: 'Secondary', variant: GrafitButtonVariant.secondary, onPressed: () {}),
                  GrafitButton(label: 'Ghost', variant: GrafitButtonVariant.ghost, onPressed: () {}),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Color _getColorPreview(String color) {
    return switch (color) {
      'zinc' => const Color(0xFF71717A),
      'slate' => const Color(0xFF64748B),
      'neutral' => const Color(0xFF737373),
      'stone' => const Color(0xFF78716C),
      _ => Colors.grey,
    };
  }

  void _updateTheme(BuildContext context) {
    final isDark = _themeMode == ThemeMode.dark ||
        (_themeMode == ThemeMode.system &&
            MediaQuery.of(context).platformBrightness == Brightness.dark);

    final newTheme = isDark
        ? GrafitTheme.dark(baseColor: _baseColor)
        : GrafitTheme.light(baseColor: _baseColor);

    // Update app theme
    // Note: This would require a state management solution in a real app
  }
}
