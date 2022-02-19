// import 'package:isar/isar.dart';

// abstract class IStoreRepository {
//   Future<void> create<T>({required String collectionId, required T item});
//   Future<List<T?>> retrieve<T>({
//     required String collectionId,
//     required List<int> ids,
//   });
//   Future<void> update<T>({required String collectionId, required T item});
//   Future<void> delete<T>({required String collectionId, required int id});
// }

// class IsarRepository implements IStoreRepository {
//   late final Isar _isar;

//   Future<void> setup() async {
//     _isar = Object() as Isar;
//   }

//   Future<void> isarAction({
//     required void Function(Isar isar) isarAction,
//   }) async {
//     isarAction(_isar);
//   }

//   Future<List<T>> query<T>({
//     required String collectionId,
//     required Future<List<T>> Function(IsarCollection<T> collection)
//         queryBuilder,
//   }) async {
//     return queryBuilder(_isar.getCollection<T>(collectionId));
//   }

//   Stream<List<T>> watch<T>({
//     required String collectionId,
//     required Future<List<T>> Function(IsarCollection<T> collection)
//         queryBuilder,
//   }) {
//     return _isar
//         .getCollection<T>(collectionId)
//         .where()
//         .build()
//         .watch(initialReturn: true);
//   }

//   @override
//   Future<void> create<T>({
//     required String collectionId,
//     required T item,
//   }) async {
//     await _isar.getCollection<T>(collectionId).put(item);
//   }

//   @override
//   Future<void> delete<T>({
//     required String collectionId,
//     required int id,
//   }) async {
//     await _isar.getCollection<T>(collectionId).delete(id);
//   }

//   @override
//   Future<List<T?>> retrieve<T>({
//     required String collectionId,
//     required List<int> ids,
//   }) async {
//     return _isar.getCollection<T>(collectionId).getAll(ids);
//   }

//   @override
//   Future<void> update<T>({
//     required String collectionId,
//     required T item,
//   }) async {
//     await _isar.getCollection<T>(collectionId).put(item);
//   }
// }

// /*
//   implement cache

//   - hashmap
//   - store after fetch


//   - file system cache
//   - db cache

//   - local and remote repository implementing repository interface and have single repository interface that interacts with both remote and local and connectivity service

//   - override hashcode
// */
