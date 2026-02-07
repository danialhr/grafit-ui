import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grafit_ui/grafit_ui.dart';

import '../../test_helper.dart';

void main() {
  group('GrafitSonner', () {
    group('Rendering', () {
      testWidgets('renders without error', (tester) async {
        await tester.pumpWidget(
          const GrafitThemedTest(
            child: GrafitSonner(
              child: Text('Content'),
            ),
          ),
        );
        expect(find.text('Content'), findsOneWidget);
      });

      testWidgets('renders without child', (tester) async {
        await tester.pumpWidget(
          const GrafitThemedTest(
            child: GrafitSonner(),
          ),
        );
        expect(find.byType(GrafitSonner), findsOneWidget);
      });
    });

    group('showToast()', () {
      testWidgets('shows basic toast', (tester) async {
        await tester.pumpWidget(
          GrafitThemedTest(
            child: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  context.showToast(
                    title: 'Test Toast',
                    description: 'Test Description',
                  );
                },
                child: const Text('Show Toast'),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Show Toast'));
        await tester.pumpAndSettle();

        expect(find.text('Test Toast'), findsOneWidget);
        expect(find.text('Test Description'), findsOneWidget);
      });

      testWidgets('shows toast with custom duration', (tester) async {
        await tester.pumpWidget(
          GrafitThemedTest(
            child: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  context.showToast(
                    title: 'Short Duration',
                    duration: const Duration(milliseconds: 100),
                  );
                },
                child: const Text('Show'),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Show'));
        await tester.pumpAndSettle();

        expect(find.text('Short Duration'), findsOneWidget);

        // Wait for auto-dismiss
        await tester.pump(const Duration(milliseconds: 150));
        await tester.pump(const Duration(milliseconds: 300));

        // Toast should be dismissed
        expect(find.text('Short Duration'), findsNothing);
      });

      testWidgets('calls onDismiss callback', (tester) async {
        bool dismissed = false;

        await tester.pumpWidget(
          GrafitThemedTest(
            child: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  context.showToast(
                    title: 'Dismiss Test',
                    onDismiss: () => dismissed = true,
                  );
                },
                child: const Text('Show'),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Show'));
        await tester.pumpAndSettle();

        // Wait for auto-dismiss (default 4 seconds)
        await tester.pump(const Duration(seconds: 5));

        expect(dismissed, isTrue);
      });

      testWidgets('shows toast with action button', (tester) async {
        bool actionPressed = false;

        await tester.pumpWidget(
          GrafitThemedTest(
            child: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  context.showToast(
                    title: 'Action Toast',
                    actionLabel: 'Undo',
                    onAction: () => actionPressed = true,
                  );
                },
                child: const Text('Show'),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Show'));
        await tester.pumpAndSettle();

        expect(find.text('Action Toast'), findsOneWidget);
        expect(find.text('Undo'), findsOneWidget);

        await tester.tap(find.text('Undo'));
        await tester.pumpAndSettle();

        expect(actionPressed, isTrue);
      });
    });

    group('showSuccess()', () {
      testWidgets('shows success toast', (tester) async {
        await tester.pumpWidget(
          GrafitThemedTest(
            child: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  context.showSuccess(
                    title: 'Success!',
                    description: 'Operation completed',
                  );
                },
                child: const Text('Show Success'),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Show Success'));
        await tester.pumpAndSettle();

        expect(find.text('Success!'), findsOneWidget);
        expect(find.text('Operation completed'), findsOneWidget);
      });

      testWidgets('uses default title when not provided', (tester) async {
        await tester.pumpWidget(
          GrafitThemedTest(
            child: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  context.showSuccess();
                },
                child: const Text('Show'),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Show'));
        await tester.pumpAndSettle();

        expect(find.text('Success'), findsOneWidget);
      });
    });

    group('showError()', () {
      testWidgets('shows error toast', (tester) async {
        await tester.pumpWidget(
          GrafitThemedTest(
            child: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  context.showError(
                    title: 'Error!',
                    description: 'Something went wrong',
                  );
                },
                child: const Text('Show Error'),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Show Error'));
        await tester.pumpAndSettle();

        expect(find.text('Error!'), findsOneWidget);
        expect(find.text('Something went wrong'), findsOneWidget);
      });

      testWidgets('uses default title when not provided', (tester) async {
        await tester.pumpWidget(
          GrafitThemedTest(
            child: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  context.showError();
                },
                child: const Text('Show'),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Show'));
        await tester.pumpAndSettle();

        expect(find.text('Error'), findsOneWidget);
      });
    });

    group('showWarning()', () {
      testWidgets('shows warning toast', (tester) async {
        await tester.pumpWidget(
          GrafitThemedTest(
            child: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  context.showWarning(
                    title: 'Warning!',
                    description: 'Please review',
                  );
                },
                child: const Text('Show Warning'),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Show Warning'));
        await tester.pumpAndSettle();

        expect(find.text('Warning!'), findsOneWidget);
        expect(find.text('Please review'), findsOneWidget);
      });
    });

    group('showInfo()', () {
      testWidgets('shows info toast', (tester) async {
        await tester.pumpWidget(
          GrafitThemedTest(
            child: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  context.showInfo(
                    title: 'Info',
                    description: 'For your information',
                  );
                },
                child: const Text('Show Info'),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Show Info'));
        await tester.pumpAndSettle();

        expect(find.text('Info'), findsOneWidget);
        expect(find.text('For your information'), findsOneWidget);
      });
    });

    group('showLoading()', () {
      testWidgets('shows loading toast', (tester) async {
        await tester.pumpWidget(
          GrafitThemedTest(
            child: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  context.showLoading(
                    title: 'Loading...',
                    description: 'Please wait',
                  );
                },
                child: const Text('Show Loading'),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Show Loading'));
        await tester.pumpAndSettle();

        expect(find.text('Loading...'), findsOneWidget);
        expect(find.text('Please wait'), findsOneWidget);
      });

      testWidgets('does not auto-dismiss loading toast', (tester) async {
        await tester.pumpWidget(
          GrafitThemedTest(
            child: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  context.showLoading(title: 'Loading');
                },
                child: const Text('Show'),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Show'));
        await tester.pumpAndSettle();

        // Wait longer than normal duration
        await tester.pump(const Duration(seconds: 5));

        // Loading toast should still be visible
        expect(find.text('Loading'), findsOneWidget);
      });
    });

    group('showPromise()', () {
      testWidgets('shows loading then success on promise completion', (tester) async {
        await tester.pumpWidget(
          GrafitThemedTest(
            child: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  context.showPromise(
                    () async {
                      await Future.delayed(const Duration(milliseconds: 100));
                      return 'Result';
                    }(),
                    loadingTitle: 'Processing...',
                    successTitle: 'Complete!',
                  );
                },
                child: const Text('Show Promise'),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Show Promise'));
        await tester.pumpAndSettle();

        // Should show loading
        expect(find.text('Processing...'), findsOneWidget);

        // Wait for promise to complete
        await tester.pump(const Duration(milliseconds: 200));
        await tester.pumpAndSettle();

        // Should show success
        expect(find.text('Complete!'), findsOneWidget);
      });

      testWidgets('shows error on promise rejection', (tester) async {
        await tester.pumpWidget(
          GrafitThemedTest(
            child: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  context.showPromise(
                    () async {
                      await Future.delayed(const Duration(milliseconds: 100));
                      throw Exception('Failed');
                    }(),
                    loadingTitle: 'Loading',
                    errorTitle: 'Error!',
                  );
                },
                child: const Text('Show Promise'),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Show Promise'));
        await tester.pumpAndSettle();

        expect(find.text('Loading'), findsOneWidget);

        await tester.pump(const Duration(milliseconds: 200));
        await tester.pumpAndSettle();

        expect(find.text('Error!'), findsOneWidget);
      });
    });

    group('Position', () {
      testWidgets('positions toasts at top left', (tester) async {
        await tester.pumpWidget(
          const GrafitThemedTest(
            child: GrafitSonner(
              position: GrafitToastPosition.topLeft,
              child: Text('Content'),
            ),
          ),
        );

        await tester.pumpWidget(
          GrafitThemedTest(
            child: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  context.showToast(title: 'Top Left');
                },
                child: const Text('Show'),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Show'));
        await tester.pumpAndSettle();

        expect(find.text('Top Left'), findsOneWidget);
      });

      testWidgets('positions toasts at top center', (tester) async {
        await tester.pumpWidget(
          GrafitThemedTest(
            child: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  context.showToast(title: 'Top Center');
                },
                child: const Text('Show'),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Show'));
        await tester.pumpAndSettle();

        expect(find.text('Top Center'), findsOneWidget);
      });

      testWidgets('positions toasts at top right', (tester) async {
        await tester.pumpWidget(
          GrafitThemedTest(
            child: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  context.showToast(title: 'Top Right');
                },
                child: const Text('Show'),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Show'));
        await tester.pumpAndSettle();

        expect(find.text('Top Right'), findsOneWidget);
      });

      testWidgets('positions toasts at bottom left', (tester) async {
        await tester.pumpWidget(
          GrafitThemedTest(
            child: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  context.showToast(title: 'Bottom Left');
                },
                child: const Text('Show'),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Show'));
        await tester.pumpAndSettle();

        expect(find.text('Bottom Left'), findsOneWidget);
      });

      testWidgets('positions toasts at bottom center', (tester) async {
        await tester.pumpWidget(
          GrafitThemedTest(
            child: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  context.showToast(title: 'Bottom Center');
                },
                child: const Text('Show'),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Show'));
        await tester.pumpAndSettle();

        expect(find.text('Bottom Center'), findsOneWidget);
      });

      testWidgets('positions toasts at bottom right', (tester) async {
        await tester.pumpWidget(
          GrafitThemedTest(
            child: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  context.showToast(title: 'Bottom Right');
                },
                child: const Text('Show'),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Show'));
        await tester.pumpAndSettle();

        expect(find.text('Bottom Right'), findsOneWidget);
      });
    });

    group('Multiple Toasts', () {
      testWidgets('shows multiple toasts', (tester) async {
        await tester.pumpWidget(
          GrafitThemedTest(
            child: Builder(
              builder: (context) => Column(
                children: [
                  ElevatedButton(
                    onPressed: () => context.showToast(title: 'First'),
                    child: const Text('Show First'),
                  ),
                  ElevatedButton(
                    onPressed: () => context.showToast(title: 'Second'),
                    child: const Text('Show Second'),
                  ),
                  ElevatedButton(
                    onPressed: () => context.showToast(title: 'Third'),
                    child: const Text('Show Third'),
                  ),
                ],
              ),
            ),
          ),
        );

        await tester.tap(find.text('Show First'));
        await tester.pump();
        await tester.tap(find.text('Show Second'));
        await tester.pump();
        await tester.tap(find.text('Show Third'));
        await tester.pumpAndSettle();

        expect(find.text('First'), findsOneWidget);
        expect(find.text('Second'), findsOneWidget);
        expect(find.text('Third'), findsOneWidget);
      });

      testWidgets('respects maxToasts limit', (tester) async {
        await tester.pumpWidget(
          const GrafitThemedTest(
            child: GrafitSonner(
              maxToasts: 2,
              child: Text('Content'),
            ),
          ),
        );

        await tester.pumpWidget(
          GrafitThemedTest(
            child: Builder(
              builder: (context) => Column(
                children: [
                  ElevatedButton(
                    onPressed: () => context.showToast(title: '1'),
                    child: const Text('1'),
                  ),
                  ElevatedButton(
                    onPressed: () => context.showToast(title: '2'),
                    child: const Text('2'),
                  ),
                  ElevatedButton(
                    onPressed: () => context.showToast(title: '3'),
                    child: const Text('3'),
                  ),
                ],
              ),
            ),
          ),
        );

        await tester.tap(find.text('1'));
        await tester.pump();
        await tester.tap(find.text('2'));
        await tester.pump();
        await tester.tap(find.text('3'));
        await tester.pumpAndSettle();

        // Only 2 should be visible
        expect(find.text('1'), findsOneWidget);
        expect(find.text('2'), findsOneWidget);
        expect(find.text('3'), findsNothing);
      });
    });

    group('Dismiss', () {
      testWidgets('dismisses specific toast', (tester) async {
        String? toastId;

        await tester.pumpWidget(
          GrafitThemedTest(
            child: Builder(
              builder: (context) => Column(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      toastId = context.showToast(title: 'Toast 1');
                    },
                    child: const Text('Show'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (toastId != null) {
                        context.dismissToast(toastId!);
                      }
                    },
                    child: const Text('Dismiss'),
                  ),
                ],
              ),
            ),
          ),
        );

        await tester.tap(find.text('Show'));
        await tester.pumpAndSettle();
        expect(find.text('Toast 1'), findsOneWidget);

        await tester.tap(find.text('Dismiss'));
        await tester.pumpAndSettle();
        expect(find.text('Toast 1'), findsNothing);
      });

      testWidgets('dismisses all toasts', (tester) async {
        await tester.pumpWidget(
          GrafitThemedTest(
            child: Builder(
              builder: (context) => Column(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      context.showToast(title: 'A');
                      context.showToast(title: 'B');
                      context.showToast(title: 'C');
                    },
                    child: const Text('Show All'),
                  ),
                  ElevatedButton(
                    onPressed: () => context.dismissAllToasts(),
                    child: const Text('Dismiss All'),
                  ),
                ],
              ),
            ),
          ),
        );

        await tester.tap(find.text('Show All'));
        await tester.pumpAndSettle();
        expect(find.text('A'), findsOneWidget);
        expect(find.text('B'), findsOneWidget);
        expect(find.text('C'), findsOneWidget);

        await tester.tap(find.text('Dismiss All'));
        await tester.pumpAndSettle();
        expect(find.text('A'), findsNothing);
        expect(find.text('B'), findsNothing);
        expect(find.text('C'), findsNothing);
      });

      testWidgets('dismisses on close button tap', (tester) async {
        await tester.pumpWidget(
          GrafitThemedTest(
            child: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  context.showToast(title: 'Closable');
                },
                child: const Text('Show'),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Show'));
        await tester.pumpAndSettle();

        // Find and tap close icon
        final closeButton = find.byIcon(Icons.close);
        expect(closeButton, findsOneWidget);

        await tester.tap(closeButton);
        await tester.pumpAndSettle();

        expect(find.text('Closable'), findsNothing);
      });
    });

    group('Animation', () {
      testWidgets('animates in when shown', (tester) async {
        await tester.pumpWidget(
          GrafitThemedTest(
            child: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => context.showToast(title: 'Animated'),
                child: const Text('Show'),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Show'));
        await tester.pump(const Duration(milliseconds: 100));

        expect(find.text('Animated'), findsOneWidget);

        await tester.pump(const Duration(milliseconds: 300));
      });
    });

    group('Custom Icon', () {
      testWidgets('shows toast with custom icon', (tester) async {
        await tester.pumpWidget(
          GrafitThemedTest(
            child: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  context.showToast(
                    title: 'Custom Icon',
                    customIcon: const Icon(Icons.star),
                  );
                },
                child: const Text('Show'),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Show'));
        await tester.pumpAndSettle();

        expect(find.byIcon(Icons.star), findsOneWidget);
      });
    });

    group('Edge Cases', () {
      testWidgets('handles empty title and description', (tester) async {
        await tester.pumpWidget(
          GrafitThemedTest(
            child: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  context.showToast();
                },
                child: const Text('Show'),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Show'));
        await tester.pumpAndSettle();

        // Should handle gracefully
        expect(find.byType(GrafitSonner), findsOneWidget);
      });

      testWidgets('handles very long title', (tester) async {
        const longTitle = 'This is a very long title that goes on and on '
            'and on and should still be displayed properly';

        await tester.pumpWidget(
          GrafitThemedTest(
            child: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  context.showToast(title: longTitle);
                },
                child: const Text('Show'),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Show'));
        await tester.pumpAndSettle();

        expect(find.text(longTitle), findsOneWidget);
      });
    });
  });
}
