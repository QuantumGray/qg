import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qg_flutter_native_windows/qg_flutter_native_windows.dart';

void main() {
  const channel = MethodChannel('qg_flutter_native');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async => '42');
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await QgFlutterNativeWindowsPlatform.platformVersion, '42');
  });
}
