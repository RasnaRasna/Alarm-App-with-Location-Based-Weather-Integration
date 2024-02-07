import 'package:alarm_weather_app/database/model_class.dart';
import 'package:alarm_weather_app/widgets/add_Alarm.dart';
import 'package:alarm_weather_app/widgets/alarm_list.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: WatchBoxBuilder(
        box: Hive.box('alarms'),
        builder: (context, box) {
          return ListView.builder(
            itemCount: box.length,
            itemBuilder: (context, index) {
              final alarm = box.getAt(index) as Alarm;

              return AlarmList(alarm: alarm);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (ctx) => AddAlarm()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
