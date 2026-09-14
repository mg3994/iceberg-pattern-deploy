import 'dart:js_interop';
import 'dart:js_interop_unsafe';

import 'package:blogstore/firebase_web_config.dart';

@JS('importScripts')
external void importScripts(JSString script1, JSString script2);

@JS('firebase.initializeApp')
external JSObject initializeApp(JSObject options);

@JS('firebase.messaging')
external FirebaseMessaging messaging();

@JS('firebase.messaging.isSupported')
external JSPromise<JSBoolean> isSupported();

@JS('console.log')
external void consoleLog(JSAny? value);

@JS('self')
external JSObject get self;

@JS()
@staticInterop
class FirebaseMessaging {}

extension FirebaseMessagingExtension on FirebaseMessaging {
  external void onBackgroundMessage(JSFunction callback);

  external void setDeliveryMetricsExportedToBigQuery(bool enabled);
}

void main() {
  //
  // Firebase JS SDK
  //
  importScripts(
    'https://www.gstatic.com/firebasejs/10.7.0/firebase-app-compat.js'.toJS,
    'https://www.gstatic.com/firebasejs/10.7.0/firebase-messaging-compat.js'
        .toJS,
  );

  //
  // Service worker install
  //
  self.callMethod(
    'addEventListener'.toJS,
    'install'.toJS,
    ((JSObject event) {
      consoleLog(self);
      consoleLog(event);
    }).toJS,
  );

  //
  // Notification click
  //
  self.callMethod(
    'addEventListener'.toJS,
    'notificationclick'.toJS,
    ((JSObject event) {
      final notification = event.getProperty('notification'.toJS) as JSObject?;

      notification?.callMethod('close'.toJS);

      final clients = self.getProperty('clients'.toJS) as JSObject?;

      if (clients == null) {
        return;
      }

      final matchAllOptions = <String, JSAny?>{
        'type': 'window'.toJS,
        'includeUncontrolled': true.toJS,
      }.jsify();

      final matchAll = clients.callMethod(
        'matchAll'.toJS,
        matchAllOptions,
      ) as JSPromise<JSArray>;

      event.callMethod('waitUntil'.toJS, matchAll);

      matchAll.toDart.then((clientList) {
        final array = clientList as JSArray;
        for (final client in array.toDart) {
          final jsClient = client as JSObject;
          final focused = jsClient.getProperty('focused'.toJS) as JSBoolean?;

          if (focused?.toDart != true) {
            jsClient.callMethod('focus'.toJS);
            break;
          }
        }
      });
    }).toJS,
  );

  //
  // Firebase configuration
  //
  final options =
      <String, JSAny?>{
            'apiKey': FirebaseWebConfig.apiKey.toJS,
            'appId': FirebaseWebConfig.appId.toJS,
            'messagingSenderId': FirebaseWebConfig.messagingSenderId.toJS,
            'projectId': FirebaseWebConfig.projectId.toJS,
            'authDomain': FirebaseWebConfig.authDomain.toJS,
            'storageBucket': FirebaseWebConfig.storageBucket.toJS,
            'measurementId': FirebaseWebConfig.measurementId.toJS,
          }.jsify()
          as JSObject;

  initializeApp(options);

  //
  // Check browser support
  //
  isSupported().toDart.then((supported) {
    if (!supported.toDart) {
      return;
    }

    //
    // Firebase Messaging
    //
    final messagingInstance = messaging();

    messagingInstance.setDeliveryMetricsExportedToBigQuery(true);

    //
    // Background message
    //
    messagingInstance.onBackgroundMessage(
      ((JSAny? rawMessage) {
        if (rawMessage == null) {
          return;
        }

        final message = rawMessage as JSObject;

        final notification =
            message.getProperty('notification'.toJS) as JSObject?;

        if (notification == null) {
          return;
        }

        final title = notification.getProperty('title'.toJS) as JSString?;

        if (title == null || title.toDart.isEmpty) {
          return;
        }

        final body = notification.getProperty('body'.toJS) as JSString?;

        final image = notification.getProperty('image'.toJS) as JSString?;

        final icon = (image != null && image.toDart.isNotEmpty)
            ? image
            : '/icons/Icon-192.png'.toJS;

        final notificationOptions =
            <String, JSAny?>{'body': body, 'icon': icon}.jsify() as JSObject;

        final registration = self.getProperty('registration'.toJS) as JSObject?;

        registration?.callMethod(
          'showNotification'.toJS,
          title,
          notificationOptions,
        );
      }).toJS,
    );
  });
}
