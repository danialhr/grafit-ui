import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:grafit_ui/grafit_ui.dart';
import '../helpers/golden_helpers.dart';

void main() {
  group('Checkbox Golden Tests', () {
    testWidgets('unchecked state', (tester) async {
      await tester.pumpWidget(
        GoldenTestWrapper(
          device: defaultGoldenDevice,
          child: const GrafitCheckbox(
            value: false,
            label: 'Accept terms and conditions',
          ),
        ),
      );
      await matchGolden(tester, 'checkbox_unchecked', device: defaultGoldenDevice);
    });

    testWidgets('checked state', (tester) async {
      await tester.pumpWidget(
        GoldenTestWrapper(
          device: defaultGoldenDevice,
          child: const GrafitCheckbox(
            value: true,
            label: 'Accept terms and conditions',
          ),
        ),
      );
      await matchGolden(tester, 'checkbox_checked', device: defaultGoldenDevice);
    });

    testWidgets('without label', (tester) async {
      await tester.pumpWidget(
        GoldenTestWrapper(
          device: defaultGoldenDevice,
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              GrafitCheckbox(value: false),
              SizedBox(width: 16),
              GrafitCheckbox(value: true),
            ],
          ),
        ),
      );
      await matchGolden(tester, 'checkbox_without_label', device: defaultGoldenDevice);
    });

    testWidgets('size variants', (tester) async {
      await tester.pumpWidget(
        GoldenTestWrapper(
          device: defaultGoldenDevice,
          child: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GrafitCheckbox(value: true, label: 'Small', size: GrafitInputSizeX.sm),
              SizedBox(height: 12),
              GrafitCheckbox(value: true, label: 'Medium', size: GrafitInputSizeX.md),
              SizedBox(height: 12),
              GrafitCheckbox(value: true, label: 'Large', size: GrafitInputSizeX.lg),
            ],
          ),
        ),
      );
      await matchGolden(tester, 'checkbox_sizes', device: defaultGoldenDevice);
    });

    testWidgets('disabled state', (tester) async {
      await tester.pumpWidget(
        GoldenTestWrapper(
          device: defaultGoldenDevice,
          child: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GrafitCheckbox(value: false, label: 'Disabled unchecked', enabled: false),
              SizedBox(height: 12),
              GrafitCheckbox(value: true, label: 'Disabled checked', enabled: false),
            ],
          ),
        ),
      );
      await matchGolden(tester, 'checkbox_disabled', device: defaultGoldenDevice);
    });

    testWidgets('multiple checkboxes', (tester) async {
      await tester.pumpWidget(
        GoldenTestWrapper(
          device: defaultGoldenDevice,
          child: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GrafitCheckbox(value: true, label: 'Remember me'),
              SizedBox(height: 12),
              GrafitCheckbox(value: false, label: 'Subscribe to newsletter'),
              SizedBox(height: 12),
              GrafitCheckbox(value: true, label: 'Accept privacy policy'),
            ],
          ),
        ),
      );
      await matchGolden(tester, 'checkbox_multiple', device: defaultGoldenDevice);
    });
  });
}
