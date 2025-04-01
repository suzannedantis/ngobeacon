import 'package:flutter/material.dart';
import 'package:ngobeacon/ngo_menu.dart';

class TopNavBar extends StatelessWidget implements PreferredSizeWidget {
  TopNavBar();

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Color(0xFFFAFAF0),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'NGOBeacon',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF163F77),
            ),
          ),
        ],
      ),
      centerTitle: true,
      leading: Padding(
        padding: const EdgeInsets.only(left: 12.0),
        child: Image.asset('assets/Images/lighthouse_logo.png', height: 40),
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.menu, color: Color(0xFF163F77)), // Updated color
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SideMenuPage()),
            );
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
