import 'dart:convert';

import 'package:alarm_weather_app/database/model_class.dart';
import 'package:alarm_weather_app/widgets/add_Alarm.dart';
import 'package:alarm_weather_app/widgets/alarm_list.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late String currentLatitude = '0.0';
  late String currentLongitude = '0.0';
  Map<String, dynamic>? currentWeatherData;

  // Define API key at the class level
  final String apiKey = 'b662e9abd4114adab5a8d0ae8fc06d5d';

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  // Function to get the current location
  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      setState(() {
        currentLatitude = position.latitude.toString();
        currentLongitude = position.longitude.toString();
      });

      // Fetch weather information after obtaining the location
      await _updateWeather();
    } catch (e) {
      print("Error getting location: $e");
    }
  }

  // Function to get the current weather
  Future<void> _updateWeather() async {
    try {
      // Check if currentLatitude is not null before making the API call
      if (currentLatitude == null || currentLongitude == null) {
        print('Location not available yet.');
        return;
      }

      const String apiUrl = 'https://api.openweathermap.org/data/2.5/weather';
      final String url =
          '$apiUrl?lat=$currentLatitude&lon=$currentLongitude&appid=$apiKey';

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        currentWeatherData = json.decode(response.body);
        setState(() {
          // Trigger a rebuild to display weather information
        });
      } else {
        print('Failed to load weather data');
      }
    } catch (e) {
      print('Error getting weather: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Current Location'),
            Text('Lat: $currentLatitude, Lon: $currentLongitude'),
            if (currentWeatherData != null)
              Text('Weather: ${currentWeatherData!['weather'][0]['main']}'),
          ],
        ),
      ),
      body: WatchBoxBuilder(
        box: Hive.box<Alarm>('alarms'),
        builder: (context, box) {
          if (box.isEmpty) {
            return const Center(
              child: Text('No alarms available'),
            );
          }

          return ListView.builder(
            itemCount: box.length,
            itemBuilder: (context, index) {
              final alarm = box.getAt(index) as Alarm;

              return AlarmList(
                alarm: alarm,
                selectedTime: alarm.time != null
                    ? TimeOfDay.fromDateTime(alarm.time!)
                    : null,
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (ctx) => AddAlarm()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
