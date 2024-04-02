import 'dart:developer';
import 'package:asthsist_plus/backend/weather.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:health/health.dart';
import 'package:intl/intl.dart';

import 'notifications.dart';


class FirebaseService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  // create user
  Future<User?> createUserWithEmailAndPassword(String email, String password) async {
    await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
  }


  // add user data
  Future<void> addUserDetails({
    required String firstname,
    required String lastname,
    required  String dob,
    required String gender,
    required  weight,
    required height,
    required bestpef,
    required bool smoker,
    required String maxHR,
  }) async {
    User? user = _firebaseAuth.currentUser;
    DateTime dobTime = DateTime.parse(dob);
    // Calculate age
    final DateTime currentDate = DateTime.now();
    num age = currentDate.year - dobTime.year;
    if (currentDate.month < dobTime.month ||
        (currentDate.month == dobTime.month && currentDate.day < dobTime.day)) {
      age--;
    }

    // Calculate BMI
    double heightInMeters = double.parse(height) / 100;  // convert height to meters
    double bmi = double.parse(weight) / (heightInMeters * heightInMeters);

    // Categorize BMI
    int bmiCategory;
    if (bmi < 18.5) {
      bmiCategory = 0;  // Underweight
    } else if (bmi < 23) {
      bmiCategory = 1;  // Normal
    } else if (bmi < 25) {
      bmiCategory = 2;  // Pre-obesity
    } else {
      bmiCategory = 3;  // Obesity
    }


    final Map<String, dynamic> userData = {
      'firstname': firstname,
      'lastname': lastname,
      'dob': dob,
      'age': age,
      'gender': gender,
      'weight': weight,
      'height': height,
      'bmi':bmi,
      'bmiCategory': bmiCategory,
      'bestpef': bestpef,
      'smoker':smoker,
      'maxHR': maxHR,
    };
    final FirebaseFirestore db = FirebaseFirestore.instance;
    final CollectionReference usersRef = db.collection('users');
    final DocumentReference userDocRef = usersRef.doc(user?.uid);
    await userDocRef.set(userData).catchError((error) {
      log(error);
    });
  }

  // get user data
  Future<Map<String, dynamic>> getUserDetails() async {
    User? user = _firebaseAuth.currentUser;
    final FirebaseFirestore db = FirebaseFirestore.instance;
    final CollectionReference usersRef = db.collection('users');
    final DocumentReference userDocRef = usersRef.doc(user?.uid);

    DocumentSnapshot docSnapshot = await userDocRef.get();

    if (docSnapshot.exists) {
      Map<String, dynamic> userData = docSnapshot.data() as Map<String, dynamic>;
      return userData;
    } else {
      throw Exception('User not found!');
    }
  }

  // update user data
  Future<void> updateUserDetails({
    required String firstname,
    required String lastname,
    required String dob,
    required String gender,
    required weight,
    required height,
    required bestpef,
    required bool smoker,
    required String maxHR,
  }) async {
    User? user = _firebaseAuth.currentUser;
    DateTime dobTime = DateTime.parse(dob);
    // Calculate age
    final DateTime currentDate = DateTime.now();
    num age = currentDate.year - dobTime.year;
    if (currentDate.month < dobTime.month ||
        (currentDate.month == dobTime.month && currentDate.day < dobTime.day)) {
      age--;
    }

    // Calculate BMI
    double heightInMeters = double.parse(height) / 100;  // convert height to meters
    double bmi = double.parse(weight) / (heightInMeters * heightInMeters);

    // Categorize BMI
    int bmiCategory;
    if (bmi < 18.5) {
      bmiCategory = 0;  // Underweight
    } else if (bmi < 23) {
      bmiCategory = 1;  // Normal
    } else if (bmi < 25) {
      bmiCategory = 2;  // Pre-obesity
    } else {
      bmiCategory = 3;  // Obesity
    }

    final Map<String, dynamic> userData = {
      'firstname': firstname,
      'lastname': lastname,
      'dob': dob,
      'age': age,
      'gender': gender,
      'weight': weight,
      'height': height,
      'bmi': bmi,
      'bmiCategory': bmiCategory,
      'bestpef': bestpef,
      'smoker':smoker,
      'maxHR': maxHR,
    };

    final FirebaseFirestore db = FirebaseFirestore.instance;
    final CollectionReference usersRef = db.collection('users');
    final DocumentReference userDocRef = usersRef.doc(user?.uid);

    await userDocRef.update(userData).catchError((error) {
      log(error);
    });
  }


// Sign-in
  Future<void> signInWithEmailAndPassword(String email, String password) async {
    await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
  }


// sign-out
  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }
//add heart rate
  Future addHRToFirebase(List<HealthDataPoint> healthDataList) async {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    CollectionReference heartrate = users.doc(_firebaseAuth.currentUser?.uid).collection('heartrate');
    int maxHR = await getUserMaxHR();

    for (HealthDataPoint data in healthDataList) {
      if (double.parse(data.value.toString()) >= maxHR){
        await NotificationServices().showNotification(6);
      }
      String date = DateFormat('yyyy-MM-dd').format(data.dateFrom);
      CollectionReference entries = heartrate.doc(date).collection('entries');

      // Check for duplicates
      QuerySnapshot query = await entries.where('datetime', isEqualTo: data.dateTo).get();
      if (query.docs.isEmpty) {
        // No duplicate found, add the new data
        await entries.add({
          'datetime': data.dateTo,
          'value': data.value.toString()
        });
      }
    }
  }
  // add step
  Future addStepToFirebase(List<HealthDataPoint> healthDataList) async {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    CollectionReference steps = users.doc(_firebaseAuth.currentUser?.uid).collection('steps');

    for (HealthDataPoint data in healthDataList) {
      String date = DateFormat('yyyy-MM-dd').format(data.dateFrom);
      CollectionReference entries = steps.doc(date).collection('entries');

      // Check for duplicates
      QuerySnapshot query = await entries.where('datetime', isEqualTo: data.dateTo).get();
      if (query.docs.isEmpty) {
        // No duplicate found, add the new data
        await entries.add({
          'datetime': data.dateTo,
          'value': data.value.toString()
        });
      }
    }
  }
