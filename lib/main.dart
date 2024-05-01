import 'package:asthsist_plus/style.dart';
import 'package:asthsist_plus/widget_tree.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'backend/firebase.dart';
import 'firebase_options.dart';
import 'backend/health.dart';
import 'backend/notifications.dart';
import 'backend/sklearn.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:workmanager/workmanager.dart';

Future<void> _checkLocationPermission() async {
  // Check if location service is enabled
  bool serviceStatus = await Geolocator.isLocationServiceEnabled();
  if (serviceStatus) {
    print("GPS service is enabled");
  } else {
    print("GPS service is disabled.");
  }

  // Check if location permission is granted
  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      print('Location permissions are denied');
    } else if (permission == LocationPermission.deniedForever) {
      print('Location permissions are permanently denied');
    } else {
      print('GPS Location service is granted');
    }
  } else {
    print('GPS Location permission granted.');
  }
}

// This is the callback dispatcher function. It will be called by the Workmanager to run background tasks
@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    print("Native called background task: $task");
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    _checkLocationPermission();
    await NotificationServices().initNotifications();
    try {
      await HealthService().fetchSteps();
      await HealthService().fetchHeartRate();
      await FirebaseService().addWeatherToFirebase();
      await NotificationServices().showNotification(3);
      await SKLearn().peakFlowPrediction();
    } catch (e) {
      print(e);
      NotificationServices().showNotification(3, e.toString());
      throw Exception(e);
    }
    return Future.value(true);
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

//  // Request permissions
  await [
    Permission.location,
    Permission.activityRecognition,
    Permission.notification,
  ].request();

  // initialize notifications service
  await NotificationServices().initNotifications();

  // initialize firebase service
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge,
      overlays: [SystemUiOverlay.top]);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    systemNavigationBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
    systemNavigationBarIconBrightness: Brightness.dark,
  ));

  // initialize workmanager
  await Workmanager().initialize(
      callbackDispatcher, // The top level function, aka callbackDispatcher
      isInDebugMode:
          false // If enabled it will post a notification whenever the task is running. Handy for debugging tasks
      );

  // Register the background task
  await Workmanager().registerPeriodicTask(
    '1',
    'fetchData',
    initialDelay: const Duration(minutes: 15),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Asthsist+',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Style.primaryColor),
        primarySwatch: Colors.blue,
        inputDecorationTheme: const InputDecorationTheme(
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Style.primaryColor),
          ),
        ),
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: Style.primaryColor,
        ),
      ),
      // home: NavigationBarApp()
      //home: HomePage(),
      home: const WidgetTree(),
    );
  }
}
