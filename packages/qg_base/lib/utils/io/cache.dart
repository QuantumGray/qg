import 'package:freezed_annotation/freezed_annotation.dart';

abstract class Cache {
  /// return null if local resource does not exist
  @protected
  T? retrieveLocal<T>(String id);

  /// fetch resource for when there is no local instance of it
  @protected
  T retrieveRemote<T>(String id);

  @nonVirtual
  T retrieve<T>(String id) {
    final T? _localResult = retrieveLocal<T>(id);
    if (_localResult == null) {
      return retrieveRemote<T>(id);
    }
    return _localResult;
  }
}
