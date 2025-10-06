import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../services/firebase_auth.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
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
                _createAccount();
              },
              child: Text("Create Account"),
            ),
          ],
        ),
      ),
    );
  }

  void _createAccount() async {
    try {
      await AuthService().createAccount(
        email: _emailController.text,
        password: _passwordController.text,
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        _errorMessage = e.message ?? "An unknown error occurred";
      });
    }
  }
}
