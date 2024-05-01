import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../backend/firebase.dart';

import '../backend/health.dart';
import '../backend/notifications.dart';
import '../backend/sklearn.dart';
import '../style.dart';
import '../widget_tree.dart';
import 'Tutorials/home_page.dart';
import 'edit_profile_page.dart'; // Import the flutter_health package

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  static const String username = 'Username';
  final String age = 'Age';
  final String email = 'email@email.com';

  String? errorMessage = '';
  bool error = false;

  @override
  void dispose() {
    super.dispose();
  }

  // sign out function
  Future<void> signOut() async {
    await FirebaseService().signOut();
  }

  // fetch data function
  Future<void> fetchData() async {
    print('fetching data...');
    try {
      await HealthService().fetchHeartRate();
      await HealthService().fetchSteps();
      await FirebaseService().addWeatherToFirebase();
    } catch (e) {
      print(e);
      setState(() {
        errorMessage = e.toString();
      });
    }
    print('data fetched');
  }

  // connect to google fit function
  Future<void> connect() async {
    try {
      await HealthService().authorize();
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
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => const WidgetTree(),
                            ),
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
                      'Fetch Data',
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
                      onPressed: () async {
                        await fetchData();
                        // await SKLearn().peakFlowPrediction();
                        // Implement your Google health connect connection functionality here
                      },
                      child: Text(
                        'Fetch',
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
                        'Predict Peak Flow',
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
                          // predict peak flow zones
                          SKLearn().peakFlowPrediction();
                        },
                        child: Text(
                          'Predict',
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
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 8, 0, 8),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'How to use this App?',
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
                          backgroundColor: Style.primaryColor,
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12))),
                        ),
                        onPressed: () {
                          // show tutorial
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const HomePageTutorial()),
                          );
                        },
                        child: Text(
                          'Go!',
                          style: GoogleFonts.outfit(
                            textStyle: const TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 18,
                              color: Style.tertiaryText,
                            ),
                          ),
                        ),
                      )
                    ]),
              ),
              const Divider(),
            ],
          ),
        ));
  }
}
