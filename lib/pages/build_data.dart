import 'package:asthsist_plus/backend/firebase.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

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

  };

  @override
  void didUpdateWidget(CategoryList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.date != oldWidget.date) {
      setState(() {
        _selectedDay = widget.date;
        FirebaseService().getPefValuesForDay(_selectedDay).then((pefValues) {
          FirebaseService().getMedicationForDay(_selectedDay).then((medications) {
            FirebaseService().getHRForDay(_selectedDay).then((hr) {
              FirebaseService().getAttackForDay(_selectedDay).then((attack) {
                FirebaseService().getActForDay(_selectedDay).then((act) {
                  FirebaseService().getWeatherForDay(_selectedDay).then((weather) {
                    FirebaseService().getStepsForDay(_selectedDay).then((steps) {
                      updateData(pefValues, medications, hr,attack,act,weather,steps);
                    });
                  });
                });
              });
            });
          });
        });
        // Fetch data for _selectedDay
      });
    }
  }



  @override
  void initState() {
    _selectedDay = widget.date;
    super.initState();
    FirebaseService().getPefValuesForDay(_selectedDay).then((pefValues) {
      FirebaseService().getMedicationForDay(_selectedDay).then((medications) {
        FirebaseService().getHRForDay(_selectedDay).then((hr) {
          FirebaseService().getAttackForDay(_selectedDay).then((attack) {
            FirebaseService().getActForDay(_selectedDay).then((act) {
              FirebaseService().getWeatherForDay(_selectedDay).then((weather) {
                FirebaseService().getStepsForDay(_selectedDay).then((steps) {
                  updateData(pefValues, medications, hr,attack,act,weather,steps);
                });
              });
            });
          });
        });
      });
    });
    super.initState();
  }

  void updateData(List<Map<String, dynamic>> pefValues,
      List<Map<String, dynamic>>medications,
      List<Map<String, dynamic>> hr,
      List<Map<String, dynamic>> attack,
      List<Map<String, dynamic>> act,
      List<Map<String, dynamic>> weather,
      List<Map<String, dynamic>> steps,
      ) {
    setState(() {
      data = {
        'HeartRate': hr,
        'Medications': medications,
        'Attack': attack,
        'pef': pefValues,
        'ACT': act,
        'Weather': weather,
        'Steps': steps,
      };
    });
  }

  Widget build(BuildContext context) {
    return buildCategoryView(widget.category, context);
  }

  Widget buildCategoryView(String category, BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
      child: ListView.builder(
        itemCount: data[category]?.length ?? 0,
        itemBuilder: (context, index) {
          final item = data[category]![index];
          return Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 4),
            child: Slidable(
              actionPane: SlidableDrawerActionPane(), // Choose a slide transition
              secondaryActions: <Widget>[
                IconSlideAction(
                  caption: 'Delete',
                  color: Colors.red,
                  icon: Icons.delete,
                  onTap: () =>
                      _confirmDeletion(context, category, index),
                ),
              ],
              child: Material(
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                elevation: 0,
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Style.secondaryBackground
                  ),
                  child: ListTile(
                    title: Text(item['data']),
                    trailing: Text(DateFormat('HH:mm').format(item['time'])),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
  void _confirmDeletion(BuildContext context, String category, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Data'),
          content: const Text('Are you sure you want to delete this data?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss the dialog
              },
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () {
                setState(() {
                  data[category]!.removeAt(index);
                });
                Navigator.of(context).pop(); // Dismiss the dialog after confirming deletion
              },
            ),
          ],
        );
      },
    );
  }
}
