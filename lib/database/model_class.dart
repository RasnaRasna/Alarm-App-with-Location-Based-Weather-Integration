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

  Alarm({
    this.label,
    this.time,
    required this.color,
  });
  Color get alarmColor => Color(color);

  // Additional fields and methods as needed
}
