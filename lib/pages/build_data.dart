import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../style.dart';

// Mock data
Map<String, List<Map<String, dynamic>>> data = {
  'Category1': [
    {'data': 'Data 1', 'time': DateTime.now().subtract(Duration(days: 1))},
    {'data': 'Data 2', 'time': DateTime.now().subtract(Duration(days: 2))},
    {'data': 'Data 1', 'time': DateTime.now().subtract(Duration(days: 1))},
    {'data': 'Data 2', 'time': DateTime.now().subtract(Duration(days: 2))},
    {'data': 'Data 1', 'time': DateTime.now().subtract(Duration(days: 1))},
    {'data': 'Data 2', 'time': DateTime.now().subtract(Duration(days: 2))},
  ],
  'Category2': [
    {'data': 'Data 3', 'time': DateTime.now().subtract(Duration(days: 3))},
    {'data': 'Data 4', 'time': DateTime.now().subtract(Duration(days: 4))},
  ],
  'Category3': [
    {'data': 'Data 5', 'time': DateTime.now().subtract(Duration(days: 5))},
    {'data': 'Data 6', 'time': DateTime.now().subtract(Duration(days: 6))},
  ],
  'Category4': [
    {'data': 'Data 7', 'time': DateTime.now().subtract(Duration(days: 7))},
    {'data': 'Data 8', 'time': DateTime.now().subtract(Duration(days: 8))},
  ],
};

Widget buildCategoryView(String category) {
  return Padding(padding: const EdgeInsetsDirectional.fromSTEB(0, 14, 0, 0),
      child: ListView.builder(
        itemCount: data[category]?.length ?? 0,
        itemBuilder: (context, index) {
          final item = data[category]![index];
          return Padding(padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 4),
          child: Material(
              borderRadius:
              const BorderRadius.all(Radius.circular(8)),
              elevation: 0,
              child: Container(
              decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
          color: Style.secondaryBackground),
          child:ListTile(
            title: Text(item['data']),
            trailing: Text(DateFormat('HH:mm').format(item['time'])),
          ))));
        },
      )
  );
}
