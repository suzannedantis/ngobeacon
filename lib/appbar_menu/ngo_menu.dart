import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ngobeacon/appbar_menu/about_us.dart';
import 'package:ngobeacon/appbar_menu/change_password.dart';
import 'package:ngobeacon/login_page.dart';
import 'ngo_profile.dart';
import '../components/bottom_nav_bar.dart';
import '../components/top_nav_bar.dart';
import '/Auth/auth_service.dart';

final AuthService _authService = AuthService();

class SideMenuPage extends StatelessWidget {
  const SideMenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavBar(),
      appBar: TopNavBar(),
      backgroundColor: Color(0xFFFAFAF0),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildMenuButton("NGO Profile", () {
              // Navigate to NGO Profile Page
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NGOProfilePage()),
              );
            }),
            _buildMenuButton("Change Password", () {
              // Navigate to Settings Page
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ChangePasswordPage()),
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
            _buildMenuButton("Log Out", () async {
              try {
                await _authService.signOut();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                  (Route<dynamic> route) => false,
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error during logout: $e')),
                );
              }
            }),
            _buildMenuButton("Notifications", () {
              // Navigate to About Us Page
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => AboutUsPage(),
                ), // Navigate to upload Page
              );
            }),
            TextButton(
              onPressed: () {},
              child: Text(
                "Privacy Policy",
                style: TextStyle(color: Color(0xFF002B5B), fontSize: 12),
              ),
            ),
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
