import 'package:flutter/material.dart';
import 'package:pikpo_ui/pikpo_ui.dart';

/// Widget to showcase a single component with preview and code
class ComponentShowcase extends StatelessWidget {
  final String name;
  final String description;
  final Widget preview;
  final String? code;

  const ComponentShowcase({
    super.key,
    required this.name,
    required this.description,
    required this.preview,
    this.code,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<GrafitTheme>()!;

    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GrafitText.headlineSmall(name),
                    const SizedBox(height: 4),
                    GrafitText.muted(description),
                  ],
                ),
              ),
              if (code != null)
                GrafitButton(
                  label: 'View Code',
                  variant: GrafitButtonVariant.ghost,
                  size: GrafitButtonSize.sm,
                  icon: Icons.code,
                  onPressed: () => _showCode(context),
                ),
            ],
          ),
          const SizedBox(height: 16),

          // Preview
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: theme.colors.card,
              border: Border.all(color: theme.colors.border),
              borderRadius: BorderRadius.circular(theme.colors.radius * 8),
            ),
            child: Center(child: preview),
          ),
        ],
      ),
    );
  }

  void _showCode(BuildContext context) {
    if (code == null) return;

    final theme = Theme.of(context).extension<GrafitTheme>()!;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: GrafitText.titleLarge('Code: $name'),
        content: SizedBox(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E1E),
                borderRadius: BorderRadius.circular(8),
              ),
              child: GrafitText.bodySmall(
                code!,
                color: const Color(0xFFD4D4D4),
              ),
            ),
          ),
        ),
        actions: [
          GrafitButton(
            label: 'Close',
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}

/// Section header for component groups
class ComponentSection extends StatelessWidget {
  final String title;
  final String? description;

  const ComponentSection({
    super.key,
    required this.title,
    this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GrafitText.headlineMedium(title),
          if (description != null) ...[
            const SizedBox(height: 4),
            GrafitText.muted(description!),
          ],
        ],
      ),
    );
  }
}

/// Responsive grid for component previews
class ComponentGrid extends StatelessWidget {
  final List<Widget> children;
  final int columns;

  const ComponentGrid({
    super.key,
    required this.children,
    this.columns = 2,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate responsive columns
        final responsiveColumns = switch (constraints.maxWidth) {
          > 1200 => columns,
          > 800 => 1,
          _ => 1,
        };

        return GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: responsiveColumns,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 1.5,
          children: children,
        );
      },
    );
  }
}
