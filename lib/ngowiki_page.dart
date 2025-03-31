import 'package:flutter/material.dart';
import 'package:ngobeacon/side_menu.dart';
import 'package:ngobeacon/update_ngowiki_page.dart';
import 'home_page.dart';
import 'applications_page.dart';
import 'upload_page.dart';

class NGOWikiPage extends StatelessWidget {
  const NGOWikiPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF002B5B),
      appBar: AppBar(
        title: const Text(
          "NGOBeacon",
          style:
          TextStyle(color: Color(0xFF002B5B), fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child:
          Image.asset('assets/Images/logo.png'), // replace with your logo
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu, color: Color(0xFF002B5B)),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context)=> SideMenuPage())
              );// Add Drawer if needed
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            const Text(
              "What is the NGOWiki Page?",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              "The NGOWiki page is a dedicated hub where NGOs can comprehensively showcase their journey—from their inception, vision, and mission to the projects they drive and the team behind them.\n\n"
                  "We encourage each NGO to fill out this page, as it highlights their impact, amplifies their story, and fosters stronger connections with supporters and the broader community.\n\n"
                  "For guidance, we are providing a sample NGOWiki page of an NGO to help you get started.",
              style: TextStyle(color: Colors.white, fontSize: 14, height: 1.6),
            ),
            const SizedBox(height: 12),
            _buildButton("Update NGOWiki Page", context, onTap: () {
              // Navigate to Update/Edit Page
              Navigator.push(
                context,
                  MaterialPageRoute(builder: (context)=> UpdateNGOWikiPage())
              );
            }),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: () {
          // Navigate to chat or support
        },
        child: const Icon(Icons.chat_bubble_outline, color: Color(0xFF002B5B)),
      ),
      bottomNavigationBar: _buildBottomNavBar(context),
    );
  }

  Widget _buildButton(String text, BuildContext context,
      {required VoidCallback onTap}) {
    return SizedBox(
      width: double.infinity,
      height: 45,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Color(0xFF002B5B),
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: Text(
          text,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildBottomNavBar(BuildContext context) {
    return BottomAppBar(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: const Icon(Icons.home, size: 30, color: Color(0xFF002B5B)),
              onPressed: () {
                // Navigate to Home Page
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()), // Navigate to HomePage
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.article, size: 30, color: Color(0xFF002B5B)),
              onPressed: () {
                // Navigate to Reports Page
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => ApplicationsPage()), // Navigate to Applications Page
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.share, size: 30, color: Color(0xFF002B5B)),
              onPressed: () {
                // Share NGO info
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => UploadPage()), // Navigate to upload Page
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
