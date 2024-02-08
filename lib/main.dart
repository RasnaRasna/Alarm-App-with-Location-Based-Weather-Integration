import 'package:alarm_weather_app/database/model_class.dart';
import 'package:alarm_weather_app/local_notification/notifcation_services.dart';

import 'package:alarm_weather_app/widgets/homepage.dart';
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
  NotificationService().initNotification();
  var status = await Permission.ignoreBatteryOptimizations.status;
  if (status.isDenied || status.isPermanentlyDenied) {
    await Permission.ignoreBatteryOptimizations.request();
  }

// Check and request notification permission
  var notificationStatus = await Permission.notification.status;
  if (notificationStatus.isDenied || notificationStatus.isPermanentlyDenied) {
    await Permission.notification.request();
  }

  // Check and request location permission
  var locationStatus = await Permission.location.status;
  if (locationStatus.isDenied || locationStatus.isPermanentlyDenied) {
    await Permission.location.request();
  }

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  tz.initializeTimeZones();

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
