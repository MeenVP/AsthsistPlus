import 'package:cloud_firestore/cloud_firestore.dart';
class FirestoreService{

  //get users colleaction
  final CollectionReference usersCollection = FirebaseFirestore.instance.collection('users');

  //add new user
  Future<void> addUser(String uid, String name, String email, String password) async {
    return await usersCollection.doc(uid).set({
      'name': name,
      'email': email,
      'password': password,
    });
  }
}