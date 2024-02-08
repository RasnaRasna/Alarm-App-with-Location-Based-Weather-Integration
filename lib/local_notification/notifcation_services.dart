import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart'
    as tz; // Add this import for TZDateTime and tz.local

// class NotificationService {

//   // initializes an instance of FlutterLocalNotificationsPlugin, which will be used to interact with the notification plugin.
//   final FlutterLocalNotificationsPlugin notificationsPlugin =
//       FlutterLocalNotificationsPlugin();

//   Future<void> initNotification() async {
//     AndroidInitializationSettings androidInitializationSettings =
//         AndroidInitializationSettings("habit_tracker_logo");

//     var initialzationSettings = InitializationSettings(
//       android: androidInitializationSettings,
//     );
//     await notificationsPlugin.initialize(
//       initialzationSettings,
//       //used to handle user interactions with notifications.
//       onDidReceiveNotificationResponse:
//           (NotificationResponse notificationResponse) async {},
//     );
//   }

//   notificationDetails() {
//     return const NotificationDetails(
//         android: AndroidNotificationDetails('channelId', 'channelName'));
//   }

//   Future shownotification(
//       {int id = 0, String? title, String? body, String? payLoad}) async {
//     return notificationsPlugin.show(
//         id, title, body, await notificationDetails());
//   }

//   Future sheduleNotification(
//       {int id = 0,
//       String? title,
//       String? body,
//       String? payLoad,
//       required DateTime sheduleNotificationDateTime}) async {
//     // schedule the notification at the provided time,
//     return notificationsPlugin.zonedSchedule(
//         id,
//         title,
//         body,
//         tz.TZDateTime.from(
//           sheduleNotificationDateTime,
//           tz.local,
//         ),
//         await notificationDetails(),
//         uiLocalNotificationDateInterpretation:
//             UILocalNotificationDateInterpretation.absoluteTime);
//   }
// }
class NotificationService {
  final FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initNotification() async {
    AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings("habit_tracker_logo");

    var initialzationSettings = InitializationSettings(
      android: androidInitializationSettings,
    );
    await notificationsPlugin.initialize(
      initialzationSettings,
      onDidReceiveNotificationResponse:
          (NotificationResponse notificationResponse) async {},
    );
  }

  NotificationDetails notificationDetails() {
    return const NotificationDetails(
        android: AndroidNotificationDetails('channelId', 'channelName'));
  }

  Future<void> shownotification({
    int id = 0,
    String? title,
    String? body,
    String? payLoad,
  }) async {
    return notificationsPlugin.show(
      id,
      title,
      body,
      await notificationDetails(),
    );
  }

  Future<void> scheduleNotification({
    int id = 0,
    String? title,
    String? body,
    String? payLoad,
    required DateTime scheduleNotificationDateTime,
  }) async {
    // Check if the specified time is in the past
    if (scheduleNotificationDateTime.isBefore(DateTime.now())) {
      // You may choose to handle this case differently, e.g., show an error message.
      print('Cannot schedule a notification for the past.');
      return;
    }

    // Schedule the notification at the provided time
    return notificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(
        scheduleNotificationDateTime,
        tz.local,
      ),
      await notificationDetails(),
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }
}
