import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qg_flutter_base/base/base.dart';
import 'package:qg_flutter_starter/core/app/app.dart';

Future<void> bootstrap({
  required Override Function(
    Provider<RuntimeConfig> runtimeConfigProvider,
    Environment environment,
  )
      runtimeConfigOverride,
}) async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  bootstrapFlutter(
    () => runFlutter(
      runtimeConfigOverride: runtimeConfigOverride,
      runner: () async => const App(),
    ),
  );
}

class AppRuntimeConfig {
  final bool log;
  final bool secure;
  final bool respondWithPage;

  AppRuntimeConfig({
    required this.log,
    required this.secure,
    this.respondWithPage = false,
  });
}
