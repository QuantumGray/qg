import 'package:qg_flutter_base/base/request_response.dart';

abstract class BaseStoreRepository {
  Future<RequestResponse<void, Exception>> create<T>({
    required String collectionId,
    required T item,
  });
  Future<RequestResponse<T?, Exception>> read<T>({
    required String collectionId,
    required List<int> ids,
  });
  Future<RequestResponse<void, Exception>> update<T>({
    required String collectionId,
    required T item,
  });
  Future<RequestResponse<void, Exception>> delete<T>({
    required String collectionId,
    required int id,
  });
}
