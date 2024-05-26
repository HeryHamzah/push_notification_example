import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:push_notification_example/main.dart';
import 'package:push_notification_example/message_page.dart';

class PushNotification {
  static final _firebaseMessaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin
      _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: false,
      criticalAlert: true,
      provisional: false,
      sound: true,
    );

    final token = await _firebaseMessaging.getToken();
    print("Device token: $token");
  }

  static Future<void> localNotifInit() async {
    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final DarwinInitializationSettings darwinInitializationSettings =
        DarwinInitializationSettings(
      onDidReceiveLocalNotification: (id, title, body, payload) {},
    );

    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: androidInitializationSettings,
            iOS: darwinInitializationSettings);

    //request notifiction for android 13 or above
    _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()!
        .requestNotificationsPermission();

    _flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveBackgroundNotificationResponse: onNotificationTap,
        onDidReceiveNotificationResponse: onNotificationTap);

    //on tap local notification
  }

  //on tap notification foreground
  static void onNotificationTap(NotificationResponse notificationResponse) {
    navigatorKey.currentState!.push(MaterialPageRoute(
      builder: (context) =>
          MessagePage(message: jsonDecode(notificationResponse.payload ?? "")),
    ));
  }

  static Future showSimpleNotification({
    required String title,
    required String body,
    required String payload,
  }) async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails("channelId", "channelName",
            channelDescription: "desc",
            priority: Priority.high,
            importance: Importance.max,
            ticker: 'ticker');

    const DarwinNotificationDetails darwinNotificationDetails =
        DarwinNotificationDetails(
      presentAlert:
          true, // Present an alert when the notification is displayed and the application is in the foreground (only from iOS 10 onwards)
      presentBadge:
          true, // Present the badge number when the notification is displayed and the application is in the foreground (only from iOS 10 onwards)
      presentSound:
          true, // Play a sound when the notification is displayed and the application is in the foreground (only from iOS 10 onwards)
    );

    const NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails, iOS: darwinNotificationDetails);

    await _flutterLocalNotificationsPlugin
        .show(0, title, body, notificationDetails, payload: payload);
  }
}
