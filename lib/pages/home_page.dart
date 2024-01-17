import 'package:asthsist_plus/style.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'notification_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  static const String routeName = '/home';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Style.primaryBackground,
      appBar: AppBar(
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
                // Row(
                //   mainAxisSize: MainAxisSize.max,
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   crossAxisAlignment: CrossAxisAlignment.start,
                //   children: [
                //     Row(
                //       mainAxisSize: MainAxisSize.max,
                //       mainAxisAlignment: MainAxisAlignment.end,
                //       crossAxisAlignment: CrossAxisAlignment.center,
                //       children: [
                //         Align(
                //           alignment: AlignmentDirectional(0, -1),
                //           child: Padding(
                //             padding:
                //             EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                //             child: Text(
                //               'Asthsist',
                //               style: GoogleFonts.outfit(
                //                 textStyle: const TextStyle(
                //                   fontWeight: FontWeight.normal,
                //                   fontSize: 32,
                //                   color: Colors.black,
                //                 ),
                //               ),
                //             ),
                //           ),
                //         ),
                //         Align(
                //           alignment: AlignmentDirectional(0, -1),
                //           child: Text(
                //             '+',
                //             style: GoogleFonts.outfit(
                //               textStyle: const TextStyle(
                //                 fontWeight: FontWeight.normal,
                //                 fontSize: 32,
                //                 color: Style.primaryColor,
                //               ),
                //             ),
                //           ),
                //         )
                //       ],
                //     ),
                //     Align(
                //       alignment: AlignmentDirectional(0, -1),
                //       child: Card(
                //         clipBehavior: Clip.antiAliasWithSaveLayer,
                //         color: Colors.deepPurpleAccent[400],
                //         elevation: 2,
                //         shape: RoundedRectangleBorder(
                //           borderRadius: BorderRadius.circular(40),
                //         ),
                //         child: Padding(
                //           padding: const EdgeInsets.all(2),
                //           child: Container(
                //             width: 50,
                //             height: 50,
                //             clipBehavior: Clip.antiAlias,
                //             decoration: const BoxDecoration(
                //               shape: BoxShape.circle,
                //             ),
                //             child: Align(
                //               alignment: Alignment.center,
                //               child: Image.asset(
                //                 'assets/images/asthsist.jpg',
                //                 fit: BoxFit.fitHeight,
                //               ),
                //             ),
                //           ),
                //         ),
                //       ),
                //     ),
                //   ],
                // ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 16, 0, 0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        'Good Morning',
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
                      'Username 👋',
                      style: GoogleFonts.outfit(
                        textStyle: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 28,
                          color: Colors.deepPurpleAccent[400],
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
                                'Great job! ',
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
                            decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(16),
                                  bottomRight: Radius.circular(16),
                                ),
                                color: Style.secondaryBackground),
                            child: ListView(
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              children: ListTile
                                  .divideTiles(context: context, tiles: [
                                ListTile(
                                  title: primaryTileText('Current Peak Flow'),
                                  subtitle: secondaryTileText('450'),
                                  trailing: Icon(
                                    Icons.arrow_forward_ios,
                                    color: Colors.grey[600],
                                    size: 20,
                                  ),
                                  tileColor: Colors.white,
                                  dense: false,
                                ),
                                ListTile(
                                  title: primaryTileText('Medication Usage'),
                                  subtitle:
                                      secondaryTileText('1, Medication name'),
                                  trailing: const Icon(
                                    Icons.arrow_forward_ios,
                                    color: Colors.black,
                                    size: 20,
                                  ),
                                  tileColor: Colors.transparent,
                                  dense: false,
                                ),
                                ListTile(
                                  title: primaryTileText('Heart Rate'),
                                  subtitle: secondaryTileText('85 bpm'),
                                  trailing: const Icon(
                                    Icons.arrow_forward_ios,
                                    color: Colors.black,
                                    size: 20,
                                  ),
                                  tileColor: Colors.transparent,
                                  dense: false,
                                ),
                                ListTile(
                                  title: primaryTileText('Weather & AQI'),
                                  subtitle:
                                      secondaryTileText('Clear, 33°C, 45 AQI'),
                                  trailing: const Icon(
                                    Icons.arrow_forward_ios,
                                    color: Colors.black,
                                    size: 20,
                                  ),
                                  tileColor: Colors.transparent,
                                  dense: false,
                                ),
                              ]).toList(),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
