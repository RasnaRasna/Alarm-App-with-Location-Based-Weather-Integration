// Import necessary packages and files
import 'package:flutter/material.dart';
import 'date_picker.dart';

class CurvedBorderContainer extends StatefulWidget {
  @override
  _CurvedBorderContainerState createState() => _CurvedBorderContainerState();
}

class _CurvedBorderContainerState extends State<CurvedBorderContainer> {
  TimeOfDay? selectedTime;
  List<bool> selectedDays =
      List.generate(7, (index) => false); // To track selected days
  String label = "";
  Color selectedColor = Colors.blue;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 8, 35, 56),
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 40, horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Set New Alarm",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(
                    Icons.cancel,
                    size: 30,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                Positioned(
                  top: 10,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 400,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(65),
                        topRight: Radius.circular(65),
                      ),
                    ),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 13,
                        ),
                        Card(
                          color: const Color.fromARGB(255, 199, 224, 246),
                          elevation: 20,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(60)),
                          child: GestureDetector(
                            onTap: () {
                              // Show the AlarmTime widget when the card is tapped
                              _showAlarmTimePicker(context);
                            },
                            child: Container(
                              width: 300, // Adjust the width as needed
                              height: 150, // Adjust the height as needed
                              child: Center(
                                child: selectedTime != null
                                    ? Text(
                                        "${selectedTime!.format(context)}",
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 25,
                                        ),
                                      )
                                    : const Text(
                                        "Tap to set time",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 18,
                                        ),
                                      ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Display days of the week
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: List.generate(
                            7,
                            (index) => GestureDetector(
                              onTap: () {
                                setState(() {
                                  // Toggle the selection for the corresponding day
                                  selectedDays[index] = !selectedDays[index];
                                });
                              },
                              child: Container(
                                width: 35,
                                height: 35,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  color: selectedDays[index]
                                      ? const Color.fromARGB(255, 8, 35, 56)
                                      : Colors.grey,
                                ),
                                child: Center(
                                  child: Text(
                                    getDayName(index),
                                    style: const TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: 20,
                            ),
                            GestureDetector(
                              child: const Icon(Icons.edit),
                              onTap: () {
                                _showLabelInputDialog(context);
                              },
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            Text(
                              label.isNotEmpty
                                  ? " $label"
                                  : "Tap the icon to add a label",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showLabelInputDialog(BuildContext context) {
    TextEditingController labelController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Enter Label"),
          content: TextField(
            controller: labelController,
            decoration: const InputDecoration(labelText: "Label"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: const Text("Cancel",
                  style: TextStyle(
                    color: Color.fromARGB(255, 8, 35, 56),
                  )),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  label = labelController.text; // Save the label
                });
                Navigator.pop(context); // Close the dialog
              },
              child: const Text(
                "Save",
                style: TextStyle(
                  color: Color.fromARGB(255, 8, 35, 56),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // Function to show the AlarmTime widget as a bottom sheet
  void _showAlarmTimePicker(BuildContext context) async {
    TimeOfDay? pickedTime = await showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return AlarmTime(
          initialDateTime: DateTime.now(),
          onDateTimeChanged: (DateTime dateTime) {
            // Handle the selected time as needed
            setState(() {
              selectedTime = TimeOfDay.fromDateTime(dateTime);
            });
          },
        );
      },
    );

    // Handle the selected time from the AlarmTime widget
    if (pickedTime != null) {
      setState(() {
        selectedTime = pickedTime;
      });
    }
  }

  // Helper function to get the day name based on the index
  String getDayName(int index) {
    switch (index) {
      case 0:
        return 'S';
      case 1:
        return 'M';
      case 2:
        return 'T';
      case 3:
        return 'W';
      case 4:
        return 'T';
      case 5:
        return 'F';
      case 6:
        return 'S';
      default:
        return '';
    }
  }
}
