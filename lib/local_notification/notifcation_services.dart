// notification_permissions.dart
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> initializeNotifications() async {
  AwesomeNotifications().initialize(
    'resource://drawable/icon_notification',
    [
      NotificationChannel(
        channelKey: 'basic_channel',
        channelName: 'Basic notifications',
        channelDescription: 'Notification channel for basic notifications',
        defaultColor: Color(0xFF9D50DD),
        ledColor: Colors.white,
      ),
    ],
  );

  var notificationStatus = await Permission.notification.status;
  print('Notification Permission Status: $notificationStatus');

  if (notificationStatus.isDenied || notificationStatus.isPermanentlyDenied) {
    print('Requesting Notification Permission...');
    await Permission.notification.request();
  }
}
