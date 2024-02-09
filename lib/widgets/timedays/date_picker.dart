import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AlarmTime extends StatefulWidget {
  final DateTime initialDateTime;
  final ValueChanged<DateTime> onDateTimeChanged;

  AlarmTime({
    required this.initialDateTime,
    required this.onDateTimeChanged,
  });

  @override
  State<AlarmTime> createState() => _AlarmTimeState();
}

class _AlarmTimeState extends State<AlarmTime> {
  DateTime sheduleTime = DateTime.now();

  TimeOfDay? selectedTime =
      TimeOfDay.fromDateTime(DateTime.now()); // Initialize with current
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 200.0,
          child: CupertinoDatePicker(
            mode: CupertinoDatePickerMode.time,
            initialDateTime: widget.initialDateTime,
            onDateTimeChanged: widget.onDateTimeChanged,
          ),
        ),
        Container(
          color: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Done'),
              ),
            ],
          ),
        ),
      ],
    );
  }

 
}
