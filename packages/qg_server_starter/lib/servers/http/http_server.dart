// ignore_for_file: unused_element, unused_field

import 'dart:convert';
import 'dart:io' as io;
import 'dart:io';
import 'package:convert/convert.dart';
import 'package:http/http.dart' as http;
import 'package:qg_base/logger.dart';
import 'package:qg_base/utils/io/async_response.dart';
import 'package:qg_server_starter/auth/base_auth.dart';
import 'package:qg_server_starter/auth/jwt_auth.dart';
import 'package:qg_server_starter/env.dart';
import 'package:qg_server_starter/response_messages.dart';
import 'package:qg_server_starter/servers/http/endpoints.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_cors_headers/shelf_cors_headers.dart';
import 'package:shelf_proxy/shelf_proxy.dart';
import 'package:shelf_plus/shelf_plus.dart';
import 'package:shelf_letsencrypt/shelf_letsencrypt.dart';
import 'package:shelf_mustache/shelf_mustache.dart';
import 'package:riverpod/riverpod.dart';
import 'package:shelf_rate_limiter/shelf_rate_limiter.dart';
import 'package:shelf_web_socket/shelf_web_socket.dart';

final pHttpServer = Provider<HttpServer>(
  (ref) => HttpServer(
    read: ref.read,
    runtimeConfig: ref.watch(pRuntimeConfig),
    auth: JwtAuth(
      jwtIssuer: ref.read(pEnv).jwtIssuer,
      jwtSecret: ref.read(pEnv).jwtSecret,
    ),
  ),
);

class HttpServer {
  final Reader read;
  final client = http.Client();
  final basePath = io.File(io.Platform.script.toFilePath());
  final BaseAuth? auth;
  final RuntimeConfig<QgServerRuntimeConfig> runtimeConfig;

  HttpServer({
    required this.read,
    this.auth,
    required this.runtimeConfig,
  }) {
    if (auth is JwtAuth) {
      (auth as JwtAuth)
        ..responseBody = _responseBody
        ..responseHeaders = _responseHeaders;
    }
  }

  late List<io.HttpServer> servers;
  late RouterPlus router;
  late Handler masterHandler;
  bool setup = false;

  List<void Function(RouterPlus router)> get _routerMutations => [
        ...endpoints(
          client,
          auth,
        ),
        ..._baseRouterMutations,
      ];

  List<void Function(RouterPlus router)> get _baseRouterMutations => [
        (router) => router.get('/static/<file|.*>', (Request request) async {
              final rootDir = Directory('static').resolveSymbolicLinksSync();
              final fileName = request.params['file'];
              final filePath = rootDir + '/' + fileName!;
              final file = io.File(filePath);
              final fileExists = file.existsSync();

              if (fileExists) {
                final byteSink = ByteAccumulatorSink();

                await file
                    .openRead(0, file.lengthSync())
                    .listen(byteSink.add)
                    .asFuture();

                return Response.ok(byteSink.bytes);
              } else {
                return Response.notFound(
                  'File not found: ' + filePath,
                );
              }
            }),
        (router) => router.all(
              '/<ignored|.*>',
              (Request request) {
                final respondWithPage =
                    read(pRuntimeConfig).extended.respondWithPage;

                final title = '404';
                final message = read(pResponseMessages)
                    .nothingFoundFor(request.params['ignored']);

                late String body;
                final headers = <String, String>{};

                if (respondWithPage) {
                  body = _responseBody(title, message);
                  headers['Content-Type'] = 'text/html';
                } else {
                  body = '$title - $message';
                  headers['Content-Type'] = 'text/html';
                }
                return Response.notFound(
                  body,
                  headers: headers,
                );
              },
            ),
      ];

