import 'package:qg_flutter_base/base/bootstrap/bootstrap.dart'
    show RuntimeConfig;

import 'bootstrap.dart';

Future<void> main(List<String> args) => bootstrap(
      runtimeConfigOverride: (runtimeConfig, environment) =>
          runtimeConfig.overrideWithValue(
        RuntimeConfig<AppRuntimeConfig, Map>(
          debug: true,
          extended: AppRuntimeConfig(
            log: true,
            secure: false,
            respondWithPage: true,
          ),
          environment: (env) => env,
        ),
      ),
    );
