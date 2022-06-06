// ignore_for_file: avoid_classes_with_only_static_members

import 'dart:async';
import 'dart:core';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:qg_flutter_base/repositories/base_repository.dart';
import 'package:rxdart/rxdart.dart';

final Provider<AnalyticsRepository> pAnalyticsRepository =
    Provider<AnalyticsRepository>((ref) => AnalyticsRepository(ref.read));

class AnalyticsRepository extends BaseRepository {
  AnalyticsRepository(Reader read) : super(read) {
    _analyticsEventSubscription =
        _analyticsEventQueue.stream.listen(_dispatchEvent);
  }

  late StreamSubscription<AnalyticsEvent> _analyticsEventSubscription;

  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  final BehaviorSubject<AnalyticsEvent> _analyticsEventQueue =
      BehaviorSubject<AnalyticsEvent>();

  Future<void> initUser(String signUpMethod, String id) async {
    await _analytics.logSignUp(signUpMethod: signUpMethod);
    await _analytics.setUserId(id: id);
  }

  Future<void> removeUser() async {
    await _analytics.setUserId();
  }

  Future<void> setUserProperty(String name, String value) async {
    await _analytics.setUserProperty(name: name, value: value);
  }

  Future<void> removeUserProperty(String name) async {
    await _analytics.setUserProperty(name: name, value: null);
  }

  Future<void> logShare({
    required String contentType,
    required String itemId,
    required String method,
  }) async {
    await _analytics.logShare(
      contentType: contentType,
      itemId: itemId,
      method: method,
    );
  }

  Future<void> _dispatchEvent(AnalyticsEvent event) async {
    await _analytics.logEvent(name: event.name, parameters: event.parameters);
  }

  void logEvent(AnalyticsEvent event) {
    _analyticsEventQueue.sink.add(event);
  }

  Future<void> setPage(Page page) async {
    _analytics.setCurrentScreen(screenName: page.toString());
  }

  final Map<String, Stopwatch> _timeEvents = <String, Stopwatch>{};

  void startTimeEvent(String event) {
    _timeEvents[event] = Stopwatch()..start();
  }

  void stopTimeEvent(String event) {
    logEvent(
      AnalyticsEvent(
        name: event,
        parameters: {
          'timeElapsed': _timeEvents[event]?.elapsed ?? 'empty',
        },
      ),
    );
    _timeEvents[event]?.reset();
  }

  void dispose() {
    _analyticsEventSubscription.cancel();
    _analyticsEventQueue.close();
  }
}

class AnalyticsEvents {
  static const appStart = AnalyticsEvent(name: 'appStart');

  static AnalyticsEvent trackScreenTime(Duration duration, String screen) =>
      AnalyticsEvent(
        name: 'screenTime',
        parameters: {
          'screen': screen,
          'duration': duration.inSeconds,
        },
      );
}

class AnalyticsEvent {
  const AnalyticsEvent({
    required this.name,
    this.parameters,
  });

  final String name;
  final Map<String, Object?>? parameters;
}
