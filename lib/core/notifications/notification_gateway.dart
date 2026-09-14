import 'package:firebase_messaging/firebase_messaging.dart';

// typedef BackgroundMessageHandler = Future<void> Function(RemoteMessage message);

abstract interface class NotificationGateway {
  const NotificationGateway();
  Future<bool> isSupported();

  Future<NotificationSettings> requestPermission({
    bool alert = true,
    bool announcement = false,
    bool badge = true,
    bool carPlay = false,
    bool criticalAlert = false,
    bool provisional = false,
    bool sound = true,
    bool providesAppNotificationSettings = false,
  });

  Future<NotificationSettings> getNotificationSettings();

  Future<String?> getToken({String? vapidKey, String? serviceWorkerScriptPath});

  Future<String?> getAPNSToken();

  Stream<String> get tokenChanges;

  Future<void> deleteToken();

  Stream<RemoteMessage> get onForegroundMessage;

  Stream<RemoteMessage> get onNotificationOpened;

  Future<RemoteMessage?> getInitialMessage();

  bool get isAutoInitEnabled;

  Future<void> setAutoInitEnabled(bool enabled);

  Future<void> setDeliveryMetricsExportToBigQuery(bool enabled);

  Future<void> subscribeToTopic(String topic);

  Future<void> unsubscribeFromTopic(String topic);

  Future<void> setForegroundPresentationOptions({
    bool alert = false,
    bool badge = false,
    bool sound = false,
  });

  Future<void> registerBackgroundHandler(BackgroundMessageHandler handler);
}
