import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qg_flutter_native_macos/qg_flutter_native_macos.dart';

void main() {
  const channel = MethodChannel('qg_flutter_native');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await QgFlutterNativeMacosPlatform.platformVersion, '42');
  });
}