// add weather data
  Future addWeatherToFirebase() async {
    double temp = double.parse(await getTemperature());
    double humid = double.parse(await getHumidity());
    Map<String, dynamic> airPollution = await getAirPollutionData();
    int aqi = int.parse(await getAirQualityIndex());
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    CollectionReference weather = users.doc(_firebaseAuth.currentUser?.uid).collection('weather');

      String date = DateFormat('yyyy-MM-dd').format(DateTime.now());
      CollectionReference entries = weather.doc(date).collection('entries');

      // Check for duplicates
      QuerySnapshot query = await entries.where('datetime', isEqualTo: DateTime.now()).get();
      if (query.docs.isEmpty) {
        // No duplicate found, add the new data
        await entries.add({
          'datetime': DateTime.now(),
          'temperature': temp,
          'humidity': humid,
          'aqi': aqi,
          'no2': airPollution['no2'],
          'so2': airPollution['so2'],
          'pm2_5': airPollution['pm2_5'],
        });
    }
  }

// add medication
  Future<void> addMedication(String medication) async {
    // Get the current date and time
    DateTime now = DateTime.now();

    // Create a new DateTime object with only the year, month, day, hour, and minute
    DateTime datetime = DateTime(now.year, now.month, now.day, now.hour, now.minute);

    final Map<String, dynamic> medicationData = {
      'datetime': datetime,
      'medication_name': medication,
    };

    final FirebaseFirestore db = FirebaseFirestore.instance;
    final DocumentReference userDocRef = db.collection('users').doc(_firebaseAuth.currentUser?.uid);

    // Format the current date as 'yyyy-MM-dd'
    final String formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

    final CollectionReference dateRef = userDocRef.collection('medication').doc(formattedDate).collection('entries');

    await dateRef.add(medicationData).catchError((error) {
      log(error);
    });
  }

  Future<void> addMedicationName(String medication) async {
    final Map<String, dynamic> medicationData = {
      'medication_name': medication,
    };

    final FirebaseFirestore db = FirebaseFirestore.instance;
    final DocumentReference userDocRef = db.collection('users').doc(_firebaseAuth.currentUser?.uid);
    final CollectionReference dateRef = userDocRef.collection('medication_name');

    await dateRef.add(medicationData).catchError((error) {
      log(error);
    });
  }
  // get medication names
  Future<List<String>> getMedicationNames() async {
    // Declare a variable to store the list of medication names
    List<String> medicationNames = [];

    // Get the reference to the user document
    final FirebaseFirestore db = FirebaseFirestore.instance;
    final DocumentReference userDocRef = db.collection('users').doc(_firebaseAuth.currentUser?.uid);

    // Get the reference to the medication_name collection
    final CollectionReference dateRef = userDocRef.collection('medication_name');

    // Get the documents from the collection
    QuerySnapshot querySnapshot = await dateRef.get();

    // Map the documents to a list of medication names
    medicationNames = querySnapshot.docs.map((doc) => doc['medication_name'] as String).toList();
    // Return the list of medication names
    return medicationNames;
  }

// add peak flow values
  Future<void> addPef(String pef) async {
    // Get the current date and time
    DateTime now = DateTime.now();

    // Create a new DateTime object with only the year, month, day, hour, and minute
    DateTime datetime = DateTime(now.year, now.month, now.day, now.hour, now.minute);

    final Map<String, dynamic> pefData = {
      'datetime': datetime,
      'value': pef,
    };

    final FirebaseFirestore db = FirebaseFirestore.instance;
    final DocumentReference userDocRef = db.collection('users').doc(_firebaseAuth.currentUser?.uid);

    // Format the current date as 'yyyy-MM-dd'
    final String formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

    final CollectionReference dateRef = userDocRef.collection('pef').doc(formattedDate).collection('entries');

    await dateRef.add(pefData).catchError((error) {
      log(error);
    });
  }
  // add attack
  Future<void> addAttack(String attack) async {
    // Get the current date and time
    DateTime now = DateTime.now();

    // Create a new DateTime object with only the year, month, day, hour, and minute
    DateTime datetime = DateTime(now.year, now.month, now.day, now.hour, now.minute);

    final Map<String, dynamic> pefData = {
      'datetime': datetime,
      'severity': attack,
    };

    final FirebaseFirestore db = FirebaseFirestore.instance;
    final DocumentReference userDocRef = db.collection('users').doc(_firebaseAuth.currentUser?.uid);

    // Format the current date as 'yyyy-MM-dd'
    final String formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

    final CollectionReference dateRef = userDocRef.collection('attack').doc(formattedDate).collection('entries');

    await dateRef.add(pefData).catchError((error) {
      log(error);
    });
  }
