import 'dart:async';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:jaguar_jwt/jaguar_jwt.dart';
import 'package:qg_server_starter/auth/base_auth.dart';
import 'package:shelf/shelf.dart';

class JwtAuth implements BaseAuth {
  final String jwtIssuer;
  final String jwtSecret;
  final List<String> noauthRoutes;

  JwtAuth({
    required this.jwtIssuer,
    required this.jwtSecret,
    this.noauthRoutes = const ['static', 'hello'],
  });

  final JsonDecoder _jsonDecoder = JsonDecoder();
  final JsonEncoder _jsonEncoder = JsonEncoder();

  final Utf8Encoder _encoder = Utf8Encoder();

  late String Function(String title, String message) responseBody;
  late Map<String, String> responseHeaders;

  List<int> _convert(String x) => _encoder.convert(x);

  String create(String str) => sha256.convert(_convert(str)).toString();

  List<Map<String, String>> get users => [
        {"username": "test", "password": create("insecure")},
        {"username": "beep", "password": create("beepboop")}
      ];

  FutureOr<bool> _checkUserCredentials(Map<String, String> creds) {
    return (users.indexWhere((user) =>
            (user['username'] == creds['username']) &&
            user['password'] == creds['password'])) !=
        -1;
  }

  @override
  FutureOr<Response?> handle(Request request) async {
    for (final route in noauthRoutes) {
      print(request.url.path);
      if (request.url.path.startsWith(route)) {
        return null;
      }
    }
    return (request.requestedUri.pathSegments.last == 'login')
        ? auth(request)
        : verify(request);
  }

  bool _checkValidFormat(dynamic data) =>
      data is Map &&
      data.containsKey('username') &&
      data.containsKey('password');

  FutureOr<Response> auth(Request request) async {
    try {
      dynamic data = _jsonDecoder.convert(await request.readAsString());

      final dataFormatValid = _checkValidFormat(data);

      if (!dataFormatValid) {
        return Response(
          400,
          body: _body('Invalid format', 'invalid'),
          headers: responseHeaders,
        );
      }

      final user = data['username'] as String;
      final password = data['password'] as String;

      final hash = create(password);

      final creds = {'username': user, 'password': hash};

      final userCredentialsValid = await _checkUserCredentials(creds);
      if (!userCredentialsValid) {
        return Response(
          401,
          body: _body('Incorrect username/password', ''),
          headers: responseHeaders,
        );
      }

      final claim = JwtClaim(
        subject: user,
        issuer: jwtIssuer,
        audience: jwtAudiences,
      );

      final token = issueJwtHS256(claim, jwtSecret);
      return Response.ok(_jsonEncoder.convert({'token': token}));
    } on NullThrownError catch (e) {
      return Response.internalServerError(
        body: _body('Eroor herre', 'Error: $e'),
        headers: responseHeaders,
      );
    } catch (e) {
      return Response.internalServerError(
        body: _body('Unknown', 'Unkown Error: $e'),
        headers: responseHeaders,
      );
    }
  }

  String _body(String title, String message) => responseBody(title, message);

  List<String> get jwtAudiences => ['example.com'];

  FutureOr<Response?> verify(Request request) async {
    try {
      final token = request.authorizationBearer;
      if (token == null) {
        return Response.forbidden(_body('Missing Token', 'No token provided'),
            headers: {'Content-Type': 'text/html'});
      }
      final claim = verifyJwtHS256Signature(token, jwtSecret);
      claim.validate(issuer: jwtIssuer, audience: jwtAudiences.first);
      return null;
    } on JwtException catch (e) {
      return Response.forbidden(
        _body(
          'Forbidden',
          '${e.runtimeType}: ${e.message}',
        ),
        headers: responseHeaders,
      );
    } catch (e) {
      return Response.internalServerError(
        body: _body(
          'Error on our side',
          '${e.runtimeType}: $e',
        ),
        headers: responseHeaders,
      );
    }
  }
}

extension AuthorizationBearer on Request {
  String? get authorizationBearer =>
      headers['Authorization']?.replaceAll('Bearer ', '');
}
