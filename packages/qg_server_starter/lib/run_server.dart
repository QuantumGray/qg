// ignore_for_file: invalid_return_type_for_catch_error, argument_type_not_assignable_to_error_handler
import 'package:qg_base/logger.dart';
import 'package:qg_server_starter/env.dart';
import 'package:qg_server_starter/servers/ws/ws_server.dart';
import 'package:riverpod/riverpod.dart';
import 'servers/http/http_server.dart';

late ProviderContainer container;

Future<void> runServer(
    {Override Function(Provider<RuntimeConfig> runtimeConfigProvider)?
        runtimeConfigOverride}) async {
  container = ProviderContainer(
    overrides: [
      if (runtimeConfigOverride != null)
        runtimeConfigOverride(
          pRuntimeConfig,
        ),
    ],
  );

  final env = container.read(pEnv);
  final address = env.host;
  final httpPort = env.httpPort;
  final websocketPort = env.wsPort;

  // container = ProviderContainer(
  //   overrides: [
  //     pGapiAuthClient.overrideWithValue(
  //       await container.read(pGapiAuthClientFuture.future),
  //     )
  //   ],
  //   parent: container,
  // );

  final httpServer = container.read(pHttpServer);
  final wsServer = container.read(pWsServer);

  await Future.wait<void>(
    [
      httpServer.serve(address: address, port: httpPort),
      wsServer.serve(address: address, port: websocketPort),
    ],
  ).catchError(container.read(pLogger).e);
}
