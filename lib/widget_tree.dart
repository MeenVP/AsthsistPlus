import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:workmanager/workmanager.dart';
import '../pages/navigation_bar.dart';
import '../pages/login_page.dart';
import '../backend/firebase.dart';

class WidgetTree extends StatefulWidget {
  const WidgetTree({Key? key}) : super(key: key);

  @override
  State<WidgetTree> createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> {


  @override
  void initState() {
    super.initState();
    _checkLocationPermission();
  }
  Future<void> _checkLocationPermission() async {
    bool serviceStatus = await Geolocator.isLocationServiceEnabled();
    if(serviceStatus){
      print("GPS service is enabled");
    }else{
      print("GPS service is disabled.");
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print('Location permissions are denied');
      }else if(permission == LocationPermission.deniedForever){
        print('Location permissions are permanently denied');
      }else{
        print('GPS Location service is granted');
      }
    }else{
      print('GPS Location permission granted.');
    }
  }
  @override
  Widget build(BuildContext context) {

    return StreamBuilder(
      stream: FirebaseService().authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return const NavigationBarApp();
        } else {
          return const LoginPage();
        }
      },
    );
  }
}