import 'package:flutter/material.dart';
import 'package:qg_flutter_base/base/user/user_auth.dart';
import 'package:qg_flutter_base/base/user/user_settings.dart';

abstract class User<D, S extends UserSettings, A extends UserAuth> {
  @protected
  D? data;

  @protected
  S? settings;

  @protected
  A? auth;

  DateTime? lastUpdated;

  User({
    this.data,
    this.settings,
    this.auth,
  });
}
