// ignore: depend_on_referenced_packages
import 'package:isar/isar.dart';
import 'package:qg_flutter_base/base/async_response.dart';
import 'package:qg_flutter_base/presentation/presentation.dart';
import 'package:qg_flutter_base/repositories/store/store_repository.dart';

class IsarRepository implements IStoreRepository {
  late final Isar _isar;

  final Future<Isar> Function() openIsar;

  IsarRepository(this.openIsar);

  Future<void> setup() async {
    _isar = await openIsar();
  }

  Future<void> isarAction({
    required void Function(Isar isar) isarAction,
  }) async {
    isarAction(_isar);
  }

  Future<List<T>> query<T>({
    required String collectionId,
    required Future<List<T>> Function(IsarCollection<T> collection)
        queryBuilder,
  }) async {
    return queryBuilder(_isar.getCollection<T>(collectionId));
  }

  Stream<List<T>> watch<T>({
    required String collectionId,
    required QueryBuilder<T> Function(IsarCollection<T> collection)
        queryBuilder,
  }) {
    return _isar
        .getCollection<T>(collectionId)
        .where()
        .build()
        .watch(initialReturn: true);
  }

  @override
  Future<AsyncResponse<void>> create<T>({
    required String collectionId,
    required T item,
  }) async {
    try {
      await _isar.getCollection<T>(collectionId).put(item);
      return const AsyncResponse.data(null);
    } catch (e) {
      return AsyncResponse.error(e);
    }
  }

  @override
  Future<AsyncResponse<void>> delete<T>({
    required String collectionId,
    required int id,
  }) async {
    try {
      await _isar.getCollection<T>(collectionId).delete(id);
      return const AsyncResponse.data(null);
    } catch (e) {
      return AsyncResponse.error(e);
    }
  }

  @override
  Future<AsyncResponse<T?>> retrieve<T>({
    required String collectionId,
    required List<int> ids,
  }) async {
    try {
      late T? data;
      final collection = _isar.getCollection<T>(collectionId);
      if (T is Iterable) {
        data = await collection.getAll(ids) as T;
      }
      assert(ids.isNotEmpty);
      data = await collection.get(ids.first);
      return AsyncResponse.data(data);
    } catch (e) {
      return AsyncResponse.error(e);
    }
  }

  @override
  Future<AsyncResponse<void>> update<T>({
    required String collectionId,
    required T item,
  }) async {
    try {
      await _isar.getCollection<T>(collectionId).put(item);
      return const AsyncResponse.data(null);
    } catch (e) {
      return AsyncResponse.error(e);
    }
  }
}
