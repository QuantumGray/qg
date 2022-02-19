import 'dart:async';
import 'package:riverpod/riverpod.dart';
import 'package:dotenv/dotenv.dart';

Future<void> bootstrap(FutureOr<void> Function() main) async {
  await runZonedGuarded(
    () async => await main(),
    (error, trace) {},
  );
}

Future<void> runDart({
  required Override Function(
    Provider<RuntimeConfig> runtimeConfigProvider,
    Environment environment,
  )
      runtimeConfigOverride,
  required Future<void> Function(
    ProviderContainer container,
    RuntimeConfig config,
  )
      runner,
  Function? onError,
}) async {
  load();
  final container = ProviderContainer(
    overrides: [
      runtimeConfigOverride(
        pRuntimeConfig,
        env,
      ),
    ],
  );
  final run = Future.wait<void>(
    [
      runner(
        container,
        container.read(pRuntimeConfig),
      ),
    ],
  );

  if (onError != null) {
    run.catchError(onError);
  }

  await run;
}

final pRuntimeConfig = Provider<RuntimeConfig>(
  (ref) => throw UnimplementedError(),
);

class RuntimeConfig<X extends Object, E extends Object> {
  final bool debug;
  final X extended;
  final E Function(Map<String, String> env) environment;

  RuntimeConfig({
    required this.debug,
    required this.extended,
    required this.environment,
  }) {
    load();
  }
}

typedef Environment = Map<String, String>;

extension EnvironmentGetters on Environment {
  Map<String, String> get _env => env;

  String get gcpProjectId => _env['GCP_PROJECT_ID']!;
  String get jwtIssuer => _env['JWT_ISSUER']!;
  String get jwtSecret => _env['JWT_SECRET']!;
  String get domain => _env['DOMAIN']!;
  String get email => _env['EMAIL']!;
  int get httpPort => int.parse(_env['HTTP_PORT']!);
  int get secureHttpPort => int.parse(_env['SECURE_HTTP_PORT']!);
  int get wsPort => int.parse(_env['WS_PORT']!);
}
