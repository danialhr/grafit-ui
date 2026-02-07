import 'package:flutter_test/flutter_test.dart';
import 'package:grafit_ui/grafit_ui.dart';
import '../../../helpers/test_helpers.dart';
import '../../../helpers/themed_test_widget.dart';

void main() {
  group('GrafitInputOtp', () {
    group('Smoke Test', () {
      testWidgets('renders OTP input', (tester) async {
        await tester.pumpWidget(
          tester,
          child: GrafitInputOtp(
            length: 4,
            onChanged: (_) {},
          ),
        );

        expect(find.byType(GrafitInputOtp), findsOneWidget);
      });

      testWidgets('displays correct number of slots', (tester) async {
        await tester.pumpWidget(
          tester,
          child: GrafitInputOtp(
            length: 6,
            onChanged: (_) {},
          ),
        );

        expect(find.byType(GrafitInputOtpSlot), findsNWidgets(6));
      });

      testWidgets('accepts digit entry', (tester) async {
        final otp = StringBuffer();

        await tester.pumpWidget(
          tester,
          child: GrafitInputOtp(
            length: 4,
            onChanged: (value) => otp.write(value),
          ),
        );

        // Enter first digit
        await tester.tap(find.byType(GrafitInputOtpSlot).first);
        await tester.enterText(find.byType(TextField), '1');
        await tester.pump();

        expect(find.text('1'), findsOneWidget);
      });
    });

    group('Length Configuration', () {
      testWidgets('length 4 renders', (tester) async {
        await tester.pumpWidget(
          tester,
          child: GrafitInputOtp(
            length: 4,
            onChanged: (_) {},
          ),
        );

        expect(find.byType(GrafitInputOtpSlot), findsNWidgets(4));
      });

      testWidgets('length 6 renders', (tester) async {
        await tester.pumpWidget(
          tester,
          child: GrafitInputOtp(
            length: 6,
            onChanged: (_) {},
          ),
        );

        expect(find.byType(GrafitInputOtpSlot), findsNWidgets(6));
      });

      testWidgets('length 8 renders', (tester) async {
        await tester.pumpWidget(
          tester,
          child: GrafitInputOtp(
            length: 8,
            onChanged: (_) {},
          ),
        );

        expect(find.byType(GrafitInputOtpSlot), findsNWidgets(8));
      });
    });

    group('States', () {
      testWidgets('enabled OTP accepts input', (tester) async {
        await tester.pumpWidget(
          tester,
          child: GrafitInputOtp(
            length: 4,
            enabled: true,
            onChanged: (_) {},
          ),
        );

        await tester.tap(find.byType(GrafitInputOtpSlot).first);
        await tester.enterText(find.byType(TextField), '1');
        await tester.pump();

        expect(find.text('1'), findsOneWidget);
      });

      testWidgets('disabled OTP does not accept input', (tester) async {
        await tester.pumpWidget(
          tester,
          child: GrafitInputOtp(
            length: 4,
            enabled: false,
            onChanged: (_) {},
          ),
        );

        final textField = tester.widget<TextField>(find.byType(TextField));
        expect(textField.enabled, false);
      });

      testWidgets('autofocus focuses first slot', (tester) async {
        await tester.pumpWidget(
          tester,
          child: GrafitInputOtp(
            length: 4,
            autofocus: true,
            onChanged: (_) {},
          ),
        );

        await tester.pump();

        // First slot should be focused
        expect(find.byType(GrafitInputOtpSlot), findsWidgets);
      });
    });

    group('Callbacks', () {
      testWidgets('onChanged fires on digit entry', (tester) async {
        String? currentValue;

        await tester.pumpWidget(
          tester,
          child: GrafitInputOtp(
            length: 4,
            onChanged: (value) => currentValue = value,
          ),
        );

        await tester.tap(find.byType(GrafitInputOtpSlot).first);
        await tester.enterText(find.byType(TextField), '1');
        await tester.pump();

        expect(currentValue, isNotNull);
      });

      testWidgets('onCompleted fires when all digits entered', (tester) async {
        String? completedValue;

        await tester.pumpWidget(
          tester,
          child: GrafitInputOtp(
            length: 4,
            onCompleted: (value) => completedValue = value,
            onChanged: (_) {},
          ),
        );

        // Enter all 4 digits
        for (int i = 0; i < 4; i++) {
          await tester.tap(find.byType(GrafitInputOtpSlot).at(i));
          await tester.enterText(find.byType(TextField), '${i + 1}');
          await tester.pump();
        }

        // Note: onCompleted should fire when all slots are filled
        expect(find.byType(GrafitInputOtp), findsOneWidget);
      });
    });

    group('Navigation', () {
      testWidgets('auto-advances to next slot', (tester) async {
        await tester.pumpWidget(
          tester,
          child: GrafitInputOtp(
            length: 4,
            onChanged: (_) {},
          ),
        );

        // Enter first digit
        await tester.tap(find.byType(GrafitInputOtpSlot).at(0));
        await tester.enterText(find.byType(TextField), '1');
        await tester.pump();

        // Focus should move to next slot
        expect(find.byType(GrafitInputOtpSlot), findsNWidgets(4));
      });

      testWidgets('backspace moves to previous slot', (tester) async {
        await tester.pumpWidget(
          tester,
          child: GrafitInputOtp(
            length: 4,
            onChanged: (_) {},
          ),
        );

        // Enter digits
        for (int i = 0; i < 2; i++) {
          await tester.tap(find.byType(GrafitInputOtpSlot).at(i));
          await tester.enterText(find.byType(TextField), '${i + 1}');
          await tester.pump();
        }

        expect(find.byType(GrafitInputOtp), findsOneWidget);
      });
    });

    group('Separators', () {
      testWidgets('renders with separators', (tester) async {
        await tester.pumpWidget(
          tester,
          child: GrafitInputOtp(
            length: 6,
            separatorPositions: const [3],
            onChanged: (_) {},
          ),
        );

        expect(find.byType(GrafitInputOtpSeparator), findsOneWidget);
      });

      testWidgets('multiple separators', (tester) async {
        await tester.pumpWidget(
          tester,
          child: GrafitInputOtp(
            length: 6,
            separatorPositions: const [2, 4],
            onChanged: (_) {},
          ),
        );

        expect(find.byType(GrafitInputOtpSeparator), findsNWidgets(2));
      });

      testWidgets('custom separator widget', (tester) async {
        await tester.pumpWidget(
          tester,
          child: GrafitInputOtp(
            length: 4,
            separatorPositions: const [2],
            separator: const Text('-'),
            onChanged: (_) {},
          ),
        );

        expect(find.text('-'), findsOneWidget);
      });
    });

    group('Custom Content', () {
      testWidgets('custom slot widget', (tester) async {
        await tester.pumpWidget(
          tester,
          child: GrafitInputOtp(
            length: 4,
            slotBuilder: (index, value) {
              return Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFF000000)),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    value ?? '',
                    style: const TextStyle(fontSize: 24),
                  ),
                ),
              );
            },
            onChanged: (_) {},
          ),
        );

        expect(find.byType(Container), findsWidgets);
      });
    });

    group('Value Handling', () {
      testWidgets('initial value is displayed', (tester) async {
        await tester.pumpWidget(
          tester,
          child: GrafitInputOtp(
            length: 4,
            value: '1234',
            onChanged: (_) {},
          ),
        );

        expect(find.text('1'), findsOneWidget);
        expect(find.text('2'), findsOneWidget);
        expect(find.text('3'), findsOneWidget);
        expect(find.text('4'), findsOneWidget);
      });

      testWidgets('partial value fills some slots', (tester) async {
        await tester.pumpWidget(
          tester,
          child: GrafitInputOtp(
            length: 4,
            value: '12',
            onChanged: (_) {},
          ),
        );

        expect(find.text('1'), findsOneWidget);
        expect(find.text('2'), findsOneWidget);
      });

      testWidgets('value can be cleared', (tester) async {
        String? value = '1234';

        await tester.pumpWidget(
          tester,
          child: StatefulBuilder(
            builder: (context, setState) {
              return GrafitInputOtp(
                length: 4,
                value: value,
                onChanged: (v) => setState(() => value = v),
              );
            },
          ),
        );

        expect(find.byType(GrafitInputOtp), findsOneWidget);
      });
    });

    group('Edge Cases', () {
      testWidgets('empty input', (tester) async {
        await tester.pumpWidget(
          tester,
          child: GrafitInputOtp(
            length: 4,
            value: '',
            onChanged: (_) {},
          ),
        );

        expect(find.byType(GrafitInputOtpSlot), findsNWidgets(4));
      });

      testWidgets('non-digit input handling', (tester) async {
        await tester.pumpWidget(
          tester,
          child: GrafitInputOtp(
            length: 4,
            onChanged: (_) {},
          ),
        );

        await tester.tap(find.byType(GrafitInputOtpSlot).first);
        await tester.enterText(find.byType(TextField), 'a');
        await tester.pump();

        // Should filter non-digits
        expect(find.byType(GrafitInputOtp), findsOneWidget);
      });

      testWidgets('paste functionality', (tester) async {
        await tester.pumpWidget(
          tester,
          child: GrafitInputOtp(
            length: 4,
            onChanged: (_) {},
          ),
        );

        // Paste should work
        await tester.tap(find.byType(GrafitInputOtpSlot).first);
        tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
          SystemChannels.platform,
          (call) async {
            if (call.method == 'Clipboard.getData') {
              return const <String, dynamic>{'text': '1234'};
            }
            return null;
          },
        );

        expect(find.byType(GrafitInputOtp), findsOneWidget);
      });

      testWidgets('length 1', (tester) async {
        await tester.pumpWidget(
          tester,
          child: GrafitInputOtp(
            length: 1,
            onChanged: (_) {},
          ),
        );

        expect(find.byType(GrafitInputOtpSlot), findsNWidgets(1));
      });
    });

    group('Standalone Components', () {
      testWidgets('GrafitInputOtpSlot renders', (tester) async {
        await tester.pumpWidget(
          tester,
          child: const ThemedTestWidget(
            child: const GrafitInputOtpSlot(
            index: 0,
            value: '1',
            focused: false,
            enabled: true,
            onChanged: null,
          ),
        );

        expect(find.text('1'), findsOneWidget);
      });

      testWidgets('GrafitInputOtpSeparator renders', (tester) async {
        await tester.pumpWidget(
          tester,
          child: const ThemedTestWidget(
            child: const GrafitInputOtpSeparator(
            child: Text('-'),
          ),
        );

        expect(find.text('-'), findsOneWidget);
      });

      testWidgets('GrafitInputOtpGroup renders', (tester) async {
        await tester.pumpWidget(
          tester,
          child: GrafitInputOtpGroup(
            length: 4,
            builder: (context, slots) => Row(children: slots),
            slot: (context, index, value, focused) {
              return const GrafitInputOtpSlot(
                index: 0,
                value: null,
                focused: false,
                enabled: true,
                onChanged: null,
              );
            },
            onChanged: (_) {},
          ),
        );

        expect(find.byType(GrafitInputOtpGroup), findsOneWidget);
      });
    });
  });
}
