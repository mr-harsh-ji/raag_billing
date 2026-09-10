import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:raag_billing/main.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const RaagBillingApp());

    // Verify that our counter starts at 0.
    expect(find.text('Raag Billing'), findsOneWidget);
  });
}
