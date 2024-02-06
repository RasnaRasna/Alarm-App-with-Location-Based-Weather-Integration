import 'package:alarm_weather_app/widgets/curverd_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class EditAlarm extends StatefulWidget {
  EditAlarm({super.key});

  @override
  State<EditAlarm> createState() => _AddHabitState();
}

class _AddHabitState extends State<EditAlarm> {
  Color selectedColor = Colors.blue;
  // Default color
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          CurvedBorderContainer(isNewAlarm: false),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(
                      255,
                      8,
                      35,
                      56,
                    ),
                  ),
                  onPressed: () {},
                  child: Text(
                    "Save",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  )),
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
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          content: Text(
                            "Are you sure you want to delete the Alarm?",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                // Handle "Yes" button action
                                Navigator.of(context).pop(); // Close the dialog
                              },
                              child: Text(
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
                              child: Text(
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
                  child: Text(
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
}