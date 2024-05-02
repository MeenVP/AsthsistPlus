import 'dart:developer';
import '../backend/firebase.dart';
import 'package:health/health.dart';
import 'package:permission_handler/permission_handler.dart';

class HealthService {
  // data types to read
  static final types = [
    HealthDataType.HEART_RATE,
    HealthDataType.STEPS,
  ];
  // permissions READ only
  final permissions = types.map((e) => HealthDataAccess.READ).toList();

  // authorize the user
  Future<void> authorize() async {
    Health().configure(useHealthConnectIfAvailable: false);
    await Permission.activityRecognition.request();
    await Permission.location.request();

    // Check for health permissions
    bool? hasPermissions =
        await Health().hasPermissions(types, permissions: permissions);

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

  // fetch heart rate data
  Future fetchHeartRate() async {
    List<HealthDataPoint> healthDataList = [];
    // get data within the last 15 minutes
    final now = DateTime.now();
    final time = now.subtract(const Duration(hours: 12));
    // Clear old data points
    healthDataList.clear();
    try {
      // fetch health data
      List<HealthDataPoint> healthData = await Health().getHealthDataFromTypes(
        startTime: time,
        endTime: now,
        types: [HealthDataType.HEART_RATE],
      );
      // save all the new data points
      healthDataList.addAll(healthData);
    } catch (error) {
      log("Exception in getHealthDataFromTypes: $error");
    }
    // filter out duplicates
    healthDataList = Health().removeDuplicates(healthDataList);
    // add data to firebase
    await FirebaseService().addHRToFirebase(healthDataList);
  }

  // fetch steps data
  Future fetchSteps() async {
    List<HealthDataPoint> healthDataList = [];
    // get data within the last 15 minutes
    final now = DateTime.now();
    final time = now.subtract(const Duration(hours: 12));
    // Clear old data points
    healthDataList.clear();
    try {
      // fetch health data
      List<HealthDataPoint> healthData = await Health().getHealthDataFromTypes(
          startTime: time, endTime: now, types: [HealthDataType.STEPS]);
      // save all the new data points
      healthDataList.addAll(healthData);
    } catch (error) {
      log("Exception in getHealthDataFromTypes: $error");
    }
    // filter out duplicates
    healthDataList = Health().removeDuplicates(healthDataList);

    // add data to firebase
    await FirebaseService().addStepsToFirebase(healthDataList);
  }
}
