import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:app_golden_testing/main.dart';

// Source: https://useyourloaf.com/blog/iphone-14-screen-sizes/
const iPhoneWidth = 1170.0;
const iPhoneHeight = 2532.0;
const iPhonePixelRatio = 3.0;
const iPhoneSafeAreaHeight = 47.0 * iPhonePixelRatio + 34.0 * iPhonePixelRatio;

void _setScreenSize() {
  TestWidgetsFlutterBinding binding = TestWidgetsFlutterBinding.instance;
  binding.window.physicalSizeTestValue = const Size(
    iPhoneWidth,
    iPhoneHeight - iPhoneSafeAreaHeight,
  );
  binding.window.devicePixelRatioTestValue = iPhonePixelRatio;
}

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
    TestWidgetsFlutterBinding.ensureInitialized();

    _setScreenSize();

    // Font family names: https://stackoverflow.com/a/75079116/769006
    await _loadFont('.SF UI Text', 'SF-UI-Text-Regular.ttf');
    await _loadFont('.SF UI Display', 'SF-UI-Display-Regular.ttf');

    // See https://github.com/flutter/flutter/issues/75391#issuecomment-775375415
    await _loadFont('MaterialIcons', 'MaterialIcons-Regular.otf');
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
