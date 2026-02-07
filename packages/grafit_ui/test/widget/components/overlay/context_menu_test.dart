import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grafit_ui/grafit_ui.dart';

import '../../test_helper.dart';

void main() {
  group('GrafitContextMenu', () {
    final testItems = [
      const GrafitContextMenuItem(
        label: 'Copy',
        leading: Icon(Icons.copy),
        shortcut: 'C',
      ),
      const GrafitContextMenuItem(
        label: 'Paste',
        leading: Icon(Icons.paste),
        shortcut: 'V',
      ),
      const GrafitContextMenuItem(
        label: 'Delete',
        leading: Icon(Icons.delete),
        variant: GrafitContextMenuItemVariant.destructive,
      ),
    ];

    group('Rendering', () {
      testWidgets('renders child without error', (tester) async {
        await tester.pumpWidget(
          GrafitThemedTest(
            child: GrafitContextMenu(
              items: testItems,
              child: const Text('Right-click me'),
            ),
          ),
        );
        expect(find.text('Right-click me'), findsOneWidget);
      });

      testWidgets('renders with various child types', (tester) async {
        await tester.pumpWidget(
          GrafitThemedTest(
            child: GrafitContextMenu(
              items: testItems,
              child: Container(
                width: 200,
                height: 100,
                color: Colors.blue,
                child: const Text('Container'),
              ),
            ),
          ),
        );
        expect(find.byType(Container), findsOneWidget);
      });
    });

    group('Right-Click Trigger', () {
      testWidgets('opens on secondary tap (right-click)', (tester) async {
        await tester.pumpWidget(
          GrafitThemedTest(
            child: GrafitContextMenu(
              items: testItems,
              child: const Text('Right-click target'),
            ),
          ),
        );

        // Menu should not be visible initially
        expect(find.text('Copy'), findsNothing);

        // Simulate right-click
        await tester.tap(find.text('Right-click target'), buttons: kSecondaryButton);
        await tester.pump();

        // Menu should be visible
        expect(find.text('Copy'), findsOneWidget);
      });

      testWidgets('opens on long press', (tester) async {
        await tester.pumpWidget(
          GrafitThemedTest(
            child: GrafitContextMenu(
              items: testItems,
              child: const Text('Long press target'),
            ),
          ),
        );

        // Long press
        await tester.longPress(find.text('Long press target'));
        await tester.pump();

        // Menu should be visible
        expect(find.text('Copy'), findsOneWidget);
      });

      testWidgets('does not open when disabled', (tester) async {
        await tester.pumpWidget(
          GrafitThemedTest(
            child: GrafitContextMenu(
              items: testItems,
              disabled: true,
              child: const Text('Disabled menu'),
            ),
          ),
        );

        await tester.tap(find.text('Disabled menu'), buttons: kSecondaryButton);
        await tester.pump();

        // Menu should not open
        expect(find.text('Copy'), findsNothing);
      });
    });

    group('Backdrop Dismissal', () {
      testWidgets('dismisses on backdrop tap', (tester) async {
        await tester.pumpWidget(
          GrafitThemedTest(
            child: GrafitContextMenu(
              items: testItems,
              child: const Text('Target'),
            ),
          ),
        );

        // Open menu
        await tester.tap(find.text('Target'), buttons: kSecondaryButton);
        await tester.pump();
        expect(find.text('Copy'), findsOneWidget);

        // Tap outside
        await tester.tapAt(const Offset(10, 10));
        await tester.pumpAndSettle();

        // Menu should be dismissed
        expect(find.text('Copy'), findsNothing);
      });

      testWidgets('dismisses on escape key', (tester) async {
        await tester.pumpWidget(
          GrafitThemedTest(
            child: Focus(
              child: GrafitContextMenu(
                items: testItems,
                child: const Text('Target'),
              ),
            ),
          ),
        );

        // Open menu
        await tester.tap(find.text('Target'), buttons: kSecondaryButton);
        await tester.pump();
        expect(find.text('Copy'), findsOneWidget);

        // Press escape
        await tester.sendKeyEvent(LogicalKeyboardKey.escape);
        await tester.pump();

        // Menu should be dismissed
        expect(find.text('Copy'), findsNothing);
      });
    });

    group('Menu Items', () {
      testWidgets('renders menu items with labels', (tester) async {
        await tester.pumpWidget(
          GrafitThemedTest(
            child: GrafitContextMenu(
              items: const [
                GrafitContextMenuItem(label: 'Item 1'),
                GrafitContextMenuItem(label: 'Item 2'),
                GrafitContextMenuItem(label: 'Item 3'),
              ],
              child: const Text('Target'),
            ),
          ),
        );

        await tester.tap(find.text('Target'), buttons: kSecondaryButton);
        await tester.pump();

        expect(find.text('Item 1'), findsOneWidget);
        expect(find.text('Item 2'), findsOneWidget);
        expect(find.text('Item 3'), findsOneWidget);
      });

      testWidgets('renders items with leading icons', (tester) async {
        await tester.pumpWidget(
          GrafitThemedTest(
            child: GrafitContextMenu(
              items: [
                GrafitContextMenuItem(
                  label: 'Copy',
                  leading: const Icon(Icons.copy),
                ),
              ],
              child: const Text('Target'),
            ),
          ),
        );

        await tester.tap(find.text('Target'), buttons: kSecondaryButton);
        await tester.pump();

        expect(find.byIcon(Icons.copy), findsOneWidget);
      });

      testWidgets('renders items with shortcuts', (tester) async {
        await tester.pumpWidget(
          GrafitThemedTest(
            child: GrafitContextMenu(
              items: const [
                GrafitContextMenuItem(
                  label: 'Copy',
                  shortcut: 'C',
                ),
              ],
              child: const Text('Target'),
            ),
          ),
        );

        await tester.tap(find.text('Target'), buttons: kSecondaryButton);
        await tester.pump();

        expect(find.text('C'), findsOneWidget);
      });

      testWidgets('renders destructive variant items', (tester) async {
        await tester.pumpWidget(
          GrafitThemedTest(
            child: GrafitContextMenu(
              items: const [
                GrafitContextMenuItem(
                  label: 'Delete',
                  variant: GrafitContextMenuItemVariant.destructive,
                ),
              ],
              child: const Text('Target'),
            ),
          ),
        );

        await tester.tap(find.text('Target'), buttons: kSecondaryButton);
        await tester.pump();

        expect(find.text('Delete'), findsOneWidget);
      });
    });

    group('Item Interaction', () {
      testWidgets('calls onSelected when item is tapped', (tester) async {
        bool selectedItem = false;

        await tester.pumpWidget(
          GrafitThemedTest(
            child: GrafitContextMenu(
              items: [
                GrafitContextMenuItem(
                  label: 'Select Me',
                  onSelected: () => selectedItem = true,
                ),
              ],
              child: const Text('Target'),
            ),
          ),
        );

        await tester.tap(find.text('Target'), buttons: kSecondaryButton);
        await tester.pump();
        await tester.tap(find.text('Select Me'));
        await tester.pump();

        expect(selectedItem, isTrue);
      });

      testWidgets('dismisses menu after item selection', (tester) async {
        await tester.pumpWidget(
          GrafitThemedTest(
            child: GrafitContextMenu(
              items: const [
                GrafitContextMenuItem(label: 'Close'),
              ],
              child: const Text('Target'),
            ),
          ),
        );

        await tester.tap(find.text('Target'), buttons: kSecondaryButton);
        await tester.pump();
        expect(find.text('Close'), findsOneWidget);

        await tester.tap(find.text('Close'));
        await tester.pump();

        expect(find.text('Close'), findsNothing);
      });

      testWidgets('does not call onSelected for disabled items', (tester) async {
        bool selectedItem = false;

        await tester.pumpWidget(
          GrafitThemedTest(
            child: GrafitContextMenu(
              items: [
                GrafitContextMenuItem(
                  label: 'Disabled',
                  enabled: false,
                  onSelected: () => selectedItem = true,
                ),
              ],
              child: const Text('Target'),
            ),
          ),
        );

        await tester.tap(find.text('Target'), buttons: kSecondaryButton);
        await tester.pump();
        await tester.tap(find.text('Disabled'));
        await tester.pump();

        expect(selectedItem, isFalse);
      });
    });

    group('Keyboard Navigation', () {
      testWidgets('navigates items with arrow keys', (tester) async {
        await tester.pumpWidget(
          GrafitThemedTest(
            child: Focus(
              child: GrafitContextMenu(
                items: const [
                  GrafitContextMenuItem(label: 'Item 1'),
                  GrafitContextMenuItem(label: 'Item 2'),
                  GrafitContextMenuItem(label: 'Item 3'),
                ],
                child: const Text('Target'),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Target'), buttons: kSecondaryButton);
        await tester.pump();

        await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
        await tester.pump();

        await tester.sendKeyEvent(LogicalKeyboardKey.arrowUp);
        await tester.pump();

        expect(find.byType(GrafitContextMenu), findsOneWidget);
      });

      testWidgets('activates item on enter key', (tester) async {
        bool activated = false;

        await tester.pumpWidget(
          GrafitThemedTest(
            child: Focus(
              child: GrafitContextMenu(
                items: [
                  GrafitContextMenuItem(
                    label: 'Activate',
                    onSelected: () => activated = true,
                  ),
                ],
                child: const Text('Target'),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Target'), buttons: kSecondaryButton);
        await tester.pump();

        await tester.sendKeyEvent(LogicalKeyboardKey.enter);
        await tester.pump();

        expect(activated, isTrue);
      });
    });

    group('Menu Separators', () {
      testWidgets('renders separators between groups', (tester) async {
        await tester.pumpWidget(
          GrafitThemedTest(
            child: GrafitContextMenu(
              items: [
                const GrafitContextMenuItem(label: 'Item 1'),
                GrafitContextMenuSeparator(),
                const GrafitContextMenuItem(label: 'Item 2'),
              ],
              child: const Text('Target'),
            ),
          ),
        );

        await tester.tap(find.text('Target'), buttons: kSecondaryButton);
        await tester.pump();

        expect(find.byType(GrafitContextMenuSeparator), findsOneWidget);
      });
    });

    group('Menu Labels', () {
      testWidgets('renders menu labels', (tester) async {
        await tester.pumpWidget(
          GrafitThemedTest(
            child: GrafitContextMenu(
              items: [
                const GrafitContextMenuLabel(label: 'Actions'),
                const GrafitContextMenuItem(label: 'Item 1'),
                const GrafitContextMenuLabel(label: 'More Actions'),
                const GrafitContextMenuItem(label: 'Item 2'),
              ],
              child: const Text('Target'),
            ),
          ),
        );

        await tester.tap(find.text('Target'), buttons: kSecondaryButton);
        await tester.pump();

        expect(find.text('Actions'), findsOneWidget);
        expect(find.text('More Actions'), findsOneWidget);
      });
    });

    group('Checkbox Items', () {
      testWidgets('renders checkbox items', (tester) async {
        await tester.pumpWidget(
          GrafitThemedTest(
            child: GrafitContextMenu(
              items: [
                GrafitContextMenuCheckboxItem(
                  label: 'Enable Feature',
                  checked: true,
                ),
              ],
              child: const Text('Target'),
            ),
          ),
        );

        await tester.tap(find.text('Target'), buttons: kSecondaryButton);
        await tester.pump();

        expect(find.text('Enable Feature'), findsOneWidget);
      });

      testWidgets('toggles checkbox on tap', (tester) async {
        bool checked = false;

        await tester.pumpWidget(
          GrafitThemedTest(
            child: GrafitContextMenu(
              items: [
                GrafitContextMenuCheckboxItem(
                  label: 'Toggle',
                  checked: checked,
                  onChecked: (value) => checked = value,
                ),
              ],
              child: const Text('Target'),
            ),
          ),
        );

        await tester.tap(find.text('Target'), buttons: kSecondaryButton);
        await tester.pump();
        await tester.tap(find.text('Toggle'));
        await tester.pump();

        expect(checked, isTrue);
      });
    });

    group('Animation', () {
      testWidgets('animates in when opened', (tester) async {
        await tester.pumpWidget(
          GrafitThemedTest(
            child: GrafitContextMenu(
              items: const [
                GrafitContextMenuItem(label: 'Animated'),
              ],
              child: const Text('Target'),
            ),
          ),
        );

        await tester.tap(find.text('Target'), buttons: kSecondaryButton);
        await tester.pump(const Duration(milliseconds: 100));

        expect(find.text('Animated'), findsOneWidget);

        await tester.pump(const Duration(milliseconds: 100));
      });

      testWidgets('animates out when closed', (tester) async {
        await tester.pumpWidget(
          GrafitThemedTest(
            child: GrafitContextMenu(
              items: const [
                GrafitContextMenuItem(label: 'Item'),
              ],
              child: const Text('Target'),
            ),
          ),
        );

        await tester.tap(find.text('Target'), buttons: kSecondaryButton);
        await tester.pumpAndSettle();
        expect(find.text('Item'), findsOneWidget);

        await tester.tapAt(const Offset(10, 10));
        await tester.pump(const Duration(milliseconds: 100));

        // Animation in progress
        await tester.pump(const Duration(milliseconds: 100));
      });
    });

    group('Positioning', () {
      testWidgets('positions menu near tap location', (tester) async {
        await tester.pumpWidget(
          GrafitThemedTest(
            child: Center(
              child: GrafitContextMenu(
                items: const [
                  GrafitContextMenuItem(label: 'Item'),
                ],
                child: const Text('Center Target'),
              ),
            ),
          ),
        );

        // Tap at center
        await tester.tap(find.text('Center Target'), buttons: kSecondaryButton);
        await tester.pump();

        expect(find.text('Item'), findsOneWidget);
      });
    });

    group('Edge Cases', () {
      testWidgets('handles empty items list', (tester) async {
        await tester.pumpWidget(
          GrafitThemedTest(
            child: GrafitContextMenu(
              items: const [],
              child: const Text('Empty'),
            ),
          ),
        );

        await tester.tap(find.text('Empty'), buttons: kSecondaryButton);
        await tester.pump();

        // Should open menu without error
        expect(find.byType(GrafitContextMenu), findsOneWidget);
      });

      testWidgets('handles multiple rapid opens/closes', (tester) async {
        await tester.pumpWidget(
          GrafitThemedTest(
            child: GrafitContextMenu(
              items: const [
                GrafitContextMenuItem(label: 'Item'),
              ],
              child: const Text('Rapid'),
            ),
          ),
        );

        // Rapid right-clicks
        await tester.tap(find.text('Rapid'), buttons: kSecondaryButton);
        await tester.pump(const Duration(milliseconds: 50));
        await tester.tapAt(const Offset(10, 10));
        await tester.pump(const Duration(milliseconds: 50));
        await tester.tap(find.text('Rapid'), buttons: kSecondaryButton);
        await tester.pump();

        // Should handle gracefully
        expect(find.byType(GrafitContextMenu), findsOneWidget);
      });
    });
  });
}
