import 'dart:convert';
import 'package:alarm_weather_app/database/model_class.dart';
import 'package:alarm_weather_app/local_notification/notifcation_services.dart';
import 'package:alarm_weather_app/widgets/add_Alarm.dart';
import 'package:alarm_weather_app/widgets/alarm_list.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
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
  final String apiKey = 'b662e9abd4114adab5a8d0ae8fc06d5d';
  String currentCity = '';

  @override
  void initState() {
    super.initState();
    // notificationHelper.initialize();

    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    var status = await Permission.location.status;
    if (status.isGranted) {
      try {
        Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);

        List<Placemark> placemarks = await placemarkFromCoordinates(
          position.latitude,
          position.longitude,
        );

        setState(() {
          currentLatitude = position.latitude.toString();
          currentLongitude = position.longitude.toString();
          currentCity =
              placemarks.isNotEmpty ? placemarks.first.locality ?? '' : '';
        });

        await _updateWeather();
      } catch (e) {
        print("Error getting location: $e");
      }
    } else {
      await Permission.location.request();
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

  Widget getTemperatureWidget() {
    if (currentWeatherData != null &&
        currentWeatherData!['main'] != null &&
        currentWeatherData!['main']['temp'] != null) {
      double temperatureInKelvin =
          currentWeatherData!['main']['temp'].toDouble();
      double temperatureInCelsius = temperatureInKelvin - 273.15;

      return Text(
        '${temperatureInCelsius.toStringAsFixed(2)}°C',
        style: TextStyle(
          fontSize: 35,
          color: Colors.white,
        ),
      );
    } else {
      return CircularProgressIndicator();
    }
  }

  Future<void> _updateWeather() async {
    try {
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
        setState(() {});
      } else {
        print('Failed to load weather data');
      }
    } catch (e) {
      print('Error getting weather: $e');
    }
  }

  String _getCurrentDay() {
    return DateFormat('EEEE').format(DateTime.now());
  }

  String getHighTemperature() {
    if (currentWeatherData != null &&
        currentWeatherData!['main'] != null &&
        currentWeatherData!['main']['temp_max'] != null) {
      double highTemperatureInKelvin =
          currentWeatherData!['main']['temp_max'].toDouble();
      double highTemperatureInCelsius = highTemperatureInKelvin - 273.15;
      return '${highTemperatureInCelsius.toStringAsFixed(2)}°C';
    } else {
      return '';
    }
  }

  void showForegroundNotification() {
    FlutterLocalNotificationsPlugin().show(
      0,
      'Foreground Notification',
      'This is a foreground notification',
      NotificationDetails(
        android: AndroidNotificationDetails(
          'channelId',
          'channelName',
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
    );
  }

  String getLowTemperature() {
    if (currentWeatherData != null &&
        currentWeatherData!['main'] != null &&
        currentWeatherData!['main']['temp_min'] != null) {
      double lowTemperatureInKelvin =
          currentWeatherData!['main']['temp_min'].toDouble();
      double lowTemperatureInCelsius = lowTemperatureInKelvin - 273.15;
      return '${lowTemperatureInCelsius.toStringAsFixed(2)}°C';
    } else {
      return ' ';
    }
  }

  // NotificationHelper notificationHelper = NotificationHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Weather App',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.all(16.0),
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 139, 167, 190),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Display the current day
                    Text(
                      '${_getCurrentDay()}',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    // Display city name here
                    Text(
                      '$currentCity',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Display temperature value

                          getTemperatureWidget(),

                          const SizedBox(height: 20),
                          // Display H and its value
                          Text(
                            'H: ${getHighTemperature()}',
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.white,
                            ),
                          ),
                          // Display L and its value
                          Text(
                            'L: ${getLowTemperature()}',
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          // Display weather icon if currentWeatherData is not null
                          if (currentWeatherData != null &&
                              currentWeatherData!['weather'] != null &&
                              currentWeatherData!['weather'].isNotEmpty)
                            Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  ' ${currentWeatherData!['weather'][0]['description']}',
                                  style: const TextStyle(
                                    fontSize: 15,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  getWeatherIcon(currentWeatherData!['weather']
                                      [0]['main']),
                                  style: const TextStyle(
                                    fontSize: 100,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    )
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
                  return const Center(
                    child: Text(
                      'No alarms available',
                      style: TextStyle(fontSize: 20),
                    ),
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
        backgroundColor: Color.fromARGB(255, 139, 167, 190),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (ctx) => AddAlarm()),
          );
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
