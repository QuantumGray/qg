import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:qg_base/bootstrap.dart';

export 'package:qg_base/bootstrap.dart';

Future<void> bootstrapFlutter(
  FutureOr<void> Function() main, {
  void Function(FlutterErrorDetails)? onError,
}) async {
  WidgetsFlutterBinding.ensureInitialized();
  FlutterError.onError = onError;
  await bootstrap(main);
}

Future<void> runFlutter({
  required Override Function(
    Provider<RuntimeConfig> runtimeConfigProvider,
    Environment environment,
  )
      runtimeConfigOverride,
  required Future<Widget> Function() runner,
  Function? onError,
}) =>
    runDart(
      runtimeConfigOverride: runtimeConfigOverride,
      runner: (container, config) async {
        final run = runner();

        if (onError != null) {
          run.catchError(onError);
        }

        runApp(
          ProviderScope(
            overrides: [
              pRuntimeConfig.overrideWithValue(config),
            ],
            child: await run,
          ),
        );
      },
    );
