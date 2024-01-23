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
        title:  Row(
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
              tooltip: 'Show Snackbar',
              onPressed: () {
                // Navigator.push(
                //   context,
                //   // MaterialPageRoute(builder: (context) => NotificationsPage()),
                // );
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
                              padding:
                              const EdgeInsetsDirectional.fromSTEB(16, 10, 0, 0),
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
                              padding:
                              const EdgeInsetsDirectional.fromSTEB(0, 32, 0, 32),
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
                              padding:
                              const EdgeInsetsDirectional.fromSTEB(0, 0, 10, 10),
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
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                              decoration: const BoxDecoration(
                                color: Style.tertiaryText,
                              ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      const Icon(Icons.favorite_outline,
                                        size: 24,
                                        color: Style.danger,
                                      ),
                                      Text('$heartRate',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold
                                        ),
                                      ),
                                      Text('Bmp',
                                        style: TextStyle(
                                            color: Colors.black.withOpacity(0.7)
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      const Icon(Icons.medication_outlined, size: 24, color: Style.success),
                                      Text('$medi',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold
                                        ),
                                      ),
                                      Text('Taken',
                                        style: TextStyle(
                                            color: Colors.black.withOpacity(0.7)
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      const Icon(Icons.thermostat, size: 24, color: Style.warning),
                                      Text('$tem°C',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold
                                        ),
                                      ),
                                      Text('$weather',
                                        style: TextStyle(
                                            color: Colors.black.withOpacity(0.7)
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      const Icon(Icons.air, size: 24, color: Style.accent2),
                                      Text('$aqi',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold
                                        ),
                                      ),
                                      Text('AQI',
                                        style: TextStyle(
                                            color: Colors.black.withOpacity(0.7)
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      const Icon(Icons.health_and_safety_outlined, size: 24,color: Style.secondaryColor),
                                      Text('$pf',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold
                                        ),
                                      ),
                                      Text('PF',
                                        style: TextStyle(
                                            color: Colors.black.withOpacity(0.7)
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
                  padding: EdgeInsetsDirectional.fromSTEB(0, 16, 0, 0),
                  child: Material(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(30),
                    ),
                    elevation: 2,
                    color: Style.tertiaryText,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: InkWell(
                      splashColor: Style.primaryColor,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const AsthmaControlTestPage()
                          ),
                        );
                      },
                      child: const ListTile(
                        contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0), // Add padding if necessary
                        leading: Icon(Icons.subtitles_outlined, size: 50, color: Style.primaryColorLight),
                        title: Text(
                          'Asthma Control Test',
                          style: TextStyle(color: Style.primaryText, fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          'Click here for testing',
                          style: TextStyle(color: Style.primaryText),
                        ),
                        trailing: Icon(Icons.arrow_forward_ios, color: Style.primaryText), // Right arrow icon
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
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              elevation: 2,
                              primary: Style.tertiaryText,
                              padding: const EdgeInsets.symmetric(vertical: 20.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(40),
                              ),
                            ),
                            onPressed: () {
                              _showAddPeakFlowDialog(context);
                            },
                            label: const Text(
                              'Add peakflow',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: Style.primaryText,
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
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 8.0), // Space between the buttons
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              primary: Style.tertiaryText,
                              padding: const EdgeInsets.symmetric(vertical: 20.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(40),
                              ),
                            ),
                            onPressed: () {
                              _showAddMedicationDialog(context);
                            },
                            label: const Text(
                              'Add Medication',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: Style.primaryText,
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
                    borderRadius: const BorderRadius.all(Radius.circular(30)),
                    color: Style.primaryColorLight,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        primary: Style.primaryColor,
                        padding: const EdgeInsets.symmetric(horizontal: 140.0, vertical: 20.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40),
                        ),
                        textStyle: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      onPressed: () {
                        // tap callback
                      },
                      icon: const Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 24.0,
                      ),
                      label: const Text(
                        'Attack!',
                        style: TextStyle(
                          color: Colors.white,
                        ),
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

// class _HomePageState extends State<HomePage> {
//   final String userName = 'Username';
//   String? selectedValue;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Style.primaryBackground,
//       appBar: AppBar(
//         backgroundColor: Style.primaryBackground,
//         elevation: 0,
//         title:  Row(
//             mainAxisSize: MainAxisSize.max,
//             mainAxisAlignment: MainAxisAlignment.start,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Padding(
//                 padding: const EdgeInsetsDirectional.fromSTEB(0, 16, 0, 0),
//                 child: Text(
//                   'Asthsist',
//                   style: GoogleFonts.outfit(
//                     textStyle: const TextStyle(
//                       fontWeight: FontWeight.normal,
//                       fontSize: 32,
//                       color: Colors.black,
//                     ),
//                   ),
//                 ),
//               ),
//               Align(
//                 alignment: const AlignmentDirectional(0, -1),
//                 child: Text(
//                   '+',
//                   style: GoogleFonts.outfit(
//                     textStyle: const TextStyle(
//                       fontWeight: FontWeight.normal,
//                       fontSize: 32,
//                       color: Style.primaryColor,
//                     ),
//                   ),
//                 ),
//               )
//             ],
//           ),
//         actions: [
//           Padding(
//             padding: const EdgeInsetsDirectional.fromSTEB(0, 16, 8, 0),
//             child: IconButton(
//               icon: const Icon(
//                 Icons.notifications_outlined,
//                 size: 28,
//               ),
//               tooltip: 'Show Snackbar',
//               onPressed: () {
//                 // Navigator.push(
//                 //   context,
//                 //   // MaterialPageRoute(builder: (context) => NotificationsPage()),
//                 // );
//               },
//             ),
//           )
//         ],
//       ),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Padding(
//             padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
//             child: Column(
//               mainAxisSize: MainAxisSize.max,
//               children: [
//                 Padding(
//                   padding: const EdgeInsetsDirectional.fromSTEB(0, 16, 0, 0),
//                   child: Row(
//                     mainAxisSize: MainAxisSize.max,
//                     children: [
//                       Text(
//                         'Welcome Back',
//                         style: GoogleFonts.outfit(
//                           textStyle: const TextStyle(
//                             fontWeight: FontWeight.w500,
//                             fontSize: 32,
//                             color: Colors.black,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Row(
//                   mainAxisSize: MainAxisSize.max,
//                   children: [
//                     Text(
//                       '$userName 👋',
//                       style: GoogleFonts.outfit(
//                         textStyle: const TextStyle(
//                           fontWeight: FontWeight.w700,
//                           fontSize: 28,
//                           color: Style.primaryColor,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 Padding(
//                   padding: const EdgeInsetsDirectional.fromSTEB(0, 16, 0, 0),
//                   child: Material(
//                     borderRadius: const BorderRadius.all(Radius.circular(16)),
//                     elevation: 2,
//                     child: Container(
//                       decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(16),
//                           color: Style.success),
//                       child: Column(
//                         mainAxisSize: MainAxisSize.max,
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         children: [
//                           Align(
//                             alignment: const AlignmentDirectional(-1, -1),
//                             child: Padding(
//                               padding:
//                                   const EdgeInsetsDirectional.fromSTEB(16, 10, 0, 0),
//                               child: Text(
//                                 'Your current risk',
//                                 style: GoogleFonts.outfit(
//                                   textStyle: const TextStyle(
//                                     fontWeight: FontWeight.normal,
//                                     fontSize: 14,
//                                     color: Style.tertiaryText,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                           Align(
//                             alignment: const AlignmentDirectional(0, 0),
//                             child: Padding(
//                               padding:
//                                   const EdgeInsetsDirectional.fromSTEB(0, 32, 0, 32),
//                               child: Text(
//                                 'SAFE',
//                                 style: GoogleFonts.outfit(
//                                   textStyle: const TextStyle(
//                                     fontWeight: FontWeight.normal,
//                                     fontSize: 48,
//                                     color: Style.tertiaryText,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                           Align(
//                             alignment: const AlignmentDirectional(1, 1),
//                             child: Padding(
//                               padding:
//                                   const EdgeInsetsDirectional.fromSTEB(0, 0, 10, 10),
//                               child: Text(
//                                 'Great job! ',
//                                 textAlign: TextAlign.end,
//                                 style: GoogleFonts.outfit(
//                                   textStyle: const TextStyle(
//                                     fontWeight: FontWeight.normal,
//                                     fontSize: 14,
//                                     color: Style.tertiaryText,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                           Container(
//                             decoration: const BoxDecoration(
//                                 borderRadius: BorderRadius.only(
//                                   bottomLeft: Radius.circular(16),
//                                   bottomRight: Radius.circular(16),
//                                 ),
//                                 color: Style.secondaryBackground),
//                             child: ListView(
//                               padding: EdgeInsets.zero,
//                               shrinkWrap: true,
//                               scrollDirection: Axis.vertical,
//                               children: ListTile
//                                   .divideTiles(context: context, tiles: [
//                                 ListTile(
//                                   title: primaryTileText('Current Peak Flow'),
//                                   subtitle: secondaryTileText('450'),
//                                   trailing: Icon(
//                                     Icons.arrow_forward_ios,
//                                     color: Colors.grey[600],
//                                     size: 20,
//                                   ),
//                                   tileColor: Colors.white,
//                                   dense: false,
//                                 ),
//                                 ListTile(
//                                   title: primaryTileText('Medication Usage'),
//                                   subtitle:
//                                       secondaryTileText('1, Medication name'),
//                                   trailing: const Icon(
//                                     Icons.arrow_forward_ios,
//                                     color: Colors.black,
//                                     size: 20,
//                                   ),
//                                   tileColor: Colors.transparent,
//                                   dense: false,
//                                 ),
//                                 ListTile(
//                                   title: primaryTileText('Heart Rate'),
//                                   subtitle: secondaryTileText('85 bpm'),
//                                   trailing: const Icon(
//                                     Icons.arrow_forward_ios,
//                                     color: Colors.black,
//                                     size: 20,
//                                   ),
//                                   tileColor: Colors.transparent,
//                                   dense: false,
//                                 ),
//                                 ListTile(
//                                   title: primaryTileText('Weather & AQI'),
//                                   subtitle:
//                                       secondaryTileText('Clear, 33°C, 45 AQI'),
//                                   trailing: const Icon(
//                                     Icons.arrow_forward_ios,
//                                     color: Colors.black,
//                                     size: 20,
//                                   ),
//                                   tileColor: Colors.transparent,
//                                   dense: false,
//                                 ),
//                               ListTile(
//                                 title: Center(
//                                   child: DropdownButton<String>(
//                                     value: selectedValue,
//                                     hint: Text('Add Data'),
//                                     icon: const Icon(Icons.add),
//                                     elevation: 16,
//                                     underline: SizedBox(), // Empty box will remove underline
//                                     onChanged: (String? value) {
//                                       // This is called when the user selects an item.
//                                       setState(() {
//                                         selectedValue = value!;
//                                       });
//                                     },
//                                     items: <String>['Data 1', 'Data 2', 'Data 3', 'Data 4']
//                                         .map<DropdownMenuItem<String>>((String value) {
//                                       return DropdownMenuItem<String>(
//                                         value: value,
//                                         child: Text(value),
//                                       );
//                                     }).toList(),
//                                   ),
//                                 ),
//                                 // textColor: Colors.transparent,
//                                 // dense: false,
//                               ),
//                               ]).toList(),
//                             ),
//                           )
//                         ],
//                       ),
//                     ),
//                   ),
//                 )
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class _HomePageState extends State<HomePage> {
//   final String userName = 'Username';
//   String? selectedValue;
//
//   // List to hold your data tiles, each item is a Map with a title and subtitle.
//   List<Map<String, String>> dataItems = [
//     {
//       'title': 'Current Peak Flow',
//       'subtitle': '450',
//     },
//     {
//       'title': 'Medication Usage',
//       'subtitle': '1, Medication name',
//     },
//     {
//       'title': 'Heart Rate',
//       'subtitle': '85 bpm',
//     },
//     {
//       'title': 'Weather & AQI',
//       'subtitle': 'Clear, 33°C, 45 AQI',
//     },
//     // ... any other initial data items...
//   ];
//
//   final List<String> addableDataOptions = [
//     'New Data 1',
//     'New Data 2',
//     'New Data 3',
//     // ... more data options ...
//   ];
//   void navigateToAsthmaControlQuestionnaire() {
//     // Navigator.push(
//       // context,
//       // MaterialPageRoute(builder: (context) => AsthmaControlQuestionnairePage()),
//     // );
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Style.primaryBackground,
//       appBar: AppBar(
//         backgroundColor: Style.primaryBackground,
//         elevation: 0,
//         title: Row(
//           mainAxisSize: MainAxisSize.max,
//           mainAxisAlignment: MainAxisAlignment.start,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             Padding(
//               padding: const EdgeInsetsDirectional.fromSTEB(0, 16, 0, 0),
//               child: Text(
//                 'Asthsist',
//                 style: GoogleFonts.outfit(
//                   textStyle: const TextStyle(
//                     fontWeight: FontWeight.normal,
//                     fontSize: 32,
//                     color: Colors.black,
//                   ),
//                 ),
//               ),
//             ),
//             Align(
//               alignment: const AlignmentDirectional(0, -1),
//               child: Text(
//                 '+',
//                 style: GoogleFonts.outfit(
//                   textStyle: const TextStyle(
//                     fontWeight: FontWeight.normal,
//                     fontSize: 32,
//                     color: Style.primaryColor,
//                   ),
//                 ),
//               ),
//             )
//           ],
//         ),
//         actions: [
//           Padding(
//             padding: const EdgeInsetsDirectional.fromSTEB(0, 16, 8, 0),
//             child: IconButton(
//               icon: const Icon(
//                 Icons.notifications_outlined,
//                 size: 28,
//               ),
//               tooltip: 'Show Snackbar',
//               onPressed: () {
//                 // Navigator.push(
//                 //   context,
//                 //   // MaterialPageRoute(builder: (context) => NotificationsPage()),
//                 // );
//               },
//             ),
//           )
//         ],
//       ),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Padding(
//             padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
//             child: Column(
//               mainAxisSize: MainAxisSize.max,
//               children: [
//                 Padding(
//                   padding: const EdgeInsetsDirectional.fromSTEB(0, 16, 0, 0),
//                   child: Row(
//                     mainAxisSize: MainAxisSize.max,
//                     children: [
//                       Text(
//                         'Welcome Back',
//                         style: GoogleFonts.outfit(
//                           textStyle: const TextStyle(
//                             fontWeight: FontWeight.w500,
//                             fontSize: 32,
//                             color: Colors.black,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Row(
//                   mainAxisSize: MainAxisSize.max,
//                   children: [
//                     Text(
//                       '$userName 👋',
//                       style: GoogleFonts.outfit(
//                         textStyle: const TextStyle(
//                           fontWeight: FontWeight.w700,
//                           fontSize: 28,
//                           color: Style.primaryColor,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 // risk container
//                 Padding(
//                   padding: const EdgeInsetsDirectional.fromSTEB(0, 16, 0, 0),
//                   child: Material(
//                     borderRadius: const BorderRadius.all(Radius.circular(16)),
//                     elevation: 2,
//                     child: Container(
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(16),
//                         color: Style.success,
//                       ),
//                       child: Column(
//                         mainAxisSize: MainAxisSize.max,
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         children: [
//                           Align(
//                             alignment: const AlignmentDirectional(-1, -1),
//                             child: Padding(
//                               padding: const EdgeInsetsDirectional.fromSTEB(16, 10, 0, 0),
//                               child: Text(
//                                 'Your current risk',
//                                 style: GoogleFonts.outfit(
//                                   textStyle: TextStyle(
//                                     fontWeight: FontWeight.normal,
//                                     fontSize: 14,
//                                     color: Style.tertiaryText,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                           Align(
//                             alignment: const AlignmentDirectional(0, 0),
//                             child: Padding(
//                               padding: const EdgeInsetsDirectional.fromSTEB(0, 32, 0, 32),
//                               child: Text(
//                                 'SAFE',
//                                 style: GoogleFonts.outfit(
//                                   textStyle: TextStyle(
//                                     fontWeight: FontWeight.normal,
//                                     fontSize: 48,
//                                     color: Style.tertiaryText,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                           Align(
//                             alignment: const AlignmentDirectional(1, 1),
//                             child: Padding(
//                               padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 10, 10),
//                               child: Text(
//                                 'Great job!',
//                                 textAlign: TextAlign.end,
//                                 style: GoogleFonts.outfit(
//                                   textStyle: TextStyle(
//                                     fontWeight: FontWeight.normal,
//                                     fontSize: 14,
//                                     color: Style.tertiaryText,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//                 // Dynamically generated list of data items
//                 ListView.builder(
//                   padding: EdgeInsets.zero,
//                   physics: NeverScrollableScrollPhysics(),
//                   shrinkWrap: true,
//                   itemCount: dataItems.length,
//                   itemBuilder: (context, index) {
//                     var item = dataItems[index];
//                     return ListTile(
//                       title: Text(
//                           item['title'] ?? '', style: GoogleFonts.outfit(
//                         textStyle: const TextStyle(
//                           fontWeight: FontWeight.normal,
//                           fontSize: 16,
//                           color: Colors.black, // Replace with actual color
//                         ),
//                       )),
//                       subtitle: Text(
//                           item['subtitle'] ?? '', style: GoogleFonts.outfit(
//                         textStyle: const TextStyle(
//                           fontWeight: FontWeight.normal,
//                           fontSize: 14,
//                           color: Colors.grey,
//                         ),
//                       )),
//                       trailing: const Icon(
//                         Icons.arrow_forward_ios,
//                         color: Colors.grey,
//                         size: 20,
//                       ),
//                       tileColor: Colors.white,
//                       dense: false,
//                     );
//                   },
//                 ),
//                 // Add More+ button
//                 ListTile(
//                   title: Center(
//                     child: DropdownButton<String>(
//                       // isExpanded: true,
//                       hint: const Center(
//                           child: Text('Add More Data'),
//                       ),
//                       value: selectedValue,
//                       icon: const Icon(Icons.add),
//                       elevation: 16,
//                       underline: SizedBox(),
//                       onChanged: (String? newValue) {
//                         setState(() {
//                           if (newValue != null) {
//                             // Add the new data item to list
//                             dataItems.add({
//                               'title': newValue,
//                               'subtitle': 'Newly added data',
//                             });
//                             // Reset selectedValue to null so the hint text is shown again
//                             selectedValue = null;
//                           }
//                         });
//                       },
//                       items: addableDataOptions.map<DropdownMenuItem<String>>((String value) {
//                         return DropdownMenuItem<String>(
//                           value: value,
//                           child: Text(value),
//                         );
//                       }).toList(),
//                     ),
//                   ),
//                   tileColor: Colors.transparent,
//                   dense: false,
//                 ),
//                 //Asthma control test
//                 GestureDetector(
//                   onTap: () => navigateToAsthmaControlQuestionnaire(),
//                   child: Container(
//                     width: double.infinity,
//                     padding: const EdgeInsets.symmetric(vertical: 20.0),
//                     margin: const EdgeInsets.symmetric(vertical: 8.0),
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(16),
//                       color: Style.secondaryColor, // Replace with the actual color
//                     ),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.center, // Align the icon and text in the center
//                       children: [
//                         const Icon(
//                           Icons.calendar_month_outlined,
//                           color: Colors.white,
//                         ),
//                         SizedBox(width: 8.0), // Provide some space between the icon and the text
//                         Text(
//                           'Asthma control questionnaires',
//                           style: GoogleFonts.outfit(
//                             textStyle: const TextStyle(
//                               fontWeight: FontWeight.normal,
//                               fontSize: 16,
//                               color: Colors.white, // Replace with the actual color
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

