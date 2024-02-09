import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
part 'model_class.g.dart';

@HiveType(typeId: 0)
class Alarm {
  @HiveField(0)
  String? label;

  @HiveField(1)
  DateTime? time;
  @HiveField(2)
  int color; // You can use int to represent color, e.g., Color.value

  @HiveField(3)
  int? key; // Expose the key
  @HiveField(4)
  List<bool> selectedDays;
  Alarm(
      {this.label, this.time, required this.color, required this.selectedDays});
  Color get alarmColor => Color(color);
  @override
  String toString() {
    return 'Alarm(key: $key, label: $label, time: $time, color: $color, selectedDays: $selectedDays)';
  }
  // Additional fields and methods as needed
}
