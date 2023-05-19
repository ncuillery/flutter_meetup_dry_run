import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:app_golden_testing/main.dart';

Future<void> _loadFont(String name, String fileName) async {
  final file = File('./test/assets/$fileName');
  final fontData = await file.readAsBytes();

  final fontLoader = FontLoader(name);

  // Add the font data to the FontLoader
  fontLoader.addFont(Future.value(fontData.buffer.asByteData()));

  // Wait until the fonts are loaded
  await fontLoader.load();
}

void main() {
  setUpAll(() async {
    // Font family names: https://stackoverflow.com/a/75079116/769006
    await _loadFont('.SF UI Text', 'SF-UI-Text-Regular.ttf');
    await _loadFont('.SF UI Display', 'SF-UI-Display-Regular.ttf');
  });

  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    debugDefaultTargetPlatformOverride = TargetPlatform.iOS;

    await tester.pumpWidget(const MyApp());

    await expectLater(
      find.byType(Scaffold),
      matchesGoldenFile('home_page.png'),
    );

    debugDefaultTargetPlatformOverride = null;
  });
}
