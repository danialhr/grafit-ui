/// Golden test runner for all component golden tests
///
/// Run all golden tests with:
/// flutter test test/golden/golden_test.dart --golden-tests
///
/// Update golden files with:
/// flutter test test/golden/golden_test.dart --update-goldens

import 'package:flutter_test/flutter_test.dart';
import 'components/button_golden_test.dart' as button;
import 'components/input_golden_test.dart' as input;
import 'components/checkbox_golden_test.dart' as checkbox;
import 'components/switch_golden_test.dart' as switch_test;
import 'components/select_golden_test.dart' as select;
import 'components/badge_golden_test.dart' as badge;
import 'components/card_golden_test.dart' as card;
import 'components/avatar_golden_test.dart' as avatar;
import 'components/table_golden_test.dart' as table;
import 'components/alert_golden_test.dart' as alert;
import 'components/tabs_golden_test.dart' as tabs;
import 'components/breadcrumb_golden_test.dart' as breadcrumb;
import 'components/pagination_golden_test.dart' as pagination;
import 'components/dialog_golden_test.dart' as dialog;
import 'components/tooltip_golden_test.dart' as tooltip;

void main() {
  group('Golden Tests - Form Components', () {
    button.main();
    input.main();
    checkbox.main();
    switch_test.main();
    select.main();
  });

  group('Golden Tests - Data Display Components', () {
    badge.main();
    card.main();
    avatar.main();
    table.main();
    alert.main();
  });

  group('Golden Tests - Navigation Components', () {
    tabs.main();
    breadcrumb.main();
    pagination.main();
  });

  group('Golden Tests - Overlay Components', () {
    dialog.main();
    tooltip.main();
  });
}
