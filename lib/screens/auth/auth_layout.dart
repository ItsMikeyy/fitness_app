import 'package:flutter/material.dart';
import 'package:nutrition/screens/dashboard.dart/dashboard_screen.dart';
import 'package:nutrition/screens/loading/loading_screen.dart';
import 'package:nutrition/screens/start_screen.dart';
import 'package:nutrition/services/firebase_auth.dart';

class AuthLayout extends StatelessWidget {
  const AuthLayout({super.key, this.pageIfNotLoggedIn});

  final Widget? pageIfNotLoggedIn;
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: authService,
      builder: (context, authService, child) {
        return StreamBuilder(
          stream: authService.authStateChanges,
          builder: (context, snapshot) {
            Widget widget;
            if (snapshot.connectionState == ConnectionState.waiting) {
              widget = LoadingScreen();
            } else if (snapshot.hasData) {
              widget = const DashboardScreen();
            } else {
              widget = pageIfNotLoggedIn ?? const StartScreen();
            }
            return widget;
          },
        );
      },
    );
  }
}
