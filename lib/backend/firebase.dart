import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:health/health.dart';
import 'package:intl/intl.dart';


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
    required  dob,
    required String gender,
    required  weight,
    required height,
    required bestpef,
  }) async {
    User? user = _firebaseAuth.currentUser;
    final Map<String, dynamic> userData = {
      'firstname': firstname,
      'lastname': lastname,
      'dob': dob,
      'gender': gender,
      'weight': weight,
      'height': height,
      'bestpef': bestpef,
    };
    final FirebaseFirestore db = FirebaseFirestore.instance;
    final CollectionReference usersRef = db.collection('users');
    final DocumentReference userDocRef = usersRef.doc(user?.uid);
    await userDocRef.set(userData).catchError((error) {
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

    for (HealthDataPoint data in healthDataList) {
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
  Future<String> getLatestPefValue() async {
    User? user = FirebaseAuth.instance.currentUser;
    final FirebaseFirestore db = FirebaseFirestore.instance;

    // Format the current date as 'yyyy-MM-dd'
    final String formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

    final DocumentReference dateDocRef = db.collection('users').doc(user?.uid).collection('pef').doc(formattedDate);
    final CollectionReference entriesRef = dateDocRef.collection('entries');

    QuerySnapshot querySnapshot = await entriesRef.orderBy('datetime', descending: true).limit(1).get();

    if (querySnapshot.docs.isNotEmpty) {
      Map<String, dynamic> latestPefData = querySnapshot.docs.first.data() as Map<String, dynamic>;
      return latestPefData['value'] as String;
    } else {
      log('No PEF data found for today');
      return 'NaN';
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

  //get latest heart rate
  Future<String> getLatestHR() async {
    User? user = FirebaseAuth.instance.currentUser;
    final FirebaseFirestore db = FirebaseFirestore.instance;

    // Format the current date as 'yyyy-MM-dd'
    final String formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

    final DocumentReference dateDocRef = db.collection('users').doc(user?.uid).collection('heartrate').doc(formattedDate);
    final CollectionReference entriesRef = dateDocRef.collection('entries');

    QuerySnapshot querySnapshot = await entriesRef.orderBy('datetime', descending: true).limit(1).get();

    if (querySnapshot.docs.isNotEmpty) {
      Map<String, dynamic> latestHRData = querySnapshot.docs.first.data() as Map<String, dynamic>;
      var hr = latestHRData['value'].toString().split('.');
      return hr[0];
    } else {
      log('No HR found for today');
      return 'NaN';
    }



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
        'data': '$hr bpm',
        'time': datetime,
      });
    }

    return hrValues;
  }


  // get






}

