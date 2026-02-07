import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:grafit_ui/grafit_ui.dart';
import '../helpers/golden_helpers.dart';

void main() {
  group('Card Golden Tests', () {
    testWidgets('simple card', (tester) async {
      await tester.pumpWidget(
        GoldenTestWrapper(
          device: defaultGoldenDevice,
          child: SizedBox(
            width: 300,
            child: GrafitCard(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Card Title',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'This is a simple card with some content inside it.',
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
      await matchGolden(tester, 'card_simple', device: defaultGoldenDevice);
    });

    testWidgets('card with header and footer', (tester) async {
      await tester.pumpWidget(
        GoldenTestWrapper(
          device: defaultGoldenDevice,
          child: SizedBox(
            width: 300,
            child: const GrafitCard(
              padding: EdgeInsets.zero,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GrafitCardHeader(
                    title: 'Account',
                    description: 'Manage your account settings',
                  ),
                  Padding(
                    padding: EdgeInsets.all(16),
                    child: Text(
                      'Your account information and settings go here.',
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                  GrafitCardFooter(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text('Save changes', style: TextStyle(fontSize: 14)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
      await matchGolden(tester, 'card_with_header_footer', device: defaultGoldenDevice);
    });

    testWidgets('card without border', (tester) async {
      await tester.pumpWidget(
        GoldenTestWrapper(
          device: defaultGoldenDevice,
          child: SizedBox(
            width: 300,
            child: GrafitCard(
              bordered: false,
              child: const Text(
                'Card without border',
                style: TextStyle(fontSize: 14),
              ),
            ),
          ),
        ),
      );
      await matchGolden(tester, 'card_no_border', device: defaultGoldenDevice);
    });

    testWidgets('card with shadow', (tester) async {
      await tester.pumpWidget(
        GoldenTestWrapper(
          device: defaultGoldenDevice,
          child: SizedBox(
            width: 300,
            child: GrafitCard(
              shadow: true,
              child: const Text(
                'Card with shadow',
                style: TextStyle(fontSize: 14),
              ),
            ),
          ),
        ),
      );
      await matchGolden(tester, 'card_with_shadow', device: defaultGoldenDevice);
    });

    testWidgets('card with action in header', (tester) async {
      await tester.pumpWidget(
        GoldenTestWrapper(
          device: defaultGoldenDevice,
          child: SizedBox(
            width: 300,
            child: const GrafitCard(
              padding: EdgeInsets.zero,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GrafitCardHeader(
                    title: 'Settings',
                    action: Icon(Icons.more_vert),
                  ),
                  Padding(
                    padding: EdgeInsets.all(16),
                    child: Text(
                      'Card with action button in header',
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
      await matchGolden(tester, 'card_with_action', device: defaultGoldenDevice);
    });
  });
}
