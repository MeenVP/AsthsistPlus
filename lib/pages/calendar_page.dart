import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:table_calendar/table_calendar.dart';
import 'build_data.dart';
import 'package:intl/intl.dart';
import '../style.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarState();
}

class _CalendarState extends State<CalendarPage> with TickerProviderStateMixin {
  TabController? _tabController;
  DateTime _selectedDay = DateTime.now();
  final CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  bool _isMinimized = true;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _initTabController();
  }

  // This function will initialize the TabController
  _initTabController() async {
    await Future.delayed(Duration.zero);
    setState(() {
      _tabController = TabController(length: 8, vsync: this);
    });
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: DefaultTabController(
            // Added
            length: 8, // Added
            initialIndex: 0, //Added
            child: Scaffold(
                appBar: AppBar(
                  automaticallyImplyLeading: false,
                  surfaceTintColor: Colors.transparent,
                  title: Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(0, 16, 0, 0),
                      child: Text(
                        'Calendar',
                        style: GoogleFonts.outfit(
                          textStyle: const TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 32,
                            color: Colors.black,
                          ),
                        ),
                      )),
                  backgroundColor: Style.primaryBackground,
                ),
                backgroundColor: Style.primaryBackground,
                body: Padding(
                    padding:
                        const EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
                    child: Column(children: [
                      Material(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(16)),
                        elevation: 2,
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: Style.secondaryBackground),
                          child: Column(children: [
                            Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    0, 8, 0, 8),
                                child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      _buildMinimizedCalendar(),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              Style.secondaryBackground,
                                          shape: const CircleBorder(),
                                        ),
                                        child: const Icon(Icons.calendar_month,
                                            color: Style.primaryColor),
                                        onPressed: () {
                                          setState(() {
                                            _isMinimized = !_isMinimized;
                                          });
                                        },
                                      ),
                                    ])),
                            _isMinimized
                                ? Container()
                                : _buildMaximizedCalendar(),
                          ]),
                        ),
                      ),
                      Padding(
                          padding:
                              const EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
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
                                        color: Style.secondaryBackground),
                                    dividerColor: Colors.transparent,
                                    labelColor: Style.accent4,
                                    labelPadding: const EdgeInsets.only(),
                                    unselectedLabelColor: Style.accent2,
                                    tabs: const <Widget>[
                                      Tab(
                                        icon: Icon(
                                          Icons.favorite_outline,
                                          color: Style.heartrate,
                                        ),
                                      ),
                                      Tab(
                                        icon: Icon(Icons.medication_outlined,
                                            color: Style.medication),
                                      ),
                                      Tab(
                                        icon: Icon(
                                            Icons.health_and_safety_outlined,
                                            color: Style.pef),
                                      ),
                                      Tab(
                                        icon: Icon(Icons.heart_broken_outlined,
                                            color: Style.primaryColor),
                                      ),
                                      Tab(
                                        icon: Icon(Icons.inventory_outlined,
                                            color: Style.act),
                                      ),
                                      Tab(
                                        icon: Icon(Icons.cloud_outlined,
                                            color: Style.air),
                                      ),
                                      Tab(
                                        icon: Icon(
                                            Icons.directions_walk_outlined,
                                            color: Style.warning),
                                      ),
                                      Tab(
                                        icon: Icon(Icons.online_prediction,
                                            color: Style.tertiaryColor),
                                      ),
                                    ],
                                  )))),
                      Flexible(
                        child: TabBarView(
                          controller: _tabController,
                          children: <Widget>[
                            CategoryList(
                              category: 'Heart rates',
                              date: _selectedDay,
                            ),
                            CategoryList(
                                category: 'Medications', date: _selectedDay),
                            CategoryList(category: 'PEFs', date: _selectedDay),
                            CategoryList(
                                category: 'Attacks', date: _selectedDay),
                            CategoryList(
                                category: 'Asthma Control Tests',
                                date: _selectedDay),
                            CategoryList(
                                category: 'Weathers', date: _selectedDay),
                            CategoryList(category: 'Steps', date: _selectedDay),
                            CategoryList(
                                category: 'Predictions', date: _selectedDay),
                          ],
                        ),
                      ),
                    ])))));
  }

  // This function will build the maximized calendar
  Widget _buildMaximizedCalendar() {
    return TableCalendar(
      firstDay: DateTime.utc(2010, 10, 16),
      lastDay: DateTime.utc(2030, 3, 14),
      focusedDay: _focusedDay,
      calendarFormat: _calendarFormat,
      selectedDayPredicate: (day) {
        return isSameDay(_selectedDay, day);
      },
      availableCalendarFormats: const {
        CalendarFormat.month: 'Month',
      },
      onDaySelected: (selectedDay, focusedDay) {
        setState(() {
          _selectedDay = selectedDay;
          _focusedDay = focusedDay;
        });
      },
      onPageChanged: (focusedDay) {
        _focusedDay = focusedDay;
      },
      calendarStyle: const CalendarStyle(
        selectedDecoration: BoxDecoration(
          color: Style.primaryColor, // Color for selected day
          shape: BoxShape.circle,
        ),
        todayDecoration: BoxDecoration(
          color: Style.primaryColorLight, // Color for today
          shape: BoxShape.circle,
        ),
      ),
    );
  }

  // This function will build the minimized calendar
  Widget _buildMinimizedCalendar() {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 16),
      child: primaryTileText(
        DateFormat('MMMM d, y').format(_selectedDay),
      ),
    );
  }
}
