import 'package:alarm_weather_app/database/model_class.dart';
import 'package:alarm_weather_app/widgets/curverd_container.dart';
import 'package:alarm_weather_app/widgets/homepage.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:hive/hive.dart';

class EditAlarm extends StatefulWidget {
  final Alarm alarm; // Add this line
  final List<bool> initialSelectedDays; // Add this line

  final DateTime? selectedTime; // Change the type to DateTime?
  EditAlarm(
      {super.key,
      required this.alarm,
      required this.selectedTime,
      required this.initialSelectedDays});

  @override
  State<EditAlarm> createState() => _EditAlarmState();
}

class _EditAlarmState extends State<EditAlarm> {
  TextEditingController labelController = TextEditingController();
  Color selectedColor = Colors.blue;
  // Default color
  DateTime? selectedTime;
  late List<bool> selectedDays; // Declare selectedDays list

  @override
  void initState() {
    super.initState();
    print('Selected time in EditAlarm: $selectedTime');
    selectedDays = List.from(widget.initialSelectedDays);

    if (widget.alarm.time != null) {
      selectedTime = widget.alarm.time;
    }
    print('Selected time in EditAlarm after : $selectedTime');

    // Initialize the text controller and color with the values from the provided alarm
    labelController.text = widget.alarm.label ?? '';
    selectedColor = Color(widget.alarm.color);
    // Print additional information
    print('Widget alarm: ${widget.alarm}');
    print('Widget alarm time: ${widget.alarm.time}');
    print('Widget alarm color: ${widget.alarm.color}');
    print('selected  alarm time in edit: ${selectedTime}');
  }

  @override
  Widget build(BuildContext context) {
    print('Building EditAlarm widget');

    return Scaffold(
      body: ListView(
        children: [
          Column(
            children: [
              CurvedBorderContainer(
                onTimeChanged: (time) {
                  print('Selected time in CurvedBorderContainer: $time');
                  setState(() {
                    selectedTime = time;
                  });
                },
                onSelectedDaysChanged: (newSelectedDays) {
                  // Update the selectedDays list in the EditAlarm state
                  setState(() {
                    selectedDays = newSelectedDays;
                  });
                  print('Selected Days in EditAlarm: $newSelectedDays');
                },

                initialSelectedTime: selectedTime,
                initialSelectedDays: widget
                    .alarm.selectedDays, // Provide the initial selected days
                isNewAlarm: false,
                labelController: labelController,
                initialLabel:
                    widget.alarm.label ?? '', // Provide the initial label
                initialColor: Color(widget.alarm.color),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
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
                        saveChanges();
                      },
                      child: const Text(
                        "Save",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      )),
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
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              content: const Text(
                                "Are you sure you want to delete the Alarm?",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    deleteAlarm();
                                  },
                                  child: const Text(
                                    "Yes",
                                    style: TextStyle(
                                      color: Color.fromARGB(
                                        255,
                                        8,
                                        35,
                                        56,
                                      ),
                                    ),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    // Handle "No" button action
                                    Navigator.of(context)
                                        .pop(); // Close the dialog
                                  },
                                  child: const Text(
                                    "No",
                                    style: TextStyle(
                                      color: Color.fromARGB(
                                        255,
                                        8,
                                        35,
                                        56,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: const Text(
                        "Delete",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      )),
                ],
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

  void deleteAlarm() async {
    // Get the Hive box
    final Box<Alarm> alarmBox = Hive.box<Alarm>('alarms');

    // Find the index of the existing object in the box
    final int existingIndex = alarmBox.values.toList().indexOf(widget.alarm);

    // Delete the alarm from the box
    await alarmBox.deleteAt(existingIndex);
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
          builder: (context) =>
              MyHomePage()), // Provide the builder for MyHomePage
      (route) => false,
    );
    // Once deleted, you can navigate back to the previous screen or perform any other action
  }

  void saveChanges() async {
    // Define a tolerance for time comparison (e.g., 1 minute)
    const int timeTolerance = 1;

    if (widget.alarm.label == labelController.text &&
        widget.alarm.time != null &&
        (selectedTime == null ||
            (widget.alarm.time!.difference(
                  DateTime(
                    widget.alarm.time!.year,
                    widget.alarm.time!.month,
                    widget.alarm.time!.day,
                    selectedTime!.hour,
                    selectedTime!.minute,
                  ),
                )).abs() <=
                Duration(minutes: timeTolerance)) &&
        widget.alarm.color == selectedColor.value &&
        listEquals(widget.alarm.selectedDays, selectedDays)) {
      // No changes were made, show an error message
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('No Changes Made'),
            content: const Text('Please make changes before saving.'),
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
      return; // Exit the method if no changes were made
    }

    // Update the alarm object with the new values
    widget.alarm.label = labelController.text;
    widget.alarm.time = selectedTime != null
        ? DateTime(
            widget.alarm.time!.year,
            widget.alarm.time!.month,
            widget.alarm.time!.day,
            selectedTime!.hour,
            selectedTime!.minute,
          )
        : widget.alarm.time; // Update the time if selectedTime is not null
    widget.alarm.color = selectedColor.value;
    widget.alarm.selectedDays = List.from(selectedDays); // Update selected days

    // Get the Hive box
    final Box<Alarm> alarmBox = Hive.box<Alarm>('alarms');

    // Update the object in Hive using its key
    await alarmBox.put(widget.alarm.key, widget.alarm);
    scheduleNotification();
    // Once saved, you can navigate back to the previous screen
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
          builder: (context) =>
              MyHomePage()), // Provide the builder for MyHomePage
      (route) => false,
    );
  }

  void scheduleNotification() {
    print('Scheduling notification...');

    // Check if selectedTime is not null
    if (selectedTime != null) {
      // Print the selected time and day
      print('Selected Time: ${selectedTime!.hour}:${selectedTime!.minute}');
      print('Selected Day of Week: ${selectedTime!.weekday}');

      // Check if the selected day is in the list of selected days
      if (selectedDays[selectedTime!.weekday - 1]) {
        print('Selected Day of Week: ${selectedDays}');

        // Use the user-selected time for scheduling the notification
        AwesomeNotifications().createNotification(
          content: NotificationContent(
            id: 0,
            channelKey: 'basic_channel',
            title: '${labelController.text}',
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
        // Handle the case where the selected day is not in the list (optional)
        print('Error: Selected day is not in the list of selected days.');
      }
    } else {
      // Handle the case where selectedTime is null (optional)
      print('Error: selectedTime is null. Cannot schedule the notification.');
    }
  }
}
