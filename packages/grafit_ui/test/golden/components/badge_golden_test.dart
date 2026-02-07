import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:grafit_ui/grafit_ui.dart';
import '../helpers/golden_helpers.dart';

void main() {
  group('Badge Golden Tests', () {
    testWidgets('default variant', (tester) async {
      await tester.pumpWidget(
        GoldenTestWrapper(
          device: defaultGoldenDevice,
          child: const GrafitBadge(
            label: 'Badge',
            variant: GrafitBadgeVariant.value,
          ),
        ),
      );
      await matchGolden(tester, 'badge_default', device: defaultGoldenDevice);
    });

    testWidgets('primary variant', (tester) async {
      await tester.pumpWidget(
        GoldenTestWrapper(
          device: defaultGoldenDevice,
          child: const GrafitBadge(
            label: 'Primary',
            variant: GrafitBadgeVariant.primary,
          ),
        ),
      );
      await matchGolden(tester, 'badge_primary', device: defaultGoldenDevice);
    });

    testWidgets('secondary variant', (tester) async {
      await tester.pumpWidget(
        GoldenTestWrapper(
          device: defaultGoldenDevice,
          child: const GrafitBadge(
            label: 'Secondary',
            variant: GrafitBadgeVariant.secondary,
          ),
        ),
      );
      await matchGolden(tester, 'badge_secondary', device: defaultGoldenDevice);
    });

    testWidgets('destructive variant', (tester) async {
      await tester.pumpWidget(
        GoldenTestWrapper(
          device: defaultGoldenDevice,
          child: const GrafitBadge(
            label: 'Error',
            variant: GrafitBadgeVariant.destructive,
          ),
        ),
      );
      await matchGolden(tester, 'badge_destructive', device: defaultGoldenDevice);
    });

    testWidgets('outline variant', (tester) async {
      await tester.pumpWidget(
        GoldenTestWrapper(
          device: defaultGoldenDevice,
          child: const GrafitBadge(
            label: 'Outline',
            variant: GrafitBadgeVariant.outline,
          ),
        ),
      );
      await matchGolden(tester, 'badge_outline', device: defaultGoldenDevice);
    });

    testWidgets('ghost variant', (tester) async {
      await tester.pumpWidget(
        GoldenTestWrapper(
          device: defaultGoldenDevice,
          child: const GrafitBadge(
            label: 'Ghost',
            variant: GrafitBadgeVariant.ghost,
          ),
        ),
      );
      await matchGolden(tester, 'badge_ghost', device: defaultGoldenDevice);
    });

    testWidgets('all variants together', (tester) async {
      await tester.pumpWidget(
        GoldenTestWrapper(
          device: defaultGoldenDevice,
          child: const Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              GrafitBadge(label: 'Default', variant: GrafitBadgeVariant.value),
              GrafitBadge(label: 'Primary', variant: GrafitBadgeVariant.primary),
              GrafitBadge(label: 'Secondary', variant: GrafitBadgeVariant.secondary),
              GrafitBadge(label: 'Destructive', variant: GrafitBadgeVariant.destructive),
              GrafitBadge(label: 'Outline', variant: GrafitBadgeVariant.outline),
              GrafitBadge(label: 'Ghost', variant: GrafitBadgeVariant.ghost),
            ],
          ),
        ),
      );
      await matchGolden(tester, 'badge_all_variants', device: defaultGoldenDevice);
    });

    testWidgets('status badges', (tester) async {
      await tester.pumpWidget(
        GoldenTestWrapper(
          device: defaultGoldenDevice,
          child: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GrafitBadge(label: 'Active', variant: GrafitBadgeVariant.primary),
                  SizedBox(width: 8),
                  Text('Active', style: TextStyle(fontSize: 14)),
                ],
              ),
              SizedBox(height: 8),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GrafitBadge(label: 'Draft', variant: GrafitBadgeVariant.secondary),
                  SizedBox(width: 8),
                  Text('Draft', style: TextStyle(fontSize: 14)),
                ],
              ),
              SizedBox(height: 8),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GrafitBadge(label: 'Failed', variant: GrafitBadgeVariant.destructive),
                  SizedBox(width: 8),
                  Text('Failed', style: TextStyle(fontSize: 14)),
                ],
              ),
            ],
          ),
        ),
      );
      await matchGolden(tester, 'badge_status', device: defaultGoldenDevice);
    });
  });
}
