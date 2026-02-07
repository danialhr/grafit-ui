import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:grafit_ui/grafit_ui.dart';
import '../helpers/golden_helpers.dart';

void main() {
  group('Select Golden Tests', () {
    testWidgets('closed state', (tester) async {
      await tester.pumpWidget(
        GoldenTestWrapper(
          device: defaultGoldenDevice,
          child: const GrafitSelect<String>(
            placeholder: 'Select an option',
            items: [
              GrafitSelectItemData(value: 'apple', label: 'Apple'),
              GrafitSelectItemData(value: 'banana', label: 'Banana'),
              GrafitSelectItemData(value: 'orange', label: 'Orange'),
            ],
          ),
        ),
      );
      await matchGolden(tester, 'select_closed', device: defaultGoldenDevice);
    });

    testWidgets('with label', (tester) async {
      await tester.pumpWidget(
        GoldenTestWrapper(
          device: defaultGoldenDevice,
          child: const GrafitSelect<String>(
            label: 'Favorite Fruit',
            placeholder: 'Select an option',
            items: [
              GrafitSelectItemData(value: 'apple', label: 'Apple'),
              GrafitSelectItemData(value: 'banana', label: 'Banana'),
            ],
          ),
        ),
      );
      await matchGolden(tester, 'select_with_label', device: defaultGoldenDevice);
    });

    testWidgets('error state', (tester) async {
      await tester.pumpWidget(
        GoldenTestWrapper(
          device: defaultGoldenDevice,
          child: const GrafitSelect<String>(
            label: 'Select Option',
            placeholder: 'Choose an option',
            errorText: 'This field is required',
            items: [
              GrafitSelectItemData(value: 'opt1', label: 'Option 1'),
              GrafitSelectItemData(value: 'opt2', label: 'Option 2'),
            ],
          ),
        ),
      );
      await matchGolden(tester, 'select_error', device: defaultGoldenDevice);
    });

    testWidgets('small size', (tester) async {
      await tester.pumpWidget(
        GoldenTestWrapper(
          device: defaultGoldenDevice,
          child: const GrafitSelect<String>(
            placeholder: 'Select...',
            size: GrafitSelectSize.sm,
            items: [
              GrafitSelectItemData(value: 'opt1', label: 'Option 1'),
              GrafitSelectItemData(value: 'opt2', label: 'Option 2'),
            ],
          ),
        ),
      );
      await matchGolden(tester, 'select_small', device: defaultGoldenDevice);
    });

    testWidgets('disabled state', (tester) async {
      await tester.pumpWidget(
        GoldenTestWrapper(
          device: defaultGoldenDevice,
          child: const GrafitSelect<String>(
            label: 'Disabled Select',
            placeholder: 'Cannot select',
            enabled: false,
            items: [
              GrafitSelectItemData(value: 'opt1', label: 'Option 1'),
              GrafitSelectItemData(value: 'opt2', label: 'Option 2'),
            ],
          ),
        ),
      );
      await matchGolden(tester, 'select_disabled', device: defaultGoldenDevice);
    });

    testWidgets('with grouped options', (tester) async {
      await tester.pumpWidget(
        GoldenTestWrapper(
          device: defaultGoldenDevice,
          child: const GrafitSelect<String>.grouped(
            label: 'Select Food',
            placeholder: 'Choose a food item',
            groups: [
              GrafitSelectGroupData(
                label: 'Fruits',
                items: [
                  GrafitSelectItemData(value: 'apple', label: 'Apple'),
                  GrafitSelectItemData(value: 'banana', label: 'Banana'),
                  GrafitSelectItemData(value: 'orange', label: 'Orange'),
                ],
              ),
              GrafitSelectGroupData(
                label: 'Vegetables',
                items: [
                  GrafitSelectItemData(value: 'carrot', label: 'Carrot'),
                  GrafitSelectItemData(value: 'broccoli', label: 'Broccoli'),
                ],
              ),
            ],
          ),
        ),
      );
      await matchGolden(tester, 'select_grouped', device: defaultGoldenDevice);
    });
  });
}