// add control test
  Future<void> addACT(List<int?> act) async {
    // Get the current date and time
    DateTime now = DateTime.now();

    // Create a new DateTime object with only the year, month, day, hour, and minute
    DateTime datetime = DateTime(now.year, now.month, now.day, now.hour, now.minute);

    final Map<String, dynamic> pefData = {
      'datetime': datetime,
      '1': act[0],
      '2': act[1],
      '3': act[2],
      '4': act[3],
      '5': act[4],
      'sum': act.reduce((value, element) => value! + element!),
    };

    final FirebaseFirestore db = FirebaseFirestore.instance;
    final DocumentReference userDocRef = db.collection('users').doc(_firebaseAuth.currentUser?.uid);

    // Format the current date as 'yyyy-MM-dd'
    final String formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

    final CollectionReference dateRef = userDocRef.collection('act').doc(formattedDate).collection('entries');

    await dateRef.add(pefData).catchError((error) {
      log(error);
    });
  }
// add predictions
  Future<void> addPrediction(int prediction, List<double> X) async {
    // Get the current date and time
    DateTime now = DateTime.now();

    // Create a new DateTime object with only the year, month, day, hour, and minute
    DateTime datetime = DateTime(now.year, now.month, now.day, now.hour, now.minute);

    final Map<String, dynamic> medicationData = {
      'datetime': datetime,
      'data': X,
      'result': prediction,
    };

    final FirebaseFirestore db = FirebaseFirestore.instance;
    final DocumentReference userDocRef = db.collection('users').doc(_firebaseAuth.currentUser?.uid);

    // Format the current date as 'yyyy-MM-dd'
    final String formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

    final CollectionReference dateRef = userDocRef.collection('prediction').doc(formattedDate).collection('entries');

    await dateRef.add(medicationData).catchError((error) {
      log(error);
    });
  }
  //add notification
  Future<void> addNotification(String title, String body,[String? error]) async {
    print('addNotification');
    // Get the current date and time
    DateTime now = DateTime.now();

    // Create a new DateTime object with only the year, month, day, hour, and minute
    DateTime datetime = DateTime(now.year, now.month, now.day, now.hour, now.minute);

      final Map<String, dynamic> notiData = {
        'datetime': datetime,
        'title': title,
        'body': body,
        'error': error,
      };
      print('notiData');


    final FirebaseFirestore db = FirebaseFirestore.instance;
    final DocumentReference userDocRef = db.collection('users').doc(_firebaseAuth.currentUser?.uid);

    // Format the current date as 'yyyy-MM-dd'
    final String formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

    final CollectionReference dateRef = userDocRef.collection('notifications').doc(formattedDate).collection('entries');

    await dateRef.add(notiData).catchError((error) {
      log(error);
    });
  }

  //get email
  Future<String> getUserEmail() async {
    User? user = _firebaseAuth.currentUser;
    return user?.email ?? '';
  }

  //get user data
  Future<String> getUserName() async {
    User? user = _firebaseAuth.currentUser;
    final FirebaseFirestore db = FirebaseFirestore.instance;
    final CollectionReference usersRef = db.collection('users');
    final DocumentReference userDocRef = usersRef.doc(user?.uid);

    DocumentSnapshot docSnapshot = await userDocRef.get();

    if (docSnapshot.exists) {
      Map<String, dynamic> userData = docSnapshot.data() as Map<String, dynamic>;
      String userName = userData['firstname'];
      return userName;
    } else {
      log('No user data found');
      return 'No user data found';
    }
  }
  //get user best pef
  Future<int> getUserPEF() async {
    User? user = _firebaseAuth.currentUser;
    final FirebaseFirestore db = FirebaseFirestore.instance;
    final CollectionReference usersRef = db.collection('users');
    final DocumentReference userDocRef = usersRef.doc(user?.uid);

    DocumentSnapshot docSnapshot = await userDocRef.get();

    if (docSnapshot.exists) {
      Map<String, dynamic> userData = docSnapshot.data() as Map<String, dynamic>;
      int bestPEF = int.parse(userData['bestpef']);
      return bestPEF;
    } else {
      log('No user pef found');
      return 0;
    }
  }

  Future<int> getUserMaxHR() async {
    User? user = _firebaseAuth.currentUser;
    final FirebaseFirestore db = FirebaseFirestore.instance;
    final CollectionReference usersRef = db.collection('users');
    final DocumentReference userDocRef = usersRef.doc(user?.uid);

    DocumentSnapshot docSnapshot = await userDocRef.get();

    if (docSnapshot.exists) {
      Map<String, dynamic> userData = docSnapshot.data() as Map<String, dynamic>;
      int maxHR = int.parse(userData['maxHR']);
      return maxHR;
    } else {
      log('No max heart rate found');
      return 0;
    }
  }
  // get user age
  Future<int> getUserAge() async {
    User? user = _firebaseAuth.currentUser;
    final FirebaseFirestore db = FirebaseFirestore.instance;
    final CollectionReference usersRef = db.collection('users');
    final DocumentReference userDocRef = usersRef.doc(user?.uid);

    DocumentSnapshot docSnapshot = await userDocRef.get();

    if (docSnapshot.exists) {
      Map<String, dynamic> userData = docSnapshot.data() as Map<String, dynamic>;
      int age = userData['age'];
      return age;
    } else {
      log('No user age found');
      return 0;
    }
  }
