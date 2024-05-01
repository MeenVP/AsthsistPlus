import 'package:flutter/material.dart';
import '../pages/navigation_bar.dart';
import '../pages/login_page.dart';
import '../backend/firebase.dart';

class WidgetTree extends StatefulWidget {
  const WidgetTree({super.key});

  @override
  State<WidgetTree> createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseService().authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return const NavigationBarApp();
        } else {
          return const LoginPage();
        }
      },
    );
  }
}
