import 'package:alarm_weather_app/widgets/curverd_container.dart';
import 'package:flutter/material.dart';

class AddHabit extends StatelessWidget {
  const AddHabit({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // // Horizontal row with text and icon
          // const Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: [
          //     Row(
          //       children: [
          //         SizedBox(width: 8), // Adjust spacing
          //         Padding(
          //           padding: EdgeInsets.only(top: 30),
          //           child: Text(
          //             "Your Text",
          //             style: TextStyle(color: Colors.black, fontSize: 20),
          //           ),
          //         ),
          //       ],
          //     ),
          //     Icon(Icons.cancel),
          //   ],
          // ),
          // // Curved Border Container
          CurvedBorderContainer(),
        ],
      ),
    );
  }
}
