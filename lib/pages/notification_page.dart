import 'package:asthsist_plus/backend/firebase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../style.dart';

Future<List<Map<String, dynamic>>> updateData() async {
  var notifications = await FirebaseService().getNotificationsForLast24Hours();
  return notifications;
}

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
      surfaceTintColor: Colors.transparent,
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
        body: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
          child: FutureBuilder(
            future: updateData(), // Use your function here
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return const Center(child: Text('Error in fetching data'));
              } else {
                if (snapshot.data == null || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No data'));
                } else {
                  return Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                    child: ListView.builder(
                      itemCount: snapshot.data?.length ?? 0,
                      itemBuilder: (context, index) {
                        final item = snapshot.data![index];
                        return Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 4),
                          child: Material(
                            borderRadius: const BorderRadius.all(Radius.circular(8)),
                            elevation: 0,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Style.secondaryBackground,
                              ),
                              child: ListTile(
                                title: Text(
                                    item['title'],
                                  style: GoogleFonts.outfit(
                                    textStyle: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 18,
                                      color: Style.primaryText,
                                    ),
                                  )
                                ),
                                subtitle: Text(
                                    item['body'],
                                style: GoogleFonts.outfit(
                                      textStyle: const TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 14,
                                        color: Style.accent1,
                                      ),
                                    )
                                ),
                                trailing: Text(
                                    DateFormat('HH:mm').format(item['time']),
                                style:
                                GoogleFonts.outfit(
                                  textStyle: const TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 18,
                                    color: Style.accent1,
                                  ),
                                )
                              ),
                            ),
                          ),
                        ));
                      },
                    ),
                  );
                }
              }
            },
          )
        ));
  }
}
