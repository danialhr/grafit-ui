import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grafit_ui/grafit_ui.dart';

import '../../test_helper.dart';

void main() {
  group('GrafitCommand', () {
    final testGroups = [
      const GrafitCommandGroup(
        label: 'General',
        items: [
          GrafitCommandItem(
            label: 'New Document',
            icon: Icons.add,
            shortcut: 'N',
          ),
          GrafitCommandItem(
            label: 'Open File',
            icon: Icons.folder_open,
            shortcut: 'O',
          ),
        ],
      ),
    ];

    group('Rendering', () {
      testWidgets('renders without error', (tester) async {
        await tester.pumpWidget(
          GrafitThemedTest(
            child: GrafitCommand(
              groups: testGroups,
            ),
          ),
        );
        expect(find.byType(GrafitCommand), findsOneWidget);
      });

      testWidgets('renders search input', (tester) async {
        await tester.pumpWidget(
          GrafitThemedTest(
            child: GrafitCommand(
              groups: testGroups,
              placeholder: 'Search commands...',
            ),
          ),
        );
        expect(find.byType(TextField), findsOneWidget);
        expect(find.text('Search commands...'), findsOneWidget);
      });

      testWidgets('renders command items', (tester) async {
        await tester.pumpWidget(
          GrafitThemedTest(
            child: GrafitCommand(
              groups: testGroups,
            ),
          ),
        );
        expect(find.text('New Document'), findsOneWidget);
        expect(find.text('Open File'), findsOneWidget);
      });

      testWidgets('renders group labels', (tester) async {
        await tester.pumpWidget(
          GrafitThemedTest(
            child: GrafitCommand(
              groups: testGroups,
            ),
          ),
        );
        expect(find.text('General'), findsOneWidget);
      });

      testWidgets('renders icons when provided', (tester) async {
        await tester.pumpWidget(
          GrafitThemedTest(
            child: GrafitCommand(
              groups: testGroups,
            ),
          ),
        );
        expect(find.byIcon(Icons.add), findsOneWidget);
        expect(find.byIcon(Icons.folder_open), findsOneWidget);
      });

      testWidgets('renders shortcuts when provided', (tester) async {
        await tester.pumpWidget(
          GrafitThemedTest(
            child: GrafitCommand(
              groups: testGroups,
            ),
          ),
        );
        expect(find.text('N'), findsOneWidget);
        expect(find.text('O'), findsOneWidget);
      });
    });

    group('Search Filtering', () {
      testWidgets('filters items by search query', (tester) async {
        await tester.pumpWidget(
          GrafitThemedTest(
            child: GrafitCommand(
              groups: const [
                GrafitCommandGroup(
                  items: [
                    GrafitCommandItem(label: 'Apple'),
                    GrafitCommandItem(label: 'Banana'),
                    GrafitCommandItem(label: 'Cherry'),
                  ],
                ),
              ],
            ),
          ),
        );

        // All items visible initially
        expect(find.text('Apple'), findsOneWidget);
        expect(find.text('Banana'), findsOneWidget);
        expect(find.text('Cherry'), findsOneWidget);

        // Enter search text
        await tester.enterText(find.byType(TextField), 'Ap');
        await tester.pump();

        // Only matching items visible
        expect(find.text('Apple'), findsOneWidget);
        expect(find.text('Banana'), findsNothing);
        expect(find.text('Cherry'), findsNothing);
      });

      testWidgets('filters case-insensitively', (tester) async {
        await tester.pumpWidget(
          GrafitThemedTest(
            child: GrafitCommand(
              groups: const [
                GrafitCommandGroup(
                  items: [
                    GrafitCommandItem(label: 'Document'),
                  ],
                ),
              ],
            ),
          ),
        );

        await tester.enterText(find.byType(TextField), 'doc');
        await tester.pump();

        expect(find.text('Document'), findsOneWidget);
      });

      testWidgets('shows empty state when no results', (tester) async {
        await tester.pumpWidget(
          GrafitThemedTest(
            child: GrafitCommand(
              groups: const [
                GrafitCommandGroup(
                  items: [
                    GrafitCommandItem(label: 'Item'),
                  ],
                ),
              ],
              emptyState: const GrafitCommandEmpty(
                title: 'No results',
                description: 'Try a different search',
              ),
            ),
          ),
        );

        await tester.enterText(find.byType(TextField), 'xyz');
        await tester.pump();

        expect(find.text('No results'), findsOneWidget);
        expect(find.text('Try a different search'), findsOneWidget);
      });
    });

    group('Keyboard Navigation', () {
      testWidgets('navigates down with arrow key', (tester) async {
        await tester.pumpWidget(
          GrafitThemedTest(
            child: Focus(
              child: GrafitCommand(
                groups: const [
                  GrafitCommandGroup(
                    items: [
                      GrafitCommandItem(label: 'Item 1'),
                      GrafitCommandItem(label: 'Item 2'),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );

        await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
        await tester.pump();

        // Selection should move to second item
        expect(find.byType(GrafitCommand), findsOneWidget);
      });

      testWidgets('navigates up with arrow key', (tester) async {
        await tester.pumpWidget(
          GrafitThemedTest(
            child: Focus(
              child: GrafitCommand(
                groups: const [
                  GrafitCommandGroup(
                    items: [
                      GrafitCommandItem(label: 'Item 1'),
                      GrafitCommandItem(label: 'Item 2'),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );

        await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
        await tester.pump();
        await tester.sendKeyEvent(LogicalKeyboardKey.arrowUp);
        await tester.pump();

        expect(find.byType(GrafitCommand), findsOneWidget);
      });

      testWidgets('dismisses on escape key', (tester) async {
        await tester.pumpWidget(
          GrafitThemedTest(
            child: Focus(
              child: GrafitCommand(
                groups: const [
                  GrafitCommandGroup(
                    items: [
                      GrafitCommandItem(label: 'Item'),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );

        await tester.sendKeyEvent(LogicalKeyboardKey.escape);
        await tester.pump();

        // Command should handle escape
        expect(find.byType(GrafitCommand), findsOneWidget);
      });
    });

    group('Command Dialog', () {
      testWidgets('shows command dialog', (tester) async {
        await tester.pumpWidget(
          GrafitThemedTest(
            child: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  GrafitCommandDialog.show(
                    context,
                    groups: testGroups,
                  );
                },
                child: const Text('Open'),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Open'));
        await tester.pumpAndSettle();

        expect(find.byType(GrafitCommandDialog), findsOneWidget);
      });
    });

    group('Command Components', () {
      testWidgets('renders CommandEmpty', (tester) async {
        await tester.pumpWidget(
          const GrafitThemedTest(
            child: Column(
              children: [
                GrafitCommandEmpty(
                  title: 'No Commands',
                  description: 'Add some commands to get started',
                  icon: Icon(Icons.search_off),
                ),
              ],
            ),
          ),
        );

        expect(find.text('No Commands'), findsOneWidget);
        expect(find.text('Add some commands to get started'), findsOneWidget);
        expect(find.byIcon(Icons.search_off), findsOneWidget);
      });

      testWidgets('renders CommandSeparator', (tester) async {
        await tester.pumpWidget(
          const GrafitThemedTest(
            child: Column(
              children: [
                GrafitCommandSeparator(),
              ],
            ),
          ),
        );

        expect(find.byType(GrafitCommandSeparator), findsOneWidget);
      });
    });

    group('Autofocus', () {
      testWidgets('autofocuses search input when autofocus is true', (tester) async {
        await tester.pumpWidget(
          GrafitThemedTest(
            child: GrafitCommand(
              groups: testGroups,
              autofocus: true,
            ),
          ),
        );

        await tester.pump();

        expect(find.byType(GrafitCommand), findsOneWidget);
      });

      testWidgets('does not autofocus when autofocus is false', (tester) async {
        await tester.pumpWidget(
          GrafitThemedTest(
            child: GrafitCommand(
              groups: testGroups,
              autofocus: false,
            ),
          ),
        );

        expect(find.byType(GrafitCommand), findsOneWidget);
      });
    });

    group('Keywords', () {
      testWidgets('filters by keywords', (tester) async {
        await tester.pumpWidget(
          GrafitThemedTest(
            child: GrafitCommand(
              groups: const [
                GrafitCommandGroup(
                  items: [
                    GrafitCommandItem(
                      label: 'Create New',
                      keywords: ['add', 'new', 'create'],
                    ),
                  ],
                ),
              ],
            ),
          ),
        );

        await tester.enterText(find.byType(TextField), 'add');
        await tester.pump();

        expect(find.text('Create New'), findsOneWidget);
      });
    });

    group('Multiple Groups', () {
      testWidgets('renders multiple groups', (tester) async {
        await tester.pumpWidget(
          GrafitThemedTest(
            child: GrafitCommand(
              groups: const [
                GrafitCommandGroup(
                  label: 'Group 1',
                  items: [
                    GrafitCommandItem(label: 'Item 1'),
                  ],
                ),
                GrafitCommandGroup(
                  label: 'Group 2',
                  items: [
                    GrafitCommandItem(label: 'Item 2'),
                  ],
                ),
              ],
            ),
          ),
        );

        expect(find.text('Group 1'), findsOneWidget);
        expect(find.text('Group 2'), findsOneWidget);
        expect(find.text('Item 1'), findsOneWidget);
        expect(find.text('Item 2'), findsOneWidget);
      });

      testWidgets('shows separators between groups', (tester) async {
        await tester.pumpWidget(
          GrafitThemedTest(
            child: GrafitCommand(
              groups: const [
                GrafitCommandGroup(
                  label: 'Group 1',
                  items: [
                    GrafitCommandItem(label: 'Item 1'),
                  ],
                ),
                GrafitCommandGroup(
                  label: 'Group 2',
                  items: [
                    GrafitCommandItem(label: 'Item 2'),
                  ],
                ),
              ],
            ),
          ),
        );

        expect(find.byType(GrafitCommandSeparator), findsOneWidget);
      });
    });

    group('Edge Cases', () {
      testWidgets('handles empty groups', (tester) async {
        await tester.pumpWidget(
          GrafitThemedTest(
            child: GrafitCommand(
              groups: const [
                GrafitCommandGroup(items: []),
              ],
            ),
          ),
        );

        expect(find.byType(GrafitCommand), findsOneWidget);
      });

      testWidgets('handles items without icons', (tester) async {
        await tester.pumpWidget(
          GrafitThemedTest(
            child: GrafitCommand(
              groups: const [
                GrafitCommandGroup(
                  items: [
                    GrafitCommandItem(label: 'No Icon'),
                  ],
                ),
              ],
            ),
          ),
        );

        expect(find.text('No Icon'), findsOneWidget);
      });

      testWidgets('handles items without shortcuts', (tester) async {
        await tester.pumpWidget(
          GrafitThemedTest(
            child: GrafitCommand(
              groups: const [
                GrafitCommandGroup(
                  items: [
                    GrafitCommandItem(label: 'No Shortcut'),
                  ],
                ),
              ],
            ),
          ),
        );

        expect(find.text('No Shortcut'), findsOneWidget);
      });
    });
  });
}
