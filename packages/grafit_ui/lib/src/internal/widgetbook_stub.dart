// Widgetbook stub for code generation
// This file provides stub implementations to suppress analyzer errors
// The actual implementation comes from widgetbook_annotation during code generation

import 'package:flutter/widgets.dart';

/// Stub extension to suppress analyzer errors for Widgetbook use cases
/// The real knobs extension is provided by widgetbook_annotation code generation
extension WidgetbookBuildContextStub on BuildContext {
  /// Stub for knobs - only available in Widgetbook environment
  dynamic get knobs => _WidgetbookKnobsStub();
}

class _WidgetbookKnobsStub {
  String string({required String label, required String initialValue}) => initialValue;
  bool boolean({required String label, required bool initialValue}) => initialValue;
  int slider({required String label, required int min, required int max, required int initialValue}) => initialValue;
  double doubleSlider({required String label, required double min, required double max, required double initialValue}) => initialValue;
  List<T> list<T>({required String label, required List<T> options, required T initial, String? labelBuilder(T)?}) => initial;
}
