import 'dart:async';

import 'package:app_movil_dincydet/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

Future registerFirebase() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  // 3. On iOS, this helps to take the user permissions
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    badge: true,
    provisional: false,
    sound: true,
  );

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  if (settings.authorizationStatus != AuthorizationStatus.authorized) {
    print('User declined or has not accepted permission');
  }
  //FirebaseMessaging.onBackgroundMessage((message) => null)
}

@pragma('vm:entry-point') //REVIEW: Possible solution
Future<void> onBackGroundMessage(RemoteMessage message) async {
  await Firebase.initializeApp();
  if (message.data.containsKey('data')) {
    final data = message.data['data'];
  }
  if (message.data.containsKey('notification')) {
    final notification = message.data['notification'];
  }
  print(message.notification?.android?.channelId);
}

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class FCM {
  final _firebaseMessaging = FirebaseMessaging.instance;

  Future<String?> getToken() {
    return _firebaseMessaging.getToken();
  }

  void setNotifications() {
    FirebaseMessaging.onBackgroundMessage(onBackGroundMessage);
    FirebaseMessaging.onMessage.listen((message) async {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      print('Recived notification');
      if (notification != null && android != null) {
        print('Local notification');
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              android.channelId ?? 'General',
              'Notificaciones Generales',
              icon: "@mipmap/ic_launcher",
              importance: Importance.max,
              playSound: true,
              sound: RawResourceAndroidNotificationSound(android.sound),
            ),
          ),
        );
        print('Notification completion');
      }
    });
    final token =
        _firebaseMessaging.getToken().then((value) => print('Token: $value'));
  }

  dispose() {
    // streamCtlr.close();
    // bodyCtlr.close();
    // titleCtlr.close();
  }
}

// Channels
const AndroidNotificationChannel alertChannel = AndroidNotificationChannel(
  'alert_channel',
  'Notificaciones de alerta',
  sound: RawResourceAndroidNotificationSound('otro'),
  importance: Importance.max,
  playSound: true,
);
const AndroidNotificationChannel alertIncendio = AndroidNotificationChannel(
  'incendio_channel',
  'Notificaciones de incendios',
  sound: RawResourceAndroidNotificationSound('incendio'),
  importance: Importance.max,
  playSound: true,
);
const AndroidNotificationChannel alertSimulacro = AndroidNotificationChannel(
  'simulacro_channel',
  'Notificaciones de sismos',
  sound: RawResourceAndroidNotificationSound('sismo'),
  importance: Importance.max,
  playSound: true,
);
const AndroidNotificationChannel alertTerremoto = AndroidNotificationChannel(
  'terremoto_channel',
  'Notificaciones de terremotos',
  sound: RawResourceAndroidNotificationSound('terremoto'),
  importance: Importance.max,
  playSound: true,
);
const AndroidNotificationChannel ticketChannel = AndroidNotificationChannel(
  'ticket_channel',
  'Notificaciones de tickets',
  sound: RawResourceAndroidNotificationSound('message'),
  importance: Importance.max,
  playSound: true,
);

const AndroidNotificationChannel callChannel = AndroidNotificationChannel(
  'call_channel',
  'Notificaciones de llamadas',
  sound: RawResourceAndroidNotificationSound('llamada'),
  importance: Importance.max,
  playSound: true,
);

Future<void> createNotificationChannel(
    AndroidNotificationChannel channel) async {
  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
}
