import 'package:flutter/material.dart';
import 'package:qg_flutter_base/base/user/auth.dart';
import 'package:qg_flutter_base/base/user/settings.dart';

abstract class User<D, S extends UserSettings, A extends UserAuth> {
  @protected
  D? data;

  @protected
  S? settings;

  @protected
  A? auth;

  DateTime? lastUpdated;

  User({
    required this.data,
    required this.settings,
    required this.auth,
  });
}
