import 'package:flutter/material.dart';
import 'ngo_upload_page.dart';
import '../components/bottom_nav_bar.dart';
import '../components/top_nav_bar.dart';

class DonationNeedsPage extends StatefulWidget {
  const DonationNeedsPage({Key? key}) : super(key: key);

  @override
  State<DonationNeedsPage> createState() => _DonationNeedsPageState();
}

class _DonationNeedsPageState extends State<DonationNeedsPage> {
  Map<String, bool> donationNeeds = {
    'Money': false,
    'Clothes': true,
    'Articles': false,
    'Food': true,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D3C73),
      appBar: TopNavBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            const Text(
              'Donation Needs',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Select the particular item(s) needed by your NGO',
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
            const SizedBox(height: 24),

            // Scrollable List
            Expanded(
              child: ListView(
                children:
                    donationNeeds.entries.map((entry) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: ListTile(
                          leading: Checkbox(
                            value: entry.value,
                            onChanged: (val) {
                              setState(() {
                                donationNeeds[entry.key] = val!;
                              });
                            },
                            side: const BorderSide(
                              color: Colors.white,
                              width: 2,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                            activeColor: Colors.white,
                            checkColor: const Color(0xFF0D3C73),
                          ),
                          title: Container(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF5F6F8),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              entry.key,
                              style: const TextStyle(
                                color: Color(0xFF0D3C73),
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
              ),
            ),

            // Save Button
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Handle Save Logic Here
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => UploadPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFF0D3C73),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Save Selection",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(selectedIndex: 2),
    );
  }
}
