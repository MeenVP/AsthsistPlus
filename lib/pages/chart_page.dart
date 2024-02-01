import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../backend/firebase.dart';
import '../style.dart';

class heartRateChart extends StatefulWidget {
  const heartRateChart({super.key});

  @override
  State<heartRateChart> createState() => _heartRateChartState();
}

class _heartRateChartState extends State<heartRateChart> with TickerProviderStateMixin {
  List<Color> gradientColors = [
    Style.secondaryText,
    Style.pef,
  ];

  int currentHeartRate = 0;
  DateTime currentTimestamp = DateTime.now();
  bool showAvg = false;
  TabController? _tabController;
  List<FlSpot> heartRateData = [];

  void updateDisplayedHeartRate(int heartRate, DateTime timestamp) {
    setState(() {
      currentHeartRate = heartRate;
      currentTimestamp = timestamp;
    });
  }

  void getHeartRateDataForChart(DateTime date) async {
    var firebaseService = FirebaseService(); // Create an instance of FirebaseService
    var hrData = await firebaseService.getHRForDay(date); // Fetch the heart rate data

    // Convert the data to FlSpot objects for the chart
    List<FlSpot> heartRateSpots = hrData.map((data) {
      final x = (data['time'] as DateTime).millisecondsSinceEpoch.toDouble();
      final y = double.parse(data['data'].replaceAll(' bpm', ''));
      return FlSpot(x, y);
    }).where((spot) {
      // Filter out any heart rate values that are not within the typical range
      return spot.y >= 0 && spot.y <= 150;
    }).toList();

    // Update the state to reflect the new data
    setState(() {
      // Assuming you have a member variable to hold the chart data
      this.heartRateData = heartRateSpots;
      // Update the current heart rate and timestamp to the latest data point
      if (heartRateSpots.isNotEmpty) {
        final latestSpot = heartRateSpots.last;
        updateDisplayedHeartRate(latestSpot.y.toInt(), DateTime.now());
      }else{
        Text('no data');
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    DateTime today = DateTime.now();
    getHeartRateDataForChart(today);
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
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
      case 'M':
        startTime = now.subtract(Duration(days: 30));
        break;
      default:
        startTime = DateTime(now.year, now.month, now.day);
        break;
    }

    print('Time Span: $timeSpan');
    print('Start Time: $startTime');
    print('Current Time: $now');

    List<FlSpot> spots = heartRateData.where((spot) {
      DateTime spotTime = DateTime.fromMillisecondsSinceEpoch(spot.x.toInt());
      return spotTime.isAfter(startTime) && spotTime.isBefore(now);
    }).toList();

    print('Number of Spots for $timeSpan: ${spots.length}');
    for (var spot in spots) {
      print('x: ${spot.x}, y: ${spot.y}');
    }

    return spots;
  }

  int calculateAverage(List<FlSpot> data) {
    if (data.isEmpty) return 0;

    double sum = 0;
    for (var spot in data) {
      sum += spot.y;
    }

    double average = sum / data.length;

    return average.round(); // Convert the average to an integer
  }

  int calculateMaximum(List<FlSpot> data) {
    if (data.isEmpty) return 0;

    double max = data.first.y;
    for (var spot in data) {
      if (spot.y > max) {
        max = spot.y;
      }
    }
    return max.round();
  }

  int calculateMinimum(List<FlSpot> data) {
    if (data.isEmpty) return 0;

    double min = data.first.y;
    for (var spot in data) {
      if (spot.y < min) {
        min = spot.y;
      }
    }
    return min.round();
  }


  @override
  Widget build(BuildContext context) {
    int average = calculateAverage(heartRateData);
    int maximum = calculateMaximum(heartRateData);
    int minimum = calculateMinimum(heartRateData);
    return SafeArea(
      child: DefaultTabController(
        length: 3, // Added
        initialIndex: 0, //Added
        child: Scaffold(
          appBar: AppBar(
            surfaceTintColor: Colors.transparent,
            title: Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0, 16, 0, 0),
              child: Text(
                  'Health Info',
                  style: GoogleFonts.outfit(
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 32,
                      color: Colors.black,
                    ),
                  )
              ),
            ),
            backgroundColor: Style.primaryBackground,
          ),
          backgroundColor: Style.primaryBackground,
          body: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 16),
            child: Column(
              children: [
                Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 16, 0, 0),
                    child: Material(
                        borderRadius:
                        const BorderRadius.all(Radius.circular(10)),
                        elevation: 1,
                        child: Container(
                            height: kToolbarHeight - 8.0,
                            decoration: BoxDecoration(
                              color: const Color(0xFFE1E3E9),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: TabBar(
                              controller: _tabController,
                              indicatorSize: TabBarIndicatorSize.tab,
                              indicator: BoxDecoration(
                                  borderRadius:
                                  BorderRadius.circular(10.0),
                                  color: Style.primaryColor
                              ),
                              dividerColor: Colors.transparent,
                              labelColor: Style.accent4,
                              unselectedLabelColor: Style.accent2,
                              tabs: const <Widget>[
                                Tab(text: 'D'),
                                Tab(text: 'W'),
                                Tab(text: 'M'),
                              ],
                            )
                        )
                    )
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 16, 0, 0),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: Style.secondaryBackground
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0, 16, 0, 0),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: MediaQuery.sizeOf(context).width * 0.9,
                                  height: 200,
                                  child: TabBarView(
                                    controller: _tabController,
                                    children: [
                                      chartView(0), //Day
                                      chartView(1), //Week
                                      chartView(2), //Month
                                    ],
                                  ),
                                ),
                              ]
                          ),
                        ),
                        Column(
                          children: [
                            Text(
                              '$currentHeartRate', // Dynamic heart rate value
                              style: GoogleFonts.outfit(
                                textStyle: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 40,
                                ),
                              ),
                            ),
                            const Text(
                              'bpm',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 20,
                                color: Colors.grey,
                              ),
                            ),
                            Text(
                              DateFormat('MMM dd, yyyy  HH:mm').format(currentTimestamp), // Dynamic timestamp
                              style: GoogleFonts.outfit(
                                textStyle: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 16, 0, 0),
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
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            const Text(
                              'Daily Summary',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Average:',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black,
                                    ),
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Text(
                                        '$average',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      const Text(
                                        'BPM',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ]
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Maximum:',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black,
                                    ),
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Text(
                                        '$maximum',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      const Text(
                                        'BPM',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ]
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Minimum:',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black,
                                    ),
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Text(
                                        '$minimum',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      const Text(
                                        'BPM',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget chartView(int index) {
    String timeSpan;
    switch (index) {
      case 0:
        timeSpan = 'D';
        break;
      case 1:
        timeSpan = 'W';
        break;
      case 2:
        timeSpan = 'M';
        break;
      default:
        timeSpan = 'D';
        break;
    }
    List<FlSpot> spots = getSpotsFromData(timeSpan);
    return Stack(
      children: <Widget>[
        AspectRatio(
          aspectRatio: 2.0,
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(0, 16, 0, 0),
            child: LineChart(
              mainData(spots),
            ),
          ),
        ),
      ],
    );
  }

  LineChartData mainData(List<FlSpot> spots) {
    // Set a fixed range for minY and maxY
    double minY = 0;
    double maxY = 150;

    // Calculate minX and maxX based on the spots data
    double minX = spots.isNotEmpty ? spots.first.x : 0;
    double maxX = spots.isNotEmpty ? spots.last.x : 0;


    FlSpot lastSpot = spots.isNotEmpty ? spots.last : FlSpot(0, 0);

    // double interval = 2 * 60 * 60 * 1000;

    // Adjust maxY slightly higher to ensure the top data point isn't at the very edge
    // maxY += 1;

    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        horizontalInterval: 50,
        verticalInterval: 1,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: const Color(0xffe7e8ec),
            strokeWidth: 1,
          );
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
            interval: 1,
            getTitlesWidget: bottomTitleWidgets,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: leftTitleWidgets, // Custom function for left titles
            reservedSize: 42,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: false,
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
      ],
    ),
      minX: minX,
      maxX: maxX,
      minY: minY,
      maxY: maxY,
      lineBarsData: [
        LineChartBarData(
          spots: spots,
          isCurved: true,
          color: Style.heartrate,
          barWidth: 2,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: true,
            getDotPainter: (spot, percent, barData, index) {
              // Show a prominent dot only for the last spot or the 'current' spot
              if (spot == lastSpot) {
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

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    // TextStyle style = TextStyle(
    //   color: Colors.black,
    //   fontWeight: FontWeight.bold,
    //   fontSize: 16,
    // );
    //
    // // Map the double values to time strings.
    // const timeLabels = {
    //   0: '00:00',
    //   6: '06:00',
    //   12: '12:00',
    //   18: '18:00',
    //   24: '23:59', // Assuming 24 represents the end of the day
    // };
    //
    // // Only show the label if it's defined in the map.
    // Widget text = timeLabels.containsKey(value.toInt())
    //     ? Text(timeLabels[value.toInt()]!, style: style)
    //     : Container(); // Return an empty container for values not in the map.
    //
    // return SideTitleWidget(
    //   axisSide: meta.axisSide,
    //   space: 8.0, // You can adjust the space for alignment
    //   child: text,
    // );
    return Text('Test return');
  }




  Widget leftTitleWidgets(double value, TitleMeta meta) {
    return Container();
  }
}