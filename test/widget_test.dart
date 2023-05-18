import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:app_golden_testing/main.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    await expectLater(
      find.byType(Scaffold),
      matchesGoldenFile('home_page.png'),
    );
  });
}
