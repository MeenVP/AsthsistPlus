import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:health/health.dart';
import '../backend/firebase.dart';

import '../backend/health.dart';
import '../backend/weather.dart';
import '../style.dart';
import '../widget_tree.dart';
import 'edit_profile_page.dart'; // Import the flutter_health package

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});
  final bool isDarkModeEnabled = false;

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

enum AppState {
  DATA_NOT_FETCHED,
  FETCHING_DATA,
  DATA_READY,
  NO_DATA,
  AUTHORIZED,
  AUTH_NOT_GRANTED,
  DATA_ADDED,
  DATA_DELETED,
  DATA_NOT_ADDED,
  DATA_NOT_DELETED,
  STEPS_READY,
}

class _SettingsPageState extends State<SettingsPage> {
  AppState _state = AppState.DATA_NOT_FETCHED;
  static const String username = 'Username';
  final String age = 'Age';
  final String email = 'email@email.com';

  String? errorMessage = '';
  bool error = false;

  final isDarkModeEnabled = false;
  Future<void> signOut() async {
    await FirebaseService().signOut();
  }

  Future<void> fetchData() async {
    try{
      await Health().fetchData();
    }catch (e) {
      print(e);
      setState(() {
        errorMessage = e.toString();
      });
    }
  }

  Future<void> connect() async {
    try {
      await Health().authorize();
    } catch (e) {
      print(e);
      setState(() {
        errorMessage = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Style.primaryBackground,
        appBar: AppBar(
          surfaceTintColor: Colors.transparent,
          automaticallyImplyLeading: false,
          title: Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0, 16, 0, 0),
              child: Text(
                'Settings',
                style: GoogleFonts.outfit(
                  textStyle: const TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 32,
                    color: Colors.black,
                  ),
                ),
              )),
          backgroundColor: Style.primaryBackground,
        ),
        body: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  FutureBuilder<String>(
                      future: FirebaseService().getUserName(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          // If the Future is complete, display the data
                          return Text(
                            '${snapshot.data}',
                            style: GoogleFonts.outfit(
                              textStyle: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 28,
                                color: Style.primaryColor,
                              ),
                            ),
                          );
                        } else {
                          return const CircularProgressIndicator();
                        }
                      }),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const EditProfilePage()),
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.logout),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const WidgetTree()),
                          );
                          signOut();
                        },
                      ),
                    ],
                  )
                ],
              ),
              FutureBuilder<String>(
                  future: FirebaseService().getUserEmail(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      // If the Future is complete, display the data
                      return Text(
                        '${snapshot.data}',
                        style: GoogleFonts.outfit(
                          textStyle: const TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 18,
                            color: Style.accent2,
                          ),
                        ),
                      );
                    } else {
                      return const CircularProgressIndicator();
                    }
                  }),
              const Divider(),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 8, 0, 8),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        'Toggle Light/Dark mode',
                        style: GoogleFonts.outfit(
                          textStyle: const TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 18,
                            color: Style.primaryText,
                          ),
                        ),
                      ),
                      Switch(
                        value: isDarkModeEnabled,
                        onChanged: (value) {
                          // Implement your dark mode toggle functionality here
                        },
                        activeTrackColor: Style.primaryColor,
                        activeColor: Style.secondaryBackground,
                        inactiveTrackColor: Style.accent3,
                      ),
                    ]),
              ),
              const Divider(),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 8, 0, 8),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Connect to Google Fit',
                        style: GoogleFonts.outfit(
                          textStyle: const TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 18,
                            color: Style.primaryText,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        style: TextButton.styleFrom(
                          backgroundColor: Style.secondaryBackground,
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12))),
                        ),
                        onPressed: () {
                          // Implement your Google Fit connection functionality here
                          connect();
                        },
                        child: Text(
                          'Connect',
                          style: GoogleFonts.outfit(
                            textStyle: const TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 18,
                              color: Style.accent1,
                            ),
                          ),
                        ),
                      )
                    ]),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 8, 0, 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Connect to Health Connect',
                      style: GoogleFonts.outfit(
                        textStyle: const TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 18,
                          color: Style.primaryText,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Style.secondaryBackground,
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(12))),
                      ),
                      onPressed: () {
                        fetchData();
                        // Implement your Google health connect connection functionality here
                      },
                      child: Text(
                        'Connect',
                        style: GoogleFonts.outfit(
                          textStyle: const TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 18,
                            color: Style.accent1,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 8, 0, 8),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Connect to Apple Health Kit',
                        style: GoogleFonts.outfit(
                          textStyle: const TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 18,
                            color: Style.primaryText,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        style: TextButton.styleFrom(
                          backgroundColor: Style.secondaryBackground,
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12))),
                        ),
                        onPressed: () {
                          getHumidity();
                          getAirPollutionData();
                          FirebaseService().addWeatherToFirebase();
                        },
                        child: Text(
                          'Connect',
                          style: GoogleFonts.outfit(
                            textStyle: const TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 18,
                              color: Style.accent1,
                            ),
                          ),
                        ),
                      )
                    ]),
              ),
              const Divider(),
            ],
          ),
          // body: ListView(
          //   children: <Widget>[
          //     ListTile(
          //       title: Text(
          //         '$username ',
          //         style: GoogleFonts.outfit(
          //           textStyle: TextStyle(
          //             fontWeight: FontWeight.w700,
          //             fontSize: 28,
          //             color: Colors.deepPurpleAccent[400],
          //           ),
          //         ),
          //       ),
          //       subtitle: Text('User Email'),
          //       trailing: Row(
          //         children: [
          //           IconButton(
          //             icon: Icon(Icons.edit),
          //             onPressed: () {
          //               // Implement your edit profile functionality here
          //             },
          //           ),
          //           IconButton(
          //             icon: Icon(Icons.logout),
          //             onPressed: () {
          //               // Implement your sign out functionality here
          //             },
          //           ),],
          //       ), // Replace with actual user email
          //     ),
          //     ListTile(
          //       title: Text('Edit Profile'),
          //       trailing: IconButton(
          //         icon: Icon(Icons.edit),
          //         onPressed: () {
          //           // Implement your edit profile functionality here
          //         },
          //       ),
          //     ),
          //     ListTile(
          //       title: Text('Sign Out'),
          //       trailing: IconButton(
          //         icon: Icon(Icons.logout),
          //         onPressed: () {
          //           // Implement your sign out functionality here
          //         },
          //       ),
          //     ),
          //     SwitchListTile(
          //       title: Text('Dark Mode'),
          //       value: false, // Replace with actual value
          //       onChanged: (bool value) {
          //         // Implement your dark mode toggle functionality here
          //       },
          //     ),
          //     ListTile(
          //       title: Text('Connect to Google Fit'),
          //       trailing: IconButton(
          //         icon: Icon(Icons.fitness_center),
          //         onPressed: () {
          //           // Implement your Google Fit connection functionality here
          //         },
          //       ),
          //     ),
          //     ListTile(
          //       title: Text('Connect to Apple Health Kit'),
          //       trailing: IconButton(
          //         icon: Icon(Icons.local_hospital),
          //         onPressed: () {
          //           // Implement your Apple Health Kit connection functionality here
          //         },
          //       ),
          //     ),
          //   ],
          // ),
        ));
  }
}
