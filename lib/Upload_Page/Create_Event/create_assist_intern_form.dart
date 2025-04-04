import 'package:flutter/material.dart';
import 'package:ngobeacon/components/top_nav_bar.dart';
import 'package:ngobeacon/components/bottom_nav_bar.dart';

class CreateAssistInterForm extends StatelessWidget {
  CreateAssistInterForm();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[900],
      appBar: TopNavBar(),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Text(
              "Create Assistance/Internship Requirement",
              style: TextStyle(
                color: Color(0xFFFAFAF0),
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            buildTextField("Venue"),
            buildTextField("Starting Date"),
            buildTextField("Duration"),
            buildTextField("Eligibility"),
            buildTextField("Timings"),
            buildTextField("Person-In-Charge Name"),
            buildTextField("Person-In-Charge Contact Number"),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.blue[900],
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  "Upload Requirement",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(),
    );
  }

  Widget buildTextField(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: 16, color: Colors.white)),
          SizedBox(height: 5),
          TextField(
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey[200],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
