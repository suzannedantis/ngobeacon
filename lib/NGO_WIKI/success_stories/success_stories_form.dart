import 'package:flutter/material.dart';
import 'package:ngobeacon/components/bottom_nav_bar.dart';
import 'package:ngobeacon/components/top_nav_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';

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
    setState(() => _isLoading = true);

    try {
      // Log user info for debugging
      final user = _supabase.auth.currentUser;
      debugPrint('Current user ID: ${user?.id}');

      final response = await _supabase
          .from('success_stories')
          .select('*')
          .eq('wiki_id', widget.wikiId)
          .order('created_at', ascending: false);

      setState(() {
        _existingStories = List<Map<String, dynamic>>.from(response);
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Error loading stories: $e');
      setState(() => _isLoading = false);
      _showErrorSnackBar('Error loading stories. Please try again.');
    }
  }

  void _showErrorSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
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
      // First delete images from storage
      final story = _existingStories.firstWhere((s) => s['s_id'].toString() == storyId);
      final gallery = story['gallery'] as List?;

      if (gallery != null) {
        for (var imageUrl in gallery) {
          try {
            // Extract the path from the URL
            final uri = Uri.parse(imageUrl.toString());
            final pathSegments = uri.pathSegments;
            if (pathSegments.length >= 2) {
              final filePath = pathSegments.sublist(1).join('/');
              debugPrint('Attempting to delete: $filePath');
              await _supabase.storage
                  .from('success-stories') // Note hyphen instead of underscore
                  .remove([filePath]);
            }
          } catch (e) {
            debugPrint('Error deleting image: $e');
            // Continue with other images even if one fails
          }
        }
      }

      // Then delete the record
      await _supabase.from('success_stories').delete().eq('s_id', storyId);
      _showSuccessSnackBar('Story deleted successfully');
      _loadExistingStories();
    } catch (e) {
      debugPrint('Error deleting story: $e');
      _showErrorSnackBar('Error deleting story: $e');
    } finally {
      setState(() => _isDeleting = false);
    }
  }

  Future<List<String>> _processImages(List<XFile> images) async {
    List<String> imageUrls = [];

    for (var image in images) {
      try {
        if (image.path.startsWith('http')) {
          // Already uploaded image, just use the URL
          imageUrls.add(image.path);
        } else {
          // New image, upload it
          final file = File(image.path);
          final fileExt = image.path.split('.').last.toLowerCase();
          // Validate file extension
          if (!['jpg', 'jpeg', 'png', 'gif', 'webp'].contains(fileExt)) {
            debugPrint('Skipping invalid file type: $fileExt');
            continue; // Skip invalid file types
          }

          final fileName = '${DateTime.now().millisecondsSinceEpoch}_${imageUrls.length}.$fileExt';
          final filePath = '${widget.wikiId}/$fileName';

          debugPrint('Uploading to path: $filePath');

          // Ensure the user is authenticated before upload
          final user = _supabase.auth.currentUser;
          if (user == null) {
            debugPrint('No authenticated user found');
            throw Exception('Authentication required to upload images');
          }

          // Get file bytes for upload
          final fileBytes = await file.readAsBytes();

          await _supabase.storage
              .from('success-stories') // Note hyphen instead of underscore
              .uploadBinary(
            filePath,
            fileBytes,
            fileOptions: const FileOptions(
              cacheControl: '3600',
              upsert: true,
            ),
          );

          final imageUrl = _supabase.storage
              .from('success-stories')
              .getPublicUrl(filePath);

          debugPrint('Uploaded successfully to: $imageUrl');
          imageUrls.add(imageUrl);
        }
      } catch (e) {
        debugPrint('Error processing image: $e');
        // Continue with other images
      }
    }

    return imageUrls;
  }

  Future<void> _updateStory(EventCardData card, String storyId) async {
    if (card.descriptionController.text.trim().isEmpty) {
      _showErrorSnackBar('Please enter a description');
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final imageUrls = await _processImages(card.images);

      await _supabase.from('success_stories').update({
        'description': card.descriptionController.text.trim(),
        'gallery': imageUrls,
        'updated_at': DateTime.now().toIso8601String(),
      }).eq('s_id', storyId);

      _showSuccessSnackBar('Story updated successfully');
      _loadExistingStories();
    } catch (e) {
      debugPrint('Error updating story: $e');
      _showErrorSnackBar('Error updating story: $e');
    } finally {
      setState(() => _isSubmitting = false);
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
    // Validate input
    bool hasValidData = false;
    for (var card in _eventCards) {
      if (card.descriptionController.text.trim().isNotEmpty) {
        hasValidData = true;
        break;
      }
    }

    if (!hasValidData) {
      _showErrorSnackBar('Please enter at least one story with a description');
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final user = _supabase.auth.currentUser;
      if (user == null) {
        throw Exception('Authentication required to submit stories');
      }

      for (var card in _eventCards) {
        if (card.descriptionController.text.trim().isEmpty) continue;

        final imageUrls = await _processImages(card.images);

        await _supabase.from('success_stories').insert({
          'wiki_id': widget.wikiId,
          'description': card.descriptionController.text.trim(),
          'gallery': imageUrls,
          'user_id': user.id,
          'created_at': DateTime.now().toIso8601String(),
        });
      }

      _showSuccessSnackBar('Success stories submitted successfully!');
      setState(() {
        _eventCards.clear();
        _eventCards.add(EventCardData());
      });
      _loadExistingStories();
    } catch (e) {
      debugPrint('Submission error details: $e');
      _showErrorSnackBar('Error submitting form: $e');
    } finally {
      setState(() => _isSubmitting = false);
    }
  }

  void _showEditDialog(Map<String, dynamic> story) {
    final EventCardData card = EventCardData();
    card.descriptionController.text = story['description']?.toString() ?? '';

    // Create XFile objects from URLs
    card.images = (story['gallery'] as List?)
        ?.map((url) => XFile(url.toString()))
        .toList() ?? [];

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
                  _buildTextField("Description", card.descriptionController, maxLines: 5),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () async {
                      final images = await _picker.pickMultiImage();
                      if (images.isNotEmpty) {
                        setState(() {
                          card.images.addAll(images);
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[900],
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Add More Images'),
                  ),
                  const SizedBox(height: 10),
                  if (card.images.isNotEmpty)
                    SizedBox(
                      height: 120,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: card.images.map((image) => Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: image.path.startsWith('http')
                                    ? CachedNetworkImage(
                                  imageUrl: image.path,
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => Container(
                                    width: 100,
                                    height: 100,
                                    color: Colors.grey[300],
                                    child: const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  ),
                                  errorWidget: (context, url, error) => Container(
                                    width: 100,
                                    height: 100,
                                    color: Colors.grey[300],
                                    child: const Icon(Icons.error),
                                  ),
                                )
                                    : Image.file(
                                  File(image.path),
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Positioned(
                                top: 0,
                                right: 0,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.5),
                                    shape: BoxShape.circle,
                                  ),
                                  child: IconButton(
                                    icon: const Icon(Icons.close, size: 16, color: Colors.white),
                                    onPressed: () {
                                      setState(() {
                                        card.images.remove(image);
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )).toList(),
                      ),
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
                onPressed: _isSubmitting
                    ? null
                    : () async {
                  Navigator.pop(context);
                  await _updateStory(card, story['s_id'].toString());
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[900],
                  foregroundColor: Colors.white,
                ),
                child: _isSubmitting
                    ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
                    : const Text('Save'),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildExistingStories() {
    if (_isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: CircularProgressIndicator(color: Colors.white),
        ),
      );
    }

    if (_existingStories.isEmpty) {
      return const Card(
        color: Colors.white54,
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'No success stories yet',
            style: TextStyle(color: Colors.black87),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 12.0),
          child: Text(
            'Existing Success Stories',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ..._existingStories.map((story) {
          final firstLine = story['description']?.toString().split('\n').first ?? 'Untitled Story';
          final shortDescription = firstLine.length > 50
              ? '${firstLine.substring(0, 50)}...'
              : firstLine;

          return Card(
            color: Colors.white,
            margin: const EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 4,
            child: ExpansionTile(
              title: Text(
                shortDescription,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        story['description'] ?? '',
                        style: const TextStyle(fontSize: 15),
                      ),
                      const SizedBox(height: 16),
                      if ((story['gallery'] as List?)?.isNotEmpty ?? false)
                        SizedBox(
                          height: 120,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: (story['gallery'] as List)
                                .map((url) => Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: CachedNetworkImage(
                                  imageUrl: url.toString(),
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => Container(
                                    width: 100,
                                    height: 100,
                                    color: Colors.grey[300],
                                    child: const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  ),
                                  errorWidget: (context, url, error) => Container(
                                    width: 100,
                                    height: 100,
                                    color: Colors.grey[300],
                                    child: const Icon(Icons.error),
                                  ),
                                ),
                              ),
                            ))
                                .toList(),
                          ),
                        ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton.icon(
                            icon: const Icon(Icons.edit),
                            label: const Text('Edit'),
                            onPressed: () => _showEditDialog(story),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton.icon(
                            icon: _isDeleting
                                ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                                : const Icon(Icons.delete),
                            label: const Text('Delete'),
                            onPressed: _isDeleting
                                ? null
                                : () => _deleteStory(story['s_id'].toString()),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildExistingStories(),
              const SizedBox(height: 24),
              const Text(
                'Add New Success Stories',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
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
                      "Story ${index + 1}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    initiallyExpanded: index == 0, // First card is expanded by default
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
                              "Description",
                              card.descriptionController,
                              maxLines: 5,
                              hint: "Share your success story here...",
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton.icon(
                              onPressed: () async {
                                final images = await _picker.pickMultiImage();
                                if (images.isNotEmpty) {
                                  setState(() {
                                    card.images.addAll(images);
                                  });
                                }
                              },
                              icon: const Icon(Icons.photo_library),
                              label: const Text('Select Images'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue[900],
                                foregroundColor: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 16),
                            if (card.images.isNotEmpty)
                              SizedBox(
                                height: 120,
                                child: ListView(
                                  scrollDirection: Axis.horizontal,
                                  children: card.images.map((image) => Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: Stack(
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(8),
                                          child: Image.file(
                                            File(image.path),
                                            width: 100,
                                            height: 100,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        Positioned(
                                          top: 0,
                                          right: 0,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.black.withOpacity(0.5),
                                              shape: BoxShape.circle,
                                            ),
                                            child: IconButton(
                                              icon: const Icon(Icons.close, size: 16, color: Colors.white),
                                              onPressed: () {
                                                setState(() {
                                                  card.images.remove(image);
                                                });
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )).toList(),
                                ),
                              ),
                            const SizedBox(height: 10),
                            if (_eventCards.length > 1)
                              Align(
                                alignment: Alignment.centerRight,
                                child: ElevatedButton.icon(
                                  icon: const Icon(Icons.delete),
                                  label: const Text('Remove Story'),
                                  onPressed: () => _removeEventCard(index),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                    foregroundColor: Colors.white,
                                  ),
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
              Center(
                child: ElevatedButton.icon(
                  onPressed: _addEventCard,
                  icon: const Icon(Icons.add),
                  label: const Text("Add Another Story"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.blue[900],
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Center(
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.blue[900],
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  child: _isSubmitting
                      ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                      : const Text("Submit Stories"),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      String label,
      TextEditingController controller, {
        int maxLines = 1,
        String? hint,
      }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: controller,
            maxLines: maxLines,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey[100],
              hintText: hint,
              contentPadding: const EdgeInsets.all(12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.blue.shade900),
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