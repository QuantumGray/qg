import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:qg_flutter_base/repositories/base_repository.dart';
import 'package:rxdart/rxdart.dart';

final Provider<NotificationRepository> pNotificationRepository =
    Provider<NotificationRepository>(
  (ref) => NotificationRepository(ref.read),
);

class NotificationRepository extends BaseRepository {
  NotificationRepository(Reader read) : super(read) {
    _foregroundMessageSubscription =
        FirebaseMessaging.onMessage.listen(onForegroundMessage);
    _messageOpenedAppSubscription =
        FirebaseMessaging.onMessageOpenedApp.listen(onMessageOpenedApp);
    FirebaseMessaging.onBackgroundMessage(onBackgroundMessage);
  }

  Stream<BaseNotification> get notificationStream => Rx.merge([]);

  // FCM TOKEN
  Future<String?> get fcmToken => messaging.getToken();

  // subscriptions for listenning to opened app and foreground message stream
  late StreamSubscription<RemoteMessage> _foregroundMessageSubscription;
  late StreamSubscription<RemoteMessage> _messageOpenedAppSubscription;

  // snack bar functionality
  final PublishSubject<SnackBar> _snackBarSubject = PublishSubject<SnackBar>();

  Stream<SnackBar> get snackBarStream => _snackBarSubject.stream;

  Future<void> pushSnackbar(
    SnackBar snackBar, {
    String? sound,
  }) async {
    _snackBarSubject.sink.add(snackBar);
  }

  // notification manager
  final List<BaseNotification> _notifications = [];

  List<BaseNotification> notificationsUntil(DateTime date) => _notifications
      .where((notification) => notification.time.isAfter(date))
      .toList();

  List<BaseNotification> get allNotifications => _notifications;

  List<BaseNotification> get readNotifications =>
      _notifications.where((notification) => notification.read).toList();

  List<BaseNotification> get unreadNotifications =>
      _notifications.where((notification) => !notification.read).toList();

  int get unreadNotificationsCount => unreadNotifications.length;

  // message callbacks
  void registerForegroundMessageHooks(
    List<ForegroundMessageCallback> callbacks,
  ) {
    _messageCallbacks.addAll(callbacks);
  }

  void registerBackgroundMessageHooks(
    List<BackgroundMessageCallback> callbacks,
  ) {
    _messageCallbacks.addAll(callbacks);
  }

  void registerAppOpenMessageHooks(List<AppOpenMessageCallback> callbacks) {
    _messageCallbacks.addAll(callbacks);
  }

  final List<MessageCallback> _messageCallbacks = [];

  List<ForegroundMessageCallback> get foregroundMessageCallbacks =>
      _messageCallbacks.whereType<ForegroundMessageCallback>().toList();

  List<BackgroundMessageCallback> get backgroundMessageCallbacks =>
      _messageCallbacks.whereType<BackgroundMessageCallback>().toList();

  List<AppOpenMessageCallback> get appOpenMessageCallbacks =>
      _messageCallbacks.whereType<AppOpenMessageCallback>().toList();

  void onForegroundMessage(RemoteMessage _message) {
    pushSnackbar(SnackBars.message(_message));
  }

  Future<void> onMessageOpenedApp(RemoteMessage _message) async {
    //_read(navigation)
  }

  FirebaseMessaging get messaging => FirebaseMessaging.instance;

  // pub/sub topics
  Future<void> subscribeToTopics(List<String> topics) async {
    for (final _topic in topics) {
      await messaging.subscribeToTopic(_topic);
    }
  }

  Future<void> unsubscribeFromTopics(List<String> topics) async {
    for (final _topic in topics) {
      await messaging.unsubscribeFromTopic(_topic);
    }
  }

  Future<void> storeFcmDeviceToken() async {
    if (Platform.isIOS) {
      final NotificationSettings _iosNotificationSetting =
          await messaging.requestPermission();
      if (_iosNotificationSetting.authorizationStatus !=
          AuthorizationStatus.authorized) {
        return;
      }
    }
    final token = await fcmToken;
    final tokenRef = FirebaseFirestore.instance
        .collection('users')
        .doc('uid')
        .collection('tokens')
        .doc(token);
    tokenRef.set({
      'token': token,
      'createdAt': FieldValue.serverTimestamp(),
      'platform': Platform.operatingSystem,
    });
  }

  void dispose() {
    _foregroundMessageSubscription.cancel();
    _messageOpenedAppSubscription.cancel();
    _snackBarSubject.close();
  }
}

Future<void> onBackgroundMessage(RemoteMessage _message) async {}

abstract class BaseNotification {
  bool read;
  final DateTime time;
  final RemoteMessage message;
  final String category;

  BaseNotification({
    this.read = false,
    required this.time,
    required this.message,
    required this.category,
  });

  String? get id => message.messageId;
  void markAsRead() => read = true;
  void markAsUnread() => read = false;
}

abstract class MessageCallback {
  MessageCallback(
    this.callback,
  );

  final void Function(RemoteMessage message) callback;
}

class ForegroundMessageCallback extends MessageCallback {
  ForegroundMessageCallback(void Function(RemoteMessage message) callback)
      : super(callback);
}

class BackgroundMessageCallback extends MessageCallback {
  BackgroundMessageCallback(void Function(RemoteMessage message) callback)
      : super(callback);
}

class AppOpenMessageCallback extends MessageCallback {
  AppOpenMessageCallback(void Function(RemoteMessage message) callback)
      : super(callback);
}

// ?
class SnackBarNotification extends BaseNotification {
  SnackBarNotification()
      : super(
          time: DateTime.now(),
          category: "",
          message: const RemoteMessage(),
        );
}

class Topics {
  static const String helloWorldTopic = 'campaigns';
}

// ignore: avoid_classes_with_only_static_members
class SnackBars {
  static const SnackBar helloWorld = SnackBar(content: Text("Hello World!"));

  static SnackBar simpleText(String text) => builder(contentText: text);

  static SnackBar builder({
    required String contentText,
    Color? backgroundColor,
    VoidCallback? onVisible,
    Duration? displayDuration,
    SnackBarAction? snackBarAction,
    Animation<double>? animation,
    TextStyle? contentTextStyle,
  }) {
    return SnackBar(
      content: Builder(
        builder: (context) => Text(
          contentText,
          style: contentTextStyle ??
              Theme.of(context)
                  .textTheme
                  .headline6
                  ?.copyWith(color: Colors.white),
        ),
      ),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      elevation: 8,
      backgroundColor: backgroundColor,
      duration: displayDuration ?? const Duration(seconds: 2),
      onVisible: onVisible,
      action: snackBarAction,
      animation: animation,
    );
  }

  static SnackBar message(
    RemoteMessage message,
  ) {
    final RemoteNotification? _notification = message.notification;

    return builder(
      contentText: _notification?.title ?? "",
    );
  }
}
