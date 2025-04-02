import 'package:flutter/material.dart';
import '../components/bottom_nav_bar.dart';
import '../components/top_nav_bar.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopNavBar(),
      bottomNavigationBar: BottomNavBar(),
      backgroundColor: Color(0xFF002B5B), // Dark blue background
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSettingsOption("Change Password", Icons.lock, context),
            _buildSettingsOption("Notifications", Icons.notifications, context),
            _buildSettingsOption("Privacy Policy", Icons.privacy_tip, context),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsOption(
    String title,
    IconData icon,
    BuildContext context,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        tileColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        leading: Icon(icon, color: Color(0xFF002B5B)),
        title: Text(
          title,
          style: TextStyle(fontSize: 16, color: Color(0xFF002B5B)),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          color: Color(0xFF002B5B),
          size: 18,
        ),
        onTap: () {
          // Implement Navigation to respective setting pages if needed
        },
      ),
    );
  }
}
