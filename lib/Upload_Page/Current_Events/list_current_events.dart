import 'package:flutter/material.dart';
import 'package:ngobeacon/Upload_Page/Current_Events/edit_current_event.dart';
import 'package:ngobeacon/components/bottom_nav_bar.dart';
import 'package:ngobeacon/components/top_nav_bar.dart';
import 'package:ngobeacon/ngo_item.dart';

//add assets thing

class Current_event_list extends StatelessWidget {
  const Current_event_list({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopNavBar(),
      bottomNavigationBar: BottomNavBar(selectedIndex: 2),
      backgroundColor: Color(0xFF002B5B),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Current Events",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            NGOItem(
              name: "Name of the event",
              logo: "assets/Icons/sowing-seeds.png",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EditCurrentEvent()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
