import 'package:flutter/material.dart';
import 'package:ngobeacon/components/top_nav_bar.dart';
import 'package:ngobeacon/components/bottom_nav_bar.dart';

class CreateEventScreen extends StatefulWidget {
  @override
  _CreateEventScreenState createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for form fields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _venueController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _organizerController = TextEditingController();

  void _uploadEvent() {
    if (_formKey.currentState!.validate()) {
      // Handle form submission logic (e.g., send data to database)
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Event Uploaded Successfully!')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade900,
      appBar: TopNavBar(),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Create New Event",
                style: TextStyle(
                  color: Color(0xFFFAFAF0),
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              _buildTextField('Name of the Event', _nameController),
              _buildTextField('Venue', _venueController),
              _buildTextField('Time', _timeController),
              _buildTextField('Estimated Duration', _durationController),
              _buildTextField(
                'Contact Number',
                _contactController,
                keyboardType: TextInputType.phone,
              ),
              _buildTextField('Organizer Name', _organizerController),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: _uploadEvent,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFFAFAF0),
                    foregroundColor: Colors.blue.shade900,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    textStyle: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  child: Text('Upload Event'),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavBar(),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Color(0xFFFAFAF0),
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 5),
          TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            style: TextStyle(color: Colors.black),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey[200],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            validator: (value) => value!.isEmpty ? 'Please enter $label' : null,
          ),
        ],
      ),
    );
  }
}
