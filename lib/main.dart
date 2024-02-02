import 'package:asthsist_plus/widget_tree.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'backend/firebase.dart';
import 'backend/health.dart';
import 'firebase_options.dart';
import 'package:workmanager/workmanager.dart';

@pragma(
    'vm:entry-point')
void callbackDispatcher(){
  Workmanager().executeTask((task, inputData) async {
        print("Native called background task: $task");
        await Health().fetchData();
        await FirebaseService().addWeatherToFirebase();
    return Future.value(true);
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge, overlays: [SystemUiOverlay.top]);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    systemNavigationBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
    systemNavigationBarIconBrightness:Brightness.dark,
  ));

  await Workmanager().initialize(
      callbackDispatcher, // The top level function, aka callbackDispatcher
      isInDebugMode: true // If enabled it will post a notification whenever the task is running. Handy for debugging tasks
  );
  await Workmanager().registerPeriodicTask(
    '2',
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

    return const MaterialApp(
      title:'Asthsist+',
      debugShowCheckedModeBanner: false,
      // home: NavigationBarApp()
      //home: HomePage(),
      home: WidgetTree(),
    );
  }
}
