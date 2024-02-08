// // Import necessary packages and files
// import 'package:alarm_weather_app/local_notification/notifcation_services.dart';
// import 'package:flutter/material.dart';
// import 'date_picker.dart';

// class CurvedBorderContainer extends StatefulWidget {
//   final bool isNewAlarm;
//   final TextEditingController labelController;
//   final TimeOfDay? initialTime;
//   final String initialLabel;
//   final Color initialColor;
//   final List<bool> initialSelectedDays; // Add initialSelectedDays parameter
//   final Function(List<bool>) onSelectedDaysChanged; // Add this callback

//   const CurvedBorderContainer({
//     Key? key,
//     required this.isNewAlarm,
//     required this.labelController,
//     required this.initialTime,
//     required this.initialLabel,
//     required this.initialColor,
//     required this.initialSelectedDays,
//     required this.onSelectedDaysChanged,
//   }) : super(key: key);

//   @override
//   _CurvedBorderContainerState createState() => _CurvedBorderContainerState();
// }

// class _CurvedBorderContainerState extends State<CurvedBorderContainer> {
//   TextEditingController labelController = TextEditingController();
//   TimeOfDay? selectedTime;
//   String label = "";
//   Color selectedColor = Colors.blue;
//   late List<bool> selectedDays; // Declare selectedDays list

//   @override
//   void initState() {
//     super.initState();
//     selectedDays = List.from(widget.initialSelectedDays);

//     // Initialize values based on whether it's a new or edit alarm
//     if (widget.isNewAlarm) {
//       // For a new alarm, use the provided initial values
//       selectedTime = widget.initialTime;
//       label = widget.initialLabel;
//       selectedColor = widget.initialColor;
//     }
//     // For editing an alarm, the values will be set later in the build method
//   }

//   @override
//   Widget build(BuildContext context) {
//     String title = widget.isNewAlarm ? "Set New Alarm" : "Edit Alarm";

