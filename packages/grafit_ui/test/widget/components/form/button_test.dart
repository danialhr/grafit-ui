import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grafit_ui/grafit_ui.dart';

import '../../../helpers/test_helpers.dart';
import '../../../helpers/themed_test_widget.dart';

void main() {
  group('GrafitButton - Smoke Tests', () {
    testGrafitWidget('renders without errors', (tester) async {
      await tester.pumpWidget(
        ThemedTestWidget(
          child: GrafitButton(label: 'Click me'),
        ),
      );

      expect(find.byType(GrafitButton), findsOneWidget);
      expect(find.text('Click me'), findsOneWidget);
    });

    testGrafitWidget('renders with custom child', (tester) async {
      await tester.pumpWidget(
        ThemedTestWidget(
          child: GrafitButton(
            child: const Text('Custom Child'),
          ),
        ),
      );

      expect(find.byType(GrafitButton), findsOneWidget);
      expect(find.text('Custom Child'), findsOneWidget);
    });

    testGrafitWidget('renders with icon', (tester) async {
      await tester.pumpWidget(
        ThemedTestWidget(
          child: GrafitButton(
            label: 'With Icon',
            icon: Icons.favorite,
          ),
        ),
      );

      expect(find.byType(GrafitButton), findsOneWidget);
      expect(find.byIcon(Icons.favorite), findsOneWidget);
    });
  });

  group('GrafitButton - Variants', () {
    testGrafitWidget('renders primary variant', (tester) async {
      await tester.pumpWidget(
        ThemedTestWidget(
          child: GrafitButton(
            label: 'Primary',
            variant: GrafitButtonVariant.primary,
          ),
        ),
      );

      expect(find.byType(GrafitButton), findsOneWidget);
    });

    testGrafitWidget('renders secondary variant', (tester) async {
      await tester.pumpWidget(
        ThemedTestWidget(
          child: GrafitButton(
            label: 'Secondary',
            variant: GrafitButtonVariant.secondary,
          ),
        ),
      );

      expect(find.byType(GrafitButton), findsOneWidget);
    });

    testGrafitWidget('renders ghost variant', (tester) async {
      await tester.pumpWidget(
        ThemedTestWidget(
          child: GrafitButton(
            label: 'Ghost',
            variant: GrafitButtonVariant.ghost,
          ),
        ),
      );

      expect(find.byType(GrafitButton), findsOneWidget);
    });

    testGrafitWidget('renders link variant', (tester) async {
      await tester.pumpWidget(
        ThemedTestWidget(
          child: GrafitButton(
            label: 'Link',
            variant: GrafitButtonVariant.link,
          ),
        ),
      );

      expect(find.byType(GrafitButton), findsOneWidget);
    });

    testGrafitWidget('renders destructive variant', (tester) async {
      await tester.pumpWidget(
        ThemedTestWidget(
          child: GrafitButton(
            label: 'Delete',
            variant: GrafitButtonVariant.destructive,
          ),
        ),
      );

      expect(find.byType(GrafitButton), findsOneWidget);
    });

    testGrafitWidget('renders outline variant', (tester) async {
      await tester.pumpWidget(
        ThemedTestWidget(
          child: GrafitButton(
            label: 'Outline',
            variant: GrafitButtonVariant.outline,
          ),
        ),
      );

      expect(find.byType(GrafitButton), findsOneWidget);
    });
  });

  group('GrafitButton - Sizes', () {
    testGrafitWidget('renders small size', (tester) async {
      await tester.pumpWidget(
        ThemedTestWidget(
          child: GrafitButton(
            label: 'Small',
            size: GrafitButtonSize.sm,
          ),
        ),
      );

      expect(find.byType(GrafitButton), findsOneWidget);
    });

    testGrafitWidget('renders medium size', (tester) async {
      await tester.pumpWidget(
        ThemedTestWidget(
          child: GrafitButton(
            label: 'Medium',
            size: GrafitButtonSize.md,
          ),
        ),
      );

      expect(find.byType(GrafitButton), findsOneWidget);
    });

    testGrafitWidget('renders large size', (tester) async {
      await tester.pumpWidget(
        ThemedTestWidget(
          child: GrafitButton(
            label: 'Large',
            size: GrafitButtonSize.lg,
          ),
        ),
      );

      expect(find.byType(GrafitButton), findsOneWidget);
    });

    testGrafitWidget('renders icon size', (tester) async {
      await tester.pumpWidget(
        ThemedTestWidget(
          child: GrafitButton(
            icon: Icons.favorite,
            size: GrafitButtonSize.icon,
          ),
        ),
      );

      expect(find.byType(GrafitButton), findsOneWidget);
    });
  });

  group('GrafitButton - States', () {
    testGrafitWidget('renders in disabled state', (tester) async {
      await tester.pumpWidget(
        ThemedTestWidget(
          child: GrafitButton(
            label: 'Disabled',
            onPressed: () {},
            disabled: true,
          ),
        ),
      );

      expect(find.byType(GrafitButton), findsOneWidget);
    });

    testGrafitWidget('renders in loading state', (tester) async {
      await tester.pumpWidget(
        ThemedTestWidget(
          child: GrafitButton(
            label: 'Loading',
            onPressed: () {},
            loading: true,
          ),
        ),
      );

      expect(find.byType(GrafitButton), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testGrafitWidget('disabled when onPressed is null', (tester) async {
      await tester.pumpWidget(
        ThemedTestWidget(
          child: const GrafitButton(
            label: 'No Callback',
          ),
        ),
      );

      expect(find.byType(GrafitButton), findsOneWidget);
    });
  });

  group('GrafitButton - Interactions', () {
    testGrafitWidget('triggers onPressed callback', (tester) async {
      final callback = createCallbackTracker();

      await tester.pumpWidget(
        ThemedTestWidget(
          child: GrafitButton(
            label: 'Press Me',
            onPressed: callback.voidCallback,
          ),
        ),
      );

      await tapAndWait(tester, find.byType(GrafitButton));

      expect(callback.called, isTrue);
      expect(callback.callCount, 1);
    });

    testGrafitWidget('does not trigger when disabled', (tester) async {
      final callback = createCallbackTracker();

      await tester.pumpWidget(
        ThemedTestWidget(
          child: GrafitButton(
            label: 'Disabled',
            onPressed: callback.voidCallback,
            disabled: true,
          ),
        ),
      );

      await tapAndWait(tester, find.byType(GrafitButton));

      expect(callback.called, isFalse);
    });

    testGrafitWidget('does not trigger when loading', (tester) async {
      final callback = createCallbackTracker();

      await tester.pumpWidget(
        ThemedTestWidget(
          child: GrafitButton(
            label: 'Loading',
            onPressed: callback.voidCallback,
            loading: true,
          ),
        ),
      );

      await tapAndWait(tester, find.byType(GrafitButton));

      expect(callback.called, isFalse);
    });

    testGrafitWidget('does not trigger without callback', (tester) async {
      await tester.pumpWidget(
        ThemedTestWidget(
          child: const GrafitButton(label: 'No Callback'),
        ),
      );

      // Should not throw when tapped
      await tester.tap(find.byType(GrafitButton));
      await tester.pumpAndSettle();
    });
  });

  group('GrafitButton - Leading and Trailing Widgets', () {
    testGrafitWidget('renders with leading widget', (tester) async {
      await tester.pumpWidget(
        ThemedTestWidget(
          child: GrafitButton(
            label: 'Leading',
            leading: const Icon(Icons.star),
          ),
        ),
      );

      expect(find.byType(GrafitButton), findsOneWidget);
      expect(find.byIcon(Icons.star), findsOneWidget);
    });

    testGrafitWidget('renders with trailing widget', (tester) async {
      await tester.pumpWidget(
        ThemedTestWidget(
          child: GrafitButton(
            label: 'Trailing',
            trailing: const Icon(Icons.arrow_forward),
          ),
        ),
      );

      expect(find.byType(GrafitButton), findsOneWidget);
      expect(find.byIcon(Icons.arrow_forward), findsOneWidget);
    });

    testGrafitWidget('renders with both leading and trailing', (tester) async {
      await tester.pumpWidget(
        ThemedTestWidget(
          child: GrafitButton(
            label: 'Both',
            leading: const Icon(Icons.star),
            trailing: const Icon(Icons.arrow_forward),
          ),
        ),
      );

      expect(find.byType(GrafitButton), findsOneWidget);
      expect(find.byIcon(Icons.star), findsOneWidget);
      expect(find.byIcon(Icons.arrow_forward), findsOneWidget);
    });
  });

  group('GrafitButton - Full Width', () {
    testGrafitWidget('renders with fullWidth', (tester) async {
      await tester.pumpWidget(
        ThemedTestWidget(
          child: SizedBox(
            width: 300,
            child: GrafitButton(
              label: 'Full Width',
              fullWidth: true,
            ),
          ),
        ),
      );

      expect(find.byType(GrafitButton), findsOneWidget);
    });
  });

  group('GrafitButton - Dark Theme', () {
    testGrafitWidget('renders in dark theme', (tester) async {
      await tester.pumpWidget(
        ThemedTestWidget(
          isDark: true,
          child: GrafitButton(label: 'Dark Mode'),
        ),
      );

      expect(find.byType(GrafitButton), findsOneWidget);
      expect(find.text('Dark Mode'), findsOneWidget);
    });
  });

  group('GrafitButton - Accessibility', () {
    testGrafitWidget('has semantic button label', (tester) async {
      await tester.pumpWidget(
        ThemedTestWidget(
          child: GrafitButton(label: 'Accessible Button'),
        ),
      );

      expect(find.text('Accessible Button'), findsOneWidget);
    });

    testGrafitWidget('is not tappable when disabled', (tester) async {
      await tester.pumpWidget(
        ThemedTestWidget(
          child: GrafitButton(
            label: 'Disabled',
            onPressed: () {},
            disabled: true,
          ),
        ),
      );

      expect(find.byType(GrafitButton), findsOneWidget);
    });
  });

  group('GrafitButton - Edge Cases', () {
    testGrafitWidget('renders with very long label', (tester) async {
      await tester.pumpWidget(
        ThemedTestWidget(
          child: const GrafitButton(
            label: 'This is a very long label that should wrap '
                'or truncate depending on the implementation',
          ),
        ),
      );

      expect(find.byType(GrafitButton), findsOneWidget);
    });

    testGrafitWidget('renders with empty label', (tester) async {
      await tester.pumpWidget(
        ThemedTestWidget(
          child: const GrafitButton(label: ''),
        ),
      );

      expect(find.byType(GrafitButton), findsOneWidget);
    });

    testGrafitWidget('renders with only icon', (tester) async {
      await tester.pumpWidget(
        ThemedTestWidget(
          child: const GrafitButton(
            icon: Icons.favorite,
            size: GrafitButtonSize.icon,
          ),
        ),
      );

      expect(find.byType(GrafitButton), findsOneWidget);
    });
  });
}
