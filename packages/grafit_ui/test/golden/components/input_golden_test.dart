import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:grafit_ui/grafit_ui.dart';
import '../helpers/golden_helpers.dart';

void main() {
  group('Input Golden Tests', () {
    testWidgets('small size', (tester) async {
      await tester.pumpWidget(
        GoldenTestWrapper(
          device: defaultGoldenDevice,
          child: const GrafitInput(
            size: GrafitInputSize.sm,
            hint: 'Small input',
          ),
        ),
      );
      await matchGolden(tester, 'input_small', device: defaultGoldenDevice);
    });

    testWidgets('medium size', (tester) async {
      await tester.pumpWidget(
        GoldenTestWrapper(
          device: defaultGoldenDevice,
          child: const GrafitInput(
            size: GrafitInputSize.md,
            hint: 'Medium input',
          ),
        ),
      );
      await matchGolden(tester, 'input_medium', device: defaultGoldenDevice);
    });

    testWidgets('large size', (tester) async {
      await tester.pumpWidget(
        GoldenTestWrapper(
          device: defaultGoldenDevice,
          child: const GrafitInput(
            size: GrafitInputSize.lg,
            hint: 'Large input',
          ),
        ),
      );
      await matchGolden(tester, 'input_large', device: defaultGoldenDevice);
    });

    testWidgets('with label', (tester) async {
      await tester.pumpWidget(
        GoldenTestWrapper(
          device: defaultGoldenDevice,
          child: const GrafitInput(
            label: 'Email',
            hint: 'Enter your email',
          ),
        ),
      );
      await matchGolden(tester, 'input_with_label', device: defaultGoldenDevice);
    });

    testWidgets('error state', (tester) async {
      await tester.pumpWidget(
        GoldenTestWrapper(
          device: defaultGoldenDevice,
          child: const GrafitInput(
            label: 'Email',
            errorText: 'Please enter a valid email address',
          ),
        ),
      );
      await matchGolden(tester, 'input_error', device: defaultGoldenDevice);
    });

    testWidgets('with helper text', (tester) async {
      await tester.pumpWidget(
        GoldenTestWrapper(
          device: defaultGoldenDevice,
          child: const GrafitInput(
            label: 'Password',
            hint: 'Enter your password',
            helperText: 'Must be at least 8 characters',
          ),
        ),
      );
      await matchGolden(tester, 'input_with_helper', device: defaultGoldenDevice);
    });

    testWidgets('disabled state', (tester) async {
      await tester.pumpWidget(
        GoldenTestWrapper(
          device: defaultGoldenDevice,
          child: const GrafitInput(
            label: 'Username',
            hint: 'Disabled input',
            enabled: false,
          ),
        ),
      );
      await matchGolden(tester, 'input_disabled', device: defaultGoldenDevice);
    });

    testWidgets('all sizes together', (tester) async {
      await tester.pumpWidget(
        GoldenTestWrapper(
          device: defaultGoldenDevice,
          child: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GrafitInput(label: 'Small', size: GrafitInputSize.sm, hint: 'Small input'),
              SizedBox(height: 16),
              GrafitInput(label: 'Medium', size: GrafitInputSize.md, hint: 'Medium input'),
              SizedBox(height: 16),
              GrafitInput(label: 'Large', size: GrafitInputSize.lg, hint: 'Large input'),
            ],
          ),
        ),
      );
      await matchGolden(tester, 'input_all_sizes', device: defaultGoldenDevice);
    });
  });
}
