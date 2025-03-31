import 'package:flutter/material.dart';
import 'package:ngobeacon/side_menu.dart';
import 'applications_page.dart';
import 'upload_page.dart';
import 'home_page.dart';

class CreateEventPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF002B5B), // Dark blue background
      appBar: AppBar(
        title: Text(
          "NGOBeacon",
          style: TextStyle(color: Color(0xFF002B5B), fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Padding(
          padding: EdgeInsets.all(10),
          child: Image.asset('assets/Images/logo.png'), // NGO Logo
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.menu, color: Color(0xFF002B5B)),
            onPressed: () {
              // Implement Side Menu Navigation
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => SideMenuPage()), // Navigate to upload Page
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            _buildButton(context, "Create New Event"),
            _buildButton(context, "Create New Assistance Requirement"),
            _buildButton(context, "Create New Internship Requirement"),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Chat icon action
        },
        backgroundColor: Colors.white,
        child: Icon(Icons.chat, color: Color(0xFF002B5B)),
      ),
      bottomNavigationBar: _buildBottomNavBar(context),
    );
  }

  Widget _buildButton(BuildContext context, String title) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {
            // Implement navigation to respective forms
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
