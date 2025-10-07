import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../services/firebase_auth.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String _errorMessage = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            TextFormField(
              decoration: InputDecoration(labelText: "Email"),
              controller: _emailController,
            ),
            TextFormField(
              decoration: InputDecoration(labelText: "Password"),
              controller: _passwordController,
            ),
            Text(_errorMessage, style: TextStyle(color: Colors.red)),
            ElevatedButton(
              onPressed: () {
                _signIn();
              },
              child: Text("Sign In"),
            ),
          ],
        ),
      ),
    );
  }

  void _popPage() {
    Navigator.pop(context);
  }

  void _signIn() async {
    try {
      await AuthService().signIn(
        email: _emailController.text,
        password: _passwordController.text,
      );
      _popPage();
    } on FirebaseAuthException catch (e) {
      setState(() {
        _errorMessage = e.message ?? "An unknown error occurred";
      });
    }
  }
}
