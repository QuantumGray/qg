import 'package:http/http.dart' as http;
import 'package:qg_server_starter/auth/base_auth.dart';
import 'package:shelf_plus/shelf_plus.dart';

List<void Function(RouterPlus router)> endpoints(
  http.Client client,
  BaseAuth? auth,
) =>
    [
      (router) => router.get(
            '/hello',
            (Request request) async {
              return Response.ok('${request.requestedUri} World!');
            },
          ),
    ];
