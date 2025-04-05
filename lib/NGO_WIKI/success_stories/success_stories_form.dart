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
  List<EventCardData> _eventCards = [EventCardData()];

  void _addEventCard() {
    setState(() {
      _eventCards.add(EventCardData());
    });
  }

  void _removeEventCard(int index) {
    setState(() {
      if (_eventCards.length > 1) _eventCards.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopNavBar(),
      bottomNavigationBar: BottomNavBar(selectedIndex: 2),
      backgroundColor: Colors.blue.shade900, // translucent grey
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              ..._eventCards.asMap().entries.map((entry) {
                int index = entry.key;
                EventCardData card = entry.value;

                return Card(
                  color: Colors.white,
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  margin: const EdgeInsets.only(bottom: 16),
                  child: ExpansionTile(
                    title: Text(
                      "Event ${index + 1}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    trailing: Icon(
                      card.isExpanded
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      color: Colors.black,
                    ),
                    onExpansionChanged: (bool expanded) {
                      setState(() {
                        card.isExpanded = expanded;
                      });
                    },
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildTextField(
                              "Name of the Event",
                              card.nameController,
                            ),
                            _buildTextField(
                              "Description",
                              card.descriptionController,
                            ),
                            const SizedBox(height: 10),
                            ElevatedButton(
                              onPressed: () async {
                                final images = await _picker.pickMultiImage();
                                if (images != null) {
                                  setState(() {
                                    card.images = images;
                                  });
                                }
                              },
                              child: const Text('Select Images'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue[900],
                                foregroundColor: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 10),
                            if (card.images.isNotEmpty)
                              Wrap(
                                spacing: 8,
                                children:
                                    card.images
                                        .map(
                                          (image) => Image.file(
                                            File(image.path),
                                            width: 100,
                                            height: 100,
                                            fit: BoxFit.cover,
                                          ),
                                        )
                                        .toList(),
                              ),
                            const SizedBox(height: 10),
                            Align(
                              alignment: Alignment.centerRight,
                              child: IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () => _removeEventCard(index),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }),
              const SizedBox(height: 10),
              ElevatedButton.icon(
                onPressed: _addEventCard,
                icon: const Icon(Icons.add),
                label: const Text("Add Another Event"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.blue[900],
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // handle submission
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.blue[900],
                ),
                child: const Text("Submit"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 5),
          TextField(
            controller: controller,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey[100],
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

class EventCardData {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  List<XFile> images = [];
  bool isExpanded = false;
}
