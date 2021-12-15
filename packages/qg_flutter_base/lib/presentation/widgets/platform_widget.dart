import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class PlatformWidget extends StatelessWidget {
  final Widget? ios;
  final Widget? android;
  final Widget? web;
  final Widget? mac;
  final Widget? windows;
  final Widget? linux;
  final Widget defaultResolveTo;

  const PlatformWidget({
    this.ios,
    this.android,
    this.web,
    this.mac,
    this.windows,
    this.linux,
    this.defaultResolveTo =
        const Text('default widget for no matching platform'),
  });

  @override
  Widget build(BuildContext context) {
    return _delegate();
  }

  Widget _delegate() {
    if (Platform.isIOS) {
      return ios ?? _default();
    } else if (Platform.isAndroid) {
      return android ?? _default();
    } else if (kIsWeb) {
      return web ?? _default();
    } else if (Platform.isMacOS) {
      return mac ?? _default();
    } else if (Platform.isLinux) {
      return linux ?? _default();
    } else if (Platform.isWindows) {
      return windows ?? _default();
    }
    return _default();
  }

  Widget _default() {
    return defaultResolveTo;
  }
}
