// This is a basic Flutter widget test.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:control_gastos/main.dart';

void main() {
  testWidgets('Finance app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const FinanceApp());

    // Verify that the home screen loads
    expect(find.text('Inicio'), findsOneWidget);
  });
}