//     // Initialize values for editing an alarm in the build method
//     if (!widget.isNewAlarm) {
//       selectedTime ??= widget.initialTime;
//       label = label.isEmpty ? widget.initialLabel : label;
//       selectedColor =
//           selectedColor == Colors.blue ? widget.initialColor : selectedColor;
//       // Set selectedDays based on the provided alarm or provide default values
//     }
//     return Container(
//       height: 400,
//       decoration: const BoxDecoration(
//         color: Color.fromARGB(255, 8, 35, 56),
//       ),
//       child: Column(
//         children: [
//           Padding(
//             padding: EdgeInsets.symmetric(vertical: 40, horizontal: 10),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   title,
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 20,
//                   ),
//                 ),
//                 GestureDetector(
//                   onTap: () {
//                     Navigator.pop(context);
//                   },
//                   child: Icon(
//                     Icons.cancel,
//                     size: 30,
//                     color: Colors.white,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Expanded(
//             child: Stack(
//               children: [
//                 Positioned(
//                   top: 10,
//                   left: 0,
//                   right: 0,
//                   child: Container(
//                     height: 400,
//                     decoration: const BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.only(
//                         topLeft: Radius.circular(65),
//                         topRight: Radius.circular(65),
//                       ),
//                     ),
//                     child: Column(
//                       children: [
//                         const SizedBox(
//                           height: 13,
//                         ),
//                         Card(
//                           color: const Color.fromARGB(255, 199, 224, 246),
//                           elevation: 20,
//                           shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(60)),
//                           child: GestureDetector(
//                             onTap: () {
//                               // Show the AlarmTime widget when the card is tapped
//                               _showAlarmTimePicker(context);
//                             },
//                             child: Container(
//                               width: 300, // Adjust the width as needed
//                               height: 150, // Adjust the height as needed
//                               child: Center(
//                                 child: selectedTime != null
//                                     ? Text(
//                                         "${selectedTime!.format(context)}",
//                                         style: const TextStyle(
//                                           color: Colors.black,
//                                           fontWeight: FontWeight.bold,
//                                           fontSize: 25,
//                                         ),
//                                       )
//                                     : const Text(
//                                         "Tap to set time",
//                                         style: TextStyle(
//                                             color: Colors.black,
//                                             fontSize: 18,
//                                             fontWeight: FontWeight.bold),
//                                       ),
//                               ),
//                             ),
//                           ),
//                         ),
//                         const SizedBox(height: 20),
//                         // Display days of the week
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                           children: List.generate(
//                             7,
//                             (index) => GestureDetector(
//                               onTap: () {
//                                 // Toggle the selection for the corresponding day
//                                 setState(() {
//                                   // Toggle the selection for the corresponding day
//                                   selectedDays[index] = !selectedDays[index];
//                                   print(
//                                       'Selected Days in _CurvedBorderContainerState: $selectedDays');
//                                   widget.onSelectedDaysChanged(
//                                       selectedDays); // Notify parent
//                                 });
//                               },
//                               child: Container(
//                                 width: 35,
//                                 height: 35,
//                                 decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.circular(30),
//                                   color: selectedDays[index]
//                                       ? const Color.fromARGB(255, 8, 35, 56)
//                                       : Colors.grey,
//                                 ),
//                                 child: Center(
//                                   child: Text(
//                                     getDayName(index),
//                                     style: const TextStyle(
//                                       color: Colors.white,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                         const SizedBox(
//                           height: 20,
//                         ),
//                         Row(
//                           children: [
//                             SizedBox(
//                               width: 20,
//                             ),
//                             GestureDetector(
//                               child: const Icon(Icons.edit),
//                               onTap: () {
//                                 _showLabelInputDialog(
//                                   context,
//                                 );
//                               },
//                             ),
//                             const SizedBox(
//                               width: 20,
//                             ),
//                             Text(
//                               label.isNotEmpty
//                                   ? " $label"
//                                   : "Tap the icon to add a label",
//                               style: const TextStyle(
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 15,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   void _showLabelInputDialog(
//     BuildContext context,
//   ) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text("Enter Label"),
//           content: TextField(
//             controller: widget.labelController, // Use the provided controller
//             decoration: const InputDecoration(labelText: "Label"),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(context); // Close the dialog
//               },
//               child: const Text("Cancel",
//                   style: TextStyle(
//                     color: Color.fromARGB(255, 8, 35, 56),
//                   )),
//             ),
//             TextButton(
//               onPressed: () {
//                 setState(() {
//                   label = widget.labelController.text;
//                 });
//                 Navigator.pop(context); // Close the dialog
//               },
//               child: const Text(
//                 "Save",
//                 style: TextStyle(
//                   color: Color.fromARGB(255, 8, 35, 56),
//                 ),
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   // Function to show the AlarmTime widget as a bottom sheet
//   void _showAlarmTimePicker(BuildContext context) async {
//     TimeOfDay? pickedTime = await showModalBottomSheet(
//       context: context,
//       builder: (BuildContext context) {
//         return AlarmTime(
//           initialDateTime: DateTime.now(),
//           onDateTimeChanged: (DateTime dateTime) {
//             // Handle the selected time as needed
//             setState(() {
//               selectedTime = TimeOfDay.fromDateTime(dateTime);
//             });
//           },
//         );
//       },
//     );

//     // Handle the selected time from the AlarmTime widget
//     if (pickedTime != null) {
//       setState(() {
//         selectedTime = pickedTime;
//         if (selectedDays.isNotEmpty) {
//           _scheduleNotification();
//         }
//       });
//     }
//   }

//   Future<void> _scheduleNotification() async {
//     NotificationService notificationService = NotificationService();
//     String title = "Alarm:$label";

//     String body = 'It\'s time for your alarm!';
//     // Find the next occurrence of the selected day and time
//     DateTime now = DateTime.now();
//     DateTime scheduledDateTime = DateTime(
//       now.year,
//       now.month,
//       now.day,
//       selectedTime!.hour,
//       selectedTime!.minute,
//     );
//     for (int i = 0; i < 7; i++) {
//       if (selectedDays[i]) {
//         // Find the next occurrence of the selected day
//         int daysUntilNext = (i - now.weekday + 7) % 7;
//         scheduledDateTime =
//             scheduledDateTime.add(Duration(days: daysUntilNext));

//         // Schedule the notification for the calculated date and time
//         await notificationService.sheduleNotification(
//           id: label.hashCode, // Use a unique ID for each alarm
//           title: title,
//           body: body,
//           sheduleNotificationDateTime: scheduledDateTime,
//         );
//       }
//     }
//   }
// }

// // Helper function to get the day name based on the index
// String getDayName(int index) {
//   switch (index) {
//     case 0:
//       return 'S';
//     case 1:
//       return 'M';
//     case 2:
//       return 'T';
//     case 3:
//       return 'W';
//     case 4:
//       return 'T';
//     case 5:
//       return 'F';
//     case 6:
//       return 'S';
//     default:
//       return '';
//   }
// } Import necessary packages and files
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'date_picker.dart';

class CurvedBorderContainer extends StatefulWidget {
  final bool isNewAlarm;
  final TextEditingController labelController;

  final String initialLabel;
  final Color initialColor;
  final List<bool> initialSelectedDays; // Add initialSelectedDays parameter
  final Function(List<bool>) onSelectedDaysChanged; // Add this callback
  final DateTime? initialSelectedTime; // Add this parameter
  final Function(DateTime?) onTimeChanged; // Add this callback

  const CurvedBorderContainer({
    Key? key,
    required this.isNewAlarm,
    required this.labelController,
    required this.initialLabel,
    required this.initialColor,
    required this.initialSelectedDays,
    required this.onSelectedDaysChanged,
    this.initialSelectedTime,
    required this.onTimeChanged, TimeOfDay? initialTime,
  }) : super(key: key);

  @override
  _CurvedBorderContainerState createState() => _CurvedBorderContainerState();
}

class _CurvedBorderContainerState extends State<CurvedBorderContainer> {
  TextEditingController labelController = TextEditingController();
  DateTime? selectedTime;
  String label = "";
  Color selectedColor = Colors.blue;
  late List<bool> selectedDays; // Declare selectedDays list

  @override
  void initState() {
    super.initState();
    selectedDays = List.from(widget.initialSelectedDays);

    // Initialize values based on whether it's a new or edit alarm
    if (widget.isNewAlarm) {
      label = widget.initialLabel;
      selectedColor = widget.initialColor;
      selectedTime =
          widget.initialSelectedTime; // Use the existing selectedTime
    }
    // For editing an alarm, the values will be set later in the build method
  }

  @override
  Widget build(BuildContext context) {
    String title = widget.isNewAlarm ? "Set New Alarm" : "Edit Alarm";

    // Initialize values for editing an alarm in the build method
    if (!widget.isNewAlarm) {
      label = label.isEmpty ? widget.initialLabel : label;
      selectedColor =
          selectedColor == Colors.blue ? widget.initialColor : selectedColor;
      // Set selectedDays based on the provided alarm or provide default values
    }
    print({"selected time in_CurvedBorderContainerState $selectedTime"});
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
                  title,
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
                              _showAlarmTimePicker(
                                context,
                              );
                            },
                            child: Container(
                              width: 300,
                              height: 150,
                              child: Center(
                                child: selectedTime != null
                                    ? Text(
                                        "Selected Time: ${DateFormat('HH:mm').format(selectedTime!)}",
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
                                            fontWeight: FontWeight.bold),
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
                                // Toggle the selection for the corresponding day
                                setState(() {
                                  // Toggle the selection for the corresponding day
                                  selectedDays[index] = !selectedDays[index];
                                  print(
                                      'Selected Days in _CurvedBorderContainerState: $selectedDays');
                                  widget.onSelectedDaysChanged(
                                      selectedDays); // Notify parent
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
                                _showLabelInputDialog(
                                  context,
                                );
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

  void _updateSelectedTime(DateTime selectedTime) {
    setState(() {
      this.selectedTime = selectedTime;
      widget.onTimeChanged(selectedTime); // Call the callback
    });
  }

  void _showLabelInputDialog(
    BuildContext context,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Enter Label"),
          content: TextField(
            controller: widget.labelController, // Use the provided controller
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
                  label = widget.labelController.text;
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
    DateTime? pickedTime = await showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return AlarmTime(
          initialDateTime: DateTime.now(),
          onDateTimeChanged: _updateSelectedTime,
        );
      },
    );

    if (pickedTime != null) {
      // Save the selected time to the database or perform any other action
      // based on your requirements
      saveAlarmTime(pickedTime);
    }
  }

  void saveAlarmTime(DateTime selectedTime) {
    // Perform the necessary action to save the selected time to the database
    // For example, you can update the existing alarm or save it separately
    print("Selected Time: $selectedTime");
    // Add your logic to save the time to the database
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
