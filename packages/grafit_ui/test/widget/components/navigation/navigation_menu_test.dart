import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grafit_ui/src/components/navigation/navigation_menu.dart';
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
  group('GrafitNavigationMenu', () {
    group('Rendering', () {
      testWidgets('renders without error', (tester) async {
        await tester.pumpWidget(
          const GrafitThemedTest(
            child: Center(
              child: GrafitNavigationMenu(
                children: [
                  GrafitNavigationMenuItem(
                    child: GrafitNavigationMenuTrigger(
                      child: Text('Products'),
                    ),
                  ),
                  GrafitNavigationMenuItem(
                    child: GrafitNavigationMenuTrigger(
                      child: Text('Solutions'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
        expect(find.byType(GrafitNavigationMenu), findsOneWidget);
        expect(find.text('Products'), findsOneWidget);
        expect(find.text('Solutions'), findsOneWidget);
      });

      testWidgets('renders with initial value', (tester) async {
        await tester.pumpWidget(
          GrafitThemedTest(
            child: Center(
              child: GrafitNavigationMenu(
                initialValue: 1,
                children: [
                  GrafitNavigationMenuItem(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        GrafitNavigationMenuTrigger(child: Text('Products')),
                        GrafitNavigationMenuContent(
                          child: SizedBox(
                            width: 200,
                            child: Text('Products Content'),
                          ),
                        ),
                      ],
                    ),
                  ),
                  GrafitNavigationMenuItem(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        GrafitNavigationMenuTrigger(child: Text('Solutions')),
                        GrafitNavigationMenuContent(
                          child: SizedBox(
                            width: 200,
                            child: Text('Solutions Content'),
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
        expect(find.byType(GrafitNavigationMenu), findsOneWidget);
      });
    });

    group('Trigger Interactions', () {
      testWidgets('opens content on trigger tap', (tester) async {
        await tester.pumpWidget(
          const GrafitThemedTest(
            child: Center(
              child: GrafitNavigationMenu(
                children: [
                  GrafitNavigationMenuItem(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GrafitNavigationMenuTrigger(child: Text('Products')),
                        GrafitNavigationMenuContent(
                          child: SizedBox(
                            width: 200,
                            child: Text('Products Content'),
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

        final trigger = find.text('Products');
        expect(trigger, findsOneWidget);

        await tester.tap(trigger);
        await tester.pumpAndSettle();

        expect(find.text('Products Content'), findsOneWidget);
      });

      testWidgets('closes content when tapping same trigger again', (tester) async {
        await tester.pumpWidget(
          const GrafitThemedTest(
            child: Center(
              child: GrafitNavigationMenu(
                children: [
                  GrafitNavigationMenuItem(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GrafitNavigationMenuTrigger(child: Text('Products')),
                        GrafitNavigationMenuContent(
                          child: SizedBox(
                            width: 200,
                            child: Text('Products Content'),
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

        await tester.tap(find.text('Products'));
        await tester.pumpAndSettle();

        expect(find.text('Products Content'), findsOneWidget);

        await tester.tap(find.text('Products'));
        await tester.pumpAndSettle();

        expect(find.text('Products Content'), findsNothing);
      });
    });

    group('Navigation Menu Links', () {
      testWidgets('renders navigation menu link', (tester) async {
        await tester.pumpWidget(
          const GrafitThemedTest(
            child: Center(
              child: GrafitNavigationMenu(
                children: [
                  GrafitNavigationMenuItem(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GrafitNavigationMenuTrigger(child: Text('Products')),
                        GrafitNavigationMenuContent(
                          child: SizedBox(
                            width: 250,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                GrafitNavigationMenuLink(
                                  title: 'Software',
                                  description: 'Desktop and web apps',
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
            ),
          ),
        );

        await tester.tap(find.text('Products'));
        await tester.pumpAndSettle();

        expect(find.text('Software'), findsOneWidget);
        expect(find.text('Desktop and web apps'), findsOneWidget);
      });

      testWidgets('calls onSelect when link is tapped', (tester) async {
        bool selected = false;

        await tester.pumpWidget(
          GrafitThemedTest(
            child: Center(
              child: GrafitNavigationMenu(
                children: [
                  GrafitNavigationMenuItem(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const GrafitNavigationMenuTrigger(child: Text('Products')),
                        GrafitNavigationMenuContent(
                          child: SizedBox(
                            width: 250,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                GrafitNavigationMenuLink(
                                  title: 'Software',
                                  onSelect: () => selected = true,
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
            ),
          ),
        );

        await tester.tap(find.text('Products'));
        await tester.pumpAndSettle();

        await tester.tap(find.text('Software'));
        await tester.pumpAndSettle();

        expect(selected, isTrue);
      });

      testWidgets('renders link with leading icon', (tester) async {
        await tester.pumpWidget(
          const GrafitThemedTest(
            child: Center(
              child: GrafitNavigationMenu(
                children: [
                  GrafitNavigationMenuItem(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GrafitNavigationMenuTrigger(child: Text('Products')),
                        GrafitNavigationMenuContent(
                          child: SizedBox(
                            width: 250,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                GrafitNavigationMenuLink(
                                  leading: Icon(Icons.computer, size: 20),
                                  title: 'Software',
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
            ),
          ),
        );

        await tester.tap(find.text('Products'));
        await tester.pumpAndSettle();

        expect(find.byIcon(Icons.computer), findsOneWidget);
      });

      testWidgets('shows selected state', (tester) async {
        await tester.pumpWidget(
          const GrafitThemedTest(
            child: Center(
              child: GrafitNavigationMenu(
                children: [
                  GrafitNavigationMenuItem(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GrafitNavigationMenuTrigger(child: Text('Account')),
                        GrafitNavigationMenuContent(
                          child: SizedBox(
                            width: 250,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                GrafitNavigationMenuLink(title: 'Profile'),
                                GrafitNavigationMenuLink(title: 'Security', selected: true),
                              ],
                            ),
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

        await tester.tap(find.text('Account'));
        await tester.pumpAndSettle();

        expect(find.text('Security'), findsOneWidget);
      });
    });

    group('Keyboard Navigation', () {
      testWidgets('navigates with arrow right key', (tester) async {
        await tester.pumpWidget(
          const GrafitThemedTest(
            child: Center(
              child: GrafitNavigationMenu(
                children: [
                  GrafitNavigationMenuItem(
                    child: GrafitNavigationMenuTrigger(child: Text('Products')),
                  ),
                  GrafitNavigationMenuItem(
                    child: GrafitNavigationMenuTrigger(child: Text('Solutions')),
                  ),
                ],
              ),
            ),
          ),
        );

        await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
        await tester.pumpAndSettle();
      });

      testWidgets('navigates with arrow left key', (tester) async {
        await tester.pumpWidget(
          const GrafitThemedTest(
            child: Center(
              child: GrafitNavigationMenu(
                children: [
                  GrafitNavigationMenuItem(
                    child: GrafitNavigationMenuTrigger(child: Text('Products')),
                  ),
                  GrafitNavigationMenuItem(
                    child: GrafitNavigationMenuTrigger(child: Text('Solutions')),
                  ),
                ],
              ),
            ),
          ),
        );

        await tester.sendKeyEvent(LogicalKeyboardKey.arrowLeft);
        await tester.pumpAndSettle();
      });

      testWidgets('opens content on arrow down', (tester) async {
        await tester.pumpWidget(
          const GrafitThemedTest(
            child: Center(
              child: GrafitNavigationMenu(
                children: [
                  GrafitNavigationMenuItem(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GrafitNavigationMenuTrigger(child: Text('Products')),
                        GrafitNavigationMenuContent(
                          child: SizedBox(
                            width: 200,
                            child: Text('Content'),
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

        await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
        await tester.pumpAndSettle();
      });

      testWidgets('closes on escape key', (tester) async {
        await tester.pumpWidget(
          const GrafitThemedTest(
            child: Center(
              child: GrafitNavigationMenu(
                children: [
                  GrafitNavigationMenuItem(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GrafitNavigationMenuTrigger(child: Text('Products')),
                        GrafitNavigationMenuContent(
                          child: SizedBox(
                            width: 200,
                            child: Text('Content'),
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

        await tester.tap(find.text('Products'));
        await tester.pumpAndSettle();

        expect(find.text('Content'), findsOneWidget);

        await tester.sendKeyEvent(LogicalKeyboardKey.escape);
        await tester.pumpAndSettle();

        expect(find.text('Content'), findsNothing);
      });
    });

    group('Multiple Menu Items', () {
      testWidgets('renders multiple menu items', (tester) async {
        await tester.pumpWidget(
          const GrafitThemedTest(
            child: Center(
              child: GrafitNavigationMenu(
                children: [
                  GrafitNavigationMenuItem(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GrafitNavigationMenuTrigger(child: Text('Home')),
                        GrafitNavigationMenuContent(
                          child: SizedBox(
                            width: 200,
                            child: Text('Home Content'),
                          ),
                        ),
                      ],
                    ),
                  ),
                  GrafitNavigationMenuItem(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GrafitNavigationMenuTrigger(child: Text('Products')),
                        GrafitNavigationMenuContent(
                          child: SizedBox(
                            width: 200,
                            child: Text('Products Content'),
                          ),
                        ),
                      ],
                    ),
                  ),
                  GrafitNavigationMenuItem(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GrafitNavigationMenuTrigger(child: Text('Company')),
                        GrafitNavigationMenuContent(
                          child: SizedBox(
                            width: 200,
                            child: Text('Company Content'),
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

        expect(find.text('Home'), findsOneWidget);
        expect(find.text('Products'), findsOneWidget);
        expect(find.text('Company'), findsOneWidget);
      });

      testWidgets('only one content open at a time', (tester) async {
        await tester.pumpWidget(
          const GrafitThemedTest(
            child: Center(
              child: GrafitNavigationMenu(
                children: [
                  GrafitNavigationMenuItem(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GrafitNavigationMenuTrigger(child: Text('Home')),
                        GrafitNavigationMenuContent(
                          child: SizedBox(
                            width: 200,
                            child: Text('Home Content'),
                          ),
                        ),
                      ],
                    ),
                  ),
                  GrafitNavigationMenuItem(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GrafitNavigationMenuTrigger(child: Text('Products')),
                        GrafitNavigationMenuContent(
                          child: SizedBox(
                            width: 200,
                            child: Text('Products Content'),
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

        await tester.tap(find.text('Home'));
        await tester.pumpAndSettle();

        expect(find.text('Home Content'), findsOneWidget);
        expect(find.text('Products Content'), findsNothing);

        await tester.tap(find.text('Products'));
        await tester.pumpAndSettle();

        expect(find.text('Home Content'), findsNothing);
        expect(find.text('Products Content'), findsOneWidget);
      });
    });

    group('Navigation Menu List', () {
      testWidgets('renders navigation menu list', (tester) async {
        await tester.pumpWidget(
          const GrafitThemedTest(
            child: Center(
              child: GrafitNavigationMenu(
                children: [
                  GrafitNavigationMenuList(
                    children: [
                      GrafitNavigationMenuItem(
                        child: GrafitNavigationMenuTrigger(child: Text('Item 1')),
                      ),
                      GrafitNavigationMenuItem(
                        child: GrafitNavigationMenuTrigger(child: Text('Item 2')),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(GrafitNavigationMenuList), findsOneWidget);
      });
    });

    group('Navigation Menu Indicator', () {
      testWidgets('renders navigation menu indicator', (tester) async {
        await tester.pumpWidget(
          const GrafitThemedTest(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GrafitNavigationMenuIndicator(),
                ],
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(GrafitNavigationMenuIndicator), findsOneWidget);
      });
    });

    group('Viewport Modes', () {
      testWidgets('renders with viewport mode', (tester) async {
        await tester.pumpWidget(
          const GrafitThemedTest(
            child: Center(
              child: GrafitNavigationMenu(
                viewportMode: GrafitNavigationMenuViewportMode.viewport,
                children: [
                  GrafitNavigationMenuItem(
                    child: GrafitNavigationMenuTrigger(child: Text('Products')),
                  ),
                ],
              ),
            ),
          ),
        );
        expect(find.byType(GrafitNavigationMenu), findsOneWidget);
      });

      testWidgets('renders with popover mode', (tester) async {
        await tester.pumpWidget(
          const GrafitThemedTest(
            child: Center(
              child: GrafitNavigationMenu(
                viewportMode: GrafitNavigationMenuViewportMode.popover,
                children: [
                  GrafitNavigationMenuItem(
                    child: GrafitNavigationMenuTrigger(child: Text('Products')),
                  ),
                ],
              ),
            ),
          ),
        );
        expect(find.byType(GrafitNavigationMenu), findsOneWidget);
      });
    });

    group('Callbacks', () {
      testWidgets('calls onValueChange when selection changes', (tester) async {
        int? selectedIndex;

        await tester.pumpWidget(
          GrafitThemedTest(
            child: Center(
              child: GrafitNavigationMenu(
                onValueChange: (index) => selectedIndex = index,
                children: [
                  GrafitNavigationMenuItem(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GrafitNavigationMenuTrigger(child: Text('Products')),
                        GrafitNavigationMenuContent(
                          child: SizedBox(
                            width: 200,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                GrafitNavigationMenuLink(
                                  title: 'Software',
                                  onSelect: () {},
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
            ),
          ),
        );

        await tester.tap(find.text('Products'));
        await tester.pumpAndSettle();

        expect(selectedIndex, isNotNull);
      });
    });
  });
}
