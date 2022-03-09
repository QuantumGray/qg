import 'dart:async';
import 'dart:html' as html;

import 'package:flutter/foundation.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:qg_flutter_native_platform_interface/qg_flutter_native_platform_interface.dart';

/// The web implementation of [QgFlutterNativePlatform].
///
/// This class implements the `package:qg_flutter_native`
/// functionality for the web.
class QgFlutterNativeWebPlatform extends QgFlutterNativePlatform {
  /// Registers this class as the default instance of [QgFlutterNativePlatform].
  static void registerWith(Registrar registrar) {
    QgFlutterNativePlatform.instance = QgFlutterNativeWebPlatform();
  }

  /// The current browser window.
  @visibleForTesting
  html.Window? window;

  html.Window get _window => window ?? html.window;

  /// Returns a [String] containing the version of the platform.
  Future<String> get getPlatformVersion {
    return Future.value(_window.navigator.userAgent);
  }
}
