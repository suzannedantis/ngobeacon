import 'package:flutter/material.dart';
import 'package:ngobeacon/applications_page.dart';
import 'package:ngobeacon/change_password.dart';
import 'package:ngobeacon/ngo_profile.dart';
import 'package:ngobeacon/create_event_page.dart';
import 'login_page.dart';
import 'create_event_page.dart';
import 'upload_page.dart';

void main() {
  runApp(NGOBeaconApp());
}

class NGOBeaconApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: UploadPage(),
    );
  }
}
