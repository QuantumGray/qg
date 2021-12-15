import 'dart:async';

import 'package:flutter/material.dart';

Future<dynamic> runMain(
  Widget app, {
  void Function(FlutterErrorDetails)? onFlutterError,
  required void Function(Object, StackTrace) onError,
}) async {
  FlutterError.onError = onFlutterError;
  runZonedGuarded(() => runApp(app), onError);
}
