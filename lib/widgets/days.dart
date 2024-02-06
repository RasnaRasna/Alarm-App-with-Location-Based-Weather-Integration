import 'package:flutter/material.dart';

Widget DaysContainer() {
  String _getDaySymbol(int index) {
    final List<String> symbols = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    return symbols[index];
  }

  return GestureDetector(
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.red,
          border: Border.all(width: 1),
          borderRadius: BorderRadius.circular(5),
        ),
        width: 20,
        height: 22,
        child: Center(
          child: Text(
            _getDaySymbol(1),
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    ),
  );
}