// get today medication count
  Future<String> getTodayMedicationCount() async {
    User? user = FirebaseAuth.instance.currentUser;
    final FirebaseFirestore db = FirebaseFirestore.instance;

    // Format the current date as 'yyyy-MM-dd'
    final String formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

    final DocumentReference dateDocRef = db.collection('users').doc(user?.uid).collection('medication').doc(formattedDate);
    final CollectionReference entriesRef = dateDocRef.collection('entries');

    QuerySnapshot querySnapshot = await entriesRef.get();

    // The number of documents in the 'entries' collection is the number of medications for today
    String medicationCount = querySnapshot.docs.length.toString();

    return medicationCount;
  }

  // get latest pef value

  Future<Map<String,dynamic>> getLatestPEF() async {
    User? user = FirebaseAuth.instance.currentUser;
    final FirebaseFirestore db = FirebaseFirestore.instance;

    // Define the date range
    DateTime endDate = DateTime(2024, 1, 1); // Adjust as needed
    DateTime startDate = DateTime.now();
    int days = startDate.difference(endDate).inDays;

    // Initialize the latest ACT value and datetime
    String latestActValue = '';
    DateTime latestDatetime = DateTime.fromMillisecondsSinceEpoch(0);

    for (int i = 0; i <= days; i++) {
      // Format the date as 'yyyy-MM-dd'
      String formattedDate = DateFormat('yyyy-MM-dd').format(startDate.subtract(Duration(days: i)));

      // Get the 'entries' subcollection for the 'act' document of the given date
      CollectionReference entriesRef = db.collection('users').doc(user?.uid).collection('pef').doc(formattedDate).collection('entries');

      // Get the latest entry in the 'entries' subcollection
      QuerySnapshot entriesQuerySnapshot = await entriesRef.orderBy('datetime', descending: true).limit(1).get();
      List<QueryDocumentSnapshot> entriesDocs = entriesQuerySnapshot.docs;

      if (entriesDocs.isNotEmpty) {
        Map<String, dynamic> latestEntry = entriesDocs.first.data() as Map<String, dynamic>;
        DateTime entryDatetime = (latestEntry['datetime'] as Timestamp).toDate();
        latestActValue = latestEntry['value'].toString();
        latestDatetime = entryDatetime;
        break;
      }
    }

    if (latestActValue == '') {
      return {'error':'No ACT data found'};
    } else {
      return {
        'data': latestActValue,
        'time': latestDatetime,
      };
    }
  }

// get daily pef values
  Future<List<Map<String, dynamic>>> getPefValuesForDay(DateTime date) async {
    User? user = FirebaseAuth.instance.currentUser;
    final FirebaseFirestore db = FirebaseFirestore.instance;

    // Format the date as 'yyyy-MM-dd'
    final String formattedDate = DateFormat('yyyy-MM-dd').format(date);
    final DocumentReference dateDocRef = db.collection('users').doc(user?.uid).collection('pef').doc(formattedDate);
    final CollectionReference entriesRef = dateDocRef.collection('entries');

    QuerySnapshot querySnapshot = await entriesRef.orderBy('datetime', descending: true).get();
    List<Map<String, dynamic>> pefValues = [];

    for (var doc in querySnapshot.docs) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      DateTime datetime = (data['datetime'] as Timestamp).toDate();
      String value = data['value'] as String;
      pefValues.add({
        'data': value,
        'time': datetime,
      });
    }

    return pefValues;
  }
  Future<List<Map<String, dynamic>>> getPredictionForDay(DateTime date) async {
    User? user = FirebaseAuth.instance.currentUser;
    final FirebaseFirestore db = FirebaseFirestore.instance;

    // Format the date as 'yyyy-MM-dd'
    final String formattedDate = DateFormat('yyyy-MM-dd').format(date);
    final DocumentReference dateDocRef = db.collection('users').doc(user?.uid).collection('prediction').doc(formattedDate);
    final CollectionReference entriesRef = dateDocRef.collection('entries');

    QuerySnapshot querySnapshot = await entriesRef.orderBy('datetime', descending: true).get();
    List<Map<String, dynamic>> prediction = [];

    for (var doc in querySnapshot.docs) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      DateTime datetime = (data['datetime'] as Timestamp).toDate();
      String value = data['result'].toString();
      switch (data['result']) {
        case 0:
          value = 'Safe';
          break;
        case 1:
          value = 'Caution';
          break;
        case 2:
          value = 'Danger';

          break;
        default:
          value = 'error';
      }
      prediction.add({
        'data': value,
        'time': datetime,
      });
    }

    return prediction;
  }

