import 'package:flutter/material.dart';
import 'package:grafit_ui/grafit_ui.dart';

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({super.key});

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  int _selectedTab = 0;
  String? _selectedDropdown;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<GrafitTheme>()!;

    return Scaffold(
      backgroundColor: theme.colors.background,
      appBar: AppBar(
        backgroundColor: theme.colors.background,
        title: const Text('Navigation Components'),
        elevation: 0,
      ),
      body: GrafitScrollArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Tabs Section
              _buildSectionHeader('Tabs'),
              const SizedBox(height: 16),
              _buildTabsSection(context, theme),
              const SizedBox(height: 32),

              // Breadcrumb Section
              _buildSectionHeader('Breadcrumb'),
              const SizedBox(height: 16),
              _buildBreadcrumbSection(context, theme),
              const SizedBox(height: 32),

              // Dropdown Menu Section
              _buildSectionHeader('Dropdown Menu'),
              const SizedBox(height: 16),
              _buildDropdownSection(context, theme),
              const SizedBox(height: 32),

              // Navigation Menu Section
              _buildSectionHeader('Navigation Menu'),
              const SizedBox(height: 16),
              _buildNavigationMenuSection(context, theme),
              const SizedBox(height: 32),

              // Menubar Section
              _buildSectionHeader('Menubar'),
              const SizedBox(height: 16),
              _buildMenubarSection(context, theme),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return GrafitText.headlineSmall(title);
  }

  Widget _buildTabsSection(BuildContext context, GrafitTheme theme) {
    return GrafitCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GrafitText.titleMedium('Default Tabs'),
            const SizedBox(height: 16),
            GrafitTabs(
              tabs: [
                GrafitTab(
                  label: 'Account',
                  content: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GrafitText.titleMedium('Account Settings'),
                        const SizedBox(height: 8),
                        GrafitText.muted('Manage your account settings and preferences.'),
                      ],
                    ),
                  ),
                ),
                GrafitTab(
                  label: 'Password',
                  content: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GrafitText.titleMedium('Password Settings'),
                        const SizedBox(height: 8),
                        GrafitText.muted('Change your password and security settings.'),
                      ],
                    ),
                  ),
                ),
                GrafitTab(
                  label: 'Notifications',
                  content: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GrafitText.titleMedium('Notification Settings'),
                        const SizedBox(height: 8),
                        GrafitText.muted('Configure how you receive notifications.'),
                      ],
                    ),
                  ),
                ),
              ],
              onChanged: (index) => setState(() => _selectedTab = index),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBreadcrumbSection(BuildContext context, GrafitTheme theme) {
    return GrafitCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GrafitText.titleMedium('Breadcrumb'),
            const SizedBox(height: 16),
            const GrafitBreadcrumb(
              items: [
                GrafitBreadcrumbItem(label: 'Home', icon: Icons.home),
                GrafitBreadcrumbItem(label: 'Components', icon: Icons.widgets),
                GrafitBreadcrumbItem(label: 'Navigation', icon: Icons.navigation),
                GrafitBreadcrumbItem(label: 'Breadcrumb', isActive: true),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdownSection(BuildContext context, GrafitTheme theme) {
    return GrafitCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GrafitText.titleMedium('Dropdown Menu'),
            const SizedBox(height: 16),
            Row(
              children: [
                GrafitDropdownMenu<String>(
                  trigger: GrafitButton(
                    label: _selectedDropdown ?? 'Select Option',
                    variant: GrafitButtonVariant.outline,
                    trailing: const Icon(Icons.expand_more, size: 16),
                    onPressed: () {},
                  ),
                  items: [
                    GrafitDropdownMenuItem(
                      value: 'profile',
                      label: 'Profile',
                      icon: Icons.person,
                      onTap: () => setState(() => _selectedDropdown = 'Profile'),
                    ),
                    GrafitDropdownMenuItem(
                      value: 'settings',
                      label: 'Settings',
                      icon: Icons.settings,
                      onTap: () => setState(() => _selectedDropdown = 'Settings'),
                    ),
                    GrafitDropdownMenuItem(
                      value: 'billing',
                      label: 'Billing',
                      icon: Icons.payment,
                      onTap: () => setState(() => _selectedDropdown = 'Billing'),
                    ),
                    const GrafitDropdownMenuDivider(),
                    GrafitDropdownMenuItem(
                      value: 'logout',
                      label: 'Logout',
                      icon: Icons.logout,
                      onTap: () => setState(() => _selectedDropdown = 'Logout'),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationMenuSection(BuildContext context, GrafitTheme theme) {
    return GrafitCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GrafitText.titleMedium('Navigation Menu'),
            const SizedBox(height: 16),
            const GrafitNavigationMenu(
              items: [
                GrafitNavigationMenuItem(
                  label: 'Home',
                  icon: Icons.home,
                  href: '/',
                ),
                GrafitNavigationMenuItem(
                  label: 'Components',
                  icon: Icons.widgets,
                  href: '/components',
                ),
                GrafitNavigationMenuItem(
                  label: 'Documentation',
                  icon: Icons.description,
                  href: '/docs',
                ),
                GrafitNavigationMenuItem(
                  label: 'Settings',
                  icon: Icons.settings,
                  href: '/settings',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenubarSection(BuildContext context, GrafitTheme theme) {
    return GrafitCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GrafitText.titleMedium('Menubar'),
            const SizedBox(height: 16),
            const GrafitMenubar(
              items: [
                GrafitMenubarItem(
                  label: 'File',
                  shortcut: 'Alt+F',
                  items: [
                    GrafitMenubarMenuItem(
                      label: 'New Tab',
                      icon: Icons.tab,
                      shortcut: 'Cmd+T',
                    ),
                    GrafitMenubarMenuItem(
                      label: 'New Window',
                      icon: Icons.open_in_new,
                      shortcut: 'Cmd+N',
                    ),
                    const GrafitMenubarDivider(),
                    GrafitMenubarMenuItem(
                      label: 'Print',
                      icon: Icons.print,
                      shortcut: 'Cmd+P',
                    ),
                  ],
                ),
                GrafitMenubarItem(
                  label: 'Edit',
                  shortcut: 'Alt+E',
                  items: [
                    GrafitMenubarMenuItem(
                      label: 'Undo',
                      icon: Icons.undo,
                      shortcut: 'Cmd+Z',
                    ),
                    GrafitMenubarMenuItem(
                      label: 'Redo',
                      icon: Icons.redo,
                      shortcut: 'Cmd+Y',
                    ),
                    const GrafitMenubarDivider(),
                    GrafitMenubarMenuItem(
                      label: 'Cut',
                      icon: Icons.content_cut,
                      shortcut: 'Cmd+X',
                    ),
                    GrafitMenubarMenuItem(
                      label: 'Copy',
                      icon: Icons.content_copy,
                      shortcut: 'Cmd+C',
                    ),
                    GrafitMenubarMenuItem(
                      label: 'Paste',
                      icon: Icons.content_paste,
                      shortcut: 'Cmd+V',
                    ),
                  ],
                ),
                GrafitMenubarItem(
                  label: 'View',
                  shortcut: 'Alt+V',
                  items: [
                    GrafitMenubarMenuItem(
                      label: 'Fullscreen',
                      icon: Icons.fullscreen,
                      shortcut: 'F11',
                    ),
                    GrafitMenubarMenuItem(
                      label: 'Zoom In',
                      icon: Icons.zoom_in,
                      shortcut: 'Cmd++',
                    ),
                    GrafitMenubarMenuItem(
                      label: 'Zoom Out',
                      icon: Icons.zoom_out,
                      shortcut: 'Cmd+-',
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
