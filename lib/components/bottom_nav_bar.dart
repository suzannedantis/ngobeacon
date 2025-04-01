import 'package:flutter/material.dart';
import 'package:ngobeacon/ngo_homescreen.dart';
import 'package:ngobeacon/ngo_applications_page.dart';
import 'package:ngobeacon/ngo_upload_page.dart';

class BottomNavBar extends StatelessWidget {
  final int? selectedIndex; // Allow null for no highlight
  const BottomNavBar({Key? key, this.selectedIndex}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: const Color(0xFFFAFAF0), // Background color update
      shape: const CircularNotchedRectangle(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(
            context,
            icon: Icons.home,
            label: 'Home',
            index: 0,
            targetScreen: HomePage(),
          ),
          _buildNavItem(
            context,
            icon: Icons.article,
            label: 'Applications',
            index: 1,
            targetScreen: ApplicationsPage(),
            resetOnTap: true, // Ensures reset if tapped again
          ),
          _buildNavItem(
            context,
            icon: Icons.upload_file_rounded,
            label: 'Upload',
            index: 2,
            targetScreen: UploadPage(),
            resetOnTap: true, // Ensures reset if tapped again
          ),
        ],
      ),
    );
  }

  // 🛠 Helper Function to Build Nav Items with Reset Logic
  Widget _buildNavItem(BuildContext context,
      {required IconData icon,
        required String label,
        required int index,
        required Widget targetScreen,
        bool resetOnTap = false}) {
    final isSelected = selectedIndex == index;
    final selectedColor = Color(0xFF163F77);
    final unselectedColor = Color(0xFF6A89BE); // Lighter version of Color(0xFF163F77)

    return FittedBox(
      child: Column(
        children: [
          IconButton(
            icon: Icon(
              icon,
              color: isSelected ? selectedColor : unselectedColor, // Highlight selected icon
              size: 35,
            ),
            onPressed: () {
              if (resetOnTap || !isSelected) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => targetScreen),
                );
              }
            },
          ),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? selectedColor : unselectedColor,
              fontSize: 17,
            ),
          ),
        ],
      ),
    );
  }
}
