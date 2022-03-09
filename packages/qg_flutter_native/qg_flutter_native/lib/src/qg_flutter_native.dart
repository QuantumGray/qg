import 'package:qg_flutter_native_platform_interface/qg_flutter_native_platform_interface.dart';

class QgFlutterNative {
  QgFlutterNative({
    required QgFlutterNativePlatform? qgFlutterNativePlatform,
  }) : _qgFlutterNativePlatform =
            qgFlutterNativePlatform ?? QgFlutterNativePlatform.instance;

  final QgFlutterNativePlatform _qgFlutterNativePlatform;
}
