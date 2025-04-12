import 'package:flutter/material.dart';
import '../components/bottom_nav_bar.dart';
import '../components/top_nav_bar.dart';

class ApplicationsPage extends StatefulWidget {
  @override
  _ApplicationsPageState createState() => _ApplicationsPageState();
}

class _ApplicationsPageState extends State<ApplicationsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF002B5B), // Light background for modern feel
      appBar: TopNavBar(),
      bottomNavigationBar: BottomNavBar(selectedIndex: 1),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                "Applications",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 20),
            _buildApplicationItem(
              "Tree Plantation Drive",
              "18 applicants",
              "assets/Icons/sowing-seeds.png",
              "In Progress",
              Colors.blueAccent,
            ),
            _buildApplicationItem(
              "Blood Donation Camp",
              "27 applicants",
              "assets/Icons/donor.png",
              "Approved",
              Colors.green,
            ),
            _buildApplicationItem(
              "Winter Clothes Drive",
              "10 applicants",
              "assets/Icons/clothing.png",
              "Pending",
              Colors.orangeAccent,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildApplicationItem(
      String title,
      String applicants,
      String imagePath,
      String status,
      Color statusColor,
      ) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: Colors.grey[100],
            backgroundImage: AssetImage(imagePath),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  applicants,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              status,
              style: TextStyle(
                color: statusColor,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
