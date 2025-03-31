import 'package:flutter/material.dart';
import 'home_page.dart';
import 'upload_page.dart';
import 'side_menu.dart';

class ApplicationsPage extends StatefulWidget {
  @override
  _ApplicationsPageState createState() => _ApplicationsPageState();
}

class _ApplicationsPageState extends State<ApplicationsPage> {
  int _selectedIndex = 1; // Index for Applications Page

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
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => UploadPage()),
        );
        break; // Already on UploadPage
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('NGOBeacon'),
        backgroundColor: Colors.white,
        foregroundColor: Color(0xFF002B5B),
        centerTitle: true,
        elevation: 0,
        leading: Padding(
        padding: EdgeInsets.all(10),
        child: Image.asset('assets/Images/logo.png'),
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
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  "Applications",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
              SizedBox(height: 10),
              _buildApplicationItem(
                "Tree Plantation Drive",
                "4 applicants",
                "assets/Icons/sowing-seeds.png",
              ),
              _buildApplicationItem(
                "Blood Donation Drive",
                "6 applicants",
                "assets/Icons/donor.png",
              ),
              _buildApplicationItem(
                "Data Entry Internship",
                "4 applicants",
                "assets/Icons/internship.png",
              ),
              _buildApplicationItem(
                "Animal Care Internship",
                "3 applicants",
                "assets/Icons/animal.png",
              ),
              _buildApplicationItem(
                "Clothes Donation Drive",
                "8 applicants",
                "assets/Icons/clothing.png",
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Color(0xFF002B5B),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildApplicationItem(String title, String applicants, String imagePath) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Image.asset(imagePath, height: 50, width: 50), // Replace with actual image assets
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                Text(applicants, style: TextStyle(color: Colors.white70, fontSize: 14)),
              ],
            ),
          ),
        ],
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
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(
                Icons.upload_file,
                size: 30,
                color: _selectedIndex == 2 ? Colors.blue : Color(0xFF002B5B),
              ),
              onPressed: () => _onItemTapped(2),
            ),
          ],
        ),
      ),
    );
  }
}
