import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  // Register
  Future<User?> createUserWithEmailAndPassword(String email, String password) async {
    await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
  }

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();
  // add user data
  Future<void> addUserDetails({
      required String uid,
    required String firstname,
    required String lastname,
    required DateTime dob,
    required String gender,
    required  weight,
    required height,
  }) async {
    User? user = _firebaseAuth.currentUser;
    final Map<String, dynamic> userData = {
      'firstname': firstname,
      'lastname': lastname,
      'dob': dob,
      'gender': gender,
      'weight': weight,
      'height': height,
    };
    final FirebaseFirestore db = FirebaseFirestore.instance;
    final CollectionReference usersRef = db.collection('users');
    final DocumentReference userDocRef = usersRef.doc(user?.uid);
    userDocRef.set(userData).catchError((error) {
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
}