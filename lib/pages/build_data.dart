import 'package:asthsist_plus/backend/firebase.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../style.dart';

// Mock data
// Map<String, List<Map<String, dynamic>>> data = {
//   'Category1': [
//     {'data': 'Data 1', 'time': DateTime.now().subtract(Duration(days: 1))},
//     {'data': 'Data 2', 'time': DateTime.now().subtract(Duration(days: 2))},
//     {'data': 'Data 1', 'time': DateTime.now().subtract(Duration(days: 1))},
//     {'data': 'Data 2', 'time': DateTime.now().subtract(Duration(days: 2))},
//     {'data': 'Data 1', 'time': DateTime.now().subtract(Duration(days: 1))},
//     {'data': 'Data 2', 'time': DateTime.now().subtract(Duration(days: 2))},
//   ],
//   'Category2': [
//     {'data': 'Data 3', 'time': DateTime.now().subtract(Duration(days: 3))},
//     {'data': 'Data 4', 'time': DateTime.now().subtract(Duration(days: 4))},
//   ],
//   'Category3': [
//     {'data': 'Data 5', 'time': DateTime.now().subtract(Duration(days: 5))},
//     {'data': 'Data 6', 'time': DateTime.now().subtract(Duration(days: 6))},
//   ],
//   'Category4': [
//     {'data': 'Data 7', 'time': DateTime.now().subtract(Duration(days: 7))},
//     {'data': 'Data 8', 'time': DateTime.now().subtract(Duration(days: 8))},
//   ],
// };

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
    'Category1': [],
    'Category2': [],
    'Category3': [],
    'pef': [],
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
              updateData(pefValues, medications, hr);
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
          updateData(pefValues, medications, hr);
        });
      });
    });
    super.initState();
  }

  void updateData(List<Map<String, dynamic>> pefValues, List<Map<String, dynamic>>medications, List<Map<String, dynamic>> hr) {
    print(pefValues);
    setState(() {
      data = {
        'HeartRate': hr,
        'Medications': medications,
        'Category3': [
          {'data': 'Data 1', 'time': DateTime.now().subtract(Duration(days: 1))},
          {'data': 'Data 2', 'time': DateTime.now().subtract(Duration(days: 2))},
          {'data': 'Data 1', 'time': DateTime.now().subtract(Duration(days: 1))},
          {'data': 'Data 2', 'time': DateTime.now().subtract(Duration(days: 2))},
          {'data': 'Data 1', 'time': DateTime.now().subtract(Duration(days: 1))},
          {'data': 'Data 2', 'time': DateTime.now().subtract(Duration(days: 2))},
        ],
        'pef': pefValues,
      };
    });
  }

  Widget build(BuildContext context) {
    return buildCategoryView(widget.category, context);
  }

  Widget buildCategoryView(String category, BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0, 14, 0, 0),
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
