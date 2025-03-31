import 'package:flutter/material.dart';
import 'upload_page.dart';
import 'home_page.dart';
import 'applications_page.dart';

class ChangePasswordPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Change Password"),
        backgroundColor: Colors.white,
        foregroundColor: Color(0xFF002B5B),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              buildTextField("Enter Current Password", obscureText: true),
              buildTextField("Enter New Password", obscureText: true),
              buildTextField("Confirm New Password", obscureText: true),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Implement password change logic
                },
                child: Text("Confirm"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Color(0xFF002B5B),
                  padding: EdgeInsets.symmetric(vertical: 14, horizontal: 24),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Color(0xFF002B5B),
      bottomNavigationBar: _buildBottomNavBar(context),
    );
  }

  Widget buildTextField(String label, {bool obscureText = false}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: TextField(
        obscureText: obscureText,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.white70),
          filled: true,
          fillColor: Colors.white24,
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white54),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
  // Bottom Navigation Bar
  Widget _buildBottomNavBar(BuildContext context) {
    return BottomAppBar(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: const Icon(Icons.home, size: 30, color: Color(0xFF002B5B)),
              onPressed: () {
                // Navigate to Home Page
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()), // Navigate to HomePage
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.article, size: 30, color: Color(0xFF002B5B)),
              onPressed: () {
                // Navigate to Reports Page
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => ApplicationsPage()), // Navigate to Applications Page
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.share, size: 30, color: Color(0xFF002B5B)),
              onPressed: () {
                // Share NGO info
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => UploadPage()), // Navigate to upload Page
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
