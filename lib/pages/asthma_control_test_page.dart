import 'package:asthsist_plus/backend/firebase.dart';
import 'package:asthsist_plus/pages/navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../style.dart';
import 'act_info.dart';

class AsthmaControlTestPage extends StatefulWidget {
  const AsthmaControlTestPage({Key? key}) : super(key: key);

  // static const String routeName = '/act';

  @override
  _AsthmaControlTestPageState createState() => _AsthmaControlTestPageState();
}

class _AsthmaControlTestPageState extends State<AsthmaControlTestPage> {
  // This will hold the selected option index for each question
  final List<int?> _selectedOptions = List.filled(5, null);
  String? errorMessage = '';

  // This will hold the actual questions and options
  final List<Map<String, dynamic>> _questions = [
    {
      'question': '1. In the past 4 weeks, how often did your asthma prevent you from getting as much done at work, school, or home?',
      'options': [
        'All of the time',
        'Most of the time',
        'Some of the time',
        'A little of the time',
        'Not at all'
      ]
    },
    {
      'question': '2. During the past 4 weeks, how often have you had shortness of breath?',
      'options': [
        'More than once a day',
        'Once a day',
        '3 - 6 times a week',
        'One or twice a week',
        'Not at all'
      ]
    },
    {
      'question': '3. During the past 4 weeks, how often did your asthma symptoms wake you up at night or earlier than usual in the morning?',
      'options': [
        '4 or more times a week',
        '2 - 3 nights a week',
        '1 night a week',
        'Less than one night a week',
        'Not at all'
      ]
    },
    {
      'question': '4. During the past 4 weeks, how often have you used your reliever medication?',
      'options': [
        '3 or more times a day',
        '1 - 2 times per day',
        '2 - 3 times per week',
        'Once a week or less',
        'Not at all'
      ]
    },
    {
      'question': '5. How would you rate your asthma control during the past 4 weeks?',
      'options': [
        'Not controlled',
        'Poorly controlled',
        'Somewhat controlled',
        'Well controlled',
        'Completely controlled'
      ]
    },
  ];

  void _saveTestResults(){
    print(_selectedOptions);
    FirebaseService().addACT(_selectedOptions).then((value) => Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ControlTestInfoPage(showBackButton: true,)),
    ));

  }

  @override
  Widget build(BuildContext context) {

    Widget _error() {
      return Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(0, 8, 0, 8),
          child: Text(
            errorMessage!,
            style: GoogleFonts.outfit(
              textStyle: const TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 18,
                color: Colors.red,
              ),
            ),
          ));
    }

    return Scaffold(
      backgroundColor: Style.primaryBackground,
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: Style.primaryBackground,
        automaticallyImplyLeading: false,
        leading: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(0, 16, 0, 0),
    child: InkWell(
          splashColor: Colors.transparent,
          focusColor: Colors.transparent,
          hoverColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: () async {
            Navigator.of(context).pop();
          },
          child: Icon(
            Icons.chevron_left_rounded,
            color: Style.accent2,
            size: 32,
          ),
        ),
        ),
        title: Padding(
    padding: const EdgeInsetsDirectional.fromSTEB(0, 16, 0, 0),
    child: Align(
          alignment: AlignmentDirectional(-1.3, 0),
          child: Text(
            'Asthma Control Test',
            style: GoogleFonts.outfit(
              textStyle: const TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 24,
                color: Colors.black,
              ),
            ),
          )
        ),
        ),
        actions: [],
        centerTitle: false,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(20, 20, 20, 30),
          child: Column(
            children: [
              // The '...' (spread operator) is used to insert all the elements of the list into the children array.
              ..._questions.map((question) {
                // This map function transforms each question map into a widget.
                // It takes the current question map and finds its index in the _questions list.
                int questionIndex = _questions.indexOf(question);
                return Padding(padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 16)
                ,child:Material(
                    borderRadius:
                    const BorderRadius.all(Radius.circular(16)),
                elevation: 2,
                child: Container(
                decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Style.secondaryBackground),
                child: Column(
                    children: [
                      ListTile(
                        title: primaryTileText(
                          question['question'],),
                      ),
                      // The '...' (spread operator) is used again to insert all option widgets into the children array.
                      ...question['options'].map<Widget>((option) {
                        int optionIndex = question['options'].indexOf(option)+1;
                        return RadioListTile<int>(
                          title: Text(option),
                          value: optionIndex,
                          groupValue: _selectedOptions[questionIndex],
                          onChanged: (int? value) {
                            setState(() {
                              _selectedOptions[questionIndex] = value;
                            });
                          },
                        );
                      }).toList(), // Convert the iterable returned by map to a list.
                    ],
                  ),
                )));
              }),
              _error(),
              // Provide some spacing before the save button.
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Style.primaryColor, // Use your style for buttons here.
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 70, vertical: 15),
                ),
                onPressed: () {
                  print(_selectedOptions);
                  if (_selectedOptions.contains(null)==true) {
                    setState(() {
                      errorMessage = 'Please answer all questions';
                    });
                  } else {
                    _saveTestResults();
                  }
                },
                icon: const Icon(Icons.save,
                  color: Colors.white,
                ),
                label: const Text(
                  'Save',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
