import 'package:flutter/material.dart';
import '../pages/navigation_bar.dart';
import '../pages/login_page.dart';
import '../backend/auth.dart';

class WidgetTree extends StatefulWidget {
  const WidgetTree({Key? key}) : super(key: key);

  @override
  State<WidgetTree> createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuthService().authStateChanges,
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