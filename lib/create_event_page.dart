import 'package:flutter/material.dart';
import 'package:ngobeacon/ngo_menu.dart';
import 'components/bottom_nav_bar.dart';
import 'components/top_nav_bar.dart';

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
      bottomNavigationBar: BottomNavBar(selectedIndex: 2),
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

  }

