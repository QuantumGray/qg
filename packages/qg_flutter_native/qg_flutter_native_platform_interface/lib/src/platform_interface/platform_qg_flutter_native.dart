import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:qg_flutter_native_platform_interface/qg_flutter_native_platform_interface.dart';

abstract class QgFlutterNativePlatform extends PlatformInterface {
  /// Constructs a [QgFlutterNativePlatform].
  QgFlutterNativePlatform() : super(token: _token);

  static final Object _token = Object();

  static QgFlutterNativePlatform _instance = MethodChannelQgFlutterNative();

  /// The default instance of [QgFlutterNativePlatform] to use.
  ///
  /// Defaults to [MethodChannelQgFlutterNative].
  static QgFlutterNativePlatform get instance => _instance;

  /// Platform-specific plugins should set this with their own platform-specific
  /// class that extends [QgFlutterNativePlatform] when they register themselves.
  static set instance(QgFlutterNativePlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }
}
