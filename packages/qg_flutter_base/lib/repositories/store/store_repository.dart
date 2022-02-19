import 'package:qg_flutter_base/base/request_response.dart';

abstract class IStoreRepository {
  Future<RequestResponse<void>> create<T>({
    required String collectionId,
    required T item,
  });
  Future<RequestResponse<T?>> retrieve<T>({
    required String collectionId,
    required List<int> ids,
  });
  Future<RequestResponse<void>> update<T>({
    required String collectionId,
    required T item,
  });
  Future<RequestResponse<void>> delete<T>({
    required String collectionId,
    required int id,
  });
}
