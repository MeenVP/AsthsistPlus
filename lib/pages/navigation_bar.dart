import 'package:flutter/material.dart';
import 'package:asthsist_plus/pages/home_page.dart';
import 'package:asthsist_plus/style.dart';

import 'calendar_page.dart';

class NavigationBarApp extends StatefulWidget {
  const NavigationBarApp({super.key});

  @override
  State<NavigationBarApp> createState() => _NavigationState();
}

class _NavigationState extends State<NavigationBarApp> {
  int currentPageIndex = 0;
  static const List<Widget> _widgetOptions = <Widget>[
    HomePage(),
    CalendarPage(),
    Text(
      'Index 2: Health Info',
    ),
    Text(
      'Index 3: Settings',
    ),
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
        showUnselectedLabels: false,
        showSelectedLabels: false,
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
        selectedLabelStyle: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            activeIcon: Icon(Icons.home),
            icon: Icon(Icons.home_outlined),
            label: '•',
          ),
          BottomNavigationBarItem(
            activeIcon: Icon(Icons.date_range),
            icon: Icon(Icons.date_range_outlined),
            label: '•',
          ),
          BottomNavigationBarItem(
            activeIcon: Icon(Icons.monitor_heart),
            icon: Icon(Icons.monitor_heart_outlined),
            label: '•',
          ),
          BottomNavigationBarItem(
            activeIcon: Icon(Icons.manage_accounts),
            icon: Icon(Icons.manage_accounts_outlined),
            label: '•',
          ),
        ],
      ),
    );
  }
}
