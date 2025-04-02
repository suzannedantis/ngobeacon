import 'package:flutter/material.dart';
import 'package:ngobeacon/donation_needs_page.dart';
import 'package:ngobeacon/NGO_WIKI/ngowiki_page.dart';
import 'appbar_menu/ngo_menu.dart';
import 'ngo_homescreen.dart';
import 'ngo_applications_page.dart';
import 'create_event_page.dart'; // Import the page for creating a new event
import 'components/bottom_nav_bar.dart';
import 'components/top_nav_bar.dart';

class UploadPage extends StatefulWidget {
  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  int _selectedIndex = 2; // Index for Upload Page

  void _onItemTapped(int index) {
    if (index == _selectedIndex) return; // Prevent reloading the same page

    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ApplicationsPage()),
        );
        break;
      case 2:
        break; // Already on UploadPage
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF002B5B), // Dark blue background
      appBar: TopNavBar(),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                "Upload Data",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 20),
            _buildUploadButton(
              context,
              "Create New Event & Assistance/Internship Requirements",
              CreateEventPage(),
            ),
            _buildUploadButton(
              context,
              "Current Events",
              null,
            ), // Add respective pages later
            _buildUploadButton(context, "NGOWiki Page", NGOWikiPage()),
            _buildUploadButton(
              context,
              "Update Donation Needs",
              DonationNeedsPage(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(selectedIndex: 2),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Chat icon action
        },
        backgroundColor: Colors.white,
        child: Icon(Icons.chat, color: Color(0xFF002B5B)),
      ),
    );
  }

  Widget _buildUploadButton(BuildContext context, String title, Widget? page) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {
            if (page != null) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => page),
              );
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Color(0xFF002B5B),
            padding: EdgeInsets.symmetric(vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }
}
