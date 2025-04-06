import 'package:flutter/material.dart';
import 'package:ngobeacon/Upload_Page/Create_Event/create_internship_form.dart';
import 'package:ngobeacon/Upload_Page/Current_Events/list_current_events.dart';
import 'package:ngobeacon/Upload_Page/donation_needs_page.dart';
import 'package:ngobeacon/Upload_Page/Create_Event/create_newevent_form.dart';
import 'package:ngobeacon/NGO_WIKI/what_ngowiki_page.dart';
import 'package:ngobeacon/Upload_Page/Create_Event/create_assistance_form.dart';
import '../components/bottom_nav_bar.dart';
import '../components/top_nav_bar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UploadPage extends StatelessWidget {
  const UploadPage({super.key});

  Future<String?> _getNgoId() async {
    try {
      final supabase = Supabase.instance.client;
      final userId = supabase.auth.currentUser?.id;

      if (userId == null) return null;

      final ngoProfile = await supabase
          .from('ngo_profile')
          .select('ngo_id')
          .eq('authid', userId)
          .maybeSingle();

      return ngoProfile?['ngo_id'] as String?;
    } catch (e) {
      debugPrint('Error getting NGO ID: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF002B5B),
      appBar: TopNavBar(),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Text(
              "Upload Data",
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            FutureBuilder<String?>(
              future: _getNgoId(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }
                return _uploadButton(
                  context,
                  "Create New Event",
                  snapshot.hasData
                      ? CreateEventScreen(ngoId: snapshot.data!)
                      : null,
                );
              },
            ),
            _uploadButton(context, "Current Events", const Current_event_list()),
            _uploadButton(context, "NGOWiki Page", const NGOWikiPage()),
            _uploadButton(
              context,
              "Update Donation Needs",
              const DonationNeedsPage(),
            ),
            _uploadButton(
              context,
              "Add Internship Requirement",
              CreateInternshipForm(),
            ),
            _uploadButton(
              context,
              "Add Assistance Requirement",
              const CreateAssistanceForm(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavBar(selectedIndex: 2),
    );
  }

  Widget _uploadButton(BuildContext context, String title, Widget? page) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: page != null
            ? () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => page),
        )
            : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: const Color(0xFF002B5B),
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}