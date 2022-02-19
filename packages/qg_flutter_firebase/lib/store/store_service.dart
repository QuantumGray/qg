import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:qg_flutter_base/repositories/base_repository.dart';

final pStoreRepository =
    Provider<StoreRepository>((ref) => StoreRepository(ref.read));

class StoreRepository extends BaseRepository {
  StoreRepository(Reader read) : super(read) {
    // read(pAppUser.notifier)
    //     .addListener((user) => user != null ? storeUser(user) : null);
    // compute<AppUser?, void>(
    //     (appUser) async => _syncRoutine(appUser), read(pAppUser).state);
  }

  late StreamSubscription<QuerySnapshot> _eventSyncSubscription;
  late StreamSubscription<BoxEvent> _eventSyncHiveSubscription;

  final int _syncRoutineMinuteOffset = 15;

  T? getSingleObject<T>(String key) => key.box<T>().get(key);

  void setSingleObject<T>(String key, T value) => key.box<T>().put(key, value);

  FirebaseFirestore get _store => FirebaseFirestore.instance;

  Future<void> storeUser(dynamic user) async {
    await userRef.set(user.toJson());
  }

  Future<void> deleteUser() async {
    await userRef.delete();
  }

  DocumentReference get userRef => _store.doc('');

  // ignore: unused_element
  Future<void> _syncRoutine(dynamic appUser) async {
    // get firestore user and sync to local appUser
    if (appUser != null) {
      // _eventSyncSubscription =
      //     appUserref.snapshots().listen(_eventSnapshotMapper);
      //_hiveWatcher();
    }

    final syncTimestamp = _getSyncTimestamp();
    if (syncTimestamp != null &&
        syncTimestamp.difference(DateTime.now()).inMinutes <
            _syncRoutineMinuteOffset) {
      return;
    }
    // syncroutine

    _recordSyncTimestamp();
  }

  void _recordSyncTimestamp() {
    Hive.box<DateTime>(HiveBoxes.syncTimestamp).put('main', DateTime.now());
  }

  DateTime? _getSyncTimestamp() =>
      Hive.box<DateTime>(HiveBoxes.syncTimestamp).get('main');
}

// ignore: avoid_classes_with_only_static_members
class HiveBoxes {
  static String get user => 'user';
  static String get didSeeOnboarding => 'did-see-onboarding';
  static String get tabIndex => 'tab-index';

  // ?
  static String get syncTimestamp => 'sync-timestamp';
  static String get events => 'events';

  static Future<void> openAll() async {
    await Hive.openBox<Map<String, dynamic>>(HiveBoxes.user);
    await Hive.openBox<bool>(HiveBoxes.didSeeOnboarding);
    await Hive.openBox<int>(HiveBoxes.tabIndex);
  }
}

extension BoxString on String {
  Box<T> box<T>() => Hive.box(this);
  Future<void> openBox() => Hive.openBox(this);
}
