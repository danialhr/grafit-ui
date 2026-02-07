import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:grafit_ui/grafit_ui.dart';
import '../helpers/golden_helpers.dart';

void main() {
  group('Breadcrumb Golden Tests', () {
    testWidgets('default breadcrumb', (tester) async {
      await tester.pumpWidget(
        GoldenTestWrapper(
          device: defaultGoldenDevice,
          child: const GrafitBreadcrumb(
            items: [
              GrafitBreadcrumbItem(
                child: GrafitBreadcrumbLink(label: 'Home'),
              ),
              GrafitBreadcrumbItem(
                child: GrafitBreadcrumbLink(label: 'Components'),
              ),
              GrafitBreadcrumbItem(
                child: GrafitBreadcrumbPage(label: 'Breadcrumb'),
              ),
            ],
          ),
        ),
      );
      await matchGolden(tester, 'breadcrumb_default', device: defaultGoldenDevice);
    });

    testWidgets('long trail', (tester) async {
      await tester.pumpWidget(
        GoldenTestWrapper(
          device: defaultGoldenDevice,
          child: const GrafitBreadcrumb(
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
      );
      await matchGolden(tester, 'breadcrumb_long', device: defaultGoldenDevice);
    });

    testWidgets('with icons', (tester) async {
      await tester.pumpWidget(
        GoldenTestWrapper(
          device: defaultGoldenDevice,
          child: const GrafitBreadcrumb(
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
                    GrafitBreadcrumbLink(label: 'Projects'),
                  ],
                ),
              ),
              GrafitBreadcrumbItem(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.insert_drive_file, size: 16),
                    SizedBox(width: 4),
                    GrafitBreadcrumbPage(label: 'File.txt'),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
      await matchGolden(tester, 'breadcrumb_with_icons', device: defaultGoldenDevice);
    });

    testWidgets('custom separator', (tester) async {
      await tester.pumpWidget(
        GoldenTestWrapper(
          device: defaultGoldenDevice,
          child: GrafitBreadcrumb(
            items: const [
              GrafitBreadcrumbItem(
                child: GrafitBreadcrumbLink(label: 'Home'),
              ),
              GrafitBreadcrumbItem(
                child: GrafitBreadcrumbPage(label: 'Page'),
              ),
            ],
            separator: const Text('/'),
          ),
        ),
      );
      await matchGolden(tester, 'breadcrumb_custom_separator', device: defaultGoldenDevice);
    });

    testWidgets('with ellipsis', (tester) async {
      await tester.pumpWidget(
        GoldenTestWrapper(
          device: defaultGoldenDevice,
          child: const GrafitBreadcrumb(
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
                child: GrafitBreadcrumbPage(label: 'Current Page'),
              ),
            ],
          ),
        ),
      );
      await matchGolden(tester, 'breadcrumb_ellipsis', device: defaultGoldenDevice);
    });
  });
}
