import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:grafit_ui/grafit_ui.dart';
import '../helpers/golden_helpers.dart';

void main() {
  group('Tabs Golden Tests', () {
    testWidgets('value variant - default', (tester) async {
      await tester.pumpWidget(
        GoldenTestWrapper(
          device: defaultGoldenDevice,
          child: SizedBox(
            height: 300,
            child: GrafitTabs(
              tabs: const [
                GrafitTab(
                  label: 'Account',
                  content: Center(child: Text('Account settings')),
                ),
                GrafitTab(
                  label: 'Password',
                  content: Center(child: Text('Password settings')),
                ),
                GrafitTab(
                  label: 'Appearance',
                  content: Center(child: Text('Appearance settings')),
                ),
              ],
            ),
          ),
        ),
      );
      await matchGolden(tester, 'tabs_value', device: defaultGoldenDevice);
    });

    testWidgets('line variant', (tester) async {
      await tester.pumpWidget(
        GoldenTestWrapper(
          device: defaultGoldenDevice,
          child: SizedBox(
            height: 300,
            child: GrafitTabs(
              variant: GrafitTabsVariant.line,
              tabs: const [
                GrafitTab(
                  label: 'Overview',
                  content: Center(child: Text('Overview content')),
                ),
                GrafitTab(
                  label: 'Analytics',
                  content: Center(child: Text('Analytics content')),
                ),
                GrafitTab(
                  label: 'Reports',
                  content: Center(child: Text('Reports content')),
                ),
              ],
            ),
          ),
        ),
      );
      await matchGolden(tester, 'tabs_line', device: defaultGoldenDevice);
    });

    testWidgets('vertical orientation', (tester) async {
      await tester.pumpWidget(
        GoldenTestWrapper(
          device: defaultGoldenDevice,
          child: SizedBox(
            height: 300,
            child: GrafitTabs(
              orientation: GrafitTabsOrientation.vertical,
              tabs: const [
                GrafitTab(
                  label: 'Profile',
                  content: Center(child: Text('Profile information')),
                ),
                GrafitTab(
                  label: 'Security',
                  content: Center(child: Text('Security settings')),
                ),
                GrafitTab(
                  label: 'Notifications',
                  content: Center(child: Text('Notification preferences')),
                ),
              ],
            ),
          ),
        ),
      );
      await matchGolden(tester, 'tabs_vertical', device: defaultGoldenDevice);
    });

    testWidgets('vertical with line variant', (tester) async {
      await tester.pumpWidget(
        GoldenTestWrapper(
          device: defaultGoldenDevice,
          child: SizedBox(
            height: 300,
            child: GrafitTabs(
              variant: GrafitTabsVariant.line,
              orientation: GrafitTabsOrientation.vertical,
              tabs: const [
                GrafitTab(
                  label: 'Dashboard',
                  content: Center(child: Text('Dashboard content')),
                ),
                GrafitTab(
                  label: 'Projects',
                  content: Center(child: Text('Projects list')),
                ),
                GrafitTab(
                  label: 'Team',
                  content: Center(child: Text('Team members')),
                ),
              ],
            ),
          ),
        ),
      );
      await matchGolden(tester, 'tabs_vertical_line', device: defaultGoldenDevice);
    });
  });
}
