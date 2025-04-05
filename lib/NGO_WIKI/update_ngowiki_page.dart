import 'package:flutter/material.dart';
import 'package:ngobeacon/NGO_WIKI/ngowiki_page.dart';
import '../components/bottom_nav_bar.dart';
import '../components/top_nav_bar.dart';

class UpdateNGOWikiPage extends StatefulWidget {
  UpdateNGOWikiPage();

  @override
  State<UpdateNGOWikiPage> createState() => _UpdateNGOWikiPageState();
}

class _UpdateNGOWikiPageState extends State<UpdateNGOWikiPage> {
  List<TextEditingController> controllers = [TextEditingController()];

  void addField() {
    setState(() {
      controllers.add(TextEditingController());
    });
  }

  void removeField(int index) {
    setState(() {
      if (controllers.length > 1) {
        controllers.removeAt(index);
      }
    });
  }

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
              buildLabel('Established Date'),
              buildField(),
              buildLabel('Registration number'),
              buildField(),
              buildLabel('Vision:'),
              buildField(),
              buildLabel('Mission:'),
              buildField(),
              buildLabel('Areas of Focus:'),
              buildField(),
              buildLabel('NGO Members:'),
              ...List.generate(controllers.length, (index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: controllers[index],
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            labelText: 'Member ${index + 1}',
                            labelStyle: const TextStyle(color: Colors.white70),
                            enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white,
                                width: 2,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.white),
                        onPressed: () => removeField(index),
                      ),
                    ],
                  ),
                );
              }),
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton.icon(
                  onPressed: addField,
                  icon: const Icon(Icons.add, color: Colors.white),
                  label: const Text(
                    "Add Member",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),

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
                    // Save logic
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => NGOWikiPage()),
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
    maxLines: null, // Unlimited lines
    minLines: 1, // Start with 1 line
    keyboardType: TextInputType.multiline,
    style: const TextStyle(color: Colors.black),
    decoration: InputDecoration(
      filled: true,
      fillColor: Colors.grey[200],
      contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(08),
        borderSide: BorderSide.none,
      ),
    ),
  );
}
