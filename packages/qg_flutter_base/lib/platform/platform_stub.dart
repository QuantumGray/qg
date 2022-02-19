import 'platform_stub_default.dart'
    // ignore: uri_does_not_exist
    if (dart.library.io) 'package:qg_flutter_base/src/platform/platform_stub_mobile.dart'
    // ignore: uri_does_not_exist
    if (dart.library.html) 'package:qg_flutter_base/src/platform/platform_stub_web.dart';

abstract class PlatformStub {
  String hello();

  factory PlatformStub() => getKeyFinder();
}
