import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'login_page.dart'; // Import the login page

class SignupPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF002B5B),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/Images/lighthouse.jpeg',
                width: 80,
                height: 80,
              ),
              SizedBox(height: 10),
              Text(
                "Welcome to",
                style: GoogleFonts.lato(color: Colors.white, fontSize: 18),
              ),
              Text(
                "NGOBeacon!",
                style: GoogleFonts.lato(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),

              _buildTextField("NGO Name"),
              SizedBox(height: 10),
              _buildTextField("Registration Number"),
              SizedBox(height: 10),
              _buildTextField("Single Point of Contact (SPOC) Name"),
              SizedBox(height: 10),
              _buildTextField("Email or Phone Number"),
              SizedBox(height: 10),
              _buildTextField("Password", obscureText: true),
              SizedBox(height: 10),
              _buildTextField("Re-type Password", obscureText: true),
              SizedBox(height: 10),
              _buildTextField("Certification"),
              SizedBox(height: 20),

              ElevatedButton(
                onPressed: () {
                  // Navigate back to login page
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
                child: Text("Sign up", style: TextStyle(fontSize: 16)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Color(0xFF002B5B),
                  padding: EdgeInsets.symmetric(vertical: 14),
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  "Already have an account? Sign in here.",
                  style: GoogleFonts.lato(color: Colors.white, fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, {bool obscureText = false}) {
    return TextField(
      obscureText: obscureText,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.white70),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white54),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
          borderRadius: BorderRadius.circular(10),
        ),
        filled: true,
        fillColor: Colors.white24,
      ),
    );
  }
}
