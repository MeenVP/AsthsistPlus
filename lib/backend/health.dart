// Purpose: Health backend
import 'dart:developer';
import 'package:workmanager/workmanager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../backend/firebase.dart';
import 'package:health/health.dart';
import 'package:permission_handler/permission_handler.dart';

class Health{

  static final types = [
    HealthDataType.HEART_RATE,
    HealthDataType.STEPS,
    // HealthDataType.BLOOD_OXYGEN,
  ];
  // with corresponsing permissions
  // READ only
  final permissions = types.map((e) => HealthDataAccess.READ).toList();

  // create a HealthFactory for use in the app
  HealthFactory health = HealthFactory(useHealthConnectIfAvailable: true);
  Future authorize() async {
    // If we are trying to read Step Count, Workout, Sleep or other data that requires
    // the ACTIVITY_RECOGNITION permission, we need to request the permission first.
    // This requires a special request authorization call.
    //
    // The location permission is requested for Workouts using the Distance information.
    await Permission.activityRecognition.request();

    // Check if we have permission
    bool? hasPermissions =
    await health.hasPermissions(types, permissions: permissions);

    // hasPermissions = false because the hasPermission cannot disclose if WRITE access exists.
    // Hence, we have to request with WRITE as well.
    if (!hasPermissions!) {
      // requesting access to the data types before reading them
      await health.requestAuthorization(types, permissions: permissions).catchError((error) {
        log(error);});
    }
  }

  Future fetchData() async {
    List<HealthDataPoint> _healthDataList = [];
    // get data within the last 15 minutes
    final now = DateTime.now();
    final fifteenMinutesAgo = now.subtract(Duration(hours:24));
    // Clear old data points
    _healthDataList.clear();
    try {
      // fetch health data
      List<HealthDataPoint> healthData =
      await health.getHealthDataFromTypes(fifteenMinutesAgo, now, [HealthDataType.HEART_RATE],);
      // save all the new data points
      _healthDataList.addAll(healthData);
    } catch (error) {
      print("Exception in getHealthDataFromTypes: $error");
    }
    // filter out duplicates
    _healthDataList = HealthFactory.removeDuplicates(_healthDataList);
    // print the results
    _healthDataList.forEach((x) => {
      print(x.type),
      print(x.value),
      print(x.dateTo),
    });
    await FirebaseService().addHRToFirebase(_healthDataList);

    // update the UI to display the results
  }





}


