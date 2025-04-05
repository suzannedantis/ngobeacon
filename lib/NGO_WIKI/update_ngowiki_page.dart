import 'package:flutter/material.dart';
import 'package:ngobeacon/NGO_WIKI/ngowiki_page.dart';
import '../components/bottom_nav_bar.dart';
import '../components/top_nav_bar.dart';

class UpdateNGOWikiPage extends StatefulWidget {
  const UpdateNGOWikiPage({super.key});

  @override
  State<UpdateNGOWikiPage> createState() => _UpdateNGOWikiPageState();
}

class _UpdateNGOWikiPageState extends State<UpdateNGOWikiPage> {
  List<TextEditingController> _nameControllers = [TextEditingController()];
  List<TextEditingController> _designationControllers = [
    TextEditingController(),
  ];

  void _addMemberField() {
    setState(() {
      _nameControllers.add(TextEditingController());
      _designationControllers.add(TextEditingController());
    });
  }

  void _removeMemberField(int index) {
    if (_nameControllers.length > 1) {
      setState(() {
        _nameControllers.removeAt(index);
        _designationControllers.removeAt(index);
      });
    }
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
              buildLabel('Vision:'),
              buildField(),
              buildLabel('Mission:'),
              buildField(),
              buildLabel('Areas of Focus:'),
              buildField(),
              buildLabel('NGO Members (Name & Designation):'),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: _nameControllers.length,
                itemBuilder: (context, index) {
                  return Card(
                    color: Colors.white,
                    margin: EdgeInsets.symmetric(vertical: 6),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          TextField(
                            controller: _nameControllers[index],
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              labelText: 'Member Name',
                              labelStyle: TextStyle(color: Colors.white70),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.white,
                                  width: 2,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          TextField(
                            controller: _designationControllers[index],
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              labelText: 'Designation',
                              labelStyle: TextStyle(color: Colors.white70),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.white,
                                  width: 2,
                                ),
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: IconButton(
                              icon: Icon(Icons.delete, color: Colors.white),
                              onPressed: () => _removeMemberField(index),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: 10),
              ElevatedButton.icon(
                onPressed: _addMemberField,
                icon: Icon(Icons.add),
                label: Text("Add Member"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Color(0xFF002B5B),
                ),
              ),
              buildLabel('Contact Information'),
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
      minLines: 1,
      keyboardType: TextInputType.multiline,
      style: const TextStyle(color: Colors.black),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey[200],
        contentPadding: const EdgeInsets.symmetric(
          vertical: 14,
          horizontal: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
