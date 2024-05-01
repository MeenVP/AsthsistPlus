import 'dart:convert';
import 'package:sklite/utils/io.dart';
import 'package:sklite/ensemble/forest.dart';
import 'firebase.dart';
import 'notifications.dart';

class SKLearn {
  double gender = 0;
  double age = 0;
  double bmi = 0;
  double smoker = 0;
  double pefBest = 0;
  double hours = 0;
  double inhaler = 0;
  double temperature = 0;
  double humidity = 0;
  double aqi = 0;
  double no2 = 0;
  double so2 = 0;
  double pm25 = 0;
  double avgHeartRate = 0;
  double totalSteps = 0;

// prepare data for prediction
  Future<List<double>?> prepareData() async {
    final userDetails = await FirebaseService().getUserDetails();
    final weather = await FirebaseService().getLatestWeather();
    final hr = await FirebaseService().getAverageHrInPastHour();
    final steps = await FirebaseService().getTotalStepsInPastHour();
    //gender
    if (userDetails['gender'] == 'Male') {
      gender = 1;
    } else {
      gender = 0;
    }

    //age
    if (userDetails['age'] < 29) {
      age = 0;
    } else if (userDetails['age'] < 39) {
      age = 1;
    } else if (userDetails['age'] < 49) {
      age = 2;
    } else {
      age = 3;
    }

    //bmi
    bmi = userDetails['bmiCategory'].toDouble();

    //smoker
    if (userDetails['smoker'] == 'true') {
      smoker = 1;
    } else {
      smoker = 0;
    }

    //pefBest
    pefBest = double.parse(userDetails['bestpef']);

    //hours
    hours = DateTime.now().hour.toDouble();

    //inhaler
    inhaler = double.parse(await FirebaseService().getTodayMedicationCount());

    //temperature
    temperature = weather['temperature'];

    //humidity
    humidity = weather['humidity'];

    //aqi
    if (weather['aqi'].toDouble() < 51) {
      aqi = 1;
    } else if (weather['aqi'].toDouble() < 101) {
      aqi = 2;
    } else if (weather['aqi'].toDouble() < 151) {
      aqi = 3;
    } else if (weather['aqi'].toDouble() < 201) {
      aqi = 4;
    } else {
      aqi = 5;
    }

    //no2
    no2 = weather['no2'].toDouble();

    //so2
    so2 = weather['so2'].toDouble();

    //pm25
    pm25 = weather['pm2_5'].toDouble();

    //avgHeartRate
    avgHeartRate = hr['value'].toDouble();

    //avgSteps
    totalSteps = steps['value'].toDouble();
    if (avgHeartRate == 0.0) {
      NotificationServices().showNotification(4);
      return null;
    } else {
      List<double> X = [
        gender,
        age,
        bmi,
        smoker,
        pefBest,
        hours,
        temperature,
        humidity,
        aqi,
        no2,
        so2,
        pm25,
        inhaler,
        avgHeartRate,
        totalSteps
      ];
      // print(X);
      return X;
    }
  }

  // predict peak flow zones
  Future peakFlowPrediction() async {
    int result = 0;
    print('------------------------------------');
    print("RandomForestClassifier");
    List<double>? X = await prepareData();
    if (X != null) {
      // if there is sufficient data

      // initialize the model
      RandomForestClassifier r;
      // import the model
      String model = await loadModel("assets/rf_model.json");
      r = RandomForestClassifier.fromMap(json.decode(model));

      // pass data to the model
      result = r.predict(X);

      // show notification based on the prediction
      switch (result) {
        case 0:
          print('Your vitals are normal.');
          await NotificationServices().showNotification(0);
          break;
        case 1:
          print(
              'You are at risk of an asthma attack. Please take necessary precautions.');
          await NotificationServices().showNotification(1);
          break;
        case 2:
          print(
              'You are at high risk of an asthma attack. Please take action immediately.');
          await NotificationServices().showNotification(2);
          break;
      }
      // add the prediction to firebase
      await FirebaseService().addPrediction(result, X);
    }
  }
}
