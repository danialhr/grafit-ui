import 'package:flutter/material.dart';
import 'package:grafit_ui/grafit_ui.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<GrafitTheme>()!;

    return Scaffold(
      backgroundColor: theme.colors.background,
      body: GrafitScrollArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              GrafitText.headlineLarge(
                'Grafit UI',
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 8),
              GrafitText.muted(
                'Flutter port of shadcn/ui - Beautiful, accessible components',
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 32),

              // Feature cards
              _buildFeatureCards(context, theme),

              const SizedBox(height: 32),

              // Component categories
              GrafitText.titleLarge('Component Categories'),
              const SizedBox(height: 16),
              _buildCategoryGrid(context, theme),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureCards(BuildContext context, GrafitTheme theme) {
    final features = [
      FeatureCard(
        icon: Icons.palette_outlined,
        title: 'Beautiful Design',
        description: 'Carefully crafted components following design best practices',
      ),
      FeatureCard(
        icon: Icons.accessibility_new,
        title: 'Accessible',
        description: 'WCAG compliant components with proper ARIA labels',
      ),
      FeatureCard(
        icon: Icons.code,
        title: 'Copy & Paste',
        description: 'Easy to integrate into your existing Flutter project',
      ),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1.5,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: features.length,
      itemBuilder: (context, index) {
        final feature = features[index];
        return GrafitCard(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(feature.icon, size: 32, color: theme.colors.primary),
                const SizedBox(height: 12),
                GrafitText.titleMedium(feature.title),
                const SizedBox(height: 8),
                GrafitText.muted(feature.description),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCategoryGrid(BuildContext context, GrafitTheme theme) {
    final categories = [
      CategoryCard(
        title: 'Form Components',
        description: 'Button, Input, Checkbox, Switch, Slider, etc.',
        icon: Icons.edit_outlined,
        route: '/form',
        color: theme.colors.primary,
      ),
      CategoryCard(
        title: 'Navigation',
        description: 'Tabs, Breadcrumb, Dropdown Menu, Menubar',
        icon: Icons.navigation_outlined,
        route: '/navigation',
        color: theme.colors.secondary,
      ),
      CategoryCard(
        title: 'Overlay',
        description: 'Dialog, Popover, Tooltip, Alert Dialog',
        icon: Icons.layers_outlined,
        route: '/overlay',
        color: theme.colors.accent,
      ),
      CategoryCard(
        title: 'Feedback',
        description: 'Alert, Progress, Skeleton, Sonner',
        icon: Icons.notifications_outlined,
        route: '/feedback',
        color: theme.colors.destructive,
      ),
      CategoryCard(
        title: 'Data Display',
        description: 'Badge, Avatar, Data Table, Pagination, Chart',
        icon: Icons.table_chart_outlined,
        route: '/data-display',
        color: const Color(0xFF8b5cf6),
      ),
      CategoryCard(
        title: 'Specialized',
        description: 'Resizable, Scroll Area, Drawer, Sheet, Calendar, Carousel',
        icon: Icons.widgets_outlined,
        route: '/specialized',
        color: const Color(0xFF06b6d4),
      ),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.6,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        return GestureDetector(
          onTap: () => Navigator.pushNamed(context, category.route),
          child: GrafitCard(
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  left: BorderSide(color: category.color, width: 4),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: category.color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(category.icon, color: category.color),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GrafitText.titleMedium(category.title),
                          const SizedBox(height: 4),
                          GrafitText.muted(
                            category.description,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.chevron_right, color: theme.colors.mutedForeground),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class FeatureCard {
  final IconData icon;
  final String title;
  final String description;

  FeatureCard({
    required this.icon,
    required this.title,
    required this.description,
  });
}

class CategoryCard {
  final String title;
  final String description;
  final IconData icon;
  final String route;
  final Color color;

  CategoryCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.route,
    required this.color,
  });
}
