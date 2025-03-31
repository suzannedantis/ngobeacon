import 'package:flutter/material.dart';
import 'side_menu.dart';
import 'home_page.dart';
import 'applications_page.dart';
import 'create_event_page.dart'; // Import the page for creating a new event

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
      appBar: AppBar(
        title: Text(
          'NGOBeacon',
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
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SideMenuPage()),
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
            _buildUploadButton(context, "Create New Event & Assistance/Internship Requirements", CreateEventPage()),
            _buildUploadButton(context, "Current Events", null), // Add respective pages later
            _buildUploadButton(context, "NGOWiki Page", null),
            _buildUploadButton(context, "Update Donation Needs", null),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(),
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

  Widget _buildBottomNavBar() {
    return BottomAppBar(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: Icon(
                Icons.home,
                size: 30,
                color: _selectedIndex == 0 ? Colors.blue : Color(0xFF002B5B),
              ),
              onPressed: () => _onItemTapped(0),
            ),
            IconButton(
              icon: Icon(
                Icons.article,
                size: 30,
                color: _selectedIndex == 1 ? Colors.blue : Color(0xFF002B5B),
              ),
              onPressed: () => _onItemTapped(1),
            ),
            IconButton(
              icon: Icon(
                Icons.upload_file,
                size: 30,
                color: _selectedIndex == 2 ? Colors.blue : Color(0xFF002B5B),
              ),
              onPressed: () {}, // Already on UploadPage
            ),
          ],
        ),
      ),
    );
  }
}