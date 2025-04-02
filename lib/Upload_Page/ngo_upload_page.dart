import 'package:flutter/material.dart';
import 'package:ngobeacon/Upload_Page/donation_needs_page.dart';
import 'package:ngobeacon/NGO_WIKI/ngowiki_page.dart';
import '../create_event_page.dart';
import '../components/bottom_nav_bar.dart';
import '../components/top_nav_bar.dart';

class UploadPage extends StatelessWidget {
  const UploadPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF002B5B),
      appBar: TopNavBar(),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              "Upload Data",
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            _uploadButton(
              context,
              "Create New Event & Assistance/Internship Requirements",
              CreateEventPage(),
            ),
            _uploadButton(context, "Current Events", null),
            _uploadButton(context, "NGOWiki Page", NGOWikiPage()),
            _uploadButton(
              context,
              "Update Donation Needs",
              DonationNeedsPage(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(selectedIndex: 2),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.white,
        child: Icon(Icons.chat, color: Color(0xFF002B5B)),
      ),
    );
  }

  Widget _uploadButton(BuildContext context, String title, Widget? page) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed:
            page != null
                ? () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => page),
                )
                : null,
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
    );
  }
}
