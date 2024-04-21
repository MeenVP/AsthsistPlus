// Purpose: Health backend
import 'dart:developer';
import 'package:workmanager/workmanager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../backend/firebase.dart';
import 'package:health/health.dart';
import 'package:permission_handler/permission_handler.dart';




class HealthService{

  static final types = [
    HealthDataType.HEART_RATE,
    HealthDataType.STEPS,
    // HealthDataType.BLOOD_OXYGEN,
  ];
  // with corresponsing permissions
  // READ only
  final permissions = types.map((e) => HealthDataAccess.READ).toList();

  // create a HealthFactory for use in the app

  Future<void> authorize() async {
    Health().configure(useHealthConnectIfAvailable: false);
    // If we are trying to read Step Count, Workout, Sleep or other data that requires
    // the ACTIVITY_RECOGNITION permission, we need to request the permission first.
    // This requires a special request authorization call.
    //
    // The location permission is requested for Workouts using the Distance information.
    await Permission.activityRecognition.request();
    await Permission.location.request();

    // Check if we have health permissions
    bool? hasPermissions =
    await Health().hasPermissions(types, permissions: permissions);

    // hasPermissions = false because the hasPermission cannot disclose if WRITE access exists.
    // Hence, we have to request with WRITE as well.
    hasPermissions = false;

    bool authorized = false;
    if (!hasPermissions) {
      // requesting access to the data types before reading them
      try {
        authorized = await Health()
            .requestAuthorization(types, permissions: permissions);
      } catch (error) {
        log("Exception in authorize: $error");
      }
    }

  }

  Future fetchHeartRate() async {
    List<HealthDataPoint> healthDataList = [];
    // get data within the last 15 minutes
    final now = DateTime.now();
    final time = now.subtract(Duration(hours: 24));
    // Clear old data points
    healthDataList.clear();
    try {
      // fetch health data
      List<HealthDataPoint> healthData =
      await Health().getHealthDataFromTypes(startTime: time, endTime:now, types:[HealthDataType.HEART_RATE],);
      // save all the new data points
      healthDataList.addAll(healthData);
    } catch (error) {
      print("Exception in getHealthDataFromTypes: $error");
    }
    // filter out duplicates
    healthDataList = Health().removeDuplicates(healthDataList);
    await FirebaseService().addHRToFirebase(healthDataList);
  }

  Future fetchSteps() async {
    List<HealthDataPoint> healthDataList = [];
    // get data within the last 15 minutes
    final now = DateTime.now();
    final time = now.subtract(Duration(hours: 24));
    // Clear old data points
    healthDataList.clear();
    try {
      // fetch health data
      List<HealthDataPoint> healthData =
      await Health().getHealthDataFromTypes(startTime: time, endTime:now, types: [HealthDataType.STEPS]);
      // save all the new data points
      healthDataList.addAll(healthData);
    } catch (error) {
      print("Exception in getHealthDataFromTypes: $error");
    }
    // filter out duplicates
    healthDataList = Health().removeDuplicates(healthDataList);
    await FirebaseService().addStepToFirebase(healthDataList);

    // update the UI to display the results
  }






}


