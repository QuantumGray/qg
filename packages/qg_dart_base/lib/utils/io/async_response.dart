import 'package:meta/meta.dart';

export 'async_response.dart';

String? modifierName(String? from, String modifier) {
  return from == null ? null : '$from.$modifier';
}

@sealed
@immutable
abstract class AsyncResponse<T> {
  const factory AsyncResponse.data(T value) = AsyncDataResponse<T>;
  const factory AsyncResponse.error(Object error, {StackTrace? stackTrace}) =
      AsyncErrorResponse<T>;

  static Future<AsyncResponse<T>> guard<T>(Future<T> Function() future) async {
    try {
      return AsyncResponse.data(await future());
    } catch (err, stack) {
      return AsyncResponse.error(err, stackTrace: stack);
    }
  }

  R _map<R>({
    required R Function(AsyncDataResponse<T> data) data,
    required R Function(AsyncErrorResponse<T> error) error,
  });
}

class AsyncDataResponse<T> implements AsyncResponse<T> {
  const AsyncDataResponse(this.value);

  final T value;

  @override
  R _map<R>({
    required R Function(AsyncDataResponse<T> data) data,
    required R Function(AsyncErrorResponse<T> error) error,
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
        other is AsyncDataResponse<T> &&
        other.value == value;
  }

  @override
  int get hashCode => Object.hash(runtimeType, value);
}

extension AsyncResponseX<T> on AsyncResponse<T> {
  @Deprecated('use `asData` instead')
  AsyncDataResponse<T>? get data => asData;

  AsyncDataResponse<T>? get asData {
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

  AsyncResponse<R> whenData<R>(R Function(T value) cb) {
    return _map(
      data: (d) {
        try {
          return AsyncResponse.data(cb(d.value));
        } catch (err, stack) {
          return AsyncResponse.error(err, stackTrace: stack);
        }
      },
      error: (e) => AsyncErrorResponse(e.error, stackTrace: e.stackTrace),
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
    required R Function(AsyncDataResponse<T> data) data,
    required R Function(AsyncErrorResponse<T> error) error,
  }) {
    return _map(
      data: data,
      error: error,
    );
  }

  R maybeMap<R>({
    R Function(AsyncDataResponse<T> data)? data,
    R Function(AsyncErrorResponse<T> error)? error,
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
    R Function(AsyncDataResponse<T> data)? data,
    R Function(AsyncErrorResponse<T> error)? error,
  }) {
    return _map(
      data: (d) => data?.call(d),
      error: (d) => error?.call(d),
    );
  }
}

class AsyncErrorResponse<T> implements AsyncResponse<T> {
  const AsyncErrorResponse(this.error, {this.stackTrace});
  final Object error;
  final StackTrace? stackTrace;

  @override
  R _map<R>({
    required R Function(AsyncDataResponse<T> data) data,
    required R Function(AsyncErrorResponse<T> error) error,
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
        other is AsyncErrorResponse<T> &&
        other.error == error &&
        other.stackTrace == stackTrace;
  }

  @override
  int get hashCode => Object.hash(runtimeType, error, stackTrace);
}
