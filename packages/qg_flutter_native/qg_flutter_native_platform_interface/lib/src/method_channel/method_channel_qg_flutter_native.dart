import 'package:qg_flutter_native_platform_interface/qg_flutter_native_platform_interface.dart';

/// An implementation of [QgFlutterNativePlatform]
/// that uses a `MethodChannel` to communicate with the native code.
///
/// The `qg_flutter_native` plugin code
/// itself never talks to the native code directly.
/// It delegates all calls to an instance of a class
/// that extends the [QgFlutterNativePlatform].
///
/// The architecture above allows for platforms that communicate differently
/// with the native side (like web) to have a common interface to extend.
///
/// This is the instance that runs when the native side talks
/// to your Flutter app through MethodChannels (Android and iOS platforms).
class MethodChannelQgFlutterNative extends QgFlutterNativePlatform {}
