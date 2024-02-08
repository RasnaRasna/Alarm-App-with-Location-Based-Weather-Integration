import 'dart:convert';

import 'package:alarm_weather_app/database/model_class.dart';
import 'package:alarm_weather_app/widgets/add_Alarm.dart';
import 'package:alarm_weather_app/widgets/alarm_list.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';

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
    var status = await Permission.location.status;
    if (status.isGranted) {
      // Location permission is granted, proceed with getting the location.
      try {
        Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);

        setState(() {
          currentLatitude = position.latitude.toString();
          currentLongitude = position.longitude.toString();
        });
        print(currentWeatherData);

        // Fetch weather information after obtaining the location
        await _updateWeather();
      } catch (e) {
        print("Error getting location: $e");
      }
    } else {
      // Location permission is not granted, request it.
      await Permission.location.request();
      // The user will be prompted to grant the location permission.
    }
  }

  String getWeatherIcon(String mainCondition) {
    switch (mainCondition.toLowerCase()) {
      case 'clear':
        return '🌞';
      case 'clouds':
        return '☁️';
      case 'rain':
        return '🌧️';
      case 'thunderstorm':
        return '⛈️';
      case 'snow':
        return '❄️';
      default:
        return '❓';
    }
  }

  String getTemperature() {
    if (currentWeatherData != null &&
        currentWeatherData!['main'] != null &&
        currentWeatherData!['main']['temp'] != null) {
      double temperatureInKelvin =
          currentWeatherData!['main']['temp'].toDouble();
      // Convert temperature from Kelvin to Celsius
      double temperatureInCelsius = temperatureInKelvin - 273.15;
      // You can also convert temperature to Fahrenheit if needed
      // double temperatureInFahrenheit = (temperatureInCelsius * 9/5) + 32;

      return 'Temperature: ${temperatureInCelsius.toStringAsFixed(2)}°C';
    } else {
      return 'Temperature: N/A';
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
        backgroundColor: Color.fromARGB(255, 95, 137, 171),
        centerTitle: true,
        title: Text(
          'Weather and Alarms',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 95, 137, 171),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(50),
                bottomRight: Radius.circular(50),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (currentLatitude != '0.0' && currentLongitude != '0.0')
                  Text(
                    'Latitude: ${double.parse(currentLatitude).toStringAsFixed(2)}, Longitude: ${double.parse(currentLongitude).toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  getTemperature(),
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
                if (currentWeatherData != null)
                  Row(
                    children: [
                      Text(
                        'Weather: ${currentWeatherData!['weather'][0]['description']}',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 10),
                      Text(
                        getWeatherIcon(
                            currentWeatherData!['weather'][0]['main']),
                        style: TextStyle(
                          fontSize: 30,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
          Expanded(
            child: WatchBoxBuilder(
              box: Hive.box<Alarm>('alarms'),
              builder: (context, box) {
                if (box.isEmpty) {
                  return Center(
                    child: Text('No alarms available'),
                  );
                }

                return ListView.builder(
                  itemCount: box.length,
                  itemBuilder: (context, index) {
                    final alarm = box.getAt(index) as Alarm;

                    print('Alarm Time in homepage: ${alarm.time}');

                    final selectedTime = alarm.time != null ? alarm.time : null;
                    print('Selected Time in homepage: $selectedTime');

                    return AlarmList(
                      alarm: alarm,
                      selectedTime: selectedTime,
                    );
                  },
                );
              },
            ),
          ),
        ],
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
