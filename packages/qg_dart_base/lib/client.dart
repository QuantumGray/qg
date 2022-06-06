import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:logger/logger.dart';

class HttpClient {
  HttpClient({
    required String baseUrl,
  }) {
    client
      ..options.connectTimeout = 5000
      ..options.baseUrl = baseUrl
      ..options.headers = {'': "dio", "api-version": "1.0.0"};
    client.interceptors
      ..add(
        LoggerInterceptor(logger: Logger()),
      )
      ..add(
        DioCacheInterceptor(
          options: CacheOptions(
            store: MemCacheStore(),
          ),
        ),
      )
      ..add(
        QueuedInterceptorsWrapper(
          onRequest: (options, handler) {
            const dynamic csrfToken = "";
            // print(
            //     'send request：path:${options.path}，baseURL:${options.baseUrl}');
            if (csrfToken == null) {
              // print('no token，request token firstly...');
              // tokenDio.get('/token').then(
              //   (d) {
              //     options.headers['csrfToken'] =
              //         csrfToken = d.data['data']['token'];
              //     print('request token succeed, value: ' +
              //         d.data['data']['token']);
              //     print(
              //         'continue to perform request：path:${options.path}，baseURL:${options.path}');
              //     handler.next(options);
              //   },
              // ).catchError(
              //   (error, stackTrace) {
              //     handler.reject(error, true);
              //   },
              // );
            } else {
              options.headers['csrfToken'] = csrfToken;
              return handler.next(options);
            }
          },
        ),
      );
    // ..add(
    //   InterceptorsWrapper(
    //     onRequest: (options, handler) {
    //       return handler
    //           .resolve(Response(requestOptions: options, data: 'fake data'));
    //     },
    //   ),
    // );
  }

  final client = Dio();

  Future<List<String>> uploadFiles(
    List<File> files, {
    String endpoint = '/upload',
  }) async {
    try {
      final formData = FormData.fromMap(
        {
          'files': [
            for (final file in files)
              await MultipartFile.fromFile(
                file.path,
                filename: file.path.split('/').last,
              ),
          ]
        },
      );
      final response = await client.post(endpoint, data: formData);
      return response.data['ids'] as List<String>;
    } catch (e) {
      rethrow;
    }
  }

  void weenie() {}
}

class LoggerInterceptor extends Interceptor {
  final Logger logger;
  LoggerInterceptor({required this.logger});

  Logger get _l => logger;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    _l.i(
      'REQUEST[${options.method}] => PATH: ${options.baseUrl + options.path}',
    );

    return super.onRequest(options, handler);
  }

  @override
  Future onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) async {
    _l.i(
      '${_formatResponse(response)} => PATH: ${response.requestOptions.path}',
    );
    return super.onResponse(response, handler);
  }

  @override
  Future onError(DioError err, ErrorInterceptorHandler handler) async {
    _l.e(err);
    if (err.response != null) {
      _l.i(
        '${_formatResponse(err.response!)} => PATH: ${err.requestOptions.path}',
      );
    }
    return super.onError(err, handler);
  }

  String _formatResponse(Response response) {
    return '''
    RESPONSE:
    STATUS: ${response.statusCode}
    HEADERS: ${response.headers}
    DATA: ${response.data}
    ''';
  }
}