  List<Middleware> get _middlewares => [
        if (runtimeConfig.extended.log) logRequests(logger: _logRequests),
        if (auth != null) createMiddleware(requestHandler: auth!.handle),
        corsHeaders(
          headers: {
            ACCESS_CONTROL_ALLOW_ORIGIN: read(pEnv).host,
            io.HttpHeaders.contentTypeHeader: 'application/json;charset=utf-8'
          },
        ),
        _rateLimiter.rateLimiter(),
      ];

  List<Handler> get _handlers => [
        ..._baseHandlers,
      ];

  List<Handler> get _baseHandlers => [
        router,
      ];

  Future<AsyncResponse> _setup({required String address, required int port}) =>
      AsyncResponse.guard(
        () async {
          // ROUTER-ENDPOINTS SETUP
          router = Router().plus;

          for (final mutation in _routerMutations) {
            mutation(router);
          }

          // MIDDLEWARE SETUP
          Pipeline pipeline = Pipeline();

          for (final middleware in _middlewares) {
            pipeline = pipeline.addMiddleware(middleware);
          }

          for (final handler in _handlers) {
            masterHandler = pipeline.addHandler(handler);
          }
          setup = true;
        },
      );

  CertificatesHandlerIO get certificatesHandler => CertificatesHandlerIO(
        Directory('/tmp/shelf-letsencrypt-example/'),
      );
  LetsEncrypt get _letsEncrypt =>
      LetsEncrypt(certificatesHandler, production: false);

  ShelfRateLimiter get _rateLimiter => ShelfRateLimiter(
        storage: MemStorage(),
        duration: Duration(seconds: 60),
        maxRequests: 10,
      );

  Map<String, String> get _responseHeaders {
    final headers = <String, String>{};

    headers['Content-Type'] = runtimeConfig.extended.respondWithPage
        ? 'text/html'
        : 'application/json';

    return headers;
  }

  String _responseBody(String title, String message) {
    late String body;

    body = runtimeConfig.extended.respondWithPage
        ? '{{> response_page.html }}'.mustache(
            {
              'title': title,
              'message': message,
            },
            includePath: 'static',
          )
        : '$title - $message';

    return body;
  }

  void _logRequests(String msg, bool _) {
    read(pLogger).i(msg);
  }

  Handler _proxy(
    dynamic url, {
    http.Client? client,
    String? proxyName,
  }) =>
      proxyHandler(url, client: client, proxyName: proxyName);

  T parse<T, F extends Object>(dynamic data,
      {required T Function(F json) parser}) {
    final convertedData = _jsonDecoder.convert(data);
    if (convertedData is! F) {
      throw FormatException();
    }
    return parser(convertedData);
  }

  final _jsonEncoder = JsonEncoder();
  final _jsonDecoder = JsonDecoder();
  final _base64encoder = Base64Encoder();
  final _base64decoder = Base64Decoder();
  final _utf8Encoder = Utf8Encoder();
  final _utf8Decoder = Utf8Decoder();

  Future<void> serve({required String address, required int port}) async {
    if (!setup) {
      final response = await _setup(address: address, port: port);
      final shouldExcite = response.maybeWhen<bool>(
        error: (error, stacktrace) {
          read(pLogger).e(error);
          return true;
        },
        orElse: () => false,
      );
      if (shouldExcite) return;
    }

    if (runtimeConfig.extended.secure) {
      servers = await _letsEncrypt.startSecureServer(
        masterHandler,
        'quantumgray.tech',
        'niklas@quantumgray.tech',
        port: port,
        securePort: 8443,
        requestCertificate: true,
        forceRequestCertificate: false,
        checkCertificate: false,
      );
      for (final server in servers) {
        server.autoCompress = true;
        read(pLogger).i(
            'HTTP server with headers -> ${server.serverHeader} is running at -> ${server.address}');
      }
    } else {
      read(pLogger).i('HTTP server is running at -> $address:$port');
      servers = [await shelf_io.serve(masterHandler, address, port)];
    }
  }
}

extension ShelfRequest on Request {
  Map<String, String> get queryParams => requestedUri.queryParameters;
}
