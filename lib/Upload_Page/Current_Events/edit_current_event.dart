import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For date formatting
import 'package:ngobeacon/components/bottom_nav_bar.dart';

class EditEventPage extends StatefulWidget {
  final Map<String, dynamic> eventData;

  const EditEventPage({Key? key, required this.eventData}) : super(key: key);

  @override
  State<EditEventPage> createState() => _EditEventPageState();
}

class _EditEventPageState extends State<EditEventPage> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _locationController;
  late TextEditingController _dateController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.eventData['title']);
    _descriptionController = TextEditingController(text: widget.eventData['description']);
    _locationController = TextEditingController(text: widget.eventData['location']);
    _dateController = TextEditingController(text: widget.eventData['date']);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  void _saveChanges() {
    Navigator.pop(context, {
      'title': _titleController.text,
      'description': _descriptionController.text,
      'location': _locationController.text,
      'date': _dateController.text,
    });
  }

  Future<void> _pickDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.tryParse(_dateController.text) ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
      setState(() {
        _dateController.text = formattedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Event'),
        backgroundColor: Colors.white,
        foregroundColor: Color(0xFF002B5B),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildTextField('Title', _titleController),
            _buildTextField('Description', _descriptionController, maxLines: 3),
            _buildTextField('Location', _locationController),
            GestureDetector(
              onTap: _pickDate,
              child: AbsorbPointer(
                child: _buildTextField('Date', _dateController),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _saveChanges,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[900],
                foregroundColor: Colors.white,
              ),
              child: const Text('Save Changes'),
            ),
          ],
        ),
      ),
      backgroundColor: const Color(0xFF002B5B),
      bottomNavigationBar: BottomNavBar(),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        style: const TextStyle(color: Colors.black),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          labelText: label,
          labelStyle: const TextStyle(color: Colors.black87),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.grey),
          ),
        ),
      ),
    );
  }
}
