import 'dart:html';

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:qg_flutter_native_platform_interface/qg_flutter_native_platform_interface.dart';
import 'package:qg_flutter_native_web/qg_flutter_native_web.dart';

class MockWindow extends Mock implements Window {}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('QgFlutterNativeWebPlatform', () {
    late Window window;

    setUp(() async {
      window = MockWindow();

      QgFlutterNativePlatform.instance = QgFlutterNativeWebPlatform()..window = window;
    });

    testWidgets('QgFlutterNativeWebPlatform is the live instance', (tester) async {
      expect(QgFlutterNativePlatform.instance, isA<QgFlutterNativeWebPlatform>());
    });
  });
}
