import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:grafit_ui/grafit_ui.dart';
import '../helpers/golden_helpers.dart';

void main() {
  group('Dialog Golden Tests', () {
    testWidgets('dialog with title and description', (tester) async {
      await tester.pumpWidget(
        GoldenTestWrapper(
          device: defaultGoldenDevice,
          home: Scaffold(
            backgroundColor: Colors.black.withOpacity(0.5),
            body: Center(
              child: Material(
                color: Colors.transparent,
                child: Container(
                  width: 400,
                  constraints: BoxConstraints(maxHeight: 600),
                  child: GrafitDialog(
                    title: 'Confirm Action',
                    description: 'Are you sure you want to proceed? This action cannot be undone.',
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      await matchGolden(tester, 'dialog_simple', device: defaultGoldenDevice);
    });

    testWidgets('dialog with content', (tester) async {
      await tester.pumpWidget(
        GoldenTestWrapper(
          device: defaultGoldenDevice,
          home: Scaffold(
            backgroundColor: Colors.black.withOpacity(0.5),
            body: Center(
              child: Material(
                color: Colors.transparent,
                child: Container(
                  width: 400,
                  constraints: BoxConstraints(maxHeight: 600),
                  child: GrafitDialog(
                    title: 'Edit Profile',
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('Name'),
                        SizedBox(height: 4),
                        TextField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Enter your name',
                          ),
                        ),
                        SizedBox(height: 16),
                        Text('Email'),
                        SizedBox(height: 4),
                        TextField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Enter your email',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      await matchGolden(tester, 'dialog_with_content', device: defaultGoldenDevice);
    });

    testWidgets('dialog without cancel button', (tester) async {
      await tester.pumpWidget(
        GoldenTestWrapper(
          device: defaultGoldenDevice,
          home: Scaffold(
            backgroundColor: Colors.black.withOpacity(0.5),
            body: Center(
              child: Material(
                color: Colors.transparent,
                child: Container(
                  width: 400,
                  constraints: BoxConstraints(maxHeight: 600),
                  child: GrafitDialog(
                    title: 'Delete Account',
                    description: 'This action cannot be undone.',
                    confirmText: 'Delete',
                    showCancel: false,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      await matchGolden(tester, 'dialog_no_cancel', device: defaultGoldenDevice);
    });
  });
}
