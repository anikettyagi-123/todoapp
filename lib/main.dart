// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:get/get.dart';
// import 'package:todo_list/splash_screen.dart';
//
// import 'firebase_options.dart';
//
// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );
//   WidgetsFlutterBinding.ensureInitialized();
//
//   // Lock the orientation to portrait only
//   SystemChrome.setPreferredOrientations([
//     DeviceOrientation.portraitUp,
//     DeviceOrientation.portraitDown,
//   ]).then((_) {
//     runApp(const MyApp());
//   });
//
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return GetMaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: SplashScreen(),
//
//     );
//   }
// }
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:todo_list/splash_screen.dart';
import 'controller/notification.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'firebase_options.dart';
 // Import your NotificationService

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //tz.initializeTimeZones();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );


  // Initialize the Notification Service
  final NotificationService notificationService = NotificationService();
  await notificationService.initNotification();
  // Ensure notifications are initialized

  // Register the NotificationService with GetX
  Get.put(notificationService);
  print('NotificationService registered successfully.');
  if (Platform.isAndroid && (await getAndroidVersion() >= 12)) {
    await requestExactAlarmPermission();
  }

  // Lock the orientation to portrait only
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) {
    runApp(const MyApp());
  });
}
Future<void> requestExactAlarmPermission() async {
  if (await Permission.scheduleExactAlarm.request().isGranted) {
    print("Exact alarm permission granted");
  } else {
    print("Exact alarm permission denied");
  }
}

Future<int> getAndroidVersion() async {
  return int.parse((await Process.run('getprop', ['ro.build.version.sdk'])).stdout.trim());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}

