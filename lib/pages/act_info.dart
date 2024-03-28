import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../backend/firebase.dart';
import '../style.dart';
import 'asthma_control_test_page.dart';

class ControlTestInfoPage extends StatefulWidget {
  final bool showBackButton;
  const ControlTestInfoPage({super.key, required this.showBackButton});

  @override
  _ControlTestInfoState createState() => _ControlTestInfoState();
}
class _ControlTestInfoState extends State<ControlTestInfoPage> {
  @override
  Widget build(BuildContext context) {

    Widget testResult(int result){
      String text = '';
      if(result>=20){
        text = 'Well Controlled';
      }else if (result>=16) {
        text = 'Not Well Controlled';
      }else{
        text = 'Very Poor Controlled';
      }
      return Column(
        children: [
          Text(
            text,
            textAlign: TextAlign.center,
            style: GoogleFonts.outfit(
              textStyle: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 24,
                color: Style.primaryText,
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'More than 19',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                  ),
                ),
                Text(
                  'Well controlled',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '16-19',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                  ),
                ),
                Text(
                  'Not well controlled',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Less than 16',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                  ),
                ),
                Text(
                  'Very poor controlled',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }
    Color setColor(int result){
      if(result>=20){
        return Style.safeSecondary;
      }else if (result>=16) {
        return Style.warningSecondary;
      }else{
        return Style.dangerSecondary;
      }
    }

    Widget infoWidget(){
          return FutureBuilder(
              future: FirebaseService().getLatestAct(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(
                    color: Style.primaryColor,
                  ));
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (snapshot.hasData) {
                  String resultText = snapshot.data['data'];
                  int result = int.parse(resultText);
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(0, 20, 0, 10),
                        child: Text(
                          'Your latest result is',
                          style: GoogleFonts.outfit(
                            textStyle: const TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 24,
                              color: Style.primaryText,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(0, 20, 0, 10),
                        child: Column(
                          children: [
                            Text(
                              resultText,
                              style: GoogleFonts.outfit(
                                textStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 72,
                                  color: setColor(result),
                                ),
                              ),
                            ),
                            Text(
                              'points',
                              style: GoogleFonts.outfit(
                                textStyle: const TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 18,
                                  color: Style.secondaryText,
                                ),
                              ),
                            ),
                            Text(
                              DateFormat('MMM dd, yyyy').format(
                                  snapshot.data['time'] as DateTime),
                              // Dynamic timestamp
                              style: GoogleFonts.outfit(
                                textStyle: const TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 18,
                                  color: Style.secondaryText,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Divider(
                        height: 32,
                        color: Style.accent4,
                        thickness: 2,
                        indent : 10,
                        endIndent : 10,
                      ),
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 10),
                        child: testResult(result),
                      )
                    ],
                  );
                }
                return const Text('No data for this category');
              });
      }

    if (widget.showBackButton==true) {
      return Scaffold(
          backgroundColor: Style.primaryBackground,
          appBar:
          PreferredSize(
            preferredSize: const Size.fromHeight(kToolbarHeight),
            // This is the height of AppBar.
            child: Padding(
              padding: const EdgeInsets.only(top: 20.0),
              // Change this value to adjust the padding
              child: AppBar(
                surfaceTintColor: Colors.transparent,
                automaticallyImplyLeading: false,
                backgroundColor: Style.primaryBackground,
                title: Text(
                  'Asthma Control Tests',
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
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(20, 20, 20, 0),
              child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                      child: Material(
                        color: Colors.transparent,
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Style.secondaryBackground
                          ),
                          child:
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                20, 0, 20, 0),
                            child: infoWidget(),
                          ),
                        ),
                      ),
                    ),
                  ]
              ),
            ),
          )
      );
    }else{
      return SafeArea(
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(10, 10, 10, 0),
          child: Column(
              children: [
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 10),
                  child:Text('Asthma Control Tests', style: GoogleFonts.outfit(
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 24,
                      color: Style.primaryText,
                    ),
                  ),),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                  child: Material(
                    color: Colors.transparent,
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Style.secondaryBackground
                      ),
                      child:
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(
                            20, 0, 20, 0),
                        child:
                            infoWidget(),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 16, 0, 0),
                  child: Material(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(16),
                    ),
                    elevation: 2,
                    surfaceTintColor: Colors.transparent,
                    color: Style.secondaryBackground,
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
              ]
          ),
        ),
      );
    }
  }
}