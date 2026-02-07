import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:grafit_ui/grafit_ui.dart';
import '../helpers/golden_helpers.dart';

void main() {
  group('Alert Golden Tests', () {
    testWidgets('default variant', (tester) async {
      await tester.pumpWidget(
        GoldenTestWrapper(
          device: defaultGoldenDevice,
          child: const SizedBox(
            width: 400,
            child: GrafitAlert(
              title: 'Information',
              description: 'This is an informational alert message.',
              variant: GrafitAlertVariant.value,
            ),
          ),
        ),
      );
      await matchGolden(tester, 'alert_default', device: defaultGoldenDevice);
    });

    testWidgets('destructive variant', (tester) async {
      await tester.pumpWidget(
        GoldenTestWrapper(
          device: defaultGoldenDevice,
          child: const SizedBox(
            width: 400,
            child: GrafitAlert(
              title: 'Error',
              description: 'Something went wrong. Please try again.',
              variant: GrafitAlertVariant.destructive,
            ),
          ),
        ),
      );
      await matchGolden(tester, 'alert_destructive', device: defaultGoldenDevice);
    });

    testWidgets('warning variant', (tester) async {
      await tester.pumpWidget(
        GoldenTestWrapper(
          device: defaultGoldenDevice,
          child: const SizedBox(
            width: 400,
            child: GrafitAlert(
              title: 'Warning',
              description: 'Please review this important warning.',
              variant: GrafitAlertVariant.warning,
            ),
          ),
        ),
      );
      await matchGolden(tester, 'alert_warning', device: defaultGoldenDevice);
    });

    testWidgets('without description', (tester) async {
      await tester.pumpWidget(
        GoldenTestWrapper(
          device: defaultGoldenDevice,
          child: SizedBox(
            width: 400,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                GrafitAlert(
                  title: 'Information',
                  variant: GrafitAlertVariant.value,
                ),
                SizedBox(height: 8),
                GrafitAlert(
                  title: 'Error',
                  variant: GrafitAlertVariant.destructive,
                ),
                SizedBox(height: 8),
                GrafitAlert(
                  title: 'Warning',
                  variant: GrafitAlertVariant.warning,
                ),
              ],
            ),
          ),
        ),
      );
      await matchGolden(tester, 'alert_no_description', device: defaultGoldenDevice);
    });

    testWidgets('all variants together', (tester) async {
      await tester.pumpWidget(
        GoldenTestWrapper(
          device: defaultGoldenDevice,
          child: SizedBox(
            width: 400,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                GrafitAlert(
                  title: 'Information',
                  description: 'This is an informational message.',
                  variant: GrafitAlertVariant.value,
                ),
                SizedBox(height: 8),
                GrafitAlert(
                  title: 'Error',
                  description: 'This is an error message.',
                  variant: GrafitAlertVariant.destructive,
                ),
                SizedBox(height: 8),
                GrafitAlert(
                  title: 'Warning',
                  description: 'This is a warning message.',
                  variant: GrafitAlertVariant.warning,
                ),
              ],
            ),
          ),
        ),
      );
      await matchGolden(tester, 'alert_all_variants', device: defaultGoldenDevice);
    });
  });
}
