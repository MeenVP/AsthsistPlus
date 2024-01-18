import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../style.dart'; // Import the flutter_health package

class SettingsPage extends StatelessWidget {
  final bool isDarkModeEnabled = false;
  static const String username = 'Username';
  final String age = 'Age';
  final String email = 'email@email.com';
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Style.primaryBackground,
        appBar: AppBar(
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
                  Text(
                    '$username  ',
                    style: GoogleFonts.outfit(
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 36,
                        color: Style.primaryColor,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          // Implement your edit profile functionality here
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.logout),
                        onPressed: () {
                          // Implement your edit profile functionality here
                        },
                      ),
                    ],
                  )
                ],
              ),
              Text(
                email,
                style: GoogleFonts.outfit(
                  textStyle: const TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 18,
                    color: Style.accent2,
                  ),
                ),
              ),
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
                          // Implement your Google Fit connection functionality here
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
