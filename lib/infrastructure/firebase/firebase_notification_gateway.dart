import 'package:firebase_messaging/firebase_messaging.dart';

import '../../core/notifications/notification_gateway.dart'
    show NotificationGateway;

final class FirebaseNotificationGateway implements NotificationGateway {
  const FirebaseNotificationGateway(
    this._messaging, {
    this.vapidKey,
    this.serviceWorkerScriptPath,
  });

  final FirebaseMessaging _messaging;
  final String? vapidKey;
  final String? serviceWorkerScriptPath;

  @override
  Future<bool> isSupported() => _messaging.isSupported();
  static const _unsupportedSettings = NotificationSettings(
    authorizationStatus: AuthorizationStatus.notDetermined,
    alert: AppleNotificationSetting.notSupported,
    announcement: AppleNotificationSetting.notSupported,
    badge: AppleNotificationSetting.notSupported,
    carPlay: AppleNotificationSetting.notSupported,
    lockScreen: AppleNotificationSetting.notSupported,
    notificationCenter: AppleNotificationSetting.notSupported,
    showPreviews: AppleShowPreviewSetting.notSupported,
    timeSensitive: AppleNotificationSetting.notSupported,
    criticalAlert: AppleNotificationSetting.notSupported,
    sound: AppleNotificationSetting.notSupported,
    providesAppNotificationSettings: AppleNotificationSetting.notSupported,
  );
  @override
  Future<NotificationSettings> requestPermission({
    bool alert = true,
    bool announcement = false,
    bool badge = true,
    bool carPlay = false,
    bool criticalAlert = false,
    bool provisional = false,
    bool sound = true,
    bool providesAppNotificationSettings = false,
  }) async {
    if (!await isSupported()) {
      return _unsupportedSettings;
    }

    return _messaging.requestPermission(
      alert: alert,
      announcement: announcement,
      badge: badge,
      carPlay: carPlay,
      criticalAlert: criticalAlert,
      provisional: provisional,
      sound: sound,
      providesAppNotificationSettings: providesAppNotificationSettings,
    );
  }

  @override
  Future<NotificationSettings> getNotificationSettings() async {
    if (!await isSupported()) {
      return _unsupportedSettings;
    }
    return _messaging.getNotificationSettings();
  }

  @override
  Future<String?> getToken({
    String? vapidKey,
    String? serviceWorkerScriptPath,
  }) async {
    if (!await isSupported()) return null;

    try {
      return await _messaging.getToken(
        vapidKey: vapidKey ?? this.vapidKey,
        serviceWorkerScriptPath:
            serviceWorkerScriptPath ?? this.serviceWorkerScriptPath,
      );
    } catch (_) {
      return null;
    }
  }

  @override
  Future<String?> getAPNSToken() async {
    if (!await isSupported()) return null;
    return _messaging.getAPNSToken();
  }

  @override
  Stream<String> get tokenChanges async* {
    if (!await isSupported()) return;

    final token = await getToken();
    if (token != null) yield token;

    yield* _messaging.onTokenRefresh;
  }

  @override
  Future<void> deleteToken() async {
    if (!await isSupported()) return;
    await _messaging.deleteToken();
  }

  @override
  Stream<RemoteMessage> get onForegroundMessage => FirebaseMessaging.onMessage;

  @override
  Stream<RemoteMessage> get onNotificationOpened =>
      FirebaseMessaging.onMessageOpenedApp;

  @override
  Future<RemoteMessage?> getInitialMessage() async {
    if (!await isSupported()) return null;
    return _messaging.getInitialMessage();
  }

  @override
  bool get isAutoInitEnabled => _messaging.isAutoInitEnabled;

  @override
  Future<void> setAutoInitEnabled(bool enabled) async {
    if (!await isSupported()) return;
    await _messaging.setAutoInitEnabled(enabled);
  }

  @override
  Future<void> setDeliveryMetricsExportToBigQuery(bool enabled) async {
    if (!await isSupported()) return;
    await _messaging.setDeliveryMetricsExportToBigQuery(enabled);
  }

  @override
  Future<void> subscribeToTopic(String topic) async {
    if (!await isSupported()) return;
    // _assertTopicName(topic);
    await _messaging.subscribeToTopic(topic);
  }

  @override
  Future<void> unsubscribeFromTopic(String topic) async {
    if (!await isSupported()) return;
    // _assertTopicName(topic);
    await _messaging.unsubscribeFromTopic(topic);
  }

  @override
  Future<void> setForegroundPresentationOptions({
    bool alert = false,
    bool badge = false,
    bool sound = false,
  }) async {
    if (!await isSupported()) return;

    await _messaging.setForegroundNotificationPresentationOptions(
      alert: alert,
      badge: badge,
      sound: sound,
    );
  }

  @override
  Future<void> registerBackgroundHandler(
    BackgroundMessageHandler handler,
  ) async {
    if (!await isSupported()) return;
    FirebaseMessaging.onBackgroundMessage(handler);
  }
}

// void _assertTopicName(String topic) {
//   // todo make if valid or not
//   bool isValidTopic = RegExp(r'^[a-zA-Z0-9-_.~%]{1,900}$').hasMatch(topic);
//   assert(isValidTopic);
// }
