import 'package:flutter/material.dart';
import 'package:ngobeacon/components/bottom_nav_bar.dart';
import 'package:ngobeacon/components/top_nav_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class SuccessStoriesForm extends StatefulWidget {
  const SuccessStoriesForm({super.key});
  @override
  State<SuccessStoriesForm> createState() => _SuccessStoriesFormState();
}

class _SuccessStoriesFormState extends State<SuccessStoriesForm> {
  final ImagePicker _picker = ImagePicker();
  List<XFile>? _selectedImages;

  Future<void> pickImages() async {
    final List<XFile>? images = await _picker.pickMultiImage();
    if (images != null) {
      setState(() {
        _selectedImages = images;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopNavBar(),
      bottomNavigationBar: BottomNavBar(selectedIndex: 2),
      backgroundColor: Color(0xFF002B5B),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                buildTextField("Name of the Event"),
                buildTextField("Description"),
                Column(
                  children: [
                    ElevatedButton(
                      onPressed: pickImages,
                      child: Text('Select Images'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.blue[900],
                      ),
                    ),
                    if (_selectedImages != null)
                      Wrap(
                        spacing: 8,
                        children:
                            _selectedImages!.map((image) {
                              return Image.file(
                                File(image.path),
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              );
                            }).toList(),
                      ),
                  ],
                ),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.blue[900],
                  ),
                  child: Text("Submit"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTextField(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: 16, color: Colors.white)),
          SizedBox(height: 5),
          TextField(
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey[200],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
