import 'dart:async';

import 'package:flutter/services.dart';
import 'package:qg_flutter_native_platform_interface/qg_flutter_native_platform_interface.dart';

class QgFlutterNativeAndroidPlatform extends QgFlutterNativePlatform {
  static const _channel = MethodChannel('qg_flutter_native');

  /// Sample [MethodChannel] invokation.
  static Future<String?> get platformVersion async {
    final version = await _channel.invokeMethod<String?>('getPlatformVersion');
    return version;
  }
}