// get daily medication
  Future<List<Map<String, dynamic>>> getMedicationForDay(DateTime date) async {
    User? user = FirebaseAuth.instance.currentUser;
    final FirebaseFirestore db = FirebaseFirestore.instance;

    // Format the date as 'yyyy-MM-dd'
    final String formattedDate = DateFormat('yyyy-MM-dd').format(date);
    final DocumentReference dateDocRef = db.collection('users').doc(user?.uid).collection('medication').doc(formattedDate);
    final CollectionReference entriesRef = dateDocRef.collection('entries');

    QuerySnapshot querySnapshot = await entriesRef.orderBy('datetime', descending: true).get();
    List<Map<String, dynamic>> pefValues = [];

    for (var doc in querySnapshot.docs) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      DateTime datetime = (data['datetime'] as Timestamp).toDate();
      String value = data['medication_name'] as String;
      pefValues.add({
        'data': value,
        'time': datetime,
      });
    }

    return pefValues;
  }

  //get weekly medication
  Future<List<Map<String, dynamic>>> getMedicationForWeek(DateTime anyDate) async {
    User? user = FirebaseAuth.instance.currentUser;
    final FirebaseFirestore db = FirebaseFirestore.instance;

    // Calculate the start and end dates of the week
    int daysFromStart = anyDate.weekday - 1; // weekday returns 1 for Monday and 7 for Sunday
    DateTime startDate = anyDate.subtract(Duration(days: daysFromStart));
    DateTime endDate = startDate.add(Duration(days: 6));

    List<Map<String, dynamic>> medicationValues = [];

    for (DateTime date = startDate; date.isBefore(endDate) || date.isAtSameMomentAs(endDate); date = date.add(Duration(days: 1))) {
      // Format the date as 'yyyy-MM-dd'
      final String formattedDate = DateFormat('yyyy-MM-dd').format(date);
      final DocumentReference dateDocRef = db.collection('users').doc(user?.uid).collection('medication').doc(formattedDate);
      final CollectionReference entriesRef = dateDocRef.collection('entries');

      QuerySnapshot querySnapshot = await entriesRef.orderBy('datetime', descending: true).get();

      for (var doc in querySnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        DateTime datetime = (data['datetime'] as Timestamp).toDate();
        String value = data['medication_name'] as String;
        medicationValues.add({
          'data': value,
          'time': datetime,
        });
      }
    }

    return medicationValues;
  }

  Future<List<int>> getWeeklyMedication() async {
    List<int> weeklyMedications = List.filled(7, 0); // Initialize list with 7 zeros
    DateTime now = DateTime.now();
    DateTime startOfWeek = now.subtract(Duration(days: now.weekday - 1)); // Get the start of the week (Monday)

    for (int i = 0; i < 7; i++) {
      DateTime day = startOfWeek.add(Duration(days: i));
      List<Map<String, dynamic>> dailyMedications = await getMedicationForDay(day);
      int totalMedications = dailyMedications.length;
      weeklyMedications[i] = totalMedications;
    }
    return weeklyMedications;
  }


  //get latest heart rate
  Future<Map<String, dynamic>> getLatestHR() async {
    User? user = FirebaseAuth.instance.currentUser;
    final FirebaseFirestore db = FirebaseFirestore.instance;

    // Format the current date as 'yyyy-MM-dd'
    final String formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

    final DocumentReference dateDocRef = db.collection('users').doc(user?.uid).collection('heartrate').doc(formattedDate);
    final CollectionReference entriesRef = dateDocRef.collection('entries');

    QuerySnapshot querySnapshot = await entriesRef.orderBy('datetime', descending: true).limit(1).get();

      Map<String, dynamic> latestHRData = querySnapshot.docs.first.data() as Map<String, dynamic>;
      return latestHRData;
  }

  //get daily heart rate
  Future<List<Map<String, dynamic>>> getHRForDay(DateTime date) async {
    User? user = FirebaseAuth.instance.currentUser;
    final FirebaseFirestore db = FirebaseFirestore.instance;

    // Format the date as 'yyyy-MM-dd'
    final String formattedDate = DateFormat('yyyy-MM-dd').format(date);
    final DocumentReference dateDocRef = db.collection('users').doc(user?.uid).collection('heartrate').doc(formattedDate);
    final CollectionReference entriesRef = dateDocRef.collection('entries');

    QuerySnapshot querySnapshot = await entriesRef.orderBy('datetime', descending: true).get();
    List<Map<String, dynamic>> hrValues = [];

    for (var doc in querySnapshot.docs) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      DateTime datetime = (data['datetime'] as Timestamp).toDate();
      var value = data['value'].toString().split('.');
      String hr = value[0];
      hrValues.add({
        'data': hr,
        'time': datetime,
      });
    }

    return hrValues;
  }
  // get weekly heart rate
  Future<List<Map<String, dynamic>>> getHRForWeek(DateTime anyDate) async {
    User? user = FirebaseAuth.instance.currentUser;
    final FirebaseFirestore db = FirebaseFirestore.instance;

    // Calculate the start and end dates of the week
    int daysFromStart = anyDate.weekday - 1; // weekday returns 1 for Monday and 7 for Sunday
    DateTime startDate = anyDate.subtract(Duration(days: daysFromStart));
    DateTime endDate = startDate.add(Duration(days: 6));

    List<Map<String, dynamic>> hrValues = [];

    for (DateTime date = startDate; date.isBefore(endDate) || date.isAtSameMomentAs(endDate); date = date.add(Duration(days: 1))) {
      // Format the date as 'yyyy-MM-dd'
      final String formattedDate = DateFormat('yyyy-MM-dd').format(date);
      final DocumentReference dateDocRef = db.collection('users').doc(user?.uid).collection('heartrate').doc(formattedDate);
      final CollectionReference entriesRef = dateDocRef.collection('entries');

      QuerySnapshot querySnapshot = await entriesRef.orderBy('datetime', descending: true).get();

      for (var doc in querySnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        DateTime datetime = (data['datetime'] as Timestamp).toDate();
        var value = data['value'].toString().split('.');
        String hr = value[0];
        hrValues.add({
          'data': '$hr bpm',
          'time': datetime,
        });
      }
    }

    return hrValues;
  }
  // get latest steps
  Future<Map<String, dynamic>> getLatestSteps() async {
    User? user = FirebaseAuth.instance.currentUser;
    final FirebaseFirestore db = FirebaseFirestore.instance;

    // Format the current date as 'yyyy-MM-dd'
    final String formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

    final DocumentReference dateDocRef = db.collection('users').doc(user?.uid).collection('steps').doc(formattedDate);
    final CollectionReference entriesRef = dateDocRef.collection('entries');

    QuerySnapshot querySnapshot = await entriesRef.orderBy('datetime', descending: true).limit(1).get();

    Map<String, dynamic> latestSteps = querySnapshot.docs.first.data() as Map<String, dynamic>;
    return latestSteps;
  }

  Future<int> getTotalStepsForToday() async {
    DateTime today = DateTime.now();
    List<Map<String, dynamic>> dailySteps = await getStepsForDay(today);
    int totalSteps = 0;
    for (var step in dailySteps) {
      totalSteps += int.parse(step['data']);
    }
    return totalSteps;
  }

  // get daily steps
  Future<List<Map<String, dynamic>>> getStepsForDay(DateTime date) async {
    User? user = FirebaseAuth.instance.currentUser;
    final FirebaseFirestore db = FirebaseFirestore.instance;

    // Format the date as 'yyyy-MM-dd'
    final String formattedDate = DateFormat('yyyy-MM-dd').format(date);
    final DocumentReference dateDocRef = db.collection('users')
        .doc(user?.uid)
        .collection('steps')
        .doc(formattedDate);
    final CollectionReference entriesRef = dateDocRef.collection('entries');

    QuerySnapshot querySnapshot = await entriesRef.orderBy(
        'datetime', descending: true).get();
    List<Map<String, dynamic>> hrValues = [];

    for (var doc in querySnapshot.docs) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      DateTime datetime = (data['datetime'] as Timestamp).toDate();
      var value = data['value'].toString().split('.');
      String steps = value[0];
      hrValues.add({
        'data': steps,
        'time': datetime,
      });
    }

    return hrValues;
  }

  //get weekly steps
  Future<List<int>> getWeeklySteps() async {
    List<int> weeklySteps = List.filled(7, 0); // Initialize list with 7 zeros
    DateTime now = DateTime.now();
    DateTime startOfWeek = now.subtract(Duration(days: now.weekday - 1)); // Get the start of the week (Monday)

    for (int i = 0; i < 7; i++) {
      DateTime day = startOfWeek.add(Duration(days: i));
      List<Map<String, dynamic>> dailySteps = await getStepsForDay(day);
      int totalSteps = dailySteps.fold(0, (sum, item) => sum + int.parse(item['data']));
      weeklySteps[i] = totalSteps;
    }

    return weeklySteps;
  }

  //get average steps for a week
  Future<double> getAverageWeeklySteps() async {
    List<int> weeklySteps = await getWeeklySteps();
    int totalSteps = weeklySteps.fold(0, (sum, item) => sum + item);
    double averageSteps = totalSteps / 7;
    return averageSteps;
  }




  // get daily attack
  Future<List<Map<String, dynamic>>> getAttackForDay(DateTime date) async {
    User? user = FirebaseAuth.instance.currentUser;
    final FirebaseFirestore db = FirebaseFirestore.instance;

    // Format the date as 'yyyy-MM-dd'
    final String formattedDate = DateFormat('yyyy-MM-dd').format(date);
    final DocumentReference dateDocRef = db.collection('users').doc(user?.uid).collection('attack').doc(formattedDate);
    final CollectionReference entriesRef = dateDocRef.collection('entries');

    QuerySnapshot querySnapshot = await entriesRef.orderBy('datetime', descending: true).get();
    List<Map<String, dynamic>> attack = [];

    for (var doc in querySnapshot.docs) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      DateTime datetime = (data['datetime'] as Timestamp).toDate();
      String value = data['severity'] as String;
      attack.add({
        'data': value,
        'time': datetime,
      });
    }

    return attack;
  }

