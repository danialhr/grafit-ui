import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:grafit_ui/grafit_ui.dart';
import '../helpers/golden_helpers.dart';

void main() {
  group('Tooltip Golden Tests', () {
    testWidgets('tooltip on text', (tester) async {
      await tester.pumpWidget(
        GoldenTestWrapper(
          device: defaultGoldenDevice,
          child: const GrafitTooltip(
            message: 'This is a helpful tooltip',
            child: Text('Hover over me'),
          ),
        ),
      );
      await matchGolden(tester, 'tooltip_text', device: defaultGoldenDevice);
    });

    testWidgets('tooltip on button', (tester) async {
      await tester.pumpWidget(
        GoldenTestWrapper(
          device: defaultGoldenDevice,
          child: const GrafitTooltip(
            message: 'Click to save your changes',
            child: ElevatedButton(
              onPressed: null,
              child: Text('Save'),
            ),
          ),
        ),
      );
      await matchGolden(tester, 'tooltip_button', device: defaultGoldenDevice);
    });

    testWidgets('tooltip with long text', (tester) async {
      await tester.pumpWidget(
        GoldenTestWrapper(
          device: defaultGoldenDevice,
          child: const GrafitTooltip(
            message: 'This is a much longer tooltip message that contains more information about the element',
            child: Icon(Icons.info_outline),
          ),
        ),
      );
      await matchGolden(tester, 'tooltip_long_text', device: defaultGoldenDevice);
    });

    testWidgets('multiple tooltips', (tester) async {
      await tester.pumpWidget(
        GoldenTestWrapper(
          device: defaultGoldenDevice,
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              GrafitTooltip(
                message: 'First tooltip',
                child: Icon(Icons.home),
              ),
              SizedBox(width: 16),
              GrafitTooltip(
                message: 'Second tooltip',
                child: Icon(Icons.search),
              ),
              SizedBox(width: 16),
              GrafitTooltip(
                message: 'Third tooltip',
                child: Icon(Icons.settings),
              ),
            ],
          ),
        ),
      );
      await matchGolden(tester, 'tooltip_multiple', device: defaultGoldenDevice);
    });

    testWidgets('tooltip on icon buttons', (tester) async {
      await tester.pumpWidget(
        GoldenTestWrapper(
          device: defaultGoldenDevice,
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              GrafitTooltip(
                message: 'Copy to clipboard',
                child: Icon(Icons.copy),
              ),
              SizedBox(width: 16),
              GrafitTooltip(
                message: 'Download file',
                child: Icon(Icons.download),
              ),
              SizedBox(width: 16),
              GrafitTooltip(
                message: 'Delete item',
                child: Icon(Icons.delete),
              ),
            ],
          ),
        ),
      );
      await matchGolden(tester, 'tooltip_icon_buttons', device: defaultGoldenDevice);
    });
  });
}
