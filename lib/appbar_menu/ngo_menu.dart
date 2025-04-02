import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ngobeacon/appbar_menu/about_us.dart';
import 'package:ngobeacon/login_page.dart';
import 'package:ngobeacon/appbar_menu/settings_page.dart';
import '../ngo_profile.dart';
import '../components/bottom_nav_bar.dart';
import '../components/top_nav_bar.dart';

class SideMenuPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavBar(),
      appBar: TopNavBar(),
      backgroundColor: Color(0xFFFAFAF0),
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
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => AboutUsPage(),
                ), // Navigate to upload Page
              );
            }),
            _buildMenuButton("Log Out", () {
              // Handle logout
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => LoginPage(),
                ), // Navigate to upload Page
              );
            }),
          ],
        ),
      ),
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
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF002B5B),
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: Text(
            text,
            style: GoogleFonts.lato(fontSize: 18, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
