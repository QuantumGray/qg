import 'package:logger/logger.dart';

abstract class BaseException implements Exception {
  BaseException() {
    log();
  }
  String get message;

  @override
  String toString() => message;

  @override
  bool operator ==(Object other) =>
      other is BaseException && other.message == message;

  @override
  int get hashCode => message.codeUnits
      .fold(0, (previousValue, element) => previousValue ^ element);

  void log() {
    ErrorLogger.i.logger.e(message);
  }
}

class ErrorLogger {
  ErrorLogger._();

  final Logger logger = Logger(level: Level.error);

  static final i = ErrorLogger._();
}
