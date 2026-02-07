import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:grafit_ui/grafit_ui.dart';
import '../helpers/golden_helpers.dart';

void main() {
  group('Avatar Golden Tests', () {
    testWidgets('with initials', (tester) async {
      await tester.pumpWidget(
        GoldenTestWrapper(
          device: defaultGoldenDevice,
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              GrafitAvatar(name: 'Alice', size: 40),
              SizedBox(width: 8),
              GrafitAvatar(name: 'Bob Smith', size: 40),
              SizedBox(width: 8),
              GrafitAvatar(name: 'Charlie Brown Jr', size: 40),
            ],
          ),
        ),
      );
      await matchGolden(tester, 'avatar_initials', device: defaultGoldenDevice);
    });

    testWidgets('size variants', (tester) async {
      await tester.pumpWidget(
        GoldenTestWrapper(
          device: defaultGoldenDevice,
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GrafitAvatar(name: 'XS', size: 24),
              SizedBox(width: 8),
              GrafitAvatar(name: 'S', size: 32),
              SizedBox(width: 8),
              GrafitAvatar(name: 'M', size: 40),
              SizedBox(width: 8),
              GrafitAvatar(name: 'L', size: 56),
              SizedBox(width: 8),
              GrafitAvatar(name: 'XL', size: 80),
            ],
          ),
        ),
      );
      await matchGolden(tester, 'avatar_sizes', device: defaultGoldenDevice);
    });

    testWidgets('fallback icon', (tester) async {
      await tester.pumpWidget(
        GoldenTestWrapper(
          device: defaultGoldenDevice,
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              GrafitAvatar(size: 32),
              SizedBox(width: 8),
              GrafitAvatar(size: 40),
              SizedBox(width: 8),
              GrafitAvatar(size: 56),
            ],
          ),
        ),
      );
      await matchGolden(tester, 'avatar_fallback', device: defaultGoldenDevice);
    });

    testWidgets('custom fallback', (tester) async {
      await tester.pumpWidget(
        GoldenTestWrapper(
          device: defaultGoldenDevice,
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              GrafitAvatar(
                size: 40,
                fallback: Icon(Icons.star, color: Colors.amber),
              ),
              SizedBox(width: 12),
              GrafitAvatar(
                size: 40,
                fallback: Icon(Icons.favorite, color: Colors.red),
              ),
            ],
          ),
        ),
      );
      await matchGolden(tester, 'avatar_custom_fallback', device: defaultGoldenDevice);
    });

    testWidgets('avatar group', (tester) async {
      await tester.pumpWidget(
        GoldenTestWrapper(
          device: defaultGoldenDevice,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const GrafitAvatar(name: 'Alice', size: 36),
              Transform.translate(
                offset: Offset(-12, 0),
                child: const GrafitAvatar(name: 'Bob', size: 36),
              ),
              Transform.translate(
                offset: Offset(-24, 0),
                child: const GrafitAvatar(name: 'Charlie', size: 36),
              ),
              Transform.translate(
                offset: Offset(-36, 0),
                child: GrafitAvatar(
                  name: '',
                  size: 36,
                  fallback: const Center(
                    child: Text(
                      '+5',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
      await matchGolden(tester, 'avatar_group', device: defaultGoldenDevice);
    });
  });
}
