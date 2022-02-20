import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as _http;
import 'package:http/io_client.dart';
import 'package:qg_dart_base/exceptions/api_exceptions.dart';
import 'package:qg_dart_base/exceptions/base_exception.dart';
import 'package:qg_dart_base/exceptions/parse_exception.dart';
import 'package:qg_dart_base/qg_dart_base.dart';
import 'package:qg_dart_base/utils/io/async_response.dart';

final pApiRepository = Provider<IHttpApiClient>((_) => HttpApiClient());

abstract class IHttpApiClient {
  Future<AsyncResponse<T?>> get<T>(
    String uri, {
    T Function(Map<String, dynamic>)? parser,
    T Function(String)? stringParser,
    String? baseUri,
    bool useCompute = false,
  });

  Future<AsyncResponse<T?>> post<T>(
    String uri, {
    dynamic body,
    bool encodeJson = true,
    Map<String, String>? headers,
    T Function(Map<String, dynamic>)? parser,
    String? baseUri,
  });

  Future<_http.StreamedResponse?> getFile(
    String uri,
    Map<String, String> headers,
  );

  Future<T?> parse<T>(
    Future<_http.Response> Function() request, {
    T Function(Map<String, dynamic>)? jsonParser,
    T Function(String)? parser,
    bool useCompute = false,
  });

  Future<BaseException> parseException(_http.BaseResponse res);
}

class HttpApiClient implements IHttpApiClient {
  HttpApiClient({
    this.client,
  }) {
    client ??= IOClient();
  }

  _http.BaseClient? client;
  _http.BaseClient get _client => client!;
  final String _baseUri = "http://localhost:3000"; //"api.coup.app/v1/";

  @override
  Future<AsyncResponse<T?>> get<T>(
    String uri, {
    T Function(Map<String, dynamic>)? parser,
    T Function(String)? stringParser,
    String? baseUri,
    bool useCompute = false,
  }) =>
      AsyncResponse.guard(() async {
        baseUri ??= _baseUri; // apiBaseUri getter
        return parse<T>(
          () => _client.get(
            Uri.parse(baseUri! + uri),
          ),
          jsonParser: parser,
          parser: stringParser,
          useCompute: useCompute,
        );
      });

  @override
  Future<_http.StreamedResponse?> getFile(
    String uri,
    Map<String, String> headers,
  ) async {
    try {
      final response = await _client.send(Request('GET', Uri.parse(uri)));
      if (response.statusCode >= 200 && response.statusCode <= 299) {
        return response;
      }
      //throw await _handleStatusCodes(response);
    } on SocketException {
      throw NoInternetException();
    }
  }

  @override
  Future<AsyncResponse<T?>> post<T>(
    String uri, {
    dynamic body,
    bool encodeJson = true,
    Map<String, String>? headers,
    T Function(Map<String, dynamic>)? parser,
    String? baseUri,
  }) =>
      AsyncResponse.guard(() async {
        baseUri ??= _baseUri;
        late String _body;
        if (encodeJson) {
          headers ??= {};

          headers?['Content-Type'] = 'application/json';
          headers?['Accept'] = 'application/json';
          _body = jsonEncode(body);
        }

        return parse<T>(
          () => _http.post(
            Uri.parse(baseUri! + uri),
            headers: headers,
            body: _body,
          ),
          jsonParser: parser,
        );
      });

  @override
  Future<T?> parse<T>(
    Future<_http.Response> Function() request, {
    T Function(Map<String, dynamic>)? jsonParser,
    T Function(String)? parser,
    bool useCompute = false,
  }) async {
    try {
      final res = await request();
      if (res.statusCode >= 200 && res.statusCode <= 299) {
        if (jsonParser != null && res.body.isNotEmpty) {
          if (useCompute) {
            return jsonParser(_parseAndDecode(res.bodyBytes));
          } else {
            return jsonParser(
              jsonDecode(utf8.decode(res.bodyBytes)) as Map<String, dynamic>,
            );
          }
        } else if (parser != null && res.body.isNotEmpty) {
          return parser(utf8.decode(res.bodyBytes));
        } else {
          return null;
        }
      }
      throw await parseException(res);
    } catch (e) {
      throw ParseException();
    }
  }

  @override
  Future<BaseException> parseException(_http.BaseResponse res) async {
    String body;
    if (res is Response) {
      body = res.body;
    } else if (res is StreamedResponse) {
      body = await res.stream.bytesToString();
    }

    switch (res.statusCode) {
      case 500:
        return InternalServerException();
      case 502:
        return BadGatewayException();
      case 504:
        return BadGatewayException();
    }
    return UnknownException();
  }
}

Map<String, dynamic> _parseAndDecode(Uint8List list) {
  return jsonDecode(utf8.decode(list)) as Map<String, dynamic>;
}

const environment = 'development';

String get apiBaseUri {
  return baseUrls[environment] ?? baseUrls['production']!;
}

String get featureFlagsUri {
  return featureFlagUrls[environment] ?? featureFlagUrls['production']!;
}

String get analyticsUri {
  return analyticsUrls[environment] ?? analyticsUrls['production']!;
}

const baseUrls = {
  'production': 'https://api.coup.app/',
  'staging': 'https://api.coup.app/',
  'development': 'https://api.coup.app/',
};

const featureFlagUrls = {
  'production': 'https://api.coup.app/',
  'staging': 'https://api.coup.app/',
  'development': 'https://api.coup.app/',
};

const analyticsUrls = {
  'production': 'https://api.coup.app/',
  'staging': 'https://api.coup.app/',
  'development': 'https://api.coup.app/',
};
