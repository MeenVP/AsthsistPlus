import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../backend/firebase.dart';
import '../style.dart';
import 'asthma_control_test_page.dart';

class PeakFlowInfoPage extends StatefulWidget {
  final bool showBackButton;
  const PeakFlowInfoPage({super.key, required this.showBackButton});

  @override
  _PeakFlowInfoState createState() => _PeakFlowInfoState();
}
class _PeakFlowInfoState extends State<PeakFlowInfoPage> {
  @override
  Widget build(BuildContext context) {

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
              decoration: const BoxDecoration(
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
                  setState(() {});
                },
              ),
            ],
          );
        },
      );
    }

    Widget testResult(List<dynamic> data) {
      int pef=data[0];
      int bestPef=data[1];
      String text = '';
      if(pef>bestPef*0.8){
        text = 'Green Zone';
      }else if (pef>=bestPef*0.5) {
        text = 'Yellow Zone';
      }else{
        text = 'Red Zone';
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
                  'More than 80%',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                  ),
                ),
                Text(
                  'Green Zone, Safe',
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
                  '50%-80%',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                  ),
                ),
                Text(
                  'Yellow Zone, Caution',
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
                  'Less than 50%',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                  ),
                ),
                Text(
                  'Red Zone, Danger',
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
    Color setColor(List<dynamic> data){
      int pef=data[0];
      int bestPef=data[1];
      if(pef>(bestPef*0.8)){
        return Style.safeSecondary;
      }else if (pef>=(bestPef*0.5)) {
        return Style.warningSecondary;
      }else{
        return Style.dangerSecondary;
      }
    }

    Future<List<dynamic>> getPEFData() async{
      List<dynamic> data =[];
      var pef = await FirebaseService().getLatestPEF();
      var bestPef = await FirebaseService().getUserPEF();
      data.add(int.parse(pef['data']));
      data.add(bestPef);
      data.add(pef['time']);
      return data;
    }

    Widget infoWidget(){
          return FutureBuilder(
              future: getPEFData(),
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
                  String resultText = snapshot.data[0].toString();
                  int result = snapshot.data[0];
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(0, 20, 0, 10),
                        child: Text(
                          'Your latest PEF is',
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
                                  color: setColor(snapshot.data),
                                ),
                              ),
                            ),
                            Text(
                              'L/min',
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
                                  snapshot.data[2] as DateTime),
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
                        child: testResult(snapshot.data),
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
                  'Peak Flow',
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
          body: SingleChildScrollView(
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
      return SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(10, 10, 10, 0),
            child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 10),
                    child:Text('Peak Flow', style: GoogleFonts.outfit(
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
                          _showAddPeakFlowDialog(context);
                        },
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20.0,
                              vertical: 10.0), // Add padding if necessary
                          leading: const Icon(Icons.health_and_safety_outlined,
                              size: 50, color: Style.pef),
                          title: Text(
                            'Add Peak Flow',
                            style: GoogleFonts.outfit(
                              textStyle: const TextStyle(
                                fontWeight: FontWeight.normal,
                                // fontSize: 16,
                                color: Style.primaryText,
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
        ),
      );
    }
  }
}