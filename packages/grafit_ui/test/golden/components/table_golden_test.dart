import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:grafit_ui/grafit_ui.dart';
import '../helpers/golden_helpers.dart';

void main() {
  group('Table Golden Tests', () {
    testWidgets('basic table with data', (tester) async {
      await tester.pumpWidget(
        GoldenTestWrapper(
          device: largeGoldenDevice,
          child: SizedBox(
            width: 600,
            child: GrafitTable(
              columnCount: 3,
              rows: const [
                TableRow(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(12),
                      child: Text('John Doe'),
                    ),
                    Padding(
                      padding: EdgeInsets.all(12),
                      child: Text('john@example.com'),
                    ),
                    Padding(
                      padding: EdgeInsets.all(12),
                      child: Text('Active'),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(12),
                      child: Text('Jane Smith'),
                    ),
                    Padding(
                      padding: EdgeInsets.all(12),
                      child: Text('jane@example.com'),
                    ),
                    Padding(
                      padding: EdgeInsets.all(12),
                      child: Text('Inactive'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
      await matchGolden(tester, 'table_basic', device: largeGoldenDevice);
    });

    testWidgets('table with header', (tester) async {
      await tester.pumpWidget(
        GoldenTestWrapper(
          device: largeGoldenDevice,
          child: SizedBox(
            width: 600,
            child: GrafitTable(
              columnCount: 4,
              header: [
                GrafitTableHeader(
                  children: [
                    GrafitTableHead(child: Text('Name')),
                    GrafitTableHead(child: Text('Email')),
                    GrafitTableHead(child: Text('Status')),
                    GrafitTableHead(alignment: GrafitTableAlignment.right, child: Text('Actions')),
                  ],
                ),
              ],
              rows: [
                GrafitTableRow(
                  children: [
                    GrafitTableCell(child: Text('John Doe')),
                    GrafitTableCell(child: Text('john@example.com')),
                    GrafitTableCell(child: Text('Active')),
                    GrafitTableCell(
                      alignment: GrafitTableAlignment.right,
                      child: Text('Edit'),
                    ),
                  ],
                ),
                GrafitTableRow(
                  children: [
                    GrafitTableCell(child: Text('Jane Smith')),
                    GrafitTableCell(child: Text('jane@example.com')),
                    GrafitTableCell(child: Text('Inactive')),
                    GrafitTableCell(
                      alignment: GrafitTableAlignment.right,
                      child: Text('Edit'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
      await matchGolden(tester, 'table_with_header', device: largeGoldenDevice);
    });

    testWidgets('table with footer', (tester) async {
      await tester.pumpWidget(
        GoldenTestWrapper(
          device: largeGoldenDevice,
          child: SizedBox(
            width: 600,
            child: GrafitTable(
              columnCount: 3,
              header: [
                GrafitTableHeader(
                  children: [
                    GrafitTableHead(child: Text('Product')),
                    GrafitTableHead(child: Text('Price')),
                    GrafitTableHead(child: Text('Qty')),
                  ],
                ),
              ],
              rows: [
                GrafitTableRow(
                  children: [
                    GrafitTableCell(child: Text('Widget A')),
                    GrafitTableCell(child: Text('\$10.00')),
                    GrafitTableCell(child: Text('5')),
                  ],
                ),
                GrafitTableRow(
                  children: [
                    GrafitTableCell(child: Text('Widget B')),
                    GrafitTableCell(child: Text('\$15.00')),
                    GrafitTableCell(child: Text('3')),
                  ],
                ),
              ],
              footer: GrafitTableFooter(
                children: [
                  GrafitTableCell(child: Text('Total')),
                  GrafitTableCell(child: Text('\$95.00')),
                  GrafitTableCell(child: Text('8')),
                ],
              ),
            ),
          ),
        ),
      );
      await matchGolden(tester, 'table_with_footer', device: largeGoldenDevice);
    });

    testWidgets('table with selected row', (tester) async {
      await tester.pumpWidget(
        GoldenTestWrapper(
          device: largeGoldenDevice,
          child: SizedBox(
            width: 500,
            child: GrafitTable(
              columnCount: 3,
              header: [
                GrafitTableHeader(
                  children: [
                    GrafitTableHead(child: Text('Name')),
                    GrafitTableHead(child: Text('Email')),
                    GrafitTableHead(child: Text('Status')),
                  ],
                ),
              ],
              rows: [
                GrafitTableRow(
                  children: [
                    GrafitTableCell(child: Text('John Doe')),
                    GrafitTableCell(child: Text('john@example.com')),
                    GrafitTableCell(child: Text('Active')),
                  ],
                ),
                GrafitTableRow(
                  selected: true,
                  children: [
                    GrafitTableCell(child: Text('Jane Smith')),
                    GrafitTableCell(child: Text('jane@example.com')),
                    GrafitTableCell(child: Text('Active')),
                  ],
                ),
                GrafitTableRow(
                  children: [
                    GrafitTableCell(child: Text('Bob Johnson')),
                    GrafitTableCell(child: Text('bob@example.com')),
                    GrafitTableCell(child: Text('Inactive')),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
      await matchGolden(tester, 'table_selected_row', device: largeGoldenDevice);
    });
  });
}
