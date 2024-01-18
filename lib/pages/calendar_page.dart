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
  DateTime? _selectedDay;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();

  bool _isMinimized = false;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _initTabController();
  }

  _initTabController() async {
    await Future.delayed(Duration.zero);
    setState(() {
      _tabController = TabController(length: 4, vsync: this);
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
            length: 4, // Added
            initialIndex: 0, //Added
            child: Scaffold(
                appBar: AppBar(
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
                        const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 16),
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
                                          shape: const CircleBorder(),
                                        ),
                                        child: const Icon(Icons.calendar_month),
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
                              const EdgeInsetsDirectional.fromSTEB(0, 16, 0, 0),
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
                                        color: Style.tertiaryColor),
                                    dividerColor: Colors.transparent,
                                    labelColor: Style.accent4,
                                    unselectedLabelColor: Style.accent2,
                                    tabs: const <Widget>[
                                      Tab(
                                        icon:
                                            Icon(Icons.monitor_heart_outlined),
                                      ),
                                      Tab(
                                        icon: Icon(Icons.medication_outlined),
                                      ),
                                      Tab(
                                        icon: Icon(Icons.air_outlined),
                                      ),
                                      Tab(
                                        icon: Icon(Icons.heart_broken_outlined),
                                      ),
                                    ],
                                  )))),
                      Flexible(
                        child: TabBarView(
                          controller: _tabController,
                          children: <Widget>[
                            buildCategoryView('Category1'),
                            buildCategoryView('Category2'),
                            buildCategoryView('Category3'),
                            buildCategoryView('Category4'),
                          ],
                        ),
                      ),
                    ])))));
  }

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

  Widget _buildMinimizedCalendar() {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 16),
      child: primaryTileText(
        DateFormat('MMMM d, y').format(_selectedDay!),
      ),
    );
  }
}
