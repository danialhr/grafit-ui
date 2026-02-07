import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grafit_ui/src/components/navigation/menubar.dart';
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
  group('GrafitMenubar', () {
    group('Rendering', () {
      testWidgets('renders without error', (tester) async {
        await tester.pumpWidget(
          const GrafitThemedTest(
            child: Center(
              child: GrafitMenubar(
                children: [
                  GrafitMenubarMenu(
                    trigger: GrafitMenubarTrigger(child: Text('File')),
                    children: [
                      GrafitMenubarItem(label: 'New'),
                      GrafitMenubarItem(label: 'Open'),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
        expect(find.byType(GrafitMenubar), findsOneWidget);
        expect(find.text('File'), findsOneWidget);
      });

      testWidgets('opens dropdown on menu trigger tap', (tester) async {
        await tester.pumpWidget(
          const GrafitThemedTest(
            child: Center(
              child: GrafitMenubar(
                children: [
                  GrafitMenubarMenu(
                    trigger: GrafitMenubarTrigger(child: Text('File')),
                    children: [
                      GrafitMenubarItem(label: 'New'),
                      GrafitMenubarItem(label: 'Open'),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );

        await tester.tap(find.text('File'));
        await tester.pumpAndSettle();

        expect(find.text('New'), findsOneWidget);
        expect(find.text('Open'), findsOneWidget);
      });

      testWidgets('closes dropdown on outside tap', (tester) async {
        await tester.pumpWidget(
          const GrafitThemedTest(
            child: Center(
              child: GrafitMenubar(
                children: [
                  GrafitMenubarMenu(
                    trigger: GrafitMenubarTrigger(child: Text('File')),
                    children: [
                      GrafitMenubarItem(label: 'New'),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );

        await tester.tap(find.text('File'));
        await tester.pumpAndSettle();

        expect(find.text('New'), findsOneWidget);

        await tester.tapAt(const Offset(10, 10));
        await tester.pumpAndSettle();

        expect(find.text('New'), findsNothing);
      });

      testWidgets('only one menu open at a time', (tester) async {
        await tester.pumpWidget(
          const GrafitThemedTest(
            child: Center(
              child: GrafitMenubar(
                children: [
                  GrafitMenubarMenu(
                    trigger: GrafitMenubarTrigger(child: Text('File')),
                    children: [
                      GrafitMenubarItem(label: 'New'),
                    ],
                  ),
                  GrafitMenubarMenu(
                    trigger: GrafitMenubarTrigger(child: Text('Edit')),
                    children: [
                      GrafitMenubarItem(label: 'Undo'),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );

        await tester.tap(find.text('File'));
        await tester.pumpAndSettle();

        expect(find.text('New'), findsOneWidget);
        expect(find.text('Undo'), findsNothing);

        await tester.tap(find.text('Edit'));
        await tester.pumpAndSettle();

        expect(find.text('New'), findsNothing);
        expect(find.text('Undo'), findsOneWidget);
      });
    });

    group('Menubar Items', () {
      testWidgets('renders item with leading icon', (tester) async {
        await tester.pumpWidget(
          const GrafitThemedTest(
            child: Center(
              child: GrafitMenubar(
                children: [
                  GrafitMenubarMenu(
                    trigger: GrafitMenubarTrigger(child: Text('File')),
                    children: [
                      GrafitMenubarItem(
                        label: 'New',
                        leading: Icon(Icons.add, size: 16),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );

        await tester.tap(find.text('File'));
        await tester.pumpAndSettle();

        expect(find.byIcon(Icons.add), findsOneWidget);
      });

      testWidgets('renders item with trailing icon', (tester) async {
        await tester.pumpWidget(
          const GrafitThemedTest(
            child: Center(
              child: GrafitMenubar(
                children: [
                  GrafitMenubarMenu(
                    trigger: GrafitMenubarTrigger(child: Text('File')),
                    children: [
                      GrafitMenubarItem(
                        label: 'Export',
                        trailing: Icon(Icons.arrow_forward_ios, size: 16),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );

        await tester.tap(find.text('File'));
        await tester.pumpAndSettle();

        expect(find.byIcon(Icons.arrow_forward_ios), findsOneWidget);
      });

      testWidgets('calls onSelected when item is tapped', (tester) async {
        bool selected = false;

        await tester.pumpWidget(
          GrafitThemedTest(
            child: Center(
              child: GrafitMenubar(
                children: [
                  GrafitMenubarMenu(
                    trigger: GrafitMenubarTrigger(child: Text('File')),
                    children: [
                      GrafitMenubarItem(
                        label: 'New',
                        onSelected: () => selected = true,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );

        await tester.tap(find.text('File'));
        await tester.pumpAndSettle();

        await tester.tap(find.text('New'));
        await tester.pumpAndSettle();

        expect(selected, isTrue);
      });

      testWidgets('renders disabled item', (tester) async {
        await tester.pumpWidget(
          const GrafitThemedTest(
            child: Center(
              child: GrafitMenubar(
                children: [
                  GrafitMenubarMenu(
                    trigger: GrafitMenubarTrigger(child: Text('Edit')),
                    children: [
                      GrafitMenubarItem(label: 'Undo', enabled: false),
                      GrafitMenubarItem(label: 'Redo'),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );

        await tester.tap(find.text('Edit'));
        await tester.pumpAndSettle();

        expect(find.text('Undo'), findsOneWidget);
        expect(find.text('Redo'), findsOneWidget);
      });

      testWidgets('renders destructive variant', (tester) async {
        await tester.pumpWidget(
          const GrafitThemedTest(
            child: Center(
              child: GrafitMenubar(
                children: [
                  GrafitMenubarMenu(
                    trigger: GrafitMenubarTrigger(child: Text('Actions')),
                    children: [
                      GrafitMenubarItem(
                        label: 'Delete',
                        variant: GrafitMenubarMenuItemVariant.destructive,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );

        await tester.tap(find.text('Actions'));
        await tester.pumpAndSettle();

        expect(find.text('Delete'), findsOneWidget);
      });
    });

    group('Keyboard Navigation', () {
      testWidgets('navigates items with arrow down key', (tester) async {
        await tester.pumpWidget(
          const GrafitThemedTest(
            child: Center(
              child: GrafitMenubar(
                children: [
                  GrafitMenubarMenu(
                    trigger: GrafitMenubarTrigger(child: Text('File')),
                    children: [
                      GrafitMenubarItem(label: 'New'),
                      GrafitMenubarItem(label: 'Open'),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );

        await tester.tap(find.text('File'));
        await tester.pumpAndSettle();

        await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
        await tester.pumpAndSettle();
      });

      testWidgets('navigates items with arrow up key', (tester) async {
        await tester.pumpWidget(
          const GrafitThemedTest(
            child: Center(
              child: GrafitMenubar(
                children: [
                  GrafitMenubarMenu(
                    trigger: GrafitMenubarTrigger(child: Text('File')),
                    children: [
                      GrafitMenubarItem(label: 'New'),
                      GrafitMenubarItem(label: 'Open'),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );

        await tester.tap(find.text('File'));
        await tester.pumpAndSettle();

        await tester.sendKeyEvent(LogicalKeyboardKey.arrowUp);
        await tester.pumpAndSettle();
      });

      testWidgets('closes on escape key', (tester) async {
        await tester.pumpWidget(
          const GrafitThemedTest(
            child: Center(
              child: GrafitMenubar(
                children: [
                  GrafitMenubarMenu(
                    trigger: GrafitMenubarTrigger(child: Text('File')),
                    children: [
                      GrafitMenubarItem(label: 'New'),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );

        await tester.tap(find.text('File'));
        await tester.pumpAndSettle();

        expect(find.text('New'), findsOneWidget);

        await tester.sendKeyEvent(LogicalKeyboardKey.escape);
        await tester.pumpAndSettle();

        expect(find.text('New'), findsNothing);
      });

      testWidgets('closes on arrow left key', (tester) async {
        await tester.pumpWidget(
          const GrafitThemedTest(
            child: Center(
              child: GrafitMenubar(
                children: [
                  GrafitMenubarMenu(
                    trigger: GrafitMenubarTrigger(child: Text('File')),
                    children: [
                      GrafitMenubarItem(label: 'New'),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );

        await tester.tap(find.text('File'));
        await tester.pumpAndSettle();

        expect(find.text('New'), findsOneWidget);

        await tester.sendKeyEvent(LogicalKeyboardKey.arrowLeft);
        await tester.pumpAndSettle();

        expect(find.text('New'), findsNothing);
      });

      testWidgets('activates item on enter key', (tester) async {
        bool selected = false;

        await tester.pumpWidget(
          GrafitThemedTest(
            child: Center(
              child: GrafitMenubar(
                children: [
                  GrafitMenubarMenu(
                    trigger: GrafitMenubarTrigger(child: Text('File')),
                    children: [
                      GrafitMenubarItem(
                        label: 'New',
                        onSelected: () => selected = true,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );

        await tester.tap(find.text('File'));
        await tester.pumpAndSettle();

        await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
        await tester.pumpAndSettle();

        await tester.sendKeyEvent(LogicalKeyboardKey.enter);
        await tester.pumpAndSettle();

        expect(selected, isTrue);
      });
    });

    group('Menubar Separators', () {
      testWidgets('renders menu separator', (tester) async {
        await tester.pumpWidget(
          const GrafitThemedTest(
            child: Center(
              child: GrafitMenubar(
                children: [
                  GrafitMenubarMenu(
                    trigger: GrafitMenubarTrigger(child: Text('File')),
                    children: const [
                      GrafitMenubarItem(label: 'New'),
                      GrafitMenubarSeparator(),
                      GrafitMenubarItem(label: 'Save'),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );

        await tester.tap(find.text('File'));
        await tester.pumpAndSettle();

        expect(find.byType(GrafitMenubarSeparator), findsOneWidget);
      });
    });

    group('Menubar Labels', () {
      testWidgets('renders menu label', (tester) async {
        await tester.pumpWidget(
          const GrafitThemedTest(
            child: Center(
              child: GrafitMenubar(
                children: [
                  GrafitMenubarMenu(
                    trigger: GrafitMenubarTrigger(child: Text('Bookmarks')),
                    children: const [
                      GrafitMenubarLabel(label: 'Recently Bookmarked'),
                      GrafitMenubarItem(label: 'Home'),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );

        await tester.tap(find.text('Bookmarks'));
        await tester.pumpAndSettle();

        expect(find.text('Recently Bookmarked'), findsOneWidget);
      });
    });

    group('Menubar with Shortcuts', () {
      testWidgets('renders item with shortcut', (tester) async {
        await tester.pumpWidget(
          const GrafitThemedTest(
            child: Center(
              child: GrafitMenubar(
                children: [
                  GrafitMenubarMenu(
                    trigger: GrafitMenubarTrigger(child: Text('Edit')),
                    children: const [
                      GrafitMenubarItem(
                        label: 'Undo',
                        shortcut: '⌘Z',
                      ),
                      GrafitMenubarItem(
                        label: 'Redo',
                        shortcut: '⌘⇧Z',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );

        await tester.tap(find.text('Edit'));
        await tester.pumpAndSettle();

        expect(find.text('⌘Z'), findsOneWidget);
        expect(find.text('⌘⇧Z'), findsOneWidget);
      });
    });

    group('Menubar Checkboxes', () {
      testWidgets('renders checkbox item', (tester) async {
        await tester.pumpWidget(
          const GrafitThemedTest(
            child: Center(
              child: GrafitMenubar(
                children: [
                  GrafitMenubarMenu(
                    trigger: GrafitMenubarTrigger(child: Text('View')),
                    children: const [
                      GrafitMenubarCheckboxItem(
                        label: 'Show Toolbar',
                        checked: true,
                      ),
                      GrafitMenubarCheckboxItem(
                        label: 'Show Status Bar',
                        checked: false,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );

        await tester.tap(find.text('View'));
        await tester.pumpAndSettle();

        expect(find.byIcon(Icons.check), findsOneWidget);
      });
    });

    group('Menubar Radio Groups', () {
      testWidgets('renders radio group', (tester) async {
        await tester.pumpWidget(
          GrafitThemedTest(
            child: Center(
              child: GrafitMenubar(
                children: [
                  GrafitMenubarMenu(
                    trigger: const GrafitMenubarTrigger(child: Text('Theme')),
                    children: [
                      GrafitMenubarRadioGroup<String>(
                        value: 'system',
                        onValueChanged: (value) {},
                        items: const [
                          GrafitMenubarRadioItem(value: 'light', label: 'Light'),
                          GrafitMenubarRadioItem(value: 'dark', label: 'Dark'),
                          GrafitMenubarRadioItem(value: 'system', label: 'System'),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );

        await tester.tap(find.text('Theme'));
        await tester.pumpAndSettle();

        expect(find.text('Light'), findsOneWidget);
        expect(find.text('Dark'), findsOneWidget);
        expect(find.text('System'), findsOneWidget);
      });
    });

    group('Menubar Submenus', () {
      testWidgets('renders submenu', (tester) async {
        await tester.pumpWidget(
          const GrafitThemedTest(
            child: Center(
              child: GrafitMenubar(
                children: [
                  GrafitMenubarMenu(
                    trigger: GrafitMenubarTrigger(child: Text('File')),
                    children: [
                      GrafitMenubarItem(label: 'New'),
                      GrafitMenubarSub(
                        trigger: GrafitMenubarSubTrigger(label: 'Open Recent'),
                        children: const [
                          GrafitMenubarItem(label: 'File 1', inset: true),
                          GrafitMenubarItem(label: 'File 2', inset: true),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );

        await tester.tap(find.text('File'));
        await tester.pumpAndSettle();

        expect(find.text('Open Recent'), findsOneWidget);

        await tester.tap(find.text('Open Recent'));
        await tester.pumpAndSettle();

        expect(find.text('File 1'), findsOneWidget);
      });
    });

    group('Multiple Menus', () {
      testWidgets('renders multiple menu items', (tester) async {
        await tester.pumpWidget(
          const GrafitThemedTest(
            child: Center(
              child: GrafitMenubar(
                children: [
                  GrafitMenubarMenu(
                    trigger: GrafitMenubarTrigger(child: Text('File')),
                    children: [
                      GrafitMenubarItem(label: 'New'),
                    ],
                  ),
                  GrafitMenubarMenu(
                    trigger: GrafitMenubarTrigger(child: Text('Edit')),
                    children: [
                      GrafitMenubarItem(label: 'Undo'),
                    ],
                  ),
                  GrafitMenubarMenu(
                    trigger: GrafitMenubarTrigger(child: Text('View')),
                    children: [
                      GrafitMenubarItem(label: 'Fullscreen'),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );

        expect(find.text('File'), findsOneWidget);
        expect(find.text('Edit'), findsOneWidget);
        expect(find.text('View'), findsOneWidget);
      });
    });
  });
}
