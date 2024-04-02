import 'package:asthsist_plus/backend/firebase.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'dart:math';

import '../style.dart';

class BarPage extends StatefulWidget {
  final String category;

  const BarPage({super.key, required this.category});

  @override
  _BarPageState createState() => _BarPageState();
}

class _BarPageState extends State<BarPage> {
  final DateTime _selectedDay = DateTime.now();

  @override
  void initState() {
    super.initState();
  }

  BarTouchData get barTouchData => BarTouchData(
        enabled: true,
        touchTooltipData: BarTouchTooltipData(
          tooltipBgColor: Colors.transparent,
          tooltipPadding: EdgeInsets.zero,
          tooltipMargin: 8,
          getTooltipItem: (
            BarChartGroupData group,
            int groupIndex,
            BarChartRodData rod,
            int rodIndex,
          ) {
            return BarTooltipItem(
              rod.toY.round().toString(),
              GoogleFonts.outfit(
                textStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Style.accent1,
                ),
              ),
            );
          },
        ),
      );

  Widget getTitles(double value, TitleMeta meta) {
    String text;
    switch (value.toInt()) {
      case 0:
        text = 'Mon';
        break;
      case 1:
        text = 'Tue';
        break;
      case 2:
        text = 'Wed';
        break;
      case 3:
        text = 'Thu';
        break;
      case 4:
        text = 'Fri';
        break;
      case 5:
        text = 'Sat';
        break;
      case 6:
        text = 'Sun';
        break;
      default:
        text = '';
        break;
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 4,
      child: secondaryTileText(text),
    );
  }

  Widget getMedicationSideTitle(double value, TitleMeta meta) {
    // switch (value%2) {
    //   case 0:
        return SideTitleWidget(
          axisSide: AxisSide.left,
          space: 4,
          child: secondaryTileText(value.toInt().toString()),
        );
    //   default:
    //     return SideTitleWidget(
    //       axisSide: AxisSide.left,
    //       space: 4,
    //       child: secondaryTileText(''),
    //     );
    // }
  }

  Widget getStepsSideTitle(double value, TitleMeta meta) {
    switch (value%2000) {
      case 0:
        return SideTitleWidget(
          axisSide: AxisSide.left,
          space: 4,
          child: secondaryTileText(value.toInt().toString()),
        );
      default:
        return SideTitleWidget(
          axisSide: AxisSide.left,
          space: 4,
          child: secondaryTileText(''),
        );
    }
  }

  FlTitlesData titleData(String category){
    switch (category){
      case 'Medications'||'Attacks':
        return FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              getTitlesWidget: getTitles,
              interval: 1,
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              interval: 1,
              getTitlesWidget: getMedicationSideTitle,
            ),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        );
      case 'Steps':
        return FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              getTitlesWidget: getTitles,
              interval: 1,
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 50,
              interval: 500,
              getTitlesWidget: getStepsSideTitle,
            ),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        );
    }
    return FlTitlesData(
      show: true,
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 60,
          getTitlesWidget: getTitles,
          interval: 1,
        ),
      ),
      leftTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 60,
          interval: 2,
          getTitlesWidget: getMedicationSideTitle,
        ),
      ),
      topTitles: const AxisTitles(
        sideTitles: SideTitles(showTitles: false),
      ),
      rightTitles: const AxisTitles(
        sideTitles: SideTitles(showTitles: false),
      ),
    );
  }

  FlBorderData get borderData => FlBorderData(
      show: true,
      border: const Border(
        bottom: BorderSide(
          color: Style.accent2,
          width: 1,
        ),
        left: BorderSide(
          color: Style.accent2,
          width: 1,
        ),
      ));

  List<BarChartGroupData> getMedication(List<int> barData) {
    var dailyUsage = barData;
    List<BarChartGroupData> barGroups = [];
    for (var i = 0; i < dailyUsage.length; i++) {
      barGroups.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: dailyUsage[i].toDouble(),
              color: Style.success,
              width: 20,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(0),
                topRight: Radius.circular(0),
              ),
            )
          ],
          showingTooltipIndicators: [0],
        ),
      );
    }
    return barGroups;
  }

  List<BarChartGroupData> getSteps(List<int> barData) {
    List<BarChartGroupData> barGroups = [];
    for (var i = 0; i < barData.length; i++) {
      barGroups.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: barData[i].toDouble(),
              color: Style.warning,
              width: 20,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(0),
                topRight: Radius.circular(0),
              ),
            )
          ],
          showingTooltipIndicators: [0],
        ),
      );
    }
    return barGroups;
  }

  List<BarChartGroupData> getAttacks(List<Map<String,dynamic>> barData){
    List<BarChartGroupData> barGroups = [];
    for (var i = 0; i < barData.length; i++) {
      var data = barData[i];
      barGroups.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: data['Total'].toDouble(),
              rodStackItems: [
                BarChartRodStackItem(0, data['Severe'].toDouble(), Style.danger),
                BarChartRodStackItem(data['Severe'].toDouble(), data['Moderate'].toDouble()+data['Severe'].toDouble(), Style.warning),
                BarChartRodStackItem(data['Moderate'].toDouble()+data['Severe'].toDouble(), data['Total'].toDouble(), Style.warning2),
              ],
              color: Style.warning,
              width: 20,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(0),
                topRight: Radius.circular(0),
              ),
            )
          ],
          showingTooltipIndicators: [0],
        ),
      );
    }
    return barGroups;
  }


  _buildMedicationChart() {
    return FutureBuilder(
        future: FirebaseService().getWeeklyMedication(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: Style.primaryColor,
              ),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }
          if (snapshot.hasData) {
            List<int> barData = snapshot.data;
            return
                Stack(children: <Widget>[
                  AspectRatio(
                      aspectRatio: 1.8,
                      child: Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              20, 20, 20, 0),
                          child: BarChart(
                            BarChartData(
                              barTouchData: barTouchData,
                              titlesData: titleData(widget.category),
                              borderData: borderData,
                              barGroups: getMedication(barData),
                              gridData: FlGridData(
                                show: true,
                                verticalInterval: 1,
                                horizontalInterval: 1,
                                getDrawingVerticalLine: (value) {
                                  return const FlLine(
                                    color: Style.secondaryText,
                                    strokeWidth: 1,
                                  );
                                },
                              ),
                              maxY:(barData.reduce(max)<4)
                                ? 4
                                : barData.reduce(max)+1,
                            ),
                          ))),
            ]);
          }
          return Container(
            child: Text('No data for this category'),
          );
        });
  }

  _buildPefChart() {
    return Container(
      child: Text('Pef Chart'),
    );
  }

  _buildAttackChart() {

    int findMax(List<Map<String, dynamic>> weeklyAttack){
      int maxValue = weeklyAttack.reduce((curr, next) => curr['Total'] > next['Total'] ? curr : next)['Total'];
      return maxValue;
    }
    return FutureBuilder(
        future: FirebaseService().getWeeklyAttacks(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: Style.primaryColor,
              ),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }
          if (snapshot.hasData) {
            var barData = snapshot.data;
            return
              Stack(children: <Widget>[
                AspectRatio(
                    aspectRatio: 1.8,
                    child: Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(
                            10, 20, 20, 0),
                        child: BarChart(
                          BarChartData(
                            barTouchData: barTouchData,
                            titlesData: titleData(widget.category),
                            borderData: borderData,
                            barGroups: getAttacks(barData),
                            gridData: FlGridData(
                              show: true,
                              verticalInterval: 1,
                              horizontalInterval: 1,
                              getDrawingVerticalLine: (value) {
                                return const FlLine(
                                  color: Style.secondaryText,
                                  strokeWidth: 1,
                                );
                              },
                            ),
                            maxY:(findMax(barData)<4)
                                ? 4
                                : findMax(barData).toDouble()+2,
                          ),
                        ))),
              ]);
          }
          return Container(
            child: Text('No data for this category'),
          );
        });
  }

  _buildActChart() {
    return Container(
      child: Text('Act Chart'),
    );
  }

  _buildWeatherChart() {
    return Container(
      child: Text('Weather Chart'),
    );
  }

  _buildStepsChart() {
    return FutureBuilder(
        future: FirebaseService().getWeeklySteps(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: Style.primaryColor,
              ),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }
          if (snapshot.hasData) {
            List<int> barData = snapshot.data;
            return
              Stack(children: <Widget>[
                AspectRatio(
                    aspectRatio: 1.8,
                    child: Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(
                            10, 20, 20, 0),
                        child: BarChart(
                          BarChartData(
                            barTouchData: barTouchData,
                            titlesData: titleData(widget.category),
                            borderData: borderData,
                            barGroups: getSteps(barData),
                            gridData: FlGridData(
                              show: true,
                              verticalInterval: 1,
                              horizontalInterval: 500,
                              getDrawingVerticalLine: (value) {
                                return const FlLine(
                                  color: Style.secondaryText,
                                  strokeWidth: 1,
                                );
                              },
                            ),
                            maxY:(barData.reduce(max)<2500)
                                ? 2500
                                : barData.reduce(max)+2500,
                          ),
                        ))),
              ]);
          }
          return Container(
            child: Text('No data for this category'),
          );
        });
  }

  _buildPredictionChart() {
    return Container(
      child: Text('Prediction Chart'),
    );
  }

  @override
  Widget build(BuildContext context) {

    Widget infoWidget(String category){
      switch (category){
      case 'Medications': // Daily view
        return FutureBuilder(future: FirebaseService().getTodayMedicationCount(), builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (snapshot.hasData) {
            return Column(
              children: [
                Text(
            snapshot.data,
                  style: GoogleFonts.outfit(
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 40,
                    ),
                  ),
                ),
                Text(
                  'used',
                  style: GoogleFonts.outfit(
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 18,
                      color: Style.secondaryText,
                    ),
                  ),
                ),
                Text(
                  DateFormat('MMM dd, yyyy  HH:mm').format(DateTime.now()),
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
            );
          }
          return Container(
            child: Text('No data for this category'),
          );
        });
      case 'Steps':
        return FutureBuilder(future: FirebaseService().getTotalStepsForToday(), builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (snapshot.hasData) {
            return Column(
              children: [
                Text(
                  snapshot.data.toString(),
                  style: GoogleFonts.outfit(
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 40,
                    ),
                  ),
                ),
                Text(
                  'steps',
                  style: GoogleFonts.outfit(
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 18,
                      color: Style.secondaryText,
                    ),
                  ),
                ),
                Text(
                  DateFormat('MMM dd, yyyy  HH:mm').format(DateTime.now()),
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
            );
          }
          return Container(
            child: Text('No data for this category'),
          );
        });
        case 'Attacks':// Daily view
          return FutureBuilder(future: FirebaseService().getAttackForDay(DateTime.now()), builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            if (snapshot.hasData) {
              return Column(
                children: [
                  Text(
                    snapshot.data.length.toString(),
                    style: GoogleFonts.outfit(
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 40,
                      ),
                    ),
                  ),
                  Text(
                    'attacks',
                    style: GoogleFonts.outfit(
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 18,
                        color: Style.secondaryText,
                      ),
                    ),
                  ),
                  Text(
                    DateFormat('MMM dd, yyyy  HH:mm').format(DateTime.now()),
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
              );
            }
            return Container(
              child: Text('No data for this category'),
            );
          });

        // Always display the current heart rate for the daily view
      }
      return Container();
      // } else if (widget.category == 'week' && selectedBarIndex != null) { // Weekly view and a bar is selected
      //   // Get the min and max heart rate for the selected day of the week
      //   List<double> heartRates = weeklyData
      //       .where((data) => (data['time'] as DateTime).weekday == selectedBarIndex!)
      //       .map((data) => double.parse(data['data'].replaceAll(' bpm', '')))
      //       .toList();
      //
      //   double minRate = heartRates.isNotEmpty ? heartRates.reduce(math.min) : 0.0;
      //   double maxRate = heartRates.isNotEmpty ? heartRates.reduce(math.max) : 0.0;
      //
      //   // Calculate the start of the week, then add the selected index (minus 1 because selectedBarIndex is 0-based and DateTime.now().weekday is 1-based)
      //   DateTime now = DateTime.now();
      //   int todayWeekday = now.weekday;
      //   DateTime firstDayOfWeek = now.subtract(Duration(days: todayWeekday));
      //   DateTime selectedDate = firstDayOfWeek.add(Duration(days: selectedBarIndex!));
      //
      //   return Column(
      //     children: [
      //       Text(
      //         heartRates.isNotEmpty ? '$minRate - $maxRate' : 'No Data',
      //         style: GoogleFonts.outfit(
      //           textStyle: const TextStyle(
      //             fontWeight: FontWeight.w500,
      //             fontSize: 32,
      //             color: Style.primaryText,
      //           ),
      //         ),
      //       ),
      //       Text(
      //         'bpm',
      //         style: GoogleFonts.outfit(
      //           textStyle: const TextStyle(
      //             fontWeight: FontWeight.normal,
      //             fontSize: 18,
      //             color: Style.secondaryText,
      //           ),
      //         ),
      //       ),
      //       Text(
      //         DateFormat('EEE, MMM dd').format(selectedDate),
      //         style: GoogleFonts.outfit(
      //           textStyle: const TextStyle(
      //             fontWeight: FontWeight.normal,
      //             fontSize: 18,
      //             color: Style.secondaryText,
      //           ),
      //         ),
      //       ),
      //     ],
      //   );
      // }
    }

    // Widget _buildSummaryWidget(BuildContext context) {
    //   // Switch between different summaries based on the selected tab.
    //   switch (widget.fetchType) {
    //     case 'day': // Day
    //       return summaryWidget("Daily Summary",
    //           calculateAverage(heartRateData),
    //           calculateMaximum(heartRateData),
    //           calculateMinimum(heartRateData)
    //       );
    //     case 'week': // Week
    //     // Calculate weekly stats based on the selectedBarIndex
    //     // Assuming you have a method to calculate these
    //       return summaryWidget("Weekly Summary",
    //           calculateOverallWeeklyAverage(weeklyData).toInt(),
    //           calculateOverallWeeklyMaximum(weeklyData).toInt(),
    //           calculateOverallWeeklyMinimum(weeklyData).toInt()
    //       );
    //     default:
    //       return const SizedBox.shrink();
    //   }
    // }

    switch (widget.category) {
      case 'Medications':
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(10, 0, 10, 0),
            child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 10, 0, 10),
                    child:Text(widget.category, style: GoogleFonts.outfit(
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 24,
                        color: Style.primaryText,
                      ),
                    ),),
                  ),
                  _buildMedicationChart(),
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
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(20, 20, 20, 10),
                          child: Column(
                            children: [
                              infoWidget(widget.category),
                              const Divider(
                                height: 32,
                                color: Style.accent4,
                                thickness: 2,
                                indent : 10,
                                endIndent : 10,
                              ),
                              summaryWidget(widget.category),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ]
            ),
          ),
        );
      case 'PEFs':
        return _buildPefChart();
      case 'Attacks':
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(10, 0, 10, 0),
            child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 10, 0, 10),
                    child:Text(widget.category, style: GoogleFonts.outfit(
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 24,
                        color: Style.primaryText,
                      ),
                    ),),
                  ),
                  _buildAttackChart(),
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
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(20, 20, 20, 10),
                          child: Column(
                            children: [
                              infoWidget(widget.category),
                              const Divider(
                                height: 32,
                                color: Style.accent4,
                                thickness: 2,
                                indent : 10,
                                endIndent : 10,
                              ),
                              summaryWidget(widget.category),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ]
            ),
          ),
        );
      case 'Asthma Control Tests':
        return _buildActChart();
      case 'Weathers':
        return _buildWeatherChart();
      case 'Steps':
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(10, 0, 10, 0),
            child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 10, 0, 10),
                    child:Text(widget.category, style: GoogleFonts.outfit(
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 24,
                        color: Style.primaryText,
                      ),
                    ),),
                  ),
                  _buildStepsChart(),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 16, 0, 0),
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
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(20, 20, 20, 10),
                          child: Column(
                            children: [
                              infoWidget(widget.category),
                              const Divider(
                                height: 32,
                                color: Style.accent4,
                                thickness: 2,
                                indent : 10,
                                endIndent : 10,
                              ),
                              summaryWidget(widget.category),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ]
            ),
          ),
        );;
      case 'Prediction':
        return _buildPredictionChart();
      default:
        return Container(
          child: Text('No data for this category'),
        );
    }
  }

  Widget summaryWidget(String category) {
    switch (category) {
      case 'Medications':
        return FutureBuilder(future: FirebaseService().getMedicationForWeek(DateTime.now()), builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(
              color: Style.primaryColor,
            ));
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (snapshot.hasData) {
            Map<String, int> medicationCountPerDay = {
              'Monday': 0,
              'Tuesday': 0,
              'Wednesday': 0,
              'Thursday': 0,
              'Friday': 0,
              'Saturday': 0,
              'Sunday': 0,
            };

            for (var medication in snapshot.data) {
              // Extract the date from the datetime and format it as a string
              DateTime date = medication['time'] as DateTime;

              // If the date is already in the map, increment the count
              if (medicationCountPerDay.containsKey(DateFormat('EEEE').format(date))) {
                medicationCountPerDay[DateFormat('EEEE').format(date)] =
                    (medicationCountPerDay[date] ?? 0) + 1;
              }
            }
            var dailyUsage = medicationCountPerDay.values.toList();
            return Column(
              children: [
                Text(
                  'Weekly Summary',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.outfit(
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                      color: Style.primaryText,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Average:',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        (dailyUsage.reduce((a, b) => a + b) / dailyUsage.length).toStringAsFixed(2),
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Maximum:',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        dailyUsage.reduce(max).toString(),
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 10, 0, 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total:',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        snapshot.data.length.toString(),
                        style: const TextStyle(
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
          return Container(
            child: Text('No data for this category'),
          );
        });
        case 'Steps':
          return FutureBuilder(future: FirebaseService().getWeeklySteps(), builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator(
                color: Style.primaryColor,
              ));
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            if (snapshot.hasData) {
              List<int> weeklySteps = snapshot.data;
              return Column(
                children: [
                  Text(
                    'Weekly Summary',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.outfit(
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                        color: Style.primaryText,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Average:',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          (weeklySteps.reduce((a, b) => a + b)/weeklySteps.length)
                                .toStringAsFixed(2),
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Maximum:',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          weeklySteps.reduce(max).toString(),
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 10, 0, 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total:',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          weeklySteps.reduce((a, b) => a + b).toString(),
                          style: const TextStyle(
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
            return Container(
              child: Text('No data for this category'),
            );
          });
      case 'Attacks':
        return FutureBuilder(future: FirebaseService().getTotalSeverityForWeek(), builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(
              color: Style.primaryColor,
            ));
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (snapshot.hasData) {
            Map<String,int> weeklyTotal = snapshot.data;
            return Column(
              children: [
                Text(
                  'Weekly Summary',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.outfit(
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                      color: Style.primaryText,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Mild',
                        style: TextStyle(
                          fontSize: 14,
                          color: Style.warning2,
                        ),
                      ),
                      Text(
                        weeklyTotal['Mild'].toString(),
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Moderate',
                        style: TextStyle(
                          fontSize: 14,
                          color: Style.warning,
                        ),
                      ),
                      Text(
                        weeklyTotal['Moderate'].toString(),
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Severe',
                        style: TextStyle(
                          fontSize: 14,
                          color: Style.danger,
                        ),
                      ),
                      Text(
                        weeklyTotal['Severe'].toString(),
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 10, 0, 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        weeklyTotal['Total'].toString(),
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
          return Container(
            child: Text('No data for this category'),
          );
        });
    }
    return Container(
      child: Text('No data for this category'),
    );

  }
}
