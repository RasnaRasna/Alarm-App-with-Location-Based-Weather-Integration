import 'package:alarm_weather_app/database/model_class.dart';
import 'package:alarm_weather_app/widgets/curverd_container.dart';
import 'package:alarm_weather_app/widgets/homepage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:hive/hive.dart';

class AddAlarm extends StatefulWidget {
  AddAlarm({super.key});

  @override
  State<AddAlarm> createState() => _AddHabitState();
}

class _AddHabitState extends State<AddAlarm> {
  List<bool> selectedDays =
      List.generate(7, (index) => false); // Initialize with default values
  DateTime? selectedTime;
  Color selectedColor = const Color.fromARGB(
    255,
    8,
    35,
    56,
  );
  // Default color
  TextEditingController labelController = TextEditingController();

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
}
