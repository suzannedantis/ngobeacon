import 'package:flutter/material.dart';
import 'package:ngobeacon/components/top_nav_bar.dart';
import 'package:ngobeacon/components/bottom_nav_bar.dart';
class AboutUsPage extends StatelessWidget {
  const AboutUsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D3C73),
      appBar: TopNavBar(),
      bottomNavigationBar: BottomNavBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Project Vision & Mission
            const Text(
              'About NGOBeacon',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'NGOBeacon is a platform designed to streamline NGO management, '
                  'facilitate volunteer collaboration, and promote impactful projects. '
                  'Our mission is to empower organizations to make a difference '
                  'through technology.',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 30),

            // Team Section
            const Text(
              'Meet the Creators',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),

            // Sample Team Member Cards
            teamMemberCard('assets/team1.png', 'John Doe', 'Lead Developer'),
            const SizedBox(height: 15),
            teamMemberCard('assets/team2.png', 'Jane Smith', 'UI/UX Designer'),
            const SizedBox(height: 15),
            teamMemberCard('assets/team3.png', 'Mike Johnson', 'Backend Engineer'),
            const SizedBox(height: 15),

            // Social Media & Contact Section
            const SizedBox(height: 30),
            const Text(
              'Connect with Us',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                socialButton(Icons.web, 'Website'),
                socialButton(Icons.email, 'Email'),
                socialButton(Icons.link, 'LinkedIn'),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // Widget for team member cards
  Widget teamMemberCard(String imagePath, String name, String role) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundImage: AssetImage(imagePath), // Replace with actual image assets
          ),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0D3C73),
                ),
              ),
              Text(
                role,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  // Widget for social media/contact buttons
  Widget socialButton(IconData icon, String label) {
    return ElevatedButton.icon(
      onPressed: () {
        // Implement navigation to social media/contact links
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF0D3C73),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      icon: Icon(icon),
      label: Text(label),
    );
  }
}
