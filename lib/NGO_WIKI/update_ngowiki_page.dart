import 'package:flutter/material.dart';
import 'package:ngobeacon/NGO_WIKI/ngowiki_page.dart';
import '../components/bottom_nav_bar.dart';
import '../components/top_nav_bar.dart';

class UpdateNGOWikiPage extends StatelessWidget {
  const UpdateNGOWikiPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopNavBar(),
      bottomNavigationBar: BottomNavBar(selectedIndex: 2),
      backgroundColor: const Color(0xFF0D3C73),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '*Kindly fill out the fields in Paragraphs, and Upload Images wherever asked',
                style: TextStyle(color: Colors.white70, fontSize: 12),
              ),
              const SizedBox(height: 16),
              buildLabel('Established Date, Location, Registration Number. :'),
              buildField(),
              buildLabel('Vision:'),
              buildField(),
              buildLabel('Mission:'),
              buildField(),
              buildLabel('Areas of Focus:'),
              buildField(),
              buildLabel('NGO Members:'),
              buildField(),
              buildLabel('Images for Members (minimum 0, maximum 3):'),
              buildField(),
              buildLabel('Projects/Initiatives covered, with details:'),
              buildField(),
              buildLabel('Relevant Project Images (minimum 0, maximum 7):'),
              buildField(),
              buildLabel('Success Stories:'),
              buildField(),
              buildLabel(
                'Relevant Success Stories Images (minimum 0, maximum 7):',
              ),
              buildField(),
              buildLabel('Contact Information and Address:'),
              buildField(),
              const SizedBox(height: 24),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF0D3C73),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: () {
                    // Save logic here
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => NGOWikiPage()),
                    );
                  },
                  child: const Text(
                    'Save changes to NGOWiki Page',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 6),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white, fontSize: 14),
      ),
    );
  }

  Widget buildField() {
    return TextFormField(
      maxLines: null,
      style: const TextStyle(color: Colors.black),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey[200],
        contentPadding: const EdgeInsets.symmetric(
          vertical: 14,
          horizontal: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(08),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
