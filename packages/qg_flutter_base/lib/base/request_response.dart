import 'package:meta/meta.dart';

export 'request_response.dart';

String? modifierName(String? from, String modifier) {
  return from == null ? null : '$from.$modifier';
}

@sealed
@immutable
abstract class RequestResponse<T, E> {
  const factory RequestResponse.data(T value) = RequestDataResponse<T, E>;
  const factory RequestResponse.error(Object error, {StackTrace? stackTrace}) =
      RequestErrorResponse<T, E>;

  static Future<RequestResponse<T, E>> guard<T, E>(
    Future<T> Function() future,
  ) async {
    try {
      return RequestResponse.data(await future());
    } catch (err, stack) {
      return RequestResponse.error(err, stackTrace: stack);
    }
  }

  R _map<R>({
    required R Function(RequestDataResponse<T, E> data) data,
    required R Function(RequestErrorResponse<T, E> error) error,
  });
}

class RequestDataResponse<T, E> implements RequestResponse<T, E> {
  const RequestDataResponse(this.value);

  final T value;

  @override
  R _map<R>({
    required R Function(RequestDataResponse<T, E> data) data,
    required R Function(RequestErrorResponse<T, E> error) error,
  }) {
    return data(this);
  }

  @override
  String toString() {
    return 'AsyncData<$T>(value: $value)';
  }

  @override
  bool operator ==(Object other) {
    return runtimeType == other.runtimeType &&
        other is RequestDataResponse<T, E> &&
        other.value == value;
  }

  @override
  int get hashCode => Object.hash(runtimeType, value);
}

extension RequestResponseExtension<T, E> on RequestResponse<T, E> {
  @Deprecated('use `asData` instead')
  RequestDataResponse<T, E>? get data => asData;

  RequestDataResponse<T, E>? get asData {
    return _map(
      data: (d) => d,
      error: (e) => null,
    );
  }

  T? get value {
    return _map(
      data: (d) => d.value,
      // ignore: only_throw_errors
      error: (e) => throw e.error,
    );
  }

  RequestResponse<R, E> whenData<R>(R Function(T value) cb) {
    return _map(
      data: (d) {
        try {
          return RequestResponse.data(cb(d.value));
        } catch (err, stack) {
          return RequestResponse.error(err, stackTrace: stack);
        }
      },
      error: (e) => RequestErrorResponse(e.error, stackTrace: e.stackTrace),
    );
  }

  R maybeWhen<R>({
    R Function(T data)? data,
    R Function(Object error, StackTrace? stackTrace)? error,
    required R Function() orElse,
  }) {
    return _map(
      data: (d) {
        if (data != null) return data(d.value);
        return orElse();
      },
      error: (e) {
        if (error != null) return error(e.error, e.stackTrace);
        return orElse();
      },
    );
  }

  R when<R>({
    required R Function(T data) data,
    required R Function(Object error, StackTrace? stackTrace) error,
  }) {
    return _map(
      data: (d) => data(d.value),
      error: (e) => error(e.error, e.stackTrace),
    );
  }

  R? whenOrNull<R>({
    R Function(T data)? data,
    R Function(Object error, StackTrace? stackTrace)? error,
  }) {
    return _map(
      data: (d) => data?.call(d.value),
      error: (e) => error?.call(e.error, e.stackTrace),
    );
  }

  R map<R>({
    required R Function(RequestDataResponse<T, E> data) data,
    required R Function(RequestErrorResponse<T, E> error) error,
  }) {
    return _map(
      data: data,
      error: error,
    );
  }

  R maybeMap<R>({
    R Function(RequestDataResponse<T, E> data)? data,
    R Function(RequestErrorResponse<T, E> error)? error,
    required R Function() orElse,
  }) {
    return _map(
      data: (d) {
        if (data != null) return data(d);
        return orElse();
      },
      error: (d) {
        if (error != null) return error(d);
        return orElse();
      },
    );
  }

  R? mapOrNull<R>({
    R Function(RequestDataResponse<T, E> data)? data,
    R Function(RequestErrorResponse<T, E> error)? error,
  }) {
    return _map(
      data: (d) => data?.call(d),
      error: (d) => error?.call(d),
    );
  }
}

class RequestErrorResponse<T, E> implements RequestResponse<T, E> {
  const RequestErrorResponse(this.error, {this.stackTrace});
  final Object error;
  final StackTrace? stackTrace;

  @override
  R _map<R>({
    required R Function(RequestDataResponse<T, E> data) data,
    required R Function(RequestErrorResponse<T, E> error) error,
  }) {
    return error(this);
  }

  @override
  String toString() {
    return 'AsyncError<$T>(error: $error, stackTrace: $stackTrace)';
  }

  @override
  bool operator ==(Object other) {
    return runtimeType == other.runtimeType &&
        other is RequestErrorResponse<T, E> &&
        other.error == error &&
        other.stackTrace == stackTrace;
  }

  @override
  int get hashCode => Object.hash(runtimeType, error, stackTrace);
}
