import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ngobeacon/login_page.dart';
import 'package:ngobeacon/settings_page.dart';
import 'ngo_profile.dart';
import 'applications_page.dart';
import 'home_page.dart';
import 'upload_page.dart';
import 'create_event_page.dart';

class SideMenuPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF002B5B),
        title: Text(
          "NGOBeacon",
          style: GoogleFonts.lato(color: Colors.white, fontSize: 20),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildMenuButton("NGO Profile", () {
              // Navigate to NGO Profile Page
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NGOProfilePage()),
              );
            }),
            _buildMenuButton("Settings", () {
              // Navigate to Settings Page
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsPage()),
              );
            }),
            _buildMenuButton("About Us", () {
              // Navigate to About Us Page
            }),
            _buildMenuButton("Log Out", () {
              // Handle logout
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()), // Navigate to upload Page
              );
            }),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(context),
    );
  }

  // Method to create a menu button
  Widget _buildMenuButton(String text, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: onPressed,
          child: Text(
            text,
            style: GoogleFonts.lato(fontSize: 18, color: Colors.white),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF002B5B),
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ),
    );
  }

  // Bottom Navigation Bar
  Widget _buildBottomNavBar(BuildContext context) {
    return BottomAppBar(
      color: Color(0xFF002B5B),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: const Icon(Icons.home, size: 30, color: Colors.white),
              onPressed: () {
                // Navigate to Home Page
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()), // Navigate to HomePage
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.article, size: 30, color: Colors.white),
              onPressed: () {
                // Navigate to Reports Page
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => ApplicationsPage()), // Navigate to Applications Page
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.share, size: 30, color: Colors.white),
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
