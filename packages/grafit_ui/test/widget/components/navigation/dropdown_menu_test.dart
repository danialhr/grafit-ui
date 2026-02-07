import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grafit_ui/src/components/navigation/dropdown_menu.dart';
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
  group('GrafitDropdownMenu', () {
    group('Rendering', () {
      testWidgets('renders without error', (tester) async {
        await tester.pumpWidget(
          GrafitThemedTest(
            child: Center(
              child: GrafitDropdownMenu(
                trigger: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text('Open Menu'),
                ),
                children: const [
                  GrafiDropdownMenuItem(label: 'Option 1'),
                  GrafiDropdownMenuItem(label: 'Option 2'),
                ],
              ),
            ),
          ),
        );
        expect(find.byType(GrafitDropdownMenu), findsOneWidget);
        expect(find.text('Open Menu'), findsOneWidget);
      });

      testWidgets('opens menu on trigger tap', (tester) async {
        await tester.pumpWidget(
          GrafitThemedTest(
            child: Center(
              child: GrafitDropdownMenu(
                trigger: Container(
                  key: const Key('trigger'),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: const Text('Open Menu'),
                ),
                children: const [
                  GrafiDropdownMenuItem(label: 'Option 1'),
                  GrafiDropdownMenuItem(label: 'Option 2'),
                ],
              ),
            ),
          ),
        );

        await tester.tap(find.byKey(const Key('trigger')));
        await tester.pumpAndSettle();

        expect(find.text('Option 1'), findsOneWidget);
        expect(find.text('Option 2'), findsOneWidget);
      });

      testWidgets('closes menu on outside tap', (tester) async {
        await tester.pumpWidget(
          GrafitThemedTest(
            child: Center(
              child: GrafitDropdownMenu(
                trigger: Container(
                  key: const Key('trigger'),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: const Text('Open Menu'),
                ),
                children: const [
                  GrafiDropdownMenuItem(label: 'Option 1'),
                ],
              ),
            ),
          ),
        );

        await tester.tap(find.byKey(const Key('trigger')));
        await tester.pumpAndSettle();

        expect(find.text('Option 1'), findsOneWidget);

        await tester.tapAt(const Offset(10, 10));
        await tester.pumpAndSettle();

        expect(find.text('Option 1'), findsNothing);
      });
    });

    group('Alignments', () {
      testWidgets('renders with bottom alignment', (tester) async {
        await tester.pumpWidget(
          GrafitThemedTest(
            child: Center(
              child: GrafitDropdownMenu(
                alignment: GrafitDropdownMenuAlignment.bottom,
                trigger: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: const Text('Open'),
                ),
                children: const [GrafiDropdownMenuItem(label: 'Item')],
              ),
            ),
          ),
        );
        expect(find.byType(GrafitDropdownMenu), findsOneWidget);
      });

      testWidgets('renders with top alignment', (tester) async {
        await tester.pumpWidget(
          GrafitThemedTest(
            child: Center(
              child: GrafitDropdownMenu(
                alignment: GrafitDropdownMenuAlignment.top,
                trigger: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: const Text('Open'),
                ),
                children: const [GrafiDropdownMenuItem(label: 'Item')],
              ),
            ),
          ),
        );
        expect(find.byType(GrafitDropdownMenu), findsOneWidget);
      });

      testWidgets('renders with left alignment', (tester) async {
        await tester.pumpWidget(
          GrafitThemedTest(
            child: Center(
              child: GrafitDropdownMenu(
                alignment: GrafitDropdownMenuAlignment.left,
                trigger: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: const Text('Open'),
                ),
                children: const [GrafiDropdownMenuItem(label: 'Item')],
              ),
            ),
          ),
        );
        expect(find.byType(GrafitDropdownMenu), findsOneWidget);
      });

      testWidgets('renders with right alignment', (tester) async {
        await tester.pumpWidget(
          GrafitThemedTest(
            child: Center(
              child: GrafitDropdownMenu(
                alignment: GrafitDropdownMenuAlignment.right,
                trigger: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: const Text('Open'),
                ),
                children: const [GrafiDropdownMenuItem(label: 'Item')],
              ),
            ),
          ),
        );
        expect(find.byType(GrafitDropdownMenu), findsOneWidget);
      });
    });

    group('Dropdown Menu Items', () {
      testWidgets('renders menu item with leading icon', (tester) async {
        await tester.pumpWidget(
          GrafitThemedTest(
            child: Center(
              child: GrafitDropdownMenu(
                trigger: Container(
                  key: const Key('trigger'),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: const Text('Open'),
                ),
                children: const [
                  GrafiDropdownMenuItem(
                    label: 'Profile',
                    leading: Icon(Icons.person, size: 16),
                  ),
                ],
              ),
            ),
          ),
        );

        await tester.tap(find.byKey(const Key('trigger')));
        await tester.pumpAndSettle();

        expect(find.byIcon(Icons.person), findsOneWidget);
        expect(find.text('Profile'), findsOneWidget);
      });

      testWidgets('renders menu item with trailing icon', (tester) async {
        await tester.pumpWidget(
          GrafitThemedTest(
            child: Center(
              child: GrafitDropdownMenu(
                trigger: Container(
                  key: const Key('trigger'),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: const Text('Open'),
                ),
                children: const [
                  GrafiDropdownMenuItem(
                    label: 'Settings',
                    trailing: Icon(Icons.arrow_forward_ios, size: 16),
                  ),
                ],
              ),
            ),
          ),
        );

        await tester.tap(find.byKey(const Key('trigger')));
        await tester.pumpAndSettle();

        expect(find.byIcon(Icons.arrow_forward_ios), findsOneWidget);
      });

      testWidgets('calls onSelected when item is tapped', (tester) async {
        bool selected = false;

        await tester.pumpWidget(
          GrafitThemedTest(
            child: Center(
              child: GrafitDropdownMenu(
                trigger: Container(
                  key: const Key('trigger'),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: const Text('Open'),
                ),
                children: [
                  GrafiDropdownMenuItem(
                    label: 'Option',
                    onSelected: () => selected = true,
                  ),
                ],
              ),
            ),
          ),
        );

        await tester.tap(find.byKey(const Key('trigger')));
        await tester.pumpAndSettle();

        await tester.tap(find.text('Option'));
        await tester.pumpAndSettle();

        expect(selected, isTrue);
      });

      testWidgets('renders disabled menu item', (tester) async {
        await tester.pumpWidget(
          GrafitThemedTest(
            child: Center(
              child: GrafitDropdownMenu(
                trigger: Container(
                  key: const Key('trigger'),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: const Text('Open'),
                ),
                children: const [
                  GrafiDropdownMenuItem(
                    label: 'Disabled',
                    enabled: false,
                  ),
                  GrafiDropdownMenuItem(label: 'Enabled'),
                ],
              ),
            ),
          ),
        );

        await tester.tap(find.byKey(const Key('trigger')));
        await tester.pumpAndSettle();

        expect(find.text('Disabled'), findsOneWidget);
        expect(find.text('Enabled'), findsOneWidget);
      });

      testWidgets('renders destructive variant', (tester) async {
        await tester.pumpWidget(
          GrafitThemedTest(
            child: Center(
              child: GrafitDropdownMenu(
                trigger: Container(
                  key: const Key('trigger'),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: const Text('Open'),
                ),
                children: const [
                  GrafiDropdownMenuItem(
                    label: 'Delete',
                    variant: GrafitDropdownMenuItemVariant.destructive,
                  ),
                ],
              ),
            ),
          ),
        );

        await tester.tap(find.byKey(const Key('trigger')));
        await tester.pumpAndSettle();

        expect(find.text('Delete'), findsOneWidget);
      });
    });

    group('Keyboard Navigation', () {
      testWidgets('navigates with arrow down key', (tester) async {
        await tester.pumpWidget(
          GrafitThemedTest(
            child: Center(
              child: GrafitDropdownMenu(
                trigger: Container(
                  key: const Key('trigger'),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: const Text('Open'),
                ),
                children: const [
                  GrafiDropdownMenuItem(label: 'Item 1'),
                  GrafiDropdownMenuItem(label: 'Item 2'),
                ],
              ),
            ),
          ),
        );

        await tester.tap(find.byKey(const Key('trigger')));
        await tester.pumpAndSettle();

        await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
        await tester.pumpAndSettle();
      });

      testWidgets('navigates with arrow up key', (tester) async {
        await tester.pumpWidget(
          GrafitThemedTest(
            child: Center(
              child: GrafitDropdownMenu(
                trigger: Container(
                  key: const Key('trigger'),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: const Text('Open'),
                ),
                children: const [
                  GrafiDropdownMenuItem(label: 'Item 1'),
                  GrafiDropdownMenuItem(label: 'Item 2'),
                ],
              ),
            ),
          ),
        );

        await tester.tap(find.byKey(const Key('trigger')));
        await tester.pumpAndSettle();

        await tester.sendKeyEvent(LogicalKeyboardKey.arrowUp);
        await tester.pumpAndSettle();
      });

      testWidgets('closes on escape key', (tester) async {
        await tester.pumpWidget(
          GrafitThemedTest(
            child: Center(
              child: GrafitDropdownMenu(
                trigger: Container(
                  key: const Key('trigger'),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: const Text('Open'),
                ),
                children: const [
                  GrafiDropdownMenuItem(label: 'Item 1'),
                ],
              ),
            ),
          ),
        );

        await tester.tap(find.byKey(const Key('trigger')));
        await tester.pumpAndSettle();

        expect(find.text('Item 1'), findsOneWidget);

        await tester.sendKeyEvent(LogicalKeyboardKey.escape);
        await tester.pumpAndSettle();

        expect(find.text('Item 1'), findsNothing);
      });

      testWidgets('activates item on enter key', (tester) async {
        bool selected = false;

        await tester.pumpWidget(
          GrafitThemedTest(
            child: Center(
              child: GrafitDropdownMenu(
                trigger: Container(
                  key: const Key('trigger'),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: const Text('Open'),
                ),
                children: [
                  GrafiDropdownMenuItem(
                    label: 'Item 1',
                    onSelected: () => selected = true,
                  ),
                ],
              ),
            ),
          ),
        );

        await tester.tap(find.byKey(const Key('trigger')));
        await tester.pumpAndSettle();

        await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
        await tester.pumpAndSettle();

        await tester.sendKeyEvent(LogicalKeyboardKey.enter);
        await tester.pumpAndSettle();

        expect(selected, isTrue);
      });
    });

    group('Dropdown Menu Separators', () {
      testWidgets('renders menu separator', (tester) async {
        await tester.pumpWidget(
          GrafitThemedTest(
            child: Center(
              child: GrafitDropdownMenu(
                trigger: Container(
                  key: const Key('trigger'),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: const Text('Open'),
                ),
                children: const [
                  GrafiDropdownMenuItem(label: 'Item 1'),
                  GrafitDropdownMenuSeparator(),
                  GrafiDropdownMenuItem(label: 'Item 2'),
                ],
              ),
            ),
          ),
        );

        await tester.tap(find.byKey(const Key('trigger')));
        await tester.pumpAndSettle();

        expect(find.byType(GrafitDropdownMenuSeparator), findsOneWidget);
      });
    });

    group('Dropdown Menu Labels', () {
      testWidgets('renders menu label', (tester) async {
        await tester.pumpWidget(
          GrafitThemedTest(
            child: Center(
              child: GrafitDropdownMenu(
                trigger: Container(
                  key: const Key('trigger'),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: const Text('Open'),
                ),
                children: const [
                  GrafitDropdownMenuLabel(label: 'Section'),
                  GrafiDropdownMenuItem(label: 'Item'),
                ],
              ),
            ),
          ),
        );

        await tester.tap(find.byKey(const Key('trigger')));
        await tester.pumpAndSettle();

        expect(find.text('Section'), findsOneWidget);
      });
    });

    group('Dropdown Menu with Shortcuts', () {
      testWidgets('renders menu item with shortcut', (tester) async {
        await tester.pumpWidget(
          GrafitThemedTest(
            child: Center(
              child: GrafitDropdownMenu(
                trigger: Container(
                  key: const Key('trigger'),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: const Text('Open'),
                ),
                children: const [
                  GrafiDropdownMenuItem(
                    label: 'Copy',
                    shortcut: '⌘C',
                  ),
                ],
              ),
            ),
          ),
        );

        await tester.tap(find.byKey(const Key('trigger')));
        await tester.pumpAndSettle();

        expect(find.text('⌘C'), findsOneWidget);
      });
    });

    group('Dropdown Menu Checkboxes', () {
      testWidgets('renders checkbox item', (tester) async {
        await tester.pumpWidget(
          GrafitThemedTest(
            child: Center(
              child: GrafitDropdownMenu(
                trigger: Container(
                  key: const Key('trigger'),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: const Text('Open'),
                ),
                children: const [
                  GrafitDropdownMenuCheckboxItem(
                    label: 'Show Toolbar',
                    checked: true,
                  ),
                ],
              ),
            ),
          ),
        );

        await tester.tap(find.byKey(const Key('trigger')));
        await tester.pumpAndSettle();

        expect(find.byIcon(Icons.check), findsOneWidget);
      });
    });

    group('Dropdown Menu Radio Groups', () {
      testWidgets('renders radio group', (tester) async {
        await tester.pumpWidget(
          GrafitThemedTest(
            child: Center(
              child: GrafitDropdownMenu(
                trigger: Container(
                  key: const Key('trigger'),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: const Text('Open'),
                ),
                children: [
                  GrafitDropdownMenuRadioGroup<String>(
                    value: 'light',
                    items: const [
                      GrafitDropdownMenuRadioItem(value: 'light', label: 'Light'),
                      GrafitDropdownMenuRadioItem(value: 'dark', label: 'Dark'),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );

        await tester.tap(find.byKey(const Key('trigger')));
        await tester.pumpAndSettle();

        expect(find.text('Light'), findsOneWidget);
        expect(find.text('Dark'), findsOneWidget);
      });
    });

    group('Dropdown Menu Submenus', () {
      testWidgets('renders submenu', (tester) async {
        await tester.pumpWidget(
          GrafitThemedTest(
            child: Center(
              child: GrafitDropdownMenu(
                trigger: Container(
                  key: const Key('trigger'),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: const Text('Open'),
                ),
                children: [
                  GrafitDropdownMenuSub(
                    trigger: const GrafitDropdownMenuSubTrigger(label: 'Submenu'),
                    children: const [
                      GrafiDropdownMenuItem(label: 'Sub 1', inset: true),
                      GrafiDropdownMenuItem(label: 'Sub 2', inset: true),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );

        await tester.tap(find.byKey(const Key('trigger')));
        await tester.pumpAndSettle();

        expect(find.text('Submenu'), findsOneWidget);
      });
    });
  });
}
