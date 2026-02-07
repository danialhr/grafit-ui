import 'package:flutter/material.dart';
import 'package:grafit_ui/grafit_ui.dart';

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({super.key});

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
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
              onChanged: (index) {},
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
                GrafitBreadcrumbItem(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.home, size: 16),
                      SizedBox(width: 4),
                      Text('Home'),
                    ],
                  ),
                ),
                GrafitBreadcrumbItem(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.widgets, size: 16),
                      SizedBox(width: 4),
                      Text('Components'),
                    ],
                  ),
                ),
                GrafitBreadcrumbItem(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.navigation, size: 16),
                      SizedBox(width: 4),
                      Text('Navigation'),
                    ],
                  ),
                ),
                GrafitBreadcrumbItem(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.description, size: 16),
                      SizedBox(width: 4),
                      Text('Breadcrumb'),
                    ],
                  ),
                  isActive: true,
                ),
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
                GrafitDropdownMenu(
                  trigger: GrafitButton(
                    label: _selectedDropdown ?? 'Select Option',
                    variant: GrafitButtonVariant.outline,
                    trailing: const Icon(Icons.expand_more, size: 16),
                    onPressed: () {},
                  ),
                  children: [
                    GrafiDropdownMenuItem(
                      label: 'Profile',
                      leading: const Icon(Icons.person, size: 16),
                      onSelected: () => setState(() => _selectedDropdown = 'Profile'),
                    ),
                    GrafiDropdownMenuItem(
                      label: 'Settings',
                      leading: const Icon(Icons.settings, size: 16),
                      onSelected: () => setState(() => _selectedDropdown = 'Settings'),
                    ),
                    GrafiDropdownMenuItem(
                      label: 'Billing',
                      leading: const Icon(Icons.payment, size: 16),
                      onSelected: () => setState(() => _selectedDropdown = 'Billing'),
                    ),
                    const GrafitDropdownMenuSeparator(),
                    GrafiDropdownMenuItem(
                      label: 'Logout',
                      leading: const Icon(Icons.logout, size: 16),
                      onSelected: () => setState(() => _selectedDropdown = 'Logout'),
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
            GrafitNavigationMenu(
              children: [
                GrafitNavigationMenuItem(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GrafitNavigationMenuTrigger(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(Icons.home, size: 18),
                            SizedBox(width: 6),
                            Text('Home'),
                          ],
                        ),
                      ),
                      GrafitNavigationMenuContent(
                        child: Container(
                          width: 200,
                          padding: const EdgeInsets.all(8),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              GrafitNavigationMenuLink(
                                title: 'Dashboard',
                                onSelect: null,
                              ),
                              SizedBox(height: 4),
                              GrafitNavigationMenuLink(
                                title: 'Analytics',
                                onSelect: null,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                GrafitNavigationMenuItem(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GrafitNavigationMenuTrigger(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(Icons.widgets, size: 18),
                            SizedBox(width: 6),
                            Text('Components'),
                          ],
                        ),
                      ),
                      GrafitNavigationMenuContent(
                        child: Container(
                          width: 200,
                          padding: const EdgeInsets.all(8),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              GrafitNavigationMenuLink(
                                title: 'Buttons',
                                onSelect: null,
                              ),
                              SizedBox(height: 4),
                              GrafitNavigationMenuLink(
                                title: 'Inputs',
                                onSelect: null,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                GrafitNavigationMenuItem(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GrafitNavigationMenuTrigger(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(Icons.settings, size: 18),
                            SizedBox(width: 6),
                            Text('Settings'),
                          ],
                        ),
                      ),
                      GrafitNavigationMenuContent(
                        child: Container(
                          width: 200,
                          padding: const EdgeInsets.all(8),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              GrafitNavigationMenuLink(
                                title: 'Profile',
                                onSelect: null,
                              ),
                              SizedBox(height: 4),
                              GrafitNavigationMenuLink(
                                title: 'Preferences',
                                onSelect: null,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
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
            GrafitMenubar(
              children: [
                GrafitMenubarMenu(
                  trigger: const GrafitMenubarTrigger(child: Text('File')),
                  children: const [
                    GrafitMenubarItem(
                      label: 'New Tab',
                      leading: Icon(Icons.tab, size: 16),
                      shortcut: 'Cmd+T',
                    ),
                    GrafitMenubarItem(
                      label: 'New Window',
                      leading: Icon(Icons.open_in_new, size: 16),
                      shortcut: 'Cmd+N',
                    ),
                    GrafitMenubarSeparator(),
                    GrafitMenubarItem(
                      label: 'Print',
                      leading: Icon(Icons.print, size: 16),
                      shortcut: 'Cmd+P',
                    ),
                  ],
                ),
                GrafitMenubarMenu(
                  trigger: const GrafitMenubarTrigger(child: Text('Edit')),
                  children: const [
                    GrafitMenubarItem(
                      label: 'Undo',
                      leading: Icon(Icons.undo, size: 16),
                      shortcut: 'Cmd+Z',
                    ),
                    GrafitMenubarItem(
                      label: 'Redo',
                      leading: Icon(Icons.redo, size: 16),
                      shortcut: 'Cmd+Y',
                    ),
                    GrafitMenubarSeparator(),
                    GrafitMenubarItem(
                      label: 'Cut',
                      leading: Icon(Icons.content_cut, size: 16),
                      shortcut: 'Cmd+X',
                    ),
                    GrafitMenubarItem(
                      label: 'Copy',
                      leading: Icon(Icons.content_copy, size: 16),
                      shortcut: 'Cmd+C',
                    ),
                    GrafitMenubarItem(
                      label: 'Paste',
                      leading: Icon(Icons.content_paste, size: 16),
                      shortcut: 'Cmd+V',
                    ),
                  ],
                ),
                GrafitMenubarMenu(
                  trigger: const GrafitMenubarTrigger(child: Text('View')),
                  children: const [
                    GrafitMenubarItem(
                      label: 'Fullscreen',
                      leading: Icon(Icons.fullscreen, size: 16),
                      shortcut: 'F11',
                    ),
                    GrafitMenubarItem(
                      label: 'Zoom In',
                      leading: Icon(Icons.zoom_in, size: 16),
                      shortcut: 'Cmd++',
                    ),
                    GrafitMenubarItem(
                      label: 'Zoom Out',
                      leading: Icon(Icons.zoom_out, size: 16),
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
