import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:grafit_ui/grafit_ui.dart';
import '../helpers/golden_helpers.dart';

void main() {
  group('Pagination Golden Tests', () {
    testWidgets('first page', (tester) async {
      await tester.pumpWidget(
        GoldenTestWrapper(
          device: defaultGoldenDevice,
          child: const GrafitPaginationWidget(
            currentPage: 0,
            totalPages: 10,
          ),
        ),
      );
      await matchGolden(tester, 'pagination_first', device: defaultGoldenDevice);
    });

    testWidgets('middle page', (tester) async {
      await tester.pumpWidget(
        GoldenTestWrapper(
          device: defaultGoldenDevice,
          child: const GrafitPaginationWidget(
            currentPage: 5,
            totalPages: 10,
          ),
        ),
      );
      await matchGolden(tester, 'pagination_middle', device: defaultGoldenDevice);
    });

    testWidgets('last page', (tester) async {
      await tester.pumpWidget(
        GoldenTestWrapper(
          device: defaultGoldenDevice,
          child: const GrafitPaginationWidget(
            currentPage: 9,
            totalPages: 10,
          ),
        ),
      );
      await matchGolden(tester, 'pagination_last', device: defaultGoldenDevice);
    });

    testWidgets('with first/last buttons', (tester) async {
      await tester.pumpWidget(
        GoldenTestWrapper(
          device: defaultGoldenDevice,
          child: const GrafitPaginationWidget(
            currentPage: 5,
            totalPages: 10,
            showFirstLast: true,
          ),
        ),
      );
      await matchGolden(tester, 'pagination_with_first_last', device: defaultGoldenDevice);
    });

    testWidgets('compact mode', (tester) async {
      await tester.pumpWidget(
        GoldenTestWrapper(
          device: defaultGoldenDevice,
          child: const GrafitPaginationWidget(
            currentPage: 5,
            totalPages: 10,
            compact: true,
          ),
        ),
      );
      await matchGolden(tester, 'pagination_compact', device: defaultGoldenDevice);
    });

    testWidgets('small page count', (tester) async {
      await tester.pumpWidget(
        GoldenTestWrapper(
          device: defaultGoldenDevice,
          child: const GrafitPaginationWidget(
            currentPage: 1,
            totalPages: 5,
          ),
        ),
      );
      await matchGolden(tester, 'pagination_small_count', device: defaultGoldenDevice);
    });

    testWidgets('large page count', (tester) async {
      await tester.pumpWidget(
        GoldenTestWrapper(
          device: defaultGoldenDevice,
          child: const GrafitPaginationWidget(
            currentPage: 25,
            totalPages: 50,
          ),
        ),
      );
      await matchGolden(tester, 'pagination_large_count', device: defaultGoldenDevice);
    });
  });
}
