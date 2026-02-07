import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:grafit_ui/grafit_ui.dart';

Widget tabsUseCase(BuildContext context) {
  final variant = context.knobs.object.dropdown(
    label: 'Variant',
    defaultValue: GrafitTabsVariant.value,
    values: GrafitTabsVariant.values.toList(),
    labelBuilder: (v) => v.name,
  );
  
  final orientation = context.knobs.object.dropdown(
    label: 'Orientation',
    defaultValue: GrafitTabsOrientation.horizontal,
    values: GrafitTabsOrientation.values.toList(),
    labelBuilder: (v) => v.name,
  );

  final tabs = [
    GrafitTab(
      label: 'Account',
      content: _buildTabContent('Account Settings', [
        'Profile Information',
        'Email Preferences',
        'Password',
        'Linked Accounts',
      ]),
    ),
    GrafitTab(
      label: 'Password',
      content: _buildTabContent('Password Settings', [
        'Current Password',
        'New Password',
        'Confirm Password',
        'Two-Factor Authentication',
      ]),
    ),
    GrafitTab(
      label: 'Appearance',
      content: _buildTabContent('Appearance Settings', [
        'Theme',
        'Font Size',
        'Language',
        'Accessibility',
      ]),
    ),
  ];

  return Scaffold(
    body: Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Individual tabs preview
            SizedBox(
              height: orientation == GrafitTabsOrientation.vertical ? 300 : 250,
              child: GrafitTabs(
                variant: variant,
                orientation: orientation,
                tabs: tabs,
              ),
            ),
            const SizedBox(height: 48),
            
            // Horizontal variants showcase
            const Text(
              'Horizontal Variants',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: GrafitTabs(
                variant: GrafitTabsVariant.value,
                tabs: [
                  GrafitTab(
                    label: 'Overview',
                    content: _buildSimpleContent('Overview content goes here.'),
                  ),
                  GrafitTab(
                    label: 'Features',
                    content: _buildSimpleContent('Features list goes here.'),
                  ),
                  GrafitTab(
                    label: 'Pricing',
                    content: _buildSimpleContent('Pricing information goes here.'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 200,
              child: GrafitTabs(
                variant: GrafitTabsVariant.line,
                tabs: [
                  GrafitTab(
                    label: 'Details',
                    content: _buildSimpleContent('Details content goes here.'),
                  ),
                  GrafitTab(
                    label: 'Reviews',
                    content: _buildSimpleContent('Reviews content goes here.'),
                  ),
                  GrafitTab(
                    label: 'Specs',
                    content: _buildSimpleContent('Specifications content goes here.'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            
            // Vertical tabs showcase
            const Text(
              'Vertical Tabs',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 250,
              child: GrafitTabs(
                variant: GrafitTabsVariant.value,
                orientation: GrafitTabsOrientation.vertical,
                tabs: [
                  GrafitTab(
                    label: 'Dashboard',
                    content: _buildSimpleContent('Dashboard widgets and stats.'),
                  ),
                  GrafitTab(
                    label: 'Projects',
                    content: _buildSimpleContent('Your active projects.'),
                  ),
                  GrafitTab(
                    label: 'Team',
                    content: _buildSimpleContent('Team members and roles.'),
                  ),
                  GrafitTab(
                    label: 'Settings',
                    content: _buildSimpleContent('Application settings.'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            
            // With icons
            const Text(
              'Tabs with Rich Content',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 220,
              child: GrafitTabs(
                tabs: [
                  GrafitTab(
                    label: 'Home',
                    content: _buildRichTabContent(
                      icon: Icons.home,
                      title: 'Welcome Home',
                      description: 'This is your personalized dashboard showing all your important information at a glance.',
                    ),
                  ),
                  GrafitTab(
                    label: 'Analytics',
                    content: _buildRichTabContent(
                      icon: Icons.analytics,
                      title: 'Analytics Overview',
                      description: 'View detailed analytics and insights about your usage and performance.',
                    ),
                  ),
                  GrafitTab(
                    label: 'Reports',
                    content: _buildRichTabContent(
                      icon: Icons.assessment,
                      title: 'Generated Reports',
                      description: 'Access and download all your generated reports in various formats.',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget _buildTabContent(String title, List<String> items) {
  return Padding(
    padding: const EdgeInsets.all(24),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ...items.map((item) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              const Icon(Icons.chevron_right, size: 20),
              const SizedBox(width: 8),
              Text(item),
            ],
          ),
        )),
      ],
    ),
  );
}

Widget _buildSimpleContent(String text) {
  return Padding(
    padding: const EdgeInsets.all(24),
    child: Center(
      child: Text(
        text,
        style: const TextStyle(fontSize: 16),
      ),
    ),
  );
}

Widget _buildRichTabContent({
  required IconData icon,
  required String title,
  required String description,
}) {
  return Padding(
    padding: const EdgeInsets.all(32),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.blue.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 48, color: Colors.blue),
        ),
        const SizedBox(height: 24),
        Text(
          title,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        Text(
          description,
          style: const TextStyle(fontSize: 14, color: Colors.grey),
          textAlign: TextAlign.center,
        ),
      ],
    ),
  );
}
