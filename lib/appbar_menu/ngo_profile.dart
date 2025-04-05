import 'package:flutter/material.dart';
import 'change_password.dart';
import '../components/bottom_nav_bar.dart';
import '../components/top_nav_bar.dart';

class NGOProfilePage extends StatelessWidget {
  const NGOProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopNavBar(),
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
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Color(0xFF002B5B),
                  padding: EdgeInsets.symmetric(vertical: 14, horizontal: 24),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text("Save Changes"),
              ),
              SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChangePasswordPage(),
                    ),
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
      bottomNavigationBar: BottomNavBar(),
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
}
