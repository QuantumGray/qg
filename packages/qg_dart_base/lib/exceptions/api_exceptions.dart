import 'base_exception.dart';

class TokenExpiredException extends BaseException {
  @override
  String get message => 'session expired';
}

class NoInternetException extends BaseException {
  @override
  String get message => 'no internet connection';
}

class FetchDataException extends BaseException {
  @override
  String get message => 'currently cant process request';
}

class RequestException extends BaseException {
  @override
  String get message => 'error while sending request';
}

class InternalServerException extends BaseException {
  @override
  String get message => 'internal server error';
}

class BadGatewayException extends BaseException {
  @override
  String get message => 'servers not available';
}

class UnknownException extends BaseException {
  @override
  String get message => 'unknown error';
}
