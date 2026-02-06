import 'package:flutter/material.dart';
import 'package:pikpo_ui/pikpo_ui.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<GrafitTheme>()!;

    return Scaffold(
      backgroundColor: theme.colors.background,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Title
              GrafitText.headlineLarge(
                'Grafit UI',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              GrafitText.muted(
                'Flutter port of shadcn/ui',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),

              // Buttons showcase
              Wrap(
                spacing: 12,
                runSpacing: 12,
                alignment: WrapAlignment.center,
                children: [
                  GrafitButton(
                    label: 'View Components',
                    variant: GrafitButtonVariant.primary,
                    onPressed: () {
                      Navigator.pushNamed(context, '/components');
                    },
                  ),
                  GrafitButton(
                    label: 'Theme Settings',
                    variant: GrafitButtonVariant.secondary,
                    onPressed: () {
                      Navigator.pushNamed(context, '/theme');
                    },
                  ),
                  GrafitButton(
                    label: 'Documentation',
                    variant: GrafitButtonVariant.ghost,
                    onPressed: () {
                      // Open docs
                    },
                  ),
                ],
              ),
              const SizedBox(height: 48),

              // Input showcase
              SizedBox(
                width: 300,
                child: GrafitInput(
                  label: 'Email',
                  hint: 'Enter your email',
                  onChanged: (value) {},
                ),
              ),
              const SizedBox(height: 24),

              // Feature list
              _buildFeatureList(context, theme),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureList(BuildContext context, GrafitTheme theme) {
    final features = [
      '47 shadcn/ui components',
      'Copy-paste philosophy',
      'Theme-based customization',
      'State management agnostic',
      'Light & dark mode support',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: features.map((feature) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            children: [
              Icon(
                Icons.check_circle,
                size: 16,
                color: theme.colors.primary,
              ),
              const SizedBox(width: 8),
              GrafitText.bodyMedium(feature),
            ],
          ),
        );
      }).toList(),
    );
  }
}
