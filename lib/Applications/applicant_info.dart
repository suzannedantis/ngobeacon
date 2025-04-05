import 'package:flutter/material.dart';
import 'package:ngobeacon/components/bottom_nav_bar.dart';
import 'package:ngobeacon/components/top_nav_bar.dart';

//import 'package:ngobeacon/components/ngo_item.dart';
class ApplicantInfo extends StatelessWidget {
  const ApplicantInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFAFAF0),
      appBar: TopNavBar(),
      bottomNavigationBar: BottomNavBar(),
      body: SafeArea(child: Padding(padding: EdgeInsets.all(16.0))),
    );
  }
}
