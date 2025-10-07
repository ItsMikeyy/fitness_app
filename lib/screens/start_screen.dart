import 'package:flutter/material.dart';
import 'package:nutrition/screens/auth/create_account_screen.dart';
import 'package:nutrition/screens/auth/signin_screen.dart';

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
              _navigateToCreateAccountScreen(context);
            },
            child: Text(" Get Started"),
          ),
          ElevatedButton(
            onPressed: () {
              _navigateToSignInScreen(context);
            },
            child: Text(" Sign In"),
          ),
        ],
      ),
    );
  }
}

void _navigateToCreateAccountScreen(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => CreateAccountScreen()),
  );
}

void _navigateToSignInScreen(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => SignInScreen()),
  );
}
