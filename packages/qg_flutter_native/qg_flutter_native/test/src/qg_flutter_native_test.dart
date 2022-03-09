import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:qg_flutter_native/qg_flutter_native.dart';

class MockQgFlutterNativePlatform extends Mock implements QgFlutterNativePlatform {}

void main() {
  group('QgFlutterNative', () {
    test('can be instantiated', () {
      expect(
        QgFlutterNative(qgFlutterNativePlatform: MockQgFlutterNativePlatform()),
        isNotNull,
      );
    });
  });
}
