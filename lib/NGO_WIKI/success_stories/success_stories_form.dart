import 'package:flutter/material.dart';
import 'package:ngobeacon/components/bottom_nav_bar.dart';
import 'package:ngobeacon/components/top_nav_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';

class SuccessStoriesForm extends StatefulWidget {
  final String wikiId;
  const SuccessStoriesForm({super.key, required this.wikiId});

  @override
  State<SuccessStoriesForm> createState() => _SuccessStoriesFormState();
}

class _SuccessStoriesFormState extends State<SuccessStoriesForm> {
  final ImagePicker _picker = ImagePicker();
  final List<EventCardData> _eventCards = [EventCardData()];
  final SupabaseClient _supabase = Supabase.instance.client;
  bool _isSubmitting = false;
  bool _isLoading = true;
  bool _isDeleting = false;
  List<Map<String, dynamic>> _existingStories = [];

  @override
  void initState() {
    super.initState();
    _loadExistingStories();
  }

  Future<void> _loadExistingStories() async {
    try {
      final response = await _supabase
          .from('success_stories')
          .select('*')
          .eq('wiki_id', widget.wikiId);

      setState(() {
        _existingStories = List<Map<String, dynamic>>.from(response);
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading stories: $e')),
      );
    }
  }

  Future<void> _deleteStory(String storyId) async {
    bool confirmDelete = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Delete'),
        content: const Text('Are you sure you want to delete this success story?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    ) ?? false;

    if (!confirmDelete) return;

    setState(() => _isDeleting = true);

    try {
      await _supabase.from('success_stories').delete().eq('s_id', storyId);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Story deleted successfully')),
      );
      _loadExistingStories();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting story: $e')),
      );
    } finally {
      setState(() => _isDeleting = false);
    }
  }

  Future<void> _updateStory(EventCardData card, String storyId) async {
    try {
      List<String> imageUrls = [];
      for (var image in card.images) {
        if (image.path.startsWith('http')) {
          imageUrls.add(image.path);
        } else {
          final file = File(image.path);
          final fileExt = image.path.split('.').last;
          final fileName = '${DateTime.now().millisecondsSinceEpoch}.$fileExt';
          final filePath = 'success_stories_images/$fileName';

          await _supabase.storage
              .from('success_stories')
              .upload(filePath, file);

          final imageUrl = _supabase.storage
              .from('success_stories')
              .getPublicUrl(filePath);
          imageUrls.add(imageUrl);
        }
      }

      await _supabase.from('success_stories').update({
        'description': card.descriptionController.text,
        'gallery': imageUrls,
      }).eq('s_id', storyId);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Story updated successfully')),
      );
      _loadExistingStories();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating story: $e')),
      );
    }
  }

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

  Future<void> _submitForm() async {
    setState(() {
      _isSubmitting = true;
    });

    try {
      for (var card in _eventCards) {
        if (card.descriptionController.text.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please enter a description')),
          );
          continue;
        }

        List<String> imageUrls = [];
        for (var image in card.images) {
          final file = File(image.path);
          final fileExt = image.path.split('.').last;
          final fileName = '${DateTime.now().millisecondsSinceEpoch}.$fileExt';
          final filePath = 'success_stories_images/$fileName';

          await _supabase.storage
              .from('success_stories')
              .upload(filePath, file);

          final imageUrl = _supabase.storage
              .from('success_stories')
              .getPublicUrl(filePath);
          imageUrls.add(imageUrl);
        }

        await _supabase.from('success_stories').insert({
          'wiki_id': widget.wikiId,
          'description': card.descriptionController.text,
          'gallery': imageUrls,
        });
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Success stories submitted successfully!')),
      );
      setState(() {
        _eventCards.clear();
        _eventCards.add(EventCardData());
      });
      _loadExistingStories();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error submitting form: $e')),
      );
      debugPrint('Submission error details: $e');
    } finally {
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  void _showEditDialog(Map<String, dynamic> story) {
    final card = EventCardData()
      ..descriptionController.text = story['description']?.toString() ?? ''
      ..images = (story['gallery'] as List?)?.map((url) => XFile(url.toString())).toList() ?? [];

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Edit Success Story'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildTextField("Description", card.descriptionController),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () async {
                      final images = await _picker.pickMultiImage();
                      setState(() {
                        card.images.addAll(images);
                      });
                                        },
                    child: const Text('Add More Images'),
                  ),
                  if (card.images.isNotEmpty)
                    Wrap(
                      spacing: 8,
                      children: card.images.map((image) => Stack(
                        children: [
                          image.path.startsWith('http')
                              ? Image.network(image.path, width: 80, height: 80)
                              : Image.file(File(image.path), width: 80, height: 80),
                          Positioned(
                            top: 0,
                            right: 0,
                            child: IconButton(
                              icon: const Icon(Icons.close, size: 16),
                              onPressed: () {
                                setState(() {
                                  card.images.remove(image);
                                });
                              },
                            ),
                          ),
                        ],
                      )).toList(),
                    ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () async {
                  Navigator.pop(context);
                  await _updateStory(card, story['s_id'].toString());
                },
                child: const Text('Save'),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildExistingStories() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_existingStories.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(16.0),
        child: Text(
          'No success stories yet',
          style: TextStyle(color: Colors.white),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            'Existing Success Stories',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ..._existingStories.map((story) {
          return Card(
            color: Colors.white,
            margin: const EdgeInsets.only(bottom: 16),
            child: ExpansionTile(
              title: Text(
                story['description']?.toString().split('\n').first ?? 'Untitled Story',
                style: const TextStyle(fontWeight: FontWeight.bold),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(story['description'] ?? ''),
                      const SizedBox(height: 16),
                      if ((story['gallery'] as List?)?.isNotEmpty ?? false)
                        Wrap(
                          spacing: 8,
                          children: (story['gallery'] as List)
                              .map((url) => Image.network(
                            url.toString(),
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ))
                              .toList(),
                        ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () => _showEditDialog(story),
                          ),
                          IconButton(
                            icon: _isDeleting
                                ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                                : const Icon(Icons.delete, color: Colors.red),
                            onPressed: _isDeleting
                                ? null
                                : () => _deleteStory(story['s_id'].toString()),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopNavBar(),
      bottomNavigationBar: BottomNavBar(selectedIndex: 2),
      backgroundColor: Colors.blue.shade900,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _buildExistingStories(),
              const SizedBox(height: 24),
              const Text(
                'Add New Success Stories',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
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
                                setState(() {
                                  card.images = images;
                                });
                                                            },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue[900],
                                foregroundColor: Colors.white,
                              ),
                              child: const Text('Select Images'),
                            ),
                            const SizedBox(height: 10),
                            if (card.images.isNotEmpty)
                              Wrap(
                                spacing: 8,
                                children: card.images.map((image) => Stack(
                                  children: [
                                    Image.file(
                                      File(image.path),
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.cover,
                                    ),
                                    Positioned(
                                      top: 0,
                                      right: 0,
                                      child: IconButton(
                                        icon: const Icon(Icons.close, size: 16),
                                        onPressed: () {
                                          setState(() {
                                            card.images.remove(image);
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                )).toList(),
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
              }).toList(),
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
                onPressed: _isSubmitting ? null : _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.blue[900],
                ),
                child: _isSubmitting
                    ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
                    : const Text("Submit"),
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