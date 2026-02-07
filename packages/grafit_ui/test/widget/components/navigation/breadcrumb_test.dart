import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grafit_ui/src/components/navigation/breadcrumb.dart';
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
  group('GrafitBreadcrumb', () {
    group('Rendering', () {
      testWidgets('renders without error', (tester) async {
        await tester.pumpWidget(
          const GrafitThemedTest(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: GrafitBreadcrumb(
                items: [
                  GrafitBreadcrumbItem(
                    child: GrafitBreadcrumbLink(label: 'Home'),
                  ),
                  GrafitBreadcrumbItem(
                    child: GrafitBreadcrumbPage(label: 'Current'),
                  ),
                ],
              ),
            ),
          ),
        );
        expect(find.byType(GrafitBreadcrumb), findsOneWidget);
      });

      testWidgets('renders breadcrumb with default separators', (tester) async {
        await tester.pumpWidget(
          const GrafitThemedTest(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: GrafitBreadcrumb(
                items: [
                  GrafitBreadcrumbItem(
                    child: GrafitBreadcrumbLink(label: 'Home'),
                  ),
                  GrafitBreadcrumbItem(
                    child: GrafitBreadcrumbLink(label: 'Products'),
                  ),
                  GrafitBreadcrumbItem(
                    child: GrafitBreadcrumbPage(label: 'Current'),
                  ),
                ],
              ),
            ),
          ),
        );
        expect(find.text('Home'), findsOneWidget);
        expect(find.text('Products'), findsOneWidget);
        expect(find.text('Current'), findsOneWidget);
      });

      testWidgets('renders breadcrumb with custom separators', (tester) async {
        await tester.pumpWidget(
          GrafitThemedTest(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: GrafitBreadcrumb(
                separator: const Text('/'),
                items: const [
                  GrafitBreadcrumbItem(
                    child: GrafitBreadcrumbLink(label: 'Home'),
                  ),
                  GrafitBreadcrumbItem(
                    child: GrafitBreadcrumbPage(label: 'Page'),
                  ),
                ],
              ),
            ),
          ),
        );
        expect(find.text('/'), findsOneWidget);
      });

      testWidgets('renders minimal breadcrumb', (tester) async {
        await tester.pumpWidget(
          const GrafitThemedTest(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: GrafitBreadcrumb(
                items: [
                  GrafitBreadcrumbItem(
                    child: GrafitBreadcrumbLink(label: 'Back'),
                  ),
                  GrafitBreadcrumbItem(
                    child: GrafitBreadcrumbPage(label: 'Current'),
                  ),
                ],
              ),
            ),
          ),
        );
        expect(find.byType(GrafitBreadcrumb), findsOneWidget);
      });
    });

    group('Long Trail', () {
      testWidgets('renders long breadcrumb trail', (tester) async {
        await tester.pumpWidget(
          const GrafitThemedTest(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: GrafitBreadcrumb(
                items: [
                  GrafitBreadcrumbItem(
                    child: GrafitBreadcrumbLink(label: 'Home'),
                  ),
                  GrafitBreadcrumbItem(
                    child: GrafitBreadcrumbLink(label: 'Products'),
                  ),
                  GrafitBreadcrumbItem(
                    child: GrafitBreadcrumbLink(label: 'Electronics'),
                  ),
                  GrafitBreadcrumbItem(
                    child: GrafitBreadcrumbLink(label: 'Computers'),
                  ),
                  GrafitBreadcrumbItem(
                    child: GrafitBreadcrumbPage(label: 'Laptops'),
                  ),
                ],
              ),
            ),
          ),
        );
        expect(find.text('Home'), findsOneWidget);
        expect(find.text('Laptops'), findsOneWidget);
      });
    });

    group('With Icons', () {
      testWidgets('renders breadcrumb with icons', (tester) async {
        await tester.pumpWidget(
          const GrafitThemedTest(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: GrafitBreadcrumb(
                items: [
                  GrafitBreadcrumbItem(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.home, size: 16),
                        SizedBox(width: 4),
                        GrafitBreadcrumbLink(label: 'Home'),
                      ],
                    ),
                  ),
                  GrafitBreadcrumbItem(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.folder, size: 16),
                        SizedBox(width: 4),
                        GrafitBreadcrumbPage(label: 'Projects'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
        expect(find.byIcon(Icons.home), findsOneWidget);
        expect(find.byIcon(Icons.folder), findsOneWidget);
      });
    });

    group('Ellipsis', () {
      testWidgets('renders breadcrumb with ellipsis', (tester) async {
        await tester.pumpWidget(
          const GrafitThemedTest(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: GrafitBreadcrumb(
                items: [
                  GrafitBreadcrumbItem(
                    child: GrafitBreadcrumbLink(label: 'Home'),
                  ),
                  GrafitBreadcrumbItem(
                    child: GrafitBreadcrumbEllipsis(),
                  ),
                  GrafitBreadcrumbItem(
                    child: GrafitBreadcrumbLink(label: 'Parent'),
                  ),
                  GrafitBreadcrumbItem(
                    child: GrafitBreadcrumbPage(label: 'Current'),
                  ),
                ],
              ),
            ),
          ),
        );
        expect(find.byType(GrafitBreadcrumbEllipsis), findsOneWidget);
        expect(find.byIcon(Icons.more_horiz), findsOneWidget);
      });
    });

    group('Breadcrumb Link Interactions', () {
      testWidgets('calls onTap when link is tapped', (tester) async {
        bool tapped = false;

        await tester.pumpWidget(
          GrafitThemedTest(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: GrafitBreadcrumb(
                items: [
                  GrafitBreadcrumbItem(
                    child: GrafitBreadcrumbLink(
                      label: 'Home',
                      onTap: () => tapped = true,
                    ),
                  ),
                  GrafitBreadcrumbItem(
                    child: GrafitBreadcrumbPage(label: 'Current'),
                  ),
                ],
              ),
            ),
          ),
        );

        await tester.tap(find.text('Home'));
        await tester.pumpAndSettle();

        expect(tapped, isTrue);
      });

      testWidgets('shows active state correctly', (tester) async {
        await tester.pumpWidget(
          const GrafitThemedTest(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: GrafitBreadcrumb(
                items: [
                  GrafitBreadcrumbItem(
                    child: GrafitBreadcrumbLink(label: 'Home'),
                  ),
                  GrafitBreadcrumbItem(
                    child: GrafitBreadcrumbPage(label: 'Current', isActive: true),
                  ),
                ],
              ),
            ),
          ),
        );
        expect(find.byType(GrafitBreadcrumbPage), findsOneWidget);
      });
    });

    group('Breadcrumb Components', () {
      testWidgets('renders breadcrumb separator', (tester) async {
        await tester.pumpWidget(
          const GrafitThemedTest(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Text('Before'),
                  GrafitBreadcrumbSeparator(),
                  Text('After'),
                ],
              ),
            ),
          ),
        );
        expect(find.byType(GrafitBreadcrumbSeparator), findsOneWidget);
      });

      testWidgets('renders breadcrumb ellipsis component', (tester) async {
        bool tapped = false;

        await tester.pumpWidget(
          GrafitThemedTest(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: GrafitBreadcrumbEllipsis(
                onTap: () => tapped = true,
              ),
            ),
          ),
        );

        expect(find.byType(GrafitBreadcrumbEllipsis), findsOneWidget);

        await tester.tap(find.byType(GrafitBreadcrumbEllipsis));
        await tester.pumpAndSettle();

        expect(tapped, isTrue);
      });
    });
  });
}
