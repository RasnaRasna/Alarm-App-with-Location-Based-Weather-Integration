import 'package:alarm_weather_app/database/model_class.dart';
import 'package:alarm_weather_app/widgets/days.dart';
import 'package:alarm_weather_app/widgets/edit_alarm.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AlarmList extends StatelessWidget {
  final Alarm alarm;
  final TimeOfDay? selectedTime; // Add selectedTime parameter

  const AlarmList({super.key, required this.alarm, this.selectedTime});

  @override
  Widget build(BuildContext context) {
    final formattedTime = selectedTime != null
        ? selectedTime!.format(context)
        : DateFormat('hh:mm a').format(alarm.time ?? DateTime.now());
    print('time in AlarmList: $selectedTime');

    return SizedBox(
        height: 125,
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Card(
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (ctx) => EditAlarm(
                        alarm: alarm,
                      ),
                    ),
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
                          days: alarm.selectedDays ?? List.filled(7, false),
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
