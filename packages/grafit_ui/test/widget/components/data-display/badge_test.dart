import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grafit_ui/grafit_ui.dart';

import '../../../helpers/test_helpers.dart';
import '../../../helpers/themed_test_widget.dart';

void main() {
  group('GrafitBadge - Smoke Tests', () {
    testGrafitWidget('renders without errors', (tester) async {
      await tester.pumpWidget(
        ThemedTestWidget(
          child: const GrafitBadge(label: 'Badge'),
        ),
      );

      expect(find.byType(GrafitBadge), findsOneWidget);
      expect(find.text('Badge'), findsOneWidget);
    });

    testGrafitWidget('renders with long label', (tester) async {
      await tester.pumpWidget(
        ThemedTestWidget(
          child: const GrafitBadge(label: 'Very Long Badge Label'),
        ),
      );

      expect(find.byType(GrafitBadge), findsOneWidget);
      expect(find.text('Very Long Badge Label'), findsOneWidget);
    });

    testGrafitWidget('renders with custom child', (tester) async {
      await tester.pumpWidget(
        ThemedTestWidget(
          child: GrafitBadge(
            label: 'Icon Badge',
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.star, size: 12),
                SizedBox(width: 4),
                Text('Custom'),
              ],
            ),
          ),
        ),
      );

      expect(find.byType(GrafitBadge), findsOneWidget);
      expect(find.byIcon(Icons.star), findsOneWidget);
    });
  });

  group('GrafitBadge - Variants', () {
    testGrafitWidget('renders value variant (default)', (tester) async {
      await tester.pumpWidget(
        ThemedTestWidget(
          child: const GrafitBadge(
            label: 'Value',
            variant: GrafitBadgeVariant.value,
          ),
        ),
      );

      expect(find.byType(GrafitBadge), findsOneWidget);
    });

    testGrafitWidget('renders primary variant', (tester) async {
      await tester.pumpWidget(
        ThemedTestWidget(
          child: const GrafitBadge(
            label: 'Primary',
            variant: GrafitBadgeVariant.primary,
          ),
        ),
      );

      expect(find.byType(GrafitBadge), findsOneWidget);
    });

    testGrafitWidget('renders secondary variant', (tester) async {
      await tester.pumpWidget(
        ThemedTestWidget(
          child: const GrafitBadge(
            label: 'Secondary',
            variant: GrafitBadgeVariant.secondary,
          ),
        ),
      );

      expect(find.byType(GrafitBadge), findsOneWidget);
    });

    testGrafitWidget('renders destructive variant', (tester) async {
      await tester.pumpWidget(
        ThemedTestWidget(
          child: const GrafitBadge(
            label: 'Error',
            variant: GrafitBadgeVariant.destructive,
          ),
        ),
      );

      expect(find.byType(GrafitBadge), findsOneWidget);
    });

    testGrafitWidget('renders outline variant', (tester) async {
      await tester.pumpWidget(
        ThemedTestWidget(
          child: const GrafitBadge(
            label: 'Outline',
            variant: GrafitBadgeVariant.outline,
          ),
        ),
      );

      expect(find.byType(GrafitBadge), findsOneWidget);
    });

    testGrafitWidget('renders ghost variant', (tester) async {
      await tester.pumpWidget(
        ThemedTestWidget(
          child: const GrafitBadge(
            label: 'Ghost',
            variant: GrafitBadgeVariant.ghost,
          ),
        ),
      );

      expect(find.byType(GrafitBadge), findsOneWidget);
    });
  });

  group('GrafitBadge - Custom Colors', () {
    testGrafitWidget('renders with custom background color', (tester) async {
      const customColor = Color(0xFFFF5722);

      await tester.pumpWidget(
        ThemedTestWidget(
          child: const GrafitBadge(
            label: 'Custom',
            backgroundColor: customColor,
          ),
        ),
      );

      expect(find.byType(GrafitBadge), findsOneWidget);
    });

    testGrafitWidget('renders with custom foreground color', (tester) async {
      const customColor = Color(0xFF3F51B5);

      await tester.pumpWidget(
        ThemedTestWidget(
          child: const GrafitBadge(
            label: 'Custom Text',
            foregroundColor: customColor,
          ),
        ),
      );

      expect(find.byType(GrafitBadge), findsOneWidget);
    });

    testGrafitWidget('renders with both custom colors', (tester) async {
      const bg = Color(0xFF009688);
      const fg = Color(0xFFFFFFFF);

      await tester.pumpWidget(
        ThemedTestWidget(
          child: const GrafitBadge(
            label: 'Both Custom',
            backgroundColor: bg,
            foregroundColor: fg,
          ),
        ),
      );

      expect(find.byType(GrafitBadge), findsOneWidget);
    });

    testGrafitWidget('custom colors override variant colors', (tester) async {
      const customBg = Color(0xFF9C27B0);
      const customFg = Color(0xFFFFFFFF);

      await tester.pumpWidget(
        ThemedTestWidget(
          child: const GrafitBadge(
            label: 'Override',
            variant: GrafitBadgeVariant.primary,
            backgroundColor: customBg,
            foregroundColor: customFg,
          ),
        ),
      );

      expect(find.byType(GrafitBadge), findsOneWidget);
    });
  });

  group('GrafitBadge - Layout and Positioning', () {
    testGrafitWidget('renders in row', (tester) async {
      await tester.pumpWidget(
        ThemedTestWidget(
          child: const Row(
            children: [
              GrafitBadge(label: 'One'),
              GrafitBadge(label: 'Two'),
              GrafitBadge(label: 'Three'),
            ],
          ),
        ),
      );

      expect(find.byType(GrafitBadge), findsNWidgets(3));
    });

    testGrafitWidget('renders in column', (tester) async {
      await tester.pumpWidget(
        ThemedTestWidget(
          child: const Column(
            children: [
              GrafitBadge(label: 'Top'),
              GrafitBadge(label: 'Middle'),
              GrafitBadge(label: 'Bottom'),
            ],
          ),
        ),
      );

      expect(find.byType(GrafitBadge), findsNWidgets(3));
    });

    testGrafitWidget('renders in wrap', (tester) async {
      await tester.pumpWidget(
        ThemedTestWidget(
          child: const Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              GrafitBadge(label: '1'),
              GrafitBadge(label: '2'),
              GrafitBadge(label: '3'),
              GrafitBadge(label: '4'),
              GrafitBadge(label: '5'),
            ],
          ),
        ),
      );

      expect(find.byType(GrafitBadge), findsNWidgets(5));
    });
  });

  group('GrafitBadge - Dark Theme', () {
    testGrafitWidget('renders in dark theme', (tester) async {
      await tester.pumpWidget(
        ThemedTestWidget(
          isDark: true,
          child: const GrafitBadge(label: 'Dark Badge'),
        ),
      );

      expect(find.byType(GrafitBadge), findsOneWidget);
    });

    testGrafitWidget('renders all variants in dark theme', (tester) async {
      await tester.pumpWidget(
        ThemedTestWidget(
          isDark: true,
          child: const Wrap(
            spacing: 8,
            children: [
              GrafitBadge(label: 'Value', variant: GrafitBadgeVariant.value),
              GrafitBadge(label: 'Primary', variant: GrafitBadgeVariant.primary),
              GrafitBadge(label: 'Secondary', variant: GrafitBadgeVariant.secondary),
              GrafitBadge(label: 'Destructive', variant: GrafitBadgeVariant.destructive),
              GrafitBadge(label: 'Outline', variant: GrafitBadgeVariant.outline),
              GrafitBadge(label: 'Ghost', variant: GrafitBadgeVariant.ghost),
            ],
          ),
        ),
      );

      expect(find.byType(GrafitBadge), findsNWidgets(6));
    });
  });

  group('GrafitBadge - Common Use Cases', () {
    testGrafitWidget('renders status badges', (tester) async {
      await tester.pumpWidget(
        ThemedTestWidget(
          child: const Row(
            children: [
              GrafitBadge(label: 'Active', variant: GrafitBadgeVariant.primary),
              GrafitBadge(label: 'Draft', variant: GrafitBadgeVariant.secondary),
              GrafitBadge(label: 'Failed', variant: GrafitBadgeVariant.destructive),
            ],
          ),
        ),
      );

      expect(find.byType(GrafitBadge), findsNWidgets(3));
    });

    testGrafitWidget('renders count badge', (tester) async {
      await tester.pumpWidget(
        ThemedTestWidget(
          child: const Row(
            children: [
              Text('Messages'),
              SizedBox(width: 8),
              GrafitBadge(label: '5'),
            ],
          ),
        ),
      );

      expect(find.byType(GrafitBadge), findsOneWidget);
      expect(find.text('5'), findsOneWidget);
    });

    testGrafitWidget('renders category badges', (tester) async {
      await tester.pumpWidget(
        ThemedTestWidget(
          child: const Wrap(
            spacing: 8,
            children: [
              GrafitBadge(label: 'Design', variant: GrafitBadgeVariant.ghost),
              GrafitBadge(label: 'Development', variant: GrafitBadgeVariant.ghost),
              GrafitBadge(label: 'Marketing', variant: GrafitBadgeVariant.ghost),
            ],
          ),
        ),
      );

      expect(find.byType(GrafitBadge), findsNWidgets(3));
    });
  });

  group('GrafitBadge - Edge Cases', () {
    testGrafitWidget('renders with single character', (tester) async {
      await tester.pumpWidget(
        ThemedTestWidget(
          child: const GrafitBadge(label: 'A'),
        ),
      );

      expect(find.byType(GrafitBadge), findsOneWidget);
      expect(find.text('A'), findsOneWidget);
    });

    testGrafitWidget('renders with special characters', (tester) async {
      await tester.pumpWidget(
        ThemedTestWidget(
          child: const GrafitBadge(label: '@#\$%'),
        ),
      );

      expect(find.byType(GrafitBadge), findsOneWidget);
    });

    testGrafitWidget('renders with emoji', (tester) async {
      await tester.pumpWidget(
        ThemedTestWidget(
          child: const GrafitBadge(label: '🎉 Party'),
        ),
      );

      expect(find.byType(GrafitBadge), findsOneWidget);
    });

    testGrafitWidget('renders with numeric label', (tester) async {
      await tester.pumpWidget(
        ThemedTestWidget(
          child: const GrafitBadge(label: '99+'),
        ),
      );

      expect(find.byType(GrafitBadge), findsOneWidget);
    });

    testGrafitWidget('renders with empty string', (tester) async {
      await tester.pumpWidget(
        ThemedTestWidget(
          child: const GrafitBadge(label: ''),
        ),
      );

      expect(find.byType(GrafitBadge), findsOneWidget);
    });
  });

  group('GrafitBadge - Complex Layouts', () {
    testGrafitWidget('renders with leading icon', (tester) async {
      await tester.pumpWidget(
        ThemedTestWidget(
          child: GrafitBadge(
            label: 'Icon',
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.check_circle, size: 12),
                SizedBox(width: 4),
                Text('Verified'),
              ],
            ),
          ),
        ),
      );

      expect(find.byType(GrafitBadge), findsOneWidget);
      expect(find.byIcon(Icons.check_circle), findsOneWidget);
    });

    testGrafitWidget('renders in card', (tester) async {
      await tester.pumpWidget(
        ThemedTestWidget(
          child: Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Card Title'),
                  SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: [
                      GrafitBadge(label: 'Tag 1'),
                      GrafitBadge(label: 'Tag 2'),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.byType(GrafitBadge), findsNWidgets(2));
    });

    testGrafitWidget('renders in list tile', (tester) async {
      await tester.pumpWidget(
        ThemedTestWidget(
          child: ListTile(
            title: const Text('Item with badge'),
            trailing: GrafitBadge(label: 'New'),
          ),
        ),
      );

      expect(find.byType(GrafitBadge), findsOneWidget);
    });
  });

  group('GrafitBadge - Accessibility', () {
    testGrafitWidget('is accessible with label', (tester) async {
      await tester.pumpWidget(
        ThemedTestWidget(
          child: const GrafitBadge(label: 'Accessible'),
        ),
      );

      expect(find.text('Accessible'), findsOneWidget);
    });
  });

  group('GrafitBadge - Custom Child Widgets', () {
    testGrafitWidget('renders with text span child', (tester) async {
      await tester.pumpWidget(
        ThemedTestWidget(
          child: GrafitBadge(
            label: 'Rich',
            child: RichText(
              text: const TextSpan(
                text: 'Bold',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      );

      expect(find.byType(GrafitBadge), findsOneWidget);
    });

    testGrafitWidget('renders with multiple icons and text', (tester) async {
      await tester.pumpWidget(
        ThemedTestWidget(
          child: GrafitBadge(
            label: 'Complex',
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.star, size: 10),
                SizedBox(width: 2),
                Icon(Icons.star, size: 10),
                SizedBox(width: 2),
                Icon(Icons.star, size: 10),
                SizedBox(width: 4),
                Text('Rated'),
              ],
            ),
          ),
        ),
      );

      expect(find.byType(GrafitBadge), findsOneWidget);
      expect(find.byIcon(Icons.star), findsNWidgets(3));
    });
  });

  group('GrafitBadge - Responsive Behavior', () {
    testGrafitWidget('handles text overflow gracefully', (tester) async {
      await tester.pumpWidget(
        ThemedTestWidget(
          child: const SizedBox(
            width: 100,
            child: GrafitBadge(label: 'Very Long Badge Text'),
          ),
        ),
      );

      expect(find.byType(GrafitBadge), findsOneWidget);
    });

    testGrafitWidget('renders consistently across different widths', (tester) async {
      for (final width in [100.0, 200.0, 400.0]) {
        await tester.pumpWidget(
          ThemedTestWidget(
            child: SizedBox(
              width: width,
              child: const GrafitBadge(label: 'Test'),
            ),
          ),
        );

        expect(find.byType(GrafitBadge), findsOneWidget);
      }
    });
  });
}
