import 'package:flutter/material.dart';
import 'package:nutrition/screens/dashboard/dashboard_screen.dart';
import 'package:nutrition/screens/loading/loading_screen.dart';
import 'package:nutrition/screens/start_screen.dart';
import 'package:nutrition/screens/onboard/onboard_screen.dart';
import 'package:nutrition/services/firebase_auth.dart';
import 'package:nutrition/providers/user_provider.dart';
import 'package:provider/provider.dart';

class AuthLayout extends StatefulWidget {
  const AuthLayout({super.key, this.pageIfNotLoggedIn});
  final Widget? pageIfNotLoggedIn;

  @override
  State<AuthLayout> createState() => _AuthLayoutState();
}

class _AuthLayoutState extends State<AuthLayout> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: authService,
      builder: (context, authService, child) {
        return StreamBuilder(
          stream: authService.authStateChanges,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const LoadingScreen();
            } else if (snapshot.hasData) {
              // Load user data when Firebase user exists
              WidgetsBinding.instance.addPostFrameCallback((_) {
                context.read<UserProvider>().loadUserData();
              });

              return Consumer<UserProvider>(
                builder: (context, userProvider, child) {
                  if (userProvider.isLoading) {
                    return const LoadingScreen();
                  } else if (userProvider.isUserLoggedIn) {
                    return const DashboardScreen();
                  } else {
                    // User exists in Firebase but not in local database (new user)
                    return OnboardScreen(onComplete: userProvider.setUser);
                  }
                },
              );
            } else {
              // Clear user data when Firebase user is null
              WidgetsBinding.instance.addPostFrameCallback((_) {
                context.read<UserProvider>().clearUser();
              });
              return widget.pageIfNotLoggedIn ?? const StartScreen();
            }
          },
        );
      },
    );
  }
}
