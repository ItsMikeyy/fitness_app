import 'package:flutter/material.dart';
import 'package:nutrition/screens/auth/auth_screen.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Nutrition")),
      body: Column(
        children: [
          Text(
            "Welcome to Nutrition!",
            style: TextStyle(color: Colors.black, fontSize: 24),
          ),
          ElevatedButton(
            onPressed: () {
              _navigateToAuthScreen(context);
            },
            child: Text(" Get Started"),
          ),
        ],
      ),
    );
  }
}

void _navigateToAuthScreen(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => AuthScreen()),
  );
}
