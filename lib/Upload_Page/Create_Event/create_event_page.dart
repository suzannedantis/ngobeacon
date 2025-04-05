import 'package:flutter/material.dart';
import 'package:ngobeacon/components/bottom_nav_bar.dart';
import 'package:ngobeacon/components/top_nav_bar.dart';
import 'package:ngobeacon/Upload_Page/Create_Event/create_newevent_form.dart';
import 'package:ngobeacon/Upload_Page/Create_Event/create_assist_intern_form.dart';

class CreateEventPage extends StatelessWidget {
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
            SizedBox(height: 20),
            _buildButton(context, "Create New Event", () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CreateEventScreen()),
              );
            }),
            _buildButton(
              context,
              "Create New Assistance/Internship Requirement",
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CreateAssistInterForm(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(selectedIndex: 2),
    );
  }

  Widget _buildButton(
    BuildContext context,
    String title,
    VoidCallback onPressed,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: onPressed,
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
