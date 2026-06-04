import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:courtly/main.dart';

void main() {
  testWidgets('Courtly app loading smoke test', (WidgetTester tester) async {
    // Set size to desktop to ensure header builds
    tester.view.physicalSize = const Size(1200, 800);
    tester.view.devicePixelRatio = 1.0;

    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that our app name exists on the header/shell.
    expect(find.text('COURTLY'), findsOneWidget);

    // Reset size
    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
  });
}
