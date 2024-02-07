import 'package:alarm_weather_app/database/model_class.dart';
import 'package:alarm_weather_app/widgets/add_Alarm.dart';
import 'package:alarm_weather_app/widgets/alarm_list.dart';
import 'package:alarm_weather_app/widgets/homepage.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Hive.registerAdapter(AlarmAdapter());
  await Hive.initFlutter();
  await Hive.openBox<Alarm>('alarms'); // Open a Hive box for storing alarms

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
