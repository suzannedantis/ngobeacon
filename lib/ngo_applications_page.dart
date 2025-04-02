import 'package:flutter/material.dart';
import 'ngo_homescreen.dart';
import 'ngo_upload_page.dart';
import 'components/bottom_nav_bar.dart';
import 'components/top_nav_bar.dart';

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
      appBar: TopNavBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  "Applications",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
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
      bottomNavigationBar: BottomNavBar(selectedIndex: 1),
    );
  }

  Widget _buildApplicationItem(
    String title,
    String applicants,
    String imagePath,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Image.asset(
            imagePath,
            height: 50,
            width: 50,
          ), // Replace with actual image assets
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  applicants,
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
