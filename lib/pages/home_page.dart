import 'package:asthsist_plus/backend/firebase.dart';
import 'package:asthsist_plus/backend/weather.dart';
import 'package:asthsist_plus/pages/asthma_control_test_page.dart';
import 'package:asthsist_plus/pages/pef_info.dart';
import 'package:asthsist_plus/style.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../backend/sklearn.dart';
import 'health_info.dart';
import 'navigation_bar.dart';
import 'notification_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});


  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  void _showAddAttackDialog(BuildContext context) {
    String? errorMessage = '';
    bool error = false;
    String selectedSeverity = 'Mild'; // Set default to 'Mild'

    List<String> severities = ['Mild', 'Moderate', 'Severe'];

    Future<void> addAttack() async {
      try {
        await FirebaseService().addAttack(selectedSeverity);
        Navigator.of(context).pop();
        setState(() {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Asthma attack added successfully!"),
          ));
        });
      } on FirebaseAuthException catch (e) {
        print(e.message);
        setState(() {
          errorMessage = e.message;
        });
      }
    }

    Widget showError() {
      return Text(
        errorMessage!,
        style: GoogleFonts.outfit(
          textStyle: const TextStyle(
            fontWeight: FontWeight.normal,
            fontSize: 18,
            color: Colors.red,
          ),
        ),
      );
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder( // Add this line
          builder: (BuildContext context, StateSetter setState) { // Modify this line
            return AlertDialog(
              backgroundColor: Style.primaryBackground,
              surfaceTintColor: Colors.transparent,
              title: Container(
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20)),
                    color: Style.primaryColor),
                // color: Colors.red,
                child: Padding(
                  padding: EdgeInsetsDirectional.all(20), // Add horizontal padding
                  child: Text(
                    'Add Attack',
                    style: GoogleFonts.outfit(
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.normal,
                        color: Style.tertiaryText,
                      ),
                    ),
                  ),
                ),
              ),
              titlePadding: const EdgeInsets.all(0),
              content: SizedBox(
                height: 200, // Increase height to accommodate radio buttons
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    showError(),
                    ...severities.map((severity) => RadioListTile<String>(
                      title: Text(severity),
                      value: severity,
                      groupValue: selectedSeverity,
                      onChanged: (String? value) {
                        setState(() {
                          selectedSeverity = value!;
                        });
                      },
                    )).toList(),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text('Cancel',
                    style: GoogleFonts.outfit(
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 16,
                        color: Style.primaryColor,
                      ),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: Text('Add',
                    style: GoogleFonts.outfit(
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 16,
                        color: Style.primaryColor,
                      ),
                    ),
                  ),
                  onPressed: () async {
                    final navigator = Navigator.of(context);
                    final buildContext = context;
                    await addAttack();
                    errorMessage == '' ? error = false : error = true;
                    setState(() {});
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showAddPeakFlowDialog(BuildContext context) {
    TextEditingController peakFlowController = TextEditingController();
    String? errorMessage = '';
    bool error = false;

    Future<void> addPeakFlow() async {
      try {
        await FirebaseService().addPef(peakFlowController.text);
        Navigator.of(context).pop();
      } on FirebaseAuthException catch (e) {
        print(e.message);
        setState(() {
          errorMessage = e.message;
        });
      }
    }

    Widget showError() {
      return Text(
        errorMessage!,
        style: GoogleFonts.outfit(
          textStyle: const TextStyle(
            fontWeight: FontWeight.normal,
            fontSize: 18,
            color: Colors.red,
          ),
        ),
      );
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Style.primaryBackground,
          surfaceTintColor: Colors.transparent,
          title: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20)),
                color: Style.primaryColor),
            // color: Colors.red,
            child: Padding(
              padding: EdgeInsetsDirectional.all(20), // Add horizontal padding
              child: Text(
                'Add Peak Flow Data',
                style: GoogleFonts.outfit(
                  textStyle: const TextStyle(
                    fontWeight: FontWeight.normal,
                    color: Style.tertiaryText,
                  ),
                ),
              ),
            ),
          ),
          titlePadding: const EdgeInsets.all(0),
          // title: Text('Add Peak Flow Data'),
          content: SizedBox(
            height: 100,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                showError(),
                TextField(
                  controller: peakFlowController,
                  keyboardType: TextInputType.number,
                  decoration:
                      const InputDecoration(hintText: "Enter peak flow value"),
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly // Only allow digits
                  ],
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel',
                style: GoogleFonts.outfit(
                  textStyle: const TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 16,
                    color: Style.primaryColor,
                  ),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Add',
                style: GoogleFonts.outfit(
                  textStyle: const TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 16,
                    color: Style.primaryColor,
                  ),
                ),
              ),
              onPressed: () async {
                final navigator = Navigator.of(context);
                final buildContext = context;
                await addPeakFlow();
                errorMessage == '' ? error = false : error = true;
                navigator.push(
                  MaterialPageRoute(builder: (context) => const PeakFlowInfoPage(showBackButton: true)),
                );
              },
            ),
          ],
        );
      },
    );
  }
  Widget showPEFPrediction(){
    return FutureBuilder<Map<String,dynamic>>(
      future: FirebaseService().getLatestPrediction(),
      builder: (BuildContext context, AsyncSnapshot<Map<String,dynamic>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(
            color: Style.primaryColor,
          );  // or your custom loader
        } else if (snapshot.hasError) {
          // return
          return Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
                color: Style.primaryColor),
            child: Column(
              children: [
                Align(
                  alignment: const AlignmentDirectional(-1, -1),
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(
                        16, 10, 0, 0),
                    child: Text(
                      'Your current risk',
                      style: GoogleFonts.outfit(
                        textStyle: const TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 14,
                          color: Style.tertiaryText,
                        ),
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: const AlignmentDirectional(0, 0),
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(
                        0, 32, 0, 32),
                    child: Text(
                      'Error: ${snapshot.error}',
                      style: GoogleFonts.outfit(
                        textStyle: const TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 24,
                          color: Style.tertiaryText,
                        ),
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: const AlignmentDirectional(1, 1),
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(
                        0, 0, 10, 10),
                    child: Text(
                      '-_-\'',
                      textAlign: TextAlign.end,
                      style: GoogleFonts.outfit(
                        textStyle: const TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 14,
                          color: Style.tertiaryText,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        } else {
          Map<String, dynamic>? data = snapshot.data;
          var prediction = data?['value'];
          var updateTime = DateFormat('HH:mm, dd MMM yyyy').format(data?['datetime']);
          String riskLevel;
          String recommendation;
          double fontSize = 48;
          Color riskColor;

          switch (prediction) {
            case 0:
              riskLevel = 'SAFE';
              riskColor = Style.success;
              recommendation = 'Keep up the good work!';
              break;
            case 1:
              riskLevel = 'CAUTION';
              riskColor = Style.warning;
              recommendation = 'Take your medication';
              break;
            case 2:
              riskLevel = 'DANGER';
              riskColor = Style.danger;
              recommendation = 'Seek medical attention';
              break;
            default:
              riskLevel = 'Insufficient data';
              riskColor = Style.primaryColor;
              recommendation = 'Error';
              fontSize = 24;
          }

          return Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
                color: riskColor),
            child: Column(
              children: [
                Align(
                  alignment: const AlignmentDirectional(-1, -1),
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(
                        16, 10, 0, 0),
                    child: Text(
                      'Your current risk',
                      style: GoogleFonts.outfit(
                        textStyle: const TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 14,
                          color: Style.tertiaryText,
                        ),
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: const AlignmentDirectional(0, 0),
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(
                        0, 32, 0, 32),
                    child: Text(
                      riskLevel,
                      style: GoogleFonts.outfit(
                        textStyle: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: fontSize,
                          color: Style.tertiaryText,
                        ),
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: const AlignmentDirectional(1, 1),
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(
                        0, 0, 10, 10),
                    child: Text(
                      updateTime.toString(),
                      textAlign: TextAlign.end,
                      style: GoogleFonts.outfit(
                        textStyle: const TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 14,
                          color: Style.tertiaryText,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }

  void _showAddMedicationDialog(BuildContext context) async{
    // Declare a variable to store the selected medicine name
    String? selectedMedicine;
    List<String> medicationNames = await FirebaseService().getMedicationNames();
    print(medicationNames);
    // Declare a text editing controller for the medicine name input
    TextEditingController medicationController = TextEditingController();

    // Declare a variable to store the error message
    String? errorMessage = '';

    // Declare a function to add a new medication to the database
    Future<void> addMedication(String name) async {
      try {
        await FirebaseService().addMedication(name);
        Navigator.of(context).pop();
        setState(() {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Medicine added successfully!"),
          ));
        });
      } on FirebaseAuthException catch (e) {
        print(e.message);
        setState(() {
          errorMessage = e.message;
        });
      }
    }

    // Declare a widget to show the error message
    Widget showError() {
      return Text(
        errorMessage!,
        style: GoogleFonts.outfit(
          textStyle: const TextStyle(
            fontWeight: FontWeight.normal,
            fontSize: 18,
            color: Colors.red,
          ),
        ),
      );
    }

    // Show the dialog using the showDialog function
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Style.primaryBackground,
          surfaceTintColor: Colors.transparent,
          title: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20)),
                color: Style.primaryColor),
            // color: Colors.red,
            child: Padding(
              padding: EdgeInsetsDirectional.all(20), // Add horizontal padding
              child: Text(
                'Add Medication',
                style: GoogleFonts.outfit(
                  textStyle: const TextStyle(
                    fontWeight: FontWeight.normal,
                    color: Style.tertiaryText,
                  ),
                ),
              ),
            ),
          ),
          titlePadding: const EdgeInsets.all(0),
          // title: Text('Add Medication'),
          content: SizedBox(
            height: 150,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // Add a text field for the user to type the medicine name
                TextField(
                  controller: medicationController,
                  decoration: InputDecoration(
                    labelText: 'Enter medicine name',
                  ), // If the user types a medicine name that is not in the list, ask if they want to add it
                ),
                // Add a dropdown menu for the user to choose the medicine name from the list
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 8, 0, 0),
                  child: Container(
                    padding: EdgeInsets.only(left: 10, right: 10), // Add padding around the dropdown
                    decoration: BoxDecoration(
                      // color: Colors.white, // Background color of dropdown button
                      borderRadius: BorderRadius.circular(8), // Rounded corners
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: selectedMedicine,
                        hint: Text('Or choose a medicine'),
                        items: medicationNames.map((name) => DropdownMenuItem<String>(
                          value: name,
                          child: Text(name),
                        )).toList(),
                        onChanged: (value) {
                          // Update the selected medicine name
                          medicationController.text = value!;
                        },
                      ),
                    ),
                  ),
                ),
                // Show the error message if any
                showError(),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel',
                style: GoogleFonts.outfit(
                  textStyle: const TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 16,
                    color: Style.primaryColor,
                  ),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Add',
                style: GoogleFonts.outfit(
                  textStyle: const TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 16,
                    color: Style.primaryColor,
                  ),
                ),
              ),
              onPressed: () async {
                // Add the selected or typed medicine to the database
                  if (!medicationNames.contains(medicationController.text)) {
                    await showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('Add new medicine'),
                          content: Text(
                              'The medicine ${medicationController.text} is not in the list. Do you want to add it?'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                // Add the new medicine to the database
                                FirebaseService().addMedicationName(medicationController.text);
                                addMedication(selectedMedicine ?? medicationController.text);
                                // Close the dialog
                                Navigator.of(context).pop();
                                setState(() {
                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                    content: Text("Medicine added successfully!"),
                                  ));
                                });
                              },
                              child: Text('Yes'),
                            ),
                            TextButton(
                              onPressed: () {
                                // Close the dialog
                                addMedication(selectedMedicine ?? medicationController.text);
                                Navigator.of(context).pop();
                              },
                              child: Text('No'),
                            ),
                          ],
                        );
                      },
                    );
                  }else{
                    addMedication(selectedMedicine ?? medicationController.text);
                  }
                // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Style.primaryBackground,
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        automaticallyImplyLeading: false,
        backgroundColor: Style.primaryBackground,
        elevation: 0,
        title: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0, 16, 0, 0),
              child: Text(
                'Asthsist',
                style: GoogleFonts.outfit(
                  textStyle: const TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 32,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            Align(
              alignment: const AlignmentDirectional(0, -1),
              child: Text(
                '+',
                style: GoogleFonts.outfit(
                  textStyle: const TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 32,
                    color: Style.primaryColor,
                  ),
                ),
              ),
            )
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(0, 16, 8, 0),
            child: IconButton(
              icon: const Icon(
                Icons.notifications_outlined,
                size: 28,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NotificationsPage()),
                );
              },
            ),
          )
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(10, 0, 10, 10),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 16, 0, 0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        'Welcome Back',
                        style: GoogleFonts.outfit(
                          textStyle: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 32,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    FutureBuilder<String>(
                      future: FirebaseService()
                          .getUserName(), // The Future returned by the function
                      builder: (BuildContext context,
                          AsyncSnapshot<String> snapshot) {
                        // Check if the Future is resolved
                        if (snapshot.connectionState == ConnectionState.done) {
                          // If the Future is complete, display the data
                          return Text(
                            '${snapshot.data} 👋',
                            style: GoogleFonts.outfit(
                              textStyle: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 28,
                                color: Style.primaryColor,
                              ),
                            ),
                          );
                        } else {
                          // If the Future is not complete, display a loading indicator
                          return const CircularProgressIndicator(
                            color: Style.primaryColor,
                          );
                        }
                      },
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 16, 0, 0),
                  child: Material(
                    borderRadius: const BorderRadius.all(Radius.circular(16)),
                    elevation: 2,
                    child: Container(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          showPEFPrediction(),
                          Container(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            decoration: const BoxDecoration(
                              color: Style.secondaryBackground,
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(16),
                                bottomRight: Radius.circular(16),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    print('Tapped');
                                    Navigator. push(
                                      context,
                                      MaterialPageRoute(builder: (context) => const NavigationBarApp(initialPageIndex: 2),
                                    ));
                                  },
                                  child: Padding(
                                    padding: const EdgeInsetsDirectional.fromSTEB(
                                        10, 10, 10, 10),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        const Icon(
                                          Icons.favorite,
                                          size: 24,
                                          color: Style.heartrate,
                                        ),
                                        FutureBuilder<Map<String,dynamic>>(
                                            future: FirebaseService()
                                                .getLatestHR(),
                                            builder: (context, snapshot) {
                                              var heartRate = snapshot.data?['value'].toString().split('.');
                                  
                                              if (snapshot.connectionState ==
                                                  ConnectionState.done) {
                                                if (snapshot.data == null) {
                                                return Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 6, bottom: 6),
                                                  child: Text(
                                                    'No Data',
                                                    style: GoogleFonts.outfit(
                                                      textStyle:
                                                          const TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal,
                                                              fontSize: 9,
                                                              color: Style
                                                                  .primaryText),
                                                    ),
                                                  ),
                                                );
                                              } else {
                                                  // If the Future is complete, display the data

                                                  return Text(
                                                      '${heartRate?[0]}',
                                                      style: GoogleFonts.outfit(
                                                        textStyle: const TextStyle(
                                                            fontWeight:
                                                            FontWeight.normal,
                                                            fontSize: 21,
                                                            color: Style
                                                                .primaryText),
                                                      )
                                                  );
                                                }
                                              }else{
                                                return const CircularProgressIndicator(
                                                  color: Style.primaryColor,
                                                );
                                              }
                                            }),
                                        Text(
                                          'bpm',
                                          style: GoogleFonts.outfit(
                                            textStyle: const TextStyle(
                                              fontWeight: FontWeight.w300,
                                              fontSize: 16,
                                              color: Style.accent2,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      10, 10, 10, 10),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      const Icon(Icons.medication_outlined,
                                          size: 24, color: Style.medication),
                                      FutureBuilder<String>(
                                          future: FirebaseService()
                                              .getTodayMedicationCount(),
                                          builder: (context, snapshot) {
                                            if (snapshot.connectionState ==
                                                ConnectionState.done) {
                                              // If the Future is complete, display the data
                                              return Text(
                                                '${snapshot.data}',
                                                style: GoogleFonts.outfit(
                                                  textStyle: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      fontSize: 24,
                                                      color: Style.primaryText),
                                                ),
                                              );
                                            } else {
                                              return Text(
                                                '0',
                                                style: GoogleFonts.outfit(
                                                  textStyle: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      fontSize: 21,
                                                      color: Style.primaryText),
                                                ),
                                              );
                                            }
                                          }),
                                      Text(
                                        'Used',
                                        style: GoogleFonts.outfit(
                                          textStyle: const TextStyle(
                                              fontWeight: FontWeight.w300,
                                              fontSize: 16,
                                              color: Style.accent2),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      10, 10, 10, 10),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      const Icon(Icons.thermostat,
                                          size: 24, color: Style.weather),
                                      FutureBuilder<String>(
                                          future: FirebaseService().getLatestTemperature(),
                                          builder: (context, snapshot) {
                                            if (snapshot.connectionState ==
                                                ConnectionState.done) {
                                              if (snapshot.data == null) {
                                                return Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 6, bottom: 6),
                                                  child: Text(
                                                    'No Data',
                                                    style: GoogleFonts.outfit(
                                                      textStyle:
                                                          const TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal,
                                                              fontSize: 9,
                                                              color: Style
                                                                  .primaryText),
                                                    ),
                                                  ),
                                                );
                                              } else {
                                                // If the Future is complete, display the data
                                                return Text(
                                                  '${snapshot.data}°C',
                                                  style: GoogleFonts.outfit(
                                                    textStyle: const TextStyle(
                                                        fontWeight:
                                                        FontWeight.normal,
                                                        fontSize: 21,
                                                        color: Style
                                                            .primaryText),
                                                  ),
                                                );
                                              }
                                            } else {
                                              return const CircularProgressIndicator(
                                                color: Style.primaryColor,

                                              );
                                            }
                                          }),
                                      Text(
                                        'Temp',
                                        style: GoogleFonts.outfit(
                                          textStyle: const TextStyle(
                                              fontWeight: FontWeight.w300,
                                              fontSize: 16,
                                              color: Style.accent2),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      10, 10, 10, 10),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      const Icon(Icons.air,
                                          size: 24, color: Style.air),
                                      FutureBuilder<String>(
                                          future: FirebaseService().getLatestAQI(),
                                          builder: (context, snapshot) {
                                            if (snapshot.connectionState ==
                                                ConnectionState.done) {
                                              // If the Future is complete, display the data
                                              var value = snapshot.data;
                                              if (value == null) {
                                                return Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 6, bottom: 6),
                                                  child: Text(
                                                    'No Data',
                                                    style: GoogleFonts.outfit(
                                                      textStyle:
                                                          const TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal,
                                                              fontSize: 9,
                                                              color: Style
                                                                  .primaryText),
                                                    ),
                                                  ),
                                                );
                                              } else {
                                                return Text(
                                                  '${snapshot.data}',
                                                  style: GoogleFonts.outfit(
                                                    textStyle: const TextStyle(
                                                        fontWeight:
                                                        FontWeight.normal,
                                                        fontSize: 21,
                                                        color: Style
                                                            .primaryText),
                                                  ),
                                                );
                                              }
                                            } else {
                                              return const CircularProgressIndicator(
                                                color: Style.primaryColor,
                                              );
                                            }
                                          }),
                                      Text(
                                        'AQI',
                                        style: GoogleFonts.outfit(
                                          textStyle: const TextStyle(
                                              fontWeight: FontWeight.w300,
                                              fontSize: 16,
                                              color: Style.accent2),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      10, 10, 10, 10),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      const Icon(
                                          Icons.health_and_safety_outlined,
                                          size: 24,
                                          color: Style.pef),
                                      FutureBuilder(
                                          future: FirebaseService()
                                              .getLatestPEF(),
                                          builder: (context, snapshot) {
                                            var value = snapshot.data?['data'];
                                            if (snapshot.connectionState ==
                                                ConnectionState.done) {
                                              // If the Future is complete, display the data
                                              if (value == null) {
                                                return Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 6, bottom: 6),
                                                  child: Text(
                                                    'No Data',
                                                    style: GoogleFonts.outfit(
                                                      textStyle:
                                                          const TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal,
                                                              fontSize: 9,
                                                              color: Style
                                                                  .primaryText),
                                                    ),
                                                  ),
                                                );
                                              } else {
                                                return Text(
                                                  '$value',
                                                  style: GoogleFonts.outfit(
                                                    textStyle: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        fontSize: 21,
                                                        color:
                                                            Style.primaryText),
                                                  ),
                                                );
                                              }
                                            } else {
                                              return const CircularProgressIndicator(
                                                color: Style.primaryColor,
                                              );
                                            }
                                          }),
                                      Text(
                                        'PEF',
                                        style: GoogleFonts.outfit(
                                          textStyle: const TextStyle(
                                              fontWeight: FontWeight.w300,
                                              fontSize: 16,
                                              color: Style.accent2),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 16, 0, 0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Style.tertiaryText,
                      backgroundColor: Style.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      minimumSize: const Size(double.infinity, 80),
                    ),
                    onPressed: () {
                      _showAddAttackDialog(context);
                    },
                    child: Text(
                      'I have an Attack!',
                      style: GoogleFonts.outfit(
                        textStyle: GoogleFonts.outfit(
                          textStyle: const TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 18,
                            color: Style.secondaryBackground,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 16, 0, 0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Material(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(16)),
                            elevation: 2,
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                elevation: 0,
                                // backgroundColor: Colors.transparent,
                                foregroundColor: Style.tertiaryText,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 20.0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              onPressed: () {
                                _showAddPeakFlowDialog(context);
                              },
                              label: Text(
                                'add peakflow',
                                style: GoogleFonts.outfit(
                                  textStyle: const TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 16,
                                    color: Style.primaryText,
                                  ),
                                ),
                              ),
                              icon: const Icon(
                                Icons.health_and_safety_outlined,
                                color: Style.secondaryColor,
                                size: 30.0,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Material(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(16)),
                            elevation: 2,
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                elevation: 0,
                                // backgroundColor: Colors.transparent,
                                foregroundColor: Style.tertiaryText,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 20.0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              onPressed: () {
                                _showAddMedicationDialog(context);
                              },
                              label: Text(
                                'add medication',
                                style: GoogleFonts.outfit(
                                  textStyle: const TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 16,
                                    color: Style.primaryText,
                                  ),
                                ),
                              ),
                              icon: const Icon(
                                Icons.medication_outlined,
                                color: Style.success,
                                size: 30.0,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 16, 0, 0),
                  child: Material(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(16),
                    ),
                    elevation: 2,
                    color: Style.tertiaryText,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: InkWell(
                      // splashColor: Style.primaryColor,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const AsthmaControlTestPage()),
                        );
                      },
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20.0,
                            vertical: 10.0), // Add padding if necessary
                        leading: const Icon(Icons.inventory_outlined,
                            size: 50, color: Style.act),
                        title: Text(
                          'Asthma Control Test',
                          style: GoogleFonts.outfit(
                            textStyle: const TextStyle(
                              fontWeight: FontWeight.normal,
                              // fontSize: 16,
                              color: Style.primaryText,
                            ),
                          ),
                        ),
                        subtitle: Text(
                          'Click here for testing',
                          style: GoogleFonts.outfit(
                            textStyle: const TextStyle(
                              fontWeight: FontWeight.normal,
                              // fontSize: 16,
                              color: Style.secondaryText,
                            ),
                          ),
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios,
                            color: Style.secondaryText, size: 20), // Right arrow icon
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
