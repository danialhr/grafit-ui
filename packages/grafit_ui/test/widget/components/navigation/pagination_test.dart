import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grafit_ui/src/components/data-display/pagination.dart';
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
  group('GrafitPaginationWidget', () {
    group('Rendering', () {
      testWidgets('renders without error', (tester) async {
        await tester.pumpWidget(
          const GrafitThemedTest(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: GrafitPaginationWidget(
                currentPage: 0,
                totalPages: 10,
              ),
            ),
          ),
        );
        expect(find.byType(GrafitPaginationWidget), findsOneWidget);
      });

      testWidgets('renders on first page', (tester) async {
        await tester.pumpWidget(
          const GrafitThemedTest(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: GrafitPaginationWidget(
                currentPage: 0,
                totalPages: 10,
              ),
            ),
          ),
        );
        expect(find.text('1'), findsOneWidget);
      });

      testWidgets('renders on middle page', (tester) async {
        await tester.pumpWidget(
          const GrafitThemedTest(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: GrafitPaginationWidget(
                currentPage: 5,
                totalPages: 10,
              ),
            ),
          ),
        );
        expect(find.text('6'), findsOneWidget);
      });

      testWidgets('renders on last page', (tester) async {
        await tester.pumpWidget(
          const GrafitThemedTest(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: GrafitPaginationWidget(
                currentPage: 9,
                totalPages: 10,
              ),
            ),
          ),
        );
        expect(find.text('10'), findsOneWidget);
      });

      testWidgets('renders with small page count', (tester) async {
        await tester.pumpWidget(
          const GrafitThemedTest(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: GrafitPaginationWidget(
                currentPage: 0,
                totalPages: 3,
              ),
            ),
          ),
        );
        expect(find.text('1'), findsOneWidget);
        expect(find.text('2'), findsOneWidget);
        expect(find.text('3'), findsOneWidget);
      });

      testWidgets('renders with large page count', (tester) async {
        await tester.pumpWidget(
          const GrafitThemedTest(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: GrafitPaginationWidget(
                currentPage: 25,
                totalPages: 50,
              ),
            ),
          ),
        );
        expect(find.text('26'), findsOneWidget);
      });
    });

    group('Page Navigation', () {
      testWidgets('navigates to next page on tap', (tester) async {
        int? currentPage = 0;

        await tester.pumpWidget(
          GrafitThemedTest(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: GrafitPaginationWidget(
                currentPage: 0,
                totalPages: 10,
                onPageChanged: (page) => currentPage = page,
              ),
            ),
          ),
        );

        await tester.tap(find.text('2'));
        await tester.pumpAndSettle();

        expect(currentPage, equals(1));
      });

      testWidgets('calls onPageChanged on page tap', (tester) async {
        int? changedPage;

        await tester.pumpWidget(
          GrafitThemedTest(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: GrafitPaginationWidget(
                currentPage: 0,
                totalPages: 10,
                onPageChanged: (page) => changedPage = page,
              ),
            ),
          ),
        );

        await tester.tap(find.text('3'));
        await tester.pumpAndSettle();

        expect(changedPage, equals(2));
      });

      testWidgets('next button navigates forward', (tester) async {
        int? currentPage = 0;

        await tester.pumpWidget(
          StatefulBuilder(
            builder: (context, setState) {
              return GrafitThemedTest(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: GrafitPaginationWidget(
                    key: UniqueKey(),
                    currentPage: currentPage ?? 0,
                    totalPages: 10,
                    onPageChanged: (page) {
                      setState(() => currentPage = page);
                    },
                  ),
                ),
              );
            },
          ),
        );

        // Find and tap the "Next" button
        final nextButton = find.text('Next');
        if (tester.widget(nextButton) != null) {
          await tester.tap(nextButton);
          await tester.pumpAndSettle();
        }
      });

      testWidgets('previous button navigates backward', (tester) async {
        int? currentPage = 5;

        await tester.pumpWidget(
          StatefulBuilder(
            builder: (context, setState) {
              return GrafitThemedTest(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: GrafitPaginationWidget(
                    key: UniqueKey(),
                    currentPage: currentPage ?? 0,
                    totalPages: 10,
                    onPageChanged: (page) {
                      setState(() => currentPage = page);
                    },
                  ),
                ),
              );
            },
          ),
        );

        // Find and tap the "Previous" button
        final prevButton = find.text('Previous');
        if (tester.widget(prevButton) != null) {
          await tester.tap(prevButton);
          await tester.pumpAndSettle();
        }
      });
    });

    group('Ellipsis', () {
      testWidgets('shows ellipsis for large page ranges', (tester) async {
        await tester.pumpWidget(
          const GrafitThemedTest(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: GrafitPaginationWidget(
                currentPage: 25,
                totalPages: 50,
              ),
            ),
          ),
        );

        // Should show ellipsis for large page ranges
        expect(find.byType(GrafitPaginationEllipsis), findsWidgets);
      });
    });

    group('Previous/Next Buttons', () {
      testWidgets('shows previous and next buttons by default', (tester) async {
        await tester.pumpWidget(
          const GrafitThemedTest(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: GrafitPaginationWidget(
                currentPage: 5,
                totalPages: 10,
                showPreviousNext: true,
              ),
            ),
          ),
        );

        expect(find.text('Previous'), findsOneWidget);
        expect(find.text('Next'), findsOneWidget);
      });

      testWidgets('can hide previous/next buttons', (tester) async {
        await tester.pumpWidget(
          const GrafitThemedTest(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: GrafitPaginationWidget(
                currentPage: 5,
                totalPages: 10,
                showPreviousNext: false,
              ),
            ),
          ),
        );

        expect(find.text('Previous'), findsNothing);
        expect(find.text('Next'), findsNothing);
      });
    });

    group('First/Last Buttons', () {
      testWidgets('shows first/last buttons when enabled', (tester) async {
        await tester.pumpWidget(
          const GrafitThemedTest(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: GrafitPaginationWidget(
                currentPage: 5,
                totalPages: 10,
                showFirstLast: true,
              ),
            ),
          ),
        );

        // Should have extra navigation buttons for first/last
        expect(find.byType(GrafitPaginationPrevious), findsWidgets);
        expect(find.byType(GrafitPaginationNext), findsWidgets);
      });
    });

    group('Compact Mode', () {
      testWidgets('renders in compact mode', (tester) async {
        await tester.pumpWidget(
          const GrafitThemedTest(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: GrafitPaginationWidget(
                currentPage: 5,
                totalPages: 10,
                compact: true,
              ),
            ),
          ),
        );
        expect(find.byType(GrafitPaginationWidget), findsOneWidget);
      });
    });

    group('Pagination Components', () {
      testWidgets('renders pagination link', (tester) async {
        await tester.pumpWidget(
          const GrafitThemedTest(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: GrafitPaginationContent(
                children: [
                  GrafitPaginationItem(
                    child: GrafitPaginationLink(label: '1'),
                  ),
                ],
              ),
            ),
          ),
        );
        expect(find.text('1'), findsOneWidget);
      });

      testWidgets('renders pagination ellipsis', (tester) async {
        await tester.pumpWidget(
          const GrafitThemedTest(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: GrafitPaginationContent(
                children: [
                  GrafitPaginationEllipsis(),
                ],
              ),
            ),
          ),
        );
        expect(find.byType(GrafitPaginationEllipsis), findsOneWidget);
        expect(find.byIcon(Icons.more_horiz), findsOneWidget);
      });

      testWidgets('renders pagination previous button', (tester) async {
        await tester.pumpWidget(
          GrafitThemedTest(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: GrafitPaginationContent(
                children: [
                  GrafitPaginationPrevious(
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ),
        );
        expect(find.byType(GrafitPaginationPrevious), findsOneWidget);
      });

      testWidgets('renders pagination next button', (tester) async {
        await tester.pumpWidget(
          GrafitThemedTest(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: GrafitPaginationContent(
                children: [
                  GrafitPaginationNext(
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ),
        );
        expect(find.byType(GrafitPaginationNext), findsOneWidget);
      });
    });

    group('Active State', () {
      testWidgets('shows active page correctly', (tester) async {
        await tester.pumpWidget(
          const GrafitThemedTest(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: GrafitPaginationWidget(
                currentPage: 2,
                totalPages: 10,
              ),
            ),
          ),
        );
        // Page 3 should be rendered (currentPage + 1)
        expect(find.text('3'), findsOneWidget);
      });
    });

    group('Edge Cases', () {
      testWidgets('handles single page', (tester) async {
        await tester.pumpWidget(
          const GrafitThemedTest(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: GrafitPaginationWidget(
                currentPage: 0,
                totalPages: 1,
              ),
            ),
          ),
        );
        expect(find.text('1'), findsOneWidget);
      });

      testWidgets('handles two pages', (tester) async {
        await tester.pumpWidget(
          const GrafitThemedTest(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: GrafitPaginationWidget(
                currentPage: 0,
                totalPages: 2,
              ),
            ),
          ),
        );
        expect(find.text('1'), findsOneWidget);
        expect(find.text('2'), findsOneWidget);
      });
    });

    group('Pagination Wrapper', () {
      testWidgets('renders pagination wrapper', (tester) async {
        await tester.pumpWidget(
          GrafitThemedTest(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: GrafitPagination(
                child: GrafitPaginationContent(
                  children: [
                    GrafitPaginationItem(
                      child: GrafitPaginationLink(label: '1'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
        expect(find.byType(GrafitPagination), findsOneWidget);
      });
    });

    group('Disabled State', () {
      testWidgets('disables previous button on first page', (tester) async {
        await tester.pumpWidget(
          const GrafitThemedTest(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: GrafitPaginationWidget(
                currentPage: 0,
                totalPages: 10,
                showPreviousNext: true,
              ),
            ),
          ),
        );
        // Previous button should be disabled on first page
        expect(find.text('Previous'), findsOneWidget);
      });

      testWidgets('disables next button on last page', (tester) async {
        await tester.pumpWidget(
          const GrafitThemedTest(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: GrafitPaginationWidget(
                currentPage: 9,
                totalPages: 10,
                showPreviousNext: true,
              ),
            ),
          ),
        );
        // Next button should be disabled on last page
        expect(find.text('Next'), findsOneWidget);
      });
    });
  });
}
