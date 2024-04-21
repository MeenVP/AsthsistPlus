import 'package:asthsist_plus/pages/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:asthsist_plus/pages/home_page.dart';
import 'package:asthsist_plus/style.dart';
import 'package:google_fonts/google_fonts.dart';

import 'calendar_page.dart';
import 'chart_page.dart';
import 'health_info.dart';

class NavigationBarApp extends StatefulWidget {
  final int initialPageIndex;

  const NavigationBarApp({Key? key, this.initialPageIndex = 0}) : super(key: key);

  @override
  State<NavigationBarApp> createState() => _NavigationState();
}

class _NavigationState extends State<NavigationBarApp> {
  late int currentPageIndex;
  @override
  void initState() {
    super.initState();
    currentPageIndex = widget.initialPageIndex;
  }
  static const List<Widget> _widgetOptions = <Widget>[
    HomePage(),
    CalendarPage(),
    HealthInfoPage(),
    // HeartRateChart(),
    SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Style.primaryBackground,
      body: Center(
        child: _widgetOptions.elementAt(currentPageIndex),
      ),
      bottomNavigationBar:
      BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: true,
        showSelectedLabels: true,
        elevation: 20,
        backgroundColor: Style.secondaryBackground,
        selectedItemColor: Style.primaryColor,
        unselectedItemColor: Style.accent2,
        currentIndex: currentPageIndex,
        onTap: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        selectedLabelStyle: GoogleFonts.outfit(
          textStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: Style.primaryColor,
          ),
        ),
        unselectedLabelStyle: GoogleFonts.outfit(
          textStyle: const TextStyle(
            fontWeight: FontWeight.w300,
            fontSize: 12,
            color: Style.accent1,
          ),
        ),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            activeIcon: Icon(Icons.home),
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            activeIcon: Icon(Icons.date_range),
            icon: Icon(Icons.date_range_outlined),
            label: 'Calendar',
          ),
          BottomNavigationBarItem(
            activeIcon: Icon(Icons.monitor_heart),
            icon: Icon(Icons.monitor_heart_outlined),
            label: 'Health',
          ),
          BottomNavigationBarItem(
            activeIcon: Icon(Icons.manage_accounts),
            icon: Icon(Icons.manage_accounts_outlined),
            label: 'Profiles',
          ),
        ],
      ),
    );
  }
}
