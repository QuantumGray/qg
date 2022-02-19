import 'dart:io';

import 'package:dotenv/dotenv.dart';
import 'package:googleapis/firestore/v1.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:qg_base/qg_base.dart';

final pEnv = Provider<_Env>((ref) => const _Env());

class _Env {
  const _Env();

  Map<String, String> get _env {
    load();
    return env;
  }

  String get gcpProjectId => _env['GCP_PROJECT_ID']!;
  String get jwtIssuer => _env['JWT_ISSUER']!;
  String get jwtSecret => _env['JWT_SECRET']!;
  String get domain => _env['DOMAIN']!;
  String get email => _env['EMAIL']!;
  String get host => _env['HOST'] ?? InternetAddress.anyIPv4.address;
  int get httpPort => int.parse(_env['HTTP_PORT']!);
  int get secureHttpPort => int.parse(_env['SECURE_HTTP_PORT']!);
  int get wsPort => int.parse(_env['WS_PORT']!);
}

final pGapiAuthClientFuture = FutureProvider<Client>(
  (ref) async => await clientViaApplicationDefaultCredentials(
    scopes: [FirestoreApi.datastoreScope],
  ),
);

final pGapiAuthClient = Provider<Client>(
  (ref) => throw UnimplementedError(),
);

final pRuntimeConfig = Provider<RuntimeConfig<QgServerRuntimeConfig>>(
  (ref) => throw UnimplementedError(),
);

class RuntimeConfig<E> {
  final bool debug;
  final E extended;

  RuntimeConfig({
    required this.debug,
    required this.extended,
  });
}

class QgServerRuntimeConfig {
  final bool log;
  final bool secure;
  final bool respondWithPage;

  QgServerRuntimeConfig({
    required this.log,
    required this.secure,
    this.respondWithPage = false,
  });
}