// get weekly attack
  Future<List<Map<String,dynamic>>> getWeeklyAttacks() async {
    List<Map<String,dynamic>> weeklyAttack = []; // Initialize list with 7 zeros
    DateTime now = DateTime.now();
    DateTime startOfWeek = now.subtract(Duration(days: now.weekday - 1)); // Get the start of the week (Monday)

    for (int i = 0; i < 7; i++) {
      DateTime day = startOfWeek.add(Duration(days: i));
      Map<String, int> dailyData = {'Mild': 0, 'Moderate': 0, 'Severe': 0, 'Total': 0};
      List<Map<String, dynamic>> dailyAttack = await getAttackForDay(day);
      for (var attack in dailyAttack) {
        String severity = attack['data'];
        if (severity == 'Moderate'){
          dailyData['Moderate'] = (dailyData['Moderate'] ?? 0) + 1;
        } else if (severity == 'Severe'){
          dailyData['Severe'] = (dailyData['Severe'] ?? 0) + 1;
        } else {
          dailyData['Mild'] = (dailyData['Mild'] ?? 0) + 1;
        }
        dailyData['Total'] = (dailyData['Total'] ?? 0) + 1;
      }
      weeklyAttack.add(dailyData);
    }
    return weeklyAttack;
  }

  // get weekly total severity of attacks
  Future<Map<String,int>> getTotalSeverityForWeek()async{
    DateTime now = DateTime.now();
    DateTime startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    Map<String,int> weeklySeverity = {'Mild': 0, 'Moderate': 0, 'Severe': 0, 'Total': 0};
    for (int i = 0; i < 7; i++) {
      DateTime day = startOfWeek.add(Duration(days: i));
      List<Map<String, dynamic>> dailyAttack = await getAttackForDay(day);
      for (var attack in dailyAttack) {
        String severity = attack['data'];
        if (severity == 'Moderate'){
          weeklySeverity['Moderate'] = (weeklySeverity['Moderate'] ?? 0) + 1;
        } else if (severity == 'Severe'){
          weeklySeverity['Severe'] = (weeklySeverity['Severe'] ?? 0) + 1;
        } else {
          weeklySeverity['Mild'] = (weeklySeverity['Mild'] ?? 0) + 1;
        }
        weeklySeverity['Total'] = (weeklySeverity['Total'] ?? 0) + 1;
      }
    }
    return weeklySeverity;

  }

