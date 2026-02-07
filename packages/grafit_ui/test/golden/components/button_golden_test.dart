import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:grafit_ui/grafit_ui.dart';
import '../helpers/golden_helpers.dart';

void main() {
  group('Button Golden Tests', () {
    testWidgets('primary variant', (tester) async {
      await tester.pumpWidget(
        GoldenTestWrapper(
          device: defaultGoldenDevice,
          child: const GrafitButton(
            label: 'Primary Button',
            variant: GrafitButtonVariant.primary,
          ),
        ),
      );
      await matchGolden(tester, 'button_primary', device: defaultGoldenDevice);
    });

    testWidgets('secondary variant', (tester) async {
      await tester.pumpWidget(
        GoldenTestWrapper(
          device: defaultGoldenDevice,
          child: const GrafitButton(
            label: 'Secondary Button',
            variant: GrafitButtonVariant.secondary,
          ),
        ),
      );
      await matchGolden(tester, 'button_secondary', device: defaultGoldenDevice);
    });

    testWidgets('ghost variant', (tester) async {
      await tester.pumpWidget(
        GoldenTestWrapper(
          device: defaultGoldenDevice,
          child: const GrafitButton(
            label: 'Ghost Button',
            variant: GrafitButtonVariant.ghost,
          ),
        ),
      );
      await matchGolden(tester, 'button_ghost', device: defaultGoldenDevice);
    });

    testWidgets('link variant', (tester) async {
      await tester.pumpWidget(
        GoldenTestWrapper(
          device: defaultGoldenDevice,
          child: const GrafitButton(
            label: 'Link Button',
            variant: GrafitButtonVariant.link,
          ),
        ),
      );
      await matchGolden(tester, 'button_link', device: defaultGoldenDevice);
    });

    testWidgets('destructive variant', (tester) async {
      await tester.pumpWidget(
        GoldenTestWrapper(
          device: defaultGoldenDevice,
          child: const GrafitButton(
            label: 'Destructive',
            variant: GrafitButtonVariant.destructive,
          ),
        ),
      );
      await matchGolden(tester, 'button_destructive', device: defaultGoldenDevice);
    });

    testWidgets('outline variant', (tester) async {
      await tester.pumpWidget(
        GoldenTestWrapper(
          device: defaultGoldenDevice,
          child: const GrafitButton(
            label: 'Outline Button',
            variant: GrafitButtonVariant.outline,
          ),
        ),
      );
      await matchGolden(tester, 'button_outline', device: defaultGoldenDevice);
    });

    testWidgets('all variants together', (tester) async {
      await tester.pumpWidget(
        GoldenTestWrapper(
          device: defaultGoldenDevice,
          child: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GrafitButton(label: 'Primary', variant: GrafitButtonVariant.primary),
              SizedBox(height: 8),
              GrafitButton(label: 'Secondary', variant: GrafitButtonVariant.secondary),
              SizedBox(height: 8),
              GrafitButton(label: 'Ghost', variant: GrafitButtonVariant.ghost),
              SizedBox(height: 8),
              GrafitButton(label: 'Link', variant: GrafitButtonVariant.link),
              SizedBox(height: 8),
              GrafitButton(label: 'Destructive', variant: GrafitButtonVariant.destructive),
              SizedBox(height: 8),
              GrafitButton(label: 'Outline', variant: GrafitButtonVariant.outline),
            ],
          ),
        ),
      );
      await matchGolden(tester, 'button_all_variants', device: defaultGoldenDevice);
    });

    testWidgets('size variants', (tester) async {
      await tester.pumpWidget(
        GoldenTestWrapper(
          device: defaultGoldenDevice,
          child: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GrafitButton(label: 'Small', size: GrafitButtonSize.sm),
              SizedBox(height: 8),
              GrafitButton(label: 'Medium', size: GrafitButtonSize.md),
              SizedBox(height: 8),
              GrafitButton(label: 'Large', size: GrafitButtonSize.lg),
              SizedBox(height: 8),
              GrafitButton(size: GrafitButtonSize.icon, icon: Icons.favorite),
            ],
          ),
        ),
      );
      await matchGolden(tester, 'button_sizes', device: defaultGoldenDevice);
    });

    testWidgets('disabled state', (tester) async {
      await tester.pumpWidget(
        GoldenTestWrapper(
          device: defaultGoldenDevice,
          child: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GrafitButton(label: 'Disabled Primary', variant: GrafitButtonVariant.primary, disabled: true),
              SizedBox(height: 8),
              GrafitButton(label: 'Disabled Secondary', variant: GrafitButtonVariant.secondary, disabled: true),
              SizedBox(height: 8),
              GrafitButton(label: 'Disabled Destructive', variant: GrafitButtonVariant.destructive, disabled: true),
            ],
          ),
        ),
      );
      await matchGolden(tester, 'button_disabled', device: defaultGoldenDevice);
    });

    testWidgets('with icons', (tester) async {
      await tester.pumpWidget(
        GoldenTestWrapper(
          device: defaultGoldenDevice,
          child: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GrafitButton(label: 'With Icon', icon: Icons.favorite),
              SizedBox(height: 8),
              GrafitButton(label: 'Leading', leading: Icon(Icons.arrow_back)),
              SizedBox(height: 8),
              GrafitButton(label: 'Trailing', trailing: Icon(Icons.arrow_forward)),
            ],
          ),
        ),
      );
      await matchGolden(tester, 'button_with_icons', device: defaultGoldenDevice);
    });
  });
}
