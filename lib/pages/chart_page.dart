import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../backend/firebase.dart';
import '../style.dart';

class HeartRateChart extends StatefulWidget {
final String fetchType;

  const HeartRateChart({super.key, required this.fetchType});

  @override
  State<HeartRateChart> createState() => _HeartRateChartState();
}

class _HeartRateChartState extends State<HeartRateChart> with TickerProviderStateMixin {

  List<Color> gradientColors = [
    Style.secondaryText,
    Style.pef,
  ];

  int currentHeartRate = 0;
  DateTime currentTimestamp = DateTime.now();
  List<FlSpot> heartRateData = [];
  List<Map<String, dynamic>> weeklyData = [];
  int? selectedBarIndex;

  int maxHeartRate = 0;

  @override
  void initState() {
    super.initState();
    fetchDataForCurrentTab(); // Fetch initial data// Fetch data on tab change
  }

  @override
  void dispose() {
    super.dispose();
  }

  // Fetches heart rate data based on the currently selected tab.
  void fetchDataForCurrentTab() {
    // Prevent data fetching during tab transition.// Only fetch data when tab selection is finalized
    DateTime now = DateTime.now();
    // Fetch heart rate data based on the selected time span.
    getHeartRateDataForChart(now, widget.fetchType);
  }

  // Processes daily heart rate data and updates the state.
  void processDayData(List<Map<String, dynamic>> hrData) {
    if (!mounted) return;
    List<FlSpot> heartRateSpots = hrData.map((data) {
      final x = (data['time'] as DateTime).millisecondsSinceEpoch.toDouble();
      final y = double.parse(data['data'].replaceAll(' bpm', ''));
      return FlSpot(x, y);
    }).toList();
    setState(() {
      heartRateData = heartRateSpots;
      if (hrData.isNotEmpty) {
        currentTimestamp = hrData.first['time'];
        currentHeartRate = double.parse(hrData.first['data'].replaceAll(' bpm', '')).toInt();
      } else {
        currentHeartRate = 0; // Placeholder or default value
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("No heart rate data available."),
        ));
      }
    });
  }

  void processWeekData(List<Map<String, dynamic>> hrData) {
    if (!mounted) return;
    // Assume hrData is pre-processed to minimize necessary transformations
    setState(() {
      weeklyData = hrData;
      selectedBarIndex = DateTime.now().weekday; // Automatically select current day
      if (hrData.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("No heart rate data available."),
        ));
      }
    });
  }

  // Fetches heart rate data from Firebase and processes it according to the fetch type.
  void getHeartRateDataForChart(DateTime date, String fetchType) async {
    var firebaseService = FirebaseService();
    List<Map<String, dynamic>> hrData = [];
    switch (fetchType) {
      case 'day':
        hrData = await firebaseService.getHRForDay(date);
        maxHeartRate = await firebaseService.getUserMaxHR();
        if (mounted) {
          processDayData(hrData);
        }
        break;
      case 'week':
        hrData = await firebaseService.getHRForWeek(date);
        maxHeartRate = await firebaseService.getUserMaxHR();
        if (mounted) {
          processWeekData(hrData);
        }
        break;
    }
  }

  List<FlSpot> getSpotsFromData(String timeSpan) {
    DateTime now = DateTime.now();
    DateTime startTime;

    switch (timeSpan) {
      case 'D':
        startTime = DateTime(now.year, now.month, now.day);
        break;
      case 'W':
        startTime = now.subtract(Duration(days: 7));
        break;
      default:
        startTime = DateTime(now.year, now.month, now.day);
        break;
    }

    List<FlSpot> spots = heartRateData.where((spot) {
      DateTime spotTime = DateTime.fromMillisecondsSinceEpoch(spot.x.toInt());
      return spotTime.isAfter(startTime) && spotTime.isBefore(now);
    }).toList();

    return spots;
  }

  // Calculates and returns the average heart rate from a list of FlSpot objects.
  int calculateAverage(List<FlSpot> data) {
    if (data.isEmpty) return 0;

    double sum = 0;
    for (var spot in data) {
      sum += spot.y;
    }

    double average = sum / data.length;

    return average.toInt();
  }

  // Calculates and returns the maximum heart rate from a list of FlSpot objects.
  int calculateMaximum(List<FlSpot> data) {
    if (data.isEmpty) return 0;

    double max = data.first.y;
    for (var spot in data) {
      if (spot.y > max) {
        max = spot.y;
      }
    }
    return max.toInt();
  }

  // Calculates and returns the minimum heart rate from a list of FlSpot objects.
  int calculateMinimum(List<FlSpot> data) {
    if (data.isEmpty) return 0;

    double min = data.first.y;
    for (var spot in data) {
      if (spot.y < min) {
        min = spot.y;
      }
    }
    return min.toInt();
  }

  // Calculate the overall maximum heart rate for the week
  int calculateOverallWeeklyMaximum(List<Map<String, dynamic>> hrData) {
    List<double> allValues = hrData
        .map((data) => double.parse(data['data'].replaceAll(' bpm', '')))
        .toList();
    return allValues.isNotEmpty ? allValues.reduce(math.max).round() : 0;
  }

  // Calculate the overall minimum heart rate for the week
  int calculateOverallWeeklyMinimum(List<Map<String, dynamic>> hrData) {
    List<double> allValues = hrData
        .map((data) => double.parse(data['data'].replaceAll(' bpm', '')))
        .toList();
    return allValues.isNotEmpty ? allValues.reduce(math.min).round() : 0;
  }

  // Calculate the overall average heart rate for the week
  double calculateOverallWeeklyAverage(List<Map<String, dynamic>> hrData) {
    List<double> allValues = hrData
        .map((data) => double.parse(data['data'].replaceAll(' bpm', '')))
        .toList();
    return allValues.isNotEmpty ? allValues.reduce((a, b) => a + b) / allValues.length : 0;
  }

  // Creates and returns a widget displaying a summary of heart rate data.
  Widget _buildSummaryWidget(BuildContext context) {
    // Switch between different summaries based on the selected tab.
    switch (widget.fetchType) {
      case 'day': // Day
        return summaryWidget("Daily Summary",
            calculateAverage(heartRateData),
            calculateMaximum(heartRateData),
            calculateMinimum(heartRateData)
        );
      case 'week': // Week
          // Calculate weekly stats based on the selectedBarIndex
          // Assuming you have a method to calculate these
          return summaryWidget("Weekly Summary",
              calculateOverallWeeklyAverage(weeklyData).toInt(),
              calculateOverallWeeklyMaximum(weeklyData).toInt(),
              calculateOverallWeeklyMinimum(weeklyData).toInt()
          );
      default:
        return const SizedBox.shrink();
    }
  }

  // The summary widget for day and week
  Widget summaryWidget(String title, int average, int maximum, int minimum) {
    return Column(
      children: [
        Text(
          title,
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
                '$average bpm',
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
                '$maximum bpm',
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
                'Minimum:',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                ),
              ),
              Text(
                '$minimum bpm',
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

  @override
  Widget build(BuildContext context) {
    // Custom widget for displaying heart rate information based on the selected time span.
    Widget heartRateInfoWidget() {
      if (widget.fetchType=='day') { // Daily view
        // Always display the current heart rate for the daily view
        return Column(
          children: [
            Text(
              '$currentHeartRate',
              style: GoogleFonts.outfit(
                textStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 40,
                ),
              ),
            ),
            Text(
              'bpm',
              style: GoogleFonts.outfit(
                textStyle: const TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 18,
                  color: Style.secondaryText,
                ),
              ),
            ),
            Text(
              DateFormat('MMM dd, yyyy  HH:mm').format(currentTimestamp), // Dynamic timestamp
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
      } else if (widget.fetchType == 'week' && selectedBarIndex != null) { // Weekly view and a bar is selected
        // Get the min and max heart rate for the selected day of the week
        List<double> heartRates = weeklyData
            .where((data) => (data['time'] as DateTime).weekday == selectedBarIndex!)
            .map((data) => double.parse(data['data'].replaceAll(' bpm', '')))
            .toList();

        double minRate = heartRates.isNotEmpty ? heartRates.reduce(math.min) : 0.0;
        double maxRate = heartRates.isNotEmpty ? heartRates.reduce(math.max) : 0.0;

        // Calculate the start of the week, then add the selected index (minus 1 because selectedBarIndex is 0-based and DateTime.now().weekday is 1-based)
        DateTime now = DateTime.now();
        int todayWeekday = now.weekday;
        DateTime firstDayOfWeek = now.subtract(Duration(days: todayWeekday));
        DateTime selectedDate = firstDayOfWeek.add(Duration(days: selectedBarIndex!));

        return Column(
          children: [
            Text(
                heartRates.isNotEmpty ? '$minRate - $maxRate' : 'No Data',
              style: GoogleFonts.outfit(
                textStyle: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 32,
                  color: Style.primaryText,
                ),
              ),
            ),
            Text(
                'bpm',
              style: GoogleFonts.outfit(
                textStyle: const TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 18,
                  color: Style.secondaryText,
                ),
              ),
            ),
            Text(
              DateFormat('EEE, MMM dd').format(selectedDate),
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
      return Container();
    }
    return SafeArea(
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(10, 0, 10, 0),
        child: Column(
          children: [
            chartView(widget.fetchType),
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
                    padding: EdgeInsetsDirectional.fromSTEB(20, 10, 20, 10),
                    child: Column(
                      children: [
                        heartRateInfoWidget(),
                        const Divider(
                          height: 32,
                          color: Style.accent4,
                          thickness: 2,
                          indent : 10,
                          endIndent : 10,
                        ),
                        _buildSummaryWidget(context),
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
  }

  Widget chartView(String index) {

    switch (index) {
      case 'day': // Day
        List<FlSpot> daySpots = getSpotsFromData('D');
        if (daySpots.isEmpty) {
          // Handle the case where there's no data
          return Center(child: Text('No data available for this day.'));
        }
        return Stack(
          children: <Widget>[
            AspectRatio(
              aspectRatio: 1.6,
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                child: LineChart(
                  mainData(daySpots),
                ),
              ),
            ),
          ],
        );
      case 'week': // Week
        return Stack(
          children: <Widget>[
            AspectRatio(
              aspectRatio: 1.6,
              child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                  child:BarChart(mainWeeklyBarData())
              ),
            ),
          ],
        );
      default:
        return Container(); // Just in case something goes wrong
    }
  }

  HorizontalLine showExtraLines(){
    if(maxHeartRate!=0){
      return HorizontalLine(
        y: maxHeartRate.toDouble(),
        color: Style.heartrate,
        strokeWidth: 1,
        dashArray: [5,5],
      );
    }else{
      return HorizontalLine(
        y: 0,
        color: Colors.transparent,
        strokeWidth: 0,
      );
    }
  }

  // Creates and configures a line chart with heart rate data.
  LineChartData mainData(List<FlSpot> reversedSpots) {
    reversedSpots = List.from(heartRateData.reversed);
    // Set a fixed range for minY and maxY
    double minY = 0;
    double maxY = 150;
    DateTime now = DateTime.now();
    DateTime minTime = DateTime(now.year, now.month, now.day);
    DateTime maxTime = DateTime(now.year, now.month, now.day, 23, 59,59);

    // Calculate minX and maxX based on the spots data
    double minX = minTime.millisecondsSinceEpoch.toDouble();
    double maxX = maxTime.millisecondsSinceEpoch.toDouble();

    FlSpot lasttSpot = reversedSpots.isNotEmpty ? reversedSpots.last : FlSpot(0, 0);
    // print('test list reversed: ${reversedSpots}');



    return LineChartData(
      extraLinesData: ExtraLinesData(
        horizontalLines: [
          HorizontalLine(
            y: 0,
            color: const Color(0xffe7e8ec),
            strokeWidth: 1,
          ),
          HorizontalLine(
            y: 150,
            color: const Color(0xffe7e8ec),
            strokeWidth: 1,
          ),
          showExtraLines()
        ]
      ),
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        horizontalInterval: 50,
        verticalInterval: 3600000,
        getDrawingHorizontalLine: (value) {
          return const FlLine(
            color: Color(0xffe7e8ec),
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          DateTime time = DateTime.fromMillisecondsSinceEpoch(value.toInt());
          switch (time.hour){
            case 0||6||12||18||23:
              return const FlLine(
                color: Color(0xffe7e8ec),
                strokeWidth: 1,
                dashArray: [5,5]
              );
              default:
                return const FlLine(
                  color: Color(0xffe7e8ec),
                  strokeWidth: 0,
                );
          }
          // return const FlLine(
          //   color: Color(0xffe7e8ec),
          //   strokeWidth: 1,
          // );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            getTitlesWidget: bottomTitleWidgets,
            interval: 3600000,
          ),
        ),
        rightTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: rightTitleWidgets,
            reservedSize: 42,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 50,
            interval: 1,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      minX: minX,
      maxX: maxX,
      minY: minY,
      maxY: maxY,
      lineBarsData: [
        LineChartBarData(
          spots: reversedSpots,
          isCurved: true,
          color: Style.heartrate,
          barWidth: 3,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: true,
            getDotPainter: (spot, percent, barData, index) {
              // Show a prominent dot only for the last spot or the 'current' spot
              if (spot == lasttSpot) {
                return FlDotCirclePainter(
                  radius: 4,
                  color: Colors.white,
                  strokeWidth: 2,
                  strokeColor: Style.heartrate,
                );
              }
              return FlDotCirclePainter(radius: 0); // No other dots
            },
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: [
                Style.heartrate.withOpacity(0.3),
                Style.heartrate.withOpacity(0.01),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ],
    );
  }

  // Handles custom formatting for bottom axis titles based on the tab and data.
  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff68737d),
      fontWeight: FontWeight.bold,
      fontSize: 13,
    );
    var label = '';

    // var dateTime = DateTime.fromMillisecondsSinceEpoch(value.toInt());
    // var formattedTime = DateFormat('HH:mm').format(dateTime); // Example: 15:04
    //
    // var label = '';
    // if (_tabController?.index == 0) { // Day view
    //   if (value == heartRateData.first.x) {
    //     label = '$formattedTime';
    //   }
    // } else{
    //   label = '';
    // }
    DateTime time = DateTime.fromMillisecondsSinceEpoch(value.toInt());
    switch(time.hour) {
      case 0:
        if (time.minute == 0 && time.second == 0) {
          label = '00:00';
        }
        break;
      case 6:
          label = '06:00';
        break;
      case 12:
          label = '12:00';
        break;
      case 18:
          label = '18:00';
        break;
      case 23:
        if (time.minute == 59 && time.second == 59) {
          label = '23:59';
        }
        break;
    }


    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: secondaryTileText(label),
    );
  }

  Widget rightTitleWidgets(double value, TitleMeta meta) {
    return Container();
  }
  // Handles custom formatting for left axis titles.
  Widget leftTitleWidgets(double value, TitleMeta meta) {
    Color color = Style.accent1;
    String text;
    if (value.toInt()==maxHeartRate){
      return Padding(
        padding: const EdgeInsets.only(left: 15), // Add padding if needed
        child: Text(
          maxHeartRate.toString(),
          style: GoogleFonts.outfit(
            textStyle: const TextStyle(
              fontWeight: FontWeight.normal,
              fontSize: 14,
              color: Style.heartrate,
            ),
          ),
        ),
      );
    }
    switch (value.toInt()) {
      case 0:
        text = '0';
        break;
      case 50:
        text = '50';
        break;
      case 100:
        text = '100';
        break;
      case 150:
        text = '150';
        break;
      default:
        return Container(); // Return an empty container for non-labeled values
    }
    return Padding(
      padding: const EdgeInsets.only(left: 15), // Add padding if needed
      child: Text(
        text,
        style: GoogleFonts.outfit(
          textStyle: TextStyle(
            fontWeight: FontWeight.normal,
            fontSize: 14,
            color: color,
          ),
        ),
    ));
  }

  // Custom bar chart configuration for weekly data visualization.
  BarChartData mainWeeklyBarData() {
    // Your existing code to find the min and max values per day
    Map<int, List<double>> minMaxByDay = {1: [], 2: [], 3: [], 4: [], 5: [], 6: [], 7: []};
    for (var data in weeklyData) {
      int dayOfWeek = (data['time'] as DateTime).weekday;
      double value = double.parse(data['data'].replaceAll(' bpm', ''));
      minMaxByDay[dayOfWeek]!.add(value);
    }

    // Create bar groups using min and max values
    List<BarChartGroupData> barGroups = List.generate(7, (index) {
      bool isSelected = index + 1 == selectedBarIndex;
      List<double> dailyValues = minMaxByDay[index + 1] ?? [];
      double minY = dailyValues.isNotEmpty ? dailyValues.reduce(math.min) : 0;
      double maxY = dailyValues.isNotEmpty ? dailyValues.reduce(math.max) : 0;

      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: maxY,
            fromY: minY,
            color: isSelected ? Colors.red : Style.heartrate,
            width: 14,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      );
    });

    return BarChartData(
      maxY: 150,
      minY: 0,
      barGroups: barGroups,
      titlesData: FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: getWeekdayTitle, // Implement this function to show day names
            reservedSize: 30,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: leftTitleWidgets, // Implement this function to show left titles
            reservedSize: 50,
            interval: 1,
          ),
        ),
        rightTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: rightTitleWidgets, // Custom function for left titles
            reservedSize: 20,
          ),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      ),
      extraLinesData: ExtraLinesData(
        horizontalLines: [
          HorizontalLine(
            y: 0,
            color: const Color(0xffe7e8ec),
            strokeWidth: 1,
          ),
          HorizontalLine(
            y: 150,
            color: const Color(0xffe7e8ec),
            strokeWidth: 1,
          ),
          showExtraLines()
        ],
      ),
      barTouchData: BarTouchData(
        handleBuiltInTouches: false,
        touchCallback: (FlTouchEvent event, BarTouchResponse? response) {
        if (!mounted) return;
          if (event is FlTapUpEvent && response != null && response.spot != null) {
            // If a bar is tapped, update the selectedBarIndex to that bar's index
            setState(() {
              selectedBarIndex = response.spot!.touchedBarGroupIndex + 1;
            });
          } else {
            // Do not set selectedBarIndex to null, as we want to always display the current day's data
            // Comment out or remove the setState call that sets selectedBarIndex to null
          }
        }
      ),
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        horizontalInterval: 50,
        // verticalInterval: 1,
        getDrawingHorizontalLine: (value) {
          return const FlLine(
            color: Color(0xffe7e8ec),
            strokeWidth: 1,
          );
        },
      ),
      borderData: FlBorderData(show: false),
      alignment: BarChartAlignment.spaceAround,
    );
  }

  Widget getWeekdayTitle(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff68737d),
      fontWeight: FontWeight.bold,
      fontSize: 13,
    );
    String weekday;
    switch (value.toInt()) {
      case 0:
        weekday = 'Mon';
        break;
      case 1:
        weekday = 'Tue';
        break;
      case 2:
        weekday = 'Wed';
        break;
      case 3:
        weekday = 'Thu';
        break;
      case 4:
        weekday = 'Fri';
        break;
      case 5:
        weekday = 'Sat';
        break;
      case 6:
        weekday = 'Sun';
        break;
      default:
        return Container();
    }
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: secondaryTileText(weekday),
    );
  }
}