//get latest asthma control test
  Future<Map<String,dynamic>> getLatestAct() async {
    User? user = FirebaseAuth.instance.currentUser;
    final FirebaseFirestore db = FirebaseFirestore.instance;

    // Define the date range
    DateTime endDate = DateTime(2024, 1, 1); // Adjust as needed
    DateTime startDate = DateTime.now();
    int days = startDate.difference(endDate).inDays;

    // Initialize the latest ACT value and datetime
    String latestActValue = '';
    DateTime latestDatetime = DateTime.fromMillisecondsSinceEpoch(0);

    for (int i = 0; i <= days; i++) {
      // Format the date as 'yyyy-MM-dd'
      String formattedDate = DateFormat('yyyy-MM-dd').format(startDate.subtract(Duration(days: i)));

      // Get the 'entries' subcollection for the 'act' document of the given date
      CollectionReference entriesRef = db.collection('users').doc(user?.uid).collection('act').doc(formattedDate).collection('entries');

      // Get the latest entry in the 'entries' subcollection
      QuerySnapshot entriesQuerySnapshot = await entriesRef.orderBy('datetime', descending: true).limit(1).get();
      List<QueryDocumentSnapshot> entriesDocs = entriesQuerySnapshot.docs;

      if (entriesDocs.isNotEmpty) {
        Map<String, dynamic> latestEntry = entriesDocs.first.data() as Map<String, dynamic>;
        DateTime entryDatetime = (latestEntry['datetime'] as Timestamp).toDate();
        latestActValue = latestEntry['sum'].toString();
        latestDatetime = entryDatetime;
        break;
      }
    }

    if (latestActValue == '') {
      return {'error':'No ACT data found'};
    } else {
      return {
        'data': latestActValue,
        'time': latestDatetime,
      };
    }
  }


