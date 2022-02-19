import 'package:googleapis/fcm/v1.dart';
import 'package:qg_base/qg_base.dart' hide Notification;
import 'package:qg_base/utils/io/async_response.dart';
import 'package:qg_server_starter/env.dart';

final pFCM = Provider<FCM>((ref) => FCM(ref.read));

class FCM {
  final Reader read;
  FCM(this.read);

  FirebaseCloudMessagingApi? __messaging;

  ProjectsMessagesResource get _messaging =>
      (__messaging ??= FirebaseCloudMessagingApi(read(pGapiAuthClient)))
          .projects
          .messages;

  ApnsConfig get _apnsConfig => ApnsConfig();
  AndroidConfig get _androidConfig => AndroidConfig();
  WebpushConfig get _webpushConfig => WebpushConfig();
  FcmOptions get _fcmOptions => FcmOptions(
        analyticsLabel: 'analytics_label',
      );

  Future<AsyncResponse<Message>> send(
    String? fcmToken,
    String? topic,
    Map<String, String>? data,
    String? condition,
    Notification? notification,
  ) =>
      AsyncResponse.guard(
        () async {
          final name = '';

          final message = Message(
            apns: _apnsConfig,
            android: _androidConfig,
            webpush: _webpushConfig,
            condition: condition,
            data: data,
            fcmOptions: _fcmOptions,
            name: name,
            notification: notification,
            token: fcmToken,
            topic: topic,
          );

          Message()
            ..token = fcmToken
            ..android = _androidConfig
            ..apns = _apnsConfig
            ..webpush = _webpushConfig;

          final sendRequestMessage = SendMessageRequest()
            ..message = message
            ..validateOnly = read(pRuntimeConfig).debug;

          return await _messaging.send(
            sendRequestMessage,
            read(pEnv).gcpProjectId,
            $fields: '*',
          );
        },
      );
}
