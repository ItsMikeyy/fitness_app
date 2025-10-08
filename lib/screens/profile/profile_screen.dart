import 'package:flutter/material.dart';
import 'package:nutrition/services/firebase_auth.dart';
import 'package:nutrition/providers/user_provider.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.person, size: 64, color: Colors.green),
          SizedBox(height: 16),
          Text(
            "Profile Page",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          // Display user information using Provider
          Consumer<UserProvider>(
            builder: (context, userProvider, child) {
              final user = userProvider.currentUser;
              final firebaseUser = AuthService().currentUser;

              if (user != null && firebaseUser != null) {
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 32),
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "User Information",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 12),
                        _buildUserInfoRow("Name", user.name),
                        _buildUserInfoRow("Email", user.email),
                        _buildUserInfoRow("Gender", user.gender ?? ""),
                        _buildUserInfoRow("Age", user.age ?? ""),
                        _buildUserInfoRow("Height", "${user.height} cm"),
                        _buildUserInfoRow("Weight", "${user.weight} kg"),
                        SizedBox(height: 12),
                      ],
                    ),
                  ),
                );
              } else {
                return Text(
                  "No user data available",
                  style: TextStyle(fontSize: 16, color: Colors.red),
                );
              }
            },
          ),
          SizedBox(height: 16),
          ElevatedButton(onPressed: _onLogOut, child: Text("Logout")),
        ],
      ),
    );
  }

  Widget _buildUserInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              "$label:",
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: Text(value, style: TextStyle(color: Colors.grey[700])),
          ),
        ],
      ),
    );
  }

  void _onLogOut() async {
    await AuthService().signOut();
  }
}
