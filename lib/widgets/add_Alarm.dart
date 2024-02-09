import 'package:alarm_weather_app/database/model_class.dart';
import 'package:alarm_weather_app/local_notification/notifcation_services.dart';
import 'package:alarm_weather_app/widgets/curverd_container.dart';
import 'package:alarm_weather_app/widgets/homepage.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:hive/hive.dart';

class AddAlarm extends StatefulWidget {
  AddAlarm({super.key});

  @override
  State<AddAlarm> createState() => AddAlarmState();
}

class AddAlarmState extends State<AddAlarm> {
  List<bool> selectedDays =
      List.generate(7, (index) => false); // Initialize with default values
  DateTime? selectedTime;
  Color selectedColor = const Color.fromARGB(
    255,
    8,
    35,
    56,
  );
  TextEditingController labelController = TextEditingController();
  //

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Column(
            children: [
              CurvedBorderContainer(
                initialSelectedTime: selectedTime,
                isNewAlarm: true,
                labelController: labelController,
                initialLabel: '',
                initialColor: const Color.fromARGB(255, 8, 35, 56),
                initialSelectedDays: selectedDays,
                onTimeChanged: (time) {
                  setState(() {
                    selectedTime = time;
                  });
                },
                onSelectedDaysChanged: (days) {
                  setState(() {
                    selectedDays = days;
                  });
                },
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  const SizedBox(
                    width: 20,
                  ),
                  const Text(
                    "Pick a Color",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  GestureDetector(
                    onTap: _openColorPickerDialog,
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: selectedColor,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(
                    255,
                    8,
                    35,
                    56,
                  ),
                ),
                onPressed: () {
                  scheduleNotification();
                  saveAlarm();
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            const MyHomePage()), // Provide the builder for MyHomePage
                    (route) => false,
                  );
                },
                child: const Text(
                  "Save",
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  void _openColorPickerDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Pick a Color'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: selectedColor,
              onColorChanged: (color) {
                setState(() {
                  selectedColor = color;
                });
              },
              showLabel: true,
              pickerAreaHeightPercent: 0.8,
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void saveAlarm() async {
    final Box<Alarm> alarmBox = Hive.box<Alarm>('alarms');
    print('Selected Days when creating Alarm: $selectedDays');

    final newAlarm = Alarm(
        selectedDays: selectedDays,
        label: labelController.text,
        color: selectedColor.value,
        time: selectedTime);

    print('New Alarm before saving: $newAlarm');

    final addedKey = await alarmBox.add(newAlarm);
    newAlarm.key = addedKey;

    print('New Alarm added with key: $addedKey');
    print('New Alarm after saving: $newAlarm');

    // Retrieve the saved alarm from the database
    final retrievedAlarm = alarmBox.get(addedKey);
    print('Retrieved Alarm from the database: $retrievedAlarm');
  }

  void scheduleNotification() {
    print('Scheduling notification...');

    // Check if selectedTime is not null
    if (selectedTime != null) {
      // Print the selected time and day
      print('Selected Time: ${selectedTime!.hour}:${selectedTime!.minute}');
      print('Selected Day of Week: ${selectedTime!.weekday}');
      // Use the user-selected time for scheduling the notification
      AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: 0,
          channelKey: 'basic_channel',
          title: 'Alarm:${labelController.text}',
          body: 'It\'s time for your alarm!',
        ),
        schedule: NotificationCalendar(
          weekday: selectedTime!.weekday,
          hour: selectedTime!.hour,
          minute: selectedTime!.minute,
          second: selectedTime!.second,
          millisecond: selectedTime!.millisecond,
        ),
      );
    } else {
      // Handle the case where selectedTime is null (optional)
      print('Error: selectedTime is null. Cannot schedule the notification.');
    }
  }
}

// Future<void> _scheduleNotification() async {
//     String title = "Alarm:${labelController.text}";
//     String body = 'It\'s time for your alarm!';

//     DateTime now = DateTime.now();
//     DateTime scheduledDateTime = DateTime(
//       now.year,
//       now.month,
//       now.day,
//       selectedTime!.hour,
//       selectedTime!.minute,
//     );

//     for (int i = 0; i < 7; i++) {
//       print('Executing _scheduleNotification');

//       if (selectedDays[i]) {
//         int daysUntilNext = (i - now.weekday + 7) % 7;
//         scheduledDateTime =
//             scheduledDateTime.add(Duration(days: daysUntilNext));
//         print('Scheduling notification: $title, $body, $scheduledDateTime');

//         await notificationService.sheduleNotification(
//           id: labelController.text.hashCode,
//           title: title,
//           body: body,
//           scheduleNotificationDateTime: scheduledDateTime,
//         );
//       }
//     }
//   }

//   Default color
