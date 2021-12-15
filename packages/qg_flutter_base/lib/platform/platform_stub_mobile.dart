import 'platform_stub.dart';

class PlatformStubMobile implements PlatformStub {
  PlatformStubMobile() {
    _init();
  }

  void _init() {}

  @override
  String hello() {
    return "Hello from mobile";
  }
}

PlatformStub getKeyFinder() => PlatformStubMobile();
