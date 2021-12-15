// import 'package:flutter/material.dart';
// import 'package:hive/hive.dart';
// import 'package:qg_flutter_base/src/base/auth/auth.dart';

// abstract class User<D, S, A extends Auth> {
//   @protected
//   D? userData;
//   // final Map Function(D data) dataToJson;
//   // final D Function(Map json) dataFromJson;

//   @protected
//   S? userSettings;

//   @protected
//   A? userAuth;

//   final String? storageKey;
//   String get key => storageKey ?? 'user';

//   User({
//     required this.userData,
//     required this.userSettings,
//     required this.userAuth,
//     this.storageKey,
//   });

//   D? get data => userData;

//   void set data(D? data) {
//     userData = data;
//     _store();
//   }

//   S? get settings => userSettings;

//   void set settings(S? settings) {
//     userSettings = settings;
//     _store();
//   }

//   A? get auth => userAuth;

//   void set auth(A? auth) {
//     userAuth = auth;
//     _store();
//   }

//   late Box<User<D, S, A>> _box;

//   Map<String, dynamic> toJson(User<D, S, A> user);

//   User<D, S, A> fromJson(Map<String, dynamic> json);

//   Future<void> _initBox() async {
//     if (!Hive.isBoxOpen(key)) {
//       _box = await Hive.openBox<User<D, S, A>>(key);
//     }
//   }

//   Future<User<D, S, A>> _store() async {
//     await _initBox();
//     _box.put(key, this);
//     return this;
//   }
// }
