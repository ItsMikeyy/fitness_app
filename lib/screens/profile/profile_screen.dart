import 'package:flutter/material.dart';
import 'package:nutrition/services/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();
    final user = authService.currentUser;

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
          // Display user information
          if (user != null) ...[
            Card(
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
                    _buildUserInfoRow("Email", user.email ?? "No email"),
                    _buildUserInfoRow("UID", user.uid),
                    _buildUserInfoRow(
                      "Email Verified",
                      user.emailVerified ? "Yes" : "No",
                    ),
                    _buildUserInfoRow(
                      "Created",
                      _formatDate(user.metadata.creationTime),
                    ),
                    _buildUserInfoRow(
                      "Last Sign In",
                      _formatDate(user.metadata.lastSignInTime),
                    ),
                  ],
                ),
              ),
            ),
          ] else ...[
            Text(
              "No user signed in",
              style: TextStyle(fontSize: 16, color: Colors.red),
            ),
          ],
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

  String _formatDate(DateTime? date) {
    if (date == null) return "Unknown";
    return "${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}";
  }

  void _onLogOut() async {
    await AuthService().signOut();
  }
}
