import 'package:alarm_weather_app/database/model_class.dart';
import 'package:alarm_weather_app/widgets/curverd_container.dart';
import 'package:alarm_weather_app/widgets/homepage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:hive/hive.dart';

class EditAlarm extends StatefulWidget {
  final Alarm alarm; // Add this line

  EditAlarm({super.key, required this.alarm});

  @override
  State<EditAlarm> createState() => _EditAlarmState();
}

class _EditAlarmState extends State<EditAlarm> {
  TextEditingController labelController = TextEditingController();
  Color selectedColor = Colors.blue;
  // Default color
  TimeOfDay? selectedTime; // Define selectedTime

  @override
  void initState() {
    super.initState();
    // Initialize the text controller and color with the values from the provided alarm
    labelController.text = widget.alarm.label ?? '';
    selectedColor = Color(widget.alarm.color);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          CurvedBorderContainer(
            onSelectedDaysChanged: (newSelectedDays) {
              // Handle the changes to the selected days, if needed
              print('Selected Days in EditAlarm: $newSelectedDays');
            },
            initialSelectedDays:
                widget.alarm.selectedDays, // Provide the initial selected days

            isNewAlarm: false,
            labelController: labelController,
            initialTime: widget.alarm.time != null
                ? TimeOfDay.fromDateTime(widget.alarm.time!)
                : null,
            initialLabel: widget.alarm.label ?? '', // Provide the initial label
            initialColor:
                Color(widget.alarm.color), // Provide the initial color
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
                                Navigator.of(context).pop(); // Close the dialog
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
    if (widget.alarm.label == labelController.text &&
        widget.alarm.time ==
            (selectedTime != null
                ? DateTime(
                    widget.alarm.time!.year,
                    widget.alarm.time!.month,
                    widget.alarm.time!.day,
                    selectedTime!.hour,
                    selectedTime!.minute,
                  )
                : widget.alarm.time) &&
        widget.alarm.color == selectedColor.value) {
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
    widget.alarm.selectedDays = widget.alarm.selectedDays;

    // Get the Hive box
    final Box<Alarm> alarmBox = Hive.box<Alarm>('alarms');

    // Find the index of the existing object in the box
    final int existingIndex = alarmBox.values.toList().indexOf(widget.alarm);

    // Put the updated object back into the box
    await alarmBox.put(existingIndex, widget.alarm);

    // Once saved, you can navigate back to the previous screen
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
          builder: (context) =>
              MyHomePage()), // Provide the builder for MyHomePage
      (route) => false,
    );
  }
}
