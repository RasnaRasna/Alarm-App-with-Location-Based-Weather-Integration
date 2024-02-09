import 'package:alarm_weather_app/database/model_class.dart';

import 'package:alarm_weather_app/widgets/homepage.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest.dart' as tz;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Hive.registerAdapter(AlarmAdapter());
  await Hive.initFlutter();
  await Hive.openBox<Alarm>('alarms'); // Open a Hive box for storing alarms

  AwesomeNotifications().initialize(
    'resource://drawable/notification_icon',
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

// Check and request notification permission
  var notificationStatus = await Permission.notification.status;
  print('Notification Permission Status: $notificationStatus');

  if (notificationStatus.isDenied || notificationStatus.isPermanentlyDenied) {
    print('Requesting Notification Permission...');

    await Permission.notification.request();
  }

  // Check and request location permission
  var locationStatus = await Permission.location.status;
  print('Location Permission Status: $locationStatus');

  if (locationStatus.isDenied || locationStatus.isPermanentlyDenied) {
    print('Requesting Location Permission...');

    await Permission.location.request();
  }
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  // await initFcm();h
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Alarm App with Location-Based Weather Integration',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: MyHomePage(),
    );
  }
}
