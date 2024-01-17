import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../style.dart';

class NotificationsPage extends StatelessWidget {
  final String collection = "notifications";
  final String title = "Title";
  final String body = "Body";

  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Style.primaryBackground,
        appBar:
        PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight), // This is the height of AppBar.
    child: Padding(
    padding: EdgeInsets.only(top: 20.0), // Change this value to adjust the padding
    child: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Style.primaryBackground,
          title: Text(
              'Notification',
              style: GoogleFonts.outfit(
                textStyle: const TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 32,
                  color: Colors.black,
                ),
              ),
            ),
          actions: [
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
          flexibleSpace: Container(
            height: 20.0,
          ),
        ),
    ),
        ),
        body: StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection(collection).snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return const Text('Something went wrong');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Text("Loading");
                }

                return ListView(
                  children:
                      snapshot.data!.docs.map((DocumentSnapshot document) {
                    Map<String, dynamic> data =
                        document.data() as Map<String, dynamic>;
                    return ListTile(
                      title: Text(data[title]),
                      subtitle: Text(data[body]),
                    );
                  }).toList(),
                );
              },
            ),

    );
  }
}
