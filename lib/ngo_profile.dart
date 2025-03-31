import 'package:flutter/material.dart';
import 'change_password.dart';// Import Change Password Page
import 'home_page.dart';
import 'applications_page.dart';

class NGOProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('NGO Profile'),
        backgroundColor: Colors.white,
        foregroundColor: Color(0xFF002B5B),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              CircleAvatar(
                radius: 40,
                backgroundColor: Colors.white,
                child: Icon(Icons.person, size: 40, color: Colors.blue),
              ),
              SizedBox(height: 20),
              buildTextField("NGO Name"),
              buildTextField("Registration Number"),
              buildTextField("Single Point of Contact (SPOC) Name"),
              buildTextField("Email"),
              buildTextField("Phone Number"),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Implement Save Changes Logic
                },
                child: Text("Save Changes"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Color(0xFF002B5B),
                  padding: EdgeInsets.symmetric(vertical: 14, horizontal: 24),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ChangePasswordPage()),
                  );
                },
                child: Text(
                  "Change Password",
                  style: TextStyle(color: Colors.white, fontSize: 16),
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

  Widget buildTextField(String label) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: TextField(
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
              },
            ),
          ],
        ),
      ),
    );
  }
}
