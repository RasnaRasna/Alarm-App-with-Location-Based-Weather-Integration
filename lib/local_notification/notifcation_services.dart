// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:timezone/data/latest.dart' as tz;
// import 'package:timezone/timezone.dart'
//     as tz; // Add this import for TZDateTime and tz.local

// class NotificationService {
//   // Create a static flag to check if the service has been initialized
//   static bool _initialized = false;
//   static final _notifications = FlutterLocalNotificationsPlugin();
//   // initializes an instance of FlutterLocalNotificationsPlugin, which will be used to interact with the notification plugin.
//   final FlutterLocalNotificationsPlugin notificationsPlugin =
//       FlutterLocalNotificationsPlugin();

//   // Ensure initialization only happens once
//   Future<void> initNotification() async {
//     if (!_initialized) {
//       AndroidInitializationSettings androidInitializationSettings =
//           AndroidInitializationSettings("notification_icon");

//       var initializationSettings = InitializationSettings(
//         android: androidInitializationSettings,
//       );

//       await notificationsPlugin.initialize(
//         initializationSettings,
//         //used to handle user interactions with notifications.
//         onDidReceiveNotificationResponse:
//             (NotificationResponse notificationResponse) async {},
//       );

//       _initialized = true; // Set the flag to true after initialization
//     }
//   }

//   static Future _notificationDetails() async {
//     return NotificationDetails(
//         android: AndroidNotificationDetails(
//       'channelId',
//       'channelName',
//       importance: Importance.max,
//     ));
//   }

//   /// without select the time JUST TAP THE BUTTON THE NOTFICATION WILL DISPLAY
//   static Future Shownotification(
//           {int id = 0, String? title, String? body, String? payLoad}) async =>
//       _notifications.show(id, title, body, await _notificationDetails(),
//           payload: payLoad);

// //// schedule with spesific time
//   ///  // schedule the notification at the provided time,

//   static void sheduleNotification({
//     int id = 0,
//     String? title,
//     String? body,
//     String? payLoad,
//     required DateTime scheduleNotificationDateTime,
//   }) async {
//     print('Scheduled Time: $scheduleNotificationDateTime');
//     print('Notification Details: ${await _notificationDetails()}');

//     _notifications.zonedSchedule(
//       id,
//       title,
//       body,
//       tz.TZDateTime.from(
//         scheduleNotificationDateTime,
//         tz.local,
//       ),
//       await _notificationDetails(),
//       payload: payLoad,
//       androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
//       uiLocalNotificationDateInterpretation:
//           UILocalNotificationDateInterpretation.absoluteTime,
//     );
//   }
// }

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationHelper {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    // Initialization for Android
    var androidInitializationSettings =
        AndroidInitializationSettings('notification_icon');
    var initializationSettings = InitializationSettings(
      android: androidInitializationSettings,
    );

    flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );

    // Load the time zone data
    tz.initializeTimeZones();
  }

  Future<void> onSelectNotification(String? payload) async {
    // Handle notification tap event
    print('Notification tapped with payload: $payload');
  }

  Future<void> scheduleNotification() async {
    print('Scheduling notification...');

    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'your_channel_id',
      'your_channel_name',
      importance: Importance.high,
      priority: Priority.high,
    );

    var platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    DateTime scheduledTime = DateTime.now().add(Duration(minutes: 5));

    await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      'Scheduled Notification',
      'This is a scheduled notification local',
      tz.TZDateTime.from(scheduledTime, tz.local),
      platformChannelSpecifics,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
      payload:
          'custom_payload', // Optional, you can use this to identify the notification
    );
  }
}
