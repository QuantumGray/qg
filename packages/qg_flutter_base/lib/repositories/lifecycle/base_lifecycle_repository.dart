import 'package:flutter/material.dart';

abstract class BaseLifecycleRepository {
  void onAppLifecycleStateChanged(AppLifecycleState _state);
  void dispose();
  Stream<Duration> get detached;
  Stream<Duration> get inactive;
  Stream<Duration> get paused;
  Stream<Duration> get resumed;
}
