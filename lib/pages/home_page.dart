import 'package:asthsist_plus/pages/asthma_control_test_page.dart';
import 'package:asthsist_plus/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'notification_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  static const String routeName = '/home';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final String userName = 'Username';
  final int heartRate = 85;
  final String weather = 'clear';
  final int tem = 33;
  final int aqi = 45;
  final int pf = 450;
  final int medi = 1;

  void _showAddPeakFlowDialog(BuildContext context) {
    TextEditingController peakFlowController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Peak Flow Data'),
          content: TextField(
            controller: peakFlowController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(hintText: "Enter peak flow value"),
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly // Only allow digits
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Add'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showAddMedicationDialog(BuildContext context) {
    TextEditingController medicationController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Medication'),
          content: TextField(
            controller: medicationController,
            decoration: InputDecoration(hintText: "Enter medication details"),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Add'),
              onPressed: () {
                Navigator.of(context).pop();
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
            padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
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
                    Text(
                      '$userName 👋',
                      style: GoogleFonts.outfit(
                        textStyle: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 28,
                          color: Style.primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 16, 0, 0),
                  child: Material(
                    borderRadius: const BorderRadius.all(Radius.circular(16)),
                    elevation: 2,
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: Style.success),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
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
                                'SAFE',
                                style: GoogleFonts.outfit(
                                  textStyle: const TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 48,
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
                                'Great job!',
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
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      10, 10, 10, 10),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        Icons.favorite_outline,
                                        size: 24,
                                        color: Style.heartrate,
                                      ),
                                      Text(
                                        '$heartRate',
                                        style: GoogleFonts.outfit(
                                          textStyle: const TextStyle(
                                            fontWeight: FontWeight.normal,
                                            fontSize: 24,
                                            color: Style.primaryText
                                          ),
                                        ),
                                      ),
                                      Text(
                                        'Bmp',
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
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      10, 10, 10, 10),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      const Icon(Icons.medication_outlined,
                                          size: 24, color: Style.medication),
                                      Text(
                                        '$medi',
                                        style: GoogleFonts.outfit(
                                          textStyle: const TextStyle(
                                              fontWeight: FontWeight.normal,
                                              fontSize: 24,
                                              color: Style.primaryText
                                          ),
                                        ),
                                      ),
                                      Text(
                                        'Taken',
                                        style: GoogleFonts.outfit(
                                          textStyle: const TextStyle(
                                              fontWeight: FontWeight.normal,
                                              fontSize: 16,
                                              color: Style.accent2
                                          ),
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
                                      Text(
                                        '$tem°C',
                                        style: GoogleFonts.outfit(
                                          textStyle: const TextStyle(
                                              fontWeight: FontWeight.normal,
                                              fontSize: 24,
                                              color: Style.primaryText
                                          ),
                                        ),
                                      ),
                                      Text(
                                        '$weather',
                                        style: GoogleFonts.outfit(
                                          textStyle: const TextStyle(
                                              fontWeight: FontWeight.normal,
                                              fontSize: 16,
                                              color: Style.accent2
                                          ),
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
                                      Text(
                                        '$aqi',
                                        style: GoogleFonts.outfit(
                                          textStyle: const TextStyle(
                                              fontWeight: FontWeight.normal,
                                              fontSize: 24,
                                              color: Style.primaryText
                                          ),
                                        ),
                                      ),
                                      Text(
                                        'AQI',
                                        style: GoogleFonts.outfit(
                                          textStyle: const TextStyle(
                                              fontWeight: FontWeight.normal,
                                              fontSize: 16,
                                              color: Style.accent2
                                          ),
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
                                      Text(
                                        '$pf',
                                        style: GoogleFonts.outfit(
                                          textStyle: const TextStyle(
                                              fontWeight: FontWeight.normal,
                                              fontSize: 24,
                                              color: Style.primaryText
                                          ),
                                        ),
                                      ),
                                      Text(
                                        'PEF',
                                        style: GoogleFonts.outfit(
                                          textStyle: const TextStyle(
                                              fontWeight: FontWeight.normal,
                                              fontSize: 16,
                                              color: Style.accent2
                                          ),
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
                  padding: EdgeInsetsDirectional.fromSTEB(0, 16, 0, 0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child:
                          Material(
                            borderRadius:
                            const BorderRadius.all(Radius.circular(16)),
                            elevation: 2,
                            child:ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              elevation:0,
                              backgroundColor: Colors.transparent,
                              primary: Style.tertiaryText,
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
                        child: Material(
                            borderRadius:
                            const BorderRadius.all(Radius.circular(16)),
                            elevation: 2,
                            child:
                            ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              elevation:0,
                              backgroundColor: Colors.transparent,
                              primary: Style.tertiaryText,
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
                      ],
                  ),
                ),

                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 16, 0, 0),
                  child: Material(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(16),
                    ),
                    elevation: 2,
                    color: Style.tertiaryText,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: InkWell(
                      splashColor: Style.primaryColor,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                              const AsthmaControlTestPage()),
                        );
                      },
                      child: const ListTile(
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 20.0,
                            vertical: 10.0), // Add padding if necessary
                        leading: Icon(Icons.subtitles_outlined,
                            size: 50, color: Style.primaryColorLight),
                        title: Text(
                          'Asthma Control Test',
                          style: TextStyle(
                              color: Style.primaryText,
                              fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          'Click here for testing',
                          style: TextStyle(color: Style.primaryText),
                        ),
                        trailing: Icon(Icons.arrow_forward_ios,
                            color: Style.primaryText), // Right arrow icon
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


