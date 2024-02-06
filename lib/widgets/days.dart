import 'package:flutter/material.dart';

class Days extends StatelessWidget {
  final List<bool> days;

  Days({required this.days});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildDay('M', days[0]),
        _buildDay('T', days[1]),
        _buildDay('W', days[2]),
        _buildDay('T', days[3]),
        _buildDay('F', days[4]),
        _buildDay('S', days[5]),
        _buildDay('S', days[6]),
      ],
    );
  }

  Widget _buildDay(String day, bool isSelected) {
    return Container(
      margin: const EdgeInsets.only(right: 5),
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: isSelected ? Colors.blue : Colors.grey,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        day,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.black,
        ),
      ),
    );
  }
}
