import 'package:flutter/material.dart';
import 'package:pikpo_ui/pikpo_ui.dart';

class ComponentsPage extends StatefulWidget {
  const ComponentsPage({super.key});

  @override
  State<ComponentsPage> createState() => _ComponentsPageState();
}

class _ComponentsPageState extends State<ComponentsPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<GrafitTheme>()!;

    return Scaffold(
      backgroundColor: theme.colors.background,
      appBar: AppBar(
        backgroundColor: theme.colors.background,
        title: GrafitText.titleLarge('Components'),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            // Search
            GrafitInput(
              hint: 'Search components...',
              prefix: const Icon(Icons.search, size: 18),
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.toLowerCase();
                });
              },
            ),
            const SizedBox(height: 24),

            // Component list
            Expanded(
              child: _buildComponentList(context, theme),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildComponentList(BuildContext context, GrafitTheme theme) {
    final categories = _getComponentCategories();
    final filteredCategories = <String, List<ComponentInfo>>{};

    for (final entry in categories.entries) {
      final filteredComponents = entry.value
          .where((comp) =>
              comp.name.toLowerCase().contains(_searchQuery) ||
              comp.description.toLowerCase().contains(_searchQuery))
          .toList();

      if (filteredComponents.isNotEmpty) {
        filteredCategories[entry.key] = filteredComponents;
      }
    }

    if (filteredCategories.isEmpty) {
      return Center(
        child: GrafitText.muted('No components found'),
      );
    }

    return ListView.builder(
      itemCount: filteredCategories.length,
      itemBuilder: (context, index) {
        final category = filteredCategories.keys.elementAt(index);
        final components = filteredCategories[category]!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GrafitText.headlineSmall(category),
            const SizedBox(height: 16),
            ...components.map((comp) => _buildComponentCard(context, theme, comp)),
            const SizedBox(height: 24),
          ],
        );
      },
    );
  }

  Widget _buildComponentCard(
    BuildContext context,
    GrafitTheme theme,
    ComponentInfo info,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colors.card,
        border: Border.all(color: theme.colors.border),
        borderRadius: BorderRadius.circular(theme.colors.radius * 8),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GrafitText.titleMedium(info.name),
                const SizedBox(height: 4),
                GrafitText.muted(info.description),
              ],
            ),
          ),
          const SizedBox(width: 16),
          GrafitButton(
            label: 'View',
            variant: GrafitButtonVariant.ghost,
            size: GrafitButtonSize.sm,
            onPressed: () {
              // Show component details
            },
          ),
        ],
      ),
    );
  }

  Map<String, List<ComponentInfo>> _getComponentCategories() {
    return {
      'Form': [
        ComponentInfo('button', 'Button with variants'),
        ComponentInfo('input', 'Text input field'),
        ComponentInfo('checkbox', 'Checkbox input'),
        ComponentInfo('switch', 'Toggle switch'),
      ],
      'Typography': [
        ComponentInfo('text', 'Text with styles'),
        ComponentInfo('heading', 'Heading component'),
      ],
      'Layout': [
        ComponentInfo('card', 'Card container'),
        ComponentInfo('separator', 'Visual divider'),
      ],
      'Overlay': [
        ComponentInfo('dialog', 'Modal dialog'),
        ComponentInfo('popover', 'Popover overlay'),
      ],
    };
  }
}

class ComponentInfo {
  final String name;
  final String description;

  ComponentInfo(this.name, this.description);
}
