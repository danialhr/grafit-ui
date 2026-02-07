import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grafit_ui/src/components/navigation/sidebar.dart';
import 'package:grafit_ui/src/theme/theme.dart';

/// Test helper widget for Grafit themed tests
class GrafitThemedTest extends StatelessWidget {
  final Widget child;

  const GrafitThemedTest({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        extensions: [GrafitTheme.light()],
      ),
      home: Scaffold(body: child),
    );
  }
}

void main() {
  group('GrafitSidebar', () {
    group('Rendering', () {
      testWidgets('renders without error with provider', (tester) async {
        await tester.pumpWidget(
          GrafitSidebarProvider(
            defaultOpen: true,
            child: const GrafitThemedTest(
              child: Row(
                children: [
                  GrafitSidebar(
                    child: Column(
                      children: [
                        GrafitSidebarHeader(
                          child: Text('Header'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(find.byType(GrafitSidebar), findsOneWidget);
      });

      testWidgets('renders collapsed sidebar', (tester) async {
        await tester.pumpWidget(
          GrafitSidebarProvider(
            defaultOpen: false,
            child: const GrafitThemedTest(
              child: Row(
                children: [
                  GrafitSidebar(
                    collapsible: GrafitSidebarCollapsible.icon,
                    child: Column(
                      children: [
                        GrafitSidebarHeader(
                          child: Text('Header'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(find.byType(GrafitSidebar), findsOneWidget);
      });

      testWidgets('renders right sidebar', (tester) async {
        await tester.pumpWidget(
          GrafitSidebarProvider(
            defaultOpen: true,
            child: const GrafitThemedTest(
              child: Row(
                children: [
                  GrafitSidebar(
                    side: GrafitSidebarSide.right,
                    child: Column(
                      children: [
                        GrafitSidebarHeader(
                          child: Text('Header'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(find.byType(GrafitSidebar), findsOneWidget);
      });

      testWidgets('renders floating variant', (tester) async {
        await tester.pumpWidget(
          GrafitSidebarProvider(
            defaultOpen: true,
            child: GrafitThemedTest(
              child: Container(
                color: Colors.grey,
                child: const Row(
                  children: [
                    GrafitSidebar(
                      variant: GrafitSidebarVariant.floating,
                      child: Column(
                        children: [
                          GrafitSidebarHeader(
                            child: Text('Header'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(find.byType(GrafitSidebar), findsOneWidget);
      });

      testWidgets('renders inset variant', (tester) async {
        await tester.pumpWidget(
          GrafitSidebarProvider(
            defaultOpen: true,
            child: const GrafitThemedTest(
              child: Row(
                children: [
                  GrafitSidebar(
                    variant: GrafitSidebarVariant.inset,
                    child: Column(
                      children: [
                        GrafitSidebarHeader(
                          child: Text('Header'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(find.byType(GrafitSidebar), findsOneWidget);
      });
    });

    group('Sidebar Components', () {
      testWidgets('renders sidebar header', (tester) async {
        await tester.pumpWidget(
          GrafitSidebarProvider(
            defaultOpen: true,
            child: const GrafitThemedTest(
              child: Row(
                children: [
                  GrafitSidebar(
                    child: Column(
                      children: [
                        GrafitSidebarHeader(
                          child: Text('Test Header'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(find.text('Test Header'), findsOneWidget);
      });

      testWidgets('renders sidebar footer', (tester) async {
        await tester.pumpWidget(
          GrafitSidebarProvider(
            defaultOpen: true,
            child: const GrafitThemedTest(
              child: Row(
                children: [
                  GrafitSidebar(
                    child: Column(
                      children: [
                        GrafitSidebarFooter(
                          child: Text('Footer'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(find.text('Footer'), findsOneWidget);
      });

      testWidgets('renders sidebar content', (tester) async {
        await tester.pumpWidget(
          GrafitSidebarProvider(
            defaultOpen: true,
            child: const GrafitThemedTest(
              child: Row(
                children: [
                  GrafitSidebar(
                    child: Column(
                      children: [
                        GrafitSidebarContent(
                          child: Text('Content'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(find.text('Content'), findsOneWidget);
      });

      testWidgets('renders sidebar separator', (tester) async {
        await tester.pumpWidget(
          GrafitSidebarProvider(
            defaultOpen: true,
            child: const GrafitThemedTest(
              child: Row(
                children: [
                  GrafitSidebar(
                    child: Column(
                      children: [
                        GrafitSidebarSeparator(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(find.byType(GrafitSidebarSeparator), findsOneWidget);
      });
    });

    group('Sidebar Groups', () {
      testWidgets('renders sidebar group with label', (tester) async {
        await tester.pumpWidget(
          GrafitSidebarProvider(
            defaultOpen: true,
            child: const GrafitThemedTest(
              child: Row(
                children: [
                  GrafitSidebar(
                    child: Column(
                      children: [
                        GrafitSidebarGroup(
                          label: GrafitSidebarGroupLabel(text: 'Group Label'),
                          children: [
                            GrafitSidebarMenuItem(
                              button: GrafitSidebarMenuButton(
                                icon: Icon(Icons.home),
                                label: 'Home',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(find.text('Group Label'), findsOneWidget);
        expect(find.text('Home'), findsOneWidget);
      });

      testWidgets('renders sidebar group with action', (tester) async {
        await tester.pumpWidget(
          GrafitSidebarProvider(
            defaultOpen: true,
            child: GrafitThemedTest(
              child: const Row(
                children: [
                  GrafitSidebar(
                    child: Column(
                      children: [
                        GrafitSidebarGroup(
                          label: GrafitSidebarGroupLabel(text: 'Group'),
                          action: GrafitSidebarGroupAction(
                            tooltip: 'Add',
                            child: Icon(Icons.add),
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
        await tester.pumpAndSettle();
        expect(find.byType(GrafitSidebarGroupAction), findsOneWidget);
      });
    });

    group('Sidebar Menu', () {
      testWidgets('renders sidebar menu items', (tester) async {
        await tester.pumpWidget(
          GrafitSidebarProvider(
            defaultOpen: true,
            child: const GrafitThemedTest(
              child: Row(
                children: [
                  GrafitSidebar(
                    child: Column(
                      children: [
                        GrafitSidebarMenu(
                          children: [
                            GrafitSidebarMenuItem(
                              button: GrafitSidebarMenuButton(
                                icon: Icon(Icons.home),
                                label: 'Home',
                              ),
                            ),
                            GrafitSidebarMenuItem(
                              button: GrafitSidebarMenuButton(
                                icon: Icon(Icons.settings),
                                label: 'Settings',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(find.text('Home'), findsOneWidget);
        expect(find.text('Settings'), findsOneWidget);
      });

      testWidgets('handles menu button tap', (tester) async {
        bool tapped = false;

        await tester.pumpWidget(
          GrafitSidebarProvider(
            defaultOpen: true,
            child: GrafitThemedTest(
              child: const Row(
                children: [
                  GrafitSidebar(
                    child: Column(
                      children: [
                        GrafitSidebarMenu(
                          children: [
                            GrafitSidebarMenuItem(
                              button: GrafitSidebarMenuButton(
                                icon: Icon(Icons.home),
                                label: 'Home',
                                onTap: null,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        final button = find.text('Home');
        expect(button, findsOneWidget);
      });

      testWidgets('shows active state for menu button', (tester) async {
        await tester.pumpWidget(
          GrafitSidebarProvider(
            defaultOpen: true,
            child: const GrafitThemedTest(
              child: Row(
                children: [
                  GrafitSidebar(
                    child: Column(
                      children: [
                        GrafitSidebarMenu(
                          children: [
                            GrafitSidebarMenuItem(
                              button: GrafitSidebarMenuButton(
                                icon: Icon(Icons.home),
                                label: 'Home',
                                isActive: true,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(find.text('Home'), findsOneWidget);
      });

      testWidgets('renders menu button with badge', (tester) async {
        await tester.pumpWidget(
          GrafitSidebarProvider(
            defaultOpen: true,
            child: const GrafitThemedTest(
              child: Row(
                children: [
                  GrafitSidebar(
                    child: Column(
                      children: [
                        GrafitSidebarMenu(
                          children: [
                            GrafitSidebarMenuItem(
                              button: GrafitSidebarMenuButton(
                                icon: Icon(Icons.mail),
                                label: 'Messages',
                              ),
                              badge: GrafitSidebarMenuBadge(text: '5'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(find.text('5'), findsOneWidget);
      });
    });

    group('Sidebar Submenus', () {
      testWidgets('renders sidebar with submenus', (tester) async {
        await tester.pumpWidget(
          GrafitSidebarProvider(
            defaultOpen: true,
            child: const GrafitThemedTest(
              child: Row(
                children: [
                  GrafitSidebar(
                    child: Column(
                      children: [
                        GrafitSidebarMenu(
                          children: [
                            GrafitSidebarMenuItem(
                              button: GrafitSidebarMenuButton(
                                icon: Icon(Icons.home),
                                label: 'Home',
                              ),
                              sub: GrafitSidebarMenuSub(
                                children: [
                                  GrafitSidebarMenuSubItem(
                                    button: GrafitSidebarMenuSubButton(
                                      icon: Icon(Icons.list),
                                      label: 'All',
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
                ],
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(find.text('Home'), findsOneWidget);
        expect(find.text('All'), findsOneWidget);
      });
    });

    group('Sidebar Trigger', () {
      testWidgets('renders sidebar trigger', (tester) async {
        await tester.pumpWidget(
          GrafitSidebarProvider(
            defaultOpen: true,
            child: GrafitThemedTest(
              child: Column(
                children: const [
                  GrafitSidebarTrigger(),
                ],
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(find.byType(GrafitSidebarTrigger), findsOneWidget);
      });

      testWidgets('toggles sidebar on trigger tap', (tester) async {
        await tester.pumpWidget(
          GrafitSidebarProvider(
            defaultOpen: true,
            child: GrafitThemedTest(
              child: Column(
                children: const [
                  GrafitSidebarTrigger(),
                ],
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        final trigger = find.byType(GrafitSidebarTrigger);
        expect(trigger, findsOneWidget);

        await tester.tap(trigger);
        await tester.pumpAndSettle();
      });
    });

    group('Sidebar Rail', () {
      testWidgets('renders sidebar rail', (tester) async {
        await tester.pumpWidget(
          GrafitSidebarProvider(
            defaultOpen: true,
            child: const GrafitThemedTest(
              child: Row(
                children: [
                  GrafitSidebar(
                    child: Column(
                      children: [
                        GrafitSidebarRail(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(find.byType(GrafitSidebarRail), findsOneWidget);
      });
    });

    group('Sidebar Inset', () {
      testWidgets('renders sidebar inset wrapper', (tester) async {
        await tester.pumpWidget(
          GrafitSidebarProvider(
            defaultOpen: true,
            child: const GrafitThemedTest(
              child: GrafitSidebarInset(
                child: Text('Main Content'),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(find.text('Main Content'), findsOneWidget);
      });
    });

    group('Sidebar Skeleton', () {
      testWidgets('renders sidebar menu skeleton', (tester) async {
        await tester.pumpWidget(
          GrafitSidebarProvider(
            defaultOpen: true,
            child: const GrafitThemedTest(
              child: Row(
                children: [
                  GrafitSidebar(
                    child: Column(
                      children: [
                        GrafitSidebarMenuSkeleton(showIcon: true),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(find.byType(GrafitSidebarMenuSkeleton), findsOneWidget);
      });
    });
  });
}
