library;

import 'package:flutter_test/flutter_test.dart';

/// Global test configuration for Grafit UI test suite.
///
/// Usage:
/// ```dart
/// import 'test_config.dart';
///
/// void main() {
///   testWidgets('my test', (tester) async {
///     // Test code here
///   });
/// }
/// ```

/// Run all tests with common configuration
void grafitTestSuite(void Function() callback) {
  callback();
}

/// Configuration for golden tests
class GoldenTestConfig {
  /// Golden file comparison tolerance
  static const double pixelTolerance = 0.01;

  /// Skip golden tests (useful for CI environments)
  static const bool skipGoldenTests =
      bool.fromEnvironment('SKIP_GOLDEN_TESTS', defaultValue: false);
}

/// Test timeout configuration
class TestTimeouts {
  /// Default timeout for widget tests
  static const Duration defaultDuration = Duration(minutes: 2);

  /// Extended timeout for integration tests
  static const Duration extendedDuration = Duration(minutes: 5);

  /// Short timeout for unit tests
  static const Duration shortDuration = Duration(seconds: 30);
}

/// Test groups for organizing tests
class TestGroups {
  /// Widget tests group
  static const String widgets = 'Widgets';

  /// Golden tests group
  static const String golden = 'Golden';

  /// Unit tests group
  static const String unit = 'Unit';

  /// Integration tests group
  static const String integration = 'Integration';

  /// Accessibility tests group
  static const String a11y = 'Accessibility';
}

/// Test tags for filtering tests
class TestTags {
  /// Tag for smoke tests (basic functionality)
  static const String smoke = 'smoke';

  /// Tag for regression tests
  static const String regression = 'regression';

  /// Tag for slow tests
  static const String slow = 'slow';

  /// Tag for tests requiring external resources
  static const String external = 'external';
}

/// Common test configurations
class TestConfig {
  /// Default widget test configuration
  static const Timeout widgetTest = Timeout(Duration(minutes: 1));

  /// Default golden test configuration
  static const Timeout goldenTest = Timeout(Duration(minutes: 2));

  /// Test variants for light and dark themes
  static const List<bool> themeVariants = [false, true];

  /// Test sizes for responsive components
  static const List<String> sizes = ['sm', 'md', 'lg'];
}
