import 'package:alarm_weather_app/widgets/date_picker.dart';
import 'package:flutter/material.dart';

class CurvedBorderContainer extends StatefulWidget {
  @override
  _CurvedBorderContainerState createState() => _CurvedBorderContainerState();
}

class _CurvedBorderContainerState extends State<CurvedBorderContainer> {
  TimeOfDay? selectedTime;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 8, 35, 56),
      ),
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 35, horizontal: 10),
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
                Icon(
                  Icons.cancel,
                  size: 30,
                  color: Colors.white,
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
                        SizedBox(
                          height: 13,
                        ),
                        Card(
                          color: Color.fromARGB(255, 199, 224, 246),
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
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 25,
                                        ),
                                      )
                                    : Text(
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
}
