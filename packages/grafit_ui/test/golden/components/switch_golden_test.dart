import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:grafit_ui/grafit_ui.dart';
import '../helpers/golden_helpers.dart';

void main() {
  group('Switch Golden Tests', () {
    testWidgets('off state', (tester) async {
      await tester.pumpWidget(
        GoldenTestWrapper(
          device: defaultGoldenDevice,
          child: const GrafitSwitch(
            value: false,
            label: 'Dark mode',
          ),
        ),
      );
      await matchGolden(tester, 'switch_off', device: defaultGoldenDevice);
    });

    testWidgets('on state', (tester) async {
      await tester.pumpWidget(
        GoldenTestWrapper(
          device: defaultGoldenDevice,
          child: const GrafitSwitch(
            value: true,
            label: 'Dark mode',
          ),
        ),
      );
      await matchGolden(tester, 'switch_on', device: defaultGoldenDevice);
    });

    testWidgets('without label', (tester) async {
      await tester.pumpWidget(
        GoldenTestWrapper(
          device: defaultGoldenDevice,
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              GrafitSwitch(value: false),
              SizedBox(width: 16),
              GrafitSwitch(value: true),
            ],
          ),
        ),
      );
      await matchGolden(tester, 'switch_without_label', device: defaultGoldenDevice);
    });

    testWidgets('size variants', (tester) async {
      await tester.pumpWidget(
        GoldenTestWrapper(
          device: defaultGoldenDevice,
          child: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GrafitSwitch(value: true, label: 'Small switch', size: GrafitSwitchSize.sm),
              SizedBox(height: 12),
              GrafitSwitch(value: true, label: 'Default switch', size: GrafitSwitchSize.value),
            ],
          ),
        ),
      );
      await matchGolden(tester, 'switch_sizes', device: defaultGoldenDevice);
    });

    testWidgets('disabled state', (tester) async {
      await tester.pumpWidget(
        GoldenTestWrapper(
          device: defaultGoldenDevice,
          child: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GrafitSwitch(value: false, label: 'Disabled off', enabled: false),
              SizedBox(height: 12),
              GrafitSwitch(value: true, label: 'Disabled on', enabled: false),
            ],
          ),
        ),
      );
      await matchGolden(tester, 'switch_disabled', device: defaultGoldenDevice);
    });

    testWidgets('multiple switches', (tester) async {
      await tester.pumpWidget(
        GoldenTestWrapper(
          device: defaultGoldenDevice,
          child: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GrafitSwitch(value: true, label: 'Notifications'),
              SizedBox(height: 12),
              GrafitSwitch(value: false, label: 'Email updates'),
              SizedBox(height: 12),
              GrafitSwitch(value: true, label: 'Auto-save'),
            ],
          ),
        ),
      );
      await matchGolden(tester, 'switch_multiple', device: defaultGoldenDevice);
    });
  });
}
