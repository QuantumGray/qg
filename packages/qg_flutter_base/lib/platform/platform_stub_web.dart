// ignore_for_file: avoid_web_libraries_in_flutter, unused_import

import 'dart:html';

import 'platform_stub.dart';

class PlatformStubWeb implements PlatformStub {
  PlatformStubWeb() {
    _init();
  }

  void _init() {}

  @override
  String hello() {
    return "Hello from web plaftorm";
  }
}

PlatformStub getKeyFinder() => PlatformStubWeb();
