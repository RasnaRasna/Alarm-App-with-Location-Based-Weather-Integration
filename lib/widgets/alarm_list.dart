import 'package:alarm_weather_app/database/model_class.dart';
import 'package:alarm_weather_app/widgets/days.dart';
import 'package:alarm_weather_app/widgets/edit_alarm.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AlarmList extends StatelessWidget {
  final Alarm alarm;

  const AlarmList({super.key, required this.alarm});

  @override
  Widget build(BuildContext context) {
    print('Label: ${alarm.label}');
    print('Label in AlarmList: ${alarm.label}');

    final formattedTime =
        DateFormat('hh:mm a').format(alarm.time ?? DateTime.now());
    return SizedBox(
        height: 125,
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Card(
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (ctx) => EditAlarm(alarm: alarm,)),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(alarm.color),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: const Color.fromARGB(255, 150, 147, 147),
                      width: 1,
                    ),
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        top: 15,
                        left: 20,
                        child: Text(
                          alarm.label?.isNotEmpty ?? false
                              ? alarm.label!
                              : 'No Label',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 50,
                        left: 20,
                        child: Text(
                          formattedTime,
                          style: const TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 80,
                        left: 20,
                        child: Days(
                          days: [true, true, true, true, true, true, false],
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 5,
                          horizontal: 10,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 30,
                              ),
                              child: Icon(
                                Icons.toggle_off,
                                size: 40,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )));
  }
}
