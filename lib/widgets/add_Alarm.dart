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
  Color selectedColor = Color.fromARGB(
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
                  isNewAlarm: true,
                  labelController: labelController,
                  initialTime: null, // Provide the initial time if needed
                  initialLabel: '', // Provide the initial label if needed
                  initialColor: Color.fromARGB(
                    255,
                    8,
                    35,
                    56,
                  ) // Provide the initial color if needed
                  ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    "Pick a Color",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
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
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(
                    255,
                    8,
                    35,
                    56,
                  ),
                ),
                onPressed: () {
                  saveAlarm();

                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => MyHomePage()),
                  );
                },
                child: Text(
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
          title: Text('Pick a Color'),
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
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void saveAlarm() async {
    final alarmBox = await Hive.openBox('alarms');
    final newAlarm = Alarm(
      label: labelController.text, // Use the label from the controller
      time: DateTime.now(),
      color: selectedColor.value,
    );

    print('Label in addalarm: ${labelController.text}');
    final addedKey =
        await alarmBox.add(newAlarm); // Retrieve the key after adding

    // Assign the key to the Alarm object
    newAlarm.key = addedKey;

    print('New Alarm added with key: $addedKey');
  }
}
