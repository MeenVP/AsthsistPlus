import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  // Register
  Future<User?> createUserWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential credential = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      return credential.user;
    } catch (e) {
      print(e);

    }
    return null;
  }
// Sign-in
  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential credential = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      return credential.user;
    } catch (e) {
      print(e);

    }
    return null;
  }
// get current user
  Future<User?> getCurrentUser() async {
    return _firebaseAuth.currentUser;
  }
// sign-out
  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }
}