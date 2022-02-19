import 'package:qg_server_starter/env.dart';
import 'package:qg_server_starter/run_server.dart';
import 'bootstrap.dart';

Future<void> main(List<String> args) => bootstrap(
      () => runServer(
        runtimeConfigOverride: (runtimeConfig) =>
            runtimeConfig.overrideWithValue(
          RuntimeConfig(
            debug: true,
            extended: QgServerRuntimeConfig(
              log: true,
              secure: false,
            ),
          ),
        ),
      ),
    );
