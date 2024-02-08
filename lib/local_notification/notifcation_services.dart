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
  // Create a static flag to check if the service has been initialized
  static bool _initialized = false;

  // initializes an instance of FlutterLocalNotificationsPlugin, which will be used to interact with the notification plugin.
  final FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // Ensure initialization only happens once
  Future<void> initNotification() async {
    if (!_initialized) {
      AndroidInitializationSettings androidInitializationSettings =
          AndroidInitializationSettings("notification_icon");

      var initializationSettings = InitializationSettings(
        android: androidInitializationSettings,
      );

      await notificationsPlugin.initialize(
        initializationSettings,
        //used to handle user interactions with notifications.
        onDidReceiveNotificationResponse:
            (NotificationResponse notificationResponse) async {},
      );

      _initialized = true; // Set the flag to true after initialization
    }
  }

  NotificationDetails notificationDetails() {
    return const NotificationDetails(
        android: AndroidNotificationDetails(
      'channelId',
      'channelName',
    ));
  }

  Future shownotification(
      {int id = 0, String? title, String? body, String? payLoad}) async {
    // Ensure the service has been initialized before showing notifications
    await initNotification();

    return notificationsPlugin.show(
        id, title, body, await notificationDetails());
  }

  Future sheduleNotification(
      {int id = 0,
      String? title,
      String? body,
      String? payLoad,
      required DateTime scheduleNotificationDateTime}) async {
    print(
        'Scheduled notification: $title, $body, $scheduleNotificationDateTime');

    // Ensure the service has been initialized before scheduling notifications
    await initNotification();

    // schedule the notification at the provided time,
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
            UILocalNotificationDateInterpretation.absoluteTime);
  }
}
