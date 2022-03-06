import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:qg_flutter_base/repositories/base_repository.dart';
import 'package:qg_flutter_base/repositories/lifecycle/base_lifecycle_repository.dart';

final pLifecycleRepository = Provider<BaseLifecycleRepository>((ref) {
  final lifecycleRepository = LifecycleRepository(ref.read);
  ref.onDispose(() {
    lifecycleRepository.dispose();
  });
  return lifecycleRepository;
});

class LifecycleRepository extends BaseRepository
    implements BaseLifecycleRepository {
  LifecycleRepository(Reader read) : super(read);

  @override
  void onAppLifecycleStateChanged(AppLifecycleState _state) {
    _streamController.sink.add(_state);
  }

  final StreamController<AppLifecycleState> _streamController =
      StreamController<AppLifecycleState>();

  final Stopwatch _stopwatch = Stopwatch();

  Duration get _timeFromLastChange {
    final Duration _timeElapsed = _stopwatch.elapsed;
    _stopwatch.reset();
    _stopwatch.start();
    return _timeElapsed;
  }

  @override
  Stream<Duration> get detached => _streamController.stream
      .where((event) => event == AppLifecycleState.detached)
      .map((_) => _timeFromLastChange);

  @override
  Stream<Duration> get inactive => _streamController.stream
      .where((event) => event == AppLifecycleState.inactive)
      .map((_) => _timeFromLastChange);

  @override
  Stream<Duration> get paused => _streamController.stream
      .where((event) => event == AppLifecycleState.paused)
      .map((_) => _timeFromLastChange);

  @override
  Stream<Duration> get resumed => _streamController.stream
      .where((event) => event == AppLifecycleState.resumed)
      .map((_) => _timeFromLastChange);

  @override
  void dispose() {
    _streamController.close();
  }
}
