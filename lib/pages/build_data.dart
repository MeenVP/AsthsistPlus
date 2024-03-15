import 'package:asthsist_plus/backend/firebase.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../style.dart';

class CategoryList extends StatefulWidget {
  final String category;
  final DateTime date;

  CategoryList({Key? key, required this.category, required this.date}) : super(key: key);

  @override
  _CategoryListState createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  late DateTime _selectedDay;

  late Map<String, List<Map<String, dynamic>>> data = {
    'HeartRate': [],
    'Medications': [],
    'pef': [],
    'Attack': [],
    'ACT': [],
    'Weather': [],
    'steps': [],
    'Prediction': [],

  };

  @override
  void didUpdateWidget(CategoryList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.date != oldWidget.date) {
      setState(() {
        _selectedDay = widget.date;
        updateData(_selectedDay);
      });
    }
  }



  @override
  void initState() {
    _selectedDay = widget.date;
    super.initState();
    updateData(_selectedDay);
  }

  Future<Map<String, List<Map<String, dynamic>>>> updateData(DateTime _selectedDay,) async {
    var heartRate = await FirebaseService().getHRForDay(_selectedDay);
    var medications = await FirebaseService().getMedicationForDay(_selectedDay);
    var attack = await FirebaseService().getAttackForDay(_selectedDay);
    var pef = await FirebaseService().getPefValuesForDay(_selectedDay);
    var act = await FirebaseService().getActForDay(_selectedDay);
    var weather = await FirebaseService().getWeatherForDay(_selectedDay);
    var steps = await FirebaseService().getStepsForDay(_selectedDay);
    var prediction = await FirebaseService().getPredictionForDay(_selectedDay);
    return{
        'Heart rates': heartRate,
        'Medications': medications,
        'Attacks': attack,
        'PEFs': pef,
        'Asthma Control Tests': act,
        'Weathers': weather,
        'Steps': steps,
        'Predictions': prediction,
      };
  }


  Widget build(BuildContext context) {
    return Column(children:[
      Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
        child:Text(widget.category, style: GoogleFonts.outfit(
          textStyle: const TextStyle(
            fontWeight: FontWeight.normal,
            fontSize: 24,
            color: Style.primaryText,
          ),
        ),),
      ),
      Flexible(child:buildCategoryView(widget.category, context))
    ]);
  }

  Widget buildCategoryView(String category, BuildContext context) {
    return FutureBuilder(
      future: updateData(_selectedDay), // Use your function here
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('Error in fetching data'));
        } else {
          if (snapshot.data[category] == null || snapshot.data[category]!.isEmpty) {
            return const Center(child: Text('No data'));
          } else {
            return Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
              child: ListView.builder(
                itemCount: snapshot.data[category]?.length ?? 0,
                itemBuilder: (context, index) {
                  final item = snapshot.data[category]![index];
                  return Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 4),
                    child: Material(
                        borderRadius: const BorderRadius.all(Radius.circular(8)),
                        elevation: 0,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Style.secondaryBackground,
                          ),
                          child: ListTile(
                            title: Text(
                                item['data'],
                            style: GoogleFonts.outfit(
                              textStyle: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 18,
                                color: Style.accent2,
                              ),
                            )
                            ),
                            trailing: Text(DateFormat('HH:mm').format(item['time']),
                              style:
                              GoogleFonts.outfit(
                              textStyle: const TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 16,
                              color: Style.accent2,
                            ),
                          )
                            ),
                          ),
                        ),
                      ),
                  );
                },
              ),
            );
          }
        }
      },
    );
  }
}
