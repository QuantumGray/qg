import 'package:qg_flutter_base/base/async_response.dart';

abstract class IStoreRepository {
  Future<AsyncResponse<void>> create<T>({
    required String collectionId,
    required T item,
  });
  Future<AsyncResponse<T?>> retrieve<T>({
    required String collectionId,
    required List<int> ids,
  });
  Future<AsyncResponse<void>> update<T>({
    required String collectionId,
    required T item,
  });
  Future<AsyncResponse<void>> delete<T>({
    required String collectionId,
    required int id,
  });
}
