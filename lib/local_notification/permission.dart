import 'package:permission_handler/permission_handler.dart';

Future<void> requestPermissions() async {
  await requestBatteryOptimizationPermission();
  await requestNotificationPermission();
  await requestLocationPermission();
}

Future<void> requestBatteryOptimizationPermission() async {
  var status = await Permission.ignoreBatteryOptimizations.status;
  if (status.isDenied || status.isPermanentlyDenied) {
    print('Requesting Battery Optimization Permission...');
    await Permission.ignoreBatteryOptimizations.request();
  }
}

Future<void> requestNotificationPermission() async {
  var status = await Permission.notification.status;
  if (status.isDenied || status.isPermanentlyDenied) {
    print('Requesting Notification Permission...');
    await Permission.notification.request();
  }
}

Future<void> requestLocationPermission() async {
  var status = await Permission.location.status;
  if (status.isDenied || status.isPermanentlyDenied) {
    print('Requesting Location Permission...');
    await Permission.location.request();
  }
}
