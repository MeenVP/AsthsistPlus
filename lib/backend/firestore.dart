import 'package:cloud_firestore/cloud_firestore.dart';
class FirestoreService{

  Future addUserDetails(String uid, String name, String email, String phone, String address) async {
    return await FirebaseFirestore.instance.collection('users').doc(uid).set({
      'name': name,
      'email': email,
      'phone': phone,
      'address': address,
    });
  }
}