// get daily asthma control test
  Future<List<Map<String, dynamic>>> getActForDay(DateTime date) async {
    User? user = FirebaseAuth.instance.currentUser;
    final FirebaseFirestore db = FirebaseFirestore.instance;

    // Format the date as 'yyyy-MM-dd'
    final String formattedDate = DateFormat('yyyy-MM-dd').format(date);
    final DocumentReference dateDocRef = db.collection('users').doc(user?.uid).collection('act').doc(formattedDate);
    final CollectionReference entriesRef = dateDocRef.collection('entries');

    QuerySnapshot querySnapshot = await entriesRef.orderBy('datetime', descending: true).get();
    List<Map<String, dynamic>> act = [];

    for (var doc in querySnapshot.docs) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      DateTime datetime = (data['datetime'] as Timestamp).toDate();
      String value = data['sum'].toString();
      act.add({
        'data': value,
        'time': datetime,
      });
    }

    return act;
  }

  //get latest weather
  Future<Map<String, dynamic>> getLatestWeather() async {
    User? user = FirebaseAuth.instance.currentUser;
    final FirebaseFirestore db = FirebaseFirestore.instance;

    // Format the date as 'yyyy-MM-dd'
    final String formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final DocumentReference dateDocRef = db.collection('users').doc(user?.uid).collection('weather').doc(formattedDate);
    final CollectionReference entriesRef = dateDocRef.collection('entries');

    QuerySnapshot querySnapshot = await entriesRef.orderBy('datetime', descending: true).limit(1).get();

    if (querySnapshot.docs.isEmpty) {
      // Handle case when no weather data is available for the given day
      return {'error': 'No weather data found for $formattedDate'};
    }

    Map<String, dynamic> latestWeather = querySnapshot.docs.first.data() as Map<String, dynamic>;
    return latestWeather;
  }


  Future<List<Map<String, dynamic>>> getWeatherForDay(DateTime date) async {
    User? user = FirebaseAuth.instance.currentUser;
    final FirebaseFirestore db = FirebaseFirestore.instance;

    // Format the date as 'yyyy-MM-dd'
    final String formattedDate = DateFormat('yyyy-MM-dd').format(date);
    final DocumentReference dateDocRef = db.collection('users').doc(user?.uid).collection('weather').doc(formattedDate);
    final CollectionReference entriesRef = dateDocRef.collection('entries');

    QuerySnapshot querySnapshot = await entriesRef.orderBy('datetime', descending: true).get();
    List<Map<String, dynamic>> weather = [];

    for (var doc in querySnapshot.docs) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      DateTime datetime = (data['datetime'] as Timestamp).toDate();
      String value = '${data['temperature'].toString()}°C, ${data['humidity'.toString()]}%, AQI:${data['aqi'].toString()}';
      weather.add({
        'data': value,
        'time': datetime,
      });
    }

    return weather;
  }
  //get latest temperature
  Future<String> getLatestTemperature() async {
    // Get a reference to the user's 'weather' collection
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    CollectionReference weather = users.doc(_firebaseAuth.currentUser?.uid).collection('weather');
    // Get today's date
    String date = DateFormat('yyyy-MM-dd').format(DateTime.now());

    // Get a reference to today's 'entries' collection
    CollectionReference entries = weather.doc(date).collection('entries');

    // Get the last entry
    QuerySnapshot query = await entries.orderBy('datetime', descending: true).limit(1).get();
    DocumentSnapshot lastEntry = query.docs.first;

    // Extract the temperature and return it
    double temperature = lastEntry['temperature'];
    return temperature.toString();
  }
  //get latest humidity
  Future<String> getLatestAQI() async {
    // Get a reference to the user's 'weather' collection
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    CollectionReference weather = users.doc(_firebaseAuth.currentUser?.uid).collection('weather');

    // Get today's date
    String date = DateFormat('yyyy-MM-dd').format(DateTime.now());

    // Get a reference to today's 'entries' collection
    CollectionReference entries = weather.doc(date).collection('entries');

    // Get the last entry
    QuerySnapshot query = await entries.orderBy('datetime', descending: true).limit(1).get();
    DocumentSnapshot lastEntry = query.docs.first;

    // Extract the humidity and return it
    int aqi = lastEntry['aqi'];
    return aqi.toString();
  }

  Future<Map<String, dynamic>> getAverageStepsInPastHour() async {
    User? user = FirebaseAuth.instance.currentUser;
    final FirebaseFirestore db = FirebaseFirestore.instance;

    // Get the current time and time an hour ago
    final DateTime now = DateTime.now();
    final DateTime anHourAgo = now.subtract(Duration(hours: 1));

    final DocumentReference dateDocRef = db.collection('users')
        .doc(user?.uid)
        .collection('steps')
        .doc(DateFormat('yyyy-MM-dd').format(now));
    final CollectionReference entriesRef = dateDocRef.collection('entries');

    // Get all entries in the past hour
    QuerySnapshot querySnapshot = await entriesRef.where('datetime', isGreaterThanOrEqualTo: anHourAgo).get();

    // Calculate the average steps in the past hour
    if (querySnapshot.docs.isNotEmpty) {
      double totalSteps = 0;
      for (var doc in querySnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        totalSteps += double.parse(data['value']);
      }
      double averageSteps = totalSteps / querySnapshot.docs.length;

      return {
        'datetime': DateFormat('yyyy-MM-dd HH:mm:ss').format(now),
        'value': averageSteps,
      };
    } else {
      return {
        'datetime': DateFormat('yyyy-MM-dd HH:mm:ss').format(now),
        'value': 0,
      };
    }
  }
  Future<Map<String, dynamic>> getAverageHrInPastHour() async {
    User? user = FirebaseAuth.instance.currentUser;
    final FirebaseFirestore db = FirebaseFirestore.instance;

    // Get the current time and time an hour ago
    final DateTime now = DateTime.now();
    final DateTime anHourAgo = now.subtract(Duration(hours: 1));

    final DocumentReference dateDocRef = db.collection('users')
        .doc(user?.uid)
        .collection('heartrate')
        .doc(DateFormat('yyyy-MM-dd').format(now));
    final CollectionReference entriesRef = dateDocRef.collection('entries');

    // Get all entries in the past hour
    QuerySnapshot querySnapshot = await entriesRef.where('datetime', isGreaterThanOrEqualTo: anHourAgo).get();

    // Calculate the average heart rate in the past hour
    if (querySnapshot.docs.isNotEmpty) {
      double totalHr = 0.0;
      for (var doc in querySnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        totalHr += double.parse(data['value']);
      }
      double averageHr = totalHr / querySnapshot.docs.length;
      print ('$averageHr BPM');
      return {
        'datetime': DateFormat('yyyy-MM-dd HH:mm:ss').format(now),
        'value': averageHr,
      };
    } else {
      print('error');
      return {
        'datetime': DateFormat('yyyy-MM-dd HH:mm:ss').format(now),
        'value': 0.0,
      };
    }
  }

  Future<Map<String, dynamic>> getLatestPrediction() async {
    User? user = FirebaseAuth.instance.currentUser;
    final FirebaseFirestore db = FirebaseFirestore.instance;

    // Format the current date as 'yyyy-MM-dd'
    final String formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final String updateDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());

    final DocumentReference dateDocRef = db.collection('users').doc(user?.uid).collection('prediction').doc(formattedDate);
    final CollectionReference entriesRef = dateDocRef.collection('entries');

    QuerySnapshot querySnapshot = await entriesRef.orderBy('datetime', descending: true).limit(1).get();

    if (querySnapshot.docs.isNotEmpty) {
      Map<String, dynamic> latestPrediction = querySnapshot.docs.first.data() as Map<String, dynamic>;
      return {
        'datetime': DateTime.parse(latestPrediction['datetime'].toDate().toString()),
        'value': latestPrediction['result'],
      };
    } else {
      return {
        'datetime': DateTime.parse(updateDate.toString()),
        'value': 4,
      };
    }
  }
  //get past notification
  Future<List<Map<String, dynamic>>> getNotificationsForLast24Hours() async {
    User? user = FirebaseAuth.instance.currentUser;
    final FirebaseFirestore db = FirebaseFirestore.instance;

    // Get the current time and subtract 24 hours to get the start of the period
    final DateTime now = DateTime.now();

    final String formattedDate = DateFormat('yyyy-MM-dd').format(now);
    final DocumentReference dateDocRef = db.collection('users').doc(user?.uid).collection('notifications').doc(formattedDate);
    final CollectionReference entriesRef = dateDocRef.collection('entries');

    QuerySnapshot querySnapshot = await entriesRef.orderBy('datetime', descending: true).get();

    List<Map<String, dynamic>> notificationData = [];

    for (var doc in querySnapshot.docs) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      DateTime datetime = (data['datetime'] as Timestamp).toDate();
      notificationData.add({
        'title': data['title'],
        'body': data['body'],
        'time': datetime,
      });
    }
    return notificationData;
  }

}

